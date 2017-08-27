//
//  DataTypeExtensions.swift
//  DropMusic
//
//  Created by Angel Contreras on 10/16/16.
//  Copyright © 2016 Angel Contreras. All rights reserved.
//

import Foundation

extension Double {
    var cleanValue: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
