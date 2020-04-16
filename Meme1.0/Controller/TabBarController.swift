//
//  TabBarController.swift
//  Meme1.0
//
//  Created by Marlhex on 2020-04-16.
//  Copyright © 2020 Ignacio Arias. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
	override func viewDidLoad() {
		super.viewDidLoad()

		navigationItem.title = "Ignacio"
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Add Meme", style: .plain, target: self, action: #selector(openMemeEditor))
	}

	@objc func openMemeEditor() {
		let memeEditorController = storyboard?.instantiateViewController(identifier: "memeEditor") as! MemeEditorVC

		navigationController!.pushViewController(memeEditorController, animated: true)

	}
}
