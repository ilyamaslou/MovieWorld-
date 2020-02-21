//
//  MWNavigationBar.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 2/21/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWNavigationBar: UINavigationBar {
    
    private var _title: String?
    var title: String? {
        get {
            return _title
        }
        set {
            _title = newValue
//            UINavigationBar.appearance(). = newValue
        }
    }
    
}
