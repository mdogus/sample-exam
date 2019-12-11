import Vapor

struct DisplayAllQuestionsContext: Encodable {
    var allQuestions: [Question]
}
struct IndexContext: Encodable {
    var questions: [Question]?
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
