import Foundation

protocol HoldingsRepository {
    func getHoldings(completion: @escaping (Result<Holdings, RepositoryError>) -> Void)
}
