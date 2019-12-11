//
//  Question.swift
//  App
//
//  Created by MUSTAFA DOĞUŞ on 4.12.2019.
//

import Foundation
import Vapor
import FluentPostgreSQL

final class Question: Content {
    var id: Int?
    var titleOfTest: String
    var titleOfQuestion: String
    var questionStem: String
    var choiceA: String
    var choiceB: String
    var choiceC: String
    var choiceD: String
    var choiceE: String
    var noteTaken: String
    var isAnswered: Bool
    var isBookmarkAdded: Bool
    var audioOfQuestion: String
    var audioOfChoices: String
    
    init(titleOfTest: String, titleOfQuestion: String, questionStem: String, choiceA: String, choiceB: String, choiceC: String, choiceD: String, choiceE: String, noteTaken: String, isAnswered: Bool, isBookmarkAdded: Bool, audioOfQuestion: String, audioOfChoices: String) {
        self.titleOfTest = titleOfTest
        self.titleOfQuestion = titleOfQuestion
        self.questionStem = questionStem
        self.choiceA = choiceA
        self.choiceB = choiceB
        self.choiceC = choiceC
        self.choiceD = choiceD
        self.choiceE = choiceE
        self.noteTaken = noteTaken
        self.isAnswered = isAnswered
        self.isBookmarkAdded = isBookmarkAdded
        self.audioOfQuestion = audioOfQuestion
        self.audioOfChoices = audioOfChoices
    }
}

extension Question: PostgreSQLModel {
    static let entity: String = "Questions"
}

extension Question: Migration {
    
}

extension Question: Parameter {
    
}
