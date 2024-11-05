import XCTest
@testable import Portfolio

final class RemoteHoldingsRepositoryTests: XCTestCase {
    private var networkService: NetworkServiceMock!
    private var remoteHoldingsRepository: RemoteHoldingsRepository!
    
    func test_fetchHoldings_whenNetworkServiceReturnsValidData_shouldReturnHoldings() {
        let networkService = NetworkServiceMock()
        let sut = RemoteHoldingsRepository(client: networkService)
        let dummyHoldings = makeDummyHoldingsData()
        networkService.fetchCompletion = .success(dummyHoldings)
        
        let expectedHoldings = makeDummyHoldings()
        let expectation = self.expectation(description: "Holdings fetched")
        sut.getHoldings { result in
            switch result {
            case .success(let holdings):
                XCTAssertEqual(holdings.data.holdings.count, expectedHoldings.data.holdings.count)
            case .failure:
                XCTFail("Expected holdings, but got an error")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_fetchHoldings_whenNetworkServiceReturnsError_shouldReturnError() {
        let networkService = NetworkServiceMock()
        let sut = RemoteHoldingsRepository(client: networkService)
        networkService.fetchCompletion = .failure(.systemError(NSError(domain: "test", code: 0, userInfo: nil)))
        
        let expectation = self.expectation(description: "Holdings fetched")
        sut.getHoldings { result in
            switch result {
            case .success:
                XCTFail("Expected an error, but got holdings")
            case .failure(let error):
                XCTAssertEqual(error, .networkRequestFailed)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_fetchHoldings_whenNetworkServiceReturnsInvalidData_shouldReturnError() {
        let networkService = NetworkServiceMock()
        let sut = RemoteHoldingsRepository(client: networkService)
        networkService.fetchCompletion = .success(Data())
        
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

    private func makeDummyHoldingsData() -> Data {
        return try! JSONEncoder().encode(makeDummyHoldings())
    }
    
    private func makeDummyHoldings() -> Holdings {
        Holdings(data: HoldingsData(holdings: [Holding(symbol: "TATA", quantity: 100, ltp: 120.0, avgPrice: 1220.33, close: 1200.2)]))
    }
}

final class NetworkServiceMock: NetworkService {
    var fetchCompletion: Result<Data, NetworkError>!

    func fetch(request: URLRequest, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        completion(fetchCompletion)
    }
}
