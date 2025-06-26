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
        title = user != nil ? StringConstants.editUser : StringConstants.createUser
        
        // Scroll view setup
        scrollView.showsVerticalScrollIndicator = false
        scrollView.keyboardDismissMode = .onDrag
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        // Content view setup
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        // Title setup
//        titleLabel.text = user != nil ? "Edit User" : "Create New User"
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = AppConstants.Colors.textColor
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Text fields setup
        setupTextField(nameTextField, placeholder: StringConstants.namePlaceholder)
        setupTextField(emailTextField, placeholder: StringConstants.emailPlaceholder)
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        
        // Segmented controls setup
        genderSegmentedControl.selectedSegmentIndex = 0
        genderSegmentedControl.backgroundColor = AppConstants.Colors.secondary
        genderSegmentedControl.selectedSegmentTintColor = AppConstants.Colors.primary
        genderSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        statusSegmentedControl.selectedSegmentIndex = 0
        statusSegmentedControl.backgroundColor = AppConstants.Colors.secondary
        statusSegmentedControl.selectedSegmentTintColor = AppConstants.Colors.primary
        statusSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        // Buttons setup
        let buttonTitle = user != nil ? StringConstants.updateUser : StringConstants.createUser
        setupButton(createButton, title: buttonTitle, backgroundColor: AppConstants.Colors.primary)
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        
        setupButton(cancelButton, title: StringConstants.cancel, backgroundColor: AppConstants.Colors.secondary)
        cancelButton.setTitleColor(AppConstants.Colors.textColor, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        // Add subviews
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(titleLabel, nameTextField, emailTextField, genderContainer, statusContainer, createButton, cancelButton)
        
        // Add segmented controls to containers
        let genderLabel = UILabel()
        genderLabel.text = StringConstants.gender
        genderLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        genderLabel.textColor = AppConstants.Colors.textColor
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let statusLabel = UILabel()
        statusLabel.text = StringConstants.status
        statusLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        statusLabel.textColor = AppConstants.Colors.textColor
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        genderContainer.addSubviews(genderLabel, genderSegmentedControl)
        statusContainer.addSubviews(statusLabel, statusSegmentedControl)
        genderContainer.translatesAutoresizingMaskIntoConstraints = false
        statusContainer.translatesAutoresizingMaskIntoConstraints = false
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
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            
            // Name field
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            nameTextField.heightAnchor.constraint(equalToConstant: AppConstants.Dimensions.buttonHeight),
            
            // Email field
            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            emailTextField.heightAnchor.constraint(equalToConstant: AppConstants.Dimensions.buttonHeight),
            
            // Gender container
            genderContainer.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 24),
            genderContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            genderContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            
            // Gender label
            genderContainer.subviews[0].topAnchor.constraint(equalTo: genderContainer.topAnchor),
            genderContainer.subviews[0].leadingAnchor.constraint(equalTo: genderContainer.leadingAnchor),
            genderContainer.subviews[0].trailingAnchor.constraint(equalTo: genderContainer.trailingAnchor),
            
            // Gender segmented control
            genderSegmentedControl.topAnchor.constraint(equalTo: genderContainer.subviews[0].bottomAnchor, constant: 8),
            genderSegmentedControl.leadingAnchor.constraint(equalTo: genderContainer.leadingAnchor),
            genderSegmentedControl.trailingAnchor.constraint(equalTo: genderContainer.trailingAnchor),
            genderSegmentedControl.bottomAnchor.constraint(equalTo: genderContainer.bottomAnchor),
            genderSegmentedControl.heightAnchor.constraint(equalToConstant: 32),
            
            // Status container
            statusContainer.topAnchor.constraint(equalTo: genderContainer.bottomAnchor, constant: 24),
            statusContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            statusContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            
            // Status label
            statusContainer.subviews[0].topAnchor.constraint(equalTo: statusContainer.topAnchor),
            statusContainer.subviews[0].leadingAnchor.constraint(equalTo: statusContainer.leadingAnchor),
            statusContainer.subviews[0].trailingAnchor.constraint(equalTo: statusContainer.trailingAnchor),
            
            // Status segmented control
            statusSegmentedControl.topAnchor.constraint(equalTo: statusContainer.subviews[0].bottomAnchor, constant: 8),
            statusSegmentedControl.leadingAnchor.constraint(equalTo: statusContainer.leadingAnchor),
            statusSegmentedControl.trailingAnchor.constraint(equalTo: statusContainer.trailingAnchor),
            statusSegmentedControl.bottomAnchor.constraint(equalTo: statusContainer.bottomAnchor),
            statusSegmentedControl.heightAnchor.constraint(equalToConstant: 32),
            
            // Create button
            createButton.topAnchor.constraint(equalTo: statusContainer.bottomAnchor, constant: 24),
            createButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            createButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            createButton.heightAnchor.constraint(equalToConstant: AppConstants.Dimensions.buttonHeight),
            
            // Cancel button
            cancelButton.topAnchor.constraint(equalTo: createButton.bottomAnchor, constant: 16),
            cancelButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            cancelButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            cancelButton.heightAnchor.constraint(equalToConstant: AppConstants.Dimensions.buttonHeight),
            cancelButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
    }
    
    // MARK: - Private Methods
    private func setupTextField(_ textField: UITextField, placeholder: String) {
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.backgroundColor = AppConstants.Colors.background
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupButton(_ button: UIButton, title: String, backgroundColor: UIColor) {
        button.setTitle(title, for: .normal)
        button.backgroundColor = backgroundColor
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.makeRounded()
        button.translatesAutoresizingMaskIntoConstraints = false
    }
    
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
            Logger.log("User \(actionType) successfully: \(user.name), ID: \(String(describing: user.id))")
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
            // Try to find UserListViewController in the navigation stack
            for viewController in navController.viewControllers {
                if viewController is UserListViewController {
                    navController.popToViewController(viewController, animated: true)
                    return
                }
            }
            
            // If not found in stack, create new instance and push
            let userListVC = UserListViewController()
            navController.pushViewController(userListVC, animated: true)
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
        Logger.log("Attempting to \(user != nil ? "update" : "create") user: \(userData.name), ID: \(String(describing: userData.id))")
        
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
            scrollView.scrollRectToVisible((nameTextField.isFirstResponder ? nameTextField : emailTextField).frame, animated: true)
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
}
