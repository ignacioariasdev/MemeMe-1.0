//
//  MemeTableViewController.swift
//  Meme1.0
//
//  Created by Marlhex on 2020-04-15.
//  Copyright © 2020 Ignacio Arias. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {

	private let tableCellID = "tableCellID"

	var memes: [Meme]! {
		let object = UIApplication.shared.delegate
		let appDelegate = object as! AppDelegate
		return appDelegate.memes
	}

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem

//		tableView.register(MemeTableCell.self, forCellReuseIdentifier: tableCellID)

		tableView.delegate = self
		tableView.dataSource = self

		navigationItem.title = "Sent Memes"
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Meme", style: .plain, target: self, action: #selector(openMemeEditor))
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		tableView.reloadData()
	}



	@objc func openMemeEditor() {
		let memeEditorController = storyboard?.instantiateViewController(identifier: "memeEditor") as! MemeEditorVC

		navigationController!.pushViewController(memeEditorController, animated: true)

	}

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
		return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		return memes.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellID, for: indexPath) as! MemeTableCell

		let meme = self.memes[(indexPath as NSIndexPath).row]
		
		cell.topLbl?.text = meme.topText
		cell.bottomLbl?.text = meme.bottomText
		cell.img?.image = meme.memeImage

        return cell
    }



	override func tableView(_ tableView: UITableView,
				   didSelectRowAt indexPath: IndexPath) {
		let selectedMeme = memes[indexPath.row]

		let memeDetail = storyboard?.instantiateViewController(
			identifier: "MemeDetailViewController") as! MemeDetailVC

		memeDetail.meme = selectedMeme

		navigationController?.pushViewController(
			memeDetail, animated: true)
	}

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
