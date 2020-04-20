//
//  MemeDetailVC.swift
//  Meme1.0
//
//  Created by Marlhex on 2020-04-20.
//  Copyright © 2020 Ignacio Arias. All rights reserved.
//

import UIKit

class MemeDetailVC: UIViewController {

	@IBOutlet weak var tpLbl: UILabel!
	@IBOutlet weak var bottomLbl: UILabel!

	@IBOutlet weak var img: UIImageView!

	var meme: Meme!

//	var memes: [Meme]! {
//		let object = UIApplication.shared.delegate
//		let appDelegate = object as! AppDelegate
//		return appDelegate.memes
//	}

//	var memes: [Meme]!

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
//		self.topLbl.text = self.memes
//		self.bottomLbl.text = self.villain.name

		self.tabBarController?.tabBar.isHidden = true
		img.image = meme.memeImage
		tpLbl.text = meme.topText
		bottomLbl.text = meme.bottomText

//		self.imageView!.image = UIImage(named: villain.imageName)
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.tabBarController?.tabBar.isHidden = false
	}
    


}
