import UIKit

final class HoldingCell: UITableViewCell {
    lazy var quantityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "NET QTY: "
        return label
    }()
    
    lazy var quantityValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var symbolLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var ltpLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "LTP:"
        return label
    }()
    
    lazy var ltpValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var profitLossLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "P&L:"
        return label
    }()
    
    lazy var profitLossValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    static var identifier: String {
        String(describing: self)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: HoldingCellViewModel) {
        symbolLabel.text = model.symbol
        quantityValueLabel.text = model.quantity
        ltpValueLabel.text = model.ltpValue
        profitLossValueLabel.text = model.profitLossValue
        profitLossValueLabel.textColor = model.isProfitLossPositive ? .green : .red
    }
    
    private func configureView() {
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(symbolLabel)
        contentView.addSubview(quantityLabel)
        contentView.addSubview(quantityValueLabel)
        contentView.addSubview(ltpLabel)
        contentView.addSubview(ltpValueLabel)
        contentView.addSubview(profitLossLabel)
        contentView.addSubview(profitLossValueLabel)
        
        NSLayoutConstraint.activate([
            symbolLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            symbolLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            ltpValueLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            ltpValueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            ltpValueLabel.leadingAnchor.constraint(equalTo: ltpLabel.trailingAnchor, constant: 2),
            ltpLabel.centerYAnchor.constraint(equalTo: ltpValueLabel.centerYAnchor),
            ltpLabel.leadingAnchor.constraint(greaterThanOrEqualTo: symbolLabel.trailingAnchor, constant: 20),
            
            quantityLabel.centerYAnchor.constraint(equalTo: profitLossLabel.centerYAnchor),
            quantityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            quantityValueLabel.leadingAnchor.constraint(equalTo: quantityLabel.trailingAnchor, constant: 2),
            quantityValueLabel.centerYAnchor.constraint(equalTo: quantityLabel.centerYAnchor),
            
            profitLossLabel.leadingAnchor.constraint(greaterThanOrEqualTo: quantityValueLabel.trailingAnchor, constant: 20),
            profitLossLabel.topAnchor.constraint(equalTo: ltpLabel.bottomAnchor, constant: 30),
            profitLossLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            profitLossValueLabel.leadingAnchor.constraint(equalTo: profitLossLabel.trailingAnchor, constant: 2),
            profitLossValueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            profitLossValueLabel.centerYAnchor.constraint(equalTo: profitLossLabel.centerYAnchor)
        ])
    }
}
