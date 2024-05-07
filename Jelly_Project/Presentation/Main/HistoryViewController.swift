//
//  ViewController.swift
//  Jelly
//
//  Created by CatSlave on 3/13/24.
////

import UIKit
import SwipeCellKit
import SwiftEntryKit



class HistoryViewController: UIViewController {
    
    // MARK: - Variables
    private let dataManager = DataManager.shared
    
    private var snapShot = NSDiffableDataSourceSnapshot<ObjectInformation, DetailInformation>()
    private var dataSource: UITableViewDiffableDataSource<ObjectInformation, DetailInformation>? = nil
    
    // MARK: - UI components
    
    @IBOutlet weak var maskingView: UIView!
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configurationTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataManager.readData()
        self.setupData()
        self.setupEmptyView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showWelcomeAlert()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        enterButton.layer.cornerRadius = enterButton.frame.width / 2
    }
    
    deinit {
        print("👾 테스트 : \(self)뷰가 해제되고 있습니다. 👾")
    }
    
    // MARK: - UI Setup
    
    fileprivate func setupUI() {
        self.title = "저장 리스트"
        setupLayer()
    }
    
    fileprivate func setupLayer() {
        containerView.layer.masksToBounds = true
        historyTableView.layer.masksToBounds = false
        maskingView.addMasking()
    }
    
    fileprivate func setupEmptyView() {
                
        do {
            try dataManager.checkDetailDataEmpty()
            emptyLabel.isHidden = false
        } catch {
            emptyLabel.isHidden = true
        }
    }
    
    @IBAction func enterButtonTapped(_ sender: UIButton) {        
        if let navigation = self.navigationController as? CustomNavigation {
            navigation.pushToViewController(destinationVCCase: .name)
        }
    }
}

// MARK: - 첫 진입 얼럿창
extension HistoryViewController {
    fileprivate func showWelcomeAlert() {
        let enterCheck = BasicUserDefaults.shard.enteredCheck()
        if !enterCheck {
            CustomPopup.shared.showCustomPopup(type: .welcome)
        }
    }
}


// MARK: - 테이블뷰 설정

extension HistoryViewController {
    
    fileprivate func configurationTableView() {
        historyTableView.delegate = self
        historyTableView.showsVerticalScrollIndicator = false
        historyTableView.register(HistoryTableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: HistoryTableViewHeaderView.name)
        historyTableView.sectionHeaderHeight = 0
        historyTableView.sectionFooterHeight = 0
        configurationTableViewDataSource()
    }
    
    fileprivate func configurationTableViewDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: historyTableView, cellProvider: { [weak self] tableView, indexPath, itemIdentifier in
            
            guard let self = self,
                  let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.name, for: indexPath) as? HistoryTableViewCell else {
                return UITableViewCell()
            }

            let currentSection = dataManager.objects[indexPath.section]
            let currentData = currentSection.data[indexPath.row]
                    
            cell.delegate = self
            cell.detailModel = currentData
 
            return cell
        })
    }
    
    fileprivate func setupData() {
        self.snapShot = NSDiffableDataSourceSnapshot<ObjectInformation, DetailInformation>()
        
        self.snapShot.appendSections(dataManager.objects)

        dataManager.objects.forEach {
            self.snapShot.appendItems($0.data, toSection: $0)
        }
                
        self.dataSource?.apply(snapShot, animatingDifferences: false)
    }
}

extension HistoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let navigation = self.navigationController as? CustomNavigation else { return }
    
        dataManager.setCurrentData(index: indexPath)
        navigation.pushToViewController(destinationVCCase: .result)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return dataManager.checkDetailCountToObject(section) ? UITableView.automaticDimension : 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return dataManager.checkDetailCountToObject(section) ? UITableView.automaticDimension : 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard !dataManager.checkDetailCountToObject(section) else { return nil }
        
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HistoryTableViewHeaderView.name) as? HistoryTableViewHeaderView else { return nil }
        header.setTitle(dataManager.objects[section].title)
            
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


// MARK: - 스와이프 설정

extension HistoryViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeCellKit.SwipeActionsOrientation) -> [SwipeCellKit.SwipeAction]? {
        
        if orientation == .right {
            let complete = SwipeAction(style: .default, title: nil) { [weak self] action, indexPath in
                
                guard let self = self else { return }
                self.deleteIItem(indexPath: indexPath)
            }
            
            complete.backgroundColor = UIColorSet.background(.transparent, 0.0)
            complete.textColor = UIColorSet.text(.black)

            complete.image = SymbolSet.getSymbolImage(name: .trash, size: .large)
                    
            return [complete]
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.backgroundColor = UIColorSet.background(.transparent, 0.0)
        options.expansionStyle = .selection
        options.transitionStyle = .drag
        return options
    }
}

// MARK: - Helper
extension HistoryViewController {

    fileprivate func deleteIItem(indexPath: IndexPath) {
        snapShot.deleteItems([dataManager.removeDataToDB(indexPath)])
        
        self.dataSource?.apply(self.snapShot, animatingDifferences: true, completion: { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.historyTableView.reloadData()
                self.setupEmptyView()
            }
        })
    }
}

extension HistoryViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        maskingView.isHidden = scrollView.contentOffset.y <= 0
    }
}



