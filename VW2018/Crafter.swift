//
//  Crafter.swift
//  VW2018
//
//  Created by Alumno on 26/04/18.
//  Copyright © 2018 Gekko. All rights reserved.
//

import Foundation

struct Crafter: Codable{
    var id = Int()
    var model = String()
    var plates = String()
    var year = Int()
    var start = String()
    var capacity = Int()
    var passengers = Int()
    var batteries = [Battery]()
    var fuel_reffils = [Fuel_reffils]()
}

struct Battery: Codable{
    var brand = String()
    var date = String()
    var model = String()
}

struct Fuel_reffils: Codable{
    var type = String()
    var date = String()
}
