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
        func scanString(_ inString: String!, isNegative: Bool = false, isDate: Bool = false) -> DateComponents! {
            var ret: DateComponents!
            
            if let parseTarget = inString {
                let numbers = CharacterSet.decimalDigits.union(CharacterSet(charactersIn: ".")) // Numbers and a decimal point.
                let valueIndicators = CharacterSet(charactersIn: "YMDHS")   // These are the value indicators (years, months/minutes, days, hours, seconds)
                let scanner = Scanner(string: parseTarget)  // Set up a scanner, with the string supplied.
                scanner.charactersToBeSkipped = numbers.union(valueIndicators).inverted  // Ignore everything but what we give you.
                ret = DateComponents()              // This is what we'll return (unless there's an error).
                while !scanner.isAtEnd {            // Keep going until the end.
                    var value: NSString?            // The numerical value that will be scanned. We use NSString for the scanner.
                    var typeIndicator: NSString?    // This is the value indicator.
                    
                    scanner.scanCharacters(from: numbers, into: &value)                 // Grab the numerical part first.
                    scanner.scanCharacters(from: valueIndicators, into: &typeIndicator) // Followed by the value indicator.
                    
                    // Quick validation and unwrapping.
                    if let value = value as String?, let doubleVal = Double(value), let typeIndicator = typeIndicator as String? {
                        if floor(doubleVal) != doubleVal && "S" != typeIndicator {  // Only seconds can have a decimal value.
                            return nil
                        }
                        let multiplier: Double = isNegative ? -1 : 1    // This is used to make values negative. We parse an absval.
                        switch typeIndicator {  // Which components are set depends upon which value indicator we got.
                        case "Y":   // Years
                            ret.year = Int(doubleVal * multiplier)
                        case "M":   // Months or Minutes
                           if isDate {  // Which one depends on whether this is a date or a time.
                                ret.month = Int(doubleVal * multiplier)
                            } else {
                                ret.minute = Int(doubleVal * multiplier)
                            }
                        case "D":   // Days
                            ret.day = Int(doubleVal * multiplier)
                        case "H":   // Hours
                            ret.hour = Int(doubleVal * multiplier)
                        case "S":   // Seconds and Nanoseconds. Fractions of seconds will result in a second property of zero.
                            ret.second = Int(doubleVal * multiplier)
                            let nanosecond = (doubleVal - floor(doubleVal)) * 1000000000  // The fractional part of the value.
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
        if 1 == timeDate.count || !(1 < timeDate.count && timeDate[1].isEmpty) {
            let dateString = "P" != timeDate[0] ? String(timeDate[0].dropFirst()) : nil
            let timeString = ((1 < timeDate.count) && !timeDate[1].isEmpty) ? timeDate[1] : nil
            
            var returnValue = scanString(dateString, isNegative: isNegative, isDate: true)

            if let timeComp = scanString(timeString, isNegative: isNegative) {
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
