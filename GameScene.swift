//
//  GameScene.swift
//  Shooting Game
//
//  Created by Radu Istrati on 10.05.20.
//  Copyright © 2020 Radu Istrati. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    // Font size for labels
    var fontSize: CGFloat = 20
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var bulletsLabel: SKLabelNode!
    var bullets = 6 {
        didSet {
            if bullets == 0 {
                bulletsLabel.text = "RELOAD"
            } else {
                bulletsLabel.text = "Bullets: \(bullets)"
            }
        }
    }
    var timerLabel: SKLabelNode!
    var time = 60 {
        didSet {
            timerLabel.text = "\(time)"
        }
    }
    var restartLabel: SKLabelNode!
    
    var targetsTimer: Timer?
    var gameTimer: Timer?
    
    // SFX files initialization
    var gunshotSFX = SKAction.playSoundFileNamed("shotgun.wav", waitForCompletion: false)
    var hitSFX = SKAction.playSoundFileNamed("clang.wav", waitForCompletion: false)
    var dryFireSFX = SKAction.playSoundFileNamed("dryFire.wav", waitForCompletion: false)
    var reloadSFX = SKAction.playSoundFileNamed("reload.wav", waitForCompletion: false)
    
    override func didMove(to view: SKView) {
        
        setBackground()
        setScoreLabel()
        setBulletsLabbel()
        setTimerLabel()
        setWoodStands()
        
        startGame()
        
    }
    
    // MARK: Game Logic
    
    // Start timers
    func startGame() {
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(setGameTimer), userInfo: nil, repeats: true)
        targetsTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(createTargets), userInfo: nil, repeats: true)
    }
    
    // Reset all variables and call startGame method
    func restartGame() {
        time = 60
        bullets = 6
        score = 0
        restartLabel.removeFromParent()
        startGame()
    }
    
    // Time count and processing
    @objc func setGameTimer() {
        time -= 1
        if time == 0 {
            gameTimer?.invalidate()
            targetsTimer?.invalidate()
            
            // TODO: GAME OVER method
            
            setRestartLabel()
        }
    }
    
    func gameOver() {
        
    }
    
    // Create targets and call moveTarget method
    @objc func createTargets() {
        let target = Target()
        let row = Int.random(in: 1...3)
        target.setTarget(row: row)
        addChild(target)
        target.moveTarget()
    }
    
    //  Method called when user touch the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Did user touched the screen?
        guard let touch = touches.first else { return }
        // Get touch location
        let location = touch.location(in: self)
        // Get all the nodes that user tapped on
        let tappedNodes = nodes(at: location)
        
        // Check if restart label exist and restart the game if it is tapped
        checkRestartLabel(tappedNodes: tappedNodes)
        
        // Check if bullets label is in state "RELOAD" and reload bullets if it is tapped
        checkBulletsLabel(tappedNodes: tappedNodes)
    
        if bullets == 0 && location.y > 100 {
            run(dryFireSFX)
        } else if location.y > 100 {
            shot()
            // Check all tapped nodes
            for node in tappedNodes {
                if let target = node as? Target {
                    score += target.targetPoints
                    run(hitSFX)
                    target.fallDown()
                }
                // TODO: Check if user did tap on the screen, substract 1 point
            }
            
        }
    }
    
    func checkRestartLabel(tappedNodes: [SKNode]) {
        if restartLabel != nil {
            if tappedNodes.contains(restartLabel) {
                restartGame()
            }
        }
    }
    
    func checkBulletsLabel(tappedNodes: [SKNode]) {
        if bulletsLabel.text == "RELOAD" {
            if tappedNodes.contains(bulletsLabel) {
                run(reloadSFX)
                bulletsLabel.text = "RELOADING"
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {[unowned self] in self.bullets = 6
                })
            }
        }
    }
    
    
    // Shot method
    func shot() {
        bullets -= 1
        run(gunshotSFX)
    }
    
    //    MARK: Methods to set initial UI
    
    func setRestartLabel() {
        restartLabel = SKLabelNode(fontNamed: "Chalkduster")
        restartLabel.fontSize = fontSize
        restartLabel.position = CGPoint(x: 45, y: 690)
        restartLabel.horizontalAlignmentMode = .left
        restartLabel.text = "RESTART"
        addChild(restartLabel)
    }
    
    func setBackground() {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 207, y: 368)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
    }
    func setWoodStands() {
        for row in 1...3 {
            let woodStand = SKSpriteNode(imageNamed: "woodStand")
            woodStand.position = CGPoint(x: 207, y: 200 * row)
            woodStand.zPosition = 2
            addChild(woodStand)
        }
    }
    func setScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.fontSize = fontSize
        scoreLabel.position = CGPoint(x: 280, y: 30)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.text = "Score: 0"
        addChild(scoreLabel)
    }
    func setBulletsLabbel() {
        bulletsLabel = SKLabelNode(fontNamed: "Chalkduster")
        bulletsLabel.fontSize = fontSize
        bulletsLabel.horizontalAlignmentMode = .left
        bulletsLabel.position = CGPoint(x: 45, y: 30)
        bulletsLabel.text = "Bullets: 6"
        addChild(bulletsLabel)
    }
    func setTimerLabel() {
        timerLabel = SKLabelNode(fontNamed: "Chalkduster")
        timerLabel.fontSize = fontSize
        timerLabel.position = CGPoint(x: 207, y: 30)
        timerLabel.horizontalAlignmentMode = .center
        timerLabel.text = "60"
        addChild(timerLabel)
    }
}
