//
//  SKImageSpriteNode.swift
//  SpriteImageView
//
//  Created by Aizawa Takashi on 2015/06/09.
//  Copyright (c) 2015年 Aizawa Takashi. All rights reserved.
//

import UIKit
import SpriteKit

class SKImageSpriteNode: SKSpriteNode {
    var imageSprite:ImageSprite!
    override init(texture: SKTexture!, color: UIColor!, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    init(texture: SKTexture!, color: UIColor!, size: CGSize, imageSprite:ImageSprite) {
        super.init(texture: texture, color: color, size: size)
        self.imageSprite = imageSprite
    }
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
}
