//
//  User.swift
//  App
//
//  Created by MUSTAFA DOĞUŞ on 11.12.2019.
//

import Foundation
import Vapor
import FluentPostgreSQL

final class User: Content {
    var id: Int?
    var name: String
    var surname: String
    var gender: String
    var school: String
    var grade: String
    var userName: String
    var password: String
    
    init(name: String, surname: String, gender: String, school: String, grade: String, userName: String, password: String) {
        self.name = name
        self.surname = surname
        self.gender = gender
        self.school = school
        self.grade = grade
        self.userName = userName
        self.password = password
    }
}

extension User: PostgreSQLModel {
    static let entity: String = "Users"
}

extension User: Migration {
    
}

extension User: Parameter {
    
}
