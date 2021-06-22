//
//  SnakeHead.swift
//  snake_game
//
//  Created by zeons on 21.06.2021.
//

import UIKit

class SnakeHead: SnakeBodyPart {
    override init (atPoint point:CGPoint){
        super.init(atPoint: point)
        
        //Определяем категорию к которой отнорсится наша голова и с кем она может столкнуться
        self.physicsBody?.categoryBitMask = CollisionCategories.SnakeHead
        self.physicsBody?.contactTestBitMask = CollisionCategories.EdgeBody | CollisionCategories.Apple | CollisionCategories.Snake
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
