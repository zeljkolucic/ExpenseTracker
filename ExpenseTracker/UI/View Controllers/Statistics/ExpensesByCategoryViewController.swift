//
//  ExpensesByCategoryViewController.swift
//  ExpenseTracker
//
//  Created by Zeljko Lucic on 14.9.22..
//

import UIKit
import Charts

class ExpensesByCategoryViewController: DataLoadingViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var chartContainerView: UIView!
    @IBOutlet weak var totalValueLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: StatisticsViewModel!
    
    private var chartView = PieChartView()
    private var selectedIndexPath: IndexPath?
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Strings.charts.localized
        configureCollectionView()
        configureTableView()
        addChartsAsSubview()
        
        getMonthlyTransactions()
    }
    
    // MARK: - Configuration
    
    private func configureCollectionView() {
        collectionView.register(MonthCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    private func configureTableView() {
        tableView.register(CategoryTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func selectCollectionViewLastItem() {
        if let indexPath = selectedIndexPath {
            collectionView.scrollToItem(at: indexPath, at: .right, animated: false)
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .right)
        }
    }
    
    private func addChartsAsSubview() {
        chartContainerView.addSubview(chartView)
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.topAnchor.constraint(equalTo: chartContainerView.topAnchor).isActive = true
        chartView.leadingAnchor.constraint(equalTo: chartContainerView.leadingAnchor).isActive = true
        chartView.bottomAnchor.constraint(equalTo: chartContainerView.bottomAnchor).isActive = true
        chartView.trailingAnchor.constraint(equalTo: chartContainerView.trailingAnchor).isActive = true
    }
    
    private func configureCharts() {
        var dataEntries = [PieChartDataEntry]()
        for category in viewModel.categories {
            let value = Double(category.value)
            let label = category.title
            let dataEntry = PieChartDataEntry(value: value, label: label)
            dataEntries.append(dataEntry)
        }
    
        let chartDataSet = PieChartDataSet(entries: dataEntries)
        
        let step = chartDataSet.entries.count
        let colors = UIColor.systemBlue.colorPalette(for: step)
        chartDataSet.colors = colors
        chartDataSet.label = .none
        chartView.holeColor = .clear
        
        let chartData = PieChartData(dataSet: chartDataSet)
        chartView.data = chartData
        
        chartView.data?.notifyDataChanged()
        chartView.notifyDataSetChanged()
    }
    
    func getMonthlyTransactions() {
        presentLoadingView()
        viewModel.getMonthlyTransactions { [weak self] result in
            guard let self = self else { return }
            
            self.dismissLoadingView()
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.collectionView.reloadData()
                    
                    let item = self.viewModel.monthlyTransactions.count - 1
                    self.selectedIndexPath = IndexPath(item: item, section: .zero)
                    self.selectCollectionViewLastItem()
                    
                    self.getTransactions()
                    
                case .failure:
                    let title = Strings.errorAlertTitle.localized
                    let actions = [
                        UIAlertAction(title: Strings.ok.localized, style: .default)
                    ]
                    self.presentAlert(title: title, actions: actions)
                }
            }
        }
    }
    
    private func getTransactions() {
        presentLoadingView()
        if let selectedIndexPath = selectedIndexPath {
            let monthlyTransactions = viewModel.monthlyTransactions[selectedIndexPath.item]
            totalValueLabel.text = "Total: \(String(format: "%.2f", monthlyTransactions.total)) RSD"
            
            viewModel.getTransactions(in: monthlyTransactions) { [weak self] result in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.dismissLoadingView()
                    
                    switch result {
                    case .success:
                        self.configureCharts()
                        self.tableView.reloadData()
                        
                    case .failure:
                        let title = Strings.warningAlertTitle.localized
                        let actions = [
                            UIAlertAction(title: Strings.ok.localized, style: .default)
                        ]
                        self.presentAlert(title: title, actions: actions)
                    }
                }
            }
        }
    }
}

// MARK: - Collection View Delegate and Data Source

extension ExpensesByCategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.monthlyTransactions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(MonthCollectionViewCell.self, indexPath: indexPath) else {
            return UICollectionViewCell()
        }
        
        let monthlyTransactions = viewModel.monthlyTransactions[indexPath.item]
        cell.monthLabel.text = monthlyTransactions.prettyDateFormatMonth
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        getTransactions()
    }
}

// MARK: - Table View Delegate and Data Source

extension ExpensesByCategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(CategoryTableViewCell.self, at: indexPath) else {
            return UITableViewCell()
        }
        
        let category = viewModel.categories[indexPath.row]
        
        let step = viewModel.categories.count
        let colors = UIColor.systemBlue.colorPalette(for: step)
        
        cell.titleLabel.text = category.title
        cell.detailsLabel.text = String(format: "%.2f", category.value)
        cell.color = colors[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
