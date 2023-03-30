import SwiftUI
import SpriteKit

enum Direction {
    case up
    case left
    case right
    case down
}

class GameScene: SKScene {
    
    let player = SKSpriteNode(color: .white, size: CGSize(width: 50, height: 50))
    
    let leftButton: SKNode = {
        let button = SKNode()
        button.name = "left"
        
        let buttonSprite = SKSpriteNode(imageNamed: "")
        button.addChild(buttonSprite)
        
        return button
        
    }()
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
        addChild(player)
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    }
        
    func move(_ direction: Direction){
        
        let moveRange = CGFloat(50)
        let moveDuration = TimeInterval(2)

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
