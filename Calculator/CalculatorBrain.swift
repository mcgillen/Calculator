//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Brian McGillen on 10/10/17.
//  Copyright © 2017 Brian McGillen. All rights reserved.
//

import Foundation

func testFunc() {
    var test = 10
    var test2 = 10
}

func percent(_ number: Double) -> Double {
    return number * 0.01
}

struct CalculatorBrain {
    
    private var accumulator: Double?
    
    private var resultIsPending: Bool = false
    private var operandDisplayedAlready: Bool = false
    
    private var description = ""
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
        case clear
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.constant(Double.pi),
        "√" : Operation.unaryOperation(sqrt),
        "cos" : Operation.unaryOperation(cos),
        "sin" : Operation.unaryOperation(sin),
        "tan" : Operation.unaryOperation(tan),
        "%" : Operation.unaryOperation(percent),
        "±" : Operation.unaryOperation({ -$0 }),
        "x" : Operation.binaryOperation({ $0 * $1 }),
        "÷" : Operation.binaryOperation({ $0 / $1 }),
        "+" : Operation.binaryOperation({ $0 + $1 }),
        "-" : Operation.binaryOperation({ $0 - $1 }),
        "x^y": Operation.binaryOperation({ pow($0, $1) }),
        "=" : Operation.equals,
        "C" : Operation.clear
    ]
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
                if pendingBinaryOperation == nil {description = ""}
                description.append(symbol + " ")
                operandDisplayedAlready = true
            case .unaryOperation (let function):
                if accumulator != nil {
                    if resultIsPending {
                        description.append(symbol + "( " + String(describing: accumulator!) + ") ")
                        operandDisplayedAlready = true
                    }
                    else {description = symbol + "( " + "\(description)" + ") "}
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    symbol == "x^y" ? description.append("^" + " ") : description.append(symbol + " ")
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    resultIsPending = true
                    accumulator = nil
                    operandDisplayedAlready = false
                }
            case .equals:
                performPendingBinaryOperation()
                resultIsPending = false
            case .clear:
                description = ""
                resultIsPending = false
                accumulator = nil
                pendingBinaryOperation = nil
        }
            
        
    }
    }
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            if !operandDisplayedAlready {description.append (String(describing: accumulator!) + " ")}
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
            operandDisplayedAlready = false
        }
       
        
    }
    private var pendingBinaryOperation : PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        if accumulator != nil {description=" "}
        accumulator = operand
        if !resultIsPending {description.append(String(operand) + " ")}
    }
    
    var result: Double? {
        get {
            return accumulator
        }
    }
    
    var descriptionToDisplay: String? {
        get {
            if description=="" {return "Expression:"}
            if resultIsPending {return description + "..."}
            else {return description + "="}
        }
    }
}

