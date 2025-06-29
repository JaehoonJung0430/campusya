# 🧱 CampusYa ERD 설계 v1.0 (AI + 커뮤니티 + 사용자 기반)

---

## ✅ 포함된 범위

- **핵심 테이블**: `users`, `schools`, `departments`, `boards`, `posts`, `comments`, `chat_logs`
- **기능 요소 기반 확장**: 로그인/온보딩, 홈 대시보드, AI 챗봇, 커뮤니티, 게시글 상세화면 구조 포함

---

## 📚 테이블 상세 정의 (ERD용 표준 형식)

### 🏫 논리 테이블명: 학교 정보 / 물리 테이블명: `schools`

| 논리 필드명 | 물리 필드명 | 도메인 | 타입 | NULL 유무 | 기본값 | 코멘트 |
| --- | --- | --- | --- | --- | --- | --- |
| 고유 ID | id | 식별자 | SERIAL | NOT NULL |  | PK |
| 학교명 | name | 학교명 | VARCHAR | NOT NULL |  | 예: 홍익대학교 |
| 캠퍼스 | campus | 캠퍼스 | VARCHAR | NOT NULL |  | 예: 서울캠퍼스 |
| 이메일 도메인 | domain | 학교 도메인 | VARCHAR | NULL |  | 예: hongik.ac.kr (UNIQUE) |

---

### 🧑‍🎓 논리 테이블명: 학과 정보 / 물리 테이블명: `departments`

| 논리 필드명 | 물리 필드명 | 도메인 | 타입 | NULL 유무 | 기본값 | 코멘트 |
| --- | --- | --- | --- | --- | --- | --- |
| 고유 ID | id | 식별자 | SERIAL | NOT NULL |  | PK |
| 소속 학교 ID | school_id | 외래키 | INT | NOT NULL |  | FK -> schools.id |
| 학과명 | name | 학과명 | VARCHAR | NOT NULL |  |  |

---

## 🧑‍🎓 논리 테이블명: 사용자 정보 / 물리 테이블명: `users`

| 논리 필드명 | 물리 필드명 | 도메인 | 타입 | NULL 유무 | 기본값 | 코멘트 |
| --- | --- | --- | --- | --- | --- | --- |
| 사용자 ID | id | 식별자 | UUID | NOT NULL |  | PK |
| 이메일 | email | 로그인 정보 | VARCHAR | NOT NULL |  | UNIQUE |
| 비밀번호 | password | 보안 정보 | VARCHAR | NOT NULL |  | 암호화 저장 (bcrypt) |
| 닉네임 | nickname | 공개 프로필 | VARCHAR | NOT NULL |  |  |
| 학교 ID | school_id | 외래키 | INT | NOT NULL |  | FK -> schools.id |
| 학과 ID | department_id | 외래키 | INT | NOT NULL |  | FK -> departments.id |
| 권한 | role | 사용자 역할 | ENUM('USER','ADMIN','MODERATOR') | NOT NULL | 'USER' |  |
| 상태 | status | 계정 상태 | ENUM('ACTIVE','BANNED','DELETED') | NOT NULL | 'ACTIVE' |  |
| 생년월일 | birth_date | 개인정보 | DATE | NOT NULL |  |  |
| 성별 | gender | 개인정보 | ENUM('MALE','FEMALE','OTHER') | NOT NULL |  |  |
| 입학 연도 | admission_year | 연도 (입학년도) | SMALLINT | NOT NULL |  | 예: 2023 (23학번 의미) |
| 학번 (고유 번호) | student_number | 고유 학번 | VARCHAR | NOT NULL |  | 예: C311158 등 숫자 또는 문자 포함 가능 |
| 가입일시 | created_at | 생성일 | TIMESTAMP | NOT NULL | now() |  |
| 수정일시 | updated_at | 수정일 | TIMESTAMP | NULL |  |  |

---

## ✅ 논리 테이블명: 사용자 동의 내역 / 물리 테이블명: `user_consents`

