//
//  PostCollectionViewCell.swift
//  ClassChat
//
//  Created by Angelina Lu on 12/1/25.
//

//single post cell
import UIKit

class PostCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties (view)

    private let nameLabel = UILabel()
    private let messageLabel = UILabel()
    private let hashtagButton = UIButton(type: .system)
    private let likeButton = UIButton(type: .system)
    private let likesLabel = UILabel()

    // MARK: - Properties (data)

    static let reuse: String = "PostCollectionViewCellReuse"

    weak var delegate: PostCellDelegate?
    private var post: Post?

    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white
        layer.cornerRadius = 16

        setupNameLabel()
        setupMessageLabel()
        setupHashtagButton()
        setupLikeButton()
        setupLikesLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configure

    func configure(with post: Post) {
        self.post = post

        nameLabel.text = post.author
        messageLabel.text = post.message
        hashtagButton.setTitle(post.hashtag, for: .normal)
        likesLabel.text = "\(post.likeCount) likes"

        let heartName = post.isLikedByMe ? "heart.fill" : "heart"
        likeButton.setImage(UIImage(systemName: heartName), for: .normal)
        likeButton.tintColor = post.isLikedByMe ? .systemRed : .systemGray2
    }

    // MARK: - Setup Views

    private func setupNameLabel() {
        nameLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        nameLabel.textColor = .label

        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24)
        ])
    }

    private func setupMessageLabel() {
        messageLabel.font = .systemFont(ofSize: 14, weight: .regular)
        messageLabel.textColor = .label
        messageLabel.numberOfLines = 3

        contentView.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24)
        ])
    }

    private func setupHashtagButton() {
        hashtagButton.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        hashtagButton.setTitleColor(.systemBlue, for: .normal)
        hashtagButton.addTarget(self, action: #selector(didTapHashtag), for: .touchUpInside)

        contentView.addSubview(hashtagButton)
        hashtagButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            hashtagButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 8),
            hashtagButton.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor)
        ])
    }

    private func setupLikeButton() {
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.tintColor = .systemGray2
        likeButton.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)

        contentView.addSubview(likeButton)
        likeButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: hashtagButton.bottomAnchor, constant: 8),
            likeButton.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 24),
            likeButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    private func setupLikesLabel() {
        likesLabel.font = .systemFont(ofSize: 12, weight: .medium)
        likesLabel.textColor = .label

        contentView.addSubview(likesLabel)
        likesLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            likesLabel.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            likesLabel.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 8),
            likesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            likesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

    // MARK: - Actions

    @objc private func didTapLike() {
        delegate?.postCellDidToggleLike(self)
    }

    @objc private func didTapHashtag() {
        guard let hashtag = post?.hashtag else { return }
        delegate?.postCell(self, didTapHashtag: hashtag)
    }
}
