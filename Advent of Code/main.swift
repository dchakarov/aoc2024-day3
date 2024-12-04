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
    let part1 = result.reduce(0) { $0 + $1.0 * $1.1 }
    print(part1)
    
    let commands = parseString(line)

    print(calcPart2(muls: result, commands: commands))
}

func calcPart2(muls: [(Int, Int, String.Index)], commands: [(String, String.Index)]) -> Int {
    var result = 0
    
    for mul in muls {
        let (a, b, index) = mul
        
        if let command = commands.last(where: { $0.1 < index }) {
            if command.0 == "do()" {
                result += a * b
            }
        } else {
            result += a * b
        }
    }
    
    return result
}

func parseLine(_ line: String) -> [(Int, Int, String.Index)] {
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
    
    var response = [(Int, Int, String.Index)]()
    
    let result = line.matches(of: search)
    for match in result {
        response.append((match[digit1], match[digit2], match.range.lowerBound))
    }
    
    return response
}

func parseString(_ line: String) -> [(String, String.Index)] {
    let str = Reference(String.self)
    let search = Regex {
        TryCapture(as: str) {
            ChoiceOf {
                "do()"
                "don't()"
            }
        } transform: { String($0) }
    }
        
    let result = line.matches(of: search)
    
    return result.map { ($0[str], $0.range.lowerBound) }
}

main()
