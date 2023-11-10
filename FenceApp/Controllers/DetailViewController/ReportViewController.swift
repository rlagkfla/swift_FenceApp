//
//  ReportViewController.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 11/8/23.
//

import UIKit
import MessageUI

class ReportViewController: UIViewController {
    
    let lost: Lost
    
    let reportingLabel: UILabel = {
        let label = UILabel()
        label.text = "신고하는 이유를 선택하세요."
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .left
        return label
    }()
    
    lazy var reportTalbeView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    init(lost: Lost) {
        self.lost = lost
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

extension ReportViewController {
    func configureUI() {
        self.title = "신고하기"
        view.backgroundColor = .white
        
        configureReportingLabel()
        configureReportTableView()
    }
    
    func configureReportingLabel() {
        view.addSubview(reportingLabel)
        
        reportingLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(60)
        }
    }
    
    func configureReportTableView() {
        view.addSubview(reportTalbeView)
        
        reportTalbeView.snp.makeConstraints {
            $0.top.equalTo(reportingLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(300)
        }
    }
}

extension ReportViewController {
    func sendReportEmail(indexPath: IndexPath) {
        if MFMailComposeViewController.canSendMail() {
            let compseVC = MFMailComposeViewController()
            compseVC.mailComposeDelegate = self
            compseVC.setToRecipients(["gaemee.88@gmail.com"])
            compseVC.setSubject(ReportType.allCases[indexPath.row].rawValue)
            compseVC.setMessageBody("게시글 식별코드: \(lost.lostIdentifier)", isHTML: false)
            
            self.present(compseVC, animated: true)
        } else {
            print("실패")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

extension ReportViewController: UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ReportType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(ReportType.allCases[indexPath.row].rawValue)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "신고하시겠습니까?", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let confirmAction = UIAlertAction(title: "신고하기", style: .default) { [weak self] _ in
            self?.sendReportEmail(indexPath: indexPath)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        present(alertController, animated: true)
    }
}
