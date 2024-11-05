struct Holdings: Codable {
    let data: HoldingsData
}

struct HoldingsData: Codable {
    let holdings: [Holding]
    
    enum CodingKeys: String, CodingKey {
        case holdings = "userHolding"
    }
}

struct Holding: Codable {
    let symbol: String
    let quantity, ltp, avgPrice, close: Double
}
