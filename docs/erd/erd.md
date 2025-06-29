

# 🧱 CampusYa ERD 설계 v1.0 (AI + 커뮤니티 + 사용자 기반)

---

## ✅ 포함된 범위

* 핵심 테이블: `users`, `schools`, `departments`, `boards`, `posts`, `comments`, `chat_logs` 등
* 로그인/온보딩, 홈 대시보드, AI 챗봇, 커뮤니티, 게시글 상세화면 구조 포함

---

## 📚 테이블 상세 정의 (ERD 표준 형식)

### 🏫 학교 정보 / `schools`

| 논리 필드명  | 물리 필드명 | 도메인    | 타입      | NULL 유무  | 기본값 | 코멘트                     |
| ------- | ------ | ------ | ------- | -------- | --- | ----------------------- |
| 고유 ID   | id     | 식별자    | SERIAL  | NOT NULL |     | PK                      |
| 학교명     | name   | 학교명    | VARCHAR | NOT NULL |     | 예: 홍익대학교                |
| 캠퍼스     | campus | 캠퍼스명   | VARCHAR | NOT NULL |     | 예: 서울캠퍼스                |
| 이메일 도메인 | domain | 학교 도메인 | VARCHAR | NULL     |     | UNIQUE, 예: hongik.ac.kr |

---

### 🧑‍🎓 학과 정보 / `departments`

| 논리 필드명   | 물리 필드명     | 도메인 | 타입      | NULL 유무  | 기본값 | 코멘트              |
| -------- | ---------- | --- | ------- | -------- | --- | ---------------- |
| 고유 ID    | id         | 식별자 | SERIAL  | NOT NULL |     | PK               |
| 소속 학교 ID | school\_id | 외래키 | INT     | NOT NULL |     | FK -> schools.id |
| 학과명      | name       | 학과명 | VARCHAR | NOT NULL |     |                  |

---

### 🧑‍🎓 사용자 정보 / `users`

| 논리 필드명      | 물리 필드명              | 도메인       | 타입                                | NULL 유무  | 기본값      | 코멘트                  |
| ----------- | ------------------- | --------- | --------------------------------- | -------- | -------- | -------------------- |
| 사용자 ID      | id                  | 식별자       | UUID                              | NOT NULL |          | PK                   |
| 이메일         | email               | 로그인 정보    | VARCHAR                           | NOT NULL |          | UNIQUE               |
| 비밀번호        | password            | 보안 정보     | VARCHAR                           | NOT NULL |          | bcrypt 암호화 저장        |
| 닉네임         | nickname            | 공개 프로필    | VARCHAR                           | NOT NULL |          |                      |
| 학교 ID       | school\_id          | 외래키       | INT                               | NOT NULL |          | FK -> schools.id     |
| 학과 ID       | department\_id      | 외래키       | INT                               | NOT NULL |          | FK -> departments.id |
| 권한          | role                | 사용자 역할    | ENUM('USER','ADMIN','MODERATOR')  | NOT NULL | 'USER'   |                      |
| 상태          | status              | 계정 상태     | ENUM('ACTIVE','BANNED','DELETED') | NOT NULL | 'ACTIVE' |                      |
| 생년월일        | birth\_date         | 개인정보      | DATE                              | NOT NULL |          |                      |
| 성별          | gender              | 개인정보      | ENUM('MALE','FEMALE','OTHER')     | NOT NULL |          |                      |
| 입학 연도       | admission\_year     | 연도 (입학년도) | SMALLINT                          | NOT NULL |          | 예: 2023 (23학번 의미)    |
| 학번 (고유 번호)  | student\_number     | 고유 학번     | VARCHAR                           | NOT NULL |          | 예: C311158 등         |
| 이메일 인증 여부   | email\_verified     | 플래그       | BOOLEAN                           | NOT NULL | FALSE    |                      |
| 프로필 이미지 URL | profile\_image\_url | URL       | VARCHAR                           | NULL     |          |                      |
| 자기소개        | bio                 | 소개        | TEXT                              | NULL     |          |                      |
| 마지막 로그인     | last\_login\_at     | 시각        | TIMESTAMP                         | NULL     |          |                      |
| 정지 종료일      | ban\_until          | 시각        | TIMESTAMP                         | NULL     |          | 정지 상태일 때만 존재         |
| 정지 사유       | ban\_reason         | 사유        | TEXT                              | NULL     |          |                      |
| 가입일시        | created\_at         | 생성일       | TIMESTAMP                         | NOT NULL | now()    |                      |
| 수정일시        | updated\_at         | 수정일       | TIMESTAMP                         | NULL     |          |                      |

