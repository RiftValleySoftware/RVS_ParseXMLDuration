# ``RVS_ParseXMLDuration``

This set of extensions allows us to easily parse duration values, as expressed in XML documents that expect their duration values to be in the standard xsd:duration format.

## Overview

[This page does a fairly good job of explaining the format.](http://www.datypic.com/sc/xsd/t-xsd_duration.html)

## What Problem Does This Solve?

The duration format has a number of ways that it can be expressed, and this set of extensions should allow us to deal with all of them. It will be most useful integrated into an XML parser.
It will read a duration from a [String](https://developer.apple.com/documentation/swift/string) instance, and return a [DateComponents](https://developer.apple.com/documentation/foundation/datecomponents) instance, representing the duration in that String.
You can also do the reverse, and take a DateComponents instance, and express it as a properly-formatted xsd:duration String.

## Requirements

It should work fine for osx, tvOS and iOS. It only depends on the Swift Foundation library.

This requires Swift Version 4.0 or above (tested with 4.2).

## Where to Get

[Here is the GitHub Repo for This Project.](https://github.com/RiftValleySoftware/RVS_ParseXMLDuration)

[Here is the online documentation page for this project.](https://riftvalleysoftware.com/work/open-source-projects/#RVS_ParseXMLDuration)

## Usage

### Include the Source in Your Project

This is a simple source file; not a module.

To use this, simply add the [RVS_ParseXMLDuration/RVS_ParseXMLDuration.swift](https://github.com/RiftValleySoftware/RVS_ParseXMLDuration/blob/master/RVS_ParseXMLDuration/RVS_ParseXMLDuration.swift) file to your project; copying it wherever you want.

This will add one function: `asXMLDuration`, to the [String](https://developer.apple.com/documentation/swift/string) struct, and to the [DateComponents](https://developer.apple.com/documentation/foundation/datecomponents) struct.

The String variant will return an optional DateComponents result (a parsed string), and the DateComponents variant will return an optional String (a properly-formatted xsd:duration string).

All the rest of the stuff is for testing, validating and sharing.

### A Few Rules:

The string is formatted as `[\-]P[|0-9|*Y][|0-9|*M][|0-9|*D][T[|0-9|*H][|0-9|*M][|0-9|*[\.|0-9|*]S]]`

The first character **MUST** be a `"P"`, and any negative sign must **PRECEDE** the `"P"`.

Any time (hours, minutes, seconds), **MUST** be preceded by a `"T"`. This either starts the time, or separates it from a date.

For example, `P2Y6M5DT12H35M30S` is 2 years, 6 months, 5 days, 12 hours, 35 minutes and 30 seconds.

For our purposes, when a unit is not specified, we don't include it at all in the DateComponents. If the unit is specified, but is a zero (0), then we specify that unit as zero in the DateComponents.

### Examples

Not much to show, really. The parser is ridiculously easy to use.

**Parsing From A String:**

Each part is composed of 1 or more decimal digits, immediately succeeded by "Y" (years), "M" (months or minutes), "D" (days), "H" (hours), or "S" (seconds). Seconds can be expressed as a decimal. All other numbers are integers.

    let durationComponents1 = "P2Y6M5DT12H35M30.123S".asXMLDuration // DateComponents(year: 2, month: 6, day: 5, hour: 12, minute: 35, second: 30, nanosecond: 1230000000)
    
You can have more than 59 minutes or 23 hours.

    let durationComponents2 = "PT168H120M".asXMLDuration            // DateComponents(hour: 168, minute: 120)
    
In order to have a negative duration, the first character must be a minus sign, and ALL components in the result will be negative.

    let durationComponents3 = "-P2M4DT10M5.23S".asXMLDuration       // DateComponents(month: -2, day: -4, minute: -10, second: -5, nanosecond: -2300000000)

**Delivering A String From A DateComponents Instance:**

Zero (or unspecified) components are not included in the resultant String.

    let durationString1 = DateComponents(year: 0, day: 1, hour: 1, minute: 0, second: 1, nanosecond: 0).asXMLDuration // "P1DT1H1S"

Note that fractional seconds are expressed as seconds and nanoseconds.

    let durationString2 = DateComponents(year: 1, month: 1, day: 1, hour: 1, minute: 1, second: 1, nanosecond: 1000000000).asXMLDuration // "P1Y1M1DT1H1M1.1S"

In order to specify a negative duration, ALL components must be negative.

    let durationString3 = DateComponents(year: -1, month: -1, day: -1, hour: -1, minute: -1, second: -1, nanosecond: -1000000000).asXMLDuration // "-P1Y1M1DT1H1M1.1S"

## DEPENDENCIES

There are no dependencies to use RVS_ParseXMLDuration in your project. In order to test it and run it in the module project, you should use [CocoaPods](https://cocoapods.org) to install [SwiftLint](https://cocoapods.org/pods/SwiftLint), although that is not required. It's [just good practice](https://littlegreenviper.com/series/swiftwater/swiftlint/).

## LICENSE

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


[The Great Rift Valley Software Company: https://riftvalleysoftware.com](https://riftvalleysoftware.com)

