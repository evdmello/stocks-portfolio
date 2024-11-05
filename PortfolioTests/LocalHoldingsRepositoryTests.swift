import XCTest
@testable import Portfolio

final class LocalHoldingsRepositoryTests: XCTestCase {
    func test_getHoldings_whenCacheHasHoldings_shouldReturnHoldings() {
        let cache = URLCacheMock()
        let sut = LocalHoldingsRepository(client: cache)
        let expectedHoldings = makeDummyHoldings()
        cache.cachedResponse = CachedURLResponse(response: HTTPURLResponse(), data: makeDummyHoldingsData())
        
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
    
    func test_getHoldings_whenCacheHasNoHoldings_shouldReturnError() {
        let cache = URLCacheMock()
        let sut = LocalHoldingsRepository(client: cache)
        cache.cachedResponse = nil
        
        let expectation = self.expectation(description: "Holdings fetched")
        sut.getHoldings { result in
            switch result {
            case .success:
                XCTFail("Expected an error, but got holdings")
            case .failure(let error):
                XCTAssertEqual(error, .noCachedResponse)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 0.1)
    }
    
    private func makeDummyHoldingsData() -> Data {
        return try! JSONEncoder().encode(makeDummyHoldings())
    }
    
    private func makeDummyHoldings() -> Holdings {
        Holdings(data: HoldingsData(holdings: [Holding(symbol: "TATA", quantity: 100, ltp: 120.0, avgPrice: 1220.33, close: 1200.2)]))
    }

    final class URLCacheMock: URLCache, @unchecked Sendable {
        var cachedResponse: CachedURLResponse?
        
        override func cachedResponse(for request: URLRequest) -> CachedURLResponse? {
            cachedResponse
        }
    }
}
