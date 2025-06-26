//
//  CreateUserViewController.swift
//  dexianUser
//
//  Created by sheik hanifa on 26/06/25.
//

import UIKit

protocol CreateUserDelegate: AnyObject {
    func didSaveUser(_ user: User)
}

class CreateUserViewController: BaseViewController {
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let titleLabel = UILabel()
    private let nameTextField = UITextField()
    private let emailTextField = UITextField()
    private let genderSegmentedControl = UISegmentedControl(items: User.Gender.allCases.map { $0.displayName })
    private let statusSegmentedControl = UISegmentedControl(items: User.Status.allCases.map { $0.displayName })
    private let createButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)
    private let genderContainer = UIView()
    private let statusContainer = UIView()
    
    // Card containers for better visual hierarchy
    private let formCardView = UIView()
    private let nameFieldContainer = UIView()
    private let emailFieldContainer = UIView()
    
    // MARK: - Properties
    private let viewModel: CreateUserViewModel
    weak var delegate: CreateUserDelegate?
    var user: User? // Added to support editing
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupKeyboardObservers()
        configureForEditMode()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
        viewModel = CreateUserViewModel(repository: UserRepositoryImpl())
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        viewModel = CreateUserViewModel(repository: UserRepositoryImpl())
        super.init(coder: coder)
    }
    
    override func setupUI() {
        super.setupUI()
        view.backgroundColor = UIColor.systemGroupedBackground
        title = user != nil ? StringConstants.editUser : StringConstants.createUser
        
        // Scroll view setup
        scrollView.showsVerticalScrollIndicator = false
        scrollView.keyboardDismissMode = .onDrag
        scrollView.contentInsetAdjustmentBehavior = .automatic
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        // Content view setup
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        // Form card setup
        setupFormCard()
        
        // Title setup
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Text field containers setup
        setupTextFieldContainer(nameFieldContainer)
        setupTextFieldContainer(emailFieldContainer)
        
        // Text fields setup
        setupModernTextField(nameTextField, placeholder: "Full Name", icon: "person.fill")
        setupModernTextField(emailTextField, placeholder: "Email Address", icon: "envelope.fill")
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        
        // Segmented controls setup
        setupModernSegmentedControl(genderSegmentedControl)
        setupModernSegmentedControl(statusSegmentedControl)
        
        // Container setup
        setupLabeledContainer(genderContainer, title: "Gender", control: genderSegmentedControl)
        setupLabeledContainer(statusContainer, title: "Status", control: statusSegmentedControl)
        
        // Buttons setup
        let buttonTitle = user != nil ? "Update User" : "Create User"
        setupModernButton(createButton, title: buttonTitle, style: .primary)
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        
        setupModernButton(cancelButton, title: "Cancel", style: .secondary)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        // Add subviews
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(titleLabel, formCardView)
        formCardView.addSubviews(nameFieldContainer, emailFieldContainer, genderContainer, statusContainer, createButton, cancelButton)
        nameFieldContainer.addSubview(nameTextField)
        emailFieldContainer.addSubview(emailTextField)
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            // Scroll view
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content view
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Form card
            formCardView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            formCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            formCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            formCardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            // Name field container
            nameFieldContainer.topAnchor.constraint(equalTo: formCardView.topAnchor, constant: 24),
            nameFieldContainer.leadingAnchor.constraint(equalTo: formCardView.leadingAnchor, constant: 20),
            nameFieldContainer.trailingAnchor.constraint(equalTo: formCardView.trailingAnchor, constant: -20),
            nameFieldContainer.heightAnchor.constraint(equalToConstant: 56),
            
            // Name text field
            nameTextField.leadingAnchor.constraint(equalTo: nameFieldContainer.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: nameFieldContainer.trailingAnchor, constant: -16),
            nameTextField.centerYAnchor.constraint(equalTo: nameFieldContainer.centerYAnchor),
            nameTextField.heightAnchor.constraint(equalToConstant: 24),
            
            // Email field container
            emailFieldContainer.topAnchor.constraint(equalTo: nameFieldContainer.bottomAnchor, constant: 16),
            emailFieldContainer.leadingAnchor.constraint(equalTo: formCardView.leadingAnchor, constant: 20),
            emailFieldContainer.trailingAnchor.constraint(equalTo: formCardView.trailingAnchor, constant: -20),
            emailFieldContainer.heightAnchor.constraint(equalToConstant: 56),
            
            // Email text field
            emailTextField.leadingAnchor.constraint(equalTo: emailFieldContainer.leadingAnchor, constant: 16),
            emailTextField.trailingAnchor.constraint(equalTo: emailFieldContainer.trailingAnchor, constant: -16),
            emailTextField.centerYAnchor.constraint(equalTo: emailFieldContainer.centerYAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 24),
            
            // Gender container
            genderContainer.topAnchor.constraint(equalTo: emailFieldContainer.bottomAnchor, constant: 32),
            genderContainer.leadingAnchor.constraint(equalTo: formCardView.leadingAnchor, constant: 20),
            genderContainer.trailingAnchor.constraint(equalTo: formCardView.trailingAnchor, constant: -20),
            
            // Status container
            statusContainer.topAnchor.constraint(equalTo: genderContainer.bottomAnchor, constant: 24),
            statusContainer.leadingAnchor.constraint(equalTo: formCardView.leadingAnchor, constant: 20),
            statusContainer.trailingAnchor.constraint(equalTo: formCardView.trailingAnchor, constant: -20),
            
            // Create button
            createButton.topAnchor.constraint(equalTo: statusContainer.bottomAnchor, constant: 32),
            createButton.leadingAnchor.constraint(equalTo: formCardView.leadingAnchor, constant: 20),
            createButton.trailingAnchor.constraint(equalTo: formCardView.trailingAnchor, constant: -20),
            createButton.heightAnchor.constraint(equalToConstant: 54),
            
            // Cancel button
            cancelButton.topAnchor.constraint(equalTo: createButton.bottomAnchor, constant: 12),
            cancelButton.leadingAnchor.constraint(equalTo: formCardView.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: formCardView.trailingAnchor, constant: -20),
            cancelButton.heightAnchor.constraint(equalToConstant: 54),
            cancelButton.bottomAnchor.constraint(equalTo: formCardView.bottomAnchor, constant: -24)
        ])
    }
    
    // MARK: - Modern UI Setup Methods
    private func setupFormCard() {
        formCardView.backgroundColor = .systemBackground
        formCardView.layer.cornerRadius = 16
        formCardView.layer.shadowColor = UIColor.black.cgColor
        formCardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        formCardView.layer.shadowRadius = 8
        formCardView.layer.shadowOpacity = 0.1
        formCardView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupTextFieldContainer(_ container: UIView) {
        container.backgroundColor = UIColor.systemGray6
        container.layer.cornerRadius = 12
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor.systemGray4.cgColor
        container.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupModernTextField(_ textField: UITextField, placeholder: String, icon: String) {
        textField.placeholder = placeholder
        textField.borderStyle = .none
        textField.backgroundColor = .clear
        textField.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        textField.textColor = .label
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        // Add icon
        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = .systemGray2
        iconView.contentMode = .scaleAspectFit
        iconView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        paddingView.addSubview(iconView)
        iconView.center = paddingView.center
        
        textField.leftView = paddingView
        textField.leftViewMode = .always
    }
    
    private func setupModernSegmentedControl(_ segmentedControl: UISegmentedControl) {
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = UIColor.systemGray6
        segmentedControl.selectedSegmentTintColor = AppConstants.Colors.primary
        segmentedControl.setTitleTextAttributes([
            .foregroundColor: UIColor.label,
            .font: UIFont.systemFont(ofSize: 15, weight: .medium)
        ], for: .normal)
        segmentedControl.setTitleTextAttributes([
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 15, weight: .semibold)
        ], for: .selected)
        segmentedControl.layer.cornerRadius = 8
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupLabeledContainer(_ container: UIView, title: String, control: UISegmentedControl) {
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = title
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubviews(label, control)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: container.topAnchor),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            
            control.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            control.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            control.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            control.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            control.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    enum ButtonStyle {
        case primary, secondary
    }
    
    private func setupModernButton(_ button: UIButton, title: String, style: ButtonStyle) {
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        
        switch style {
        case .primary:
            button.backgroundColor = AppConstants.Colors.primary
            button.setTitleColor(.white, for: .normal)
            button.layer.shadowColor = AppConstants.Colors.primary.cgColor
            button.layer.shadowOffset = CGSize(width: 0, height: 4)
            button.layer.shadowRadius = 8
            button.layer.shadowOpacity = 0.3
        case .secondary:
            button.backgroundColor = UIColor.systemGray5
            button.setTitleColor(.label, for: .normal)
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.systemGray4.cgColor
        }
        
        // Add press animation
        button.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        button.addTarget(self, action: #selector(buttonTouchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    @objc private func buttonTouchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    @objc private func buttonTouchUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform.identity
        }
    }
    
    // MARK: - Private Methods
    private func configureForEditMode() {
        guard let user = user else { return }
        nameTextField.text = user.name
        emailTextField.text = user.email
        if let genderIndex = User.Gender.allCases.firstIndex(of: user.gender) {
            genderSegmentedControl.selectedSegmentIndex = genderIndex
        }
        if let statusIndex = User.Status.allCases.firstIndex(of: user.status) {
            statusSegmentedControl.selectedSegmentIndex = statusIndex
        }
    }
    
    private func bindViewModel() {
        viewModel.onUserCreated = { [weak self] user in
            self?.hideLoading()
            
            // Show success alert
            let actionType = self?.user != nil ? "updated" : "created"
            let alertTitle = "Success"
            let alertMessage = "User \(actionType) successfully!"
            
            let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                // Navigate to UserListViewController after OK is tapped
                self?.navigateToUserList()
                // Also notify delegate if needed
                self?.delegate?.didSaveUser(user)
            }
            alert.addAction(okAction)
            
            self?.present(alert, animated: true)
        }
        
        viewModel.onError = { [weak self] error in
            self?.hideLoading()
            self?.showError(error)
        }
        
        viewModel.onValidationError = { [weak self] message in
            self?.showAlert(title: "Validation Error", message: message)
        }
        
        viewModel.onLoadingStateChanged = { [weak self] isLoading in
            if isLoading {
                self?.showLoading()
            }
        }
    }
    
    // MARK: - Navigation
    private func navigateToUserList() {
        if let navController = navigationController {
            // If this VC was presented modally, dismiss it first
            if presentingViewController != nil {
                dismiss(animated: true) {
                    // After dismissing, ensure we're back to the UserListViewController
                    if let tabBarController = self.presentingViewController as? UITabBarController,
                       let selectedNavController = tabBarController.selectedViewController as? UINavigationController {
                        selectedNavController.popToRootViewController(animated: false)
                    }
                }
                return
            }
            
            // Try to find UserListViewController in the navigation stack
            for viewController in navController.viewControllers {
                if viewController is UserListViewController {
                    navController.popToViewController(viewController, animated: true)
                    return
                }
            }
            
            // If not found in stack, pop to root (assuming UserListViewController is root)
            navController.popToRootViewController(animated: true)
        }
    }
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    // MARK: - Actions
    @objc private func createButtonTapped() {
        let name = nameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let gender = User.Gender.allCases[genderSegmentedControl.selectedSegmentIndex]
        let status = User.Status.allCases[statusSegmentedControl.selectedSegmentIndex]
        
        let userData = User(id: user?.id, name: name, email: email, gender: gender, status: status)
        if user != nil {
            viewModel.updateUser(userData)
        } else {
            viewModel.createUser(userData)
        }
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        // Scroll to active text field if needed
        if nameTextField.isFirstResponder || emailTextField.isFirstResponder {
            let activeField = nameTextField.isFirstResponder ? nameFieldContainer : emailFieldContainer
            scrollView.scrollRectToVisible(activeField.frame, animated: true)
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
}

// MARK: - CreateUserViewController + UITextFieldDelegate
extension CreateUserViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            emailTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let container = textField == nameTextField ? nameFieldContainer : emailFieldContainer
        UIView.animate(withDuration: 0.2) {
            container.layer.borderColor = AppConstants.Colors.primary.cgColor
            container.layer.borderWidth = 2
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let container = textField == nameTextField ? nameFieldContainer : emailFieldContainer
        UIView.animate(withDuration: 0.2) {
            container.layer.borderColor = UIColor.systemGray4.cgColor
            container.layer.borderWidth = 1
        }
    }
}
