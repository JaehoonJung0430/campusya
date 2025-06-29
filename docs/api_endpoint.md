# 🔗 CampusYA API 엔드포인트 명세

## 🔐 1. 인증 및 사용자 관리 (Auth + Users)

### 🔑 인증 (Authentication)

| Method | Endpoint | 설명 | Request Body | Response |
| --- | --- | --- | --- | --- |
| `POST` | `/api/auth/register` | 회원가입 | `{email, password, nickname, schoolId, departmentId, birthDate, gender, admissionYear, studentNumber}` | `{token, user}` |
| `POST` | `/api/auth/login` | 로그인 | `{email, password}` | `{token, user}` |
| `POST` | `/api/auth/logout` | 로그아웃 | - | `{message}` |
| `POST` | `/api/auth/refresh` | 토큰 갱신 | `{refreshToken}` | `{token}` |
| `POST` | `/api/auth/verify-email` | 이메일 인증 | `{email, verificationCode}` | `{verified}` |
| `POST` | `/api/auth/send-verification` | 인증 메일 발송 | `{email}` | `{sent}` |

### 👤 사용자 관리 (Users)

| Method | Endpoint | 설명 | Request Body | Response |
| --- | --- | --- | --- | --- |
| `GET` | `/api/users/me` | 내 정보 조회 | - | `{user}` |
| `PATCH` | `/api/users/me` | 내 정보 수정 | `{nickname?, birthDate?, gender?, profile_image_url?, bio?}` | `{user}` |
| `DELETE` | `/api/users/me` | 회원탈퇴 | `{password}` | `{deleted}` |
| `GET` | `/api/users/me/stats` | 내 활동 통계 | - | `{postsCount, commentsCount, likesCount}` |

---

## 🧑‍🎓 2. 학교 및 학과

| Method | Endpoint | 설명 | Query Params | Response |
| --- | --- | --- | --- | --- |
| `GET` | `/api/schools` | 학교 리스트 조회 | `search?` | `{schools[]}` |
| `GET` | `/api/schools/{schoolId}` | 특정 학교 상세 조회 | - | `{school, departments[]}` |
| `GET` | `/api/schools/{schoolId}/departments` | 해당 학교 학과 리스트 조회 | - | `{departments[]}` |

---

## 🗣 3. 커뮤니티 (게시판, 게시글, 댓글)

### 📋 게시판 (Boards)

| Method | Endpoint | 설명 | Query Params | Response |
| --- | --- | --- | --- | --- |
| `GET` | `/api/boards` | 전체 게시판 리스트 조회 | `schoolId?` | `{boards[]}` |
| `GET` | `/api/boards/{boardId}` | 특정 게시판 상세 조회 | - | `{board, stats}` |

### 📝 게시글 (Posts)

| Method | Endpoint | 설명 | Query Params | Request Body | Response |
| --- | --- | --- | --- | --- | --- |
| `GET` | `/api/boards/{boardId}/posts` | 게시판 내 글 목록 조회 | `page?, size?, sort?` | - | `{posts[], totalElements, totalPages}` |
| `POST` | `/api/boards/{boardId}/posts` | 게시판에 새 글 작성 | - | `{title, content, anonymousFlag, files?}` | `{post}` |
| `GET` | `/api/posts/{postId}` | 게시글 상세 조회 | - | - | `{post, comments[]}` |
| `PATCH` | `/api/posts/{postId}` | 게시글 수정 | - | `{title?, content?}` | `{post}` |
| `DELETE` | `/api/posts/{postId}` | 게시글 삭제 | - | - | `{deleted}` |
| `POST` | `/api/posts/{postId}/like` | 게시글 좋아요 | - | - | `{liked, likesCount}` |
| `DELETE` | `/api/posts/{postId}/like` | 좋아요 취소 | - | - | `{unliked, likesCount}` |
| `GET` | `/api/posts/search` | 게시글 검색 | `q, boardId?, page?, size?` | - | `{posts[], totalElements}` |

### 💬 댓글 (Comments)

| Method | Endpoint | 설명 | Query Params | Request Body | Response |
| --- | --- | --- | --- | --- | --- |
| `GET` | `/api/posts/{postId}/comments` | 댓글 조회 (트리뷰 구조) | `page?, size?` | - | `{comments[], totalElements}` |
| `POST` | `/api/posts/{postId}/comments` | 댓글 작성 | - | `{content, parentCommentId?, anonymousFlag}` | `{comment}` |
| `PATCH` | `/api/comments/{commentId}` | 댓글 수정 | - | `{content}` | `{comment}` |
| `DELETE` | `/api/comments/{commentId}` | 댓글 삭제 | - | - | `{deleted}` |
| `POST` | `/api/comments/{commentId}/like` | 댓글 좋아요 | - | - | `{liked, likesCount}` |
| `DELETE` | `/api/comments/{commentId}/like` | 좋아요 취소 | - | - | `{unliked, likesCount}` |

---

## 🤖 4. AI 챗봇 (Chat)

