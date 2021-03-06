//
//  MyScene.swift
//  SpriteKitToUIKit
//
//  Created by Aizawa Takashi on 2015/06/04.
//  Copyright (c) 2015年 Aizawa Takashi. All rights reserved.
//

import UIKit
import SpriteKit

protocol SpriteViewDelegate {
    func numOfSections()->Int
    func sectionStrings()->[String]
    func numOfItemsInSection( section:Int )->Int
    func itemImageAtIndex( index:NSIndexPath )->ImageObject
    func showSingleImage()
}
class MyScene: SKScene {
    enum TouchKind {
        case none
        case flicScrollDown
        case filckScrollUp
        case pinchout
        case pinchin
        case tapSingle
        case tapDouble
    }
    class TouchEventInfo {
        var prevPoint:CGPoint = CGPointMake(0, 0)
        var prevTime:CFTimeInterval = 0
        var kindOfTouch:TouchKind = TouchKind.none
        var speed:CGFloat = 0
        var intervalTime:CFTimeInterval!
    }
    class SectionInfo {
        var titleNode:SKLabelNode
        var sectionSprite:SKSpriteNode
        var titlePosition:CGPoint
        var sectionPosition:CGPoint
        
        init( title:String, imageName:String ) {
            let imageTexture = SKTexture(imageNamed: imageName)
            sectionSprite = SKSpriteNode(texture: imageTexture)
            titleNode = SKLabelNode(text: title)
            titleNode.fontColor = UIColor.whiteColor()
            titleNode.fontSize = 12
            titlePosition = CGPointMake(0, 0)
            sectionPosition = CGPointMake(0, 0)
        }
    }
    
    private let maxColume:Int = 6
    private let scrollAccellParameter:CGFloat = 0.3
    private let decleaseSpeedParam:CGFloat = 4
    
/*
    let xOffset47Inchx1:CGFloat = 19
    let yOffset47InchCase1x1:CGFloat = 13
    let yOffset47InchCase2x1:CGFloat = 28
    
    let xOffset47Inchx2:CGFloat = 28
    let yOffset47InchCase1x2:CGFloat = 19
    let yOffset47InchCase2x2:CGFloat = 42
    
    let xOffset47Inchx3:CGFloat = 19
    let yOffset47InchCase1x3:CGFloat = 13
    let yOffset47InchCase2x3:CGFloat = 28
    
    let xOffset47Inchx4:CGFloat = 14
    let yOffset47InchCase1x4:CGFloat = 11
    let yOffset47InchCase2x4:CGFloat = 28
    
    let xOffset47Inchx5:CGFloat = 11
    let yOffset47InchCase1x5:CGFloat = 8
    let yOffset47InchCase2x5:CGFloat = 17
    
    let xOffset47Inchx6:CGFloat = 10
    let yOffset47InchCase1x6:CGFloat = 7
    let yOffset47InchCase2x6:CGFloat = 15
*/
    private let xOffset47Inchx1:CGFloat = 0
    private let yOffset47InchCase1x1:CGFloat = 0
    private let yOffset47InchCase2x1:CGFloat = 0
    
    private let xOffset47Inchx2:CGFloat = 0
    private let yOffset47InchCase1x2:CGFloat = 0
    private let yOffset47InchCase2x2:CGFloat = 0
    
    private let xOffset47Inchx3:CGFloat = 0
    private let yOffset47InchCase1x3:CGFloat = 0
    private let yOffset47InchCase2x3:CGFloat = 0
    
    private let xOffset47Inchx4:CGFloat = 0
    private let yOffset47InchCase1x4:CGFloat = 0
    private let yOffset47InchCase2x4:CGFloat = 0
    
    private let xOffset47Inchx5:CGFloat = 0
    private let yOffset47InchCase1x5:CGFloat = 0
    private let yOffset47InchCase2x5:CGFloat = 0
    
    private let xOffset47Inchx6:CGFloat = 0
    private let yOffset47InchCase1x6:CGFloat = 0
    private let yOffset47InchCase2x6:CGFloat = 0

    
    private let xOffset55Inch:CGFloat = 0
    private let yOffset55InchCase1:CGFloat = 0
    private let yOffset55InchCase2:CGFloat = 0
    private let xOffset4Inch:CGFloat = 0
    private let yOffset4InchCase1:CGFloat = 0
    private let yOffset4InchCase2:CGFloat = 0
    private let xOffset35Inch:CGFloat = 0
    private let yOffset35InchCase1:CGFloat = 0
    private let yOffset35InchCase2:CGFloat = 0
    
