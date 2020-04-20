//
//  MemeCollectionViewController.swift
//  Meme1.0
//
//  Created by Marlhex on 2020-04-15.
//  Copyright © 2020 Ignacio Arias. All rights reserved.
//

import UIKit

private let reuseIdentifier = "collectionCellID"

class MemeCollectionViewController: UICollectionViewController {

	var memes: [Meme]! {
		let object = UIApplication.shared.delegate
		let appDelegate = object as! AppDelegate
		return appDelegate.memes
	}

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false



        // Do any additional setup after loading the view.
		navigationItem.title = "Sent Memes"
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Meme", style: .plain, target: self, action: #selector(openMemeEditor))


		collectionView.delegate = self
		collectionView.dataSource = self
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		collectionView.reloadData()
	}




@objc func openMemeEditor() {
	let memeEditorController = storyboard?.instantiateViewController(identifier: "memeEditor") as! MemeEditorVC

	navigationController!.pushViewController(memeEditorController, animated: true)

}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
		return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MemeCollectionCell
    
        // Configure the cell
		let meme = memes[(indexPath as NSIndexPath).row]

		cell.topLbl?.text = meme.topText
		cell.bottomLbl?.text = meme.bottomText
		cell.img?.image = meme.memeImage
    
        return cell
    }





	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {

		let selectedMeme = memes[indexPath.row]

		let memeDetail = storyboard?.instantiateViewController(
			identifier: "MemeDetailViewController") as! MemeDetailVC

		memeDetail.meme = selectedMeme

		navigationController?.pushViewController(
			memeDetail, animated: true)

	}


    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
