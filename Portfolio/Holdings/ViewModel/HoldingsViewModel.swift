import Foundation

final class HoldingsViewModel {
    private(set) var holdings: [HoldingCellViewModel] = []
    private let useCase: FetchHoldingsUseCase
    private(set) var summary: SummaryViewModel?
    var refreshView: (() -> Void)?
    var showLoading: ((Bool) -> Void)?
    
    init(useCase: FetchHoldingsUseCase) {
        self.useCase = useCase
    }
    
    func fetchData() {
        showLoading?(true)
        useCase.getHoldings { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let holdings):
                self.calculateSummaryAndMapHoldings(holdings.data.holdings)
            case .failure:
                self.holdings = []
                self.summary = nil
                // OR SHOW FAILURE
            }
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.refreshView?()
                self.showLoading?(false)
            }
        }
    }
    
    private func calculateSummaryAndMapHoldings(_ holdings: [Holding]) {
        var result = (currentValue: 0.0, totalInvestment: 0.0, totalPNL: 0.0, todayPNL: 0.0)
        
        result = holdings.reduce(result, { partialResult, holding in
            let currentValue = partialResult.currentValue + holding.ltp * holding.quantity
            let totalInvestment = partialResult.totalInvestment + holding.avgPrice * holding.quantity
            let totalPNL = partialResult.totalPNL + (currentValue - totalInvestment)
            let todayPNL = partialResult.todayPNL + ((holding.close - holding.ltp) * holding.quantity)
            return (
                currentValue: currentValue,
                totalInvestment: totalInvestment,
                totalPNL: totalPNL,
                todayPNL: todayPNL
            )
        })
        self.holdings = holdings.map({ HoldingCellViewModel(model: $0) })
        self.summary = SummaryViewModel(
            currentValue: result.currentValue,
            totalInvestment: result.totalInvestment,
            todayPNL: result.todayPNL,
            totalPNL: result.totalPNL
        )
    }
}
