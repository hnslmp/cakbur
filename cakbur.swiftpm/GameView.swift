import SwiftUI
import SpriteKit

enum Direction: String {
    case up
    case left
    case right
    case down
}

class GameScene: SKScene {
    
    let attacker1 = SKSpriteNode(color: .white, size: CGSize(width: 16, height: 16))
    let attacker2 = SKSpriteNode(color: .white, size: CGSize(width: 16, height: 16))
    let attacker3 = SKSpriteNode(color: .white, size: CGSize(width: 16, height: 16))
    let attacker4 = SKSpriteNode(color: .white, size: CGSize(width: 16, height: 16))
    let attacker5 = SKSpriteNode(color: .white, size: CGSize(width: 16, height: 16))
    let attacker6 = SKSpriteNode(color: .white, size: CGSize(width: 16, height: 16))
    
    var activeAttackerIndex = 1

    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        
        attacker1.position = CGPoint(x: 30, y: 90)
        addChild(attacker1)
        
        attacker2.position = CGPoint(x: 60, y: 90)
        addChild(attacker2)
        
        attacker3.position = CGPoint(x: 90, y: 90)
        addChild(attacker3)
        
        attacker4.position = CGPoint(x: 120, y: 90)
        addChild(attacker4)
        
        attacker5.position = CGPoint(x: 150, y: 90)
        addChild(attacker5)
        
        attacker6.position = CGPoint(x: 180, y: 90)
        addChild(attacker6)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        setupButton()
    }
    
    private func setupButton() {
        let width: CGFloat = self.frame.width

        let buttonUp = SgButton(normalImageNamed: "arrow-top.png", buttonFunc: tappedButton)
        buttonUp.position = CGPointMake(width/2, 60)
        buttonUp.tag = "buttonUp"
        self.addChild(buttonUp)
        
        let buttonDown = SgButton(normalImageNamed: "arrow-bottom.png", buttonFunc: tappedButton)
        buttonDown.position = CGPointMake(width/2, 30)
        buttonDown.tag = "buttonDown"
        self.addChild(buttonDown)
        
        let buttonLeft = SgButton(normalImageNamed: "arrow-left.png", buttonFunc: tappedButton)
        buttonLeft.position = CGPointMake((width/2) - 15, 45)
        buttonLeft.tag = "buttonLeft"
        self.addChild(buttonLeft)
        
        let buttonRight = SgButton(normalImageNamed: "arrow-right.png", buttonFunc: tappedButton)
        buttonRight.position = CGPointMake((width/2) + 15, 45)
        buttonRight.tag = "buttonRight"
        self.addChild(buttonRight)
        
        let buttonSwitch = SgButton(normalImageNamed: "switch.png", buttonFunc: tappedButton)
        buttonSwitch.position = CGPointMake((width/2) + 60, 45)
        buttonSwitch.tag = "buttonSwitch"
        self.addChild(buttonSwitch)
    }
        
    private func move(attacker: SKSpriteNode, direction: Direction){
        
        let moveRange = CGFloat(25)
        let moveDuration = TimeInterval(0.5)

        let position = attacker.position
        
        switch direction {
            
        case .up:
            let action = SKAction.move(to: CGPoint(x: position.x, y: position.y + moveRange), duration: moveDuration)
            attacker.run(action)
        case .left:
            let action = SKAction.move(to: CGPoint(x: position.x - moveRange, y: position.y), duration: moveDuration)
            attacker.run(action)
        case .right:
            let action = SKAction.move(to: CGPoint(x: position.x + moveRange, y: position.y), duration: moveDuration)
            attacker.run(action)
        case .down:
            let action = SKAction.move(to: CGPoint(x: position.x, y: position.y - moveRange), duration: moveDuration)
            attacker.run(action)
        }
    }
    
    func tappedButton(button: SgButton) {
        
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
    
    func setSelectedAttacker() -> SKSpriteNode? {
        
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
    
    func toggleActiveAttackerIndex(){
        if activeAttackerIndex == 6 {
            activeAttackerIndex = 1
        } else {
            activeAttackerIndex += 1
        }
    }
    
}

struct LineView: View {

    
    var body: some View {
        GeometryReader { geometry in
            
            let width = geometry.size.width
            let height = geometry.size.height
            
            Path { path in
                
                let topLeft = CGPoint(x: 100, y: 200)
                let topRight = CGPoint(x: width - 100, y: 200)
                let topMiddle = CGPoint(x: width/2, y: 200)
                
                let bottomLeft = CGPoint(x: 100, y: height - 400)
                let bottomRight = CGPoint(x: width - 100, y: height - 400)
                let bottomMiddle = CGPoint(x: width/2, y: height - 400)
                
                let horizontalLength = abs(topLeft.y - bottomLeft.y)
                
                let topHalfLeft = CGPoint(x: topLeft.x, y: topLeft.y + horizontalLength/3)
                let topHalfRight = CGPoint(x: topRight.x, y: topLeft.y + horizontalLength/3)
                
                let bottomHalfLeft = CGPoint(x: topLeft.x, y: topLeft.y + horizontalLength/3*2)
                let bottomHalfRight = CGPoint(x: topRight.x, y: topLeft.y + horizontalLength/3*2)
               
                path.move(to: topMiddle)
                path.addLine(to: bottomMiddle)
                
                path.move(to: topLeft)
                path.addLine(to: topRight)
                
                path.move(to: bottomLeft)
                path.addLine(to: bottomRight)
                
                path.move(to: topLeft)
                path.addLine(to: bottomLeft)
                
                path.move(to: topRight)
                path.addLine(to: bottomRight)
                
                path.move(to: topHalfLeft)
                path.addLine(to: topHalfRight)
                
                path.move(to: bottomHalfLeft)
                path.addLine(to: bottomHalfRight)
                
            }
            .stroke(Color.white, lineWidth: 5)
        }
    }
}

struct GameView: View {
    var scene: GameScene {
        let scene = GameScene()
        scene.size = CGSize(width: 300, height: 400)
        scene.scaleMode = .fill
        return scene
        
    }
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .edgesIgnoringSafeArea(.all)
            
            LineView()
        }
    }
}
