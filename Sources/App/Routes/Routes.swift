import Vapor

extension Droplet {
    func setupRoutes() throws {       
        let buildController = BuildController()
        let buildPath = "build"
        get(buildPath, Build.parameter, "manifest.plist", handler: buildController.getManifest)
        
        try resource(buildPath, BuildController.self)

    }
}
