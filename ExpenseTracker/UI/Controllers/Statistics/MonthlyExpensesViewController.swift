//
//  MonthlyExpensesViewController.swift
//  ExpenseTracker
//
//  Created by Zeljko Lucic on 14.9.22..
//

import UIKit
import Charts

class MonthlyExpensesViewController: DataLoadingViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var chartContainerView: UIView!
    
    var viewModel: StatisticsViewModel!
    
    private let chartView = BarChartView()
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Strings.charts.localized
        
        addChartAsSubview()
        configureChartLayout()
        getMonthlyTransactions()
    }
    
    // MARK: - Configuration
    
    private func addChartAsSubview() {
        chartContainerView.addSubview(chartView)
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.topAnchor.constraint(equalTo: chartContainerView.topAnchor).isActive = true
        chartView.leadingAnchor.constraint(equalTo: chartContainerView.leadingAnchor).isActive = true
        chartView.bottomAnchor.constraint(equalTo: chartContainerView.bottomAnchor).isActive = true
        chartView.trailingAnchor.constraint(equalTo: chartContainerView.trailingAnchor).isActive = true
    }
    
    private func configureChartLayout() {
        let xAxis = chartView.xAxis
        xAxis.forceLabelsEnabled = false
        xAxis.labelPosition = .bottom
        
        chartView.rightAxis.enabled = false
        chartView.legend.enabled = false
    }
    
    private func getMonthlyTransactions() {
        presentLoadingView()
        viewModel.getMonthlyTransactions { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.fillChartData()
                    
                case .failure:
                    let title = Strings.errorAlertTitle.localized
                    let actions = [
                        UIAlertAction(title: Strings.ok.localized, style: .default, handler: { [weak self] _ in
                            self?.navigationController?.popViewController(animated: true)
                        })
                    ]
                    self.presentAlert(title: title, actions: actions)
                }
            }
        }
    }
    
    private func fillChartData() {
        let monthlyTransactions = viewModel.monthlyTransactions
        
        var dataEntries = [BarChartDataEntry]()
        for (x, monthlyTransaction) in monthlyTransactions.enumerated() {
            let x = Double(x)
            let total = Double(monthlyTransaction.total)
            let dataEntry = BarChartDataEntry(x: x, y: total)
            dataEntries.append(dataEntry)
        }
        
        let dataSet = BarChartDataSet(entries: dataEntries)
        let step = dataEntries.count
        let colors = UIColor.systemBlue.colorPalette(for: step)
        dataSet.colors = colors
        dataSet.label = .none
        
        let xAxis = chartView.xAxis
        let labels = monthlyTransactions.map { $0.prettyDateFormatMonth }
        xAxis.valueFormatter = IndexAxisValueFormatter(values: labels)
        xAxis.labelCount = labels.count
        xAxis.axisMaximum = Double(labels.count)
        
        let chartData = BarChartData(dataSet: dataSet)
        chartView.data = chartData
        
        dismissLoadingView()
    }
}
