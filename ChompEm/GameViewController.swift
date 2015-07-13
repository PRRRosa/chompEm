//
//  GameViewController.swift
//  amoebaProject
//
//  Created by Paulo Ricardo Ramos da Rosa on 6/17/15.
//  Copyright (c) 2015 Paulo Ricardo Ramos da Rosa. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit

extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController, GKGameCenterControllerDelegate {

    var playerIsAuthenticated = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*

        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }*/
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        setGameCenter()
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let skView = self.view as! SKView
        
        if skView.scene == nil {

            //skView.showsFPS = true
            //skView.showsNodeCount = true
            
            let menuScene = MenuScene(size: skView.bounds.size)
            menuScene.scaleMode = SKSceneScaleMode.AspectFill
            menuScene.registerView(self.view)
//            skView.showsFPS = true
//            skView.showsNodeCount = true
//            skView.showsPhysics = true
            
            skView.presentScene(menuScene)

            
        }
    }
    
    func setGameCenter(){
        var localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {(viewController : UIViewController!, error : NSError!) -> Void in
            if ((viewController) != nil) {
                self.presentViewController(viewController, animated: true, completion: nil)
                self.playerIsAuthenticated = false
            }else {
                println((GKLocalPlayer.localPlayer().authenticated))
                self.playerIsAuthenticated = true
            }
        }
    }
    
    func showLeaderboard() {
        
        var gcViewController: GKGameCenterViewController = GKGameCenterViewController()
        gcViewController.gameCenterDelegate = self
        
        gcViewController.viewState = GKGameCenterViewControllerState.Leaderboards
        
        
        gcViewController.leaderboardIdentifier = "chompEm.highscores"
        
        self.showViewController(gcViewController, sender: self)
        self.navigationController?.pushViewController(gcViewController, animated: true)
        
    }
    
    func gameCenterViewControllerDidFinish(gcViewController: GKGameCenterViewController!){
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    

    override func shouldAutorotate() -> Bool {
        return false
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
