//
//  BaseViewController.swift
//  dexianUser
//
//  Created by sheik hanifa on 26/06/25.
//

import UIKit

class BaseViewController: UIViewController {
    // MARK: - Properties
    private let loadingView = LoadingView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    // MARK: - Setup Methods
    func setupUI() {
        view.backgroundColor = AppConstants.Colors.background
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupConstraints() {
        // Override in subclasses
    }
    
    // MARK: - Loading Methods
    func showLoading() {
        view.addSubview(loadingView)
        loadingView.setupConstraints()
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        loadingView.show()
    }
    
    func hideLoading() {
        loadingView.hide()
    }
}