    private let widthAjust:CGFloat = 0
    private let singleViewAroundSpace:CGFloat = 10
    
    private var screenSize:CGSize
    var colume:Int = 5 {
        didSet{
            getOffset(false)
        }
    }
    var intervalSpace:CGFloat = 10.0
    var aroundSpace:CGFloat = 50.0
    //let imageManager:ImageManager!
    //var imageSpriteArray:[ImageSprite] = []
    private var imageSpriteArray:[[ImageSprite]] = []
    var spriteViewDelegate:SpriteViewDelegate? = nil
    
    private var imagesForDraw:[ImageSprite] = []
    private var xOffset:CGFloat = 0
    private var yOffset:CGFloat = 0
    private var touchObject:TouchEventInfo!
    private var pinchCount:Int = 0
    private var sectionTitles:[SectionInfo] = []
    private var totalDisplayHeight:CGFloat = 0
    private var maxHeightIndex:NSIndexPath!
    private var munOfSection:Int = 1
    private var backupSingleViewSprite:ImageSprite!
    private var blurEffectNode:SKEffectNode!
    
    override init() {
        screenSize = CGSizeMake(0, 0)
        //imageManager = AssetManager.sharedInstance
        super.init()
        //imageManager.setupData()
        touchObject = TouchEventInfo()
        getOffset(true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        screenSize = CGSizeMake(0, 0)
        //imageManager = AssetManager.sharedInstance
        super.init(coder: aDecoder)
        //imageManager.setupData()
        touchObject = TouchEventInfo()
        getOffset(true)
    }
    
    override init(size: CGSize) {
        screenSize = size
        //imageManager = AssetManager.sharedInstance
        super.init(size: size)
        //imageManager.setupData()
        touchObject = TouchEventInfo()
        getOffset(true)
    }

    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        screenSize = CGSizeMake(self.view!.frame.width,self.view!.frame.height)
        
        munOfSection = self.spriteViewDelegate!.numOfSections()
        
        buildTotalImages(true,scaleChange: false)
        //self.prepareImageSpriteToDraw(0, endHeight: screenSize.height+500)
        getOffset(true)
        blurEffectNode = SKEffectNode()
        let filter:CIFilter = CIFilter(name: "CIGaussianBlur")
        filter.setDefaults()
        filter.setValue(10, forKey: "inputRadius")
        self.blurEffectNode.filter = filter
        self.blurEffectNode.blendMode = SKBlendMode.Multiply
        
        self.addChild(blurEffectNode)
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        if touches.count == 1 {
            let touch = touches.first as! UITouch
            let locaion = touch.locationInNode(self)
            let selectedNode = self.nodeAtPoint(locaion)
            if selectedNode.name == "Image" {
                touchObject.prevPoint = locaion
                touchObject.prevTime = touch.timestamp
            }
        }
        /*
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            touchObject.prevPoint = location
            touchObject.prevTime = touch.timestamp
        }
        */
    }
    private func tapEvent( point:CGPoint ) {
        alphaAction(0.2, duration: 0.3)
        let selectedNode:SKImageSpriteNode = self.nodeAtPoint(point) as! SKImageSpriteNode
        showSingleView(selectedNode.imageSprite)
        spriteViewDelegate?.showSingleImage()
    }
    private func longTapEvent( point:CGPoint ) {
        
    }
    
