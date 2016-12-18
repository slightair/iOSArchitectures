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
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MVVM (Rx)"

        tableView.register(ColorItemCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = nil

        let loadButtonItem = UIBarButtonItem(title: "Load", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = loadButtonItem

        let client = ColorItemClient()
        let viewModel = ColorItemListViewModel(loadButtonTaps: loadButtonItem.rx.tap.asObservable(),
                                               client: client)

        viewModel.items
            .bindTo(tableView.rx.items(cellIdentifier: "Cell", cellType: ColorItemCell.self)) { _, colorItem, cell in
                cell.update(with: colorItem)
            }
            .addDisposableTo(disposeBag)
    }
}

final class ColorItemListViewModel {
    let items: Observable<[ColorItem]>

    required init(loadButtonTaps: Observable<Void>, client: ColorItemClient) {
        items = loadButtonTaps
            .flatMapLatest {
                client.rx.requestItems()
            }
            .shareReplay(1)
    }
}

let view = ViewController()

// live rendering

import PlaygroundSupport

let navigationController = UINavigationController(rootViewController: view)
navigationController.view.frame = CGRect(x: 0, y: 0, width: 375, height: 667)

PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = navigationController.view
