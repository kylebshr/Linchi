//
//  Page.swift
//  Linchi
//

// Component of the server describing what request it accepts and how it should respond to it
// When URLRouter is implemented, Page will be unnecessary
// TODO: Find a better name and document it
internal struct Page {
    let method : HTTPMethod
    let url : URLPattern
    let responseWriter : ResponseWriter
}
