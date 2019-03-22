/**
 © Copyright 2019, The Great Rift Valley Software Company
 
 LICENSE:
 
 MIT License
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,
 modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 
 The Great Rift Valley Software Company: https://riftvalleysoftware.com
 */

import Foundation

/* ################################################################################################################################## */
/**
 This extension adds the capability to parse a String as an xs:duration (XML duration), returning the duration as a DateComponents Set.
 
 The definition for duration is here: https://www.w3.org/TR/xmlschema11-2/#duration
 
 A more readable breakdown is here: http://www.datypic.com/sc/xsd/t-xsd_duration.html
 */
public extension String {
    /* ################################################################## */
    /**
     */
    var asXMLDuration: DateComponents! {
        /* ############################################################## */
        /**
         */
        func _asXMLDurationScanString(_ inString: String!, isNegative: Bool = false, isDate: Bool = false) -> DateComponents! {
            var ret: DateComponents!
            
            if let parseTarget = inString {
                let numbers = CharacterSet.decimalDigits.union(CharacterSet(charactersIn: ".")) // Numbers and a decimal point.
                let valueIndicators = CharacterSet(charactersIn: "YMDHS")   // These are the value indicators (years, months/minutes, days, hours, seconds)
                let scanner = Scanner(string: parseTarget)  // Set up a scanner, with the string supplied.
                scanner.charactersToBeSkipped = numbers.union(valueIndicators).inverted  // Ignore everything but what we give you.
                while !scanner.isAtEnd {            // Keep going until the end.
                    var value: NSString?            // The numerical value that will be scanned. We use NSString for the scanner.
                    var typeIndicator: NSString?    // This is the value indicator.
                    
                    scanner.scanCharacters(from: numbers, into: &value)                 // Grab the numerical part first.
                    scanner.scanCharacters(from: valueIndicators, into: &typeIndicator) // Followed by the value indicator.
                    
                    // Quick validation and unwrapping.
                    if let value = value as String?, let doubleVal = Double(value), let typeIndicator = typeIndicator as String? {
                        if (isDate && "HS".contains(typeIndicator))                         // Any time values must come after "T".
                            || (floor(doubleVal) != doubleVal && "S" != typeIndicator) {    // Only seconds can have a decimal value.
                            return nil
                        }
                        
                        if nil == ret {
                            ret = DateComponents()                      // This is what we'll return (unless there's an error).
                        }
                        let multiplier: Double = isNegative ? -1 : 1    // This is used to make values negative. We parse an absval.
                        let intVal = Int(doubleVal * multiplier)
                        switch typeIndicator {                          // Which components are set depends upon which value indicator we got.
                        case "Y":   // Years
                            ret.year = intVal
                        case "M":   // Months or Minutes
                            if isDate {  // Which one depends on whether this is a date or a time.
                                ret.month = intVal
                            } else {
                                ret.minute = intVal
                            }
                        case "D":   // Days
                            ret.day = intVal
                        case "H":   // Hours
                            ret.hour = intVal
                        case "S":   // Seconds and Nanoseconds. Fractions of seconds will result in a second property of zero.
                            let nanosecond = (doubleVal - floor(doubleVal)) * 10000000000  // The fractional part of the value.
                            ret.second = intVal
                            if 0 < nanosecond { // We only supply a nanosecond value if we actually have a fractional part.
                                ret.nanosecond = Int(nanosecond * multiplier)
                            }
                            
                        default:    // Nothing else is allowed.
                            return nil
                        }
                    } else {
                        return nil
                    }
                }
            }
            
            return ret
        }

        var target = self
        let isNegative = "-" == target.first
        if isNegative {
            target.removeFirst()
        }
        
        let timeDate = target.uppercased().components(separatedBy: "T")
        if 0 < timeDate.count,
            !(1 < timeDate.count && timeDate[1].isEmpty),
            "P" == timeDate[0].prefix(1),
            "P-" != timeDate[0].prefix(2) {
            let dateString = "P" != timeDate[0] ? String(timeDate[0].dropFirst()) : nil
            let timeString = ((1 < timeDate.count) && !timeDate[1].isEmpty) ? timeDate[1] : nil
            
            var returnValue = _asXMLDurationScanString(dateString, isNegative: isNegative, isDate: true)

            if let timeComp = _asXMLDurationScanString(timeString, isNegative: isNegative) {
                if nil != returnValue {
                    returnValue?.hour = timeComp.hour
                    returnValue?.minute = timeComp.minute
                    returnValue?.second = timeComp.second
                    returnValue?.nanosecond = timeComp.nanosecond
                } else {
                    returnValue = timeComp
                }
            }
            
            return returnValue
        }
        
        return nil
    }
}

/* ################################################################################################################################## */
/**
 This extension provides the reverse of the above.
 
 You can have an instance of DateComponents express itself as a legal, optimized xs:duration String.
 */
public extension DateComponents {
    /* ################################################################## */
    /**
     */
    var asXMLDuration: String! {
        // First, extract all of the components we're interested in. We either have a value, or 0.
        let componentArray: [Int] = [
            self.year ?? 0,
            self.month ?? 0,
            self.day ?? 0,
            self.hour ?? 0,
            self.minute ?? 0,
            self.second ?? 0,
            self.nanosecond ?? 0
        ]
        
        // Now, if one is negative, they must ALL be negative. -1 is negative, 1 is positive, and -2 or 0 (no valid values) is error.
        let multiplier = componentArray.reduce(0, { (current, nextItem) -> Int in
            if -2 != current {  // Are we BORK?
                if (nextItem < 0 && -1 == current) || (nextItem > 0 && 1 == current) {  // We assume that we are on the same page as the previous value.
                    return current
                } else if 0 == current {    // If this is the first valid value, then we set the agenda.
                    return nextItem < 0 ? -1 : 1
                } else {        // BORK
                    return -2
                }
            } else {
                return current  // BORK
            }
        })
        
        if 1 == abs(multiplier) {                               // -2 means we have an illegal situation (some are negative, and some are not). 0 means that we have no valid numbers.
            // This allows us to loop through.
            let tagArray: [String] = ["Y", "M", "D", "H", "M"]
            
            let components = componentArray.map(abs)            // Remove any negative influences. Feng Shui...
            var resultString = -1 == multiplier ? "-P" : "P"    // Start your engines...
            
            // The first lot are easy and straightforward.
            for index in 0..<tagArray.count {
                if 3 == index {
                    resultString += "T" // Time for time...
                }
                if 0 != components[index] {
                    resultString += String(components[index]) + tagArray[index]
                }
            }
            
            // Seconds takes a bit more work, as it could be fractional.
            if 0 != components[tagArray.count] || 0 != components[tagArray.count + 1] {
                let value: Double = Double(components[tagArray.count]) + (Double(components[tagArray.count + 1]) / 10000000000)
                resultString += String(value) + "S"
            }
            
            return resultString
        }
        
        return nil
    }
}
