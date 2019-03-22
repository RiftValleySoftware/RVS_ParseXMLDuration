//
//  RVS_ParseXMLDurationTests.swift
//  RVS_ParseXMLDurationTests
//
//  Created by Chris Marshall on 3/21/19.
//  Copyright © 2019 The Great Rift Valley Software Company. All rights reserved.
//

import XCTest

class RVS_ParseXMLDurationTests: XCTestCase {
    typealias TestTuple = (targetString: String, expectedResult: DateComponents?)
    
    static let testSequence: [TestTuple] = [
        (targetString: "P2Y6M5DT12H35M30S", expectedResult: DateComponents(year: 2, month: 6, day: 5, hour: 12, minute: 35, second: 30)),
        (targetString: "P1DT2H", expectedResult: DateComponents(day: 1, hour: 2)),
        (targetString: "P20M", expectedResult: DateComponents(month: 20)),
        (targetString: "PT20M", expectedResult: DateComponents(minute: 20)),
        (targetString: "P0Y20M0D", expectedResult: DateComponents(year: 0, month: 20, day: 0)),
        (targetString: "P0Y", expectedResult: DateComponents(year: 0)),
        (targetString: "-P60D", expectedResult: DateComponents(day: -60)),
        (targetString: "PT1M30.5S", expectedResult: DateComponents(minute: 1, second: 30, nanosecond: 500000000)),
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
        (targetString: "P2M4DT10M5.23S", expectedResult: DateComponents(month: 2, day: 4, minute: 10, second: 5, nanosecond: 230000000)),
        (targetString: "-P2M4DT10M5.23S", expectedResult: DateComponents(month: -2, day: -4, minute: -10, second: -5, nanosecond: -230000000)),
        (targetString: "PT0.001S", expectedResult: DateComponents(second: 0, nanosecond: 1000000)),
        (targetString: "-P2M", expectedResult: DateComponents(month: -2)),
        (targetString: "PT168H120M", expectedResult: DateComponents(hour: 168, minute: 120)),
        (targetString: "pt168h120m", expectedResult: DateComponents(hour: 168, minute: 120)),
        (targetString: "Norman", expectedResult: nil),
        (targetString: "T168H120M", expectedResult: nil),
        (targetString: "P-20M", expectedResult: nil),
        (targetString: "P20MT", expectedResult: nil),
        (targetString: "P1YM5D", expectedResult: nil),
        (targetString: "P15.5Y", expectedResult: nil),
        (targetString: "P1D2H", expectedResult: nil),
        (targetString: "1Y2M", expectedResult: nil),
        (targetString: "P2M1Y", expectedResult: nil),
        (targetString: "P", expectedResult: nil),
        (targetString: "PT15.S", expectedResult: nil),
        (targetString: "", expectedResult: nil)
    ]
    
    func runTest(_ inTestTuple: TestTuple) {
        if let testComponents = inTestTuple.targetString.asXMLDuration, let expectedResult = inTestTuple.expectedResult {
            XCTAssertEqual(testComponents, expectedResult, "Unexpected result")
        }
    }
    
    func testBasics() {
        type(of: self).testSequence.forEach {
            runTest($0)
        }
    }
}
