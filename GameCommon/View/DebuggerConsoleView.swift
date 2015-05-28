// DebuggerConsoleView.swift
//  GameSwift
//
//  Created by eandrade21 on 4/10/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

struct DebuggerConsoleView: Printable {

    var elements = [String:[StageLocation]]()
    var viewElements: [[String]]
    var cols = 0
    var rows = 0

    var description: String {
        var desc = ""

        for rowIndex in 0..<rows {
            let row = viewElements[rowIndex]
            var rowStr = ""
            for colIndex in 0..<cols {
                rowStr += row[colIndex]
            }
            desc += rowStr + "\n"
        }
        return desc.substringToIndex(desc.endIndex.predecessor())
    }

    init(cols: Int, rows: Int) {
        if cols > 0 { self.cols = cols }
        if rows > 0 { self.rows = rows }

        viewElements = [[String]]()
            var row = [String](count: self.cols, repeatedValue: " ")
            for _ in 0..<self.rows {
            viewElements.append(row)
        }
    }

    mutating func updateCoordinate(col: Int, _ row: Int, _ str: String) {
        if row >= 0 && row < rows && col >= 0 && col < cols {
            viewElements[row][col] = str
        }
    }

    mutating func updateElment(element: StageElement) {

        if let locations = elements[element.elementID] {
            locations.map() {
                self.updateCoordinate($0.x, $0.y, " ")
            }
        }

        element.locations.map() {
            self.updateCoordinate($0.x, $0.y, element.locationDesc)
        }

        elements[element.elementID] = element.locations

    }
}