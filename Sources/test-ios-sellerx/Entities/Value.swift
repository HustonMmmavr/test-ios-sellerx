import Foundation

class Value: Codable {
    var id: Int
    var title: String
    var params: [Param]?
    
    init(id: Int, title: String, params: [Param]) {
        self.id = id;
        self.title = title;
        self.params = params;
    }
    
    func HasParams() -> Bool {
        if let pars = params {
            return pars.count > 0
        }
        return false
    }
}
