import SwiftUI
import SpriteKit

enum Direction: String {
    case up = "up"
    case left = "left"
    case right = "right"
    case down = "down"
}

class GameScene: SKScene {
    
    let player = SKSpriteNode(color: .white, size: CGSize(width: 25, height: 25))

    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        player.position = CGPoint(x: self.frame.width / 2, y: 90)
        addChild(player)
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        setupButton()
    }
    
    func setupButton() {
        let width: CGFloat = self.frame.width
//        let height: CGFloat = self.frame.height

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
        
    func move(_ direction: Direction){
        
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
        }
    }
}