---

### ✅ 사용자 동의 내역 / `user_consents`

| 논리 필드명 | 물리 필드명          | 도메인   | 타입                                           | NULL 유무  | 기본값   | 코멘트            |
| ------ | --------------- | ----- | -------------------------------------------- | -------- | ----- | -------------- |
| 동의 ID  | id              | 식별자   | SERIAL                                       | NOT NULL |       | PK             |
| 사용자 ID | user\_id        | 외래키   | UUID                                         | NOT NULL |       | FK -> users.id |
| 동의 유형  | consent\_type   | 동의 종류 | ENUM('PRIVACY\_POLICY','TERMS\_OF\_SERVICE') | NOT NULL |       | 개인정보, 이용약관 등   |
| 동의 상태  | consent\_status | 동의 여부 | BOOLEAN                                      | NOT NULL | FALSE | TRUE = 동의함     |
| 동의 일시  | consent\_date   | 동의 일시 | TIMESTAMP                                    | NOT NULL | now() |                |

---

### 🔔 사용자 알림 설정 / `user_notifications`

| 논리 필드명 | 물리 필드명       | 도메인   | 타입        | NULL 유무  | 기본값   | 코멘트            |
| ------ | ------------ | ----- | --------- | -------- | ----- | -------------- |
| 설정 ID  | id           | 식별자   | SERIAL    | NOT NULL |       | PK             |
| 사용자 ID | user\_id     | 외래키   | UUID      | NOT NULL |       | FK -> users.id |
| 이메일 알림 | email\_alert | 알림 동의 | BOOLEAN   | NOT NULL | TRUE  | 이메일 알림 수신 여부   |
| SMS 알림 | sms\_alert   | 알림 동의 | BOOLEAN   | NOT NULL | FALSE | SMS 알림 수신 여부   |
| 푸시 알림  | push\_alert  | 알림 동의 | BOOLEAN   | NOT NULL | TRUE  | 앱 푸시 알림 수신 여부  |
| 생성일시   | created\_at  | 생성일   | TIMESTAMP | NOT NULL | now() |                |
| 수정일시   | updated\_at  | 수정일   | TIMESTAMP | NULL     |       |                |

---

### 📋 게시판 / `boards`

| 논리 필드명  | 물리 필드명      | 도메인 | 타입      | NULL 유무  | 기본값  | 코멘트              |
| ------- | ----------- | --- | ------- | -------- | ---- | ---------------- |
| 게시판 ID  | id          | 식별자 | SERIAL  | NOT NULL |      | PK               |
| 학교 ID   | school\_id  | 외래키 | INT     | NOT NULL |      | FK -> schools.id |
| 게시판명    | name        | 이름  | VARCHAR | NOT NULL |      | 학교별 UNIQUE       |
| 설명      | description | 소개글 | TEXT    | NULL     |      |                  |
| 공개 여부   | is\_public  | 플래그 | BOOLEAN | NOT NULL | TRUE | 공개 여부            |
| 정렬 우선순위 | sort\_order | 정렬값 | INT     | NULL     |      |                  |

---

### 📝 게시글 / `posts`

