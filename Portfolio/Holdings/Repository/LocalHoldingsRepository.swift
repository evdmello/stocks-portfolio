import Foundation

final class LocalHoldingsRepository: HoldingsRepository {
    private let client: URLCache
    
    init(client: URLCache = .shared) {
        self.client = client
    }
    
    func getHoldings(completion: @escaping (Result<Holdings, RepositoryError>) -> Void) {
        if let cachedResponse = client.cachedResponse(for: NetworkRequests.fetchHoldings) {
            do {
                let decodedData = try JSONDecoder().decode(Holdings.self, from: cachedResponse.data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.failedToParseJSON))
            }
        } else {
            completion(.failure(.noCachedResponse))
        }
    }
}
