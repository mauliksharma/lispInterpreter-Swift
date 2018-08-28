//
//  Environment.swift
//  lispInterpreter(Basic)
//
//  Created by Maulik on 27/08/18.
//  Copyright © 2018 geekskool. All rights reserved.
//

import Foundation

enum ValueType {
    case constant(Exp)
    case operation(([Exp]) -> Exp?)
    
    func getConstantValue() -> Exp? {
        switch self {
        case .constant(let val):
            return val
        default:
            return nil
        }
    }
    func getOperation() -> (([Exp]) -> Exp?)? {
        switch self {
        case .operation(let op):
            return op
        default:
            return nil
        }
    }
}

var globalEnv: [String: ValueType] = [
    "π": ValueType.constant(.Number(Double.pi)),
    "pi": ValueType.constant(.Number(Double.pi)),
    "e": ValueType.constant(.Number(M_E)),
    "𝑒": ValueType.constant(.Number(M_E)),
    "sqrt": ValueType.operation(sqrt),
    "sin": ValueType.operation(sin),
    "cos": ValueType.operation(cos),
    "tan": ValueType.operation(tan),
    "abs": ValueType.operation(abs),
    "+": ValueType.operation(plus),
    "-": ValueType.operation(minus),
    "*": ValueType.operation(mul),
    "/": ValueType.operation(div),
    "exp": ValueType.operation(exp),
    "<":  ValueType.operation(lessThan),
    ">":  ValueType.operation(greaterThan),
    "<=":  ValueType.operation(lessThanEqual),
    ">=":  ValueType.operation(greaterThanEqual),
    "=": ValueType.operation(equal),
    "equal?": ValueType.operation(equal),
    "not": ValueType.operation(not),
    "begin": ValueType.operation(begin),
    "car": ValueType.operation(car),
    "cdr": ValueType.operation(cdr)
]

func sqrt(_ input: [Exp]) -> Exp? {
    guard input.count == 1 else { return nil }
    guard let value = input[0].getNumberValue() else { return nil }
    return .Number(sqrt(value))
}

func sin(_ input: [Exp]) -> Exp? {
    guard input.count == 1 else { return nil }
    guard let value = input[0].getNumberValue() else { return nil }
    return .Number(sin(value))
}

func cos(_ input: [Exp]) -> Exp? {
    guard input.count == 1 else { return nil }
    guard let value = input[0].getNumberValue() else { return nil }
    return .Number(cos(value))
}

func tan(_ input: [Exp]) -> Exp? {
    guard input.count == 1 else { return nil }
    guard let value = input[0].getNumberValue() else { return nil }
    return .Number(tan(value))
}

func abs(_ input: [Exp]) -> Exp? {
    guard input.count == 1 else { return nil }
    guard let value = input[0].getNumberValue() else { return nil }
    return .Number(abs(value))
}

func plus(_ input: [Exp]) -> Exp? {
    guard input.count == 2 else { return nil }
    switch (input[0], input[1]) {
    case let (.Number(first), .Number(second)):
        return .Number(first + second)
    case let (.Symbol(first), .Symbol(second)):
        return .Symbol(first + second)
    default:
        return nil
    }
}

func minus(_ input: [Exp]) -> Exp? { //for subtraction and negative
    if input.count == 1 {
        guard let value = input[0].getNumberValue() else { return nil }
        return .Number(-value)
    }
    else if input.count == 2 {
        switch (input[0], input[1]) {
        case let (.Number(first), .Number(second)):
            return .Number(first - second)
        default:
            return nil
        }
    }
    else {
        return nil
    }
}

func mul(_ input: [Exp]) -> Exp? {
    guard input.count == 2 else { return nil }
    switch (input[0], input[1]) {
    case let (.Number(first), .Number(second)):
        return .Number(first * second)
    default:
        return nil
    }
}

func div(_ input: [Exp]) -> Exp? {
    guard input.count == 2 else { return nil }
    switch (input[0], input[1]) {
    case let (.Number(first), .Number(second)):
        return .Number(first / second)
    default:
        return nil
    }
}

func exp(_ input: [Exp]) -> Exp? {
    guard input.count == 2 else { return nil }
    switch (input[0], input[1]) {
    case let (.Number(first), .Number(second)):
        return .Number(pow(first, second))
    default:
        return nil
    }
}

func lessThan(_ input: [Exp]) -> Exp? {
    guard input.count == 2 else { return nil }
    switch (input[0], input[1]) {
    case let (.Number(first), .Number(second)):
        return .Boolean(first < second)
    case let (.Symbol(first), .Symbol(second)):
        return .Boolean(first < second)
    default:
        return nil
    }
}

func greaterThan(_ input: [Exp]) -> Exp? {
    guard input.count == 2 else { return nil }
    switch (input[0], input[1]) {
    case let (.Number(first), .Number(second)):
        return .Boolean(first > second)
    case let (.Symbol(first), .Symbol(second)):
        return .Boolean(first > second)
    default:
        return nil
    }
}

func lessThanEqual(_ input: [Exp]) -> Exp? {
    guard input.count == 2 else { return nil }
    switch (input[0], input[1]) {
    case let (.Number(first), .Number(second)):
        return .Boolean(first <= second)
    case let (.Symbol(first), .Symbol(second)):
        return .Boolean(first <= second)
    default:
        return nil
    }
}

func greaterThanEqual(_ input: [Exp]) -> Exp? {
    guard input.count == 2 else { return nil }
    switch (input[0], input[1]) {
    case let (.Number(first), .Number(second)):
        return .Boolean(first >= second)
    case let (.Symbol(first), .Symbol(second)):
        return .Boolean(first >= second)
    default:
        return nil
    }
}

func equal(_ input: [Exp]) -> Exp? { // =, equal?
    guard input.count == 2 else { return nil }
    switch (input[0], input[1]) {
    case let (.Number(first), .Number(second)):
        return .Boolean(first == second)
    case let (.Symbol(first), .Symbol(second)):
        return .Boolean(first == second)
    case let (.List(first), .List(second)):
        return .Boolean(first == second)
    default:
        return nil
    }
}

func not(_ input: [Exp]) -> Exp? {
    guard input.count == 1 else { return nil }
    guard let value = input[0].getBoolValue() else { return nil }
    return .Boolean(!value)
}

func begin(_ input: [Exp]) -> Exp? {
    return input.last
}

func car(_ input: [Exp]) -> Exp? {
    return input.first
}

func cdr(_ input: [Exp]) -> Exp? {
    var arr = input
    arr.removeFirst()
    return .List(arr)
}





