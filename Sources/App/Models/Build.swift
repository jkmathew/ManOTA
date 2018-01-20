//
//  Build.swift
//  ManOTAPackageDescription
//
//  Created by Johnykutty Mathew on 13/01/18.
//

import Foundation

import Vapor
import FluentProvider
import HTTP

final class Build: Model {
    let storage = Storage()
    
    var buildUrl: String
    var displayImage: String
    var fullSizeImage: String
    var bundleIdentifier: String
    var bundleVersion: String
    var buildNumber: String
    var title: String
    
    struct Keys {
        static let id = "id"
        static let buildUrl = "build_url"
        static let displayImage = "display_image"
        static let fullSizeImage = "full_size_image"
        static let bundleIdentifier = "bundle_identifier"
        static let bundleVersion = "bundle_version"
        static let buildNumber = "build_number"
        static let title = "title"
        
    }
    
    init(buildUrl: String,
         displayImage: String,
         fullSizeImage: String,
         bundleIdentifier: String,
         bundleVersion: String,
         buildNumber: String,
         title: String) {
        self.buildUrl = buildUrl
        self.displayImage = displayImage
        self.fullSizeImage = fullSizeImage
        self.bundleIdentifier = bundleIdentifier
        self.bundleVersion = bundleVersion
        self.buildNumber = buildNumber
        self.title = title
    }
    
    init(row: Row) throws {
        buildUrl = try row.get(Build.Keys.buildUrl)
        displayImage = try row.get(Build.Keys.displayImage)
        fullSizeImage = try row.get(Build.Keys.fullSizeImage)
        bundleIdentifier = try row.get(Build.Keys.bundleIdentifier)
        bundleVersion = try row.get(Build.Keys.bundleVersion)
        buildNumber = try row.get(Build.Keys.buildNumber)
        title = try row.get(Build.Keys.title)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Build.Keys.buildUrl, buildUrl)
        try row.set(Build.Keys.displayImage, displayImage)
        try row.set(Build.Keys.fullSizeImage, fullSizeImage)
        try row.set(Build.Keys.bundleIdentifier, bundleIdentifier)
        try row.set(Build.Keys.bundleVersion, bundleVersion)
        try row.set(Build.Keys.buildNumber, buildNumber)
        try row.set(Build.Keys.title, title)
        return row
    }
}

extension Build: ResponseRepresentable { }

extension Build: JSONConvertible {
    convenience init(json: JSON) throws {
        self.init(
            buildUrl: try json.get(Build.Keys.buildUrl),
            displayImage: try json.get(Build.Keys.displayImage),
            fullSizeImage: try json.get(Build.Keys.fullSizeImage),
            bundleIdentifier: try json.get(Build.Keys.bundleIdentifier),
            bundleVersion: try json.get(Build.Keys.bundleVersion),
            buildNumber: try json.get(Build.Keys.buildNumber),
            title: try json.get(Build.Keys.title)
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Build.Keys.id, id)
        try json.set(Build.Keys.buildUrl, buildUrl)
        try json.set(Build.Keys.displayImage, displayImage)
        try json.set(Build.Keys.fullSizeImage, fullSizeImage)
        try json.set(Build.Keys.bundleIdentifier, bundleIdentifier)
        try json.set(Build.Keys.bundleVersion, bundleVersion)
        try json.set(Build.Keys.buildNumber, buildNumber)
        try json.set(Build.Keys.title, title)
        return json
    }
}

extension Build: Preparation {
    /// Prepares a table/collection in the database
    /// for storing Posts
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Build.Keys.buildUrl)
            builder.string(Build.Keys.displayImage)
            builder.string(Build.Keys.fullSizeImage)
            builder.string(Build.Keys.bundleIdentifier)
            builder.string(Build.Keys.bundleVersion)
            builder.string(Build.Keys.buildNumber)
            builder.string(Build.Keys.title)
            
        }
    }
    
    /// Undoes what was done in `prepare`
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

/*
 
 <plist version="1.0">
 <dict>
 <key>items</key>
 <array>
 <dict>
 <key>assets</key>
 <array>
 <dict>
 <key>kind</key>
 <string>software-package</string>
 <key>url</key>
 <string>http://192.168.43.181:8080/NPG.ipa</string>
 </dict>
 <dict>
 <key>kind</key>
 <string>display-image</string>
 <key>url</key>
 <string>http://192.168.43.181:8080/iTunesArtwork.png</string>
 </dict>
 <dict>
 <key>kind</key>
 <string>full-size-image</string>
 <key>url</key>
 <string>http://192.168.43.181:8080/iTunesArtwork.png</string>
 </dict>
 </array>
 <key>metadata</key>
 <dict>
 <key>bundle-identifier</key>
 <string>com.yeava.npg</string>
 <key>bundle-version</key>
 <string>1.7</string>
 <key>kind</key>
 <string>software</string>
 <key>title</key>
 <string>NPG Agency</string>
 </dict>
 </dict>
 </array>
 </dict>
 </plist>
 */
