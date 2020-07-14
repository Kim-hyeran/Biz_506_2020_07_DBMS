# git-hub에 프로젝트 업로드 하기


### 최초로 git-hub에 프로젝트 업로드
1. git init : 현재 폴더를 git-hub에 올리기 위한 local repository 생성

### 생성된 local repository에 git-hub 접속 정보 추가
#### 공용 또는 여러 사람이 사용하는 컴퓨터인 경우 폴더별로 사용자를 변경하고자 할 때
2-1. git config --local user.name userID
3-1. git config --local user.email user@email.com
#### 혼자 사용하는 컴퓨터에서는 글로벌로 설정값 저장
2-2. git config --global user.name userID
3-2. git config --global user.email user@email.com
	git config를 global로 설정하게 되면 local repository를 생성할 때마다 git config를 실행하지 않아도 된다

### remote repository 정보 추가
4. git-hub 사이트에 접속하여 new repository 설정
5. git remote add origin https://github.com/userID/repository : remote repository 추가
	git-hub의 remote repository인 주소를 origin이라는 이름으로 사용하겠다는 뜻

### git-hub에 프로젝트 업로드할 때마다 항상 실행
6. git add . : 현재 폴더, 서브(하위) 폴더의 모든 파일을 local repository(.git 폴더)에 압축, 암호화(해쉬)하여 저장
7. git commit -m "Comment" : 지금 시점에 추가된 프로젝트에 Comment를 첨부하여 remote에 업로드할 준비
8-1. git push -u origin master(local) : master에 저장된 프로젝트를 origin(remote)에 전송(최초 업로드 시에만)
8-2. git push : 최초 업로드 이후 두 번째 업로드부터 사용 가능한 명령어

### git-hub에 올려진 프로젝트를 다른 장소에서 공동으로 작업할 경우(예시)
1. 학원에서 코딩 후 프로젝트를 git-hub에 add, commit, push하여 upload
2. 집에서 'git clone remote주소'하여 download
3. 프로젝트 코딩 추가, 변경
4. git config 수행 : 처음 수행한 user.name, user.mail과 일치하여야 함
5. git push -u origin master 실행
6. 다시 학원에 와서 "git pull"을 수행하여 집에서 업로드한 프로젝트와 학원의 프로젝트를 동기화
7. 코딩 추가, 변경 후 위의 작업 반복
8. 만약 git-hub 사이트에서 코드를 직접 변경하거나 다른 작업을 수행하더라도 local에서 git pull 수행
	무시할 경우 remote repository를 삭제하고 다시 생성해야하는 경우 발생