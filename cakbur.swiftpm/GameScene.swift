//
//  GameScene.swift
//  cakbur
//
//  Created by Hansel Matthew on 15/04/23.
//

import SwiftUI
import SpriteKit

enum Direction {
    case up
    case left
    case right
    case down
}

enum NodeType {
    case attacker
    case defender
}

struct PhysicsCategory {
  static let none       : UInt32 = 0
  static let all        : UInt32 = UInt32.max
  static let attacker   : UInt32 = 0b1
  static let defender   : UInt32 = 0b10
}

class GameScene: SKScene, ObservableObject {
    
    @Published var activeAttackerIndex = 1
    var successfulAttackerIndexs:[Int] = []
    let horizontalPadding = CGFloat(30)
        
    let attacker1 = AttackerNode(spawnPoint: CGPoint(x: 60, y: 90), nodeIndex: 1)
    let attacker2 = AttackerNode(spawnPoint: CGPoint(x: 90, y: 90), nodeIndex: 2)
    let attacker3 = AttackerNode(spawnPoint: CGPoint(x: 120, y: 90), nodeIndex: 3)
    let attacker4 = AttackerNode(spawnPoint: CGPoint(x: 150, y: 90), nodeIndex: 4)
    let attacker5 = AttackerNode(spawnPoint: CGPoint(x: 180, y: 90), nodeIndex: 5)
    let attacker6 = AttackerNode(spawnPoint: CGPoint(x: 210, y: 90), nodeIndex: 6)
    
    var defender1 = DefenderNode()
    var defender2 = DefenderNode()
    var defender3 = DefenderNode()
    var defender4 = DefenderNode()
    var defender5 = DefenderNode()

    override func didMove(to view: SKView) {
        backgroundColor = .cakburBlack
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        scaleMode = .fill
        size = CGSize(width: 300, height: 400)
        
        setupArena()
        setupAttacker()
        setupDefender()
        setupButton()
    }
    
    private func setupAttacker() {
        addChild(attacker1)
        addChild(attacker2)
        addChild(attacker3)
        addChild(attacker4)
        addChild(attacker5)
        addChild(attacker6)
    }
    
    private func setupDefender() {
        let width = self.frame.width
        let height = self.frame.height
        
        let verticalPadding = CGFloat(70)
        let verticalHeight = CGFloat(270)
        
        let topLeft = CGPoint(x: horizontalPadding, y: height - verticalPadding)
        let topRight = CGPoint(x: width - horizontalPadding, y: height - verticalPadding)
        let topMiddle = CGPoint(x: width/2, y: height - verticalPadding)
        
        let bottomLeft = CGPoint(x: horizontalPadding, y: height - verticalHeight)
        let bottomRight = CGPoint(x: width - horizontalPadding, y: height - verticalHeight)
        let bottomMiddle = CGPoint(x: width/2, y: height - verticalHeight)
        
        let horizontalLength = abs(bottomLeft.y - topLeft.y)
        
        let topHalfLeft = CGPoint(x: topLeft.x, y: bottomLeft.y + horizontalLength/3)
        let topHalfRight = CGPoint(x: topRight.x, y: bottomLeft.y + horizontalLength/3)
        
        let bottomHalfLeft = CGPoint(x: topLeft.x, y: bottomLeft.y + horizontalLength/3*2)
        let bottomHalfRight = CGPoint(x: topRight.x, y: bottomLeft.y + horizontalLength/3*2)
        
        defender1 = DefenderNode(spawnPoint: bottomMiddle, startPoint: bottomMiddle, endPoint: topMiddle)
        addChild(defender1)
        configureDefenderVerticalMove(defender: defender1)
        
        defender2 = DefenderNode(spawnPoint: topLeft, startPoint: topLeft, endPoint: topRight)
        addChild(defender2)
        configureDefenderHorizontalMove(defender: defender2)
        
        defender3 = DefenderNode(spawnPoint: topHalfRight, startPoint: topHalfLeft, endPoint: topHalfRight)
        addChild(defender3)
        configureDefenderHorizontalMove(defender: defender3)
        
        defender4 = DefenderNode(spawnPoint: bottomHalfLeft, startPoint: bottomHalfLeft, endPoint: bottomHalfRight)
        addChild(defender4)
        configureDefenderHorizontalMove(defender: defender4)
        
        defender5 = DefenderNode(spawnPoint: bottomRight, startPoint: bottomLeft, endPoint: bottomRight)
        addChild(defender5)
        configureDefenderHorizontalMove(defender: defender5)
        
    }
    
