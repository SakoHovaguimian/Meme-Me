//
//  CreateViewController.swift
//  MemeMe
//
//  Created by Sako Hovaguimian on 3/15/18.
//  Copyright © 2018 Sako Hovaguimian. All rights reserved.
//

import UIKit

class CreateViewController: UIViewController {

    @IBOutlet weak var contentContainerView: UIView!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var topContentTextField: UITextField!
    @IBOutlet weak var bottomContentTextField: UITextField!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var photoLibraryButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    private let textAttributes: [NSAttributedStringKey: Any] = [
        .strokeColor: UIColor.black,
        .foregroundColor: UIColor.white,
        .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        .strokeWidth: -3.0
    ]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        update(textField: topContentTextField, withText: "Top".uppercased())
        update(textField: bottomContentTextField, withText: "Bottom".uppercased())
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: .UIKeyboardWillShow,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: .UIKeyboardWillHide,
                                               object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        
        if bottomContentTextField.isFirstResponder {
            
            guard let info = notification.userInfo else { return }
            let size = info[UIKeyboardFrameEndUserInfoKey] as! NSValue
            view.frame.origin.y = (size.cgRectValue.height * -0.8)
            
            
        }
        
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    @IBAction private func didTapCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
        shareButton.isEnabled = false
        /* contentImageView.image = nil
        
        update(textField: topContentTextField, withText: "Top".uppercased())
        update(textField: bottomContentTextField, withText: "Bottom".uppercased())
        
        topContentTextField.resignFirstResponder()
        bottomContentTextField.resignFirstResponder()
        
        UIView.animate(withDuration: 0.3) {
            self.topContentTextField.transform = .identity
            self.bottomContentTextField.transform = .identity
        }
 
        */
    }
    
    @IBAction private func didTapShare(_ sender: UIBarButtonItem) {
        
        guard let originalImage = contentImageView.image,
            let memeImage = generateMemedImage() else { return }
        
        let controller = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        controller.completionWithItemsHandler = { (activity, completed, items, error) in
            
            if completed {
                self.saveMemeImage(memeImage, originalImage: originalImage)
                self.dismiss(animated: true, completion: nil)
            }
            
        }
        
        self.present(controller, animated: true, completion: nil)
        
    }
    
    @IBAction private func didTapCamera(_ sender: UIBarButtonItem) {
        
        sourceType(sourceType: .camera)
        
    }
    
    @IBAction private func didTapPhotoLibrary(_ sender: UIBarButtonItem) {
        
        sourceType(sourceType: .photoLibrary)
        
    }
    
    private func update(textField: UITextField, withText text: String) {
        
        textField.textAlignment = .center
        textField.attributedText = NSAttributedString(string: text, attributes: textAttributes)
        shareButton.isEnabled = false
        
        topContentTextField.delegate = self
        topContentTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        bottomContentTextField.delegate = self
        bottomContentTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        let topPan = UIPanGestureRecognizer(target: self, action: #selector(didPanTextField(_:)))
        topContentTextField.addGestureRecognizer(topPan)
        
        let bottomPan = UIPanGestureRecognizer(target: self, action: #selector(didPanTextField(_:)))
        bottomContentTextField.addGestureRecognizer(bottomPan)

    }
    
    private func saveMemeImage(_ image: UIImage, originalImage: UIImage) {
        
        let meme = Meme(topText: topContentTextField.text,
                        bottomText: bottomContentTextField.text,
                        originalImage: originalImage,
                        memeImage: image)
        
        MemeDataManager.shared.add(meme: meme)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func generateMemedImage() -> UIImage? {
        
        UIGraphicsBeginImageContext(contentContainerView.bounds.size)
        contentContainerView.drawHierarchy(in: contentContainerView.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
        
    }
    
}

extension CreateViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        update(textField: textField, withText: "")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }
    
    @objc private func textFieldDidChange(_ sender: UITextField) {
        update(textField: sender, withText: sender.text ?? "")
    }
    
    @objc private func didPanTextField(_ recognizer: UIPanGestureRecognizer) {
        
        guard let textField = recognizer.view as? UITextField, !textField.isEditing else { return }
        
        switch recognizer.state {
        case .began: break
        case .changed:
            
            let translation = recognizer.translation(in: textField.superview!)
            let transform = CGAffineTransform(translationX: translation.x, y: translation.y)
            textField.transform = transform
            
        case .cancelled: fallthrough
        case.ended: break
        default: break
        }
        
    }
    
}

extension CreateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            contentImageView.image = image
            shareButton.isEnabled = true
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func sourceType (sourceType: UIImagePickerControllerSourceType){
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    
    }
}
