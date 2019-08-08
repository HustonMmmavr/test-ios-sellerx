import Foundation

// Class that defines error data
class ErrorJson: Encodable {
    var error: Message
    
    class Message: Encodable {
        var message: String
        
        init(message: String) {
            self.message = message
        }
    }
    
    init(message: String) {
        error = Message(message: message)
    }
}
