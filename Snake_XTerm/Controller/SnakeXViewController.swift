//
//  SnakeXViewController.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/30/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

class SnakeXViewController {

    // Properties
    var stageViewTransform: StageXViewTransform!
    var stageView: StageXView!
    
    var stageConfigurator: StageConfigurator!
    var stage: Stage!
    
    // Initializers
    init(){
        setUpModel()
        setUpView()
        
        waitForInput()
    }
    
    func setUpModel() {
        
        stageConfigurator = StageConfiguratorLevel1(size: stageSize)
        stage = Stage.sharedStage
        stage.configurator = stageConfigurator
        
        
    }
    
    func setUpView() {
        
        stageViewTransform = StageXViewTransform(stageSize: stageSize)
        stageView = StageXView(viewTransform: stageViewTransform)
        drawViews()
    }
    
    func drawViews() {
        stageView.drawElements(Obstacle.className(), inStage: stage)
    }
    
    func waitForInput() {
        sleep(10)
    }

}
