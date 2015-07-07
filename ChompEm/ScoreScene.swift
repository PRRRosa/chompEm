//
//  ScoreScene.swift
//  amoebaProject
//
//  Created by Camilla Schmidt on 25/06/15.
//  Copyright (c) 2015 Paulo Ricardo Ramos da Rosa. All rights reserved.
//

import SpriteKit

class ScoreScene: SKScene
{
    var menuView: SKView?
    var mainView: UIView?
    
    var backButton: SKNode! = nil
    
    override func didMoveToView(view: SKView)
    {
        //Criando a view
        self.menuView = SKView(frame: CGRectMake(self.frame.size.width/4, self.frame.size.height/4,
            self.frame.size.width/2, self.frame.size.height/2))
        
        let leftMargin = view.bounds.width/4
        let topMargin = view.bounds.height/4
        
        let backgroundImg = SKSpriteNode(imageNamed: "scoreFundo")
        backgroundImg.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
        self.addChild(backgroundImg)
        
        backButton = SKSpriteNode(imageNamed:"backButton")
        backButton.position = CGPoint(x:CGRectGetMidX(self.frame), y:200.0);
        self.addChild(backButton)
        
    }

    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        // Loop over all the touches in this event
        for touch: AnyObject in touches
        {
            // Get the location of the touch in this scene
            let location = touch.locationInNode(self)
            // Check if the location of the touch is within the button's bounds
            if backButton.containsPoint(location)
            {
                let skView = mainView as! SKView
                
                let gameScene = MenuScene(size: skView.bounds.size)
                gameScene.scaleMode = SKSceneScaleMode.AspectFill
                gameScene.registerView(mainView!)
                skView.presentScene(gameScene)
                
                self.removeFromParent()
            }
        }
    }
    
    //registro que salva a view principal para ter onde criar a proxima scene
    
    func registerView(view:UIView)
    {
        mainView = view
    }
    
}