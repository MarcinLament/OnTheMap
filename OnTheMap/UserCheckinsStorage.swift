//
//  UserCheckinsStorage.swift
//  OnTheMap
//
//  Created by Marcin Lament on 26/07/2016.
//  Copyright © 2016 Marcin Lament. All rights reserved.
//

import Foundation

class UserCheckinsStorage {
    static let instance = UserCheckinsStorage()
    private init() {}
    
    var userCheckins = [UserCheckin]()
}