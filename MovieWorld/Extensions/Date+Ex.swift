//
//  Date+Ex.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 4/5/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

extension Date {
    var toAge: Int {
        return Calendar.current.dateComponents([.year], from: self, to: Date()).year ?? 0
    }
}
