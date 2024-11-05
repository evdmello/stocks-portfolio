import Foundation

final class FetchHoldingsRepository: HoldingsRepository {
    private let primary: HoldingsRepository
    private let fallback: HoldingsRepository
    
    init(primary: HoldingsRepository = RemoteHoldingsRepository(), fallback: HoldingsRepository = LocalHoldingsRepository()) {
        self.primary = primary
        self.fallback = fallback
    }
    
    func getHoldings(completion: @escaping (Result<Holdings, RepositoryError>) -> Void) {
        primary.getHoldings { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                completion(result)
            case .failure:
                self.fallback.getHoldings(completion: completion)
            }
        }
    }
}