| 논리 필드명 | 물리 필드명              | 도메인   | 타입                                | NULL 유무  | 기본값      | 코멘트             |
| ------ | ------------------- | ----- | --------------------------------- | -------- | -------- | --------------- |
| 게시글 ID | id                  | 식별자   | UUID                              | NOT NULL |          | PK              |
| 게시판 ID | board\_id           | 외래키   | INT                               | NOT NULL |          | FK -> boards.id |
| 작성자 ID | user\_id            | 외래키   | UUID                              | NOT NULL |          | FK -> users.id  |
| 제목     | title               | 제목    | VARCHAR                           | NOT NULL |          |                 |
| 본문     | content             | 내용    | TEXT                              | NOT NULL |          |                 |
| 익명 여부  | anonymous\_flag     | 플래그   | BOOLEAN                           | NOT NULL | TRUE     |                 |
| 익명 닉네임 | anonymous\_nickname | 표시명   | VARCHAR                           | NULL     |          | 예: 익명1          |
| 좋아요 수  | likes\_count        | 캐싱 수치 | INT                               | NOT NULL | 0        |                 |
| 조회수    | view\_count         | 캐싱 수치 | INT                               | NOT NULL | 0        |                 |
| 댓글 수   | comment\_count      | 캐싱 수치 | INT                               | NOT NULL | 0        |                 |
| 상태     | status              | 상태    | ENUM('ACTIVE','DELETED','HIDDEN') | NOT NULL | 'ACTIVE' |                 |
| 고정 여부  | is\_pinned          | 플래그   | BOOLEAN                           | NOT NULL | FALSE    | 공지 고정 여부        |
| 작성일시   | created\_at         | 생성일   | TIMESTAMP                         | NOT NULL | now()    |                 |
| 수정일시   | updated\_at         | 수정일   | TIMESTAMP                         | NULL     |          |                 |

---

### 💬 댓글 / `comments`

| 논리 필드명   | 물리 필드명              | 도메인   | 타입        | NULL 유무  | 기본값   | 코멘트            |
| -------- | ------------------- | ----- | --------- | -------- | ----- | -------------- |
| 댓글 ID    | id                  | 식별자   | UUID      | NOT NULL |       | PK             |
| 게시글 ID   | post\_id            | 외래키   | UUID      | NOT NULL |       | FK -> posts.id |
| 작성자 ID   | user\_id            | 외래키   | UUID      | NOT NULL |       | FK -> users.id |
| 부모 댓글 ID | parent\_comment\_id | 외래키   | UUID      | NULL     |       | NULL이면 최상위 댓글  |
| 내용       | content             | 내용    | TEXT      | NOT NULL |       |                |
| 익명 여부    | anonymous\_flag     | 플래그   | BOOLEAN   | NOT NULL | TRUE  |                |
| 익명 닉네임   | anonymous\_nickname | 표시명   | VARCHAR   | NULL     |       | 예: 익명1         |
| 좋아요 수    | likes\_count        | 캐싱 수치 | INT       | NOT NULL | 0     |                |
| 작성일시     | created\_at         | 생성일   | TIMESTAMP | NOT NULL | now() |                |

---

### 👍 게시글 좋아요 / `post_likes`

| 논리 필드명   | 물리 필드명                     | 도메인 | 타입        | NULL 유무  | 기본값   | 코멘트            |
| -------- | -------------------------- | --- | --------- | -------- | ----- | -------------- |
| 고유 ID    | id                         | 식별자 | SERIAL    | NOT NULL |       | PK             |
| 게시글 ID   | post\_id                   | 외래키 | UUID      | NOT NULL |       | FK -> posts.id |
| 사용자 ID   | user\_id                   | 외래키 | UUID      | NOT NULL |       | FK -> users.id |
| 좋아요 일시   | created\_at                | 생성일 | TIMESTAMP | NOT NULL | now() |                |
| 중복 방지 제약 | UNIQUE(post\_id, user\_id) | -   | -         |          |       | 복합 유니크         |

---

### ❤️ 댓글 좋아요 / `comment_likes`

