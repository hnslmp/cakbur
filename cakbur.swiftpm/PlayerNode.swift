//
//  PlayerNode.swift
//  cakbur
//
//  Created by Hansel Matthew on 15/04/23.
//

import SpriteKit

class AttackerNode: SKSpriteNode {
    
    let spawnPoint: CGPoint
    let nodeIndex: Int
    
    init(spawnPoint: CGPoint, nodeIndex: Int) {
        self.spawnPoint = spawnPoint
        self.nodeIndex = nodeIndex
        super.init(texture: nil, color: .white, size: CGSize(width: 16, height: 16))
        setupNode()
    }
    
    private func setupNode() {
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.attacker
        self.physicsBody?.contactTestBitMask = PhysicsCategory.defender
        self.physicsBody?.collisionBitMask = PhysicsCategory.none
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DefenderNode: SKSpriteNode {
    
    let spawnPoint: CGPoint
    
    // TODO: Create variables to store 2 movement point of node
    
    init(spawnPoint: CGPoint) {
        self.spawnPoint = spawnPoint
        super.init(texture: nil, color: .red, size: CGSize(width: 16, height: 16))
        setupNode()
    }
    
    private func setupNode() {
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.defender
        self.physicsBody?.contactTestBitMask = PhysicsCategory.attacker
        self.physicsBody?.collisionBitMask = PhysicsCategory.none
        self.physicsBody?.usesPreciseCollisionDetection = true

    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
