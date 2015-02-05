//
//  GameScene.swift
//  SpaceCanon
//
//  Created by yosemite on 04/02/15.
//  Copyright (c) 2015 yosemite. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
     var _cannon: SKSpriteNode!
     var _mainLayer : SKNode!
    
    override func didMoveToView(view: SKView) {
        
             /* Setup your scene here */
        //fondo
        let background = SKSpriteNode(imageNamed: "starfield.jpg")
        background.anchorPoint = CGPointZero
        background.position = CGPointZero
        background.blendMode = SKBlendMode.Replace
        self.addChild(background)
        
        //main layer
        _mainLayer = SKNode()
        self.addChild(_mainLayer)
        
        //add cannon
        _cannon = SKSpriteNode(imageNamed: "canonblack")
        _cannon.position=CGPointMake(self.size.width * 0.5, 0.0)
        _mainLayer.addChild(_cannon)
        
        //action rotation cannon
        let rotationAction = SKAction.sequence([SKAction.rotateByAngle(CGFloat(M_PI), duration: 2),
            SKAction.rotateByAngle(CGFloat(-M_PI), duration: 2)
            ]
            )
        
        _cannon.runAction(SKAction.repeatActionForever(rotationAction))
        
        
        
       
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            
            
            
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    
    
}
