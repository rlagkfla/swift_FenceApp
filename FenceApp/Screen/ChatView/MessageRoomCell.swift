import UIKit
import SnapKit

class MessageRoomCell: UITableViewCell {
    
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    private let lastMessageLabel = UILabel()
    private let timestampLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        
        contentView.addSubviews(profileImageView,nameLabel,lastMessageLabel,timestampLabel)

        profileImageView.layer.cornerRadius = 25
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(50)
        }

        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(10)
            $0.top.equalToSuperview().offset(10)
            $0.trailing.lessThanOrEqualTo(timestampLabel.snp.leading).offset(-10)
        }

        lastMessageLabel.textColor = .darkGray
        lastMessageLabel.font = UIFont.systemFont(ofSize: 14)
        lastMessageLabel.snp.makeConstraints {
            $0.leading.equalTo(nameLabel)
            $0.bottom.equalToSuperview().offset(-10)
            $0.trailing.lessThanOrEqualToSuperview().offset(-10)
        }

        timestampLabel.textColor = .lightGray
        timestampLabel.font = UIFont.systemFont(ofSize: 12)
        timestampLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-10)
            $0.centerY.equalTo(nameLabel)
        }
    }


    func configure(with messageRoom: MessageRoom) {
        nameLabel.text = messageRoom.userNickName
        lastMessageLabel.text = messageRoom.lastMessage
        timestampLabel.text = formatDate(messageRoom.timestamp)
        loadImage(from: messageRoom.profileImageURL, into: profileImageView)
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    private func loadImage(from urlString: String, into imageView: UIImageView?) {
        
        guard let url = URL(string: urlString), let imageView = imageView else { return }
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }
    }
}
