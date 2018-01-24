//  Created by Johnykutty Mathew on 13/01/18.
//

import Vapor
import HTTP
import Leaf

final class BuildController: ResourceRepresentable {
    
    private var droplet: Droplet!
    
    init() {
        
    }
    
    convenience init(_ drop: Droplet) throws {
        self.init()
        droplet = drop
        try addRoutes()
    }
    
    func addRoutes() throws {
        let path = "build"
        let buildPath = droplet.grouped(path)
        buildPath.get(Build.parameter, "manifest.plist", handler: getManifest)
        try droplet.resource(path, BuildController.self)
    }
    
    func index(_ req: Request) throws -> ResponseRepresentable {
        return try  APIResponse(data: Build.all().makeJSON().wrapped)
    }
    
    func add(_ req: Request) throws -> ResponseRepresentable {
        let build = try req.build()
        try build.save()
        return try APIResponse(data: build.makeJSON().wrapped)
    }
    
    func delete(_ req: Request, build: Build) throws -> ResponseRepresentable {
        try build.delete()
        return APIResponse(data: .null)
    }
    
    func getManifest(_ req: Request) throws -> ResponseRepresentable {
        let build = try req.parameters.next(Build.self)
        return try droplet.view.make("manifest", build.makeJSON())
    }
    
    func makeResource() -> Resource<Build> {
        return Resource(
            index: index,
            store: add,
            destroy: delete)
    
    }
}

extension Request {
    /// Create a build from the JSON body
    /// return BadRequest error if invalid
    /// or no JSON
    func build() throws -> Build {
        guard let json = json else { throw Abort.badRequest }
        return try Build(json: json)
        
    }
}

extension BuildController: EmptyInitializable { }
