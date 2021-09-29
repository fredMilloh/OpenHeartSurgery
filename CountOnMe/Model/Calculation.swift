//
//  Calculation.swift
//  CountOnMe
//
//  Created by fred on 06/09/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation

protocol CalculDelegate: AnyObject {
    func expression(with element: String)
    func presentAlert(message alertError: AlertError)
}

class Calculation {

    weak var delegate: CalculDelegate?

    init(delegate: CalculDelegate) {
        self.delegate = delegate
    }

    var divideError: Bool = false
    var lastResult: String = ""

    var elementForCalculation: String = "" {
        didSet {
            delegate?.expression(with: elementForCalculation)
        }
    }

    var warning: AlertError = .elementNotComplete {
        didSet {
            delegate?.presentAlert(message: warning)
        }
    }

    /// Separates the elements of elementForCalculation in an array
    private var elements: [String] {
        elementForCalculation.split(separator: " ").map { "\($0)" }
    }

    // MARK: - Error check computed variables

    private var expressionHaveEnoughElement: Bool {
        elements.count >= 3
    }

    /// equal sign has one occurrence
    private var expressionHaveResult: Bool {
        elements.firstIndex(of: Operand.equal) != nil
    }

    private var expressionIsError: Bool {
        elementForCalculation == "Error"
    }

    private var expressionIsZero: Bool {
        elementForCalculation == "0"
    }

    /// operation must end with a number before pressing equal
    private var lastElementIsNumber: Bool {
        elements.last != Operand.plus
            && elements.last != Operand.minus
            && elements.last != Operand.multiply
            && elements.last != Operand.divide
    }

    /// Avoids starting or repeating an operand
    private var elementIsAnOperandOrNil: Bool {
        elements.last == Operand.plus
            || elements.last == Operand.minus
            || elements.last == Operand.divide
            || elements.last == Operand.multiply
            || elements == []
    }

    private var lastElementIsZero: Bool {
        elements.last == "0"

    }
    /// Avoids adding an operator when the number ends with a dot
    private var elementIsCorrect: Bool {
        elementForCalculation.last != "."
    }

    private var dotIsAlreadyPresent: Bool {
        elements.last?.firstIndex(of: ".") != nil
    }

    private var havePreviousResult: Bool {
        lastResult != ""
    }

    // MARK: - Methods

    /// Resets to zero
    func tappedCancel() {
        lastResult = ""
        elementForCalculation = "0"
    }

    func tappedNumber(_ digit: String) {
        var number = digit

        /// Remove zero from the array
        if expressionIsZero || expressionIsError {
            elementForCalculation = ""
            divideError = false
        }

        /// starts new expression with new number
        if expressionHaveResult && elements.last == lastResult {
            elementForCalculation = ""
            lastResult = ""
        }

        /// Avoid adding a second point after a zero point
        if digit != "." && lastElementIsZero {
            number = "." + digit
        }

        /// allows to start a decimal number with a dot
        if digit == "." && elementIsAnOperandOrNil {
            number = "0."
        }

        /// Avoid putting two dots in a number
        if digit == "." && dotIsAlreadyPresent {
            number = ""
            warning = .haveADot
        }

        elementForCalculation.append(number)

        #if DEBUG
        print("elementForCalculation ==> \(elementForCalculation)")
        print("[elements] ==> \(elements)")
        #endif
    }

    func tappedOperator(_ operand: String) {

        /// Chain an operation with the last result
        if havePreviousResult && expressionHaveResult {
            elementForCalculation = lastResult
        }

        if expressionIsError {
            elementForCalculation = "0"
        }
        /// if start by operator then no action
        if elementIsAnOperandOrNil || expressionIsZero { return }

        guard elementIsCorrect else { warning = .elementNotComplete
            return
        }
        elementForCalculation.append(" \(operand) ")

        #if DEBUG
        print("elementForCalculation ==> \(elementForCalculation)")
        print("[elements] ==> \(elements)")
        #endif
    }

    func tappedEqual() {

        guard lastElementIsNumber else {
            warning = .correctExpressionRequired
            return
        }
        guard expressionHaveEnoughElement else {
            warning = .expressionNotComplete
            return
        }
        guard elementIsCorrect else {
            warning = .elementNotComplete
            return
        }

        let operationsToReduce = setOperationsToReduce()

        /// Display in case of division by zero
        if divideError {
            elementForCalculation = ""
            elementForCalculation.append("Error")
            lastResult = ""
        } else {
            elementForCalculation.append(" = \(operationsToReduce.first!)")
            guard let currentResult = operationsToReduce.first else { return }

            /// Removes thousands separators
            lastResult = currentResult.withoutSeparators()

            #if DEBUG
            print("elementForCalculation ==> \(elementForCalculation)")
            print("[elements] ==> \(elements)")
            #endif
        }
    }

    // MARK: - Operator priority

    private func priorityOperations() -> [String] {
        var operationsToReduce = elements

        while operationsToReduce.contains(Operand.divide) || operationsToReduce.contains(Operand.multiply) {
            /// Find the first multiply or divide operator in the array elements
            /// Condition to check if the given predicate is satisfied
            if let index = operationsToReduce.firstIndex(where: { ($0 == Operand.divide
                                                                    || $0 == Operand.multiply) }) {
                let left = Double(operationsToReduce[index - 1].withoutSeparators())!
                let operand = operationsToReduce[index]
                let right = Double(operationsToReduce[index + 1].withoutSeparators())!
                var result: Double = 0
                switch operand {
                case Operand.multiply: result = left * right
                case Operand.divide:
                    if right == 0 {
                        result = 0
                        divideError = true
                    } else {
                        result = left / right
                    }
                default: break
                }
                operationsToReduce[index - 1] = "\(result.withDecimal())"
                operationsToReduce.remove(at: index + 1)
                operationsToReduce.remove(at: index)
            }
        }
        return operationsToReduce
    }

    private func setOperationsToReduce() -> [String] {
        /// recovery of the array after priority operations
        var operationsToReduce = priorityOperations()

        while operationsToReduce.count > 1 {
            let left = Double(operationsToReduce[0].withoutSeparators())!
            let operand = operationsToReduce[1]
            let right = Double(operationsToReduce[2].withoutSeparators())!

            var result: Double = 0
            switch operand {
            case Operand.plus: result = left + right
            case Operand.minus: result = left - right
            default: break
            }
            /// New array without the first three elements
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            /// Places the result, with two decimal, at index 0
            operationsToReduce.insert("\(result.withDecimal())", at: 0)
        }
        return operationsToReduce
    }
}
