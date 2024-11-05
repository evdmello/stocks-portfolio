import UIKit

final class PortfolioView: UIView {
    lazy var currentLabel: UILabel = {
        let label = UILabel()
        label.text = "Current value*"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var currentValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var totalInvestmentLabel: UILabel = {
        let label = UILabel()
        label.text = "Total Investment*"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var totalInvestmentValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var todayProfitLossLabel: UILabel = {
        let label = UILabel()
        label.text = "Today's Profit & Loss*"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var todayProfitLossValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var totalProfitLossLabel: UILabel = {
        let label = UILabel()
        label.text = "Profit & Loss*"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var totalProfitLossValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var portfolioDetailsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    lazy var portfolioHighlightsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    lazy var chevron: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.up"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var detailsViewHeightConstraint: NSLayoutConstraint!
    
    var collapsedHeight: CGFloat { portfolioHighlightsView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height }
    
    lazy var tapGesture: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with summary: SummaryViewModel) {
        if isHidden { isHidden = false }
        currentValueLabel.text = summary.currentValue
        totalInvestmentValueLabel.text = summary.totalInvestment
        todayProfitLossValueLabel.text = summary.todayProfitLoss
        totalProfitLossValueLabel.text = "\(summary.totalProfitLoss) (\(summary.totalProfitLossPercentage)%)"
        todayProfitLossValueLabel.textColor = summary.isTodayProfitLossPositive ? .green : .red
        totalProfitLossValueLabel.textColor = summary.isTotalProfitLossPositive ? .green : .red
    }
    
    private func configureView() {
        isHidden = true
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .lightGray
        addSubview(portfolioDetailsView)
        addSubview(portfolioHighlightsView)
        clipsToBounds = true
        layer.cornerRadius = 10
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.borderColor = UIColor.separator.cgColor
        layer.borderWidth = 1
        
        portfolioDetailsView.addSubview(currentLabel)
        portfolioDetailsView.addSubview(currentValueLabel)
        portfolioDetailsView.addSubview(totalInvestmentLabel)
        portfolioDetailsView.addSubview(totalInvestmentValueLabel)
        portfolioDetailsView.addSubview(todayProfitLossLabel)
        portfolioDetailsView.addSubview(todayProfitLossValueLabel)
        portfolioDetailsView.addSubview(separator)
        
        portfolioHighlightsView.addSubview(totalProfitLossLabel)
        portfolioHighlightsView.addSubview(totalProfitLossValueLabel)
        portfolioHighlightsView.addSubview(chevron)
        portfolioHighlightsView.addGestureRecognizer(tapGesture)
        portfolioHighlightsView.isUserInteractionEnabled = true
        
        NSLayoutConstraint.activate([
            currentLabel.topAnchor.constraint(equalTo: portfolioDetailsView.topAnchor, constant: 16),
            currentLabel.leadingAnchor.constraint(equalTo: portfolioDetailsView.leadingAnchor, constant: 20),
            
            currentValueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: currentLabel.trailingAnchor, constant: 8),
            currentValueLabel.trailingAnchor.constraint(equalTo: portfolioDetailsView.trailingAnchor, constant: -20),
            currentValueLabel.centerYAnchor.constraint(equalTo: currentLabel.centerYAnchor),
            
            totalInvestmentLabel.topAnchor.constraint(equalTo: currentLabel.bottomAnchor, constant: 8),
            totalInvestmentLabel.leadingAnchor.constraint(equalTo: portfolioDetailsView.leadingAnchor, constant: 20),
            
            totalInvestmentValueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: totalInvestmentLabel.trailingAnchor, constant: 8),
            totalInvestmentValueLabel.trailingAnchor.constraint(equalTo: portfolioDetailsView.trailingAnchor, constant: -20),
            totalInvestmentValueLabel.centerYAnchor.constraint(equalTo: totalInvestmentLabel.centerYAnchor),
            
            todayProfitLossLabel.topAnchor.constraint(equalTo: totalInvestmentLabel.bottomAnchor, constant: 8),
            todayProfitLossLabel.leadingAnchor.constraint(equalTo: portfolioDetailsView.leadingAnchor, constant: 20),
            
            todayProfitLossValueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: todayProfitLossLabel.trailingAnchor, constant: 8),
            todayProfitLossValueLabel.trailingAnchor.constraint(equalTo: portfolioDetailsView.trailingAnchor, constant: -20),
            todayProfitLossValueLabel.centerYAnchor.constraint(equalTo: todayProfitLossLabel.centerYAnchor),
            
            separator.topAnchor.constraint(equalTo: todayProfitLossLabel.bottomAnchor, constant: 8),
            separator.leadingAnchor.constraint(equalTo: portfolioDetailsView.leadingAnchor, constant: 20),
            separator.trailingAnchor.constraint(equalTo: portfolioDetailsView.trailingAnchor, constant: -20),
            separator.bottomAnchor.constraint(equalTo: portfolioDetailsView.bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1),
            
            totalProfitLossLabel.topAnchor.constraint(equalTo: portfolioHighlightsView.topAnchor, constant: 16),
            totalProfitLossLabel.leadingAnchor.constraint(equalTo: portfolioHighlightsView.leadingAnchor, constant: 20),
            totalProfitLossLabel.bottomAnchor.constraint(equalTo: portfolioHighlightsView.bottomAnchor, constant: -16),
            chevron.leadingAnchor.constraint(equalTo: totalProfitLossLabel.trailingAnchor, constant: 8),
            chevron.centerYAnchor.constraint(equalTo: totalProfitLossLabel.centerYAnchor),
            totalProfitLossValueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: chevron.trailingAnchor, constant: 4),
            totalProfitLossValueLabel.trailingAnchor.constraint(equalTo: portfolioHighlightsView.trailingAnchor, constant: -20),
            totalProfitLossValueLabel.bottomAnchor.constraint(equalTo: portfolioHighlightsView.bottomAnchor, constant: -16),
            
            portfolioDetailsView.topAnchor.constraint(equalTo: topAnchor),
            portfolioDetailsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            portfolioDetailsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            portfolioHighlightsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            portfolioHighlightsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            portfolioHighlightsView.bottomAnchor.constraint(equalTo: bottomAnchor),
            portfolioHighlightsView.heightAnchor.constraint(equalToConstant: 52),
        ])
        translatesAutoresizingMaskIntoConstraints = false
        detailsViewHeightConstraint = heightAnchor.constraint(equalToConstant: collapsedHeight)
        detailsViewHeightConstraint.isActive = true
    }
    
    func expand() {
        chevron.image = UIImage(systemName: "chevron.down")
        self.detailsViewHeightConstraint.constant = portfolioDetailsView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height + 55
        UIView.animate(withDuration: 0.3) {
            self.superview?.layoutIfNeeded()
        }
    }
    
    func collapse() {
        chevron.image = UIImage(systemName: "chevron.up")
        self.detailsViewHeightConstraint.constant = collapsedHeight
        UIView.animate(withDuration: 0.3) {
            self.superview?.layoutIfNeeded()
        }
    }
    
    @objc
    private func handleTapGesture() {
        detailsViewHeightConstraint.constant == collapsedHeight ? expand() : collapse()
    }
}
