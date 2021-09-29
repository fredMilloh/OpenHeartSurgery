//
//  CalculationTestCase.swift
//  CountOnMeTests
//
//  Created by fred on 08/09/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class CalculationTestCase: XCTestCase {

    var sut: Calculation!
    var errorMessage: String!

    override func setUp() {
        super.setUp()
        sut = Calculation(delegate: self)
        errorMessage = ""
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - numbers

    func test_when_user_enters_two_number_then_elementForCalculation_has_two_digit() {
        var digit = "5"
        sut.tappedNumber(digit)
        digit = "7"
        sut.tappedNumber(digit)
        XCTAssertEqual(sut.elementForCalculation, "57")
    }

    func test_if_element_end_by_dot_user_can_not_enter_an_operand() {
        sut.elementForCalculation = "5."
        sut.tappedOperator("-")
        XCTAssertEqual(sut?.warning, AlertError.elementNotComplete)
        XCTAssertFalse(sut.elementForCalculation == "5. -")
    }

    func test_if_expression_has_result_when_user_enter_number_then_new_expression_starts_with_number() {
        sut.elementForCalculation = "12.5 + 1.5"
        sut.tappedEqual()
        sut.tappedNumber("9")
        XCTAssertEqual(sut.lastResult, "")
        XCTAssertEqual(sut.elementForCalculation, "9")
    }

    func test_when_last_result_is_used_for_new_calcul_then_thousand_separators_disappear() {
        sut.elementForCalculation = "56432 x 89765"
        sut.tappedEqual()
        sut.tappedOperator("+")
        XCTAssertEqual(sut.lastResult, "5065618480")
    }

    func test_if_expression_is_error_or_zero_or_empty_then_divideError_becomes_false() {
        sut.elementForCalculation = "Error"
        sut.tappedNumber("6")
        XCTAssertEqual(sut.divideError, false)
    }

    // MARK: - dot

    func test_when_user_enters_dot_after_operand_then_element_start_by_zeroDot() {
        sut.elementForCalculation = "78 - "
        sut.tappedNumber(".")
        XCTAssertEqual(sut.elementForCalculation, "78 - 0.")
    }

    func test_when_user_starts_with_dot_then_expression_becomes_zeroDot() {
        sut.elementForCalculation = "0.5 + 5 x 12"
        sut.tappedEqual()
        XCTAssertEqual(sut.elementForCalculation, "0.5 + 5 x 12 = 60.5")
        sut.tappedNumber(".")
        XCTAssertEqual(sut.lastResult, "")
        XCTAssertEqual(sut.elementForCalculation, "0.")
    }

    func test_when_user_enters_number_after_zero_and_multiplier_then_element_becomes_zeroDot() {
        sut.elementForCalculation = "106 x 0"
        sut.tappedNumber("2")
        XCTAssertEqual(sut.elementForCalculation, "106 x 0.2")
    }

    // MARK: - operator

    func test_when_last_element_is_operand_if_user_press_operand_nothing_happens() {
        sut.elementForCalculation = "0.5 x "
        sut.tappedOperator("+")
        XCTAssertEqual(sut.elementForCalculation, "0.5 x ")
    }

    func test_if_there_has_result_and_user_press_operand_then_expression_becomes_result_with_operand() {
        sut.elementForCalculation = "0.7 x 0.2"
        sut.tappedEqual()
        sut.tappedOperator("-")
        XCTAssertEqual(sut.lastResult, "0.14")
        XCTAssertEqual(sut.elementForCalculation, "0.14 - ")
    }

    func test_if_expression_is_error_when_user_tap_operand_then_expression_becomes_zero() {
        sut.elementForCalculation = "Error"
        sut.tappedOperator("x")
        XCTAssertEqual(sut.elementForCalculation, "0")
    }

    // MARK: - operations

    func test_when_user_adds_two_numbers_then_equal_button_gives_good_result() {
        sut.elementForCalculation = "67 + 9"
        sut.tappedEqual()
        XCTAssertEqual(sut.elementForCalculation, "67 + 9 = 76")
    }

    func test_when_user_multiplier_decimals_numbers_then_result_has_two_decimals() {
        sut.elementForCalculation = "0.5556 x 8.789"
        sut.tappedEqual()
        XCTAssertEqual(sut.elementForCalculation, "0.5556 x 8.789 = 4.88")
    }

    func test_when_user_substracts_two_numbers_result_can_be_negative() {
        sut.elementForCalculation = "3.3 - 7.7"
        sut.tappedEqual()
        XCTAssertEqual(sut.elementForCalculation, "3.3 - 7.7 = -4.4")
    }

    func test_when_user_divides_two_numbers_result_can_be_decimal() {
        sut.elementForCalculation = "7 ÷ 3"
        sut.tappedEqual()
        XCTAssertTrue(sut.elementForCalculation == "7 ÷ 3 = 2.33")
    }

    func test_when_chained_operation_then_operator_priority_applies() {
        sut.elementForCalculation = "2 + 5 x 10 - 50 ÷ 2"
        sut.tappedEqual()
        XCTAssertEqual(sut.elementForCalculation, "2 + 5 x 10 - 50 ÷ 2 = 27")
    }

    // MARK: - errors

    func test_when_number_ends_by_dot_user_can_not_press_operand() {
        sut.elementForCalculation = "4."
        sut.tappedOperator("x")
        XCTAssertEqual(sut.warning, AlertError.elementNotComplete)
    }

    func test_when_number_ends_by_dot_user_can_not_press_equal() {
        sut.elementForCalculation = "4.1 ÷ 2."
        sut.tappedEqual()
        XCTAssertEqual(sut.warning, AlertError.elementNotComplete)
    }

    func test_when_expression_not_complete_and_user_enters_equal_warning_appears() {
        sut.elementForCalculation = "6 x "
        sut.tappedEqual()
        XCTAssertEqual(sut.warning, AlertError.correctExpressionRequired)
    }

    func test_when_expression_have_only_one_element_and_user_enters_equal_then_warning_appears() {
        sut.elementForCalculation = "21"
        sut.tappedEqual()
        XCTAssertEqual(sut.warning, AlertError.expressionNotComplete)
    }

    func test_user_can_not_enters_two_dot() {
        sut.elementForCalculation = "1.5"
        sut.tappedNumber(".")
        XCTAssertEqual(sut.elementForCalculation, "1.5")
        XCTAssertEqual(sut.warning, AlertError.haveADot)
    }

    func testGivenOperationDivideWithZeroWhenUserPressEqualThenDisplayShowsError() {
        sut.elementForCalculation = "3 ÷ 0"
        sut.tappedEqual()
        XCTAssertEqual(sut.elementForCalculation, "Error")
    }
}

extension CalculationTestCase: CalculDelegate {

    func expression(with element: String) {
        print("something")
    }

    func presentAlert(message alertError: AlertError) {
        errorMessage = "One element is missing"
    }
}
