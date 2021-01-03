//
//  commentVC.swift
//  ROCA-UVA
//
//  Created by Anusha Choudhary on 12/20/20.
//
import UIKit

protocol CommentEnteredDelegate: AnyObject {
    func userDidEnterComment(comment: String)
}


class commentVC: UIViewController {
    
    @IBOutlet weak var commentTextView: UITextView!
    weak var delegate: CommentEnteredDelegate? = nil

    var comments: String = "";
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        comments = commentTextView.text;
        delegate?.userDidEnterComment(comment: comments)
        self.dismiss(animated: true, completion: nil)
    }
}
