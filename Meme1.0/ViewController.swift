//
//  ViewController.swift
//  Meme1.0
//
//  Created by Marlhex on 2020-04-10.
//  Copyright © 2020 Ignacio Arias. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
						UINavigationControllerDelegate, UITextFieldDelegate {

	@IBOutlet weak var img: UIImageView!

	@IBOutlet weak var topTexField: UITextField!
	@IBOutlet weak var bottomTextField: UITextField!
	@IBOutlet weak var cameraBtn: UIBarButtonItem!

	@IBOutlet weak var shareBtn: UIBarButtonItem!

	 private func share() {
		let memedImage = generateMemedImage()
		let activityView = UIActivityViewController(activityItems: [memedImage],
													applicationActivities: nil)
		activityView.completionWithItemsHandler = { [weak self] type, completed, items, error in
			if completed {
				self?.save(memedImage)
			}
			activityView.dismiss(animated: true, completion: nil)
		}
		present(activityView, animated: true, completion: nil)
	}


	fileprivate func setUpTextFieldAttributedStrings() {
		let memeTextAttributes: [NSAttributedString.Key: Any] = [
			NSAttributedString.Key.strokeColor: UIColor.black,
			NSAttributedString.Key.foregroundColor: UIColor.white,
			NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack",
												size: 40)!,
			NSAttributedString.Key.strokeWidth:  3
		]

		topTexField.defaultTextAttributes = memeTextAttributes
		bottomTextField.defaultTextAttributes = memeTextAttributes

		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.alignment = .center
		topTexField.attributedText = NSAttributedString(string: topTexField.placeholder!, attributes: [.paragraphStyle: paragraphStyle])

		bottomTextField.attributedText = NSAttributedString(string: bottomTextField.placeholder!, attributes: [.paragraphStyle: paragraphStyle])


		topTexField.textAlignment = .center
		bottomTextField.textAlignment = .center




	}

	override func viewDidLoad() {
		super.viewDidLoad()
		topTexField.delegate = self
		bottomTextField.delegate = self
	}

	@IBAction func handleShare(_ sender: Any) {
		share()
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		cameraBtn.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)


		subscribeToKeyboardNotifications()

		topTexField.isHidden = true
		bottomTextField.isHidden = true

		cancelBtn.isEnabled = false
		shareBtn?.isEnabled = false

		activateShare()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		setUpTextFieldAttributedStrings()
	}



	func activateShare() {
		if topTexField.text!.count > 0 || bottomTextField.text!.count > 0 {
			shareBtn?.isEnabled = true
			cancelBtn.isEnabled = true
		}
	}



	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		navigationItem.title = NSLocalizedString("navBarAddText", comment: "Adding text")
		return true
	}

	func textFieldDidBeginEditing(_ textField: UITextField) {
		textField.text = ""
	}

	func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
		if textField.text!.count > 0 {
			shareBtn?.isEnabled = true
			textField.textAlignment = .center
			navigationItem.title = NSLocalizedString("navBarShare", comment: "Sharing")
		}
		return true
	}


	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		unsubscribeFromKeyboardNotifications()
	}


	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}


	func imagePickerController(_ picker: UIImagePickerController,
							   didFinishPickingMediaWithInfo info:
								[UIImagePickerController.InfoKey : Any]) {

		//add the image to the imageView
		if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
			img.image = image
		}
		//Dismissing the selected image and closing the presenter
		dismiss(animated: true, completion: nil)
	}

	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		picker.dismiss(animated: true, completion: nil)
	}


	fileprivate func setUp() {
		cancelBtn.isEnabled = true
		topTexField.isHidden = false
		bottomTextField.isHidden = false
	}

	func pickFromSource(_ source: UIImagePickerController.SourceType) {
		let imagePickerController = UIImagePickerController()
		imagePickerController.delegate = self;
		imagePickerController.sourceType = source
		present(imagePickerController, animated: true, completion: nil)
		setUp()
	}


	@IBAction func addFromCamera(_ sender: Any) {
		pickFromSource(.camera)
	}

	@IBAction func addFromGallery(_ sender: Any) {
		pickFromSource(.photoLibrary)
	}

	@objc func keyboardWillShow(_ notification:Notification) {
		if bottomTextField.isFirstResponder {
			view.frame.origin.y = -getKeyboardHeight(notification)
		}
	}

	@objc func keyboardWillHide(_ notification: Notification) {
		view.frame.origin.y = 0
	}

	func getKeyboardHeight(_ notification:Notification) -> CGFloat {

		let userInfo = notification.userInfo
		let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
		return keyboardSize.cgRectValue.height
	}

	@IBAction func cancelResent(_ sender: Any) {
		img.image = nil
		topTexField.placeholder = NSLocalizedString("placeholder_Text",
													comment: "Text for placeholder")

		bottomTextField.placeholder = NSLocalizedString("placeholder_Text",
														comment: "Text for placeholder")
		topTexField.text = ""
		bottomTextField.text = ""
		navigationItem.title = NSLocalizedString("navBarAddImage", comment: "Adding an image")
		cancelBtn.isEnabled = false
		shareBtn?.isEnabled = false

		topTexField.isHidden = true
		bottomTextField.isHidden = true
	}



	func subscribeToKeyboardNotifications() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
											   name: UIResponder.keyboardWillHideNotification,
											   object: nil)

		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
											   name: UIResponder.keyboardWillShowNotification,
											   object: nil)
	}

	func unsubscribeFromKeyboardNotifications() {
		NotificationCenter.default.removeObserver(self,
												  name: UIResponder.keyboardWillHideNotification,
												  object: nil)

		NotificationCenter.default.removeObserver(self,
												  name: UIResponder.keyboardWillShowNotification,
												  object: nil)
	}

	func save(_ memedImage: UIImage) {
        _ = Meme(topText: topTexField.text!,
				 bottomText: bottomTextField.text!,
				 originalImage: img.image!,
				 memeImage: memedImage)
    }


	@IBOutlet weak var cancelBtn: UIBarButtonItem!
	@IBOutlet weak var toolbar: UIToolbar!

	func generateMemedImage() -> UIImage {

		// TODO: Hide toolbar and navbar
		navigationController?.isToolbarHidden = true
		toolbar.isHidden = true
		// Render view to an image
		UIGraphicsBeginImageContext(self.view.frame.size)
		view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
		let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()

		// TODO: Show toolbar and navbar
		navigationController?.isToolbarHidden = false
		toolbar.isHidden = false

		return memedImage
	}

}

