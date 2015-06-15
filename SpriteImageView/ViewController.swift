//
//  ViewController.swift
//  SpriteImageView
//
//  Created by Aizawa Takashi on 2015/06/05.
//  Copyright (c) 2015年 Aizawa Takashi. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController,SpriteViewDelegate {

    private var scene: MyScene!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var spriteView: SKView!
    @IBAction func pushTheButton(sender: AnyObject) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        spriteView.showsFPS = true
        spriteView.showsNodeCount = true
        spriteView.setTranslatesAutoresizingMaskIntoConstraints(true)
        spriteView.frame = CGRectMake(0, label.frame.height+label.frame.origin.y, self.view.frame.width, self.view.frame.height - label.frame.origin.y - label.frame.height - button.frame.height)
       

    }
    override func viewWillAppear(animated: Bool) {
        scene = MyScene(size:CGSizeMake(spriteView.frame.width, spriteView.frame.height))
        scene.scaleMode = .AspectFill
        scene.spriteViewDelegate = self
        scene.intervalSpace = 1.0
        scene.aroundSpace = 2.0
        
        
        let imageManager:ImageManager = AssetManager.sharedInstance
        imageManager.setupData()
        spriteView.presentScene(scene)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numOfSections() -> Int {
        let imageManager = AssetManager.sharedInstance
        let numSection = imageManager.sectionCount
        return numSection
    }
    func numOfItemsInSection(section: Int) -> Int {
        let imageManager = AssetManager.sharedInstance
        let numOfItem = imageManager.getImageCount(section)
        return numOfItem
    }
    func itemImageAtIndex(index: NSIndexPath) -> ImageObject {
        let imageManager = AssetManager.sharedInstance
        let item = imageManager.getImageObjectIndexAt(index)
        return item!
    }
    func sectionStrings() -> [String] {
        let imageManager = AssetManager.sharedInstance
        let sections = imageManager.getSectionArray()
        return sections
    }
    func showSingleImage() {
        let closeButton = UIButton(frame: CGRectMake(self.spriteView.frame.width-40, 10, 32, 32))
        closeButton.setImage(UIImage(named: "close1.png"), forState: UIControlState.Normal)
        closeButton.addTarget(self, action: "pushSingleViewCloseButton", forControlEvents: UIControlEvents.TouchDown)
        self.spriteView.addSubview(closeButton)
    }

    func pushSingleViewCloseButton() {
        self.scene.closeSingleView()
    }

}

