//
//  SgButton.swift
//  cakbur
//
//  Created by Hansel Matthew on 15/04/23.
//

import SpriteKit

class SgButton: SKSpriteNode {
    enum ButtonType {
        case normal, flip
    }
    
    enum State {
        case normal, highlighted, disabled
    }
    
    class Record {
        var imageFileName: String?
        var imageTexture: SKTexture?
        
        var string: String?
        var fontName: String?
        var fontSize: CGFloat?
        var stringColor: UIColor?

        var backgroundColor: UIColor?
        var cornerRadius: CGFloat?
        
        var buttonSize: CGSize?
        
        var generatedImageTexture: SKTexture?
        
        init() {}
        
        init(imageFileName: String) {
            self.imageFileName = imageFileName
            generateTexture()
        }
        
        init(texture: SKTexture) {
            self.imageTexture = texture
            generateTexture()
        }

        private func getFont() -> UIFont {
            let fSz: CGFloat = fontSize == nil ? 18 : fontSize!
            var font: UIFont
            if fontName != nil {
                let f = UIFont(name: fontName!, size: fSz)
                assert(f != nil, "Error: Cannot create font \(String(describing: fontName)) / \(String(describing: fontSize))")
                font = f!
            } else {
                font = UIFont.systemFont(ofSize: fSz)
            }
            return font
        }
        
        func createBkImage(color: UIColor, size: CGSize, cornerRadius: CGFloat?) -> UIImage? {
            let rect = CGRectMake(0, 0, size.width, size.height)
            UIGraphicsBeginImageContextWithOptions(size, false, 0)
            color.setFill()
            
            if cornerRadius != nil {
                UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius!).addClip()
            }
            
            UIRectFill(rect)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
        
        private func getImage(tex: SKTexture) -> UIImage? {
            let sz = tex.size()
            
            UIGraphicsBeginImageContextWithOptions(sz, false, 0.0);
            _ = UIGraphicsGetCurrentContext();
            
            let rect = CGRectMake(0, 0, sz.width, sz.height)
            let view = SKView(frame:rect)
            let scene = SKScene(size: sz)
            view.backgroundColor = UIColor.clear
            
            scene.backgroundColor = UIColor.black
            let sprite  = SKSpriteNode(texture: tex)
            sprite.position = CGPoint(x: CGRectGetMidX(view.frame), y: CGRectGetMidY(view.frame))
            
            scene.addChild(sprite)
            view.presentScene(scene)
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
            
            let image = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
            
            return image
        }
        
        private let colorMasking:[CGFloat] = [0, 50, 0, 50, 0, 50]

        private func makeTransparent(image: UIImage?) -> UIImage? {
            guard
                let theimage = image,
                let img = UIImage(data: theimage.jpegData(compressionQuality: 1.0)! ),
                let imageRef = img.cgImage?.copy(maskingColorComponents: colorMasking) else {
                return nil
            }
            return UIImage(cgImage: imageRef, scale: theimage.scale, orientation: UIImage.Orientation.up)
        }

        private var textAttributes: [NSAttributedString.Key: Any]?
        private var stringSz: CGSize?
        
        fileprivate func generateTexture() {
            
            if string != nil {
                let color = stringColor == nil ? UIColor.black : stringColor!
                textAttributes = [
                    .foregroundColor: color,
                    .font: getFont()
                ]
                stringSz = string!.size(withAttributes: textAttributes)
            }

            
            if imageFileName != nil || (imageTexture == nil && string != nil) {
                var image: UIImage?
                
                if imageFileName != nil {
                    image = UIImage(named: imageFileName!)
                } else {
                    let sz: CGSize = buttonSize != nil ? buttonSize! : stringSz!
                    let color: UIColor = backgroundColor ?? UIColor.white
                    image = createBkImage(color: color, size: sz, cornerRadius: cornerRadius)
                }
                
                assert(image != nil, "Image is nil")
                
                if let str = string {
                    generatedImageTexture = generatedStringTexture(image: image, string: str)
                } else {
                    generatedImageTexture = SKTexture(image: image!)
                }
                return
            }
            
            if imageTexture != nil {
                if string == nil {
                    generatedImageTexture = imageTexture
                } else {
                    if let image = makeTransparent(image: getImage(tex: imageTexture!)) {
                        generatedImageTexture = generatedStringTexture(image: image, string: string!)
                    }
                }
            }
        }
        
