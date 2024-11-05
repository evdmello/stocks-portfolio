import XCTest
@testable import Portfolio

final class HoldingsViewModelTests: XCTestCase {
    func test_fetchData_whenHoldingsAreFetched_shouldUpdateHoldingsAndSummary() {
        let useCase = FetchHoldingsUseCaseMock()
        let sut = HoldingsViewModel(useCase: useCase)
        let expectedHoldings = makeDummyHoldings()
        useCase.getHoldingsCompletion = .success(expectedHoldings)
        
        let expectation = self.expectation(description: "Holdings fetched")
        sut.refreshView = {
            XCTAssertEqual(sut.holdings[0].symbol, expectedHoldings.data.holdings[0].symbol)
            XCTAssertEqual(sut.summary?.currentValue, "₹ 12,000.00")
            XCTAssertEqual(sut.summary?.totalInvestment, "₹ 1,22,033.00")
            XCTAssertEqual(sut.summary?.todayProfitLoss, "₹ 1,08,020.00")
            XCTAssertEqual(sut.summary?.totalProfitLoss, "-₹ 1,10,033.00")
            XCTAssertEqual(sut.summary?.totalProfitLossPercentage, "-90.17")
            XCTAssertTrue(sut.summary!.isTodayProfitLossPositive)
            XCTAssertFalse(sut.summary!.isTotalProfitLossPositive)
            expectation.fulfill()
        }
        
        sut.fetchData()
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_fetchData_whenHoldingsAreFetched_shouldShowLoading() {
        let useCase = FetchHoldingsUseCaseMock()
        let sut = HoldingsViewModel(useCase: useCase)
        let expectedHoldings = makeDummyHoldings()
        useCase.getHoldingsCompletion = .success(expectedHoldings)
        
        let expectation = self.expectation(description: "Holdings fetched")
        sut.showLoading = { isLoading in
            XCTAssertTrue(isLoading)
            expectation.fulfill()
        }
        
        sut.fetchData()
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_fetchData_whenHoldingsAreFetched_shouldHideLoading() {
        let useCase = FetchHoldingsUseCaseMock()
        let sut = HoldingsViewModel(useCase: useCase)
        let expectedHoldings = makeDummyHoldings()
        useCase.getHoldingsCompletion = .success(expectedHoldings)
        
        let expectation = self.expectation(description: "Holdings fetched")
        sut.showLoading = { isLoading in
            if !isLoading {
                expectation.fulfill()
            }
        }
        
        sut.fetchData()
        
        waitForExpectations(timeout: 0.1)
    }

    func test_fetchData_whenHoldingsFetchFails_shouldUpdateHoldingsAndSummary() {
        let useCase = FetchHoldingsUseCaseMock()
        let sut = HoldingsViewModel(useCase: useCase)
        useCase.getHoldingsCompletion = .failure(.failedToFetchHoldings)
        
        let expectation = self.expectation(description: "Holdings fetched")
        sut.refreshView = {
            XCTAssertEqual(sut.holdings.count, 0)
            XCTAssertNil(sut.summary)
            expectation.fulfill()
        }
        
        sut.fetchData()
        
        waitForExpectations(timeout: 0.1)
    }

    private func makeDummyHoldings() -> Holdings {
        Holdings(data: HoldingsData(holdings: [Holding(symbol: "TATA", quantity: 100, ltp: 120.0, avgPrice: 1220.33, close: 1200.2)]))
    }

    final class FetchHoldingsUseCaseMock: FetchHoldingsUseCase {
        var getHoldingsCompletion: Result<Holdings, FetchHoldingsError>?
        
        func getHoldings(completion: @escaping (Result<Holdings, FetchHoldingsError>) -> Void) {
            if let getHoldingsCompletion = getHoldingsCompletion {
                completion(getHoldingsCompletion)
            } else {
                completion(.failure(.failedToFetchHoldings))
            }
        }
    }
}
