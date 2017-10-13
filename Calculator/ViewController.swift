//
//  ViewController.swift
//  Calculator
//
//  Created by Brian McGillen on 10/10/17.
//  Copyright © 2017 Brian McGillen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var expressionDisplay: UILabel!
    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    
    @IBAction func clearScreen(_ sender: UIButton) {
        display.text = "0"
    }
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            if textCurrentlyInDisplay.contains(".") && digit.contains(".") {return}
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
    }
    
    var expressionValue: String {
        get {
            return expressionDisplay.text!
        }
        set {
            expressionDisplay.text = String(newValue)
        }
    }
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        if let result = brain.result {
            displayValue = result
    }
        if let description = brain.descriptionToDisplay {
            expressionValue = description
        }
    
}

}
