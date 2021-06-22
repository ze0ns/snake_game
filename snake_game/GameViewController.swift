//
//  GameViewController.swift
//  snake_game
//
//  Created by zeons on 20.06.2021.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Создаем нашу сцену, которая является объектом класса GameScene
        let scene = GameScene(size: view.bounds.size)
        
        //наша вьюшка где будет отображаться информация
        //С проверкой , что вью создалась класса SKView
        
        let skView = view as! SKView
        
        //Делаем отображение FPS
        //Отображение количества объектов на экране
        //Произвольный рендеринг объектов, игнорируя порядок загрузки объектов
        //Растягиваем на весь экран
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        
        //Вызываем метод , покажи нам сцену
        skView.presentScene(scene)

    }

}
