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
        spriteView.presentScene(scene)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numOfSections() -> Int {
        return 1
    }
    func numOfItemsInSection(section: Int) -> Int {
        return 1
    }
    func itemImageAtIndex(index: NSIndexPath) -> ImageObject {
        <#code#>
    }
    func sectionStrings() -> [String] {
        <#code#>
    }


}

