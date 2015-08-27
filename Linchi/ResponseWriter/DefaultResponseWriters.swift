//
//  DefaultResponseWriters.swift
//  Linchi
//

/// Empty class defining the default ResponseWriters for the common error codes.
public class DefaultResponseWriters {
    
    var notFound            : ResponseWriter = { req in HTTPResponse(.NotFound) }
    var forbidden           : ResponseWriter = { req in HTTPResponse(.Forbidden) }
    var badRequest          : ResponseWriter = { req in HTTPResponse(.BadRequest) }
    var unauthorized        : ResponseWriter = { req in HTTPResponse(.Unauthorized) }
    var internalServerError : ResponseWriter = { req in HTTPResponse(.InternalServerError) }

}
