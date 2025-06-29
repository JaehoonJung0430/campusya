# 🔧 ERD 테이블 정의

## 추가 필요 테이블들

### 📁 논리 테이블명: 파일 정보 / 물리 테이블명: `files`

| 논리 필드명 | 물리 필드명 | 도메인 | 타입 | NULL 유무 | 기본값 | 코멘트 |
| --- | --- | --- | --- | --- | --- | --- |
| 파일 ID | id | 식별자 | UUID | NOT NULL |  | PK |
| 업로더 ID | uploader_id | 외래키 | UUID | NOT NULL |  | FK -> users.id |
| 원본 파일명 | original_name | 파일명 | VARCHAR | NOT NULL |  |  |
| 저장 파일명 | stored_name | 파일명 | VARCHAR | NOT NULL |  | S3 키 |
| 파일 크기 | file_size | 크기 | BIGINT | NOT NULL |  | bytes |
| MIME 타입 | mime_type | 타입 | VARCHAR | NOT NULL |  | image/jpeg, application/pdf 등 |
| S3 URL | s3_url | URL | VARCHAR | NOT NULL |  |  |
| 파일 타입 | file_type | 분류 | ENUM('IMAGE','DOCUMENT','VIDEO','AUDIO','OTHER') | NOT NULL |  |  |
| 업로드일시 | created_at | 생성일 | TIMESTAMP | NOT NULL | now() |  |

---

### 🔗 논리 테이블명: 게시글-파일 연결 / 물리 테이블명: `post_files`

| 논리 필드명 | 물리 필드명 | 도메인 | 타입 | NULL 유무 | 기본값 | 코멘트 |
| --- | --- | --- | --- | --- | --- | --- |
| 연결 ID | id | 식별자 | SERIAL | NOT NULL |  | PK |
| 게시글 ID | post_id | 외래키 | UUID | NOT NULL |  | FK -> posts.id |
| 파일 ID | file_id | 외래키 | UUID | NOT NULL |  | FK -> files.id |
| 정렬 순서 | sort_order | 순서 | INT | NOT NULL | 0 |  |

---

### 🔔 논리 테이블명: 알림 / 물리 테이블명: `notifications`

| 논리 필드명 | 물리 필드명 | 도메인 | 타입 | NULL 유무 | 기본값 | 코멘트 |
| --- | --- | --- | --- | --- | --- | --- |
| 알림 ID | id | 식별자 | UUID | NOT NULL |  | PK |
| 수신자 ID | user_id | 외래키 | UUID | NOT NULL |  | FK -> users.id |
| 알림 유형 | type | 분류 | ENUM('POST_LIKE','COMMENT_LIKE','COMMENT_REPLY','MENTION','ADMIN_NOTICE') | NOT NULL |  |  |
| 제목 | title | 제목 | VARCHAR | NOT NULL |  |  |
| 내용 | content | 내용 | TEXT | NOT NULL |  |  |
| 관련 엔티티 ID | related_id | 참조 | UUID | NULL |  | 게시글/댓글 ID 등 |
| 관련 엔티티 타입 | related_type | 타입 | ENUM('POST','COMMENT','USER') | NULL |  |  |
| 읽음 여부 | is_read | 플래그 | BOOLEAN | NOT NULL | FALSE |  |
| 생성일시 | created_at | 생성일 | TIMESTAMP | NOT NULL | now() |  |
| 읽은 일시 | read_at | 읽은 시각 | TIMESTAMP | NULL |  |  |

---

### 🚨 논리 테이블명: 신고 / 물리 테이블명: `reports`

| 논리 필드명 | 물리 필드명 | 도메인 | 타입 | NULL 유무 | 기본값 | 코멘트 |
| --- | --- | --- | --- | --- | --- | --- |
| 신고 ID | id | 식별자 | UUID | NOT NULL |  | PK |
| 신고자 ID | reporter_id | 외래키 | UUID | NOT NULL |  | FK -> users.id |
| 신고 대상 ID | target_id | 참조 | UUID | NOT NULL |  | 게시글/댓글 ID |
| 신고 대상 타입 | target_type | 타입 | ENUM('POST','COMMENT','USER') | NOT NULL |  |  |
| 신고 사유 | reason | 사유 | ENUM('SPAM','ABUSE','INAPPROPRIATE','COPYRIGHT','OTHER') | NOT NULL |  |  |
| 상세 설명 | description | 설명 | TEXT | NULL |  |  |
| 상태 | status | 처리 상태 | ENUM('PENDING','PROCESSING','RESOLVED','REJECTED') | NOT NULL | 'PENDING' |  |
| 처리자 ID | handler_id | 외래키 | UUID | NULL |  | FK -> users.id (관리자) |
| 처리 결과 | resolution | 처리 결과 | TEXT | NULL |  |  |
| 신고일시 | created_at | 생성일 | TIMESTAMP | NOT NULL | now() |  |
| 처리일시 | resolved_at | 처리일 | TIMESTAMP | NULL |  |  |

