import XCTest
@testable import Portfolio

final class FetchHoldingsRepositoryTests: XCTestCase {
    func test_getHoldings_whenPrimaryRepositoryReturnsHoldings_shouldReturnHoldings() {
        let primaryRepository = HoldingsRepositoryMock()
        let fallbackRepository = HoldingsRepositoryMock()
        let sut = FetchHoldingsRepository(primary: primaryRepository, fallback: fallbackRepository)
        let expectedHoldings = makeDummyHoldings()
        primaryRepository.getHoldingsCompletion = .success(expectedHoldings)
        
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
        
    func test_getHoldings_whenPrimaryRepositoryReturnsError_shouldReturnHoldingsFromFallback() {
        let primaryRepository = HoldingsRepositoryMock()
        let fallbackRepository = HoldingsRepositoryMock()
        let sut = FetchHoldingsRepository(primary: primaryRepository, fallback: fallbackRepository)
        let expectedHoldings = makeDummyHoldings()
        fallbackRepository.getHoldingsCompletion = .success(expectedHoldings)
        
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
    
    func test_getHoldings_whenBothRepositoriesReturnError_shouldReturnError() {
        let primaryRepository = HoldingsRepositoryMock()
        let fallbackRepository = HoldingsRepositoryMock()
        let sut = FetchHoldingsRepository(primary: primaryRepository, fallback: fallbackRepository)
        primaryRepository.getHoldingsCompletion = .failure(.failedToParseJSON)
        fallbackRepository.getHoldingsCompletion = .failure(.failedToParseJSON)
        
        let expectation = self.expectation(description: "Holdings fetched")
        sut.getHoldings { result in
            switch result {
            case .success:
                XCTFail("Expected an error, but got holdings")
            case .failure(let error):
                XCTAssertEqual(error, .failedToParseJSON)
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
            } else {
                completion(.failure(.networkRequestFailed))
            }
        }
    }
}
