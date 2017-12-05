//
//  DateChecker.swift
//  Demo_app_swift
//
//  Created by Mark Cardamis on 3/11/17.
//  Copyright © 2017 PayDock. All rights reserved.
//

import Foundation



func checkDate(input: String) -> (monthString: String, yearString: String, valid: Bool) {
    
    if (input.contains("/") && (input.count == 5))
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yy"
        var someDate = dateFormatter.date(from: input)
        if (someDate == nil){
            someDate = dateFormatter.date(from: "01/01")
        }
        
        let today = Date()
        
        var valid = false
        var dateArr = input.split{$0 == "/"}.map(String.init)
        let monthString: String = dateArr[0]
        let yearString: String? = dateArr.count > 1 ? dateArr[1] : "01"
        
        if someDate! > today {
            valid = true
            return (monthString, yearString!, valid)
        } else {
            return (monthString, yearString!, valid)
        }
    }
    
    return ("01","01", false)

}
