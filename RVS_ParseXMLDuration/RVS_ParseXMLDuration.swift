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
        func scanString(_ inString: String!, isDate: Bool = false) -> DateComponents! {
            var ret: DateComponents!
            
            if let parseTarget = inString {
                let numbers = CharacterSet.decimalDigits.union(CharacterSet(charactersIn: "."))
                let separators = CharacterSet(charactersIn: "YMDHMS")
                let scanner = Scanner(string: parseTarget)
                scanner.charactersToBeSkipped = numbers.union(separators).inverted
                ret = DateComponents()
                while !scanner.isAtEnd {
                    var value: NSString?
                    var typeIndicator: NSString?
                    
                    scanner.scanCharacters(from: numbers, into: &value)
                    scanner.scanCharacters(from: separators, into: &typeIndicator)
                    
                    if let value = value as String?, let doubleVal = Double(value) {
                        switch typeIndicator as String? {
                        case "Y":
                            ret.year = Int(doubleVal)
                        case "M":
                            if isDate {
                                ret.month = Int(doubleVal)
                            } else {
                                ret.minute = Int(doubleVal)
                            }
                        case "D":
                            ret.day = Int(doubleVal)
                        case "H":
                            ret.hour = Int(doubleVal)
                        case "S":
                            ret.second = Int(doubleVal)
                            let nanosecond = Int((doubleVal - Double(Int(doubleVal))) * 1000000000)
                            if 0 < nanosecond {
                                ret.nanosecond = nanosecond
                            }
                            
                        default:
                            break
                        }
                    }
                }
            }
            
            return ret.isValidDate ? ret : nil
        }
        
        let timeDate = self.components(separatedBy: "T")
        let dateString = "P" != timeDate[0] ? String(timeDate[0].dropFirst()) : nil
        let timeString = ((1 < timeDate.count) && !timeDate[1].isEmpty) ? timeDate[1] : nil
        
        var returnValue = scanString(dateString)

        if let timeComp = scanString(timeString) {
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
}