| 논리 필드명   | 물리 필드명                        | 도메인 | 타입        | NULL 유무  | 기본값   | 코멘트               |
| -------- | ----------------------------- | --- | --------- | -------- | ----- | ----------------- |
| 고유 ID    | id                            | 식별자 | SERIAL    | NOT NULL |       | PK                |
| 댓글 ID    | comment\_id                   | 외래키 | UUID      | NOT NULL |       | FK -> comments.id |
| 사용자 ID   | user\_id                      | 외래키 | UUID      | NOT NULL |       | FK -> users.id    |
| 좋아요 일시   | created\_at                   | 생성일 | TIMESTAMP | NOT NULL | now() |                   |
| 중복 방지 제약 | UNIQUE(comment\_id, user\_id) | -   | -         |          |       | 복합 유니크            |

---

### 🤖 AI 채팅 세션 / `chat_sessions`

| 논리 필드명     | 물리 필드명            | 도메인 | 타입        | NULL 유무  | 기본값   | 코멘트            |
| ---------- | ----------------- | --- | --------- | -------- | ----- | -------------- |
| 세션 ID      | id                | 식별자 | UUID      | NOT NULL |       | PK             |
| 사용자 ID     | user\_id          | 외래키 | UUID      | NOT NULL |       | FK -> users.id |
| 세션 제목      | title             | 제목  | VARCHAR   | NULL     |       | 사용자가 설정 가능     |
| 생성일시       | created\_at       | 생성일 | TIMESTAMP | NOT NULL | now() |                |
| 마지막 메시지 시각 | last\_message\_at | 시각  | TIMESTAMP | NULL     |       |                |
| 메시지 수      | message\_count    | 개수  | INT       | NOT NULL | 0     |                |

---

### 🤖 AI 대화 로그 / `chat_logs`

| 논리 필드명   | 물리 필드명      | 도메인   | 타입        | NULL 유무  | 기본값   | 코멘트                     |
| -------- | ----------- | ----- | --------- | -------- | ----- | ----------------------- |
| 대화 로그 ID | id          | 식별자   | UUID      | NOT NULL |       | PK                      |
| 세션 ID    | session\_id | 외래키   | UUID      | NOT NULL |       | FK -> chat\_sessions.id |
| 질문       | question    | 입력    | TEXT      | NOT NULL |       |                         |
| 응답       | answer      | 출력    | TEXT      | NOT NULL |       | GPT 응답 내용               |
| 요약 응답    | summary     | 카드 요약 | TEXT      | NULL     |       | 선택적                     |
| 출처       | source      | 관련 자료 | JSONB     | NULL     |       | 관련 게시글 ID, 링크 등         |
| 생성일시     | created\_at | 생성일   | TIMESTAMP | NOT NULL | now() |                         |

---

### 📁 파일 정보 / `files`

\| 논리 필드명       | 물리 필드명     | 도메인          | 타입      | NULL 유무 | 기본값 | 코멘트                 |
\|------------------|----------------|


\-----------------|-----------|-----------|--------|------------------------|
\| 파일 ID          | id             | 식별자          | UUID      | NOT NULL  |        | PK                     |
\| 업로더 ID        | uploader\_id    | 외래키          | UUID      | NOT NULL  |        | FK -> users.id         |
\| 원본 파일명      | original\_name  | 문자열          | VARCHAR   | NOT NULL  |        |                        |
\| 저장 파일명      | stored\_name    | 문자열          | VARCHAR   | NOT NULL  |        | 실제 저장된 파일명     |
\| 파일 크기        | file\_size      | 바이트          | BIGINT    | NOT NULL  |        |                        |
\| MIME 타입        | mime\_type      | 문자열          | VARCHAR   | NOT NULL  |        | ex: image/png          |
\| 저장 URL         | s3\_url         | URL             | VARCHAR   | NOT NULL  |        | AWS S3 URL 등           |
\| 파일 타입        | file\_type      | ENUM            | ENUM('IMAGE','DOCUMENT','VIDEO','AUDIO','OTHER') | NOT NULL | 'OTHER' |  |
\| 업로드일시       | created\_at     | TIMESTAMP       | TIMESTAMP | NOT NULL  | now()  |                        |

