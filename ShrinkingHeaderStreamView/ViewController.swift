//
//  ViewController.swift
//  ShrinkingHeaderStreamView
//
//  Created by Гранченко Юрий on 12/27/18.
//  Copyright © 2018 Simcord. All rights reserved.
//

import UIKit
import StreamView
import SnapKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet var streamView: StreamView!
    fileprivate lazy var dataSource: StreamDataSource<[String]> = {
        let ds = StreamDataSource<[String]>(streamView: self.streamView)
        return ds
    }()
    fileprivate let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupStreamVeiw()
    }
    
    fileprivate func setupStreamVeiw() {
        streamView.contentInsetAdjustmentBehavior = .never
        streamView.showsHorizontalScrollIndicator = false
        var headerView = UIView()
        let headerMetrics = StreamMetrics<ItemsHeader>(size: 200)
        headerMetrics.finalizeAppearing = { item, view in
            view.imageView.image = #imageLiteral(resourceName: "Image")
            headerView = view
        }
        let metrics = StreamMetrics<ItemsCell>()
        metrics.selectable = false
        metrics.modifyItem = { item in
            item.size = 60
        }
        dataSource.addSectionHeaderMetrics(metrics: headerMetrics)
        dataSource.addMetrics(metrics: metrics)
        dataSource.items = ["one", "two", "three","one", "two", "three","one", "two", "three","one", "two", "three","one", "two", "three"]
        streamView.rx.didScroll
            .subscribe({ [unowned self] _ in
                let contentOffsetY = self.streamView.contentOffset.y
                let height = 200 - contentOffsetY
                headerView.frame = CGRect(x: 0, y: contentOffsetY, width: self.streamView.width, height: height)
            }).disposed(by: disposeBag)
    }
}

class ItemsCell: EntryStreamReusableView<String> {
    
    private let informationLabel = specify(object: UILabel()) {
        $0.numberOfLines = 0
    }
    
    public let imageView = specify(object: UIImageView()) {
        $0.image = #imageLiteral(resourceName: "Image-1")
        $0.contentMode = .scaleToFill
    }
    
    
    override func setup(entry: String) {
//        informationLabel.text = entry
    }
    
    override func layoutSubviews() {
        
        add(imageView, {
            $0.edges.equalTo(self).inset(12)
        })
        
//        add(informationLabel, {
//            $0.leading.equalTo(imageView.snp.trailing).inset(12)
//            $0.centerY.equalTo(self)
//            $0.trailing.equalTo(self).inset(12)
//        })
    }
}

class ItemsHeader: EntryStreamReusableView<()> {
    
    public let imageView = specify(object: UIImageView()) {
        $0.contentMode = .scaleAspectFill
    }
    
    override func layoutSubviews() {
        add(imageView, {
            $0.edges.equalTo(self)
        })
    }
}

extension UIView {
    @discardableResult func add<T: UIView>(_ subview: T, _ layout: (_ make: ConstraintMaker) -> Void) -> T {
        addSubview(subview)
        subview.snp.makeConstraints(layout)
        return subview
    }
}
