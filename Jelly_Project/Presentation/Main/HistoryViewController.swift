//
//  ViewController.swift
//  Jelly
//
//  Created by CatSlave on 3/13/24.
////

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import ReactorKit
import SwipeCellKit
import GoogleMobileAds

class HistoryViewController: UIViewController, StoryboardView {
    typealias Reactor = PetInfoReactor
    
    // MARK: - adMob
    var bannerView: GADBannerView!
    
    // MARK: - Variables
    private var deleteStatus: PublishSubject<IndexPath> = .init()
    var disposeBag = DisposeBag()
    
    // MARK: - Rx DataSource
    var dataSource: RxTableViewSectionedAnimatedDataSource<PetInfo>?
    
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
        setReactor()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        self.title = "저장 리스트"
        setupLayer()
    }
    
    private func configurationTableView() {
        historyTableView.showsVerticalScrollIndicator = false
        historyTableView.register(HistoryTableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: HistoryTableViewHeaderView.name)
        historyTableView.sectionHeaderHeight = 0
        historyTableView.sectionFooterHeight = 0
    }
    
    private func setupLayer() {
        containerView.layer.masksToBounds = true
        historyTableView.layer.masksToBounds = false
        maskingView.addMasking()
    }
    
    @IBAction func enterButtonTapped(_ sender: UIButton) {
        if let navigation = self.navigationController as? CustomNavigation {
            navigation.pushToViewController(destinationVCCase: .name)
        }
    }
}

// TableView Setup
extension HistoryViewController {
    private func setReactor() {
        self.reactor = PetInfoReactor()
    }
    