| Method | Endpoint | 설명 | Query Params | Request Body | Response |
| --- | --- | --- | --- | --- | --- |
| `GET` | `/api/chat/sessions` | 나의 채팅 세션 리스트 조회 | `page?, size?` | - | `{sessions[], totalElements}` |
| `POST` | `/api/chat/sessions` | 새 채팅 세션 시작 | - | `{title?}` | `{session}` |
| `GET` | `/api/chat/sessions/{sessionId}` | 세션 내 전체 채팅 로그 조회 | `page?, size?` | - | `{messages[], totalElements}` |
| `POST` | `/api/chat/sessions/{sessionId}/messages` | 질문 전송 → GPT 응답 반환 | - | `{question, attachments?}` | `{message, response}` |
| `GET` | `/api/chat/sessions/{sessionId}/messages/{messageId}` | 단일 대화 조회 | - | - | `{message}` |
| `DELETE` | `/api/chat/sessions/{sessionId}` | 채팅 세션 삭제 | - | - | `{deleted}` |

---

## 📁 5. 파일 관리

| Method | Endpoint | 설명 | Request Body | Response |
| --- | --- | --- | --- | --- |
| `POST` | `/api/files/upload` | 파일 업로드 (이미지, PDF 등) | `multipart/form-data` | `{fileUrl, fileName, fileSize}` |
| `DELETE` | `/api/files/{fileId}` | 파일 삭제 | - | `{deleted}` |

---

## ❤️ 6. 스크랩/좋아요/통계

| Method | Endpoint | 설명 | Query Params | Response |
| --- | --- | --- | --- | --- |
| `GET` | `/api/users/me/likes/posts` | 내가 좋아요한 게시글 | `page?, size?` | `{posts[], totalElements}` |
| `GET` | `/api/users/me/likes/comments` | 내가 좋아요한 댓글 | `page?, size?` | `{comments[], totalElements}` |
| `GET` | `/api/users/me/posts` | 내가 작성한 글 | `page?, size?` | `{posts[], totalElements}` |
| `GET` | `/api/users/me/comments` | 내가 작성한 댓글 | `page?, size?` | `{comments[], totalElements}` |

---

## 🔔 7. 알림 (Notifications)

| Method | Endpoint | 설명 | Query Params | Response |
| --- | --- | --- | --- | --- |
| `GET` | `/api/notifications` | 내 알림 목록 조회 | `page?, size?, unreadOnly?` | `{notifications[], totalElements}` |
| `PATCH` | `/api/notifications/{notificationId}/read` | 알림 읽음 처리 | - | `{notification}` |
| `PATCH` | `/api/notifications/read-all` | 모든 알림 읽음 처리 | - | `{readCount}` |
| `DELETE` | `/api/notifications/{notificationId}` | 알림 삭제 | - | `{deleted}` |

---

## 📊 8. 관리자 (Admin, 권한 필요)

| Method | Endpoint | 설명 | Query Params | Request Body | Response |
| --- | --- | --- | --- | --- | --- |
| `GET` | `/api/admin/users` | 전체 사용자 목록 조회 | `page?, size?, search?, status?` | - | `{users[], totalElements}` |
| `PATCH` | `/api/admin/users/{userId}/ban` | 유저 정지 처리 | - | `{reason, duration}` | `{user}` |
| `PATCH` | `/api/admin/users/{userId}/unban` | 유저 정지 해제 | - | - | `{user}` |
| `DELETE` | `/api/admin/posts/{postId}` | 게시글 강제 삭제 | - | `{reason}` | `{deleted}` |
| `DELETE` | `/api/admin/comments/{commentId}` | 댓글 강제 삭제 | - | `{reason}` | `{deleted}` |
| `GET` | `/api/admin/reports` | 신고 목록 조회 | `page?, size?, status?` | - | `{reports[], totalElements}` |
| `PATCH` | `/api/admin/reports/{reportId}` | 신고 처리 | - | `{action, reason}` | `{report}` |

---

## 🔍 9. 검색

| Method | Endpoint | 설명 | Query Params | Response |
| --- | --- | --- | --- | --- |
| `GET` | `/api/search` | 통합 검색 | `q, type?, boardId?, page?, size?` | `{results[], totalElements, type}` |
| `GET` | `/api/search/suggestions` | 검색 자동완성 | `q` | `{suggestions[]}` |

---

## 📱 10. 앱 버전 관리

| Method | Endpoint | 설명 | Response |
| --- | --- | --- | --- |
| `GET` | `/api/app/version` | 앱 버전 정보 | `{version, minVersion, updateRequired, updateUrl}` |
| `GET` | `/api/app/config` | 앱 설정 정보 | `{features, maintenanceMode, notices[]}` |

---

## 🏥 11. 헬스체크

| Method | Endpoint | 설명 | Response |
| --- | --- | --- | --- |
| `GET` | `/api/health` | 서버 상태 확인 | `{status, timestamp, services}` |
| `GET` | `/api/health/db` | 데이터베이스 연결 확인 | `{status, responseTime}` |