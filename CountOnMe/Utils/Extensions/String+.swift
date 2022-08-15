//
//  String+.swift
//  CountOnMe
//
//  Created by fred on 20/09/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation

extension String {
    func withoutSeparators() -> String {
        self.components(separatedBy: CharacterSet.whitespaces).joined()
    }
}
