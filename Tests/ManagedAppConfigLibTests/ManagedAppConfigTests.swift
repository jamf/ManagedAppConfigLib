/*
    SPDX-License-Identifier: MIT
    Copyright (c) 2017-2026 Jamf
*/

@testable import ManagedAppConfigLib
import XCTest

final class ManagedAppConfigTests: XCTestCase {
    // `ManagedAppConfig` reads and writes `UserDefaults.standard` directly, so each test seeds and
    // then clears the two well-known keys to avoid leaking state between tests.
    private let configurationKey = ManagedAppConfig.configurationKey
    private let feedbackKey = ManagedAppConfig.feedbackKey

    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: configurationKey)
        UserDefaults.standard.removeObject(forKey: feedbackKey)
        super.tearDown()
    }

    // MARK: - Key constants

    func testPublicKeyConstants() {
        XCTAssertEqual(ManagedAppConfig.configurationKey, "com.apple.configuration.managed")
        XCTAssertEqual(ManagedAppConfig.feedbackKey, "com.apple.feedback.managed")
    }

    func testSharedIsSingleton() {
        XCTAssertTrue(ManagedAppConfig.shared === ManagedAppConfig.shared)
    }

    // MARK: - Configuration getter

    func testGetConfigValueReturnsValueFromStandardDefaults() {
        UserDefaults.standard.set(["deviceId": "abc123"], forKey: configurationKey)

        let sut = ManagedAppConfig()

        XCTAssertEqual(sut.getConfigValue(forKey: "deviceId") as? String, "abc123")
    }

    func testGetConfigValueReturnsNilForMissingKey() {
        UserDefaults.standard.set(["deviceId": "abc123"], forKey: configurationKey)

        let sut = ManagedAppConfig()

        XCTAssertNil(sut.getConfigValue(forKey: "notThere"))
    }

    func testGetConfigValueReturnsNilWhenNoDictionary() {
        let sut = ManagedAppConfig()

        XCTAssertNil(sut.getConfigValue(forKey: "anything"))
    }

    // MARK: - Feedback getter / setter round-trip

    func testUpdateValueCreatesFeedbackDictionaryWhenNoneExists() {
        // Hits the branch where no feedback dictionary exists yet and a fresh one is created.
        let sut = ManagedAppConfig()

        sut.updateValue(42, forKey: "errorCount")

        XCTAssertEqual(sut.getFeedbackValue(forKey: "errorCount") as? Int, 42)
    }

    func testUpdateValueMergesIntoExistingFeedbackDictionary() {
        // Hits the branch where a feedback dictionary already exists and is updated in place.
        let sut = ManagedAppConfig()

        sut.updateValue(42, forKey: "errorCount")
        sut.updateValue("running", forKey: "state")

        XCTAssertEqual(sut.getFeedbackValue(forKey: "errorCount") as? Int, 42)
        XCTAssertEqual(sut.getFeedbackValue(forKey: "state") as? String, "running")
    }

    func testUpdateValueOverwritesExistingValueForKey() {
        let sut = ManagedAppConfig()

        sut.updateValue(1, forKey: "errorCount")
        sut.updateValue(2, forKey: "errorCount")

        XCTAssertEqual(sut.getFeedbackValue(forKey: "errorCount") as? Int, 2)
    }

    func testGetFeedbackValueReturnsNilWhenNoDictionary() {
        let sut = ManagedAppConfig()

        XCTAssertNil(sut.getFeedbackValue(forKey: "errorCount"))
    }

    // MARK: - Change hooks

    func testConfigChangedHookFiresWithConfigurationDictionary() {
        let sut = ManagedAppConfig()
        let expectation = expectation(description: "config hook called")
        expectation.assertForOverFulfill = false

        sut.addAppConfigChangedHook { config in
            if config["title"] as? String == "hello" {
                expectation.fulfill()
            }
        }

        // Writing to standard defaults posts `UserDefaults.didChangeNotification`, which the
        // observer set up in `ManagedAppConfig.init()` turns into a hook callback.
        UserDefaults.standard.set(["title": "hello"], forKey: configurationKey)

        wait(for: [expectation], timeout: 2.0)
    }

    func testFeedbackChangedHookFiresWithFeedbackDictionary() {
        let sut = ManagedAppConfig()
        let expectation = expectation(description: "feedback hook called")
        expectation.assertForOverFulfill = false

        sut.addAppFeedbackChangedHook { feedback in
            if feedback["errorCount"] as? Int == 7 {
                expectation.fulfill()
            }
        }

        sut.updateValue(7, forKey: "errorCount")

        wait(for: [expectation], timeout: 2.0)
    }
}
