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
    
    var selectedIndexPath: IndexPath?
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Strings.charts.localized
        configureCollectionView()
        configureTableView()
        configureCharts()
        
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
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func selectCollectionViewLastItem() {
        if let indexPath = selectedIndexPath {
            collectionView.scrollToItem(at: indexPath, at: .right, animated: false)
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .right)
        }
    }
    
    private func configureCharts() {
        let chartView = PieChartView()
        chartContainerView.addSubview(chartView)
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.topAnchor.constraint(equalTo: chartContainerView.topAnchor).isActive = true
        chartView.leadingAnchor.constraint(equalTo: chartContainerView.leadingAnchor).isActive = true
        chartView.bottomAnchor.constraint(equalTo: chartContainerView.bottomAnchor).isActive = true
        chartView.trailingAnchor.constraint(equalTo: chartContainerView.trailingAnchor).isActive = true
        
        chartView.holeColor = .clear
    
        let chartDataSet = PieChartDataSet(entries: [
            PieChartDataEntry(value: 20.0),
            PieChartDataEntry(value: 30.0, label: "Utilities"),
            PieChartDataEntry(value: 40.0),
            PieChartDataEntry(value: 60.0),
            PieChartDataEntry(value: 50.0)
        ])
        
        let step = chartDataSet.entries.count
        let colors = UIColor.systemBlue.colorPalette(for: step)
        chartDataSet.colors = colors
        chartDataSet.label = .none
        
        let chartData = PieChartData(dataSet: chartDataSet)
        chartView.data = chartData
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
                    
                    // TODO: - Fetch transactions for the selected month
                    
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
        // TODO: - Fetch transactions for the selected month
    }
}

// MARK: - Table View Delegate and Data Source

extension ExpensesByCategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
