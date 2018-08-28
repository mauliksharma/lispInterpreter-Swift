//
//  main.swift
//  lispInterpreter(Basic)
//
//  Created by Maulik on 27/08/18.
//  Copyright © 2018 geekskool. All rights reserved.
//

import Foundation

var lispInput = ""


while let line = readLine() {
    lispInput += line
    if line == "" {
        break
    }
}

var lispString = lispInput.replacingOccurrences(of: "(", with: " ( ").replacingOccurrences(of: ")", with: " ) ")


indirect enum Exp {
    case Symbol(String)
    case Number(Double)
    case Boolean(Bool)
    case List([Exp])
    
    func getSymbolValue() -> String? {
        switch self {
        case .Symbol(let str):
            return str
        default:
            return nil
        }
    }
    func getNumberValue() -> Double? {
        switch self {
        case .Number(let num):
            return num
        default:
            return nil
        }
    }
    func getBoolValue() -> Bool? {
        switch self {
        case .Boolean(let bool):
            return bool
        default:
            return nil
        }
    }
    func getListArray() -> [Exp]? {
        switch self {
        case .List(let arr):
            return arr
        default:
            return nil
        }
    }
}

extension Exp: Equatable {
    static func ==(lhs: Exp, rhs: Exp) -> Bool {
        switch (lhs, rhs) {
        case let (.Symbol(left), .Symbol(right)):
            return left == right
        case let (.Number(left), .Number(right)):
            return left == right
        case let (.List(left), .List(right)):
            guard left.count == right.count else { return false }
            for index in left.indices {
                if left[index] != right[index] {
                    return false
                }
            }
            return true
        default:
            return false
        }
    }
}

func parse(_ input: String) -> (parsed: Exp, rest: String)? {
    guard !input.isEmpty else { return nil }
    var s = input.trimmingCharacters(in: .whitespaces)
    let spaceIndex = s.index(of: " ") ?? s.endIndex
    let str = String(s[..<spaceIndex])
    if str != ")" && str != "(" {
        s.removeFirst(str.count)
        if let num = Double(str) {
            return (Exp.Number(num), s)
        }
        else {
            return (Exp.Symbol(str), s)
        }
    }
    else if str == "(" {
        s.removeFirst()
        var list = [Exp]()
        while !s.isEmpty {
            guard let el = parse(s) else { return nil }
            list.append(el.parsed)
            s = el.rest.trimmingCharacters(in: .whitespaces)
            if s.hasPrefix(")") {
                break
            }
        }
        s.removeFirst() //removes ")" after the break
        return (Exp.List(list), s)
    }
    return nil //also for ")" that wasn encountered w/o a preceding list
}

func eval(_ exp: Exp, env: inout [String: ValueType]) -> Exp? {
    if let s = exp.getSymbolValue() {
        return env[s]?.getConstantValue()
    }
    else if let _ = exp.getNumberValue() {
        return exp
    }
    else if let l = exp.getListArray() {
        guard let firstExp = l.first else { return nil } //assumes every list has atleast one element
        guard let firstElement = firstExp.getSymbolValue() else { return nil } //assumes every list starts with a keyword or fn
        switch firstElement {
        case "if":
            guard l.count == 4 else { return nil } //throw an error
            guard let testExp = eval(l[1], env: &env) else { return nil } // throw error
            guard let testVal = testExp.getBoolValue() else { return nil } //throw error
            return (testVal ? eval(l[2], env: &env) : eval(l[3], env: &env))
        case "define":
            guard l.count == 3 else { return nil } //throw an error
            guard let variable = l[1].getSymbolValue() else { return nil } //throw error
            guard let value = eval(l[2], env: &env) else { return nil } //throw error
            env[variable] = ValueType.constant(value)
        default:
            guard let proc = evalToProc(l[0], env: &env) else { return nil } //throw error
            let args = l.compactMap{ eval($0, env: &env) }
            return proc(args)
        }
    }
    return nil
}

func evalToProc(_ exp: Exp, env: inout [String: ValueType]) -> (([Exp]) -> Exp?)? {
    guard let procSymbol = exp.getSymbolValue() else { return nil }
    return env[procSymbol]?.getOperation()
}

extension Exp: CustomStringConvertible {
    var description: String {
        if let num = self.getNumberValue() {
            return String(num)
        }
        else if let sym = self.getSymbolValue() {
            return sym
        }
        else if let list = self.getListArray() {
            var result = "("
            for exp in list {
                result += "\(exp)"
            }
            result += ")"
            return result
        }
        else if let bool = self.getBoolValue() {
            return String(bool)
        }
        return "Invalid Exp"
    }
}


if let lisp = parse(lispString), lisp.rest.isEmpty {
    print(lisp.parsed)
    if let result = eval(lisp.parsed, env: &globalEnv) {
        print(result)
    }
}
else {
    print("Invalid LISP")
}


/*
if let check = add([Exp.Number(-40), Exp.Number(41)]) {
    print(check)
}
else {
    print("Invalid")
}
*/