    func closeSingleView() {
        self.backupSingleViewSprite.removeSpriteWithAnimation(0.2)
    }
    private func showSingleView( imageSprite:ImageSprite ){
        /*
        func makeSingleViewSprite( index:NSIndexPath ) {
            if self.backupSingleViewSprite != nil {
                self.removeSprite(backupSingleViewSprite)
                self.backupSingleViewSprite = nil
            }
            let imageObject:ImageObject! = spriteViewDelegate?.itemImageAtIndex(index)
            let sizeOfOriginal = imageObject.getSize()
            let width = self.view!.frame.width - singleViewAroundSpace*2
            
            let size = CGSizeMake(width, width/sizeOfOriginal.width*sizeOfOriginal.height)
            imageObject.getImageWithSize(size, callback: { (imageData) -> Void in
                let imageTexture = SKTexture(image: imageData)
                let singleViewSprite = SKSpriteNode(texture: imageTexture, color: UIColor.blackColor(), size: imageSprite.sprite.size)
                //let singleViewSprite = SKSpriteNode(texture: imageTexture)
                singleViewSprite.anchorPoint = CGPoint(x: 0, y: 1)
                singleViewSprite.name = "SingleView"
                singleViewSprite.position =  imageSprite.sprite.position
                self.addChild(singleViewSprite)
                let pos = CGPointMake(self.singleViewAroundSpace, (self.view!.frame.height-size.height)/2)
                let moveAction:SKAction = SKAction.moveTo(self.convertPointFromView(pos), duration: 0.3)
                let rotateAction:SKAction
                if size.width > size.height {
                    rotateAction = SKAction.rotateToAngle(0, duration: 0.3)
                }else{
                    rotateAction = SKAction.rotateToAngle(CGFloat(M_PI/2), duration: 0.0)
                }
                let scaleAction:SKAction = SKAction.scaleTo(size.width/imageSprite.sprite.size.width, duration: 0.3)
                let actionArray = [moveAction,scaleAction/*,rotateAction*/]
                //let actionArray = [moveAction]
                let action = SKAction.group(actionArray)
                singleViewSprite.runAction(action)
                self.backupSingleViewSprite = singleViewSprite
            })
        }
        let index = imageSprite.indexPath
        makeSingleViewSprite(index)
        */
        let index = imageSprite.indexPath
        let width = self.view!.frame.width - singleViewAroundSpace*2
        let singleViewImageSprite = ImageSprite(index: index, targetWidth:imageSprite.sprite.size.width, size:imageSprite.sprite.size, scene:self)
        self.backupSingleViewSprite = singleViewImageSprite
        singleViewImageSprite.setPosition(self.convertPointToView(imageSprite.sprite.position) )
        let pos = CGPointMake(self.singleViewAroundSpace, (self.view!.frame.height-width/imageSprite.sprite.size.width*imageSprite.sprite.size.height)/2)
        singleViewImageSprite.addSpriteToSceneWithAnimation(pos, targetSizeWidth: width, duration: 0.2) { (index) -> ImageObject in
                let imageObj:ImageObject! = self.spriteViewDelegate?.itemImageAtIndex(index)
                return imageObj
        }
        //singleViewImageSprite.setTargetSize(CGSizeMake(width, width*imageSprite.originalSize.height/imageSprite.originalSize.width))
        //singleViewImageSprite.setPosition(pos)
        //singleViewImageSprite.moveWithAction()
        
    }
    private func alphaAction(alpha:CGFloat, duration:NSTimeInterval) {
        let alhaAction = SKAction.fadeAlphaTo(alpha, duration: duration)
        //var removeImage:[AnyObject] = []
        for array in imageSpriteArray{
            for imageSprite in array {
                if imageSprite.sprite != nil {
                    imageSprite.sprite.runAction(alhaAction)
                    /*
                    let imgSp = imageSprite as ImageSprite
                    if imgSp.isDisplay == true {
                        if alpha != 1.0 {
                            removeImage.append(imageSprite.sprite)
                            self.removeChildrenInArray(removeImage)
                            self.blurEffectNode.addChild(imageSprite.sprite)
                        }else{
                            removeImage.append(imageSprite.sprite)
                            self.blurEffectNode.removeChildrenInArray(removeImage)
                            self.addChild(imageSprite.sprite)
                        }
                    }
                    */
                }
            }
        }
    }
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        if touches.count == 1 {
            let touch = touches.first as! UITouch
            let location = touch.locationInNode(self)
            let selectedNode = self.nodeAtPoint(location)
            if selectedNode.name == "Image" {
                if touchObject.prevPoint == location {
                    if touch.timestamp - touchObject.prevTime < 1 {
                        tapEvent( location )
                    }else{
                        longTapEvent( location )
                    }
                }else{
                    let distance:CGFloat = location.y - touchObject.prevPoint.y
                    let time = touch.timestamp - touchObject.prevTime
                    let speed = distance / CGFloat(time)
                    touchObject.speed = abs(speed)
                    if location.y > touchObject.prevPoint.y {
                        touchObject.kindOfTouch = TouchKind.flicScrollDown
                    }else{
                        touchObject.kindOfTouch = TouchKind.filckScrollUp
                    }
                    touchObject.intervalTime = touch.timestamp
                }
            }
        }
