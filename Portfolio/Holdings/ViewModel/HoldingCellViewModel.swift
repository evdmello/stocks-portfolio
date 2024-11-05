import Foundation

struct HoldingCellViewModel {
    let symbol: String
    let ltpValue: String
    let quantity: String
    let profitLossValue: String
    let isProfitLossPositive: Bool
    
    init(model: Holding) {
        self.symbol = model.symbol
        self.ltpValue = model.ltp.toINRCurrency()
        self.quantity = String(model.quantity)
        let currentValue = model.ltp * model.quantity
        let investment = model.avgPrice * model.quantity
        let pnl = currentValue - investment
        self.profitLossValue = pnl.toINRCurrency()
        self.isProfitLossPositive = pnl >= 0
    }
}
