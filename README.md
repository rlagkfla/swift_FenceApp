# 찾아줄개🐶

### 프로젝트 개요
----
- 소개 : 반려동물을 찾아주는 커뮤니티 서비스 앱
- 상태 : 배포 중 
- 다운로드 링크 : https://apps.apple.com/kr/app/%EC%B0%BE%EC%95%84%EC%A4%84%EA%B0%9C/id6471409178
- 진행 기간
    - 기획 : 2023.10.10 ~ 2023.10.20 (2주)
    - 개발 : 2023.10.23 ~ 2023.11.17 (4주)
    - 출시 : 2023.11.15 
- 팀원
    - 개발 : 전상혁, 이우준, 김하림(나), 전종혁, 이리연
    - 서버 : 이우준
    - 디자인 : 김하림(나)
- 기술 스택
    - 개발 환경
        - Swift 5, Xcode 15.1 
    - 라이브러리
        - iOS
            - SnapKit : 효율적으로 포르젝트를 진행하기 위해 SnapKit을 채택해 전보다 코드량을 확실히 줄였습니다.
            - MapKit, Core Location : 프로젝트에서 유저의 위치정보를 통해 Map을 활용하여 Mark(핀)을 보여주는 것이 **주요 기능**이기 때문에 채택하였습니다.
            - Kingfisher : Firebase에 Image가 url 방식으로 저장되기 때문에 이미지 파일 다운로드 및 캐싱을 자동적으로 처리해주는 편리성이 좋아 채택하게 되었습니다.
            - MessageUI : 게시글, 댓글 신고 및 앱 피드백(이메일 작성)을 통해 사용자와 개발자간의 소통이 가능하고 앱 품질 향상을 위해 채택하였습니다.
            - WebKit : 개인정보 처리방침 및 서비스 이용약관 제공 페이지는 노션을 활용하여 좀 더 사용자가 쉽게 접근할 수 있게 하였습니다.
            - FirebaseCloudMessaging : 사용자의 게시글에 댓글이 달렸을 경우 실시간으로 알림 기능을 구현하기 위해 채택하였습니다.
        - 서버 : Firebase
    - 아키텍처 : MVC **(채택 이유 필요)**
    - Deployment Target : iOS 16.0


### 앱 소개(삭제예정)
----
반려동물을 일어버리셨나요? 혹은 길 잃은 반려동물을 찾으셨나요?

**"찾아줄개"** 커뮤니티 앱을 통해 반려동물을 찾아보세요!

반려동물을 잃어버렸을 때 글을 작성하실 수 있으며, 길을 가다가 길 잃은 반려동물을 발견했을 때 사진 촬영 한 번으로 손 쉽게 글을 작성하실 수 있습니다.

**"위치 기반 서비스"**
를 이용하여 사용자 위치 주변의 잃어버린 반려동물, 길 잃은 반려동물들의 글들을 지도를 통해 쉽게 확인해 볼 수 있습니다.
잃어버린 반려동물, 발견한 길 잃은 반려동물 게시글들을 각 게시판에서 리스트로 확인해볼 수 있으며, 사용자의 위치에서 거리에 따른 기능 및 날짜 선택을 통해 언제부터 어디까지 작성된 글들을 필터 기능을 통해 원하시는 정보들도 보실 수 있습니다.

본인의 페이지에서 본인이 작성한 게시글들 및 닉네임, 프로필 이미지를 수정할 수 있으며, 로그아웃 및 회원탈퇴 기능들도 준비되어 있습니다.


### 이미지(삭제예정)
----
<img src = "https://github.com/GaeMeee/Fence_App/assets/32815948/ed54087b-25ee-4ce8-8c2b-848656891d69" width = "24%" height = "25%">
<img src = "https://github.com/GaeMeee/Fence_App/assets/32815948/9a1acc40-a6fb-480e-a44c-025a2510673e" width = "24%" height = "25%">
<img src = "https://github.com/GaeMeee/Fence_App/assets/32815948/56a5a453-a59c-47bb-a8ce-a0f8d2941661" width = "24%" height = "25%">
<img src = "https://github.com/GaeMeee/Fence_App/assets/32815948/396708a7-c3cd-487e-8ba2-e9d62f9cf591" width = "24%" height = "25%">


### 주요 화면 및 구현 기능(이미지 추가)
----
- ### Login 
<img src = "https://github.com/GaeMeee/Fence_App/assets/32815948/ed54087b-25ee-4ce8-8c2b-848656891d69" width = "22%" height = "23%">
<img src = "https://github.com/rlagkfla/swift_FenceApp/assets/51162461/3779c356-5a02-40c9-ba8e-5f01d3deadf5" width = "22%" height = "23%">

    - 전화번호 인증을 통한 회원가입
    - Firebase를 통한 로그인, 이메일 형식의 아이디로 비밀번호 찾기
  
