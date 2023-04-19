//
//  PlayerNode.swift
//  cakbur
//
//  Created by Hansel Matthew on 15/04/23.
//

import SpriteKit

struct PhysicsCategory {
  static let none       : UInt32 = 0
  static let all        : UInt32 = UInt32.max
  static let attacker   : UInt32 = 0b1
  static let defender   : UInt32 = 0b10
}

class AttackerNode: SKSpriteNode {
    
    let spawnPoint: CGPoint
    let nodeIndex: Int
    var isActive: Bool {
        didSet {
            updateNodeImage()
        }
    }
    
    lazy var activeIndicator: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: "ic-active-indicator")
        node.size = CGSize(width: 6, height: 6)
        node.position.y += frame.height - 2
//        node.position = CGPoint(x: frame.midX, y: frame.height)
        return node
    }()
        
    init(spawnPoint: CGPoint = CGPoint(x: 0, y: 0), nodeIndex: Int, isActive: Bool = false) {
        self.spawnPoint = spawnPoint
        self.nodeIndex = nodeIndex
        self.isActive = isActive
        
        super.init(texture: SKTexture(imageNamed: "ic-attacker"), color: .white, size: CGSize(width: 16, height: 16))
        self.position = spawnPoint
        
        setupNode()
        updateNodeImage()
    }
    
    private func setupNode() {
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.attacker
        self.physicsBody?.contactTestBitMask = PhysicsCategory.defender
        self.physicsBody?.collisionBitMask = PhysicsCategory.none
    
        addChild(activeIndicator)
    }
    
    private func updateNodeImage() {
        self.activeIndicator.isHidden = !isActive
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DefenderNode: SKSpriteNode {
    
    var spawnPoint: CGPoint
    var startPoint: CGPoint
    var endPoint: CGPoint
    
    init(spawnPoint: CGPoint = CGPoint(x: 0, y: 0), startPoint: CGPoint = CGPoint(x: 0, y: 0), endPoint: CGPoint = CGPoint(x: 0, y: 0)) {
        self.spawnPoint = spawnPoint
        self.startPoint = startPoint
        self.endPoint = endPoint
        super.init(texture: SKTexture(imageNamed: "ic-defender"), color: .red, size: CGSize(width: 16, height: 16))
        self.position = spawnPoint
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
