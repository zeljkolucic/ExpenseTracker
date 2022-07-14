//
//  DateTextField.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/12/22.
//

import UIKit

class DateTextField: UITextField {

    // MARK: - Properties
    
    private lazy var datePickerImageView: UIImageView = {
        let image = UIImage(systemName: SFSymbols.calendar)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLayout()
    }
    
    // MARK: - Configuration
    
    private func configureLayout() {
        layer.cornerRadius = 5
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGray.cgColor
        
        addSubview(datePickerImageView)
        setConstraints()
    }
    
    private func setConstraints() {
        datePickerImageView.topAnchor.constraint(equalTo: topAnchor, constant: 14).isActive = true
        datePickerImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14).isActive = true
        datePickerImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14).isActive = true
        datePickerImageView.widthAnchor.constraint(equalTo: datePickerImageView.heightAnchor).isActive = true
    }
    
}
