//
//  unit.swift
//  Geofencing-GoogleMaps
//
//  Created by MacBook on 02/11/16.
//  Copyright © 2016 iTexico. All rights reserved.
//

import XCTest

class unit: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        var target = UIATarget.localTarget();
        
        // speed is in meters/sec
        var points = [
            {location:{latitude:48.8899,longitude:14.2}, options:{speed:8, altitude:200, horizontalAccuracy:10, verticalAccuracy:15}},
            {location:{latitude:48.8899,longitude:14.9}, options:{speed:11, altitude:200, horizontalAccuracy:10, verticalAccuracy:15}},
            {location:{latitude:48.8899,longitude:14.6}, options:{speed:12, altitude:200, horizontalAccuracy:10, verticalAccuracy:15}},
            {location:{latitude:48.8899,longitude:14.7}, options:{speed:13, altitude:200, horizontalAccuracy:10, verticalAccuracy:15}},
            {location:{latitude:49.2,longitude:14.10}, options:{speed:15, altitude:200, horizontalAccuracy:10, verticalAccuracy:15}},
            {location:{latitude:49.4,longitude:14.8}, options:{speed:15, altitude:200, horizontalAccuracy:10, verticalAccuracy:15}},
            {location:{latitude:48.8899,longitude:14.9}, options:{speed:9, altitude:200, horizontalAccuracy:10, verticalAccuracy:15}},
            {location:{latitude:48.8899,longitude:15.1}, options:{speed:8, altitude:200, horizontalAccuracy:10, verticalAccuracy:15}},
            {location:{latitude:48.8899,longitude:16.1}, options:{speed:3, altitude:200, horizontalAccuracy:10, verticalAccuracy:15}},
            ];
        
        for (var i = 0; i < points.length; i++)
        {
            target.setLocationWithOptions(points[i].location,points[i].options);
            target.captureScreenWithName(i+"_.png");
            target.delay(1.0);
        }
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
