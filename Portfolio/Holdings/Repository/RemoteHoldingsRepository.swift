import Foundation

final class RemoteHoldingsRepository: HoldingsRepository {
    private let client: NetworkService
    
    init(client: NetworkService = NetworkServiceImpl()) {
        self.client = client
    }
    
    func getHoldings(completion: @escaping (Result<Holdings, RepositoryError>) -> Void) {
        client.fetch(request: NetworkRequests.fetchHoldings) { result in
            switch result {
            case let .success(data):
                do {
                    let decodedData = try JSONDecoder().decode(Holdings.self, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(.failedToParseJSON))
                }
            case .failure:
                completion(.failure(.networkRequestFailed))
            }
        }
    }
}
