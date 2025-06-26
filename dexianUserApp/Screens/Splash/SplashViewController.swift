//
//  SplashViewController.swift
//  dexianUser
//
//  Created by sheik hanifa on 26/06/25.
//

import UIKit

class SplashViewController: BaseViewController {
    // MARK: - UI Components
    private let logoImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    
    // MARK: - Properties
    private let viewModel = SplashViewModel()
    private var hasNavigated = false // Prevent multiple navigation calls
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        bindViewModel()
        viewModel.initialize()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Debug: Check navigation controller
        
        // Fallback navigation - but only if haven't navigated yet
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            if !(self?.hasNavigated ?? true) {
                self?.navigateToUserList()
            }
        }
    }
    
    override func setupUI() {
        super.setupUI()
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = UIColor.systemBlue // Use system color as fallback
        
        // Logo setup
        logoImageView.image = UIImage(systemName: "person.3.fill")
        logoImageView.tintColor = .white
        logoImageView.contentMode = .scaleAspectFit
        
        // Title setup
        titleLabel.text = "DexianUser" // Hardcoded as fallback
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        
        // Subtitle setup
        subtitleLabel.text = "User Management System"
        subtitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        subtitleLabel.textAlignment = .center
        
        // Loading indicator setup
        loadingIndicator.color = .white
        loadingIndicator.startAnimating()
        
        view.addSubviews(logoImageView, titleLabel, subtitleLabel, loadingIndicator)
    }
    
    override func setupConstraints() {
        [logoImageView, titleLabel, subtitleLabel, loadingIndicator].forEach { $0.setupConstraints() }
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            logoImageView.widthAnchor.constraint(equalToConstant: 80),
            logoImageView.heightAnchor.constraint(equalToConstant: 80),
            
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            loadingIndicator.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - ViewModel Binding
    private func bindViewModel() {
        viewModel.onCompletion = { [weak self] in
            DispatchQueue.main.async {
                self?.navigateToUserList()
            }
        }
    }
    
    // MARK: - Navigation
    private func navigateToUserList() {
        guard !hasNavigated else {
            return
        }
        
        hasNavigated = true
        let userListVC = UserListViewController()
        let navController = UINavigationController(rootViewController: userListVC)
        navController.modalPresentationStyle = .fullScreen
        navController.navigationBar.prefersLargeTitles = true
        
        // Stop loading
        loadingIndicator.stopAnimating()

        // Replace rootViewController for full-screen effect
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? UIWindowSceneDelegate,
           let window = sceneDelegate.window as? UIWindow {
            window.rootViewController = navController
            window.makeKeyAndVisible()
        } else {
            // Fallback if window access fails
            present(navController, animated: true)
        }
    }

}
