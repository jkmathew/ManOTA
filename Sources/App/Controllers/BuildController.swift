//  Created by Johnykutty Mathew on 13/01/18.
//

import Vapor
import HTTP

final class BuildController: ResourceRepresentable {
    func save(_ req: Request) throws -> ResponseRepresentable {
        let build = try req.build()
        try build.save()
        return build
    }
    
    func getManifest(_ req: Request) throws -> ResponseRepresentable {
        let build = try req.parameters.next(Build.self)
        return build
    }
    
    func makeResource() -> Resource<Build> {
        return Resource(store: save)
    
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
