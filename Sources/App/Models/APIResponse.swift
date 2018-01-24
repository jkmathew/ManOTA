//
//  Response.swift
//  App
//
//  Created by Johnykutty Mathew on 21/01/18.
//

import HTTP
import PostgreSQL

class APIResponse: ResponseRepresentable {
    private let status: Status
    private let json: JSON
    
    init(error: Error) {
        
        let data = error.extract()
        status = data.status
        json = JSON(["success": false, "error": data.json])
    }
    
    init(data: StructuredData) {
        status = .ok
        json = JSON(["success": .bool(true), "data": data])
    }
    
    func makeResponse() throws -> Response {
        let headers = [HeaderKey("Content-Type"): "application/json"]
        return Response(status: status, headers: headers, body: json)
    }
}


extension Error {
    
    func extract() -> (json: JSON, status: Status) {
        var errorJson = JSON(["reason": "unknown"])
        var status: Status
        if let abort = self as? AbortError {
            status = abort.status
            try? errorJson.set("reason", abort.reason)
        } else if let sqlError = self as? PostgreSQLError {
            status = .internalServerError
            try? errorJson.set("reason", sqlError.reason)
            try? errorJson.set("code", "\(sqlError.code)")
        } else {
            status = .internalServerError
            try? errorJson.set("reason", status.reasonPhrase)
        }
        try? errorJson.set("statusCode", status.statusCode)
        try? errorJson.set("reasonPhrase", status.reasonPhrase)

        return (json: errorJson, status: status)
    }
}
