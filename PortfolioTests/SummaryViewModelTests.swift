import XCTest
@testable import Portfolio

final class SummaryViewModelTests: XCTestCase {
    func test_init_withSummaryValues_generatesCorrectSummary() {
        let sut = SummaryViewModel(currentValue: 27893.65, totalInvestment: 28590.71, todayPNL: -235.65, totalPNL: -697.06)
        
        XCTAssertEqual(sut.currentValue, "₹ 27,893.65")
        XCTAssertEqual(sut.totalInvestment, "₹ 28,590.71")
        XCTAssertEqual(sut.todayProfitLoss, "-₹ 235.65")
        XCTAssertEqual(sut.totalProfitLoss, "-₹ 697.06")
        XCTAssertEqual(sut.totalProfitLossPercentage, "-2.44")
        XCTAssertFalse(sut.isTodayProfitLossPositive)
        XCTAssertFalse(sut.isTotalProfitLossPositive)
    }
}
