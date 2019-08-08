import Foundation

// Classes that represents data from DraftValues.json
class DraftValues: Decodable {
    var values: [DraftValue]
    
    init(values: [DraftValue]) {
        self.values = values;
    }
}

// Enum that stores value (which can be int or string) from DraftValue
enum DraftValueData: Decodable {
    case int(Int)
    case string(String)
    
    init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer()
        
        if let v = try? value.decode(Int.self) {
            self = .int(v)
            return
        } else if let v = try? value.decode(String.self) {
            self = .string(v)
            return
        }
        
        throw DraftValueData.ParseError.notRecognizedType(value)
    }
    
    func GetInt() -> Int? {
        if case let .int(val) = self {
            return val
        }
        return nil
    }
    
    func GetString() -> String? {
        if case let .string(val) = self {
            return val
        }
        return nil
    }
    
    enum ParseError: Error {
        case notRecognizedType(Any)
    }
}

class DraftValue: Decodable {
    var id: Int
    var value: DraftValueData
    
    init(id: Int, value: DraftValueData) {
        self.id = id;
        self.value = value
    }
    
    func GetIdFromValue() -> Int? {
        return value.GetInt()
    }
    
    func GetValue() -> String? {
        return value.GetString()
    }
}
