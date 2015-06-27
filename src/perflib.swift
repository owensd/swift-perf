/*! ===========================================================================
@file perflib.swift

@brief A set of utilities used to perform all of the performance measurements.

@copyright 2015 David Owens II. All rights reserved.
============================================================================ */

import Foundation

struct Result {
    let avg: Float
    let min: Float
    let max: Float
    let stddev: Float
}

typealias TimingFunction = () -> ()
typealias TestFunction = (Int, Int) -> Result

// NOTE(owensd): Trying out this faking of namespaces...
enum perflib {
    static var formatter: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.paddingCharacter = " "
        formatter.usesGroupingSeparator = false
        formatter.paddingPosition = NSNumberFormatterPadPosition.BeforePrefix
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        formatter.maximumFractionDigits = 6
        formatter.formatWidth = 8
        
        return formatter
    }()
    
    static func header(description: String) {
        let columnCount = 115
        let timingWidth = 10
        let numberOfTimings = 3
        let stddevWidth = 8
        let titleWidth = columnCount - (numberOfTimings * (timingWidth + 1)) - stddevWidth

        let remainingTitleWidth = titleWidth - description.characters.count
        
        print("\(description)", appendNewline: false)
        for _ in 0 ..< remainingTitleWidth { print(" ", appendNewline: false) }
        print("┃ Avg (ms) ┃ Min (ms) ┃ Max (ms) ┃ StdDev ┃")
        
        for  _ in 0 ..< titleWidth { print("━", appendNewline: false) }
        print("╇", appendNewline: false)
        
        for _ in 0 ..< numberOfTimings {
            for _ in 0 ..< timingWidth { print("━", appendNewline: false) }
            print("╇", appendNewline: false)
        }
        
        for _ in 0 ..< stddevWidth { print("━", appendNewline: false) }
        print("┩")
    }
    
    static func separator(endOfTable: Bool = true) {
        let columnCount = 115
        let timingWidth = 10
        let numberOfTimings = 3
        let stddevWidth = 8
        let titleWidth = columnCount - (numberOfTimings * (timingWidth + 1)) - stddevWidth
        
        for _ in 0 ..< titleWidth { print("─", appendNewline: false) }
        print(endOfTable ? "┴" : "┼", appendNewline: false)
        
        for _ in 0 ..< numberOfTimings {
            for _ in 0 ..< timingWidth { print("─", appendNewline: false) }
            print(endOfTable ? "┴" : "┼", appendNewline: false)
        }
        
        for _ in 0 ..< stddevWidth { print("─", appendNewline: false) }
        print(endOfTable ? "┘" : "┤")
    }

    static func measure(sampleCount: Int, _ iterationCount: Int, _ fn: TimingFunction) -> Result {
        var samples = [Float](count: sampleCount, repeatedValue: 0.0)
        for s in 0 ..< sampleCount {
            var elapsed: UInt64 = 0
            
            for _ in 0 ..< iterationCount {
                let start = mach_absolute_time()
                fn()
                elapsed += mach_absolute_time() - start
            }
            
            samples[s] = Float(elapsed) / Float(NSEC_PER_MSEC)
        }
        
        let avg = samples.reduce(0.0, combine: +) / Float(sampleCount)
        let sums = samples.reduce(0.0) { sum, x in ((x - avg) * (x - avg)) + sum }
        let stddev = sqrt(sums / Float(sampleCount - 1))
        
        let min = samples.minElement() ?? 0.0
        let max = samples.maxElement() ?? 0.0
        
        return Result(avg: avg, min: min, max: max, stddev: stddev)
    }
    
    static func printResult(description: String, _ result: Result) {
        let columnCount = 115
        let timingWidth = 10
        let numberOfTimings = 3
        let stddevWidth = 8
        let titleWidth = columnCount - (numberOfTimings * (timingWidth + 1)) - stddevWidth
        
        let remainingTitleWidth = titleWidth - description.characters.count
        
        print("\(description)", appendNewline: false)
        for _ in 0 ..< remainingTitleWidth { print(" ", appendNewline: false) }
        
        // NSNumberFormatter is a terrible, terrible API...
        func trim(str: String!, len: Int) -> String {
            return str.substringToIndex(advance(str.startIndex, len))
        }
        
        let avg = trim(perflib.formatter.stringFromNumber(result.avg), len: 8)
        let min = trim(perflib.formatter.stringFromNumber(result.min), len: 8)
        let max = trim(perflib.formatter.stringFromNumber(result.max), len: 8)
        let stddev = trim(perflib.formatter.stringFromNumber(result.stddev), len: 6)
        
        print("│ \(avg) │ \(min) │ \(max) │ \(stddev) │")
    }

    static func test(description: String, _ samples: Int, _ iterations: Int, _ fn: TestFunction) {
        let result = fn(samples, iterations)
        printResult(description, result)
    }
}

