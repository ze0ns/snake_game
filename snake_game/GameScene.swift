//
//  GameScene.swift
//  snake_game
//
//  Created by zeons on 20.06.2021.
//

import SpriteKit
import GameplayKit

// Категории нужны нам для разбиение всех объектов на группы. МОжно указывать какие категории могут взаимодействовать и какие нет
//Создадим категории наших объектов и зададим их значение в битовом формате
struct CollisionCategories {
    static let Snake: UInt32 = 0x1 << 0 //Число 0001
    static let SnakeHead: UInt32 = 0x1 << 1 //Число 0010
    static let Apple: UInt32 = 0x1 << 2 //Число 0100
    static let EdgeBody: UInt32 = 0x1 << 3 //Число 1000
}

class GameScene: SKScene {
    //помещаем змейку, и вызываем её только когда надо 
    var snake: Snake?

    //Метод вызывается в момент запуска сцены. Преднанзанчен для создания первоначального состояния  для добовления необходимых объектов на старте
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black //Устанавливаем фон
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0) //Добавляем гравитацию
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame) //Добавляем физику в игру, указывая где она будет работать
        self.physicsBody?.allowsRotation = false //отключаем поворот экрана
        view.showsPhysics = true
        
        //Создаем нашу первую кнопку
        let counterClockWiseButton = SKShapeNode()
        //Задали кнопке форму и размеры
        counterClockWiseButton.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 45, height: 45)).cgPath
        //Разместим нашу кнопку, в левом нижнем углу (30 поинтов от края)
        counterClockWiseButton.position = CGPoint(x: view.scene!.frame.minX+30, y: view.scene!.frame.minY+30)
        //Заполним цветом и сделаем рамку, Зададим толщину линии рамки и обзовем её
        counterClockWiseButton.fillColor = UIColor.gray
        counterClockWiseButton.strokeColor = UIColor.gray
        counterClockWiseButton.lineWidth = 10
        counterClockWiseButton.name = "counterClockWiseButton"
        
        //Создаем нашу вторую кнопку
        let ClockWiseButton = SKShapeNode()
        //Задали кнопке форму и размеры
        ClockWiseButton.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 45, height: 45)).cgPath
        //Разместим нашу кнопку, в левом нижнем углу (30 поинтов от края)
        ClockWiseButton.position = CGPoint(x: view.scene!.frame.maxX - 80, y: view.scene!.frame.minY+30)
        //Заполним цветом и сделаем рамку, Зададим толщину линии рамки и обзовем её
        ClockWiseButton.fillColor = UIColor.gray
        ClockWiseButton.strokeColor = UIColor.gray
        ClockWiseButton.lineWidth = 10
        ClockWiseButton.name = "ClockWiseButton"
        
        //Предаем(создаем) наши кнопки на нашу сцену
        self.addChild(counterClockWiseButton)
        self.addChild(ClockWiseButton)
        
        //Вызываем метод создания яблока
        crateApple()
        snake = Snake(atPoint: CGPoint(x: view.scene!.frame.midX, y: view.scene!.frame.midY))
        self.addChild(snake!)
        
        //Указываем что сцена является делегатом столкновения
        self.physicsWorld.contactDelegate = self
        
        self.physicsBody?.categoryBitMask = CollisionCategories.EdgeBody
        
        //Указываем с кем она может сталкиваться (со змеёй и с головой змеи)
        self.physicsBody?.collisionBitMask = CollisionCategories.Snake | CollisionCategories.SnakeHead
        
        
    }
    
    
    //Метод отрабатывает нажатия на экран
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        //Ищем куда было нажатие, и если было нажатие - нашу кнопку красим её в зеленый цвет
        for touch in touches{
            let touchLocation = touch.location(in: self)
            //метод atPoint - отслеживает , где произшло нажание. И объект соответствует классу SKShapeNode
            guard let touchNode = self.atPoint(touchLocation) as? SKShapeNode, touchNode.name == "counterClockWiseButton" || touchNode.name == "ClockWiseButton" else {
                return
            }
            touchNode.fillColor = .green
        }
        
    }
    

    //Метод срабатывает после отпускания пальца от экрана
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let touchLocation = touch.location(in: self)
            
            guard let touchNode = self.atPoint(touchLocation) as? SKShapeNode, touchNode.name == "counterClockWiseButton" || touchNode.name == "ClockWiseButton" else {
                return
            }
            touchNode.fillColor = .gray
            
            // Добавляем вызов методов поворота змейки при нажатии на наши кнопки
            if touchNode.name == "counterClockWiseButton" {
                snake!.moveCounterClockwise()
            } else if touchNode.name == "ClockWiseButton"{
                snake!.moveClockwise()
            }
        }
    
    }
    
    //внезапное прекращения нажатие
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
  
    }
    
    //Обновление сцены
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        snake!.move()
    }
    //Создаем наше яблоко и произвольно помещаем его на сцену
    func crateApple(){
        let randX = CGFloat(arc4random_uniform(UInt32(view!.scene!.frame.maxX - 10)))
        let randY = CGFloat(arc4random_uniform(UInt32(view!.scene!.frame.maxY - 10)))
        
        let apple = Apple(position: CGPoint(x: randX, y: randY))
        self.addChild(apple)
    }
    
}

//Расширим функционал нашей сцены. Добавляем контакт делегате
extension GameScene: SKPhysicsContactDelegate{
    func didBegin(_ contact: SKPhysicsContact) {
        
        let bodyes = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        let collisionObject = bodyes - CollisionCategories.SnakeHead
        
        switch collisionObject {
        case CollisionCategories.Apple:
            //данной проверкой мы узнаели какой из соприкоснувшихся объектов является яблоком
            let apple = contact.bodyA.node is Apple ? contact.bodyA.node : contact.bodyB.node
            
            //Увеличили туловище, удалили яблоко со сцены, рандомно создали яблоко на сцене
            snake?.addBodyPart()
            apple?.removeFromParent()
            crateApple()
        case CollisionCategories.EdgeBody:
            break
            //Домашнее задание
        default:
            break
        }
    }
}

