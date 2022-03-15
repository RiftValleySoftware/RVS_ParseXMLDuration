/*
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
  
 Version: 1.2.7

 The Great Rift Valley Software Company: https://riftvalleysoftware.com
 */

import XCTest
import RVS_ParseXMLDuration

class RVS_ParseXMLDurationTests: XCTestCase {
    typealias FromStringTestTuple = (targetString: String, expectedResult: DateComponents?)
    typealias FromComponentsTestTuple = (targetComponents: DateComponents, expectedResult: String?)

    static let fromStringTests: [FromStringTestTuple] = [
        (targetString: "P2Y6M5DT12H35M30S", expectedResult: DateComponents(year: 2, month: 6, day: 5, hour: 12, minute: 35, second: 30)),
        (targetString: "P1DT2H", expectedResult: DateComponents(day: 1, hour: 2)),
        (targetString: "P20M", expectedResult: DateComponents(month: 20)),
        (targetString: "PT20M", expectedResult: DateComponents(minute: 20)),
        (targetString: "P0Y20M0D", expectedResult: DateComponents(year: 0, month: 20, day: 0)),
        (targetString: "P0Y", expectedResult: DateComponents(year: 0)),
        (targetString: "-P60D", expectedResult: DateComponents(day: -60)),
        (targetString: "PT1M30.5S", expectedResult: DateComponents(minute: 1, second: 30, nanosecond: 5000000000)),
        (targetString: "P1Y2M3DT10H30M", expectedResult: DateComponents(year: 1, month: 2, day: 3, hour: 10, minute: 30)),
        (targetString: "-P120D", expectedResult: DateComponents(day: -120)),
        (targetString: "P1347Y", expectedResult: DateComponents(year: 1347)),
        (targetString: "P1347M", expectedResult: DateComponents(month: 1347)),
        (targetString: "P1Y2MT2H", expectedResult: DateComponents(year: 1, month: 2, hour: 2)),
        (targetString: "P0Y1347M", expectedResult: DateComponents(year: 0, month: 1347)),
        (targetString: "P0Y1347M0D", expectedResult: DateComponents(year: 0, month: 1347, day: 0)),
        (targetString: "P2M63DT55H91M", expectedResult: DateComponents(month: 2, day: 63, hour: 55, minute: 91)),
        (targetString: "P1D", expectedResult: DateComponents(day: 1)),
        (targetString: "PT10H5s", expectedResult: DateComponents(hour: 10, second: 5)),
        (targetString: "P5Y11M", expectedResult: DateComponents(year: 5, month: 11)),
        (targetString: "P2M4DT10M5.23S", expectedResult: DateComponents(month: 2, day: 4, minute: 10, second: 5, nanosecond: 2300000000)),
        (targetString: "-P2M4DT10M5.23S", expectedResult: DateComponents(month: -2, day: -4, minute: -10, second: -5, nanosecond: -2300000000)),
        (targetString: "PT0.001S", expectedResult: DateComponents(second: 0, nanosecond: 10000000)),
        (targetString: "-P2M", expectedResult: DateComponents(month: -2)),
        (targetString: "PT168H120M", expectedResult: DateComponents(hour: 168, minute: 120)),
        (targetString: "pt168h120m", expectedResult: DateComponents(hour: 168, minute: 120)),
        (targetString: "T168H120M", expectedResult: nil),
        (targetString: "P-20M", expectedResult: nil),
        (targetString: "P20MT", expectedResult: nil),
        (targetString: "P1YM5D", expectedResult: nil),
        (targetString: "P15.5Y", expectedResult: nil),
        (targetString: "P1D2H", expectedResult: nil),
        (targetString: "1Y2M", expectedResult: nil),
        (targetString: "P", expectedResult: nil),
        (targetString: "", expectedResult: nil),
        (targetString: "Norman", expectedResult: nil),
        (targetString: "P2M1Y", expectedResult: DateComponents(year: 1, month: 2)), // Even though this is illegal, we will still successfully parse it.
        (targetString: "PT15.S", expectedResult: DateComponents(second: 15))        // Even though this is illegal, we will still successfully parse it.
    ]
    