    private func setDataSource() {

        let dataSource = RxTableViewSectionedAnimatedDataSource<PetInfo>(
            configureCell: { ds, tv, _, item in

                guard let cell = tv.dequeueReusableCell(withIdentifier: HistoryTableViewCell.name) as? HistoryTableViewCell else {
                    return UITableViewCell()
                }
                cell.delegate = self
                cell.status = item
                
                return cell
            }
        )

        self.dataSource = dataSource
        
        historyTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    func bind(reactor: PetInfoReactor) {
        setDataSource()
        guard let dataSource = dataSource else { return }
        
        
        // Input
        self.rx.viewWillAppear
            .map { _ in PetInfoReactor.Action.fetchData }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.rx.viewDidAppear
            .map { _ in PetInfoReactor.Action.checkFirstEntered }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.rx.viewDidLayoutSubviews
            .map { _ in PetInfoReactor.Action.buttonRadiusUpdate }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.deleteStatus
            .map { PetInfoReactor.Action.deleteStatus($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.historyTableView.rx.isTop
            .asDriver(onErrorJustReturn: true)
            .drive(maskingView.rx.isHidden)
            .disposed(by: disposeBag)
        
        
        // Output
        reactor.pulse(\.$fetchData)
            .observe(on: MainScheduler.instance)
            .compactMap { $0 }
            .do(onNext: { (_ , indexSet, isEmpty) in
                guard let indexSet = indexSet,
                      let isEmpty = isEmpty else { return }
                
                if isEmpty {
                    self.historyTableView.reloadSections(indexSet, with: .automatic)
                }
            })
            .map { $0.petDatas }
            .asDriver(onErrorJustReturn: [])
            .drive(historyTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$displayDataIsEmpty)
            .asDriver(onErrorJustReturn: true)
            .drive(emptyLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$firstEnterCheck)
            .observe(on: MainScheduler.instance)
            .filter { $0 == false }
            .bind(with: self) { vc, _ in
                CustomPopup.shared.showCustomPopup(type: .welcome)
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$buttonRadiusUpdate)
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { vc, _ in
                vc.enterButton.layer.cornerRadius = vc.enterButton.frame.width / 2
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - TableView Delegate
extension HistoryViewController: UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        guard let navigation = self.navigationController as? CustomNavigation else { return }
//    
//        dataManager.setCurrentData(index: indexPath)
//        navigation.pushToViewController(destinationVCCase: .result)
//    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        guard let petInfo = reactor?.currentState.fetchData?.petDatas[section] else { return UITableView.automaticDimension }
        
        return petInfo.checkEmptyStatus() ? UITableView.automaticDimension : 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        guard let petInfo = reactor?.currentState.fetchData?.petDatas[section] else { return UITableView.automaticDimension }
        
        return petInfo.checkEmptyStatus() ? UITableView.automaticDimension : 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let petInfo = reactor?.currentState.fetchData?.petDatas[section],
              !petInfo.checkEmptyStatus() else { return nil }
        
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HistoryTableViewHeaderView.name) as? HistoryTableViewHeaderView else { return nil }
        header.setTitle(petInfo.name)
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
                
                self.deleteStatus.onNext(indexPath)
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

// MARK: - 배너 광고
extension HistoryViewController {
    private func showBanner() {
        setupBanner()
        addBannerViewToView(self.bannerView)
        loadBanner()
    }
    
    private func setupBanner() {
        let viewWidth = view.frame.inset(by: view.safeAreaInsets).width
        let adaptiveSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
        bannerView = GADBannerView(adSize: adaptiveSize)
        bannerView.delegate = self
    }
    
    private func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .bottom,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
    
    private func loadBanner() {
        bannerView.adUnitID = "ca-app-pub-7192833839628496/5958286452"
        bannerView.rootViewController = self
        
        bannerView.load(GADRequest())
    }
}

extension HistoryViewController: GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("👾 테스트 : bannerViewDidReceiveAd 👾")
    }

    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("👾 테스트 : bannerView:didFailToReceiveAdWithError: \(error.localizedDescription) 👾")

    }

    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
        print("👾 테스트 : bannerViewDidRecordImpression 👾")
    }

    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {        
        print("👾 테스트 : bannerViewWillPresentScreen 👾")
    }

    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {        
        print("👾 테스트 : bannerViewWillDIsmissScreen 👾")
    }

    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {        
        print("👾 테스트 : bannerViewDidDismissScreen 👾")
    }
}

extension Reactive where Base: UIViewController {
    var viewWillAppear: ControlEvent<Bool> {
      let source = self.methodInvoked(#selector(Base.viewWillAppear)).map { $0.first as? Bool ?? false }
      return ControlEvent(events: source)
    }
    
    var viewDidAppear: ControlEvent<Bool> {
      let source = self.methodInvoked(#selector(Base.viewDidAppear)).map { $0.first as? Bool ?? false }
      return ControlEvent(events: source)
    }
    
    var viewDidLayoutSubviews: ControlEvent<Void> {
      let source = self.methodInvoked(#selector(Base.viewDidLayoutSubviews)).map { _ in }
      return ControlEvent(events: source)
    }
}

extension Reactive where Base: UIScrollView {
    
    var isTop: Observable<Bool> {
        return contentOffset
            .map { cgPoint in
                return cgPoint.y <= 0
            }
            .filter { $0 == false }
    }
}




//private func configurationTableViewDataSource() {
//    diffableDataSource = UITableViewDiffableDataSource(tableView: historyTableView, cellProvider: { [weak self] tableView, indexPath, itemIdentifier in
//        
//        guard let self = self,
//              let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.name, for: indexPath) as? HistoryTableViewCell else {
//            return UITableViewCell()
//        }
//
//        let currentSection = dataManager.petInfos[indexPath.section]
//        let currentData = currentSection.status[indexPath.row]
//                
//        cell.delegate = self
//        cell.status = currentData
//
//        return cell
//    })
//}
//
//private func setupData() {
//    self.snapShot = NSDiffableDataSourceSnapshot<PetInfo, PetStatus>()
//    
//    self.snapShot.appendSections(dataManager.petInfos)
//
//    dataManager.petInfos.forEach {
//        self.snapShot.appendItems($0.status, toSection: $0)
//    }
//            
//    self.diffableDataSource?.apply(snapShot, animatingDifferences: false)
//}