- ### MapView
<img src = "https://github.com/GaeMeee/Fence_App/assets/32815948/9a1acc40-a6fb-480e-a44c-025a2510673e" width = "22%" height = "23%">
<img src = "https://github.com/rlagkfla/swift_FenceApp/assets/51162461/4fa966b0-c585-4743-89cd-67507e9f34ae" width = "22%" height = "23%">
<img src = "https://github.com/rlagkfla/swift_FenceApp/assets/51162461/3e0ac674-56ec-48f7-8ec8-172589b5222f" width = "22%" height = "23%">

    - 사용자가 작성한 게시글의 이미지와 위치 정보를 활용하여 Map에 Mark(핀)을 생성
    - 거리와 날짜를 이용하여 필터된 데이터들을 바탕으로 Mark(핀)을 업데이트
        - 사용자의 위치의 정보를 가지고 현재 위치에서 반경 nkm까지 Mark(핀) 필터링
        - 시작, 끝 날짜를 바탕으로 Mark(핀) 필터링
        
- ### LostView(잃어버린 동물 페이지) & EnrollView
<img src = "https://github.com/rlagkfla/swift_FenceApp/assets/51162461/e116ce85-973e-4b76-9994-ebb310c83796" width = "22%" height = "23%">
<img src = "https://github.com/rlagkfla/swift_FenceApp/assets/51162461/61bcc36d-e988-479b-bbe5-a6d6e63fe665" width = "22%" height = "23%">

    - 등록 시 사용자의 위치 정보와 반려동물 정보를 바탕으로 LOST Map에 Mark(핀)을 업데이트
    - 잃어버린 반려동물의 게시글을 TableView로 보여줌
    - 거리와 날짜를 이용하여 필터된 데이터들을 바탕으로 게시글 업데이트
        - 사용자의 위치의 정보를 가지고 현재 위치에서 반경 nkm까지 게시글 필터링
        - 시작, 끝 날짜를 바탕으로 게시글의 작성된 날짜 필터링
    - Pagination을 통한 무한 스크롤
- ### Camera
<img src = "https://github.com/rlagkfla/swift_FenceApp/assets/51162461/b2b280e3-8b3a-45fe-b2e5-07043ec60eb6" width = "22%" height = "23%">
<img src = "https://github.com/rlagkfla/swift_FenceApp/assets/51162461/c27d08a1-3502-4329-9113-ca4d9ebc2d94" width = "22%" height = "23%">

    - 사진 촬영 시 현재 사용자의 위치와 촬영된 이미지를 바탕으로 발견한 반려동물 게시글 자동 생성 및 FOUND Map에 Mark(핀)을 업데이트
    
- ### FoundView(발견한 동물 페이지)
<img src = "https://github.com/rlagkfla/swift_FenceApp/assets/51162461/cb2f5400-f4e2-449e-8ce4-8e7b09dc2ccf" width = "22%" height = "23%">

    - 발견한 반려동물의 게시글을 CollectionView로 보여줌
    - 거리와 날짜를 이용하여 필터된 데이터들을 바탕으로 게시글을 업데이트
        - 사용자의 위치의 정보를 가지고 현재 위치에서 반경 nkm까지 게시글 필터링
        - 시작, 끝 날짜를 바탕으로 게시글의 작성된 날짜 필터링
        
- ### DetailView
<img src = "https://github.com/rlagkfla/swift_FenceApp/assets/51162461/bf8aa7b3-12b1-4dc0-a1d9-7387875a7190" width = "22%" height = "23%">
<img src = "https://github.com/rlagkfla/swift_FenceApp/assets/51162461/1a56af7c-b868-48da-8fff-caaa4c6a6449" width = "22%" height = "23%">
<img src = "https://github.com/rlagkfla/swift_FenceApp/assets/51162461/ec34548c-777c-4863-aa22-02fff3ac9ae4" width = "22%" height = "23%">

    - 잃어버린 반려동물 게시글 및 발견한 반려동물의 게시글을 바탕으로 상세 페이지를 보여줌
    - 작성자 본인의 게시글은 삭제 및 수정이 가능하고, 다른 사용자의 글은 신고 가능
    - 댓글 기능
        - FCM 사용하여 게시글 작성자에게 실시간으로 알림
        - 삭제, 수정, 신고 기능
          
- ### MyInfo
    - 프로필 이미지 및 닉네임 수정
    - 사용자가 작성한 게시글 CollectionView로 보여줌
    - 앱 피드백, 회원탈퇴, 로그아웃, 개인정보 처리방침 및 서비스 이용약관 구현


### Flow Chart
----
<img src = "https://github.com/GaeMeee/Fence_App/assets/32815948/49634c63-46ae-43ca-a025-f4450bd6a0d0" width = "100%" height = "50%">

### 트러블 슈팅(더 추가 디테일 필요!!)
----
- 게시글 및 댓글을 작성 또는 수정할 때, '작성' 버튼을 여러 번 누르면 중복 등록되는 오류가 발생합니다.
    - 이 문제를 해결하기 위해 등록 버튼 클릭 시에 비활성화 또는 플래그 사용 등 다양한 방법이 있었지만, 사용자 관점에서 등록 후 알림이 없어 오류가 났을 수 있다는 고려로 AlertController를 활용하여 '작성 중입니다'라는 명확한 알림을 제공하도록 하였습니다.
- 잦은 API 호출 문제
    - 데이터 정보를 객체에 따라 분리를 하면 API를 여러 번 호출하는 문제가 있을 수 있고, 데이터를 한 곳에 집중하면 API는 한 번만 호출하지만 필요없는 데이터도 다 가져와야 하는 문제가 생길 수 있습니다. 그래서 유저의 사용 방식과 앱 구동 방식을 고려하여 필요한 데이터가 조금씩 중첩되도록 모델을 설계하였습니다.
