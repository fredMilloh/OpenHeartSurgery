//
//  DoubleExt.swift
//  CountOnMe
//
//  Created by fred on 14/09/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation

extension Double {

    func withDecimal() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = "."
        formatter.groupingSeparator = " "
        let number = NSNumber(value: self)
        let formattedValue = formatter.string(from: number)!
        return formattedValue
    }
}