    static let fromComponentsTests: [FromComponentsTestTuple] = [
        (targetComponents: DateComponents(year: 1, month: 1, day: 1, hour: 1, minute: 1, second: 1, nanosecond: 1000000000), expectedResult: "P1Y1M1DT1H1M1.1S"),
        (targetComponents: DateComponents(year: 1, month: 2, day: 3, hour: 4, minute: 5, second: 6, nanosecond: 7000000000), expectedResult: "P1Y2M3DT4H5M6.7S"),
        (targetComponents: DateComponents(year: 1), expectedResult: "P1Y"),
        (targetComponents: DateComponents(month: 1), expectedResult: "P1M"),
        (targetComponents: DateComponents(day: 1), expectedResult: "P1D"),
        (targetComponents: DateComponents(hour: 1), expectedResult: "PT1H"),
        (targetComponents: DateComponents(minute: 1), expectedResult: "PT1M"),
        (targetComponents: DateComponents(second: 1), expectedResult: "PT1S"),
        (targetComponents: DateComponents(second: 60, nanosecond: 0), expectedResult: "PT60S"),
        (targetComponents: DateComponents(nanosecond: 1000000000), expectedResult: "PT0.1S"),
        (targetComponents: DateComponents(second: 1, nanosecond: 1000000000), expectedResult: "PT1.1S"),
        (targetComponents: DateComponents(year: 9999), expectedResult: "P9999Y"),
        (targetComponents: DateComponents(month: 9999), expectedResult: "P9999M"),
        (targetComponents: DateComponents(day: 9999), expectedResult: "P9999D"),
        (targetComponents: DateComponents(hour: 9999), expectedResult: "PT9999H"),
        (targetComponents: DateComponents(minute: 9999), expectedResult: "PT9999M"),
        (targetComponents: DateComponents(second: 9999), expectedResult: "PT9999S"),
        (targetComponents: DateComponents(nanosecond: 9999000000), expectedResult: "PT0.9999S"),
        (targetComponents: DateComponents(second: 9999, nanosecond: 9999000000), expectedResult: "PT9999.9999S"),
        (targetComponents: DateComponents(year: -1, month: -1, day: -1, hour: -1, minute: -1, second: -1, nanosecond: -1000000000), expectedResult: "-P1Y1M1DT1H1M1.1S"),
        (targetComponents: DateComponents(year: 1, month: -1, day: -1, hour: -1, minute: -1, second: -1, nanosecond: -1000000000), expectedResult: nil),
        (targetComponents: DateComponents(year: -1, month: 1, day: -1, hour: -1, minute: -1, second: -1, nanosecond: -1000000000), expectedResult: nil),
        (targetComponents: DateComponents(year: -1, month: -1, day: 1, hour: -1, minute: -1, second: -1, nanosecond: -1000000000), expectedResult: nil),
        (targetComponents: DateComponents(year: -1, month: -1, day: -1, hour: 1, minute: -1, second: -1, nanosecond: -1000000000), expectedResult: nil),
        (targetComponents: DateComponents(year: -1, month: -1, day: -1, hour: -1, minute: 1, second: -1, nanosecond: -1000000000), expectedResult: nil),
        (targetComponents: DateComponents(year: -1, month: -1, day: -1, hour: -1, minute: -1, second: 1, nanosecond: -1000000000), expectedResult: nil),
        (targetComponents: DateComponents(year: -1, month: -1, day: -1, hour: -1, minute: -1, second: -1, nanosecond: 1000000000), expectedResult: nil),
        (targetComponents: DateComponents(), expectedResult: nil),
        (targetComponents: DateComponents(year: -1), expectedResult: "-P1Y"),
        (targetComponents: DateComponents(month: -1), expectedResult: "-P1M"),
        (targetComponents: DateComponents(day: -1), expectedResult: "-P1D"),
        (targetComponents: DateComponents(hour: -1), expectedResult: "-PT1H"),
        (targetComponents: DateComponents(minute: -1), expectedResult: "-PT1M"),
        (targetComponents: DateComponents(second: -1), expectedResult: "-PT1S"),
        (targetComponents: DateComponents(nanosecond: -1000000000), expectedResult: "-PT0.1S"),
        (targetComponents: DateComponents(second: -1, nanosecond: -1000000000), expectedResult: "-PT1.1S"),
        (targetComponents: DateComponents(year: 1, month: 0, day: 0, hour: 0, minute: 0, second: 0, nanosecond: 0), expectedResult: "P1Y"),
        (targetComponents: DateComponents(year: 0, month: 1, day: 0, hour: 0, minute: 0, second: 0, nanosecond: 0), expectedResult: "P1M"),
        (targetComponents: DateComponents(year: 0, month: 0, day: 1, hour: 0, minute: 0, second: 0, nanosecond: 0), expectedResult: "P1D"),
        (targetComponents: DateComponents(year: 0, month: 0, day: 0, hour: 1, minute: 0, second: 0, nanosecond: 0), expectedResult: "PT1H"),
        (targetComponents: DateComponents(year: 0, month: 0, day: 0, hour: 0, minute: 1, second: 0, nanosecond: 0), expectedResult: "PT1M"),
        (targetComponents: DateComponents(year: 0, month: 0, day: 0, hour: 0, minute: 0, second: 1, nanosecond: 0), expectedResult: "PT1S"),
        (targetComponents: DateComponents(year: 0, month: 0, day: 0, hour: 0, minute: 0, second: 0, nanosecond: 1000000000), expectedResult: "PT0.1S"),
        (targetComponents: DateComponents(year: 0, month: 0, day: 0, hour: 0, minute: 0, second: 1, nanosecond: 1000000000), expectedResult: "PT1.1S")
    ]
    
    func runFromStringTest(_ inTestTuple: FromStringTestTuple) {
        if let testComponents = inTestTuple.targetString.asXMLDuration {
            if let expectedResult = inTestTuple.expectedResult {
                XCTAssertEqual(testComponents, expectedResult, "Unexpected result")
            } else {
                XCTAssertNil(testComponents, "Should be nil!")
            }
        } else if nil != inTestTuple.expectedResult {
            XCTFail("Not sure what happened here (testing \(String(describing: inTestTuple)))!")
        }
    }
    
    func runFromComponentsTest(_ inTestTuple: FromComponentsTestTuple) {
        if let testComponents = inTestTuple.targetComponents.asXMLDuration {
            if let expectedResult = inTestTuple.expectedResult {
                XCTAssertEqual(testComponents, expectedResult, "Unexpected result")
            } else {
                XCTAssertNil(testComponents, "Should be nil!")
            }
        }
    }

    func testBasics() {
        type(of: self).fromStringTests.forEach {
            runFromStringTest($0)
        }

        type(of: self).fromComponentsTests.forEach {
            runFromComponentsTest($0)
        }
    }
}
