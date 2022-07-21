//
//  DetailTransactionViewController.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/15/22.
//

import UIKit

class DetailTransactionViewController: UIViewController {

    // MARK: - Properties
    
    enum State {
        case add, edit, view
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    private lazy var datePickerToolbar: UIToolbar = {
        let toolbar = UIToolbar()
        let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancelDatePickerToolbarButton))
        let spacingBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDoneDatePickerToolbarButton))
        toolbar.items = [cancelBarButton, spacingBarButton, doneBarButton]
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        return toolbar
    }()
    
    private lazy var methodOfPaymentPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private lazy var methodOfPaymentPickerToolbar: UIToolbar = {
        let toolbar = UIToolbar()
        let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancelMethodOfPaymentToolbarButton))
        let spacingBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDoneMethodOfPaymentToolbarButton))
        toolbar.items = [cancelBarButton, spacingBarButton, doneBarButton]
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        return toolbar
    }()
    
    var state: State!
    var isCurrentlyEditing: Bool = false
    
    var viewModel: TransactionViewModel = TransactionViewModel()
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
        configureTableView()
        configureTextField()
        dismissKeyboardWhenTouchOutside()
    }

    // MARK: - Configuration
    
    private func configureLayout() {
        let closeBarButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapCloseButton))
        navigationItem.leftBarButtonItem = closeBarButton
        
        switch state {
        case .add:
            configureDoneBarButton()
            valueTextField.becomeFirstResponder()
            
        case .edit:
            configureEditBarButtons()
            valueTextField.isEnabled = false
        
        case .view:
            valueTextField.isEnabled = false
            
        default:
            break
        }
        
        valueTextField.text = String(viewModel.value)
    }
    
    private func configureDoneBarButton() {
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDoneButton))
        navigationItem.rightBarButtonItems = [doneBarButton]
    }
    
    private func configureEditBarButtons() {
        let editImage = UIImage(systemName: SFSymbols.edit)
        let editBarButton = UIBarButtonItem(image: editImage, style: .plain, target: self, action: #selector(didTapEditButton))
        
        let deleteImage = UIImage(systemName: SFSymbols.delete)
        let deleteBarButton = UIBarButtonItem(image: deleteImage, style: .plain, target: self, action: #selector(didTapDeleteButton))
        deleteBarButton.tintColor = .systemRed
        
        navigationItem.rightBarButtonItems = [deleteBarButton, editBarButton]
    }
    
    private func configureTableView() {
        tableView.separatorColor = .lightGray
        tableView.register(TransactionDetailTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func configureTextField() {
        valueTextField.delegate = self
        valueTextField.keyboardType = .decimalPad
        valueTextField.returnKeyType = .done
        valueTextField.borderStyle = .none
        
        let toolbar = UIToolbar()
        let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissKeyboard))
        let spacingBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDoneToolbarButton))
        toolbar.items = [cancelBarButton, spacingBarButton, doneBarButton]
        toolbar.sizeToFit()
        valueTextField.inputAccessoryView = toolbar
    }
    
    // MARK: - Actions
    
    @objc private func didTapDoneButton() {
        switch state {
        case .edit:
            isCurrentlyEditing = false
            valueTextField.resignFirstResponder()
            valueTextField.isEnabled = false
            configureEditBarButtons()
            
        case .add:
            dismiss(animated: true)
            
        default:
            break
        }
    }
    
    @objc private func didTapCloseButton() {
        dismiss(animated: true)
    }
    
    @objc private func didTapEditButton() {
        isCurrentlyEditing = true
        configureDoneBarButton()
        valueTextField.isEnabled = true
        valueTextField.becomeFirstResponder()
    }
    
    @objc private func didTapDeleteButton() {
        let alertController = UIAlertController(title: Strings.warningAlertTitle.localized, message: Strings.deleteAlertMessage.localized, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Strings.no.localized, style: .cancel))
        alertController.addAction(UIAlertAction(title: Strings.yes.localized, style: .destructive) { [weak self] _ in
            alertController.dismiss(animated: true)
            self?.navigationController?.popViewController(animated: true)
        })
        present(alertController, animated: true)
    }
    
    @objc private func dismissKeyboard() {
        valueTextField.resignFirstResponder()
    }
    
    @objc private func didTapDoneToolbarButton() {
        valueTextField.resignFirstResponder()
    }
    
    @objc private func didTapCancelDatePickerToolbarButton() {
        dismissDatePicker()
    }
    
    @objc private func didTapDoneDatePickerToolbarButton() {
        viewModel.date = datePicker.date
        dismissDatePicker()
        tableView.reloadData()
    }
    
    @objc private func didTapCancelMethodOfPaymentToolbarButton() {
        dismissMethodOfPaymentPicker()
    }
    
    @objc private func didTapDoneMethodOfPaymentToolbarButton() {
        let methodOfPaymentIndex = methodOfPaymentPicker.selectedRow(inComponent: 0)
        let methodOfPayment = MethodOfPayment.allCases[methodOfPaymentIndex]
        viewModel.methodOfPayment = methodOfPayment
        dismissMethodOfPaymentPicker()
        tableView.reloadData()
    }
    
    private func didSelectCategory() {
        
    }
    
    private func didSelectSubcategory() {
        
    }
    
    private func didSelectDate() {
        presentDatePicker()
    }
    
    private func didSelectMethodOfPayment() {
        presentMethodOfPaymentPicker()
    }
    
    // MARK: - Presentation
    
    private func presentSubcategoriesViewController() {
        
    }
    
    private func presentDatePicker() {
        view.addSubview(datePicker)
        datePicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        view.addSubview(datePickerToolbar)
        datePickerToolbar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        datePickerToolbar.bottomAnchor.constraint(equalTo: datePicker.topAnchor).isActive = true
        datePickerToolbar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        datePicker.date = viewModel.date
    }
    
    private func dismissDatePicker() {
        datePicker.removeFromSuperview()
        datePickerToolbar.removeFromSuperview()
    }
    
    private func presentMethodOfPaymentPicker() {
        view.addSubview(methodOfPaymentPicker)
        methodOfPaymentPicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        methodOfPaymentPicker.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        methodOfPaymentPicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        view.addSubview(methodOfPaymentPickerToolbar)
        methodOfPaymentPickerToolbar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        methodOfPaymentPickerToolbar.bottomAnchor.constraint(equalTo: methodOfPaymentPicker.topAnchor).isActive = true
        methodOfPaymentPickerToolbar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    private func dismissMethodOfPaymentPicker() {
        methodOfPaymentPicker.removeFromSuperview()
        methodOfPaymentPickerToolbar.removeFromSuperview()
    }
    
    private func cleanupView() {
        dismissDatePicker()
        dismissMethodOfPaymentPicker()
    }
    
    private func presentValueAlert() {
        let alertController = UIAlertController(title: Strings.errorAlertTitle.localized, message: Strings.valueAlertMessage.localized, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Strings.ok.localized, style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.valueTextField.text = String(self.viewModel.value)
        }))
        present(alertController, animated: true)
    }

}

