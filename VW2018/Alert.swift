//
//  Alert.swift
//  VW2018
//
//  Created by Alumno on 26/04/18.
//  Copyright © 2018 Gekko. All rights reserved.
//

import Foundation

struct AlertMessage: Codable{
    var type = String()
    var priority = String()
    var message = String()
    var lat = Double()
    var lng = Double()
}