        private func generatedStringTexture(image: UIImage?, string: String) -> SKTexture {
            var sz: CGSize
            
            if buttonSize != nil {
                sz = buttonSize!
            } else if image != nil {
                sz = image!.size
            } else {
                sz = stringSz!
            }

            UIGraphicsBeginImageContextWithOptions(sz, false, 0.0);
            guard let ctx = UIGraphicsGetCurrentContext() else { return SKTexture() };
            
            if image != nil {
                image!.draw(at: CGPointZero)
            } else {
                let color = backgroundColor ?? UIColor.white
                color.setFill()
                ctx.fill(CGRectMake(0, 0, sz.width, sz.height));
            }
            
            let rect = sz==stringSz! ?  CGRectMake(0, 0, sz.width, sz.height) : CGRectMake((sz.width - stringSz!.width) * 0.5, (sz.height - stringSz!.height) * 0.5, stringSz!.width, stringSz!.height)
            (string as NSString).draw(in: rect, withAttributes: textAttributes)
            
            let image = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
            
            return SKTexture(image: image!)
        }
    }
    
    let buttonName = "SgButton"
    
    var tag: String = ""
    
    var buttonFunc: ((_ button: SgButton) -> Void)?
    
    var buttonType = ButtonType.normal
    
    var soundOn = true
    var clickSoundName: String? = nil
    var disableSoundName: String? = nil
        
    private var records = [ State : Record]()
    
    private var isDisabled: Bool = false
    private var _state  = State.normal
    private var _size: CGSize?
    

    func playSound(clickSound: Bool) {
        guard soundOn,
              let soundName = clickSound ? clickSoundName : disableSoundName else {
            return
        }
        
        let soundAct = SKAction.playSoundFileNamed(soundName, waitForCompletion: false)
        self.run(soundAct)
    }

    init(buttonType: ButtonType = .normal,
         normalImageNamed: String,
         highlightedImageNamed: String? = nil,
         disabledImageNamed: String? = nil,
         size: CGSize? = nil,
         clickSoundName: String? = nil,
         disableSoundName: String? = nil,
         buttonFunc: ((_ button: SgButton) -> Void)? = nil) {

        let record = Record(imageFileName: normalImageNamed)
        self.buttonFunc = buttonFunc
        
        super.init(texture: record.generatedImageTexture,
                   color: UIColor.clear,
                   size: record.generatedImageTexture!.size())

        records[ .normal ] = record
        
        self.buttonType = buttonType
        self.clickSoundName = clickSoundName
        self.disableSoundName = disableSoundName
        
        if highlightedImageNamed != nil {
            records[ .highlighted ] = Record(imageFileName: highlightedImageNamed!)
        }
        
        if disabledImageNamed != nil {
            records[ .disabled ] = Record(imageFileName: disabledImageNamed!)
        }
        
        completeInit()
    }
    
    init(buttonType: ButtonType = .normal,
         normalTexture: SKTexture,
         highlightedTexture: SKTexture? = nil,
         disabledTexture: SKTexture? = nil,
         clickSoundName: String? = nil,
         disableSoundName: String? = nil,
         buttonFunc: ((_ button: SgButton) -> Void)? = nil) {

        let record = Record(texture: normalTexture)

        self.buttonFunc = buttonFunc
        
        super.init(texture: record.generatedImageTexture,
                   color: UIColor.clear,
                   size: record.generatedImageTexture!.size())

        records[ .normal ] = record

        self.buttonType = buttonType
        self.clickSoundName = clickSoundName
        self.disableSoundName = disableSoundName

        if highlightedTexture != nil {
            records[ .highlighted ] = Record(texture: highlightedTexture!)
        }
        
        if disabledTexture != nil {
            records[ .disabled ] = Record(texture: disabledTexture!)
        }
        
        completeInit()
    }