| 논리 필드명 | 물리 필드명 | 도메인 | 타입 | NULL 유무 | 기본값 | 코멘트 |
| --- | --- | --- | --- | --- | --- | --- |
| 동의 ID | id | 식별자 | SERIAL | NOT NULL |  | PK |
| 사용자 ID | user_id | 외래키 | UUID | NOT NULL |  | FK -> users.id |
| 동의 유형 | consent_type | 동의 종류 | ENUM('PRIVACY_POLICY','TERMS_OF_SERVICE') | NOT NULL |  | 개인정보, 이용약관 등 |
| 동의 상태 | consent_status | 동의 여부 | BOOLEAN | NOT NULL | FALSE | TRUE = 동의함 |
| 동의 일시 | consent_date | 동의 일시 | TIMESTAMP | NOT NULL | now() |  |

---

## 🔔 논리 테이블명: 사용자 알림 설정 / 물리 테이블명: `user_notifications`

| 논리 필드명 | 물리 필드명 | 도메인 | 타입 | NULL 유무 | 기본값 | 코멘트 |
| --- | --- | --- | --- | --- | --- | --- |
| 설정 ID | id | 식별자 | SERIAL | NOT NULL |  | PK |
| 사용자 ID | user_id | 외래키 | UUID | NOT NULL |  | FK -> users.id |
| 이메일 알림 | email_alert | 알림 동의 | BOOLEAN | NOT NULL | TRUE | 이메일 알림 수신 여부 |
| SMS 알림 | sms_alert | 알림 동의 | BOOLEAN | NOT NULL | FALSE | SMS 알림 수신 여부 |
| 푸시 알림 | push_alert | 알림 동의 | BOOLEAN | NOT NULL | TRUE | 앱 푸시 알림 수신 여부 |
| 생성일시 | created_at | 생성일 | TIMESTAMP | NOT NULL | now() |  |
| 수정일시 | updated_at | 수정일 | TIMESTAMP | NULL |  |  |

---

### 📋 논리 테이블명: 게시판 / 물리 테이블명: `boards`

| 논리 필드명 | 물리 필드명 | 도메인 | 타입 | NULL 유무 | 기본값 | 코멘트 |
| --- | --- | --- | --- | --- | --- | --- |
| 게시판 ID | id | 식별자 | SERIAL | NOT NULL |  | PK |
| 학교 ID | school_id | 외래키 | INT | NOT NULL |  | FK -> schools.id |
| 게시판명 | name | 이름 | VARCHAR | NOT NULL |  | UNIQUE per school |
| 설명 | description | 소개글 | TEXT | NULL |  |  |
| 공개 여부 | is_public | 플래그 | BOOLEAN | NOT NULL | TRUE | 공개 여부 |
| 정렬 우선순위 | sort_order | 정렬 값 | INT | NULL |  |  |

---

### 📝 논리 테이블명: 게시글 / 물리 테이블명: `posts`

| 논리 필드명 | 물리 필드명 | 도메인 | 타입 | NULL 유무 | 기본값 | 코멘트 |
| --- | --- | --- | --- | --- | --- | --- |
| 게시글 ID | id | 식별자 | UUID | NOT NULL |  | PK |
| 게시판 ID | board_id | 외래키 | INT | NOT NULL |  | FK -> boards.id |
| 작성자 ID | user_id | 외래키 | UUID | NOT NULL |  | FK -> users.id |
| 제목 | title | 제목 | VARCHAR | NOT NULL |  |  |
| 본문 | content | 내용 | TEXT | NOT NULL |  |  |
| 익명 여부 | anonymous_flag | 플래그 | BOOLEAN | NOT NULL | TRUE |  |
| 익명 닉네임 | anonymous_nickname | 표시명 | VARCHAR | NULL |  | 예: 익명1, 익명2 |
| 좋아요 수 | likes_count | 캐싱 수치 | INT | NOT NULL | 0 |  |
| 작성일시 | created_at | 생성일 | TIMESTAMP | NOT NULL | now() |  |
| 수정일시 | updated_at | 수정일 | TIMESTAMP | NULL |  |  |

---

### 💬 논리 테이블명: 댓글 / 물리 테이블명: `comments`

