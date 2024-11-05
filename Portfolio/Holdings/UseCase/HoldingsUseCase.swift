protocol FetchHoldingsUseCase {
    func getHoldings(completion: @escaping (Result<Holdings, FetchHoldingsError>) -> Void)
}

final class FetchHoldingsUseCaseImpl: FetchHoldingsUseCase {
    private let repository: HoldingsRepository

    init(repository: HoldingsRepository) {
        self.repository = repository
    }
    
    func getHoldings(completion: @escaping (Result<Holdings, FetchHoldingsError>) -> Void) {
        repository.getHoldings { result in
            switch result {
            case .success(let holdings):
                completion(.success(holdings))
            case .failure:
                completion(.failure(.failedToFetchHoldings))
            }
        }
    }
}
