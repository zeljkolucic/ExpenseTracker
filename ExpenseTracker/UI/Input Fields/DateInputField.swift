//
//  DateInputField.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/12/22.
//

import UIKit

class DateInputField: UITextField {

    private lazy var calendarButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: SFSymbols.calendar)
        button.setBackgroundImage(image, for: .normal)
        button.tintColor = .lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    private func configure() {
        isEnabled = false
        calendarButton.addTarget(self, action: #selector(didTapCalendarButton), for: .touchUpInside)
        configureLayout()
    }
    
    private func configureLayout() {
        layer.cornerRadius = 5
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGray.cgColor
        
        addSubview(calendarButton)
        setConstraints()
    }
    
    private func setConstraints() {
        calendarButton.topAnchor.constraint(equalTo: topAnchor, constant: 14).isActive = true
        calendarButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14).isActive = true
        calendarButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14).isActive = true
        calendarButton.widthAnchor.constraint(equalTo: calendarButton.heightAnchor).isActive = true
    }
                                 
    // MARK: - Actions
        
    @objc private func didTapCalendarButton() {
        print("Did tap calendar button")
    }
    
}
