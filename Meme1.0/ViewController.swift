//
//  ViewController.swift
//  Meme1.0
//
//  Created by Marlhex on 2020-04-10.
//  Copyright © 2020 Ignacio Arias. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

	@IBOutlet weak var img: UIImageView!

	@IBOutlet weak var tf1: UITextField!
	@IBOutlet weak var tf2: UITextField!
	@IBOutlet weak var cameraBtn: UIBarButtonItem!


	@objc func share() {
		let image = generateMemedImage()
		let activityView = UIActivityViewController(activityItems: [image], applicationActivities: nil)
		present(activityView, animated: true, completion: nil)
	}

	private var shareBtn: UIBarButtonItem? // This will be initialized in configureNavBar

	override func viewDidLoad() {
		super.viewDidLoad()

		shareBtn = UIBarButtonItem(image: UIImage(named: "share"), style: .plain, target: self, action: #selector(share))

		navigationItem.setLeftBarButtonItems([shareBtn!], animated: true)

		cameraBtn.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)

		tf1.delegate = self
		tf2.delegate = self

		let memeTextAttributes: [NSAttributedString.Key: Any] = [
			NSAttributedString.Key.strokeColor: UIColor.red,
			NSAttributedString.Key.foregroundColor: UIColor.orange,
			NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
			NSAttributedString.Key.strokeWidth:  3
		]

		tf1.defaultTextAttributes = memeTextAttributes
		tf2.defaultTextAttributes = memeTextAttributes

	}

	func activateShare() {
		if tf1.text!.count > 0 || tf2.text!.count > 0 {
		shareBtn?.isEnabled = true
			cancelBtn.isEnabled = true
		}
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		subscribeToKeyboardNotifications()
		cancelBtn.isEnabled = false
		tf1.isHidden = true
		tf2.isHidden = true
		shareBtn?.isEnabled = false
		activateShare()
	}

	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		navigationItem.title = "Add text :)"
		return true
	}

	func textFieldDidBeginEditing(_ textField: UITextField) {
			textField.text = ""
	}

	func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
		if textField.text!.count > 0 {
			shareBtn?.isEnabled = true
			navigationItem.title = "Share it :)"
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


	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

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
		tf1.isHidden = false
		tf2.isHidden = false
	}

	@IBAction func cam(_ sender: Any) {
		let cmpiker = UIImagePickerController()
		cmpiker.delegate = self
		cmpiker.sourceType = .camera
		present(cmpiker, animated: true, completion: nil)

		setUp()
	}
	@IBAction func add(_ sender: Any) {
		let imgPicker = UIImagePickerController()
		imgPicker.delegate = self
		imgPicker.sourceType = .photoLibrary
		present(imgPicker, animated: true, completion: nil)
		setUp()
	}

	@objc func keyboardWillShow(_ notification:Notification) {
		if tf2.isFirstResponder {
		   view.frame.origin.y = -getKeyboardHeight(notification)
		}
	}

	@objc func keyboardWillHide(_ notification: Notification) {
		view.frame.origin.y = 0
	}

	func getKeyboardHeight(_ notification:Notification) -> CGFloat {

		let userInfo = notification.userInfo
		let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
		print("KeyboardSize: \(keyboardSize.cgRectValue.height)")
		return keyboardSize.cgRectValue.height
	}
	@IBAction func cancelResent(_ sender: Any) {
		img.image = nil
		tf1.placeholder = "TOP"
		tf2.placeholder = "BOTTOM"
		tf1.text = ""
		tf2.text = ""
		navigationItem.title = "Please, add an image :)"
		cancelBtn.isEnabled = false
		shareBtn?.isEnabled = false
	}



	func subscribeToKeyboardNotifications() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
	}

	func unsubscribeFromKeyboardNotifications() {
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
	}



	func save() {
		let meme = Meme(topText: tf1.text!, bottomText: tf2.text!, originalImage: img.image!, memeImage: generateMemedImage())
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

