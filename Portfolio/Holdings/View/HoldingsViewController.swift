import UIKit

final class HoldingsViewController: UIViewController {
    private let viewModel: HoldingsViewModel
    
    init(viewModel: HoldingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.register(HoldingCell.self, forCellReuseIdentifier: HoldingCell.identifier)
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    lazy var portfolioView = PortfolioView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Holdings"
        
        view.addSubview(tableView)
        view.addSubview(portfolioView)
        portfolioView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        portfolioView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        portfolioView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        portfolioView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: portfolioView.collapsedHeight, right: 0)
        
        viewModel.refreshView = { [weak self] in
            guard let self else { return }
            self.tableView.reloadData()
            if let summary = viewModel.summary {
                self.portfolioView.configure(with: summary)
            }
        }
        
        viewModel.showLoading = { [weak self] value in
            guard let self else { return }
            value ? self.showLoading() : self.hideLoading()
        }
    }
    
    private func showLoading() {
        refreshControl.beginRefreshing()
        let contentOffset = CGPoint(x: 0, y: -refreshControl.frame.height)
        tableView.setContentOffset(contentOffset, animated: true)
    }
    
    private func hideLoading() {
        self.refreshControl.endRefreshing()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.fetchData()
    }
    
    @objc
    private func refresh() {
        viewModel.fetchData()
    }
}

extension HoldingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.holdings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HoldingCell.identifier, for: indexPath) as! HoldingCell
        let model = viewModel.holdings[indexPath.row]
        cell.configure(with: model)
        return cell
    }
}
