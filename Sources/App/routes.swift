import Vapor
import Leaf
import FluentPostgreSQL

struct DisplayAllQuestionsContext: Encodable {
    var allQuestions: [Question]
}
struct IndexContext: Encodable {
    var questions: [Question]?
}
struct IndexContextForUser: Encodable {
    var users: [User]?
}
struct DeleteRequestForUser: Content {
    var userId: Int
}
struct DeleteRequestForTurkishQuestion: Content {
    var questionId: Int
}

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    //Home page
    router.get("/") { request -> Future<View> in
        return try request.view().render("home-page")
    }
    //Login: User
    router.get("login/user") { request -> Future<View> in
        return try request.view().render("home-login-user")
    }
    //Login: New user
    router.get("login/new-user") { request -> Future<View> in
        return try request.view().render("home-new-user")
    }
    router.post(User.self, at: "/login/new-user") { request, user -> Future<Response> in
        return user.save(on: request)
            .transform(to: request.redirect(to: "/login/user"))
    }
    
    //Admin page
    router.get("admin") { request -> Future<View> in
        return try request.view().render("admin")
    }
    //Admin: Adding new question
    router.get("admin/add-question") { request -> Future<View> in
        return try request.view().render("admin-add-question")
    }
    router.post(Question.self, at: "/admin/add-question") { request, question -> Future<Response> in
        return question.save(on: request)
            .transform(to: request.redirect(to: "/admin"))
    }
    
    //Admin: New user
    router.get("admin/new-user") { request -> Future<View> in
        return try request.view().render("admin-new-user")
    }
    router.post(User.self, at: "/admin/new-user") { request, user -> Future<Response> in
        return user.save(on: request)
            .transform(to: request.redirect(to: "/admin/all-users"))
    }
    //Users: All users
    router.get("/admin/all-users") { request -> Future<View> in
        return User.query(on: request).all()
            .flatMap(to: View.self) { allUsers in
                let userData = allUsers.isEmpty ? nil : allUsers
                let context = IndexContextForUser(users: userData)
                return try request.view().render("admin-users-all", context)
        }
    }
    //Deleting a user
    router.post(DeleteRequestForUser.self, at: "/delete-user") { request, deleteRequest -> Future<Response> in
        return User.query(on: request).filter(\.id == deleteRequest.userId)
            .first().unwrap(or: Abort(.badRequest)).delete(on: request)
            .transform(to: request.redirect(to: "/admin/all-users"))
    }
    
    //Admin-Tests: Turkish
    let tests = router.grouped("admin/tests")
    tests.get("/turkish") { request -> Future<View> in
        return Question.query(on: request).all()
            .flatMap(to: View.self) { turkishQuestions in
                let questionData = turkishQuestions.isEmpty ? nil : turkishQuestions
                let context = IndexContext(questions: questionData)
                return try request.view().render("admin-test-turkish", context)
        }
    }
    //Admin: Deleting a question from Turkish test
    router.post(DeleteRequestForTurkishQuestion.self, at: "/delete-turkish-question") { request, deleteRequest -> Future<Response> in
        return Question.query(on: request).filter(\.id == deleteRequest.questionId)
            .first().unwrap(or: Abort(.badRequest)).delete(on: request)
            .transform(to: request.redirect(to: "/admin/tests/turkish"))
    }
    
    //Test interface: "sinav"
    router.get("sinav") { request in
        return try request.view().render("test-interface")
    }
    
    let question1 = Question(titleOfTest: "Türkçe Sınavı", titleOfQuestion: "Soru 1", questionStem: "Soru 1'in soru kökü", choiceA: "A seçeneği", choiceB: "B seçeneği", choiceC: "C seçeneği", choiceD: "D seçeneği", choiceE: "E seçeneği", noteTaken: "", isAnswered: false, isBookmarkAdded: false, audioOfQuestion: "soru.mp3", audioOfChoices: "secenekler.mp3")
    let question2 = Question(titleOfTest: "Türkçe Sınavı", titleOfQuestion: "Soru 2", questionStem: "Soru 2'nin soru kökü", choiceA: "A seçeneği", choiceB: "B seçeneği", choiceC: "C seçeneği", choiceD: "D seçeneği", choiceE: "E seçeneği", noteTaken: "", isAnswered: false, isBookmarkAdded: false, audioOfQuestion: "soru.mp3", audioOfChoices: "secenekler.mp3")
    
    var allQuestions = [question1, question2]
    let context = DisplayAllQuestionsContext(allQuestions: allQuestions)
    
    router.get("sinav/turkce") { request -> Future<View> in
        return try request.view().render("test-interface", question1)
    }
    
    router.get("all") { request -> Future<View> in
        return try request.view().render("display-all", context)
    }
    
    //CRUD operations
    /*
    router.post(Question.self, at: "/questions") { request, question -> Future<Question> in
        return question.save(on: request)
    }
    
    router.get("/questions") { request -> Future<[Question]> in
        return Question.query(on: request).all()
    }
    
    router.get("/questions", Question.parameter) { request -> Future<Question> in
        return try request.parameters.next(Question.self)
    }
    
    router.delete("/questions", Question.parameter) { request -> Future<Question> in
        return try request.parameters.next(Question.self).delete(on: request)
    }
    
    router.put(Question.self, at: "/questions") { request, question -> Future<Question> in
        return question.update(on: request)
    }
    ===============
    
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }
    
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }

    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)
    */
}
