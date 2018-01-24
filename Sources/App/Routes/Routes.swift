import Vapor

extension Droplet {
    func setupRoutes() throws {       
        _ = try BuildController(self)
    }
}
