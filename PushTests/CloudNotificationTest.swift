//
//  CloudNotificationTest.swift
//  Mort's Minions
//
//  Created by Dan Bellinski on 2/29/16.
//  Copyright © 2016 Dan Bellinski. All rights reserved.
//

import XCTest

class CloudNotificationTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /*
    
    NSNotificationCenter.defaultCenter().addObserver(self,
    selector: "ubiquitousKeyValueStoreDidChangeExternally",
    name:  NSUbiquitousKeyValueStoreDidChangeExternallyNotification,
    object: NSUbiquitousKeyValueStore.defaultStore())

    */

    func testExample() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "NSUbiquitousKeyValueStoreDidChangeExternallyNotification"),object: nil);
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
