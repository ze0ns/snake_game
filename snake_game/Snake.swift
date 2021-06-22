//
//  Snake.swift
//  snake_game
//
//  Created by zeons on 21.06.2021.
//
import UIKit
import SpriteKit

class Snake: SKShapeNode {
    // Тело нашей змеи будет массивом
    var body = [SnakeBodyPart]()
    let moveSpeed: CGFloat = 125.0
    var angle: CGFloat = 0.0
    
    //Создали голову нашей змейки, добавили её первым объектом в массив и вывели на сцену
    convenience init(atPoint point: CGPoint){
        self.init()
        let head = SnakeHead(atPoint: point)
        body.append(head)
        addChild(head)
    }
    
    
    //Добавляем метод увеличения длены тела змейки, так же добавляем в массив и выводим на экран
    func addBodyPart(){
        let newBodyPart =  SnakeBodyPart(atPoint: CGPoint(x: body[0].position.x, y: body[0].position.y))
        body.append(newBodyPart)
        addChild(newBodyPart)
    }
    
    
    //Создаем метод который ничего не принимает , проверяет не пустое ли наше тело змейки
    func move(){
        guard !body.isEmpty else {return}
        let head =  body[0]
        moveHead(head)
        
        for index in (0..<body.count) where index > 0 {
            let previesBodyPart = body[index - 1]
            let currentBodyPart = body[index]
            moveBodyPart(previesBodyPart, currentBodyPart)
        }
    }
    
    func moveHead(_ head: SnakeBodyPart){
        let dx = moveSpeed * sin(angle)
        let dy = moveSpeed * cos(angle)
        
        let nextPosition = CGPoint(x: head.position.x + dx, y: head.position.y + dy)
        let moveAction = SKAction.move(to: nextPosition, duration: 1.0)
        
        head.run(moveAction)
    }
    
    func moveBodyPart (_ p: SnakeBodyPart, _ c: SnakeBodyPart){
        let moveAction = SKAction.move(to: CGPoint(x: p.position.x, y: p.position.y), duration: 0.1)//мы взяли и сказали , перемести объект в ту точку где был предыдущий объект
        c.run(moveAction)
    }
    
    func moveClockwise(){
        angle += CGFloat(Double.pi / 2)
    }
    
    func moveCounterClockwise(){
        angle -= CGFloat(Double.pi / 2)
    }
}
