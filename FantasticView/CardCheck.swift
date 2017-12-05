//
//  CardCheck.swift
//  Demo_app_swift
//
//  Created by Mark Cardamis on 3/11/17.
//  Copyright © 2017 PayDock. All rights reserved.
//

import Foundation

enum CardType: String {
    case Unknown, Amex, Visa, MasterCard, Diners, UnionPay
    
    
    static let allCards = [Amex, Visa, MasterCard, Diners, UnionPay]
    
    var regex : String {
        switch self {
        case .Amex:
            return "^3[47]\\d*"
        case .Visa:
            return "^4\\d*"
        case .MasterCard:
            return "^(222[1-9]|22[3-9]|2[3-6]|27[0-1]|2720|5[1-5])\\d*"
        case .Diners:
            return "^(30[0-5]|309|36|3[8-9])\\d*"
        case .UnionPay:
            return "^62\\d*"
        default:
            return ""
        }
    }
}

func matchesRegex(regex: String!, text: String!) -> Bool {
    do {
        let regex = try NSRegularExpression(pattern: regex, options: [.caseInsensitive])
        let nsString = text as NSString
        let match = regex.firstMatch(in: text, options: [], range: NSMakeRange(0, nsString.length))
        return (match != nil)
    } catch {
        return false
    }
}


func luhnCheck(cardNumber: String) -> Bool {
    var sum = 0
    let reversedCharacters = cardNumber.reversed().map { String($0) }
    for (idx, element) in reversedCharacters.enumerated() {
        guard let digit = Int(element) else { return false }
        switch ((idx % 2 == 1), digit) {
        case (true, 9): sum += 9
        case (true, 0...8): sum += (digit * 2) % 9
        default: sum += digit
        }
    }
    return sum % 10 == 0
}


func checkCardNumber(input: String) -> (type: CardType, formatted: String, valid: Bool) {
    // Get only numbers from the input string
    //let numberOnly = input.stringByReplacingOccurrencesOfString("[^0-9]", withString: "", options: .RegularExpressionSearch)
    let numberOnly = input
    var type: CardType = .Unknown
    var formatted = ""
    var valid = false
    
    // detect card type
    for card in CardType.allCards {
        if (matchesRegex(regex: card.regex, text: numberOnly)) {
            type = card
            break
        }
    }

    // check validity
    if (type == .Amex && numberOnly.count == 15) {
        valid = luhnCheck(cardNumber: numberOnly)
    } else if (numberOnly.count == 16) {
        valid = luhnCheck(cardNumber: numberOnly)
    }
    
    
    // format
    var formatted4 = ""
    for character in numberOnly {
        if formatted4.count == 4 {
            formatted += formatted4 + " "
            formatted4 = ""
        }
        formatted4.append(character)
    }
    
    formatted += formatted4 // the rest
    
    // return the tuple
    return (type, formatted, valid)
}
