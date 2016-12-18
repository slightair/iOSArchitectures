import Foundation
import UIKit
import RxSwift
import RxCocoa

extension ColorItemClient: ReactiveCompatible {}
extension Reactive where Base: ColorItemClient {
    func requestItems() -> Observable<[ColorItem]> {
        return Observable.create { [weak base] observer in
            base?.requestItems { items in
                observer.onNext(items)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}

final class ViewController: UITableViewController {
    private let viewModel = ColorItemListViewModel(client: ColorItemClient())
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MVVM (Rx)"

        tableView.register(ColorItemCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = nil

        viewModel.items.asObservable()
            .bindTo(tableView.rx.items(cellIdentifier: "Cell", cellType: ColorItemCell.self)) { _, colorItem, cell in
                cell.update(with: colorItem)
            }
            .addDisposableTo(disposeBag)

        let loadButtonItem = UIBarButtonItem(title: "Load", style: .plain, target: nil, action: nil)
        loadButtonItem.rx.tap
            .bindTo(viewModel.loadItemsTrigger)
            .addDisposableTo(disposeBag)
        navigationItem.rightBarButtonItem = loadButtonItem
    }
}

final class ColorItemListViewModel {
    let loadItemsTrigger = PublishSubject<Void>()
    let items = Variable<[ColorItem]>([])
    private let disposeBag = DisposeBag()

    required init(client: ColorItemClient) {
        loadItemsTrigger
            .flatMap {
                client.rx.requestItems()
            }
            .bindTo(items)
            .addDisposableTo(disposeBag)
    }
}

let view = ViewController()

// live rendering

import PlaygroundSupport

let navigationController = UINavigationController(rootViewController: view)
navigationController.view.frame = CGRect(x: 0, y: 0, width: 375, height: 667)

PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = navigationController.view
