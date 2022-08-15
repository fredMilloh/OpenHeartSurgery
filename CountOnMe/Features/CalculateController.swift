//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class CalculateController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!
    @IBOutlet var otherButtons: [UIButton]!

    lazy var calculation = Calculation(delegate: self)

    // MARK: - View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNumberButton()
        setupOtherButton()
    }

    // MARK: - View actions

    @IBAction func tappedCancelButton(_ sender: UIButton) {
        calculation.tappedCancel()
        selectedNumberButton(sender)
    }

    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let digit = sender.title(for: .normal) else { return }
        calculation.tappedNumber(digit)
        selectedNumberButton(sender)
    }

    @IBAction func tappedOperatorButtons(_ sender: UIButton) {
        guard let operant = sender.title(for: .normal) else { return }
        calculation.tappedOperator(operant)
        selectedOtherButton(sender)
    }

    @IBAction func tappedEqualButton(_ sender: UIButton) {
        calculation.tappedEqual()
        selectedOtherButton(sender)
    }

    // MARK: - setup buttons
    /// default state of numbers buttons
    private func setupNumberButton() {
        numberButtons.forEach { button in
            button.isSelected = false
            button.layer.cornerRadius = 20
        }
        textView.layer.cornerRadius = 20
    }

    /// default state of operand buttons
    private func setupOtherButton() {
        otherButtons.forEach { otherButton in
            otherButton.isSelected = false
            otherButton.backgroundColor = .orange
            otherButton.tintColor = .orange
            otherButton.layer.cornerRadius = 20
        }
    }

    /// selected state of numbers buttons - title color set in storyboard
    private func selectedNumberButton(_ sender: UIButton) {
        setupNumberButton()
        sender.isSelected = true
        setupOtherButton()
    }

    /// selected state of operand buttons - background color set here
    private func selectedOtherButton(_ sender: UIButton) {
        setupOtherButton()
        sender.isSelected = true
        sender.backgroundColor = .white
        sender.tintColor = .white
        sender.setTitleColor(.gray, for: .selected)
        setupNumberButton()
    }
}
extension CalculateController: CalculDelegate {

    func expression(with element: String) {
        textView.text = element
    }

    func presentAlert(message alertError: AlertError) {
        let alert = UIAlertController(
            title: "Houston !",
            message: "\(alertError)",
            preferredStyle: .alert
        )
        let errorAction = UIAlertAction(
            title: "ok",
            style: .cancel
        )
        alert.addAction(errorAction)
        present(alert, animated: true)
    }
}