---

### 📁 게시글-파일 연결 / `post_files`

| 논리 필드명 | 물리 필드명      | 도메인 | 타입     | NULL 유무  | 기본값 | 코멘트            |
| ------ | ----------- | --- | ------ | -------- | --- | -------------- |
| 연결 ID  | id          | 식별자 | SERIAL | NOT NULL |     | PK             |
| 게시글 ID | post\_id    | 외래키 | UUID   | NOT NULL |     | FK -> posts.id |
| 파일 ID  | file\_id    | 외래키 | UUID   | NOT NULL |     | FK -> files.id |
| 정렬 순서  | sort\_order | 순서  | INT    | NOT NULL | 0   | 표시 순서          |

---

### 🔔 알림 / `notifications`

| 논리 필드명    | 물리 필드명        | 도메인       | 타입                                                                            | NULL 유무  | 기본값   | 코멘트               |
| --------- | ------------- | --------- | ----------------------------------------------------------------------------- | -------- | ----- | ----------------- |
| 알림 ID     | id            | 식별자       | UUID                                                                          | NOT NULL |       | PK                |
| 수신자 ID    | user\_id      | 외래키       | UUID                                                                          | NOT NULL |       | FK -> users.id    |
| 알림 유형     | type          | ENUM      | ENUM('POST\_LIKE','COMMENT\_LIKE','COMMENT\_REPLY','MENTION','ADMIN\_NOTICE') | NOT NULL |       |                   |
| 제목        | title         | 문자열       | VARCHAR                                                                       | NOT NULL |       |                   |
| 내용        | content       | 텍스트       | TEXT                                                                          | NOT NULL |       |                   |
| 관련 엔티티 ID | related\_id   | UUID      | UUID                                                                          | NULL     |       | 게시글, 댓글, 사용자 ID 등 |
| 관련 엔티티 타입 | related\_type | ENUM      | ENUM('POST','COMMENT','USER')                                                 | NULL     |       | 관련 엔티티 타입         |
| 읽음 여부     | is\_read      | BOOLEAN   | BOOLEAN                                                                       | NOT NULL | FALSE |                   |
| 생성일시      | created\_at   | TIMESTAMP | TIMESTAMP                                                                     | NOT NULL | now() |                   |
| 읽은 일시     | read\_at      | TIMESTAMP | TIMESTAMP                                                                     | NULL     |       |                   |

---

### 🚩 신고 / `reports`

| 논리 필드명  | 물리 필드명       | 도메인       | 타입                                               | NULL 유무  | 기본값       | 코멘트                  |
| ------- | ------------ | --------- | ------------------------------------------------ | -------- | --------- | -------------------- |
| 신고 ID   | id           | 식별자       | UUID                                             | NOT NULL |           | PK                   |
| 신고자 ID  | reporter\_id | 외래키       | UUID                                             | NOT NULL |           | FK -> users.id       |
| 대상 타입   | target\_type | ENUM      | ENUM('POST','COMMENT','USER')                    | NOT NULL |           | 신고 대상 유형             |
| 대상 ID   | target\_id   | UUID      | UUID                                             | NOT NULL |           | 신고 대상 ID             |
| 신고 사유   | reason       | 텍스트       | TEXT                                             | NOT NULL |           |                      |
| 처리 상태   | status       | ENUM      | ENUM('PENDING','REVIEWED','RESOLVED','REJECTED') | NOT NULL | 'PENDING' | 신고 처리 상태             |
| 처리자 ID  | handled\_by  | UUID      | UUID                                             | NULL     |           | FK -> users.id (관리자) |
| 처리 일시   | handled\_at  | TIMESTAMP | TIMESTAMP                                        | NULL     |           |                      |
| 신고 생성일시 | created\_at  | TIMESTAMP | TIMESTAMP                                        | NOT NULL | now()     |                      |

