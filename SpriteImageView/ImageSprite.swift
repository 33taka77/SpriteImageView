//
//  ImageSprite.swift
//  SpriteImageTest
//
//  Created by AizawaTakashi on 2015/05/23.
//  Copyright (c) 2015年 AizawaTakashi. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class ImageSprite {
    private let scene:MyScene
    private var image:UIImage!
    var posotion:CGPoint
    var sprite:SKImageSpriteNode!
    var originalSize:CGSize
    var targetSize:CGSize
    var indexPath:NSIndexPath!
    var scale:CGFloat {
        get {
            return (self.targetSize.width)/self.originalSize.width
        }
    }
    
    var nodePosition:CGPoint {
        get {
            return self.scene.convertPointFromView(self.posotion)
        }
    }
    init(index:NSIndexPath, targetWidth:CGFloat, size:CGSize, scene:MyScene!) {
        self.originalSize =  size
        self.targetSize = self.originalSize
        self.posotion = CGPointMake(0, 0)
        self.scene = scene
        self.image = nil
        self.indexPath = index
        self.setTargetSize(CGSizeMake(targetWidth, targetWidth/self.originalSize.width * self.originalSize.height))
    }
    init(index:NSIndexPath, imageData:UIImage!,targetWidth:CGFloat, scene:MyScene!) {
        self.image = imageData
        self.originalSize =  imageData.size
        self.targetSize = self.originalSize
        self.posotion = CGPointMake(0, 0)
        self.scene = scene
        self.indexPath = index
        let imageTexture = SKTexture(image: imageData)
        self.sprite = SKImageSpriteNode(texture: imageTexture)
        //self.sprite = SKImageSpriteNode(texture: imageTexture,color: UIColor.blackColor(), size: self.targetSize, imageSprite:self)
        self.sprite.anchorPoint = CGPoint(x: 0, y: 1)
        //self.setTargetSize(CGSizeMake(targetWidth+self.scene.xOffset, (targetWidth+self.scene.xOffset)/self.originalSize.width * self.originalSize.height))
    }
    func setTargetSize( targetSize:CGSize ) {
        self.targetSize = targetSize
    }
    func setPosition( position:CGPoint ) {
        self.posotion = position
    }
    func setImageData( imageData:UIImage ) {
        let size:CGSize = imageData.size
        self.originalSize = size
        self.image = imageData
        let imageTexture = SKTexture(image: imageData)
        self.sprite = SKImageSpriteNode(texture: imageTexture)
        //self.sprite = SKImageSpriteNode(texture: imageTexture,color: UIColor.blackColor(), size: self.targetSize, imageSprite:self)
        self.sprite.anchorPoint = CGPoint(x: 0, y: 1)
        
        let userData:NSMutableDictionary? = NSMutableDictionary()
        userData!.setValue(self, forKey: "object")
        self.sprite.userData = userData
        self.sprite.name = "Image"
        self.sprite.imageSprite = self
        sprite.xScale = self.scale
        sprite.yScale = self.scale
        let nodePos = self.nodePosition
        self.sprite.position = nodePos
        //self.sprite.physicsBody = SKPhysicsBody(rectangleOfSize: self.sprite.size)
    }
    func move( start:CGFloat, end:CGFloat, callback:(index:NSIndexPath)->ImageObject)->Bool {
        var result = false
        if self.sprite != nil {
            self.sprite.position = self.nodePosition
        }else{
            if start < self.posotion.y && end > self.posotion.y {
                result = true
                //let imageManager = AssetManager.sharedInstance
                //let imgObj:ImageObject = imageManager.getImageObjectIndexAt(self.indexPath)!
                let imgObj:ImageObject = callback(index: self.indexPath)
                imgObj.getImageWithSize(self.originalSize, callback: { (image) -> Void in
                    self.setImageData(image)
                    self.scene.addChild(self.sprite)
                })
            }
            
        }
        return result
    }
    func addSpriteToSceneWithAnimation( position:CGPoint, targetSizeWidth:CGFloat, duration:NSTimeInterval, callback:(index:NSIndexPath)->ImageObject) {
        let imgObj:ImageObject = callback(index: self.indexPath)
        let sourceSize = imgObj.getSize()
        let originalSize = self.originalSize
        let targetSize = CGSizeMake(targetSizeWidth, targetSizeWidth/originalSize.width*originalSize.height)
        //let targetSize = CGSizeMake(originalSize.width*4, originalSize.height*4)
        //let metaData = imgObj.getMetaData()
        imgObj.getImageWithSize(targetSize, callback: { (image) -> Void in
        //imgObj.getImageDataOriginal { (imgData, orientaion) -> Void in
            //let image = UIImage(data: imgData)
            //let scale = sourceSize.width / targetSize.width
            //let image = UIImage(data: imgData, scale: scale)
            //let size = image?.size
            self.setImageData(image)
            let orientation = imgObj.getOrientation()
            self.scene.addChild(self.sprite)
            self.moveWithAction(position, targetSize: targetSize, orientation: orientation, duration: duration)
        })
    }
    func moveWithAnimation() {
        if self.sprite != nil {
            let moveAction:SKAction = SKAction.moveTo(self.nodePosition, duration: 0.1)
            let rotateAction:SKAction = SKAction.rotateToAngle(0, duration: 0.2)
            let actionArray = [moveAction,rotateAction]
            let action = SKAction.group(actionArray)
            self.sprite.runAction(action)
        }
    }
    func moveWithAction() {
        if self.sprite != nil {
            let moveAction:SKAction = SKAction.moveTo(self.nodePosition, duration: 1.0)
            let prevSize:CGSize = self.sprite.size
            let newSize:CGSize = self.targetSize
            let scale:CGFloat = self.targetSize.width/self.sprite.size.width
            println("prevSize=\(prevSize)")
            println("newSize=\(newSize)")
            println("scale=\(scale)")
            let scaleAction:SKAction = SKAction.scaleBy(scale, duration: 0.5)
            let resizeActione:SKAction = SKAction.resizeToWidth(self.targetSize.width, height: self.targetSize.height, duration: 1.0)
            //let scaleXAction:SKAction = SKAction.scaleXTo(scale, duration: 0.2)
            //let scaleYAction:SKAction = SKAction.scaleYTo(scale, duration: 0.2)
            //let actionArray = [moveAction, scaleXAction,scaleYAction]
            //let actionArray = [moveAction, scaleAction]
            let actionArray = [moveAction,resizeActione]
            let action = SKAction.group(actionArray)
            //let action = SKAction.sequence(actionArray)
            self.sprite.runAction(action)
            //self.sprite.position = self.nodePosition
            //self.sprite.size = newSize
        }
    }
    
    func moveWithAction( position:CGPoint, targetSize:CGSize, orientation:Int, duration:NSTimeInterval ) {
        if self.sprite != nil {
            
            if targetSize.width < targetSize.height {
                var newPosition:CGPoint = CGPointZero
                self.sprite.anchorPoint = CGPoint(x: 0, y: 0)
                var angle:CGFloat = 0
                if orientation == 2 {
                    angle = CGFloat(M_PI*90/180)
                    newPosition = CGPointMake(position.x, position.y+targetSize.height)
                }else if orientation == 3 {
                    angle = CGFloat(M_PI*270/180)
                    newPosition = CGPointMake(position.x+targetSize.width, position.y)
                }
                let rotateAction = SKAction.rotateByAngle( angle, duration: 0)
                let scaleX = targetSize.height/targetSize.width
                let scaleXAction = SKAction.scaleXTo(scaleX, duration: duration)
                let scaleY = targetSize.width/targetSize.height
                let scaleYAction = SKAction.scaleYTo(scaleY, duration: duration)
                let moveAction:SKAction = SKAction.moveTo(self.scene.convertPointFromView(newPosition), duration: duration)
                let array = [rotateAction,scaleXAction,scaleYAction,moveAction]
                let action = SKAction.group(array)
                self.sprite.runAction(action)
                self.sprite.anchorPoint = CGPoint(x: 0, y: 1)
                
            }else{
                let moveAction:SKAction = SKAction.moveTo(self.scene.convertPointFromView(position), duration: duration)
                let resizeActione:SKAction = SKAction.resizeToWidth(targetSize.width, height: targetSize.height, duration: duration)
                let actionArray = [moveAction,resizeActione]
                let action = SKAction.group(actionArray)
                self.sprite.runAction(action)
            }
        }
    }
    func removeSpriteWithAnimation( duration:NSTimeInterval ) {
        if self.sprite != nil {
            let moveAction:SKAction = SKAction.moveTo(self.nodePosition, duration: duration)
            let prevSize:CGSize = self.sprite.size
            let newSize:CGSize = self.targetSize
            let scale:CGFloat = self.targetSize.width/self.sprite.size.width
            println("prevSize=\(prevSize)")
            println("newSize=\(newSize)")
            println("scale=\(scale)")
            let scaleAction:SKAction = SKAction.scaleBy(scale, duration: duration)
            let resizeActione:SKAction = SKAction.resizeToWidth(self.targetSize.width, height: self.targetSize.height, duration: duration)
            //let scaleXAction:SKAction = SKAction.scaleXTo(scale, duration: 0.2)
            //let scaleYAction:SKAction = SKAction.scaleYTo(scale, duration: 0.2)
            //let actionArray = [moveAction, scaleXAction,scaleYAction]
            //let actionArray = [moveAction, scaleAction]
            let actionArray = [moveAction,resizeActione]
            let action = SKAction.group(actionArray)
            //let action = SKAction.sequence(actionArray)
            //self.sprite.runAction(action)
            self.sprite.runAction(action, completion: { () -> Void in
                self.scene.removeImageSprite(self)
            })
            //self.sprite.position = self.nodePosition
            //self.sprite.size = newSize
        }
    }
}