| 논리 필드명 | 물리 필드명 | 도메인 | 타입 | NULL 유무 | 기본값 | 코멘트 |
| --- | --- | --- | --- | --- | --- | --- |
| 댓글 ID | id | 식별자 | UUID | NOT NULL |  | PK |
| 게시글 ID | post_id | 외래키 | UUID | NOT NULL |  | FK -> posts.id |
| 작성자 ID | user_id | 외래키 | UUID | NOT NULL |  | FK -> users.id |
| 부모 댓글 ID | parent_comment_id | 외래키 | UUID | NULL |  | NULL이면 일반 댓글 |
| 내용 | content | 내용 | TEXT | NOT NULL |  |  |
| 익명 여부 | anonymous_flag | 플래그 | BOOLEAN | NOT NULL | TRUE |  |
| 익명 닉네임 | anonymous_nickname | 표시명 | VARCHAR | NULL |  | 예: 익명1 |
| 좋아요 수 | likes_count | 캐싱 수치 | INT | NOT NULL | 0 |  |
| 작성일시 | created_at | 생성일 | TIMESTAMP | NOT NULL | now() |  |

---

### 👍 논리 테이블명: 게시글 좋아요 / 물리 테이블명: `post_likes`

| 논리 필드명 | 물리 필드명 | 도메인 | 타입 | NULL 유무 | 기본값 | 코멘트 |
| --- | --- | --- | --- | --- | --- | --- |
| 고유 ID | id | 식별자 | SERIAL | NOT NULL |  | PK |
| 게시글 ID | post_id | 외래키 | UUID | NOT NULL |  | FK -> posts.id |
| 사용자 ID | user_id | 외래키 | UUID | NOT NULL |  | FK -> users.id |
| 좋아요 일시 | created_at | 생성일 | TIMESTAMP | NOT NULL | now() |  |
| 중복 방지 제약 | UNIQUE(post_id, user_id) | 제약조건 |  |  |  | 복합 유니크 |

---

### ❤️ 논리 테이블명: 댓글 좋아요 / 물리 테이블명: `comment_likes`

| 논리 필드명 | 물리 필드명 | 도메인 | 타입 | NULL 유무 | 기본값 | 코멘트 |
| --- | --- | --- | --- | --- | --- | --- |
| 고유 ID | id | 식별자 | SERIAL | NOT NULL |  | PK |
| 댓글 ID | comment_id | 외래키 | UUID | NOT NULL |  | FK -> comments.id |
| 사용자 ID | user_id | 외래키 | UUID | NOT NULL |  | FK -> users.id |
| 좋아요 일시 | created_at | 생성일 | TIMESTAMP | NOT NULL | now() |  |
| 중복 방지 제약 | UNIQUE(comment_id, user_id) | 제약조건 |  |  |  | 복합 유니크 |

---

### 🤖 논리 테이블명: AI 채팅 세션 / 물리 테이블명: `chat_sessions`

| 논리 필드명 | 물리 필드명 | 도메인 | 타입 | NULL 유무 | 기본값 | 코멘트 |
| --- | --- | --- | --- | --- | --- | --- |
| 세션 ID | id | 식별자 | UUID | NOT NULL |  | PK |
| 사용자 ID | user_id | 외래키 | UUID | NOT NULL |  | FK -> users.id |
| 생성일시 | created_at | 생성일 | TIMESTAMP | NOT NULL | now() | 채팅 세션 생성 시각 |

---

### 🤖 논리 테이블명: AI 대화 로그 / 물리 테이블명: `chat_logs`

| 논리 필드명 | 물리 필드명 | 도메인 | 타입 | NULL 유무 | 기본값 | 코멘트 |
| --- | --- | --- | --- | --- | --- | --- |
| 대화 로그 ID | id | 식별자 | UUID | NOT NULL |  | PK |
| 세션 ID | session_id | 외래키 | UUID | NOT NULL |  | FK -> [session.id](http://session.id/) |
| 질문 | question | 입력 | TEXT | NOT NULL |  |  |
| 응답 | answer | 출력 | TEXT | NOT NULL |  | GPT 응답 내용 |
| 요약 응답 | summary | 카드 요약 | TEXT | NULL |  | 선택적 |
| 출처 | source | 관련 자료 | JSONB | NULL |  | 관련 게시글 ID, 링크 등 |
| 생성일시 | created_at | 생성일 | TIMESTAMP | NOT NULL | now() |  |