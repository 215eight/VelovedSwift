//
//  SnakeView.swift
//  SnakeSwift
//
//  Created by eandrade21 on 2/2/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

class SnakeView {
    
    //Properties
    var stageWin : COpaquePointer
    var initMenuWin : COpaquePointer
    
    let stageBorder : Int32 = 1
    let initMenuWinOffset : Int32 = 2
    
    var stageHeight : Int {
        get{ return Int(LINES) }
    }
    
    var stageWidth : Int {
        get{ return Int(COLS) }
    }
    
    let snakeBodyChar : String = "#"
    
    //Methods
    init() {
        
        //Init ncurses
        setlocale(LC_ALL, "")
        initscr()                   // Start curses mode
        cbreak()                    // Line buffering disabled
        noecho()                    // Don't echo() while we do getch
        nonl()                      // Disable newline mode
        intrflush(stdscr, false)    // Prevent flush
        curs_set(0)                 // Set cursor to invisible
        
        stageWin = COpaquePointer()
        initMenuWin = COpaquePointer()

        stageWin  = newwin(LINES, COLS, 0, 0)
        initMenuWin = newwin(0, 0, 0, 0) //Not useful, only for init purposes
        
        keypad(stageWin, true)        // Enable keypad keys
        nodelay(stageWin, true)

    }
    
    deinit {
        delwin(initMenuWin)
        delwin(stageWin)
        endwin()
    }

    
    func printStage(stage:Stage) {
        
        if stage.hasWalls { box(stageWin, 0 ,0) }
        wrefresh(stageWin)
        
    }
    
    func printMenu(textOptions:[String]) ->  UnsafeMutablePointer<MENU> {
        
        var initMenu : UnsafeMutablePointer<MENU>
        
        var menuOptions : [UnsafeMutablePointer<ITEM>] = []
        var maxLengthTextOption = 0
        
        for text in textOptions {
            let textElements = countElements(text)
            if textElements > maxLengthTextOption { (maxLengthTextOption = textElements) }
            menuOptions.append(new_item(text.CString(),"".CString()))
        }
        
        menuOptions.append(UnsafeMutablePointer.null()) //Terminate the C array
        
        initMenu = new_menu(&menuOptions)
        
        
        initMenuWin = newwin(textOptions.count + initMenuWinOffset,
                          maxLengthTextOption + (initMenuWinOffset * 2) + 2,
                          (LINES - (textOptions.count + initMenuWinOffset)) / 2,
                          (COLS - (maxLengthTextOption + (initMenuWinOffset * 2))) / 2 )
        
        keypad(initMenuWin, true)
        
        set_menu_win(initMenu, initMenuWin)
        set_menu_sub(initMenu, derwin(initMenuWin,
                                      Int32(textOptions.count),
                                      Int32(maxLengthTextOption + (initMenuWinOffset * 2)),
                                      1,
                                      2))
        
        set_menu_mark(initMenu, "*")
        
        post_menu(initMenu)
        
        wborder(initMenuWin, CharacterUnicodeValue("|"),
                          CharacterUnicodeValue("|"),
                          CharacterUnicodeValue("-"),
                          CharacterUnicodeValue("-"),
                          CharacterUnicodeValue("+"),
                          CharacterUnicodeValue("+"),
                          CharacterUnicodeValue("+"),
                          CharacterUnicodeValue("+"))
        wrefresh(initMenuWin)
        
        return initMenu
    }
        
    func destroyMenu(menu:UnsafeMutablePointer<MENU>) {
        
        unpost_menu(menu)
        wborder(initMenuWin,
            CharacterUnicodeValue(" "),
            CharacterUnicodeValue(" "),
            CharacterUnicodeValue(" "),
            CharacterUnicodeValue(" "),
            CharacterUnicodeValue(" "),
            CharacterUnicodeValue(" "),
            CharacterUnicodeValue(" "),
            CharacterUnicodeValue(" "))
        
        wrefresh(initMenuWin)
        delwin(initMenuWin)

    }
    
    func destroyStage(){
        
        werase(stageWin)
        wrefresh(stageWin)
        delwin(stageWin)
        endwin()
        
    }
    
    func printSnake(snake: Snake){
        
        //Delete lastTailPoint 
        
        mvwaddch(stageWin, Int32(snake.lastTailPoint.y), Int32(snake.lastTailPoint.x), CharacterUnicodeValue(" "))
        
        //Print body again
        snake.body.map({
            [weak self] (point: Point) -> Int32 in
            
            return mvwaddch(self!.stageWin, Int32(point.y), Int32(point.x), CharacterUnicodeValue(self!.snakeBodyChar))
        })
        
        wrefresh(stageWin)
    }
    
    func printApple(appleLocation:Point) {
        
        mvwaddch(stageWin, Int32(appleLocation.y), Int32(appleLocation.x), CharacterUnicodeValue("*"))
        wrefresh(stageWin)
        
    }
    
    func cleanStage() {
        wclear(stageWin)
        wrefresh(stageWin)
    }

}
