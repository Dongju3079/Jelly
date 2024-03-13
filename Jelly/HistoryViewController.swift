//
//  ViewController.swift
//  Jelly
//
//  Created by CatSlave on 3/13/24.
//

import UIKit

class HistoryViewController: UIViewController {
    
    let dummySection = ["짱아", "나비"]
    
    let dummyData = [ResultSection(name: "짱아", 
                                   row: [ResultModel(), ResultModel(), ResultModel()]),
                     ResultSection(name: "나비",
                                   row: [ResultModel(), ResultModel()])
    ]
    
    @IBOutlet weak var historyTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        historyTableView.dataSource = self
        historyTableView.delegate = self
        self.title = "History View"
        
        historyTableView.sectionHeaderTopPadding = 0
    }


}

extension HistoryViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dummyData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyData[section].row.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.name, for: indexPath) as? HistoryTableViewCell else {
            return UITableViewCell()
        }
        
        let currentSection = indexPath.section
        
        let dataDate = dummyData[currentSection].row[indexPath.row]
        
        cell.dateLabel.text = dataDate.date.description
        
        return cell
    }
}

extension HistoryViewController: UITableViewDelegate {
    
    // Header 추가시 상단의 여백이 생겼는데 tableview의 style = grouped로 해결
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 40
    }
    
    // 0은 적용되지 않음, 최소의 값을 적용하는 것으로 해결
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.backgroundColor = .systemBackground
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = dummyData[section].name
        
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    

}
