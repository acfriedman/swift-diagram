//
//  SwiftViewerTests.swift
//  SwiftViewerTests
//
//  Created by Andrew Friedman on 5/5/21.
//

import XCTest
@testable import SwiftDiagram

class SwiftViewerTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_map_inheritance_relationship_count() throws {
        
        let contents = """
            protocol TestProtocol {
             func dothing()
            }
            
            struct TestStruct: TestProtocol {
                func dothing() { }
            }
            """
        let declarations = try SwiftViewer.parse(contents).sorted { $0.name  < $1.name }
        XCTAssert(declarations[1].inheritance.count == 1)
    }
    
    func test_map_inheritance_relationship_name() throws {
        
        let contents = """
            protocol TestProtocol {
             func dothing()
            }
            
            struct TestStruct: TestProtocol {
                func dothing() { }
            }
            """
        let declarations = try SwiftViewer.parse(contents).sorted { $0.name  < $1.name }
        XCTAssert(declarations[1].inheritance[0] == "TestProtocol")
    }
    
    func test_map_child_relationship_single_child() throws {
        
        let contents = """
            protocol TestProtocol {
             func dothing()
            }
            
            struct TestStruct: TestProtocol {
                func dothing() { }
            }
            """
        let declarations = try SwiftViewer.parse(contents).sorted { $0.name  < $1.name }
        XCTAssert(declarations[0].name == "TestProtocol")
        XCTAssert(declarations[0].children[0] == "TestStruct")
        XCTAssert(declarations[0].children.count == 1)
    }
    
    func test_map_child_relationship_single_child_class() throws {
        
        let contents = """
            
            class BaseView: NSView { }
            class NextView: BaseView { }
            class NextViewTwo: NextView { }
            
            """
        let declarations = try SwiftViewer.parse(contents).sorted { $0.name  < $1.name }
        XCTAssert(declarations.count == 3)
        XCTAssert(declarations[0].name == "BaseView")
        XCTAssert(declarations[0].children[0] == "NextView")
        XCTAssert(declarations[0].children.count == 1)
        XCTAssert(declarations[0].inheritance.count == 1)
        
        XCTAssert(declarations[1].name == "NextView")
        XCTAssert(declarations[1].children[0] == "NextViewTwo")
        XCTAssert(declarations[1].children.count == 1)
        XCTAssert(declarations[1].inheritance.count == 1)
        
        XCTAssert(declarations[2].name == "NextViewTwo")
        XCTAssert(declarations[2].children.count == 0)
        XCTAssert(declarations[2].inheritance.count == 1)
    }
    
    func test_map_child_relationship_multiple_children() throws {
        
        let contents = """
            protocol TestProtocol {
             func dothing()
            }
            
            struct TestStructA: TestProtocol {
                func dothing() { }
            }
            
            struct TestStructB: TestProtocol {
                func dothing() { }
            }
            
            struct TestStructC: TestProtocol {
                func dothing() { }
            }
            """
        let declarations = try SwiftViewer.parse(contents).sorted { $0.name  < $1.name }
        XCTAssert(declarations[0].name == "TestProtocol")
        XCTAssert(declarations[0].children.count == 3)
    }
    
    func test_map_child_relationship_multiple_parents_children() throws {
        
        let contents = """
            protocol TestProtocol {
                func dothing()
            }
            
            protocol TestProtocolB {
                func dothingB()
            }
            
            struct TestStructA: TestProtocol, TestProtocolB {
                func dothing() { }
                func dothingB() { }
            }
            
            struct TestStructB: TestProtocol, TestProtocolB {
                func dothing() { }
                func dothingB() { }
            }
            
            struct TestStructC: TestProtocol {
                func dothing() { }
            }
            """
        let declarations = try SwiftViewer.parse(contents).sorted { $0.name  < $1.name }
        
        XCTAssert(declarations[0].name == "TestProtocol")
        XCTAssert(declarations[0].children.count == 3)
        ["TestStructA", "TestStructB", "TestStructC"].forEach {
            XCTAssert(declarations[0].children.contains($0))
        }
        
        XCTAssert(declarations[1].name == "TestProtocolB")
        XCTAssert(declarations[1].children.count == 2)
        ["TestStructA", "TestStructB"].forEach {
            XCTAssert(declarations[1].children.contains($0))
        }
        
        XCTAssert(declarations[2].name == "TestStructA")
        XCTAssert(declarations[2].children.count == 0)
        
        XCTAssert(declarations[3].name == "TestStructB")
        XCTAssert(declarations[3].children.count == 0)
        
        XCTAssert(declarations[4].name == "TestStructC")
        XCTAssert(declarations[4].children.count == 0)
    }
    
    func test_map_child_relationship_multiple_parents_children_multiple_files() throws {
        let testBundle = Bundle(for: type(of: self))
        let url1 = testBundle.url(forResource: "Test_1", withExtension: "swift")!
        let declarations = try SwiftViewer.parse([url1]).sorted { $0.name  < $1.name }
        
        XCTAssert(declarations.count == 3)
        XCTAssert(declarations[0].name == "BaseView")
        XCTAssert(declarations[0].children[0] == "NextView")
        XCTAssert(declarations[0].children.count == 1)
        XCTAssert(declarations[0].inheritance.count == 1)
        
        XCTAssert(declarations[1].name == "NextView")
        XCTAssert(declarations[1].children[0] == "NextViewTwo")
        XCTAssert(declarations[1].children.count == 1)
        XCTAssert(declarations[1].inheritance.count == 1)
        
        XCTAssert(declarations[2].name == "NextViewTwo")
        XCTAssert(declarations[2].children.count == 0)
        XCTAssert(declarations[2].inheritance.count == 1)
    }
}
