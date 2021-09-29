//
//  CalculateController.swift
//  CountOnMeTests
//
//  Created by fred on 16/09/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class CalculateControllerTests: XCTestCase {

    var controller: CalculateController!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "CalculateController", bundle: Bundle.main)
        controller = storyboard.instantiateInitialViewController() as? CalculateController
        _ = controller.view
    }

    override func tearDownWithError() throws {
        super.tearDown()
        controller = nil
    }

    func test_numberButton_becomes_selected_when_user_tap_on() {
        guard let button = controller.numberButtons else { return }
        controller.tappedNumberButton(button[5])
        XCTAssertEqual(controller.numberButtons[5].state, .selected)
        XCTAssertEqual(controller.numberButtons[5].titleColor(for: .selected), .systemBlue)
    }

    func test_operatorButton_becomes_selected_when_user_tap_on() {
        guard let operatorButton = controller.otherButtons else { return }
        controller.tappedOperatorButtons(operatorButton[2])
        XCTAssertEqual(controller.otherButtons[2].state, .selected)
        XCTAssertEqual(controller.otherButtons[2].backgroundColor, .white)
    }

    func test_cancelButton_becomes_selected_when_user_tap_on() {
        guard let cancelButton = controller.numberButtons else { return }
        controller.tappedCancelButton(cancelButton[11])
        XCTAssertEqual(controller.numberButtons[11].state, .selected)
    }

    func test_equalButton_becomes_selected_when_user_tap_on() {
        guard let equalButton = controller.otherButtons else { return }
        controller.tappedEqualButton(equalButton[4])
        XCTAssertEqual(controller.otherButtons[4].state, .selected)
    }

}
