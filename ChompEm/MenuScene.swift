//
//  MenuScene.swift
//  amoebaProject
//
//  Created by Camilla Schmidt on 25/06/15.
//  Copyright (c) 2015 Paulo Ricardo Ramos da Rosa. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene
{
    var menuView: SKView?
    var mainView: UIView?
    
    var playButton: SKNode! = nil
    var scoreButton: SKNode! = nil
    var howButton: SKNode! = nil
    
    
    override func didMoveToView(view: SKView)
    {
        
        //Criando a view
        self.menuView = SKView(frame: CGRectMake(self.frame.size.width/4, self.frame.size.height/4,
            self.frame.size.width/2, self.frame.size.height/2))
        
        //let menuV = SKScene(size: self.frame.size.width/2, self.frame.size.height/2))
        
        //self.menuView!.presentScene(MenuScene);
        
        let leftMargin = view.bounds.width/4
        let topMargin = view.bounds.height/4
        
        let backgroundImg = SKSpriteNode(imageNamed: "Fundo_Ipad")
        backgroundImg.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
        backgroundImg.size = CGSize(width: self.frame.size.width, height: self.frame.size.height)
        self.addChild(backgroundImg)
        
                
        let titleImg = SKSpriteNode(imageNamed: "Chompem")
        titleImg.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 * 0.22)
        self.addChild(titleImg)
        titleImg.xScale = 0.8
        titleImg.yScale = 0.8
        let player = SKSpriteNode(imageNamed: randomPlayerColor() as! String)
        player.position = CGPointMake(self.frame.size.width/2 * 0.4, self.frame.size.height * 0.3)
        self.addChild(player)
        
        //Opcoes do menu
        
        playButton = SKSpriteNode(imageNamed:"playbutton")
        playButton.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 * 1.7)
        self.addChild(playButton)
        
        scoreButton = SKSpriteNode(imageNamed:"scorebutton")
        scoreButton.position = CGPointMake(self.frame.size.width/2, playButton.position.y - 80)//self.frame.size.height/2 * 1.38)
        self.addChild(scoreButton)
        
        howButton = SKSpriteNode(imageNamed:"howbutton")
        howButton.position = CGPointMake(self.frame.size.width/2, scoreButton.position.y - 80)//self.frame.size.height/2 * 1.15);
        self.addChild(howButton)
        
    }
    
    func randomPlayerColor()->NSString{
        var randomNumber = Int(arc4random_uniform(3))
        if(randomNumber == 0){
            return "amoebaV_00"
        }else if (randomNumber == 1){
            return "amoebaVerde_00"
        }else {
            return "amoebaL_00"
        }
    }
    
    
    //tocar nos botoes
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        // Loop over all the touches in this event
        for touch: AnyObject in touches
        {
            // Get the location of the touch in this scene
            let location = touch.locationInNode(self)
            // Check if the location of the touch is within the button's bounds
            
            //PLAY BUTTON
            
            if playButton.containsPoint(location)
            {
                let skView = mainView as! SKView
                
                let gameScene = GameScene(size: skView.bounds.size)
                gameScene.scaleMode = SKSceneScaleMode.AspectFill
                
                skView.presentScene(gameScene)
                
                self.removeFromParent()
            }
                
            //SCORE BUTTON
                
            else if scoreButton.containsPoint(location)
            {
                var game: GameViewController = self.view?.window?.rootViewController as! GameViewController
                game.showLeaderboard()
//                let skView = mainView as! SKView
//                
//                let gameScene = ScoreScene(size: skView.bounds.size)
//                gameScene.registerView(mainView!)
//                gameScene.scaleMode = SKSceneScaleMode.AspectFill
//                skView.presentScene(gameScene)
//                
//                self.removeFromParent()
            }
                
            //HOW TO PLAY BUTTON
                
            else if howButton.containsPoint(location)
            {
                let skView = mainView as! SKView
                
                let gameScene = HowToPlayScene(size: skView.bounds.size)
                gameScene.registerView(mainView!)
                gameScene.scaleMode = SKSceneScaleMode.AspectFill
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
