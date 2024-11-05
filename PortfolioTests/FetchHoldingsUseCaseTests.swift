import XCTest
@testable import Portfolio

final class FetchHoldingsUseCaseTests: XCTestCase {
    func test_getHoldings_whenRepositoryReturnsHoldings_shouldReturnHoldings() {
        let repository = HoldingsRepositoryMock()
        let sut = FetchHoldingsUseCaseImpl(repository: repository)
        let expectedHoldings = makeDummyHoldings()
        repository.getHoldingsCompletion = .success(expectedHoldings)
        
        let expectation = self.expectation(description: "Holdings fetched")
        sut.getHoldings { result in
            switch result {
            case .success(let holdings):
                XCTAssertEqual(holdings.data.holdings[0].symbol, expectedHoldings.data.holdings[0].symbol)
            case .failure:
                XCTFail("Expected holdings, but got an error")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_getHoldings_whenRepositoryReturnsError_shouldReturnError() {
        let repository = HoldingsRepositoryMock()
        let sut = FetchHoldingsUseCaseImpl(repository: repository)
        repository.getHoldingsCompletion = .failure(.failedToParseJSON)
        
        let expectation = self.expectation(description: "Holdings fetched")
        sut.getHoldings { result in
            switch result {
            case .success:
                XCTFail("Expected an error, but got holdings")
            case .failure(let error):
                XCTAssertEqual(error, .failedToFetchHoldings)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 0.1)
    }
    
    private func makeDummyHoldings() -> Holdings {
        Holdings(data: HoldingsData(holdings: [Holding(symbol: "TATA", quantity: 100, ltp: 120.0, avgPrice: 1220.33, close: 1200.2)]))
    }

    final class HoldingsRepositoryMock: HoldingsRepository {
        var getHoldingsCompletion: Result<Holdings, RepositoryError>?
        
        func getHoldings(completion: @escaping (Result<Holdings, RepositoryError>) -> Void) {
            if let getHoldingsCompletion = getHoldingsCompletion {
                completion(getHoldingsCompletion)
            }
        }
    }
}
