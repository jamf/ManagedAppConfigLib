/*
    SPDX-License-Identifier: MIT
    Copyright (c) 2017-2022 Jamf Open Source Community
*/

import ManagedAppConfigLib
import XCTest

final class AppConfigPlainTests: XCTestCase {
    func testBoolOptional() throws {
        @AppConfigPlain("enabled") var enabled: Bool?
        @AppConfigPlain("isNil") var stillNil: Bool? = false

        XCTAssertNil(enabled)
        XCTAssertNil(stillNil, "Default values for optionals to @AppConfig and @AppConfigPlain are ignored.")
    }

    func testBoolWithDefault() throws {
        @AppConfigPlain("enabled") var enabled = true

        XCTAssertTrue(enabled)
    }

    func testIntOptional() throws {
        @AppConfigPlain("how_many") var count: Int?

        XCTAssertNil(count)
    }

    func testIntWithDefault() throws {
        @AppConfigPlain("how_many") var count = 3

        XCTAssertEqual(count, 3)
    }

    func testDoubleOptional() throws {
        @AppConfigPlain("cost") var cost: Double?

        XCTAssertNil(cost)
    }

    func testDoubleWithDefault() throws {
        @AppConfigPlain("cost") var cost = 3.0

        XCTAssertEqual(cost, 3.0)
    }

    func testStringOptional() throws {
        @AppConfigPlain("name") var lastName: String?

        XCTAssertNil(lastName)
    }

    func testStringWithDefault() throws {
        @AppConfigPlain("name") var lastName = "robert"

        XCTAssertEqual(lastName, "robert")
    }

    func testURLOptional() throws {
        @AppConfigPlain("site") var site: URL?

        XCTAssertNil(site)
    }

    func testURLWithDefault() throws {
        @AppConfigPlain("site") var site = URL(fileURLWithPath: "/Library/")

        XCTAssertEqual(site, URL(fileURLWithPath: "/Library/"))
    }

    func testDataOptional() throws {
        @AppConfigPlain("info") var data: Data?

        XCTAssertNil(data)
    }

    func testDataWithDefault() throws {
        @AppConfigPlain("info") var data = "some".data(using: .utf8)!

        XCTAssertEqual(data, "some".data(using: .utf8)!)
    }

    // MARK: - Actual data tests

    func testStringConfigValue() throws {
        // given
        let defaults = UserDefaults()
        defaults.register(defaults: [ManagedAppConfig.configurationKey: ["theKey": "some"]])

        // when
        @AppConfigPlain("theKey", store: defaults) var actualOptional: String?
        @AppConfigPlain("theKey", store: defaults) var actualWithDefault = "what"
        @AppConfigPlain("theKey") var shouldBeEmpty: String?
        @AppConfigPlain("theKey") var shouldBeDefault = "hello"

        // then
        XCTAssertEqual(actualOptional, "some", "Should pick up value from AppConfigPlain")
        XCTAssertEqual(actualWithDefault, "some", "Should pick up value from AppConfigPlain and not use the default")
        XCTAssertNil(shouldBeEmpty)
        XCTAssertEqual(shouldBeDefault, "hello")
    }

    func testUpdatingConfigValues() throws {
        // given
        let defaults = UserDefaults()
        defaults.register(defaults: [ManagedAppConfig.configurationKey: ["theKey": "first"]])
        @AppConfigPlain("theKey", store: defaults) var actualWithDefault = "what"
        XCTAssertEqual(actualWithDefault, "first")

        // when
        defaults.register(defaults: [ManagedAppConfig.configurationKey: ["theKey": "second"]])

        // then
        XCTAssertEqual(actualWithDefault, "second")
    }
}
