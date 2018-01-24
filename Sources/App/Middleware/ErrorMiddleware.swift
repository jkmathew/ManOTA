//
//  ErrorMiddleware.swift
//  ManOTAPackageDescription
//
//  Created by Johnykutty Mathew on 20/01/18.
//

import Foundation

import Vapor
import HTTP

/// Catches errors and converts them into responses
/// with a description of the error.
public final class ErrorMiddleware: Middleware {
    let log: LogProtocol
    let view: ViewRenderer
    init(log: LogProtocol, view: ViewRenderer) {
        self.log = log
        self.view = view
    }
    
    public func respond(to req: Request, chainingTo next: Responder) throws -> Response {
        do {
            return try next.respond(to: req)
        } catch {
            log.error(error)
            return try make(with: req, for: error)
        }
    }
    
    public func make(with req: Request, for error: Error) throws -> Response {
        guard req.accept.prefers("html") else {

            return try APIResponse(error: error).makeResponse()
        }
        let errorJson = error.extract().json
        return try view.make("error", errorJson).makeResponse()
    }
}

extension ErrorMiddleware: ConfigInitializable {
    public convenience init(config: Config) throws {
        let log = try config.resolveLog()
        let view = try config.resolveView()
        self.init(log: log, view: view)
    }
}