---

### 🏷️ 태그 / `tags`

| 논리 필드명 | 물리 필드명       | 도메인       | 타입        | NULL 유무  | 기본값   | 코멘트      |
| ------ | ------------ | --------- | --------- | -------- | ----- | -------- |
| 태그 ID  | id           | 식별자       | SERIAL    | NOT NULL |       | PK       |
| 태그명    | name         | 문자열       | VARCHAR   | NOT NULL |       | UNIQUE   |
| 사용 횟수  | usage\_count | 숫자        | INT       | NOT NULL | 0     | 태그 사용 횟수 |
| 생성일    | created\_at  | TIMESTAMP | TIMESTAMP | NOT NULL | now() |          |

---

### 🏷️ 게시글-태그 연결 / `post_tags`

| 논리 필드명 | 물리 필드명   | 도메인  | 타입     | NULL 유무  | 기본값 | 코멘트            |
| ------ | -------- | ---- | ------ | -------- | --- | -------------- |
| 연결 ID  | id       | 식별자  | SERIAL | NOT NULL |     | PK             |
| 게시글 ID | post\_id | UUID | UUID   | NOT NULL |     | FK -> posts.id |
| 태그 ID  | tag\_id  | INT  | INT    | NOT NULL |     | FK -> tags.id  |

---

### 📊 사용자 활동 로그 / `user_activity_logs`

| 논리 필드명 | 물리 필드명       | 도메인       | 타입                                                                                   | NULL 유무  | 기본값   | 코멘트               |
| ------ | ------------ | --------- | ------------------------------------------------------------------------------------ | -------- | ----- | ----------------- |
| 로그 ID  | id           | UUID      | UUID                                                                                 | NOT NULL |       | PK                |
| 사용자 ID | user\_id     | UUID      | UUID                                                                                 | NOT NULL |       | FK -> users.id    |
| 액션 타입  | action\_type | ENUM      | ENUM('LOGIN','LOGOUT','POST\_CREATE','POST\_VIEW','COMMENT\_CREATE','CHAT\_MESSAGE') | NOT NULL |       | 행동 종류             |
| 대상 ID  | target\_id   | UUID      | UUID                                                                                 | NULL     |       | 대상 엔티티 ID (게시글 등) |
| 메타데이터  | metadata     | JSONB     | JSONB                                                                                | NULL     |       | 세부 정보             |
| 생성일시   | created\_at  | TIMESTAMP | TIMESTAMP                                                                            | NOT NULL | now() |                   |

---

## 🛠️ 테이블 간 관계 (FK)

* `departments.school_id` → `schools.id`
* `users.school_id` → `schools.id`
* `users.department_id` → `departments.id`
* `user_consents.user_id` → `users.id`
* `user_notifications.user_id` → `users.id`
* `boards.school_id` → `schools.id`
* `posts.board_id` → `boards.id`
* `posts.user_id` → `users.id`
* `comments.post_id` → `posts.id`
* `comments.user_id` → `users.id`
* `comments.parent_comment_id` → `comments.id` (재귀관계)
* `post_likes.post_id` → `posts.id`
* `post_likes.user_id` → `users.id`
* `comment_likes.comment_id` → `comments.id`
* `comment_likes.user_id` → `users.id`
* `chat_sessions.user_id` → `users.id`
* `chat_logs.session_id` → `chat_sessions.id`
* `files.uploader_id` → `users.id`
* `post_files.post_id` → `posts.id`
* `post_files.file_id` → `files.id`
* `notifications.user_id` → `users.id`
* `reports.reporter_id` → `users.id`
* `reports.handled_by` → `users.id`
* `post_tags.post_id` → `posts.id`
* `post_tags.tag_id` → `tags.id`
* `user_activity_logs.user_id` → `users.id`

---
