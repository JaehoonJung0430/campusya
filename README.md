# campusya
campus AI mascot mentor

⚙️ PostgreSQL 로컬 설정 (Codespaces 기준)
bash
복사
편집
# 최상위 디렉토리에 있는 스크립트를 실행하여 PostgreSQL 설치 및 초기화
./setup-db.sh
📝 이 스크립트는 다음 작업을 자동으로 처리합니다:
PostgreSQL 설치 (sudo apt install)

사용자 campusya_user 생성

데이터베이스 campusya_db 생성 및 소유자 설정

⚠️ Codespaces 환경은 휘발성이므로 컨테이너를 재시작할 때마다 이 스크립트를 다시 실행해야 합니다.