/*
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            let distance:CGFloat = location.y - touchObject.prevPoint.y
            let time = touch.timestamp - touchObject.prevTime
            let speed = distance / CGFloat(time)
            touchObject.speed = abs(speed)
            if location.y > touchObject.prevPoint.y {
                touchObject.kindOfTouch = TouchKind.flicScrollDown
            }else{
                touchObject.kindOfTouch = TouchKind.filckScrollUp
            }
            touchObject.intervalTime = touch.timestamp
        }
*/
    }
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            if touch.tapCount == 1 {
                
                let distance = touchObject.prevPoint.y - location.y
                scrollImageSprite(distance,isBoundRequest: false)
            }
        }
    }
    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        
    }
    
    func crashImages() {
        var flag = false
        for array in imageSpriteArray{
            for imageSprite in array {
                if imageSprite.sprite != nil {
                    imageSprite.sprite.physicsBody = SKPhysicsBody(rectangleOfSize: imageSprite.sprite.size)
                    if flag == true {
                        imageSprite.sprite.physicsBody?.applyForce(CGVectorMake(-0.4, -1.0))
                        imageSprite.sprite.physicsBody?.applyTorque(-0.5)
                        flag = false
                    }else{
                        imageSprite.sprite.physicsBody?.applyForce(CGVectorMake(0.4, -1.0))
                        imageSprite.sprite.physicsBody?.applyTorque(0.5)
                        flag = true
                    }
                }
            }
        }
    }
    func rebuildImages() {
        for array in imageSpriteArray{
            for imageSprite in array {
                if imageSprite.sprite != nil {
                    imageSprite.sprite.physicsBody = nil
                    imageSprite.moveWithAnimation()
                }
            }
        }
    }
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        removeImageSprite(-200, endHeight: screenSize.height+200)
        switch touchObject.kindOfTouch {
        case .flicScrollDown:
            println("")
            let distance = touchObject.speed * scrollAccellParameter
            scrollImageSprite(-distance,isBoundRequest: false)
            touchObject.speed -= CGFloat(currentTime - touchObject.intervalTime) * decleaseSpeedParam
            if touchObject.speed < 0 {
                touchObject.speed = 0
                touchObject.kindOfTouch = TouchKind.none
            }
        case .filckScrollUp:
            println("")
            let distance = touchObject.speed * scrollAccellParameter
            scrollImageSprite(distance,isBoundRequest: false)
            touchObject.speed -= CGFloat(currentTime - touchObject.intervalTime) * decleaseSpeedParam
            if touchObject.speed < 0 {
                touchObject.speed = 0
                touchObject.kindOfTouch = TouchKind.none
            }
        default:
            println("")
        }
        /*
        for imageSprite in imagesForDraw {
            let node = imageSprite.sprite
            if node != nil {
                let (isExist:Bool,index:Int) = self.containObject(self.children, object: node)
                if !isExist {
                    //if !contains(self.children as! [SKSpriteNode], node) {
                    self.addChild(node)
                }
            }
        }
        */
    }
    
    func changeScale( scale:CGFloat ) {
        
        pinchCount++
        if pinchCount < 10 {
            return
        }
        if scale > 1.0 {
            colume = colume - 1
            if colume < 2 {
                colume = 2
            }
        }else{
            colume = colume + 1
            if colume > maxColume {
                colume = maxColume
            }
        }
        buildTotalImages(false,scaleChange: true)
        pinchCount = 0
    }
    
    // private functions
    func timerFunc() {
        buildTotalImages(false,scaleChange: true)
    }
    
    private func crashImagesLocal() {
        for imageSprite in imagesForDraw {
            if imageSprite.sprite != nil {
                imageSprite.sprite.physicsBody = SKPhysicsBody(rectangleOfSize: imageSprite.sprite.size)
                imageSprite.sprite.physicsBody?.applyForce(CGVectorMake(1.0, 1.0))
            }
        }
    }
    private func removeAllImageSprite() {
        var removeImage:[AnyObject] = []
        for var i = 0; i < imagesForDraw.count; i++ {
            let imageSprite = imagesForDraw[i]
            if imageSprite.sprite != nil {
                removeImage.append(imageSprite.sprite)
                imageSprite.sprite = nil
                imagesForDraw.removeAtIndex(i)
            }
        }
        self.removeChildrenInArray(removeImage)
    }
    
    private func getOffset( isVirtical:Bool ) {
        switch self.colume {
        case 1:
            xOffset = xOffset47Inchx1
            if isVirtical {
                yOffset = yOffset47InchCase1x2
            }else{
                yOffset = yOffset47InchCase1x1
            }
        case 2:
            xOffset = xOffset47Inchx2
            if isVirtical {
                yOffset = yOffset47InchCase2x2
            }else{
                yOffset = yOffset47InchCase1x2
            }
        case 3:
            xOffset = xOffset47Inchx3
            if isVirtical {
                yOffset = yOffset47InchCase2x3
            }else{
                yOffset = yOffset47InchCase1x3
            }
        case 4:
            xOffset = xOffset47Inchx4
            if isVirtical {
                yOffset = yOffset47InchCase2x4
            }else{
                yOffset = yOffset47InchCase1x4
            }
        case 5:
            xOffset = xOffset47Inchx5
            if isVirtical {
                yOffset = yOffset47InchCase2x5
            }else{
                yOffset = yOffset47InchCase1x5
            }
        case 6:
            xOffset = xOffset47Inchx6
            if isVirtical {
                yOffset = yOffset47InchCase2x6
            }else{
                yOffset = yOffset47InchCase1x6
            }
        default:
            println("error")
        }
    }
    
    private func containObject ( array:[AnyObject], object:AnyObject )->(Bool,Int) {
        println("array.count :\(array.count)")
        for (index, obj) in enumerate(array) {
            if obj === object {
                return (true,index)
            }
        }
        return (false,-1)
    }
    private func buildTotalImages( initializeFlag:Bool,scaleChange:Bool ) {
        if initializeFlag == true {
            //let sections = imageManager.getSectionArray()
            let sections:[String]? = self.spriteViewDelegate?.sectionStrings()
            for sectionTitleString in sections! {
                let sectionSprite = SectionInfo(title: sectionTitleString, imageName: "SectionBar.png")
                self.addChild(sectionSprite.sectionSprite)
                self.addChild(sectionSprite.titleNode)
                sectionTitles.append(sectionSprite)
            }
        }else{
            
        }
        var sectionStartPosition:CGFloat = 0
        for (index,sectionSprite) in enumerate(sectionTitles) {
            sectionSprite.sectionSprite.size.width = self.view!.frame.width
            sectionSprite.sectionSprite.size.height = 30
            sectionSprite.sectionSprite.anchorPoint =  CGPoint(x: 0, y: 1)
            let sectionPosition = CGPointMake(0, sectionStartPosition)
            sectionSprite.sectionPosition = sectionPosition
            sectionSprite.sectionSprite.position = self.convertPointFromView(sectionPosition)
            let position = CGPointMake(50, sectionStartPosition+sectionSprite.sectionSprite.size.height/2)
            sectionSprite.titlePosition = position
            sectionSprite.titleNode.position = self.convertPointFromView(position)
            sectionStartPosition += sectionSprite.sectionSprite.size.height
            sectionStartPosition = buildImageInSection(index, startYpos:sectionStartPosition, initializeFlag:initializeFlag,scaleChange: scaleChange)
        }
        totalDisplayHeight = sectionStartPosition
    }
    private func buildImageInSection( section:Int, startYpos:CGFloat, initializeFlag:Bool,scaleChange:Bool )->CGFloat {
        var imagesInSection:[ImageSprite] = []
        //let numOfImage = imageManager.getImageCount(section)
        let numOfImage = spriteViewDelegate?.numOfItemsInSection(section)
        let spriteWidth = (screenSize.width - widthAjust - aroundSpace*2 - CGFloat(colume-1)*intervalSpace + xOffset*CGFloat(colume))  / CGFloat(colume)
        var totalHeight:CGFloat = 0
        for var i = 0; i < numOfImage; i++ {
            let imageSprite:ImageSprite
            if initializeFlag == true {
                let index = NSIndexPath(forRow: i, inSection: section)
                //let imageObject:ImageObject = imageManager.getImageObjectIndexAt(index)!
                let imageObject:ImageObject! = spriteViewDelegate?.itemImageAtIndex(index)
                let sizeOfOriginal = imageObject.getSize()
                let size = CGSizeMake(spriteWidth, spriteWidth/sizeOfOriginal.width*sizeOfOriginal.height)
                imageSprite = ImageSprite(index: index, targetWidth:spriteWidth, size:size, scene:self)
                
            }else{
                imagesInSection = imageSpriteArray[section] as [ImageSprite]
                imageSprite = imagesInSection[i]
                if imageSprite.sprite != nil {
                    imageSprite.sprite.physicsBody = nil
                }
            }
            let pos:CGPoint
            println("spriteWidth = \(spriteWidth)")
            let x = (spriteWidth-xOffset)*CGFloat(i % self.colume) + self.aroundSpace + self.intervalSpace*CGFloat(i % self.colume)
            println("x= \(x)")
            println("xOffset= \(xOffset)")
            let num = i  % self.colume
            println("i % self.colume= \(num)")
            println("self.aroundSpace= \(self.aroundSpace)")
            println("self.intervalSpace= \(self.intervalSpace)")
            if i < self.colume {
                let y = 0+self.aroundSpace + startYpos
                pos = CGPointMake(x, y)
            }else{
                let prevSprite:ImageSprite = imagesInSection[i-self.colume]
                if prevSprite.originalSize.height > prevSprite.originalSize.width {
                    getOffset(true)
                }else{
                    getOffset(false)
                }
                let y = prevSprite.posotion.y + prevSprite.targetSize.height + self.intervalSpace - yOffset
                pos = CGPointMake(x, y)
            }
            if totalHeight < pos.y + imageSprite.targetSize.height {
                totalHeight = pos.y + imageSprite.targetSize.height
                let index = NSIndexPath(forRow: i, inSection: section)
                maxHeightIndex = index
            }
            if scaleChange == false {
                imageSprite.setPosition(pos)
                imagesInSection.append(imageSprite)
                imageSprite.move(-200, end: screenSize.height+300, callback: { (index) -> ImageObject in
                    let imageObj:ImageObject! = self.spriteViewDelegate?.itemImageAtIndex(index)
                    return imageObj
                })

            }else{
                imageSprite.setTargetSize(CGSizeMake(spriteWidth, spriteWidth*imageSprite.originalSize.height/imageSprite.originalSize.width))
                imageSprite.setPosition(pos)
                imageSprite.moveWithAction()
            }
        }
        if scaleChange == false {
            imageSpriteArray.append(imagesInSection)
        }
        return totalHeight
    }
    private func prepareImageSpriteToDraw( startHeight:CGFloat, endHeight:CGFloat ) {
        var totalHeight:CGFloat = 0
        for var i = 0; i < self.imageSpriteArray.count; i++ {
            let imagesInSection = self.imageSpriteArray[i]
            for var j = 0; j < imagesInSection.count; j++ {
                let currentHeight = imagesInSection[j].posotion.y + imagesInSection[j].targetSize.height
                if imagesInSection[j].posotion.y > startHeight && currentHeight < endHeight {
                    let index = imagesInSection[j].indexPath
                    //let imageObject:ImageObject = imageManager.getImageObjectIndexAt(index)!
                    let imageObject:ImageObject! = spriteViewDelegate?.itemImageAtIndex(index)
                    imageObject.getImageWithSize(imagesInSection[index.row].originalSize, callback: { (image) -> Void in
                        let imageSprite = imagesInSection[index.row]
                        imageSprite.setImageData(image)
                        self.imagesForDraw.append(imageSprite)
                    })
                }
            }
        }
    }
    
    private func removeImageSprite( startHeight:CGFloat, endHeight:CGFloat ) {
        var removeImage:[AnyObject] = []
        let count = imagesForDraw.count
        for var index = 0; index < imagesForDraw.count; index++  {
            let imageSprite = imagesForDraw[index]
            let currentHeight = imageSprite.posotion.y + imageSprite.targetSize.height
            if currentHeight > endHeight || currentHeight < startHeight {
                if imageSprite.sprite != nil {
                    let (isExist:Bool,index:Int) = self.containObject(self.children, object: imageSprite.sprite)
                    if isExist == true {
                        if index < imagesForDraw.count {
                            removeImage.append(imageSprite.sprite)
                            imageSprite.sprite = nil
                            imagesForDraw.removeAtIndex(index)
                        }else{
                            //println("error")
                        }
                    }
                }
            }
        }
        self.removeChildrenInArray(removeImage)
    }
    
    func removeImageSprite(imageSprite:ImageSprite) {
        var removeImage:[AnyObject] = []
        let currentHeight = imageSprite.posotion.y + imageSprite.targetSize.height
        if imageSprite.sprite != nil {
            let (isExist:Bool,index:Int) = self.containObject(self.children, object: imageSprite.sprite)
            if isExist == true {
                removeImage.append(imageSprite.sprite)
                imageSprite.sprite = nil
                self.removeChildrenInArray(removeImage)
                alphaAction(1.0, duration: 0.3)
            }
        }
    }
    private func removeSprite( sprite:SKSpriteNode ) {
        let alhaAction = SKAction.fadeAlphaTo(0.0, duration: 0.2)
        sprite.runAction(alhaAction)
        var removeImage:[AnyObject] = []
        removeImage.append(sprite)
        self.removeChildrenInArray(removeImage)
    }
    private func boundAnimation( delta:CGFloat ) {
        scrollImageSprite(-delta,isBoundRequest: true)
    }
    private func scrollImageSprite( distance:CGFloat, isBoundRequest:Bool ) {
        var totalHeight:CGFloat = 0
        var isBound:Bool = false
        var delta:CGFloat = 0
        for (index,section) in enumerate(sectionTitles) {
            let sectionPos = CGPointMake(section.sectionPosition.x, section.sectionPosition.y+distance)
            if index == 0 {
                if sectionPos.y > 0 && distance > 0 {
                    isBound = true
                    delta = sectionPos.y
                }
            }
            section.sectionPosition = sectionPos
            let titlePos = CGPointMake(section.titlePosition.x, section.titlePosition.y+distance)
            section.titlePosition = titlePos
            
            if isBoundRequest == false {
                section.sectionSprite.position = convertPointFromView(sectionPos)
                section.titleNode.position = convertPointFromView(titlePos)
            }else{
                let moveAction:SKAction = SKAction.moveTo(convertPointFromView(section.sectionPosition) , duration: 0.1)
                let actionArray = [moveAction]
                let action = SKAction.group(actionArray)
                section.sectionSprite.runAction(action)
                let moveActionString:SKAction = SKAction.moveTo(convertPointFromView(section.titlePosition) , duration: 0.1)
                let actionArrayString = [moveActionString]
                let actionString = SKAction.group(actionArrayString)
                section.titleNode.runAction(actionString)
            }
        }
        for imagesInSection in imageSpriteArray {
            for imageSprite in imagesInSection{
                
                imageSprite.posotion = CGPointMake(imageSprite.posotion.x, imageSprite.posotion.y+distance)
                //removeImageSprite(imageSprite)
                if isBoundRequest == false {
                    //let isNewItem = imageSprite.move(-200, end: screenSize.height+300)
                    let isNewItem = imageSprite.move(-100, end: screenSize.height+100, callback: { (index) -> ImageObject in
                        let imageObj:ImageObject! = self.spriteViewDelegate?.itemImageAtIndex(index)
                        return imageObj
                    })
                    if isNewItem == true {
                        //imagesForDraw.append(imageSprite)
                    }
                    if maxHeightIndex == imageSprite.indexPath {
                        if imageSprite.sprite != nil {
                            if imageSprite.posotion.y + imageSprite.sprite.size.height < screenSize.height && distance < 0 {
                                isBound = true
                                delta = imageSprite.posotion.y + imageSprite.sprite.size.height - screenSize.height
                            }
                        }
                    }
                }else{
                    imageSprite.moveWithAnimation()
                }
                
            }
        }
        if isBound == true {
            boundAnimation(delta)
        }
    }
}



