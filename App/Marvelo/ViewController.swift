//
//  ViewController.swift
//  Marvelo
//
//  Created by Dan Carlson on 2022-12-13.
//

import UIKit
import Secrets

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		let label = UILabel(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
		label.text = Secrets.abbyKey
		self.view.addSubview(label)
		
		self.view.backgroundColor = .red
	}


}

