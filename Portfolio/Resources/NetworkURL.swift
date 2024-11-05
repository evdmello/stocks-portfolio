import Foundation

enum NetworkRequests {
    static var fetchHoldings: URLRequest {
        let url = URL(string: "https://35dee773a9ec441e9f38d5fc249406ce.api.mockbin.io/")!
        return URLRequest(url: url)
    }
}
