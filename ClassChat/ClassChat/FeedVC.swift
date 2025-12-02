//
//  FeedVC.swift
//  ClassChat
//
//  Created by Angelina Lu on 12/1/25.
//

//main home screen of UICollectionView with 2 sections: Create post and Post collection
import UIKit

// MARK: - Protocol

protocol PostCellDelegate: AnyObject {
    func postCellDidToggleLike(_ cell: PostCollectionViewCell)
    func postCell(_ cell: PostCollectionViewCell, didTapHashtag hashtag: String)
}

class FeedVC: UIViewController {

    // MARK: - Properties (view)

    private var collectionView: UICollectionView!

    // MARK: - Properties (data)
    
    //hardcoded
    private var posts: [Post] = [
        Post(id: 1,
             author: "Anonymous",
             message: "Anyone want to study for the prelim together?",
             hashtag: "#cs2110",
             likeCount: 3,
             isLikedByMe: false),
        Post(id: 2,
             author: "Anonymous",
             message: "Reminder: Pset 5 is due tn!!!",
             hashtag: "#math2210",
             likeCount: 5,
             isLikedByMe: true),
        Post(id: 3,
             author: "Anonymous",
             message: "Does anyone understand the discussion demos",
             hashtag: "#cs1110",
             likeCount: 2,
             isLikedByMe: false)
    ]

    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "ClassChat"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemGroupedBackground

        setupCollectionView()
    }

    // MARK: - Set Up Collection View

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(CreatePostCollectionViewCell.self,
                                forCellWithReuseIdentifier: CreatePostCollectionViewCell.reuse)
        collectionView.register(PostCollectionViewCell.self,
                                forCellWithReuseIdentifier: PostCollectionViewCell.reuse)

        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource

extension FeedVC: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if section == 0 { return 1 }
        return posts.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CreatePostCollectionViewCell.reuse,
                for: indexPath
            ) as! CreatePostCollectionViewCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostCollectionViewCell.reuse,
                for: indexPath
            ) as! PostCollectionViewCell

            let post = posts[indexPath.item]
            cell.configure(with: post)
            cell.delegate = self
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FeedVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 24
        let width = collectionView.bounds.width - 2 * padding

        if indexPath.section == 0 {
            return CGSize(width: width, height: 132)
        } else {
            return CGSize(width: width, height: 180)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let padding: CGFloat = 24

        if section == 0 {
            return UIEdgeInsets(top: 16, left: padding, bottom: 24, right: padding)
        } else {
            return UIEdgeInsets(top: 0, left: padding, bottom: 16, right: padding)
        }
    }
}

// MARK: - PostCellDelegate

extension FeedVC: PostCellDelegate {

    func postCellDidToggleLike(_ cell: PostCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell),
              indexPath.section == 1 else { return }

        posts[indexPath.item].isLikedByMe.toggle()

        if posts[indexPath.item].isLikedByMe {
            posts[indexPath.item].likeCount += 1
        } else {
            posts[indexPath.item].likeCount = max(0, posts[indexPath.item].likeCount - 1)
        }

        collectionView.reloadItems(at: [indexPath])
    }

    func postCell(_ cell: PostCollectionViewCell, didTapHashtag hashtag: String) {
        let vc = HashtagViewController(hashtag: hashtag)
        navigationController?.pushViewController(vc, animated: true)
    }
}
