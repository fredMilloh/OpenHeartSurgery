//
//  Enums.swift
//  CountOnMe
//
//  Created by fred on 06/09/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation

enum AlertError: String {
    case expressionNotComplete = "One element is missing"
    case correctExpressionRequired = "Enter a correct expression"
    case haveADot = "There is already a dot"
    case elementNotComplete = "The item is not complete"
}
