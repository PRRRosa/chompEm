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



    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        if (!contentCreated){
            createContent()
            contentCreated = true
        }
        //println(NSUserDefaults.standardUserDefaults().objectForKey("HighestScore")!)
        
        let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedRight:"))
        swipeRight.direction = .Right
        view.addGestureRecognizer(swipeRight)
        
        
        let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedLeft:"))
        swipeLeft.direction = .Left
        view.addGestureRecognizer(swipeLeft)
        
        
    }
    
    func setupHud(){
        scoreLabel = SKLabelNode(fontNamed: "Marker Felt")
        println(scoreLabel.fontName)
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
        var playerFrames = [SKTexture]()
        
        let numImages = amoebaLaranjaAtlas.textureNames.count
        for (var i = 0; i < numImages; i++) {
            let nameA = "amoebaL_\(i)@2x"
            orangeFrames.append(amoebaLaranjaAtlas.textureNamed(nameA))
            
        }
        
        for (var i = numImages - 1; i >= 0; i--){
            let nameA = "amoebaL_\(i)@2x"
            orangeFrames.append(amoebaLaranjaAtlas.textureNamed(nameA))
        }
        
        scoreLabel.fontColor = UIColor.orangeColor()
        player.name = "orange"
        player.runAction( SKAction.repeatActionForever(SKAction.animateWithTextures(orangeFrames, timePerFrame: 0.005, resize: true, restore: false)), withKey:"playerLaranja")
        

        
}
    
    func runOrangeAnimation(){
            }
    
    func createGreenAnimation(){
        let amoebaVerdeAtlas = SKTextureAtlas(named: "amoebaVerde")
        var playerFrames = [SKTexture]()
        
        let numImages = amoebaVerdeAtlas.textureNames.count
        for (var i = 0; i < numImages; i++) {
            let nameA = "amoebaVerde_\(i)@2x"
            playerFrames.append(amoebaVerdeAtlas.textureNamed(nameA))
            
        }
        
        for (var i = numImages - 1; i >= 0; i--){
            let nameA = "amoebaVerde_\(i)@2x"
            playerFrames.append(amoebaVerdeAtlas.textureNamed(nameA))
        }
        
        scoreLabel.fontColor = UIColor.greenColor()
        player.name = "green"
        player.runAction( SKAction.repeatActionForever(SKAction.animateWithTextures(playerFrames, timePerFrame: 0.005, resize: true, restore: false)), withKey:"playerVerde")
    }
    
    func createPurpleAnimation(){
        let amoebaVioletaAtlas = SKTextureAtlas(named: "amoebaVioleta")
        var playerFrames = [SKTexture]()
        
        let numImages = amoebaVioletaAtlas.textureNames.count
        for (var i = 0; i < numImages; i++) {
            let nameA = "amoebaV_\(i)@2x"
            playerFrames.append(amoebaVioletaAtlas.textureNamed(nameA))
            
        }
        
        for (var i = numImages - 1; i >= 0; i--){
            let nameA = "amoebaV_\(i)@2x"
            playerFrames.append(amoebaVioletaAtlas.textureNamed(nameA))
        }
        scoreLabel.fontColor = UIColor.purpleColor()
        player.name = "purple"
        player.runAction( SKAction.repeatActionForever(SKAction.animateWithTextures(playerFrames, timePerFrame: 0.005, resize: true, restore: false)), withKey:"playerVioleta")
    }
    
    func createRedEnemyAnimation(){
        let amoebaFeiaVermelhaAtlas = SKTextureAtlas(named: "amoebaFeiaVermelha")
        var alienFrames = [SKTexture]()
        
        let numImages = amoebaFeiaVermelhaAtlas.textureNames.count
        for (var i = 0; i < numImages; i++) {
            let nameA = "amebafeiaVermelha_\(i)@2x"
            alienFrames.append(amoebaFeiaVermelhaAtlas.textureNamed(nameA))
            
        }
        
        for (var i = numImages - 1; i >= 0; i--) {
            let nameA = "amebafeiaVermelha_\(i)@2x"
            alienFrames.append(amoebaFeiaVermelhaAtlas.textureNamed(nameA))
            
        }
        
        alien.runAction( SKAction.repeatActionForever(SKAction.animateWithTextures(alienFrames, timePerFrame: 0.05, resize: true, restore: false)), withKey:"amoebafeiaVermelha")
    }
    
    func createBlueEnemyAnimation(){
        let amoebaFeiaAzulAtlas = SKTextureAtlas(named: "amoebaFeiaAzul")
        var alienFrames = [SKTexture]()
        
        let numImages = amoebaFeiaAzulAtlas.textureNames.count
        for (var i = 0; i < numImages; i++) {
            let nameA = "amebafeiaAzul_\(i)@2x"
            alienFrames.append(amoebaFeiaAzulAtlas.textureNamed(nameA))
            
        }
        
        for (var i = numImages - 1; i >= 0; i--) {
            let nameA = "amebafeiaAzul_\(i)@2x"
            alienFrames.append(amoebaFeiaAzulAtlas.textureNamed(nameA))
            
        }
        
        alien.runAction( SKAction.repeatActionForever(SKAction.animateWithTextures(alienFrames, timePerFrame: 0.05, resize: true, restore: false)), withKey:"amoebafeiaAzul")
    }
    
    func createYellowEnemyAnimation(){
        let amoebaFeiaAmarelaAtlas = SKTextureAtlas(named: "amoebaFeiaAmarela")
        var alienFrames = [SKTexture]()
        
        let numImages = amoebaFeiaAmarelaAtlas.textureNames.count
        for (var i = 0; i < numImages; i++) {
            let nameA = "amebafeiaAmarela_\(i)@2x"
            alienFrames.append(amoebaFeiaAmarelaAtlas.textureNamed(nameA))
            
        }
        
        for (var i = numImages - 1; i >= 0; i--) {
            let nameA = "amebafeiaAmarela_\(i)@2x"
            alienFrames.append(amoebaFeiaAmarelaAtlas.textureNamed(nameA))
            
            
        }
        
        alien.runAction( SKAction.repeatActionForever(SKAction.animateWithTextures(alienFrames, timePerFrame: 0.05, resize: true, restore: false)), withKey:"amoebafeiaAmarela")
    }
    
    func createPurpleMouthOpeningAnimation(){
        let playerAnimatedAtlas = SKTextureAtlas(named: "amoebaVioletaBoca")
        var mouthFrames = [SKTexture]()
        
        let numImages = playerAnimatedAtlas.textureNames.count
        for (var i = 0; i < numImages; i++) {
            let nameA = "amebaVioleta_\(i)"
            mouthFrames.append(playerAnimatedAtlas.textureNamed(nameA))
            
        }
        for (var i = numImages - 1; i >= 0; i--) {
            let nameA = "amebaVioleta_\(i)"
            mouthFrames.append(playerAnimatedAtlas.textureNamed(nameA))
            
        }
        
        //playerMouthAnimation = mouthFrames
        player.runAction((SKAction.animateWithTextures(mouthFrames, timePerFrame: 0.01, resize: true, restore: true)), withKey:"purpleMouthOpening")
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
        var mouthFrames = [SKTexture]()
        
        let numImages = playerAnimatedAtlas.textureNames.count
        for (var i = 0; i < numImages; i++) {
            let nameA = "amebaVerde_\(i)"
            mouthFrames.append(playerAnimatedAtlas.textureNamed(nameA))
            
        }
        for (var i = numImages - 1; i >= 0; i--) {
            let nameA = "amebaVerde_\(i)"
            mouthFrames.append(playerAnimatedAtlas.textureNamed(nameA))
            
        }
        
        //playerMouthAnimation = mouthFrames
        player.runAction((SKAction.animateWithTextures(mouthFrames, timePerFrame: 0.01, resize: true, restore: true)), withKey:"greenMouthOpening")
    }
    
    func createOrangeMouthOpeningAnimation(){
        let playerAnimatedAtlas = SKTextureAtlas(named: "amoebaLaranjaBoca")
        var mouthFrames = [SKTexture]()
        
        let numImages = playerAnimatedAtlas.textureNames.count
        for (var i = 0; i < numImages; i++) {
            let nameA = "amebaLaranja_\(i)"
            mouthFrames.append(playerAnimatedAtlas.textureNamed(nameA))
            
        }
        for (var i = numImages - 1; i >= 0; i--) {
            let nameA = "amebaLaranja_\(i)"
            mouthFrames.append(playerAnimatedAtlas.textureNamed(nameA))
            
        }
        
        //playerMouthAnimation = mouthFrames
        player.runAction((SKAction.animateWithTextures(mouthFrames, timePerFrame: 0.01, resize: true, restore: true)), withKey:"orangeMouthOpening")
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
        
        
        player = SKSpriteNode(imageNamed: "AmoebaVermelha")
        //player = SKSpriteNode(texture: firstFrame)
        //player.name = "purple"
        //createPurpleAnimation()
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
        
        createOrangeAnimation()
        
        
        btnBlue = SKSpriteNode(imageNamed: "Azul")
        btnBlue.name = "btnB"
        btnBlue.position = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height/2 * 0.3)
        //        btnBlue.xScale = 1.3
        //        btnBlue.yScale = 1.3
        //        self.addChild(btnBlue)
        
        btnRed = SKSpriteNode(imageNamed: "Vermelho")
        btnRed.name = "btnR"
        btnRed.position = CGPointMake(self.frame.size.width * 0.20, self.frame.size.height/2 * 0.3)
        //        btnRed.xScale = 1.3
        //        btnRed.yScale = 1.3
        //        self.addChild(btnRed)
        
        btnYellow = SKSpriteNode(imageNamed: "Amarelo")
        btnYellow.name = "btnY"
        btnYellow.position = CGPointMake(self.frame.size.width * 0.80, self.frame.size.height/2 * 0.3)
        //        btnYellow.xScale = 1.3
        //        btnYellow.yScale = 1.3
        //        self.addChild(btnYellow)
        
        
        //player.size.height/2 + 180
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
            //projectileDidCollideWithMonster(firstBody.node as! SKSpriteNode, monster: secondBody.node as! SKSpriteNode)
            secondBody.node?.removeFromParent()
        }
    }
    
    
    func projectileDidCollideWithMonster(projectile:SKSpriteNode, monster:SKSpriteNode) {
        println("Hit")
        println(monster.name!)
        println(projectile.name!)
        
        if(projectile.name! == "purple" && (monster.name! == "blue" || monster.name! == "red")){
            createPurpleMouthOpeningAnimation()
            
            gulpSound.play()
            monster.removeFromParent()
            adjustScore()
            eatCount()
        }
        else if(projectile.name! == "green" && (monster.name! == "blue" || monster.name! == "yellow")){
            createGreenMouthOpeningAnimation()
            
            gulpSound.play()
            monster.removeFromParent()
            adjustScore()
            eatCount()
        }else if(projectile.name! == "orange" && (monster.name! == "red" || monster.name! == "yellow")){
            createOrangeMouthOpeningAnimation()
            
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
        println(direction)
        alien = randomiseEnemy() as SKSpriteNode
        if (randomEnemyNumber == 0){
            createRedEnemyAnimation()
        }else if (randomEnemyNumber == 1){
            createBlueEnemyAnimation()
        } else{
            createYellowEnemyAnimation()
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
        
        let loseAction = SKAction.runBlock() {
            let reveal = SKTransition.flipVerticalWithDuration(0.5)
            let gameOverScene = GameOverScene(size: self.size)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
        
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
            if (random == 0){
                createOrangeAnimation()
                
            }else if (random == 1){
                createGreenAnimation()
                
            }
            
        }
        else{
            if(player.name == "green"){
                if (random == 0){
                    createPurpleAnimation()
                }else if (random == 1){
                    createOrangeAnimation()
                }
                
            }
            else{
                if(player.name == "orange"){
                    if (random == 0){
                        createPurpleAnimation()
                    }else if (random == 1){
                        createGreenAnimation()
                    }
                    
                }
            }
        }
        
    }
    func randomisePlayerInit(){
        let random = Int(arc4random_uniform(3))
        if (random == 0){
            createPurpleAnimation()
        }else if (random == 1){
            createGreenAnimation()
        } else {
            createOrangeAnimation()
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
    
    
    //     override func didMoveToView(view: SKView) {
    //
    //            //self.addChild(myLabel)
    //
    //                    let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedRight:"))
    //                    swipeRight.direction = .Right
    //                    view.addGestureRecognizer(swipeRight)
    //
    //
    //                    let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedLeft:"))
    //                    swipeLeft.direction = .Left
    //                    view.addGestureRecognizer(swipeLeft)
    //
    //        }
    //
    
    
    
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
            
            if let name = nodeColor.name{
                if(name == "btnY"){
                    //player = SKSpriteNode(imageNamed: "AlienAmarelo" as String)
                    player.name = "yellow"
                    player.texture = SKTexture(imageNamed: "AmoebaAmarelo")
                    println(nodeColor.name!)
                    println(player.name!)
                    //createYellowAnimation()
                }
                
                if(name == "btnR"){
                    //player = SKSpriteNode(imageNamed: "AlienVermelho" as String)
                    player.name = "red"
                    player.texture = SKTexture(imageNamed: "AmoebaVermelha")
                    println(nodeColor.name!)
                    println(player.name!)
                    //createRedAnimation()
                }
                
                if(name == "btnB"){
                    //player = SKSpriteNode(imageNamed: "AlienAzul" as String)
                    player.name = "blue"
                    player.texture = SKTexture(imageNamed: "AmoebaAzul")
                    println(nodeColor.name!)
                    println(player.name!)
                    //createBlueAnimation()
                }
            }
            
        }
    }
    
    
    func gameOver(){
        
        if let savedScore: NSInteger = NSUserDefaults.standardUserDefaults().objectForKey("HighestScore") as? NSInteger{
            println(savedScore)
            if savedScore < score{
                NSUserDefaults.standardUserDefaults().setObject(score, forKey:"HighestScore")
                NSUserDefaults.standardUserDefaults().synchronize()
                //inserir score no gameCenter
                var game: GameViewController = self.view?.window?.rootViewController as! GameViewController
                if (game.playerIsAuthenticated){
                    var leaderboardScore = GKScore(leaderboardIdentifier: "ID DA LEADERBOARD")
                    leaderboardScore.value = Int64(score)
                    GKScore.reportScores([leaderboardScore], withCompletionHandler: {(error) -> Void in
                        let alert = UIAlertView(title: "Success", message: "Score updated", delegate: self, cancelButtonTitle: "Ok")
                        alert.show()
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
                var leaderboardScore = GKScore(leaderboardIdentifier: "ID DA LEADERBOARD")
                leaderboardScore.value = Int64(highestScore)
                GKScore.reportScores([leaderboardScore], withCompletionHandler: {(error) -> Void in
                    let alert = UIAlertView(title: "Success", message: "Score updated", delegate: self, cancelButtonTitle: "Ok")
                    alert.show()
                })
                
            }
        }
        let reveal = SKTransition.flipVerticalWithDuration(0.5)
        let gameOverScene = GameOverScene(size: self.size)
        if (player.name == "purple"){
            gameOverScene.colorType = 0
        }else if (player.name == "orange"){
            gameOverScene.colorType = 1
        }else {
            gameOverScene.colorType = 2
        }
        
        self.view?.presentScene(gameOverScene, transition: reveal)
    }
}
