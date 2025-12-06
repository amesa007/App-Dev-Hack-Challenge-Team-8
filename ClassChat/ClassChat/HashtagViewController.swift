//
//  HashtagViewController.swift
//  ClassChat
//
//  Created by Angelina Lu on 12/1/25.
//

import UIKit

class HashtagViewController: UIViewController {

    private let hashtag: String
    private var posts: [Post] = []

    private let tableView = UITableView()
    private let headerLabel = UILabel()

    init(hashtag: String) {
        self.hashtag = hashtag
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = hashtag

        setupTableView()
        setupHeader()
        loadPosts()
    }

    // MARK: - Setup

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupHeader() {
        headerLabel.text = "Welcome to the \(hashtag) group!"
        headerLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        headerLabel.numberOfLines = 0
        headerLabel.textAlignment = .center
        headerLabel.translatesAutoresizingMaskIntoConstraints = false

        let headerContainer = UIView()
        headerContainer.addSubview(headerLabel)

        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: headerContainer.topAnchor, constant: 24),
            headerLabel.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 24),
            headerLabel.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -24),
            headerLabel.bottomAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: -24)
        ])

        headerContainer.layoutIfNeeded()
        headerContainer.frame.size.height = headerLabel.frame.height + 48

        tableView.tableHeaderView = headerContainer
    }

    // MARK: - Networking

    private func loadPosts() {
        NetworkManager.shared.fetchPosts(forTag: hashtag) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let apiPosts):
                self.posts = apiPosts.map { Post(from: $0) }
                self.tableView.reloadData()
            case .failure(let error):
                print("Failed to load posts for tag \(self.hashtag):", error)
            }
        }
    }
}

// MARK: - UITableViewDataSource & Delegate

extension HashtagViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "HashtagPostCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID)
            ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellID)

        let post = posts[indexPath.row]
        cell.textLabel?.text = post.message
        cell.detailTextLabel?.text = post.author
        cell.selectionStyle = .none

        return cell
    }
}

