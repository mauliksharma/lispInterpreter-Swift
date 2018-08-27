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
    case List([Exp])
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

if let lisp = parse(lispString), lisp.rest.isEmpty {
    print(lisp.parsed)
}
else {
    print("Invalid LISP")
}

