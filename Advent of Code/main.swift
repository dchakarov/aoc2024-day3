//
//  main.swift
//  No rights reserved.
//

import Foundation
import RegexBuilder

func main() {
    let fileUrl = URL(fileURLWithPath: "./aoc-input")
    guard let inputString = try? String(contentsOf: fileUrl, encoding: .utf8) else { fatalError("Invalid input") }
    
    let lines = inputString.components(separatedBy: "\n")
        .filter { !$0.isEmpty }
    
    let line = lines.joined(separator: " ")
    
    let result = parseLine(line)
    let final = result.reduce(0) { $0 + $1.0 * $1.1 }
    print(result)
    print(final)
}

func parseLine(_ line: String) -> [(Int, Int)] {
    let digit1 = Reference(Int.self)
    let digit2 = Reference(Int.self)
    
    let search = Regex {
        "mul("
        TryCapture(as: digit1) {
            OneOrMore(.digit)
        } transform: { Int($0)! }
        ","
        TryCapture(as: digit2) {
            OneOrMore(.digit)
        } transform: { Int($0)! }
        ")"
    }
    
    var response = [(Int, Int)]()
    
    let result = line.matches(of: search)
    for match in result {
        response.append((match[digit1], match[digit2]))
    }
    
    return response
}

main()
