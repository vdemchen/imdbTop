//
//  SceneDelegate.swift
//  test
//
//  Created by Vladyslav Demchenko on 25.11.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
       
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        let rootVC = UINavigationController(rootViewController: ListViewController())
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
    }
}

