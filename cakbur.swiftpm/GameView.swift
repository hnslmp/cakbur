import SwiftUI
import SpriteKit

enum Direction: String {
    case up = "up"
    case left = "left"
    case right = "right"
    case down = "down"
}

class GameScene: SKScene {
    
    let player = SKSpriteNode(color: .white, size: CGSize(width: 16, height: 16))

    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        player.position = CGPoint(x: self.frame.width / 2, y: 90)
        addChild(player)
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        setupButton()
    }
    
    private func setupButton() {
        let width: CGFloat = self.frame.width

        let buttonUp = SgButton(normalImageNamed: "arrow-top.png", buttonFunc: tappedButton)
        buttonUp.position = CGPointMake(width/2, 60)
        buttonUp.tag = Direction.up.rawValue
        self.addChild(buttonUp)
        
        let buttonDown = SgButton(normalImageNamed: "arrow-bottom.png", buttonFunc: tappedButton)
        buttonDown.position = CGPointMake(width/2, 30)
        buttonDown.tag = Direction.down.rawValue
        self.addChild(buttonDown)
        
        let buttonLeft = SgButton(normalImageNamed: "arrow-left.png", buttonFunc: tappedButton)
        buttonLeft.position = CGPointMake((width/2) - 15, 45)
        buttonLeft.tag = Direction.left.rawValue
        self.addChild(buttonLeft)
        
        let buttonRight = SgButton(normalImageNamed: "arrow-right.png", buttonFunc: tappedButton)
        buttonRight.position = CGPointMake((width/2) + 15, 45)
        buttonRight.tag = Direction.right.rawValue
        self.addChild(buttonRight)
    }
        
    private func move(_ direction: Direction){
        
        let moveRange = CGFloat(25)
        let moveDuration = TimeInterval(0.5)

        let position = player.position
        
        switch direction {
            
        case .up:
            let action = SKAction.move(to: CGPoint(x: position.x, y: position.y + moveRange), duration: moveDuration)
            player.run(action)
        case .left:
            let action = SKAction.move(to: CGPoint(x: position.x - moveRange, y: position.y), duration: moveDuration)
            player.run(action)
        case .right:
            let action = SKAction.move(to: CGPoint(x: position.x + moveRange, y: position.y), duration: moveDuration)
            player.run(action)
        case .down:
            let action = SKAction.move(to: CGPoint(x: position.x, y: position.y - moveRange), duration: moveDuration)
            player.run(action)
        }
    }
    
    func tappedButton(button: SgButton) {
        switch button.tag {
        case Direction.up.rawValue:
            move(.up)
        case Direction.down.rawValue:
            move(.down)
        case Direction.left.rawValue:
            move(.left)
        case Direction.right.rawValue:
            move(.right)
        default:
            break
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
