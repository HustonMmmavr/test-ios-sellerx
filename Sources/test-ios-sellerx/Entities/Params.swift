import Foundation

// Classes, that represents data from Structure.json
class Params: Codable {
    var params: [Param]
    
    init (params: [Param]) {
        self.params = params;
    }
}

class Param: Codable {
    var id: Int
    var title: String
    var value: String
    var values: [Value]?
    
    init(id: Int, title: String, value: String, values: [Value]) {
        self.id = id;
        self.title = title;
        self.value = value;
        self.values = values;
    }
    
    func HasValues() -> Bool {
        if let vals = values {
            return vals.count > 0
        }
        return false
    }
}
