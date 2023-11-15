import UIKit
import RxSwift
import RxCocoa

class MessageRoomViewController: UIViewController {
    
    private let tableView = UITableView()
    private let viewModel = MessageRoomViewModel()
    private let disposeBag = DisposeBag()
    private let mainTitle = UILabel()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindViewModel()
        viewModel.loadChatRooms()
        print("\(#function)")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.stopListening()
        print("\(#function)")
    }
    
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.register(MessageRoomCell.self, forCellReuseIdentifier: "MessageRoomCell")
        tableView.delegate = self

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func bindViewModel() {
        viewModel.messageRooms
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "MessageRoomCell", cellType: MessageRoomCell.self)) { (row, chatRoom, cell) in
                cell.configure(with: chatRoom)
            }
            .disposed(by: disposeBag)
    }
}


//MARK: - TableView Delegate
extension MessageRoomViewController: UITableViewDelegate {
    
    //Set cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height/10
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if let messageRoom = try? viewModel.messageRooms.value()[indexPath.row] {
            presentMessageViewController(with: messageRoom)
        }
    }
    
    private func presentMessageViewController(with messageRoom: MessageRoom) {
        let messageVC = MessageViewController()
        present(messageVC, animated: true, completion: nil)
    }
}
