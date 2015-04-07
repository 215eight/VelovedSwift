//
//  StageXView.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/30/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

class StageXView {
    
    // MARK: Properties
    let viewTransform: StageXViewTransform
    var delegate: StageXViewDelegate?
    var waitForInput = true
    
    // MARK: Initializer
    init(viewTransform: StageXViewTransform) {
        self.viewTransform = viewTransform
        
        initNCurses()
    }

    func initNCurses() {

        setlocale(LC_ALL, "")
        initscr()                   // Start curses mode
        cbreak()                    // Line buffering disabled
        noecho()                    // Don't echo() while we do getch
        nonl()                      // Disable newline mode
        intrflush(stdscr, false)    // Prevent flush
        curs_set(0)                 // Set cursor to invisible
        //nodelay(stdscr, true)
        
        let result = resizeterm(64, 112)
    }
    
    deinit {
        endwin()
    }
    
    func destroy() {
        endwin()
    }
    
    // MARK: Instance methods
    
    func drawElements(elementType: String, inStage stage: Stage) {
        
        clear()
        
        for (elementType, elements) in stage.elements {
            
            let elementsLocations = elements.map() { $0.locations }
            for elementLocations in elementsLocations {
                
                for elementLocation in elementLocations {
                    
                    let elementFrame = viewTransform.getFrame(elementLocation)
                    
                    var elementChar: String
                    switch elementType {
                    case "Obstacle":
                        elementChar = "+"
                    case "Apple":
                        elementChar = "@"
                    case "Sanke":
                        elementChar = "#"
                    default:
                        elementChar = "#"
                    }
                    
                    printFrame(elementFrame, elementChar:elementChar)
                }
            }
            
        }
        
        refresh()
    }
    
    func printFrame(elementFrame: CGRect, elementChar: String) {
        
        let x = Int32(elementFrame.origin.x)
        let y = Int32(elementFrame.origin.y)
        
        let width = Int(elementFrame.size.width)
        let height = Int(elementFrame.size.height)
        
        for var i = 0; i<height; i++ {
            for var j = 0; j<width; j++ {
                mvaddch(y+j, x+i, charUnicodeValue(elementChar))
            }
        }
    }
    
    func startCapturingInput() {
        
        var key: Int32 = 0
        while waitForInput {
            
            key = getch()
            if key != ERR {
                delegate?.interpretKey(key)
            }
        }
    }
    
    func stopCapturingInput() {
        waitForInput = false
    }
}

protocol StageXViewDelegate {
    func interpretKey(key: Int32)
}