//
//  HowToPlayScene.swift
//  amoebaProject
//
//  Created by Camilla Schmidt on 25/06/15.
//  Copyright (c) 2015 Paulo Ricardo Ramos da Rosa. All rights reserved.
//

import SpriteKit

class HowToPlayScene: SKScene
{
    var menuView: SKView?
    var mainView: UIView?
    
    var backButton: SKNode! = nil
    var nextButton: SKNode! = nil
    var redoButton: SKNode! = nil
    
    var myLabel: SKLabelNode = SKLabelNode()
    var myLabel2: SKLabelNode = SKLabelNode()
    var myLabel3: SKLabelNode = SKLabelNode()
    
    var gambi: Int! = 0
    
    override func didMoveToView(view: SKView)
    {
        //Criando a view
        self.menuView = SKView(frame: CGRectMake(self.frame.size.width/4, self.frame.size.height/4,
            self.frame.size.width/2, self.frame.size.height/2))
        
        let leftMargin = view.bounds.width/4
        let topMargin = view.bounds.height/4
        
        let backgroundImg = SKSpriteNode(imageNamed: "blur")
        backgroundImg.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
        self.addChild(backgroundImg)
        
        backButton = SKSpriteNode(imageNamed:"how+back")
        backButton.position = CGPoint(x:CGRectGetMidX(self.frame), y:self.frame.size.height-28);
        self.addChild(backButton)
        
        let tutorial = SKSpriteNode(imageNamed: "pagina1")
        tutorial.position = CGPointMake(self.frame.size.width/2, (self.frame.size.height/2)+30)
        self.gambi = 1
        self.addChild(tutorial)
        
        nextButton = SKSpriteNode(imageNamed:"setacont")
        nextButton.position = CGPointMake((self.frame.size.width/2)+160, (self.frame.size.height/2)+30)
        self.addChild(nextButton)
        
        redoButton = SKSpriteNode(imageNamed:"seta")
        redoButton.position = CGPointMake((self.frame.size.width/2)-160, (self.frame.size.height/2)+30)
        self.addChild(redoButton)
        redoButton.hidden = true
        
        myLabel = SKLabelNode(fontNamed:"Noteworthy")
        myLabel.text = "Chompy is hungry"
        myLabel.fontSize = 25;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)/4 + 70);
        self.addChild(myLabel)
        
        myLabel2 = SKLabelNode(fontNamed:"Noteworthy")
        myLabel2.text = "and needs to eat lots" //"e precisa comer muitos"
        myLabel2.fontSize = 25;
        myLabel2.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)/4 + 30);
        self.addChild(myLabel2)
        
        myLabel3 = SKLabelNode(fontNamed:"Noteworthy")
        myLabel3.text = "of yummies" //"yummies"
        myLabel3.fontSize = 25;
        myLabel3.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)/4 - 10);
        self.addChild(myLabel3)
        
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
            
                
            else if nextButton.containsPoint(location)
            {
                if(gambi == 1)
                {
                    let tutorial1 = SKSpriteNode(imageNamed: "pagina2")
                    tutorial1.position = CGPointMake(self.frame.size.width/2, (self.frame.size.height/2)+30)
                    self.gambi = 2
                    self.addChild(tutorial1)
                    redoButton.hidden = false;
                    nextButton.hidden = false;

                    myLabel.text = "Chompy feeds" //"Chompy se alimenta"
                    myLabel2.text = "only from yummies" //"somente de yummies que"
                    myLabel3.text = "that form his color" //"formam sua cor"
                    
                }
                
                else if(gambi == 2)
                {
                    
                    let tutorial2 = SKSpriteNode(imageNamed: "pagina3")
                    tutorial2.position = CGPointMake(self.frame.size.width/2, (self.frame.size.height/2)+30)
                    self.gambi = 3
                    self.addChild(tutorial2)
                    nextButton.hidden = true;
                    redoButton.hidden = false;
                    
                    myLabel.text = "Watch out!" //"Cuidado!"
                    myLabel2.text = "Chompy can miss yummies'" //"Chompy só pode errar"
                    myLabel3.text = "colors only 3 times" //"de yummy 3 vezes"
                
                    runAction(SKAction.sequence([
                        SKAction.waitForDuration(1.0),
                        SKAction.runBlock() {
                            
                            let tutorial3 = SKSpriteNode(imageNamed: "pagina4")
                            tutorial3.position = CGPointMake(self.frame.size.width/2, (self.frame.size.height/2)+30)
                            self.addChild(tutorial3)

                        }
                    ]))
                }
            }
                
                
            else if redoButton.containsPoint(location)
            {
                if(gambi == 2)
                {
                    let tutorial = SKSpriteNode(imageNamed: "pagina1")
                    tutorial.position = CGPointMake(self.frame.size.width/2, (self.frame.size.height/2)+30)
                    self.gambi = 1
                    self.addChild(tutorial)
                    redoButton.hidden = true
                    nextButton.hidden = false
                    
                    myLabel.text = "Chompy is hungry" //"Chompy está com fome"
                    myLabel2.text = "and needs to eat lots" //"e precisa comer muitos"
                    myLabel3.text = "of yummies" //"yummies"
                }
                else if(gambi == 3)
                {
                    let tutorial1 = SKSpriteNode(imageNamed: "pagina2")
                    tutorial1.position = CGPointMake(self.frame.size.width/2, (self.frame.size.height/2)+30)
                    self.gambi = 2
                    self.addChild(tutorial1)
                    redoButton.hidden = false
                    nextButton.hidden = false
                    
                    myLabel.text = "Chompy feeds" //"Chompy se alimenta"
                    myLabel2.text = "only from yummies" //"somente de yummies que"
                    myLabel3.text = "that form his color" //"formam sua cor"

                }

            }
            
        }
    }
    
    //registro que salva a view principal para ter onde criar a proxima scene
    
    func registerView(view:UIView)
    {
        mainView = view
    }
}