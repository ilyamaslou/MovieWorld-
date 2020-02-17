//
//  MWInterface.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 2/17/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import Foundation
import UIKit

typealias MWI = MWInterface

class MWInterface {
    
    public static let s = MWInterface()
    
    private(set) weak var window: UIWindow?
    
    public let navController = MWNavigationController()
    
    private init() {}
    
    public func setup(window: UIWindow) {
        self.window = window
        
        navController.viewControllers = [MWFirstTabViewController()]
        
        window.rootViewController = navController
        window.makeKeyAndVisible()
    }
}
