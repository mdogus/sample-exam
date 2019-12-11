import FluentSQLite
import Vapor
import FluentPostgreSQL
import Leaf

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    ///Register providers first
    
    //Leaf provider
    try services.register(LeafProvider())
    //PostgreSQL provider
    try services.register(FluentPostgreSQLProvider())

    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    /// Configure a SQLite database
    //let sqlite = try SQLiteDatabase(storage: .memory)

    // Register the configured SQLite database to the database config.
    var databases = DatabasesConfig()
    
    let databaseConfig = PostgreSQLDatabaseConfig(hostname: "localhost", username: "postgres", database: "sampleexam")
    let database = PostgreSQLDatabase(config: databaseConfig)
    
    databases.add(database: database, as: .psql)
    services.register(databases)

    // Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: Question.self, database: .psql)
    migrations.add(model: User.self, database: .psql)
    //migrations.add(model: Todo.self, database: .sqlite)
    services.register(migrations)
    
    config.prefer(LeafRenderer.self, for: ViewRenderer.self)
}
