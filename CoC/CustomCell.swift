//
//  CustomCell.swift
//  CoC
//
//  Created by Robin Somlette on 21-Dec-2016.
//  Copyright © 2016 Samsao. All rights reserved.
//

import UIKit
import SnapKit


class CustomCell: UITableViewCell {

	private(set) var title = UILabel(frame: .zero)
	private(set) var members = UILabel(frame: .zero)
	private(set) var level = UILabel(frame: .zero)

	// MARK: - Lifecycle

	public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		initializeUI()
		createConstraints()
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		fatalError("init:coder was not implemented")
	}

	// MARK: - Initialization

	/**
	Initialize UI
	*/
	public func initializeUI() {
		contentView.addSubview(title)
		contentView.addSubview(members)
		contentView.addSubview(level)
		selectionStyle = .none
		backgroundColor = .lightGray
		level.textColor = .orange

	}

	/**
	Creating the constraints
	*/
	private func createConstraints() {
		level.snp.makeConstraints { (make) in
			make.centerY.equalToSuperview()
			make.right.equalToSuperview().offset(-5)
		}
		title.snp.makeConstraints { (make) in
			make.left.equalToSuperview().offset(5)
			make.centerY.equalToSuperview()
		}
		members.snp.makeConstraints { (make) in
			make.left.equalTo(title.snp.right).offset(5)
			make.centerY.equalToSuperview()
		}
	}

	// MARK: - Update UI

	/**
	Configuring the cell
	- parameter cellData:
	*/
	 func configureCell(cellData: Clan) {
		// OVERRIDE
		title.text = cellData.name
		members.text = "\(cellData.members) members"
		level.text = "\(cellData.clanLevel)"
	}

}
