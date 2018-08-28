//
//  main.swift
//  lispInterpreter(Basic)
//
//  Created by Maulik on 27/08/18.
//  Copyright © 2018 geekskool. All rights reserved.
//

import Foundation

var lispInput = ""
/*
while let line = readLine() {
    lispInput += line
    if line == "" {
        break
    }
}
*/
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

/*
if let lisp = parse(lispString), lisp.rest.isEmpty {
    print(lisp.parsed)
}
else {
    print("Invalid LISP")
}
*/

if let check = add([Exp.Number(-40), Exp.Number(41)]) {
    print(check)
}
else {
    print("Invalid")
}


