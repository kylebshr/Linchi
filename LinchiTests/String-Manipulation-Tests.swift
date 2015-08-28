//
//  String-Manipulation-Tests.swift
//  Linchi
//
//  Created by Loïc Lecrenier on 8/23/15.
//  Copyright © 2015 Loïc Lecrenier. All rights reserved.
//

import XCTest
@testable import Linchi

class String_Manipulation_Tests : XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    private func testPercentEncoding(initial: String, percentEncodedWithUppercaseHexadecimalLetters expected: String) {
        XCTAssertEqual(initial.newByAddingPercentEncoding(), expected)
        XCTAssertEqual(expected.newByRemovingPercentEncoding(), initial)
        XCTAssertEqual(initial.newByAddingPercentEncoding().newByRemovingPercentEncoding(), initial)
        XCTAssertEqual(expected.newByRemovingPercentEncoding().newByAddingPercentEncoding(), expected)
    }
    
    func testPercentEncoding() {
        
        let misc : [(initial: String, afterAdding: String, beforeRemoving: String)] = [
            ("", "", ""),
            ("?", "%3F", "%3f"),
            ("Loïc", "Lo%C3%AFc", "%4co%c3%Afc"),
            ("%", "%25", "%25"),
            ("%%%", "%25%25%25", "%25%25%25"),
            ("∆", "%E2%88%86", "%e2%88%86"),
            ("∆∑", "%E2%88%86%E2%88%91", "%e2%88%86%e2%88%91"),
            ("\"\"", "\"\"", "%22%22"),
            ("%", "%25", "%"),
            ("%GF", "%25GF", "%GF"),
            ("%%", "%25%25", "%%"),
            ("%a", "%25a", "%a")
        ]
        
        misc.forEach {
            testPercentEncoding($0.initial, percentEncodedWithUppercaseHexadecimalLetters: $0.afterAdding)
            XCTAssertEqual($0.beforeRemoving.newByRemovingPercentEncoding(), $0.initial)
        }
        
        let reservedCharacters : [(initial: String, afterAdding: String)] = [
            (":", "%3A"), ("/", "%2F"), ("?", "%3F"), ("#", "%23"), ("[", "%5B"), ("]", "%5D"), ("@", "%40"),
            ("!", "%21"), ("$", "%24"), ("&", "%26"), ("'", "%27"), ("(", "%28"), (")", "%29"),
            ("*", "%2A"), ("+", "%2B"), (",", "%2C"), (";", "%3B"), ("=", "%3D"),
        ]
        
        reservedCharacters.forEach {
            testPercentEncoding($0.initial, percentEncodedWithUppercaseHexadecimalLetters: $0.afterAdding)
        }
    }
    
    
    func testNewByTrimmingCharactersContainedInString() {
        let tests : [(initial: String, trimming: String, expected: String)] = [
            ("", "", ""),
            ("", "a", ""),
            ("a", "", "a"),
            ("abcdaabbccdd", "abcd", ""),
            ("abababab", "a", "bbbb"),
            ("abcdabcd", "bc", "adad"),
            ("æ‡ÒÂê∂", "æ∂", "‡ÒÂê"),
        ]
        tests.forEach { XCTAssertEqual($0.initial.newByTrimmingCharactersContainedInString($0.trimming), $0.expected) }
    }
    
    func testSplit() {
        
        let tests : [(initial: String, separator: Character, expected: [String])] = [
            ("", "a", []),
            ("abcdef", "c", ["ab", "def"]),
            ("aaabbbaaa", "b", ["aaa", "aaa"]),
            ("bababab", "b", ["a", "a", "a"]),
        ]
        
        tests.forEach { XCTAssertEqual($0.initial.split($0.separator), $0.expected) }
    }

    func testSplitOnce() {
        let tests : [(initial: String, separator: Character, expected: (String, String)?)] = [
            ("", "c", nil), ("aa", "a", ("", "a")), ("baaaa", "a", ("b", "aaa")),
            ("a∂c", "∂", ("a", "c")), ("abcdef", "g", nil), ("s1=s2=s3", "=", ("s1", "s2=s3"))
        ]
        
        tests.forEach {
            let splitted = $0.initial.splitOnce($0.separator)
            XCTAssertEqual(splitted?.0, $0.expected?.0)
            XCTAssertEqual(splitted?.1, $0.expected?.1)
        }
    }
    
    func testNewByReplacingPlusesBySpaces() {
        
        let tests : [(initial: String, expected: String)] = [
            ("", ""), ("abc∂êƒ~Ï®†", "abc∂êƒ~Ï®†"), ("+++", "   "),
            ("Loïc+Jean Pierre+Ronald", "Loïc Jean Pierre Ronald")
        ]
        
        tests.forEach {
            XCTAssertEqual($0.initial.newByReplacingPlusesBySpaces(), $0.expected)
        }
        
    }
    
    func testRemoveFirst() {
        
        let tests : [(initial: String, n: Int, expected: String)] = [
            ("a", 0, "a"), ("a", 1, ""), ("a", 2, ""),
            ("Hello", 3, "lo"), ("∆: [a-zA-Z]*", 3, "[a-zA-Z]*")
        ]
        
        tests.forEach {
            XCTAssertEqual($0.0.removeFirst($0.1), $0.2)
        }
    }
    
    func testToUTF8Bytes() {
        
        let tests : [(initial: String, expected: [UInt8])] = [
            ("", []), ("abc", [97, 98, 99]), ("∂", [226, 136, 130]), ("`^¨ ", [96, 94, 194, 168, 32])
        ]
        
        tests.forEach {
            XCTAssertEqual($0.initial.toUTF8Bytes(), $0.expected)
        }
    }
    
    func testFromUTF8Bytes() {
        
        let tests : [String] = ["", "Hello world!", "îÌß”»"]
        
        tests.forEach {
            XCTAssertEqual(String.fromUTF8Bytes($0.toUTF8Bytes()), $0)
        }
    }
    
    func testContains() {
        
        let tests : [(string: String, character: Character, expected: Bool)] = [
            ("", "c", false), ("é", "e", false), ("è", "`", false), ("é", "é", true),
            ("abcdef", "d", true), ("abcabc", "a", true), ("ah∂", "∂", true)
        ]
        
        tests.forEach {
            XCTAssertEqual($0.string.contains($0.character), $0.expected)
        }
        
    }
    
}