---

### 🏷️ 논리 테이블명: 태그 / 물리 테이블명: `tags`

| 논리 필드명 | 물리 필드명 | 도메인 | 타입 | NULL 유무 | 기본값 | 코멘트 |
| --- | --- | --- | --- | --- | --- | --- |
| 태그 ID | id | 식별자 | SERIAL | NOT NULL |  | PK |
| 태그명 | name | 태그명 | VARCHAR | NOT NULL |  | UNIQUE |
| 사용 횟수 | usage_count | 개수 | INT | NOT NULL | 0 | 캐싱용 |
| 생성일시 | created_at | 생성일 | TIMESTAMP | NOT NULL | now() |  |

---

### 🔗 논리 테이블명: 게시글-태그 연결 / 물리 테이블명: `post_tags`

| 논리 필드명 | 물리 필드명 | 도메인 | 타입 | NULL 유무 | 기본값 | 코멘트 |
| --- | --- | --- | --- | --- | --- | --- |
| 연결 ID | id | 식별자 | SERIAL | NOT NULL |  | PK |
| 게시글 ID | post_id | 외래키 | UUID | NOT NULL |  | FK -> posts.id |
| 태그 ID | tag_id | 외래키 | INT | NOT NULL |  | FK -> tags.id |
| 중복 방지 제약 | UNIQUE(post_id, tag_id) | 제약조건 |  |  |  | 복합 유니크 |

---

### 📊 논리 테이블명: 사용자 활동 로그 / 물리 테이블명: `user_activity_logs`

| 논리 필드명 | 물리 필드명 | 도메인 | 타입 | NULL 유무 | 기본값 | 코멘트 |
| --- | --- | --- | --- | --- | --- | --- |
| 로그 ID | id | 식별자 | UUID | NOT NULL |  | PK |
| 사용자 ID | user_id | 외래키 | UUID | NOT NULL |  | FK -> users.id |
| 액션 타입 | action_type | 액션 | ENUM('LOGIN','LOGOUT','POST_CREATE','POST_VIEW','COMMENT_CREATE','CHAT_MESSAGE') | NOT NULL |  |  |
| 대상 ID | target_id | 참조 | UUID | NULL |  | 관련 엔티티 ID |
| 메타데이터 | metadata | 추가 정보 | JSONB | NULL |  | 브라우저, IP 등 |
| 생성일시 | created_at | 생성일 | TIMESTAMP | NOT NULL | now() |  |

---

## 기존 테이블 수정 사항

### `users` 테이블 추가 필드

| 논리 필드명 | 물리 필드명 | 도메인 | 타입 | NULL 유무 | 기본값 | 코멘트 |
| --- | --- | --- | --- | --- | --- | --- |
| 이메일 인증 여부 | email_verified | 플래그 | BOOLEAN | NOT NULL | FALSE |  |
| 프로필 이미지 URL | profile_image_url | URL | VARCHAR | NULL |  |  |
| 자기소개 | bio | 소개 | TEXT | NULL |  |  |
| 마지막 로그인 | last_login_at | 시각 | TIMESTAMP | NULL |  |  |
| 정지 종료일 | ban_until | 시각 | TIMESTAMP | NULL |  | 정지 상태일 때만 값 존재 |
| 정지 사유 | ban_reason | 사유 | TEXT | NULL |  |  |

### `posts` 테이블 추가 필드

| 논리 필드명 | 물리 필드명 | 도메인 | 타입 | NULL 유무 | 기본값 | 코멘트 |
| --- | --- | --- | --- | --- | --- | --- |
| 조회수 | view_count | 개수 | INT | NOT NULL | 0 |  |
| 댓글수 | comment_count | 개수 | INT | NOT NULL | 0 | 캐싱용 |
| 상태 | status | 상태 | ENUM('ACTIVE','DELETED','HIDDEN') | NOT NULL | 'ACTIVE' |  |
| 고정 여부 | is_pinned | 플래그 | BOOLEAN | NOT NULL | FALSE | 공지 고정 등 |

### `chat_sessions` 테이블 추가 필드

| 논리 필드명 | 물리 필드명 | 도메인 | 타입 | NULL 유무 | 기본값 | 코멘트 |
| --- | --- | --- | --- | --- | --- | --- |
| 세션 제목 | title | 제목 | VARCHAR | NULL |  | 사용자가 설정 가능 |
| 마지막 메시지 시각 | last_message_at | 시각 | TIMESTAMP | NULL |  |  |
| 메시지 수 | message_count | 개수 | INT | NOT NULL | 0 |  |