import Foundation

struct Car: Identifiable, Decodable, Hashable {
    let id = UUID()
    let name: String
}


enum CodingKeys: String, CodingKey {
    case name = "Name"
}