    init(buttonType: ButtonType = .normal,
         normalString: String,
         normalStringColor: UIColor = UIColor.white,
         normalBackgroundColor: UIColor = UIColor.blue,

         highlightedString: String? = nil,
         highlightedStringColor: UIColor? = UIColor.yellow,
         highlightedBackgroundColor: UIColor? = UIColor.green,

         disabledString: String? = nil,
         disabledStringColor: UIColor? = UIColor.black,
         disabledBackgroundColor: UIColor? = UIColor.gray,

         fontName: String? = nil,
         fontSize: CGFloat? = nil,
         size: CGSize? = nil,
         cornerRadius: CGFloat? = nil,

         clickSoundName: String? = nil,
         disableSoundName: String? = nil,
         buttonFunc: ((_ button: SgButton) -> Void)? = nil) {

        let record = Record()
        record.string = normalString
        record.stringColor = normalStringColor
        record.fontName = fontName
        record.fontSize = fontSize
        record.backgroundColor = normalBackgroundColor
        record.buttonSize = size
        record.cornerRadius = cornerRadius
        record.generateTexture()
        
        self.buttonFunc = buttonFunc
        
        super.init(texture: record.generatedImageTexture,
                   color: UIColor.clear,
                   size: record.generatedImageTexture!.size())
        
        records[ .normal ] = record

        self.buttonType = buttonType
        self.clickSoundName = clickSoundName
        self.disableSoundName = disableSoundName

        _size = size
        
        if highlightedString?.isEmpty == true
            || highlightedStringColor != nil
            || highlightedBackgroundColor != nil {
            let record = Record()
            record.string = highlightedString ?? normalString
            record.stringColor = highlightedStringColor ?? normalStringColor
            record.fontName = fontName
            record.fontSize = fontSize
            record.backgroundColor = highlightedBackgroundColor ?? normalStringColor
            record.buttonSize = size
            record.cornerRadius = cornerRadius
            record.generateTexture()
            records[ .highlighted ] = record
        }
        
        if disabledString?.isEmpty == true
            || disabledStringColor != nil
            || disabledBackgroundColor != nil {
            let record = Record()
            record.string = disabledString ?? normalString
            record.stringColor = disabledStringColor ?? normalStringColor
            record.fontName = fontName
            record.fontSize = fontSize
            record.backgroundColor = disabledBackgroundColor ?? normalStringColor
            record.buttonSize = size
            record.cornerRadius = cornerRadius
            record.generateTexture()
            records[ .disabled ] = record
        }

        completeInit()
    }
    
    var disabled: Bool {
        set {
            isDisabled = newValue
            state = isDisabled ? .disabled : .normal
            
            if newValue {
                playSound(clickSound: false)
            }
        }
        
        get {
            return self.isDisabled
        }
    }
    
    var state: State {
        get {
            return self._state
        }
        
        set {
            _state = newValue
            if let tex = records[newValue]?.generatedImageTexture {
                self.texture = tex
            }
        }
    }
    

    func setString(state: State, string: String, fontName: String? = nil, fontSize: CGFloat? = nil, stringColor: UIColor? = nil, backgroundColor: UIColor? = nil, size: CGSize? = nil, cornerRadius: CGFloat? = nil) {
        var record = records[ state ]
        if record == nil {
            record = Record()
            records[ state ] = record
        }
        record?.string = string
        
        record!.fontName = fontName != nil ? fontName : records[ .normal ]?.fontName
        record!.fontSize = fontSize != nil ? fontSize : records[ .normal ]?.fontSize
        record!.stringColor = stringColor != nil ? stringColor : records[ .normal ]?.stringColor
        record!.backgroundColor = backgroundColor != nil ? backgroundColor : records[ .normal ]?.backgroundColor
        record!.buttonSize = size != nil ? size : records[ .normal ]?.buttonSize
        record!.cornerRadius = cornerRadius != nil ? cornerRadius : records[ .normal ]?.cornerRadius

        if backgroundColor == nil && state != .normal && record!.imageFileName == nil && record!.imageTexture == nil {
            record!.imageFileName = records[ .normal ]?.imageFileName
            record!.imageTexture = records[ .normal ]?.imageTexture
        }

        record!.generateTexture()
        
        if self.state == state {
            self.state = state
        }
    }
    
    func setImage(state: State, imageFileName: String) {
        var record = records[ state ]
        if record == nil {
            record = Record()
            records[ state ] = record
        }
        
        record!.imageFileName = imageFileName

        record!.generateTexture()
        
        self.state = state
    }

    func setTexture(state: State, texture: SKTexture) {
        var record = records[ state ]
        if record == nil {
            record = Record()
            records[ state ] = record
        }
        
        record!.imageTexture = texture
        
        record!.generateTexture()
        
        self.state = state
    }
    
    private func completeInit() {
        self.isUserInteractionEnabled = true
        self.name = buttonName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isDisabled {
            if buttonType == .flip {
                state = state == .normal ? .highlighted : .normal
            } else {
                state = .highlighted
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isDisabled {
            if buttonType != .flip {
                state = .normal
            }
            
            if buttonFunc != nil {
                if let touch = touches.first {
                    let location = touch.location(in: parent!)
                    if self.contains(location) {
                        playSound(clickSound: true)
                        buttonFunc!(self)
                    }
                }
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
        if !isDisabled && buttonType != .flip {
            state = .normal
        }
    }
    
}
