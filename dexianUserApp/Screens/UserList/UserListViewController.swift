//
//  UserListViewController.swift
//  dexianUser
//
//  Created by sheik hanifa on 26/06/25.
//


import UIKit

class UserListViewController: BaseViewController, CreateUserDelegate {
    
    // MARK: - UI Components
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = AppConstants.Colors.background
        table.separatorStyle = .singleLine
        table.separatorColor = AppConstants.Colors.separatorColor
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 80
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let refreshControl = UIRefreshControl()
    
    private let emptyStateView: UIView = {
        let view = UIView()
        view.backgroundColor = AppConstants.Colors.background
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.slash")
        imageView.tintColor = AppConstants.Colors.primary.withAlphaComponent(0.5)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = StringConstants.noUsers
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = AppConstants.Colors.primary.withAlphaComponent(0.7)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Properties
    
    private var viewModel: UserListViewModel?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = UserListViewModel(view: self)
        setupUI()
        setupConstraints()
        setupTableView()
        viewModel?.loadUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - Setup
    
    override func setupUI() {
        super.setupUI()
        title = StringConstants.users
        setupNavigationBar()
        setupAddButton()
        view.addSubviews(tableView, emptyStateView)
        setupEmptyState()
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyStateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyImageView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyImageView.centerYAnchor.constraint(equalTo: emptyStateView.centerYAnchor, constant: -50),
            emptyImageView.widthAnchor.constraint(equalToConstant: 80),
            emptyImageView.heightAnchor.constraint(equalToConstant: 80),
            
            emptyLabel.topAnchor.constraint(equalTo: emptyImageView.bottomAnchor, constant: 20),
            emptyLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor, constant: 20),
            emptyLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.identifier)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func setupEmptyState() {
        emptyStateView.addSubviews(emptyImageView, emptyLabel)
    }
    
    private func setupAddButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addUserTapped)
        )
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = AppConstants.Colors.primary
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    // MARK: - Actions
    
    @objc private func refreshData() {
        viewModel?.refreshUsers()
    }
    
    @objc private func addUserTapped() {
        let createUserVC = CreateUserViewController()
        createUserVC.delegate = self
        let navController = UINavigationController(rootViewController: createUserVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    
    private func showEmptyState(_ show: Bool) {
        emptyStateView.isHidden = !show
        tableView.isHidden = show
    }
    
    private func showConfirmationAlert(title: String, message: String, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: StringConstants.cancel, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: StringConstants.delete, style: .destructive, handler: { _ in
            completion()
        }))
        present(alert, animated: true)
    }
    
    // MARK: - CreateUserDelegate
    
    func didSaveUser(_ user: User) {
        Logger.log("Saved user: \(user.name), ID: \(String(describing: user.id))")
        viewModel?.didSaveUser(user)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension UserListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel?.users.count ?? 0
        showEmptyState(count == 0)
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as? UserTableViewCell else {
            fatalError("Failed to dequeue UserTableViewCell")
        }
        
        if let user = viewModel?.users[safe: indexPath.row] {
            cell.configure(with: user)
            
            if indexPath.row == (viewModel?.users.count ?? 0) - 5 {
                viewModel?.loadMoreUsers()
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let user = viewModel?.users[safe: indexPath.row] else { return }
        
        Logger.log("Selected user: \(user.name), ID: \(String(describing: user.id))")
        guard user.id != nil else {
            showError("Invalid user ID for editing")
            return
        }
        
        let createUserVC = CreateUserViewController()
        createUserVC.user = user
        createUserVC.delegate = self
        let navController = UINavigationController(rootViewController: createUserVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    
}

// MARK: - ViewModel Delegate

extension UserListViewController: UserListViewDelegate {
    func showError(_ message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: StringConstants.error, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: StringConstants.ok, style: .default))
            self.present(alert, animated: true)
        }
    }
    
    func showSuccess(_ message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: StringConstants.success, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: StringConstants.ok, style: .default))
            self.present(alert, animated: true)
        }
    }
    
    func didLoadUsers() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    func didDeleteUser(at indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.showEmptyState(self.viewModel?.users.isEmpty ?? true)
        }
    }
    
    func didFailToLoadUsers(error: NetworkError) {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.showError(error.localizedDescription)
        }
    }
}

// MARK: - Safe Array Access

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
