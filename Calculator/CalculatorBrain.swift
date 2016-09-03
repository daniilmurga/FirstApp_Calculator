//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Daniil Murga on 29/08/16.
//  Copyright © 2016 Daniil Murga. All rights reserved.
//

import Foundation


class CalculatorBrain {
    
 
    
    private var accumulator = 0.0
    
    func setOperand(operand:Double){
        accumulator = operand
    }
    
    private var operations: Dictionary<String,Operation> = [
        /*
        If in the code this table doesnt make developers code easier then creating this table was POINTLESS. This table has to be used via closures(similar to INLINE functions) instead of writing every single fucntion separately:
         Example:
         
         First
         "*": Operation.BinaryOperation({(op1: Double, op2: Double) -> Double in
         return op1 * op2
         }),
         
         Second
         "*": Operation.BinaryOperation({(op1, op2)in return op1 * op2}),
         
         Third 
         "*": Operation.BinaryOperation{return $0 * $1},
         
         Finally
         "*": Operation.BinaryOperation({$0 * $1}),
         */

        
        "π": Operation.Constant(M_PI),
        "e": Operation.Constant(M_E),
        "√": Operation.UnaryOperation(sqrt),
        "cos": Operation.UnaryOperation(cos),
        "=": Operation.Equals,
        "*": Operation.BinaryOperation({$0 * $1}),
        "/": Operation.BinaryOperation({$0 / $1}),
        "+": Operation.BinaryOperation({$0 + $1}),
        "-": Operation.BinaryOperation({$0 - $1}),
    ]

   
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    func performOperation(symbol:String){
        /*This will be doing only GENERIC operations while everytihng else is factored outside(everith else will be in a table). It will look in the table to find out what to do
         */
      /*  switch symbol {
        case "π": accumulator = M_PI
        case "√": accumulator = sqrt(accumulator)
        default: break
         */
        
      /*  Dont Need this anymore due to enum
        let constant = operations[symbol]
        accumulator = constant! */
        
        if let operation = operations[symbol]{
            switch operation {
                case .Constant(let value): accumulator = value
                case .UnaryOperation(let function): accumulator = function(accumulator)
                case .BinaryOperation(let function):
                    executePendingBinaryOperation()
                    pending = pendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
                case .Equals: executePendingBinaryOperation()
            }
        }
    }
    
    private func executePendingBinaryOperation (){
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    
    private var pending: pendingBinaryOperationInfo?
    
    private struct pendingBinaryOperationInfo{
        var binaryFunction: (Double,Double) -> Double
        var firstOperand: Double
    }
    
    var result: Double {
        get {                   // This now becomes a Read-Only property
            return accumulator
        }
    }
    
    
    
}