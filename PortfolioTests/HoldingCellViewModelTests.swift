import XCTest
@testable import Portfolio

final class HoldingCellViewModelTests: XCTestCase {
    func test_init_withHoldingModel_generatesCorrectViewModel() {
        let holding = Holding(symbol: "AAPL", quantity: 10, ltp: 150.0, avgPrice: 100.0, close: 150.0)
        let sut = HoldingCellViewModel(model: holding)
        
        XCTAssertEqual(sut.symbol, "AAPL")
        XCTAssertEqual(sut.ltpValue, "₹ 150.00")
        XCTAssertEqual(sut.quantity, "10.0")
        XCTAssertEqual(sut.profitLossValue, "₹ 500.00")
        XCTAssertTrue(sut.isProfitLossPositive)
    }
    
    func test_init_withHoldingModel_generatesCorrectViewModelForNegativeProfitLoss() {
        let holding = Holding(symbol: "AAPL", quantity: 10, ltp: 100.0, avgPrice: 150.0, close: 100.0)
        let sut = HoldingCellViewModel(model: holding)
        
        XCTAssertEqual(sut.symbol, "AAPL")
        XCTAssertEqual(sut.ltpValue, "₹ 100.00")
        XCTAssertEqual(sut.quantity, "10.0")
        XCTAssertEqual(sut.profitLossValue, "-₹ 500.00")
        XCTAssertFalse(sut.isProfitLossPositive)
    }
    
    func test_init_withHoldingModel_generatesCorrectViewModelForZeroProfitLoss() {
        let holding = Holding(symbol: "AAPL", quantity: 10, ltp: 100.0, avgPrice: 100.0, close: 100.0)
        let sut = HoldingCellViewModel(model: holding)
        
        XCTAssertEqual(sut.symbol, "AAPL")
        XCTAssertEqual(sut.ltpValue, "₹ 100.00")
        XCTAssertEqual(sut.quantity, "10.0")
        XCTAssertEqual(sut.profitLossValue, "₹ 0.00")
        XCTAssertTrue(sut.isProfitLossPositive)
    }
}
