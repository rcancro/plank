//
//  ObjectiveCIRTests.swift
//  CoreTests
//
//  Created by Rahul Malik on 7/23/17.
//

import XCTest

@testable import Core

class ObjectiveCIRTests: XCTestCase {
    func testDirtyPropertyOption() {
        let optionName = dirtyPropertyOption(propertyName: "prop", className: "class")
        XCTAssertEqual(optionName, "classDirtyPropertyProp")
    }

    func testDirtyPropertyOptionMultiWord() {
        let optionName = dirtyPropertyOption(propertyName: "some_prop", className: "class")
        XCTAssertEqual(optionName, "classDirtyPropertySomeProp")
    }

    func testEnumTypeName() {
        XCTAssertEqual(enumTypeName(propertyName: "some_prop_type", className: "class"), "classSomePropType")
    }

    func testEnumToStringName() {
        XCTAssertEqual(enumToStringMethodName(propertyName: "some_prop_type", className: "class"), "classSomePropTypeToString")
    }

    func testEnumFromStringName() {
        XCTAssertEqual(enumFromStringMethodName(propertyName: "some_prop_type", className: "class"), "classSomePropTypeFromString")
    }

    func testStatementSyntax() {
        XCTAssertEqual(
            ObjCIR.stmt("[hello world]"),
            "[hello world];"
        )
    }

    func testMsgSyntax() {
        let expected = "[someVar parameter:arg parameter2:arg2]"
        let actual = ObjCIR.msg("someVar", ("parameter", "arg"), ("parameter2", "arg2"))
        XCTAssertEqual(expected, actual)
    }

    func testBlockSyntax() {
        let actual = ObjCIR.block(["num1", "num2"]) {
            [
                "return num1 + num2;",
            ]
        }
        let expected = [
            "^(num1, num2){",
            "\treturn num1 + num2;",
            "}",
        ].joined(separator: "\n")
        XCTAssertEqual(expected, actual)
    }

    func testScopeSyntax() {
        let expected = [
            "{",
            "int x = 1;".indent(),
            "x--;".indent(),
            "x++;".indent(),
            "}",
        ].joined(separator: "\n")

        let actual = ObjCIR.scope { [
            "int x = 1;",
            "x--;",
            "x++;",
        ] }
        XCTAssertEqual(expected, actual)
    }

    func testNestedScopeSyntax() {
        let expected = [
            "{",
            "int x = 1;".indent(),
            "{".indent(),
            "x--;".indent().indent(),
            "}".indent(),
            "x++;".indent(),
            "}",
        ].joined(separator: "\n")

        let actual = ObjCIR.scope { [
            "int x = 1;",
            ObjCIR.scope { [
                "x--;",
            ] },
            "x++;",
        ] }

        XCTAssertEqual(expected, actual)
    }

    func testIfStmt() {
        let expected = [
            "if (x > 0) {",
            "return true;".indent(),
            "}",
        ].joined(separator: "\n")

        let actual = ObjCIR.ifStmt("x > 0") { [
            "return true;",
        ] }

        XCTAssertEqual(expected, actual)
    }

    func testElseIfStmt() {
        let expected = [
            " else if (x > 0) {",
            "return true;".indent(),
            "}",
        ].joined(separator: "\n")

        let actual = ObjCIR.elseIfStmt("x > 0") { [
            "return true;",
        ] }

        XCTAssertEqual(expected, actual)
    }

    func testElseStmt() {
        let expected = [
            " else {",
            "return true;".indent(),
            "}",
        ].joined(separator: "\n")

        let actual = ObjCIR.elseStmt { [
            "return true;",
        ] }

        XCTAssertEqual(expected, actual)
    }

    func testIfElseStmt() {
        let expected = [
            "if (x > 0) {",
            "return true;".indent(),
            "} else {",
            "return false;".indent(),
            "}",
        ].joined(separator: "\n")
        let actual = ObjCIR.ifElseStmt("x > 0") { [
            "return true;",
        ] } { [
            "return false;",
        ] }
        XCTAssertEqual(expected, actual)
    }

    func testMethod() {
        let expected = [
            "- (id)method",
            "{",
            "\treturn nil",
            "}",
        ]
        let actual = ObjCIR.method("- (id)method") {
            ["return nil"]
        }.render()
        XCTAssertEqual(expected, actual)
    }

    func testMethodDebug() {
        let expected = [
            "#if DEBUG",
            "- (id)method",
            "{",
            "\treturn nil",
            "}",
            "#endif",
        ]
        let actual = ObjCIR.method("- (id)method", debug: true) {
            ["return nil"]
        }.render()
        XCTAssertEqual(expected, actual)
    }

    func testFileImport() {
        XCTAssertEqual("#import \"include/ModelClass.h\"", ObjCIR.fileImportStmt("ModelClass", headerPrefix: "include/"))
        XCTAssertEqual("#import \"ModelClass.h\"", ObjCIR.fileImportStmt("ModelClass", headerPrefix: nil))
    }

    func testImportsImplementationWithTrailingSpace() {
        let imports = ObjCIR.Root.imports(classNames: Set(["MyClass "]), myName: "MyClass", parentName: nil)
        let output = imports.renderImplementation(GenerationParameters())
        XCTAssertEqual(1, output.count)
        XCTAssertEqual("#import \"MyClass.h\"", output[0])
    }
}
