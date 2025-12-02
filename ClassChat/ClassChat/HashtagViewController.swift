//
//  HashtagViewController.swift
//  ClassChat
//
//  Created by Angelina Lu on 12/1/25.
//

//screen for when user taps hashtag
import UIKit

class HashtagViewController: UIViewController {

    private let hashtag: String

    private let label = UILabel()

    init(hashtag: String) {
        self.hashtag = hashtag
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = hashtag
        view.backgroundColor = .systemBackground

        label.text = "Welcome to the \(hashtag) group!"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 0
        label.textAlignment = .center

        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 24),
            label.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -24)
        ])
    }
}

