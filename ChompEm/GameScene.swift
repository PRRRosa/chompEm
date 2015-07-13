//
//  GameScene.swift
//  amoebaProject
//
//  Created by Paulo Ricardo Ramos da Rosa on 6/17/15.
//  Copyright (c) 2015 Paulo Ricardo Ramos da Rosa. All rights reserved.
//

import SpriteKit
import AVFoundation
import GameKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let projectileCategoryName = "projectile"
    let playerCategoryName = "player"
    let enemyCategoryName = "enemy"
    let barrierCategoryName = "barrier"
    let enemyCat:UInt32 = 0x1 << 1
    let amebaCat:UInt32 = 0x1 << 2
    let barrierCat:UInt32 = 0x1 << 3
    var backgroundMusicPlayer = AVAudioPlayer()
    var gulpSound = AVAudioPlayer()
    var lastYieldTimeInterval:NSTimeInterval = NSTimeInterval()
    var lastUpdateTimerInterval:NSTimeInterval = NSTimeInterval()
    var player:SKSpriteNode = SKSpriteNode()
    var btnRed:SKSpriteNode = SKSpriteNode()
    var btnBlue:SKSpriteNode = SKSpriteNode()
    var btnYellow:SKSpriteNode = SKSpriteNode()
    var contentCreated = false
    var score:NSInteger = 0
    var scoreLabel: SKLabelNode = SKLabelNode()
    var playerPosition : NSInteger = 0
    var alien:SKSpriteNode = SKSpriteNode()
    var eat = 0
    var randomEnemyNumber = 0
    var life = 3
    var alienSpeed = 1.0
    var direction:CGFloat  = 3.2
    var life3:SKSpriteNode = SKSpriteNode()
    var life2:SKSpriteNode = SKSpriteNode()
    var life1:SKSpriteNode = SKSpriteNode()
    var orangeFrames = [SKTexture]()
    var greenFrames = [SKTexture]()
    var purpleFrames = [SKTexture]()
    var redAlienFrames = [SKTexture]()
    var blueAlienFrames = [SKTexture]()
    var yellowAlienFrames = [SKTexture]()
    var orangeMounthFrames = [SKTexture]()
    var greenMounthFrames = [SKTexture]()
    var purpleMounthFrames = [SKTexture]()

    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        if (!contentCreated){
            createContent()
            contentCreated = true
        }
        
        let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedRight:"))
        swipeRight.direction = .Right
        view.addGestureRecognizer(swipeRight)
        
        
        let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedLeft:"))
        swipeLeft.direction = .Left
        view.addGestureRecognizer(swipeLeft)
        
        
    }
    
    func setupHud(){
        scoreLabel = SKLabelNode(fontNamed: "Marker Felt")
        scoreLabel.name = "scoreHud"
        scoreLabel.fontSize = 50
        //scoreLabel.fontColor = UIColor.greenColor()
        scoreLabel.text =  String(format: "%05d", arguments: [score])
        scoreLabel.position = CGPointMake(self.frame.size.width/2, self.frame.size.height * 0.05)
        self.addChild(scoreLabel)
    }
    
    func adjustScore(){
        self.score = self.score + 100
        scoreLabel.text = String(format: "%05d", arguments: [score])
        if (score%200 == 0){
            alienSpeed = alienSpeed * 0.95
        }
    }
    
    
    func createOrangeAnimation(){
        let amoebaLaranjaAtlas = SKTextureAtlas(named: "amoebaLaranja")
        
        let numImages = amoebaLaranjaAtlas.textureNames.count
        for (var i = 0; i < numImages; i++) {
            let nameA = "amoebaL_\(i)@2x"
            orangeFrames.append(amoebaLaranjaAtlas.textureNamed(nameA))
            
        }
        
        for (var i = numImages - 1; i >= 0; i--){
            let nameA = "amoebaL_\(i)@2x"
            orangeFrames.append(amoebaLaranjaAtlas.textureNamed(nameA))
        }
        
    }
    
    func runOrangeAnimation()->SKAction{
        scoreLabel.fontColor = UIColor.orangeColor()
        player.name = "orange"
        //player.runAction( SKAction.repeatActionForever(SKAction.animateWithTextures(orangeFrames, timePerFrame: 0.005, resize: true, restore: false)), withKey:"playerLaranja")
        return (SKAction.repeatActionForever(SKAction.animateWithTextures(orangeFrames, timePerFrame: 0.005, resize: true, restore: false)))

    }
    
    func createGreenAnimation(){
        let amoebaVerdeAtlas = SKTextureAtlas(named: "amoebaVerde")
        
        let numImages = amoebaVerdeAtlas.textureNames.count
        for (var i = 0; i < numImages; i++) {
            let nameA = "amoebaVerde_\(i)@2x"
            greenFrames.append(amoebaVerdeAtlas.textureNamed(nameA))
            
        }
        
        for (var i = numImages - 1; i >= 0; i--){
            let nameA = "amoebaVerde_\(i)@2x"
            greenFrames.append(amoebaVerdeAtlas.textureNamed(nameA))
        }
        
        
    }
    
    func runGreenAnimation()->SKAction{
        scoreLabel.fontColor = UIColor.greenColor()
        player.name = "green"
        //player.runAction( SKAction.repeatActionForever(SKAction.animateWithTextures(greenFrames, timePerFrame: 0.005, resize: true, restore: false)), withKey:"playerVerde")
        return (SKAction.repeatActionForever(SKAction.animateWithTextures(greenFrames, timePerFrame: 0.005, resize: true, restore: false)))
    }
    
    func createPurpleAnimation(){
        let amoebaVioletaAtlas = SKTextureAtlas(named: "amoebaVioleta")
        
        let numImages = amoebaVioletaAtlas.textureNames.count
        for (var i = 0; i < numImages; i++) {
            let nameA = "amoebaV_\(i)@2x"
            purpleFrames.append(amoebaVioletaAtlas.textureNamed(nameA))
            
        }
        
        for (var i = numImages - 1; i >= 0; i--){
            let nameA = "amoebaV_\(i)@2x"
            purpleFrames.append(amoebaVioletaAtlas.textureNamed(nameA))
        }
    }
    
    func runPurpleAnimation()->SKAction{
        scoreLabel.fontColor = UIColor.purpleColor()
        player.name = "purple"
        //player.runAction( SKAction.repeatActionForever(SKAction.animateWithTextures(purpleFrames, timePerFrame: 0.005, resize: true, restore: false)), withKey:"playerVioleta")
        return SKAction.repeatActionForever(SKAction.animateWithTextures(purpleFrames, timePerFrame: 0.005, resize: true, restore: false))
    }
    
    func createRedEnemyAnimation(){
        let amoebaFeiaVermelhaAtlas = SKTextureAtlas(named: "amoebaFeiaVermelha")
        
        let numImages = amoebaFeiaVermelhaAtlas.textureNames.count
        for (var i = 0; i < numImages; i++) {
            let nameA = "amebafeiaVermelha_\(i)@2x"
            redAlienFrames.append(amoebaFeiaVermelhaAtlas.textureNamed(nameA))
            
        }
        
        for (var i = numImages - 1; i >= 0; i--) {
            let nameA = "amebafeiaVermelha_\(i)@2x"
            redAlienFrames.append(amoebaFeiaVermelhaAtlas.textureNamed(nameA))
            
        }
        
    }
    
    func runRedEnemyAnimation(){
        alien.runAction( SKAction.repeatActionForever(SKAction.animateWithTextures(redAlienFrames, timePerFrame: 0.05, resize: true, restore: false)), withKey:"amoebafeiaVermelha")
    }
    
    func createBlueEnemyAnimation(){
        let amoebaFeiaAzulAtlas = SKTextureAtlas(named: "amoebaFeiaAzul")
        
        let numImages = amoebaFeiaAzulAtlas.textureNames.count
        for (var i = 0; i < numImages; i++) {
            let nameA = "amebafeiaAzul_\(i)@2x"
            blueAlienFrames.append(amoebaFeiaAzulAtlas.textureNamed(nameA))
            
        }
        
        for (var i = numImages - 1; i >= 0; i--) {
            let nameA = "amebafeiaAzul_\(i)@2x"
            blueAlienFrames.append(amoebaFeiaAzulAtlas.textureNamed(nameA))
            
        }
        
    }
    
    func runBlueEnemyAnimation(){
        alien.runAction( SKAction.repeatActionForever(SKAction.animateWithTextures(blueAlienFrames, timePerFrame: 0.05, resize: true, restore: false)), withKey:"amoebafeiaAzul")
    }
    
    func createYellowEnemyAnimation(){
        let amoebaFeiaAmarelaAtlas = SKTextureAtlas(named: "amoebaFeiaAmarela")
        
        let numImages = amoebaFeiaAmarelaAtlas.textureNames.count
        for (var i = 0; i < numImages; i++) {
            let nameA = "amebafeiaAmarela_\(i)@2x"
            yellowAlienFrames.append(amoebaFeiaAmarelaAtlas.textureNamed(nameA))
            
        }
        
        for (var i = numImages - 1; i >= 0; i--) {
            let nameA = "amebafeiaAmarela_\(i)@2x"
            yellowAlienFrames.append(amoebaFeiaAmarelaAtlas.textureNamed(nameA))
            
            
        }
        
    }
    
    func runYellowEnemyAnimation(){
        alien.runAction( SKAction.repeatActionForever(SKAction.animateWithTextures(yellowAlienFrames, timePerFrame: 0.05, resize: true, restore: false)), withKey:"amoebafeiaAmarela")
    }
    
    func createPurpleMouthOpeningAnimation(){
        let playerAnimatedAtlas = SKTextureAtlas(named: "amoebaVioletaBoca")
        
        
        let numImages = playerAnimatedAtlas.textureNames.count
        for (var i = 0; i < numImages; i++) {
            let nameA = "amebaVioleta_\(i)"
            purpleMounthFrames.append(playerAnimatedAtlas.textureNamed(nameA))
            
        }
        for (var i = numImages - 1; i >= 0; i--) {
            let nameA = "amebaVioleta_\(i)"
            purpleMounthFrames.append(playerAnimatedAtlas.textureNamed(nameA))
            
        }
        
        //playerMouthAnimation = mouthFrames
        //player.runAction((SKAction.animateWithTextures(mouthFrames, timePerFrame: 0.01, resize: true, restore: true)), withKey:"purpleMouthOpening")
    }
    
    func runPurpleMounth()->SKAction{
        return (SKAction.animateWithTextures(purpleMounthFrames, timePerFrame: 0.01, resize: true, restore: true))
    }
    
    func createPurpleHitAnimation(){
        let playerAnimatedAtlas = SKTextureAtlas(named: "amoebaVioletaHit")
        var playerFrames = [SKTexture]()
        
        let numImages = playerAnimatedAtlas.textureNames.count
        for (var i = 0; i < numImages; i++) {
            let nameA = "amebaMortaRoxa_\(i)"
            playerFrames.append(playerAnimatedAtlas.textureNamed(nameA))
            
        }
        
        
        //playerMouthAnimation = mouthFrames
        player.runAction((SKAction.animateWithTextures(playerFrames, timePerFrame: 0.01, resize: true, restore: true)), withKey:"purpleHit")
    }
    
    func createGreenHitAnimation(){
        let playerAnimatedAtlas = SKTextureAtlas(named: "amoebaVerdeHit")
        var playerFrames = [SKTexture]()
        
        let numImages = playerAnimatedAtlas.textureNames.count
        for (var i = 0; i < numImages; i++) {
            let nameA = "amebaMortaVerde_\(i)"
            playerFrames.append(playerAnimatedAtlas.textureNamed(nameA))
            
        }
        
        
        //playerMouthAnimation = mouthFrames
        player.runAction((SKAction.animateWithTextures(playerFrames, timePerFrame: 0.01, resize: true, restore: true)), withKey:"greenHit")
    }
    
    func createOrangeHitAnimation(){
        let playerAnimatedAtlas = SKTextureAtlas(named: "amoebaLaranjaHit")
        var playerFrames = [SKTexture]()
        
        let numImages = playerAnimatedAtlas.textureNames.count
        for (var i = 0; i < numImages; i++) {
            let nameA = "amebaMortaLaranja_\(i)"
            playerFrames.append(playerAnimatedAtlas.textureNamed(nameA))
            
        }
        
        
        //playerMouthAnimation = mouthFrames
        player.runAction((SKAction.animateWithTextures(playerFrames, timePerFrame: 0.01, resize: true, restore: true)), withKey:"orangeHit")
    }
    
    
    
    func createGreenMouthOpeningAnimation(){
        let playerAnimatedAtlas = SKTextureAtlas(named: "amoebaVerdeBoca")

        
        let numImages = playerAnimatedAtlas.textureNames.count
        for (var i = 0; i < numImages; i++) {
            let nameA = "amebaVerde_\(i)"
            greenMounthFrames.append(playerAnimatedAtlas.textureNamed(nameA))
            
        }
    }
    
    
    func runGreenMounth()->SKAction{
        return (SKAction.animateWithTextures(greenMounthFrames, timePerFrame: 0.01, resize: true, restore: true))
    }
    
    func createOrangeMouthOpeningAnimation(){
        let playerAnimatedAtlas = SKTextureAtlas(named: "amoebaLaranjaBoca")
        let numImages = playerAnimatedAtlas.textureNames.count
        for (var i = 0; i < numImages; i++) {
            let nameA = "amebaLaranja_\(i)"
            orangeMounthFrames.append(playerAnimatedAtlas.textureNamed(nameA))
            
        }
        
        
    }
    
    func runOrangeMounth()->SKAction{
        return (SKAction.animateWithTextures(orangeMounthFrames, timePerFrame: 0.01, resize: true, restore: true))
    }
    
    func createContent(){
        
        //let firstFrame: SKTexture = playerVermelhoAnimation[0]
        let bgMusicURL = NSBundle.mainBundle().URLForResource("zuera7", withExtension: "mp3")
        
        backgroundMusicPlayer = AVAudioPlayer(contentsOfURL: bgMusicURL, error: nil)
        
        backgroundMusicPlayer.numberOfLoops = -1
        backgroundMusicPlayer.prepareToPlay()
        backgroundMusicPlayer.volume -= 0.5
        backgroundMusicPlayer.play()
        
        let gulpEffect = NSBundle.mainBundle().URLForResource("gulp", withExtension: "m4a")
        gulpSound = AVAudioPlayer(contentsOfURL: gulpEffect, error: nil)
        
        gulpSound.numberOfLoops = 0
        gulpSound.prepareToPlay()
        
        let backgroundImg = SKSpriteNode(imageNamed: "Fundo_Ipad")
        backgroundImg.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
        backgroundImg.size = CGSize(width: self.frame.size.width, height: self.frame.size.height)
        
        self.addChild(backgroundImg)
        
        life1 = SKSpriteNode(imageNamed:"life1")
        life1.position = CGPointMake(self.frame.size.width/4 - 60, self.frame.size.height * 0.15);
        self.addChild(life1)
        
        life2 = SKSpriteNode(imageNamed:"life1")
        life2.position = CGPointMake(self.frame.size.width/4 - 30, self.frame.size.height * 0.15);
        self.addChild(life2)
        
        life3 = SKSpriteNode(imageNamed:"life1")
        life3.position = CGPointMake(self.frame.size.width/4 , self.frame.size.height * 0.15);
        self.addChild(life3)
        
        
        createOrangeAnimation()
        createGreenAnimation()
        createPurpleAnimation()
        createRedEnemyAnimation()
        createBlueEnemyAnimation()
        createYellowEnemyAnimation()
        createGreenMouthOpeningAnimation()
        createOrangeMouthOpeningAnimation()
        createPurpleMouthOpeningAnimation()
        player = SKSpriteNode(imageNamed: "AmoebaVermelha")
        randomisePlayerInit()
        
        player.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/3.5)
        
        playerPosition = 0
        player.physicsBody = SKPhysicsBody(rectangleOfSize: player.size)
        player.physicsBody!.dynamic = true
        player.physicsBody!.categoryBitMask = amebaCat
        player.physicsBody!.contactTestBitMask = enemyCat
        player.physicsBody!.collisionBitMask = 0
        player.xScale = 0.4
        player.yScale = 0.4
        self.addChild(player)
        
        
        
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.physicsWorld.contactDelegate = self
        
        setupHud()
        randomisePlayerInit()
        let barrier = SKSpriteNode(texture: nil, color: nil, size: CGSizeMake(self.size.width,10.0))
        barrier.position = CGPointMake(self.frame.width/2, 0)
        barrier.physicsBody = SKPhysicsBody(rectangleOfSize: barrier.size)
        barrier.physicsBody!.dynamic = false
        barrier.physicsBody!.categoryBitMask = barrierCat
        barrier.physicsBody!.contactTestBitMask = enemyCat
        barrier.physicsBody!.collisionBitMask = 3
        
        
        self.addChild(barrier)
        
        
    }
    
    func didBeginContact(contact: SKPhysicsContact)
    {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        firstBody = contact.bodyA
        secondBody = contact.bodyB
        
        
        if ((firstBody.categoryBitMask & amebaCat != 0) && (secondBody.categoryBitMask & enemyCat != 0)) {
            projectileDidCollideWithMonster(firstBody.node as! SKSpriteNode, monster: secondBody.node as! SKSpriteNode)
        }
        if ((firstBody.categoryBitMask & barrierCat != 0) && (secondBody.categoryBitMask & enemyCat != 0)) {
            secondBody.node?.removeFromParent()
        }
    }
    
    
    func projectileDidCollideWithMonster(projectile:SKSpriteNode, monster:SKSpriteNode) {
        
        if(projectile.name! == "purple" && (monster.name! == "blue" || monster.name! == "red")){
//            createPurpleMouthOpeningAnimation()
            player.runAction(runPurpleMounth())
            gulpSound.play()
            monster.removeFromParent()
            adjustScore()
            eatCount()
        }
        else if(projectile.name! == "green" && (monster.name! == "blue" || monster.name! == "yellow")){
//            createGreenMouthOpeningAnimation()
            player.runAction(runGreenMounth())
            gulpSound.play()
            monster.removeFromParent()
            adjustScore()
            eatCount()
        }else if(projectile.name! == "orange" && (monster.name! == "red" || monster.name! == "yellow")){
//            createOrangeMouthOpeningAnimation()
            player.runAction(runOrangeMounth())
            gulpSound.play()
            monster.removeFromParent()
            adjustScore()
            eatCount()
        }else {
            if (projectile.name == "purple"){
                createPurpleHitAnimation()
                monster.removeFromParent()
                life--
                perdeVida()
                
            }else if (projectile.name == "green"){
                createGreenHitAnimation()
                monster.removeFromParent()
                life--
                perdeVida()
            }else {
                createOrangeHitAnimation()
                monster.removeFromParent()
                life--
                perdeVida()
            }
            
            if (life == 0){
                //monster.removeAllActions()
                self.gameOver()
            }
            
        }
        
        
    }
    
    func perdeVida()
    {
        if (life == 2)
        {
            life3.hidden = true
        }
        else if (life == 1)
        {
            life2.hidden = true
        }
        else if (life == 0)
        {
            life1.hidden = true
        }
    }
    
    func eatCount(){
        eat++
        if eat == 2{
            eat = 0
            randomisePlayer()
        }
    }
    
    func randomiseEnemy() -> SKSpriteNode{
        let enemyColor: SKSpriteNode
        randomEnemyNumber = Int(arc4random_uniform(3))
        if (randomEnemyNumber == 0){
            enemyColor = SKSpriteNode(imageNamed: "AlienVermelho" as String)
            enemyColor.name = "red"
        }else if (randomEnemyNumber == 1){
            enemyColor = SKSpriteNode(imageNamed: "AlienAzul"  as String)
            enemyColor.name = "blue"
        } else {
            enemyColor = SKSpriteNode(imageNamed: "AlienAmarelo"  as String)
            enemyColor.name = "yellow"
        }
        return enemyColor
    }
    
    func randomEnemyPosition() -> CGFloat{
        var enemyPositionX: CGFloat?
        let randomNumber = Int(arc4random_uniform(3))
        switch randomNumber{
        case 0:
            enemyPositionX = (self.frame.size.width/2)/2
        case 1:
            enemyPositionX = (self.frame.size.width/2)
        case 2:
            enemyPositionX = (self.frame.size.width/2) + (self.frame.size.width/2)/2
        default:
            println()
        }
        return enemyPositionX!
    }
    
    
    
    
    func addMonster(){
        
        if(direction == 3.2){
            direction = -3.2
        }
        else{
            direction = 3.2
        }
       
        alien = randomiseEnemy() as SKSpriteNode
        if (randomEnemyNumber == 0){
            runRedEnemyAnimation()
        }else if (randomEnemyNumber == 1){
            runBlueEnemyAnimation()
        } else{
            runYellowEnemyAnimation()
        }
        alien.physicsBody = SKPhysicsBody(rectangleOfSize: alien.size)
        alien.physicsBody!.dynamic = true
        alien.physicsBody!.categoryBitMask = enemyCat
        alien.physicsBody!.contactTestBitMask = amebaCat
        alien.physicsBody!.collisionBitMask = 0
        alien.xScale = 0.2
        alien.yScale = 0.2
        
        let minX = alien.size.width/2
        let maxX = self.frame.size.width - alien.size.width/2
        let rangeX = maxX - minX
        //let position:CGFloat = CGFloat(arc4random()) % CGFloat(rangeX) + CGFloat(minX)
        let position:CGFloat = randomEnemyPosition()
        
        alien.position = CGPointMake(position, self.frame.size.height+alien.size.height)
        
        
        self.addChild(alien)
        
        //duração de queda aleatória
        
        //        let minDuration = 2
        //        let maxDuration = 4
        //        let rangeDuration = maxDuration - minDuration
        //        let duration = Int(arc4random()) % Int(rangeDuration) + Int(minDuration)
        
        var actionArray:NSMutableArray = NSMutableArray()
        
        let fall = SKAction.moveTo(CGPointMake(position, -alien.size.height), duration: NSTimeInterval(4 * alienSpeed))
        let rotate = SKAction.rotateByAngle(direction/2, duration: 5)
        let group = SKAction.group([fall,rotate])
        actionArray.addObject(group)
        
//        let loseAction = SKAction.runBlock() {
//            let reveal = SKTransition.flipVerticalWithDuration(0.5)
//            let gameOverScene = GameOverScene(size: self.size)
//            self.view?.presentScene(gameOverScene, transition: reveal)
//        }
        
        //actionArray.addObject(loseAction)
        alien.runAction(SKAction.sequence(actionArray as [AnyObject]))
        
        
        
        
    }
    
    
    func updateWithTimeSinceLastUpdate(timeSinceLastUpdate:CFTimeInterval){
        
        lastYieldTimeInterval += timeSinceLastUpdate
        if (lastYieldTimeInterval > 1.5 * alienSpeed){
            lastYieldTimeInterval = 0
            addMonster()
            
            //randomisePlayer()
        }
        
        
    }
    
    
    func randomisePlayer(){
        let random = Int(arc4random_uniform(2))
        
        if(player.name == "purple"){
            
            switch random{
                case 0:
                    player.runAction(SKAction.sequence([runPurpleMounth(),runOrangeAnimation()]))
                case 1:
                    player.runAction(SKAction.sequence([runPurpleMounth(),runGreenAnimation()]))
                default:
                    println()
            }
            
            
        }
        else if(player.name == "green"){
            
                switch random{
                    case 0:
                        player.runAction(SKAction.sequence([runGreenMounth(),runPurpleAnimation()]))
                    case 1:
                        player.runAction(SKAction.sequence([runGreenMounth(),runOrangeAnimation()]))

                    default:
                        println()
                }

            }
            else if(player.name == "orange"){
            
                switch random{
                case 0:
                    player.runAction(SKAction.sequence([runOrangeMounth(),runPurpleAnimation()]))
                case 1:
                    player.runAction(SKAction.sequence([runOrangeMounth(),runGreenAnimation()]))
                
                default:
                    println()
                }
                    
            }
            
    }
        
    
    func randomisePlayerInit(){
        let random = Int(arc4random_uniform(3))
        if (random == 0){
            player.runAction(runPurpleAnimation())
        }else if (random == 1){
            player.runAction(runGreenAnimation())
        } else {
            player.runAction(runOrangeAnimation())
            
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        
        var timeSinceLastUpdate = currentTime - lastUpdateTimerInterval
        lastUpdateTimerInterval = currentTime
        
        if (timeSinceLastUpdate > 1.5 * alienSpeed){
            timeSinceLastUpdate = 1/60
            lastUpdateTimerInterval = currentTime
        }
        
        updateWithTimeSinceLastUpdate(timeSinceLastUpdate)
        
    }
    
    
    
    
    
    func swipedRight(sender:UISwipeGestureRecognizer){
        switch playerPosition{
        case 0:
            player.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/3.5)
            playerPosition = 1
        case 1:
            player.position = CGPointMake((self.frame.size.width/2)+(self.frame.size.width/2)/2, self.frame.size.height/3.5)
            playerPosition = 2
        default:
            player.position = player.position
        }
        
    }
    
    func swipedLeft(sender:UISwipeGestureRecognizer){
        switch playerPosition{
        case 2:
            player.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/3.5)
            playerPosition = 1
        case 1:
            player.position = CGPointMake((self.frame.size.width/2)/2, self.frame.size.height/3.5)
            playerPosition = 0
            
        default:
            player.position = player.position
        }
    }
    
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            let sprite = player
            let nodeColor = self.nodeAtPoint(location)
            //if((location.y >= self.frame.size.height/3 - 20) && (location.y <= self.frame.size.height/2)){
            
            if(location.x < self.frame.size.width * 0.3 ){
                sprite.position = CGPointMake((self.frame.size.width/2)/2, self.frame.size.height/3.5)
            }
            if(location.x > self.frame.size.width * 0.6){
                sprite.position = CGPointMake((self.frame.size.width/2)+(self.frame.size.width/2)/2, self.frame.size.height/3.5)
            }
            
            if((location.x >= self.frame.size.width * 0.3) && (location.x <= self.frame.size.width * 0.6)){
                sprite.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/3.5)
            }
            

            
        }
    }
    
    
    func gameOver(){
        
        if let savedScore: NSInteger = NSUserDefaults.standardUserDefaults().objectForKey("HighestScore") as? NSInteger{
            if savedScore < score{
                NSUserDefaults.standardUserDefaults().setObject(score, forKey:"HighestScore")
                NSUserDefaults.standardUserDefaults().synchronize()
                //inserir score no gameCenter
                var game: GameViewController = self.view?.window?.rootViewController as! GameViewController
                if (game.playerIsAuthenticated){
                    var leaderboardScore = GKScore(leaderboardIdentifier: "chompEm.highscores")
                    leaderboardScore.value = Int64(score)
                    GKScore.reportScores([leaderboardScore], withCompletionHandler: {(error: NSError!) -> Void in
                        let alert = UIAlertView(title: "Success", message: "Score updated", delegate: self, cancelButtonTitle: "Ok")
                        //alert.show()
                    })
                    
                }
            } else{
                NSUserDefaults.standardUserDefaults().setObject(savedScore, forKey:"HighestScore")
                NSUserDefaults.standardUserDefaults().synchronize()
                //inserir score no gameCenter
                var game: GameViewController = self.view?.window?.rootViewController as! GameViewController
                if (game.playerIsAuthenticated){
                    var leaderboardScore = GKScore(leaderboardIdentifier: "chompEm.highscores")
                    leaderboardScore.value = Int64(savedScore)
                    GKScore.reportScores([leaderboardScore], withCompletionHandler: {(error: NSError!) -> Void in
                        let alert = UIAlertView(title: "Success", message: "Score updated", delegate: self, cancelButtonTitle: "Ok")
                        //alert.show()
                    })
                    
                }
            }
            
        }else{
            var highestScore: NSInteger = score
            NSUserDefaults.standardUserDefaults().setObject(highestScore, forKey:"HighestScore")
            NSUserDefaults.standardUserDefaults().synchronize()
            //inserir score no gameCenter
            var game: GameViewController = self.view?.window?.rootViewController as! GameViewController
            if (game.playerIsAuthenticated){
                var leaderboardScore = GKScore(leaderboardIdentifier: "chompEm.highscores")
                leaderboardScore.value = Int64(highestScore)
                GKScore.reportScores([leaderboardScore], withCompletionHandler: {(error: NSError!) -> Void in
                    let alert = UIAlertView(title: "Success", message: "Score updated", delegate: self, cancelButtonTitle: "Ok")
                    //alert.show()
                })
                
            }
        }
        let reveal = SKTransition.flipVerticalWithDuration(0.5)
        if (player.name! == "purple"){
            NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "color")
        }else if (player.name! == "orange"){
            NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "color")
        }else if (player.name! == "green"){
            NSUserDefaults.standardUserDefaults().setInteger(2, forKey: "color")
        }
        let gameOverScene = GameOverScene(size: self.size)
        NSUserDefaults.standardUserDefaults().synchronize()
        self.view?.presentScene(gameOverScene, transition: reveal)
    }
}
