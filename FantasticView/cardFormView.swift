//
//  cardFormViewController.swift
//  FantasticView
//
//  Created by Mark Cardamis on 5/12/17.
//  Copyright © 2017 Mark Cardamis. All rights reserved.
//

import UIKit

class cardFormView: UIView, UITextFieldDelegate{
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var cardSchemeImage: UIImageView!
    @IBOutlet weak var cardNumberField: UITextField!
    @IBOutlet weak var cardHolderNameField: UITextField!
    @IBOutlet weak var expirationDateField: UITextField!
    @IBOutlet weak var ccvField: UITextField!
    @IBOutlet weak var lblVCardH: UILabel!
    @IBOutlet weak var lblVNo: UILabel!
    @IBOutlet weak var lblVdate: UILabel!
    @IBOutlet weak var lblVccv: UILabel!
    
    var autoInsertDateSlash = true
    var mCardType: CardType = .Unknown
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("cardForm", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        cardNumberField.delegate = self
        expirationDateField.delegate = self
        ccvField.delegate = self
    }
    
    @IBAction func cardSubmitPressed(_ sender: Any) {
        //getToken()
    }
    
    @IBAction func cardNumberChanged(_ sender: UITextField) {
        let (cardType, _, cardValid) = checkCardNumber(input: cardNumberField.text!)
        mCardType = cardType
        switch cardType {
        case .Amex:
            cardSchemeImage.image = UIImage(named: "ic_amex")
            break
        case .Visa:
            cardSchemeImage.image = UIImage(named: "ic_visa")
            break
        case .MasterCard:
            cardSchemeImage.image = UIImage(named: "ic_mastercard")
            break
        case .Diners:
            cardSchemeImage.image = UIImage(named: "ic_diners")
            break
        case .UnionPay:
            cardSchemeImage.image = UIImage(named: "ic_cup")
            break
        default:
            cardSchemeImage.image = UIImage(named: "ic_default")
            break
        }
        
        if (cardValid) {
            self.cardHolderNameField.becomeFirstResponder()
        }
    }
    
    @IBAction func DateChanged(_ sender: UITextField) {
        var nsText = expirationDateField.text!
        
        if ((nsText.count <= 2) && (nsText.contains("/"))) {
            nsText = nsText.replacingOccurrences(of: String("/"), with: "")
            nsText = nsText.replacingOccurrences(of: String("0"), with: "")
            nsText.insert("0", at: nsText.index(nsText.startIndex, offsetBy: 0))
            expirationDateField.text = nsText
        }
        if ((nsText.count >= 2) && (nsText.count < 5) && (!nsText.contains("/")) && autoInsertDateSlash) {
            nsText.insert("/", at: nsText.index(nsText.startIndex, offsetBy: 2))
            expirationDateField.text = nsText
        }
        
        if (nsText.count == 5) {
            let (_, _, validDateNumber) = checkDate(input: nsText as String)
            if (validDateNumber) {
                self.ccvField.becomeFirstResponder()
            }
        }
    }
    
    let allowedDateCharacters = "0123456789/"
    let allowedCardCharacters = "0123456789"
    
    func textField(_ textFieldToChange: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textFieldToChange == expirationDateField {
            let nsText = textFieldToChange.text!
            let startingLength = textFieldToChange.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace = range.length
            let newLength = startingLength + lengthToAdd - lengthToReplace
            if (newLength > 5) {
                return false
            }
            
            if (lengthToReplace > 0) {
                autoInsertDateSlash = false
            }
            
            if (lengthToAdd > 0) {
                autoInsertDateSlash = true
                if ((nsText.contains("/")) && ( string == "/")) {
                    return false
                }
                
                if (nsText.contains("/")) {
                    guard let index = nsText.index(of: "/") else { return false }
                    let mentionPosition = nsText.distance(from: nsText.startIndex, to: index)
                    if  ((range.location <= 2) && (mentionPosition >= 2)) {
                        return false
                    }
                }
                let cs = CharacterSet(charactersIn: allowedDateCharacters)
                let filtered: String = (string.components(separatedBy: cs) as NSArray).componentsJoined(by: "")
                if (string == filtered) {
                    return false
                }
                return true
            }
        }
        
        if textFieldToChange == cardNumberField {
            let startingLength = textFieldToChange.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace = range.length
            let newLength = startingLength + lengthToAdd - lengthToReplace
            if (newLength > 16){
                return false
            }
            
            if (lengthToAdd > 0) {
                let cs = CharacterSet(charactersIn: allowedCardCharacters)
                let filtered: String = (string.components(separatedBy: cs) as NSArray).componentsJoined(by: "")
                if (string == filtered) {
                    return false
                }
            }
            return true
        }
        
        if textFieldToChange == ccvField {
            let startingLength = textFieldToChange.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace = range.length
            let newLength = startingLength + lengthToAdd - lengthToReplace
            if (newLength > 4) {
                return false
            } else if ((mCardType != CardType.Amex) && (newLength > 3)) {
                return false
            }
            if (lengthToAdd > 0) {
                let cs = CharacterSet(charactersIn: allowedCardCharacters)
                let filtered: String = (string.components(separatedBy: cs) as NSArray).componentsJoined(by: "")
                if (string == filtered) {
                    return false
                }
            }
            return true
        }
        return true
    }
    
    func getToken (publicKey: String, gatewayId: String, completion: @escaping ((String) -> Void)) {
        clearErrors()
        var valid = true

        let (_, _, validCardNumber) = checkCardNumber(input: cardNumberField.text!)
        let (monthString, yearString, validDateNumber) = checkDate(input: expirationDateField.text!)
        
        if (cardHolderNameField.text == "") {
            valid = false
            lblVCardH.text="Name is required";
        }
        
        if (validCardNumber == false) {
            valid = false
            lblVNo.text="Card number invalid";
        }
        if (validDateNumber == false) {
            valid = false
            lblVdate.text="Expiration error";
        }
        
        if (((mCardType == CardType.Amex) && (ccvField.text!.count != 4)) ||
        ((mCardType != CardType.Amex) && (ccvField.text!.count != 3))) {
            valid = false
            lblVccv.text="CCV error";
        }
        
        if(valid) {
            PayDock.setSecretKey(key: "")
            PayDock.setPublicKey(key: publicKey)
            PayDock.shared.isSandbox = true
            
            let address = Address(line1: "one", line2: "two", city: "city", postcode: "1234", state: "state", country: "AU")
            let card = Card(gatewayId: gatewayId,
            name: cardHolderNameField.text!,
            number: cardNumberField.text!,
            expireMonth: monthString,
            expireYear: yearString,
            ccv: ccvField.text,
            address: address)
            let paymentSource = PaymentSource.card(value: card)
            let customerRequest = CustomerRequest(firstName: "Test_first_name",
            lastName: "Test_last_name",
            email: "Test@test.com",
            reference: "customer Refrence",
            phone: nil,
            paymentSource: paymentSource)
            
            let tokenRequest = TokenRequest(customer: customerRequest,
            address: address, paymentSource: paymentSource)
            
            PayDock.shared.create(token: tokenRequest) {
                (token) in
                do {
                    let token: String = try token()
                    print(token)
                    completion(token)
                } catch let error {
                    debugPrint(error)
                    completion(error.localizedDescription)
                }
            }
        }
    }
    
    func clearErrors()
    {
        lblVCardH.text = ""
        lblVNo.text = ""
        lblVdate.text = ""
        lblVccv.text = ""
    }
}
    

