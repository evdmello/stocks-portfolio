import Foundation

struct SummaryViewModel {
    let currentValue: String
    let totalInvestment: String
    let todayProfitLoss: String
    let totalProfitLoss: String
    let isTodayProfitLossPositive: Bool
    let isTotalProfitLossPositive: Bool
    let totalProfitLossPercentage: String
    
    init(currentValue: Double, totalInvestment: Double, todayPNL: Double, totalPNL: Double) {
        self.currentValue = currentValue.toINRCurrency()
        self.totalInvestment = totalInvestment.toINRCurrency()
        self.todayProfitLoss = todayPNL.toINRCurrency()
        self.totalProfitLoss = totalPNL.toINRCurrency()
        self.isTodayProfitLossPositive = todayPNL >= 0
        self.isTotalProfitLossPositive = totalPNL >= 0
        let pnlPercentage: Double = totalPNL / totalInvestment * 100.0
        self.totalProfitLossPercentage = String(format: "%.2f", pnlPercentage)
    }
}