    private func random() -> CGFloat {
      return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    private func random(min: CGFloat, max: CGFloat) -> CGFloat {
      return random() * (max - min) + min
    }
    
    private func configureDefenderVerticalMove(defender: DefenderNode) {
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run { [self] in
                    let targetPoint = random(min: defender.startPoint.y, max: defender.endPoint.y)
                    let duration = random(min: 1, max: 3)
                    let action = SKAction.move(to: CGPoint(x: defender.position.x, y: targetPoint), duration: duration)
                    defender.run(action)
                },
                SKAction.wait(forDuration: 1.0)
            ])
        ))
    }
    
    private func configureDefenderHorizontalMove(defender: DefenderNode) {
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run { [self] in
                    let targetPoint = random(min: defender.startPoint.x, max: defender.endPoint.x)
                    let duration = random(min: 1, max: 3)
                    let action = SKAction.move(to: CGPoint(x: targetPoint, y: defender.position.y), duration: duration)
                    defender.run(action)
                },
                SKAction.wait(forDuration: 1.0)
            ])
        ))
    }
    
    private func setupArena() {
        
        let finishLabel = SKLabelNode(fontNamed: "PressStart2P")
        finishLabel.text = "Finish"
        finishLabel.fontSize = 65
        finishLabel.fontColor = SKColor.green
        finishLabel.position = CGPoint(x: frame.midX, y: frame.midY)
           
        addChild(finishLabel)

        
        let lineWidth = 1.5
        let lineColor = UIColor.cakburBlue
        
        let width = self.frame.width
        let height = self.frame.height
        
        let horizontalPadding = CGFloat(30)
        let verticalPadding = CGFloat(70)
        let verticalHeight = CGFloat(270)
        
        let topLeft = CGPoint(x: horizontalPadding, y: height - verticalPadding)
        let topRight = CGPoint(x: width - horizontalPadding, y: height - verticalPadding)
        let topMiddle = CGPoint(x: width/2, y: height - verticalPadding)
        
        let bottomLeft = CGPoint(x: horizontalPadding, y: height - verticalHeight)
        let bottomRight = CGPoint(x: width - horizontalPadding, y: height - verticalHeight)
        let bottomMiddle = CGPoint(x: width/2, y: height - verticalHeight)
        
        let horizontalLength = abs(bottomLeft.y - topLeft.y)
        
        let topHalfLeft = CGPoint(x: topLeft.x, y: bottomLeft.y + horizontalLength/3)
        let topHalfRight = CGPoint(x: topRight.x, y: bottomLeft.y + horizontalLength/3)
        
        let bottomHalfLeft = CGPoint(x: topLeft.x, y: bottomLeft.y + horizontalLength/3*2)
        let bottomHalfRight = CGPoint(x: topRight.x, y: bottomLeft.y + horizontalLength/3*2)
        
        let line1 = SKShapeNode()
        let path1 = CGMutablePath()
        line1.strokeColor = lineColor
        line1.lineWidth = lineWidth
        
        path1.move(to: topLeft)
        path1.addLine(to: topRight)
        line1.path = path1
        addChild(line1)
        
        let line2 = SKShapeNode()
        let path2 = CGMutablePath()
        line2.strokeColor = lineColor
        line2.lineWidth = lineWidth
        
        path2.move(to: topMiddle)
        path2.addLine(to: bottomMiddle)
        line2.path = path2
        addChild(line2)
        
        let line3 = SKShapeNode()
        let path3 = CGMutablePath()
        line3.strokeColor = lineColor
        line3.lineWidth = lineWidth
        
        path3.move(to: bottomLeft)
        path3.addLine(to: bottomRight)
        line3.path = path3
        addChild(line3)
        
        let line4 = SKShapeNode()
        let path4 = CGMutablePath()
        line4.strokeColor = lineColor
        line4.lineWidth = lineWidth
        
        path4.move(to: topLeft)
        path4.addLine(to: bottomLeft)
        line4.path = path4
        addChild(line4)
        
        let line5 = SKShapeNode()
        let path5 = CGMutablePath()
        line5.strokeColor = lineColor
        line5.lineWidth = lineWidth
        
        path5.move(to: topRight)
        path5.addLine(to: bottomRight)
        line5.path = path5
        addChild(line5)
        
        let line6 = SKShapeNode()
        let path6 = CGMutablePath()
        line6.strokeColor = lineColor
        line6.lineWidth = lineWidth
        
        path6.move(to: topHalfLeft)
        path6.addLine(to: topHalfRight)
        line6.path = path6
        addChild(line6)
        
        let line7 = SKShapeNode()
        let path7 = CGMutablePath()
        line7.strokeColor = lineColor
        line7.lineWidth = lineWidth
        
        path7.move(to: bottomHalfLeft)
        path7.addLine(to: bottomHalfRight)
        line7.path = path7
        addChild(line7)
    }
    
    private func setupButton() {
        let width: CGFloat = self.frame.width
        let buttonSize = CGSize(width: 24, height: 24)

        let buttonUp = SgButton(normalImageNamed: "arrow-top.png", buttonFunc: tappedButton)
        buttonUp.size = buttonSize
        buttonUp.position = CGPointMake(width/2 - 50, 60)
        buttonUp.tag = "buttonUp"
        self.addChild(buttonUp)
        
        let buttonDown = SgButton(normalImageNamed: "arrow-bottom.png", buttonFunc: tappedButton)
        buttonDown.size = buttonSize
        buttonDown.position = CGPointMake(width/2 - 50, 30)
        buttonDown.tag = "buttonDown"
        self.addChild(buttonDown)
        
        let buttonLeft = SgButton(normalImageNamed: "arrow-left.png", buttonFunc: tappedButton)
        buttonLeft.size = buttonSize
        buttonLeft.position = CGPointMake((width/2 - 50) - 24, 45)
        buttonLeft.tag = "buttonLeft"
        self.addChild(buttonLeft)
        
        let buttonRight = SgButton(normalImageNamed: "arrow-right.png", buttonFunc: tappedButton)
        buttonRight.size = buttonSize
        buttonRight.position = CGPointMake((width/2 - 50) + 24, 45)
        buttonRight.tag = "buttonRight"
        self.addChild(buttonRight)
        
        let buttonSwitch = SgButton(normalImageNamed: "switch.png", buttonFunc: tappedButton)
        buttonSwitch.position = CGPointMake((width/2 - 50) + 60, 45)
        buttonSwitch.tag = "buttonSwitch"
        self.addChild(buttonSwitch)
    }
        
    private func move(attacker: AttackerNode, direction: Direction){
        let moveRange = CGFloat(25)
        let moveDuration = TimeInterval(0.5)

        let position = attacker.position
        
        switch direction {
            
        case .up:
            let action = SKAction.move(to: CGPoint(x: position.x, y: position.y + moveRange), duration: moveDuration)
            attacker.run(action)
        case .left:
            let targetPoint = position.x - moveRange
            guard targetPoint > horizontalPadding else { break }
            
            let action = SKAction.move(to: CGPoint(x: targetPoint, y: position.y), duration: moveDuration)
            attacker.run(action)
        case .right:
            let targetPoint = position.x - moveRange
            let width: CGFloat = self.frame.width
            guard targetPoint < width - horizontalPadding else { break }
            
            let action = SKAction.move(to: CGPoint(x: position.x + moveRange, y: position.y), duration: moveDuration)
            attacker.run(action)
        case .down:
            let targetPoint = position.y - moveRange
            guard targetPoint > 90 else { break }
            
            let action = SKAction.move(to: CGPoint(x: position.x, y: targetPoint), duration: moveDuration)
            attacker.run(action)
        }
        
        if attacker.position.y > 350 {
            attacker.removeAllActions()
            attacker.removeFromParent()
            
            toggleActiveAttackerIndex()
            successfulAttackerIndexs.append(attacker.nodeIndex)
        }
    }
    
    private func tappedButton(button: SgButton) {
        
        guard let attacker = setSelectedAttacker() else { return }
        
        switch button.tag {
        case "buttonUp":
            move(attacker: attacker, direction: .up)
        case "buttonDown":
            move(attacker: attacker, direction: .down)
        case "buttonLeft":
            move(attacker: attacker, direction: .left)
        case "buttonRight":
            move(attacker: attacker, direction: .right)
        case "buttonSwitch":
            toggleActiveAttackerIndex()
        default:
            break
        }
    }
    
    private func setSelectedAttacker() -> AttackerNode? {
        
        if activeAttackerIndex == 1 {
            return attacker1
        } else if activeAttackerIndex == 2 {
            return attacker2
        } else if activeAttackerIndex == 3 {
            return attacker3
        } else if activeAttackerIndex == 4 {
            return attacker4
        } else if activeAttackerIndex == 5 {
            return attacker5
        } else if activeAttackerIndex == 6 {
            return attacker6
        }
        
        return nil
    }
    
    private func toggleActiveAttackerIndex(){
        if activeAttackerIndex == 6 {
            activeAttackerIndex = 1
        } else {
            activeAttackerIndex += 1
        }
        
        if successfulAttackerIndexs.contains(activeAttackerIndex) {
            toggleActiveAttackerIndex()
        }
    }
    
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
      var firstBody: SKPhysicsBody
      var secondBody: SKPhysicsBody
      if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
        firstBody = contact.bodyA
        secondBody = contact.bodyB
      } else {
        firstBody = contact.bodyB
        secondBody = contact.bodyA
      }
     

      if ((firstBody.categoryBitMask & PhysicsCategory.attacker != 0) &&
          (secondBody.categoryBitMask & PhysicsCategory.defender != 0)) {
        if let attacker = firstBody.node as? AttackerNode,
          let defender = secondBody.node as? DefenderNode {
            attacker.removeAllActions()
            attacker.removeFromParent()
            attacker.position = attacker.spawnPoint
            addChild(attacker)
        }
      }
    }
}