// MARK: - Table View Delegate and Data Source

extension DetailTransactionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(TransactionDetailTableViewCell.self) else {
            return UITableViewCell()
        }
        
        switch indexPath.row {
        case 0:
            cell.detailImageView.image = UIImage(systemName: SFSymbols.edit)
            cell.titleLabel.text = Strings.category.localized
            cell.subtitleLabel.text = viewModel.category.localized
            
        case 1:
            cell.detailImageView.image = UIImage(systemName: SFSymbols.edit)
            cell.titleLabel.text = Strings.category.localized
            cell.subtitleLabel.text = viewModel.category.localized
            
        case 2:
            cell.detailImageView.image = UIImage(systemName: SFSymbols.calendar)
            cell.titleLabel.text = Strings.date.localized
            cell.subtitleLabel.text = viewModel.date.toString()
            
        case 3:
            cell.detailImageView.image = UIImage(systemName: SFSymbols.edit)
            cell.titleLabel.text = Strings.methodOfPayment.localized
            cell.subtitleLabel.text = viewModel.methodOfPayment.localized
            
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if isCurrentlyEditing {
            // If datePicker or methodOfPaymentPicker are presented they will first be removed from superview
            cleanupView()
            
            switch indexPath.row {
            case 0:
                didSelectCategory()
            case 1:
                didSelectSubcategory()
            case 2:
                didSelectDate()
            case 3:
                didSelectMethodOfPayment()
            default:
                break
            }
        }
    }
    
}

// MARK: - Text Field Delegate

extension DetailTransactionViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let textValue = valueTextField.text, let value = Float(textValue) else {
            presentValueAlert()
            return
        }
        
        viewModel.value = value
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let textValue = valueTextField.text, let value = Float(textValue) else {
            presentValueAlert()
            return false
        }
        
        viewModel.value = value
        return true
    }
    
}

// MARK: - Picker View Delegate and Data Source

extension DetailTransactionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return MethodOfPayment.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return MethodOfPayment.allCases[row].localized
    }
    
}
