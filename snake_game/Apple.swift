//
//  Apple.swift
//  snake_game
//
//  Created by zeons on 21.06.2021.
//

import UIKit
import SpriteKit

class Apple: SKShapeNode{
    
    //Вспомогательный инициализатор который добавляет новый функционал. Он должен вызывать внутри себя инициализатор родителя
    convenience init(position: CGPoint) {
        self.init() //супер инициализатор нашего родительского класса SKShapeNode
        
        //Создаем объект Яблоко, Тоже овал, размещаем его и задаем размеры/цвет
        path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 10, height: 10)).cgPath
        fillColor = UIColor.red
        strokeColor = UIColor.red
        lineWidth = 5
        self.position = position
        
        //Добавим физицеское тело для столкновения
        self.physicsBody = SKPhysicsBody(circleOfRadius: 10.0, center: CGPoint(x: 5, y: 5))
       
        self.physicsBody?.categoryBitMask = CollisionCategories.Apple
        
        
        
    }
    
    
    
    
    
    
    
    
}
