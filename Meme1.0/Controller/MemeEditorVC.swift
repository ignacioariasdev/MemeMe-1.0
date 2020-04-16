//
//  ViewController.swift
//  Meme1.0
//
//  Created by Marlhex on 2020-04-10.
//  Copyright © 2020 Ignacio Arias. All rights reserved.
//

import UIKit

class MemeEditorVC: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {

	@IBOutlet weak var img: UIImageView!
	@IBOutlet weak var topTexField: UITextField!
	@IBOutlet weak var bottomTextField: UITextField!
	@IBOutlet weak var cameraBtn: UIBarButtonItem!
	@IBOutlet weak var cancelBtn: UIBarButtonItem!
	@IBOutlet weak var toolbar: UIToolbar!
	@IBOutlet weak var shareBtn: UIBarButtonItem!


	func save(_ memedImage: UIImage) {
		let meme = Meme(topText: topTexField.text!,
				 bottomText: bottomTextField.text!,
				 originalImage: img.image!,
				 memeImage: memedImage)

		// Add it to the memes array on the app delegate
		(UIApplication.shared.delegate as! AppDelegate).memes.append(meme)

	}


	func generateMemedImage() -> UIImage {

		// TODO: Hide toolbar and navbar
		navigationController?.isToolbarHidden = true
		toolbar.isHidden = true
		if bottomTextField.text!.isEmpty {
			bottomTextField.isHidden = true
		}
		// Render view to an image
		UIGraphicsBeginImageContext(self.view.frame.size)
		view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
		let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()

		// TODO: Show toolbar and navbar
		navigationController?.isToolbarHidden = false
		toolbar.isHidden = false
		bottomTextField.isHidden = false

		return memedImage
	}



	fileprivate func setUp() {
		cancelBtn.isEnabled = true
		topTexField.isHidden = false
		bottomTextField.isHidden = false
	}


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

	func activateShare() {
		if topTexField.text!.count > 0 || bottomTextField.text!.count > 0 {
			shareBtn?.isEnabled = true
			cancelBtn.isEnabled = true
		}
	}


		func configureTextField(_ textField: UITextField, text: String) {
			textField.text = text
			textField.delegate = self
			textField.textAlignment = .center

			textField.defaultTextAttributes = [
				.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
				.foregroundColor: UIColor.white,
				.strokeColor: UIColor.black,
				.strokeWidth: -3.5
			]

			//Alignment of the placeholder
			let paragraphStyle = NSMutableParagraphStyle()
			paragraphStyle.alignment = .center
			topTexField.attributedText = NSAttributedString(string: topTexField.placeholder!, attributes: [.paragraphStyle: paragraphStyle])
			bottomTextField.attributedText = NSAttributedString(string: bottomTextField.placeholder!, attributes: [.paragraphStyle: paragraphStyle])

		}

	// MARK: - View Controller Life Cycle

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
		configureTextField(topTexField, text: topTexField.text!)
		configureTextField(bottomTextField, text: bottomTextField.text!)
	}

	override func viewWillDisappear(_ animated: Bool) {
		unsubscribeFromKeyboardNotifications()
		super.viewWillDisappear(animated)
	}

	// MARK: - Delegates


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

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}


	// MARK: - PickerController

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

	func pickFromSource(_ source: UIImagePickerController.SourceType) {
		let imagePickerController = UIImagePickerController()
		imagePickerController.delegate = self;
		imagePickerController.sourceType = source
		present(imagePickerController, animated: true, completion: nil)
		setUp()
	}

	// MARK: - IBActions

	@IBAction func handleShare(_ sender: Any) {
		share()
	}

	@IBAction func addFromCamera(_ sender: Any) {
		pickFromSource(.camera)
	}

	@IBAction func addFromGallery(_ sender: Any) {
		pickFromSource(.photoLibrary)
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


	// MARK: - Handlers

	@objc func keyboardWillShow(_ notification:Notification) {
		if bottomTextField.isFirstResponder {
			view.frame.origin.y = -getKeyboardHeight(notification)
		}
	}

	@objc func keyboardWillHide(_ notification: Notification) {
		view.frame.origin.y = 0
	}





	// MARK: - Notifications
	func getKeyboardHeight(_ notification:Notification) -> CGFloat {

		let userInfo = notification.userInfo
		let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
		return keyboardSize.cgRectValue.height
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

}

