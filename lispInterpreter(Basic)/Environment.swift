//
//  Environment.swift
//  lispInterpreter(Basic)
//
//  Created by Maulik on 27/08/18.
//  Copyright © 2018 geekskool. All rights reserved.
//

import Foundation

enum SchemeProcedure {
    case constant(Double)
    case operation(([Exp]) -> Exp?)
}

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

func add(_ input: [Exp]) -> Exp? {
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

func sub(_ input: [Exp]) -> Exp? {
    guard input.count == 2 else { return nil }
    switch (input[0], input[1]) {
    case let (.Number(first), .Number(second)):
        return .Number(first - second)
    default:
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
        return .Number(first * second)
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

func lessthan(_ input: [Exp]) -> Exp? {
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

func greaterthan(_ input: [Exp]) -> Exp? {
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

func lessthanequal(_ input: [Exp]) -> Exp? {
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

func greaterthanequal(_ input: [Exp]) -> Exp? {
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

func append(_ input: [Exp]) -> Exp? {
    guard input.count == 2 else { return nil }
    switch (input[0], input[1]) {
    case let (.List(first), .List(second)):
        return .List(first + second)
    default:
        return nil
    }
}

