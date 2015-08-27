//
//  RegExTests.swift
//  Linchi
//
//  Created by Loïc Lecrenier on 8/23/15.
//  Copyright © 2015 Loïc Lecrenier. All rights reserved.
//

import XCTest
@testable import Linchi

class RegExTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testMatches() {
        
        let all : [(re: RegEx, match: String, dontmatch: String)] = [
            (RegEx("[a-zA-Z]+")!, "HelloWorld", "Hello World"),
            (RegEx("[a-zA-Z]?")!, "", "&"),
            (RegEx("static")!, "static", "static "),
            (RegEx("[abc]+")!, "aa", "ef")
        ]
        all.forEach {
            XCTAssertTrue($0.re.matches($0.match))
            XCTAssertFalse($0.re.matches($0.dontmatch))
        }
        
        let dontCompile : [String] = ["[a-Z]"]
        dontCompile.forEach {
            XCTAssertTrue(RegEx($0) == nil)
        }
    }
}
