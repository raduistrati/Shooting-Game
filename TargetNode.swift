//
//  TargetNode.swift
//  Shooting Game
//
//  Created by Radu Istrati on 10.05.20.
//  Copyright © 2020 Radu Istrati. All rights reserved.
//

import UIKit
import SpriteKit

class Target: SKNode {
    
    var targetNode: SKSpriteNode!
    var targetSpeed: Float = 1.0
    var targetPoints = 0

    func setTarget(row: Int) {
        
        let yPosition = (200 * row) + 8
        
        if Int.random(in: 0...2) != 0 {
            targetNode = SKSpriteNode(imageNamed: "Red")
            targetNode.name = "red"
            if Int.random(in: 1...2) == 1 {
                targetNode.setScale(CGFloat.random(in: 0.23...0.30))
                targetSpeed = Float.random(in: 1.0...2.0)
                targetPoints = 3
            } else {
                targetNode.setScale(CGFloat.random(in: 0.45...0.55))
                targetSpeed = Float.random(in: 0.6...1.2)
                targetPoints = 2
            }
        } else {
            targetNode = SKSpriteNode(imageNamed: "Green")
            targetNode.name = "green"
            targetPoints = -2
            if Int.random(in: 1...2) == 1 {
                targetNode.setScale(0.25)
                targetSpeed = 2
            } else {
                targetNode.setScale(0.5)
                targetSpeed = 1
            }
        }
        
        targetNode.anchorPoint = CGPoint(x: 0.5, y: 0)
        let angle = CGFloat.random(in: -0.5...0.5)
        targetNode.zRotation = CGFloat(angle)
        self.position = CGPoint(x: -40, y: yPosition)
        addChild(targetNode)
    }
    
    func moveTarget() {
        let move = SKAction.moveTo(x: 500, duration: TimeInterval(targetSpeed))
        let deleteTarget = SKAction.run { [weak self] in self?.removeFromParent() }
        let sequence = SKAction.sequence([move, deleteTarget])
        targetNode.run(sequence)
    }
    
    func fallDown() {
        let scale = SKAction.scaleY(to: 0, duration: 0.2)
        targetNode.run(scale)
    }
}
