//
//  BookViewController.swift
//  Dewey
//
//  Created by Jessica Huynh on 2020-04-26.
//  Copyright © 2020 Jessica Huynh. All rights reserved.
//

import UIKit

class BookViewController: UIViewController, BookshelfOptionsViewControllerDelegate {
    let storageManager = StorageManager.instance
    var book: Book!
    var bookDetailsViewController: BookDetailsViewController!
    var didEditBookshelves = false
    
    var cardHeight: CGFloat!
    let cardTopPadding: CGFloat = 20
    let cardStretchSection: CGFloat = 50
    let cardMinVisibleHeight: CGFloat = 300
    var cardVisible = false
    var panAnimationQueue: [UIViewPropertyAnimator] = []
    var nextState: CardState {
        return cardVisible ? .collapsed : .expanded
    }
    
    enum CardState {
        case expanded, collapsed
    }
    
    @IBOutlet weak var bookDetailsView: UIView!
    @IBOutlet weak var bookCover: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBookCover()
        setupCard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if didEditBookshelves {
            NotificationCenter.default.post(name: .updatedBookshelves, object: self)
        }
    }
    
    func setupBookCover() {
        let url = URL(string: book.cover)
        bookCover.kf.indicatorType = .activity
        bookCover.kf.setImage(
            with: url,
            placeholder: UIImage(named: "book-cover-placeholder"),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ])
    }
    
    @IBAction func backTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showActions(_ sender: Any) {
        let actions = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let addAction = UIAlertAction(title: "Add To Bookshelf", style: .default) {
            _ in
            self.presentBookshelfOptionsViewController()
        }
        actions.addAction(addAction)
        
        let deleteAction = UIAlertAction(title: "Delete Everywhere", style: .default) {
            _ in
            self.showDeleteConfirmation()
        }
        
        if storageManager.bookIsInAShelf(book: book) {
            actions.addAction(deleteAction)
        }
        
        actions.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actions, animated: true)
    }
    
    func showDeleteConfirmation() {
        let alert = UIAlertController(title: "Delete Everywhere",
                                      message: "Are you sure you want to remove this book from \(storageManager.numberOfBookshelves(with: book)) bookshelves.",
                                      preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Yes", style: .default) {
            _ in
            self.storageManager.removeBookEverywhere(book: self.book)
            self.didEditBookshelves = true
        }
        
        alert.addAction(deleteAction)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func presentBookshelfOptionsViewController() {
        let viewController = BookshelfOptionsViewController(nibName: "BookshelfOptionsViewController", bundle: nil)
        viewController.delegate = self
        present(viewController, animated: true, completion: nil)
    }
    
    // MARK: - Book Options Delegate
    func bookshelfOptionsViewController(_ controller: BookshelfOptionsViewController, didSelectBookshelfAt index: Int) {
        let bookshelf = StorageManager.instance.bookshelves[index]
        controller.dismiss(animated: true, completion: nil)
        storageManager.addBook(book: book.with(dateAddedToShelf: Date()), to: bookshelf)
        didEditBookshelves = true
    }
}
