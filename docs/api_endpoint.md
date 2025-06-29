## ✅ 1. 인증 및 사용자 관리 (Auth + Users)

---

## 🧑‍🎓 2. 학교 및 학과

| Method | Endpoint | 설명 |
| --- | --- | --- |
| `GET` | `/api/schools` | 학교 리스트 조회 |
| `GET` | `/api/schools/{schoolId}` | 특정 학교 상세 조회 |
| `GET` | `/api/schools/{schoolId}/departments` | 해당 학교 학과 리스트 조회 |

---

## 🗣 3. 커뮤니티 (게시판, 게시글, 댓글)

### 📋 게시판 (Boards)

| Method | Endpoint | 설명 |
| --- | --- | --- |
| `GET` | `/api/boards` | 전체 게시판 리스트 조회 |
| `GET` | `/api/boards/{boardId}` | 특정 게시판 상세 조회 |

### 📝 게시글 (Posts)

| Method | Endpoint | 설명 |
| --- | --- | --- |
| `GET` | `/api/boards/{boardId}/posts` | 게시판 내 글 목록 조회 |
| `POST` | `/api/boards/{boardId}/posts` | 게시판에 새 글 작성 |
| `GET` | `/api/posts/{postId}` | 게시글 상세 조회 |
| `PATCH` | `/api/posts/{postId}` | 게시글 수정 |
| `DELETE` | `/api/posts/{postId}` | 게시글 삭제 |
| `POST` | `/api/posts/{postId}/like` | 게시글 좋아요 |
| `DELETE` | `/api/posts/{postId}/like` | 좋아요 취소 |

### 💬 댓글 (Comments)

| Method | Endpoint | 설명 |
| --- | --- | --- |
| `GET` | `/api/posts/{postId}/comments` | 댓글 조회 (트리뷰 구조) |
| `POST` | `/api/posts/{postId}/comments` | 댓글 작성 |
| `PATCH` | `/api/comments/{commentId}` | 댓글 수정 |
| `DELETE` | `/api/comments/{commentId}` | 댓글 삭제 |
| `POST` | `/api/comments/{commentId}/like` | 댓글 좋아요 |
| `DELETE` | `/api/comments/{commentId}/like` | 좋아요 취소 |

---

## 🤖 4. AI 챗봇 (Chat)

| Method | Endpoint | 설명 |
| --- | --- | --- |
| `GET` | `/api/chat/sessions` | 나의 채팅 세션 리스트 조회 |
| `POST` | `/api/chat/sessions` | 새 채팅 세션 시작 |
| `GET` | `/api/chat/sessions/{sessionId}` | 세션 내 전체 채팅 로그 조회 |
| `POST` | `/api/chat/sessions/{sessionId}/messages` | 질문 전송 → GPT 응답 반환 |
| `GET` | `/api/chat/sessions/{sessionId}/messages/{messageId}` | 단일 대화 조회 |

---

## ❤️ 5. 스크랩/좋아요/통계

| Method | Endpoint | 설명 |
| --- | --- | --- |
| `GET` | `/api/users/me/likes/posts` | 내가 좋아요한 게시글 |
| `GET` | `/api/users/me/likes/comments` | 내가 좋아요한 댓글 |
| `GET` | `/api/users/me/posts` | 내가 작성한 글 |
| `GET` | `/api/users/me/comments` | 내가 작성한 댓글 |

---

## 📊 6. 관리자 (옵션, 권한 필요)

| Method | Endpoint | 설명 |
| --- | --- | --- |
| `GET` | `/api/admin/users` | 전체 사용자 목록 조회 |
| `PATCH` | `/api/admin/users/{userId}/ban` | 유저 정지 처리 |
| `DELETE` | `/api/admin/posts/{postId}` | 게시글 강제 삭제 |
| `DELETE` | `/api/admin/comments/{commentId}` | 댓글 강제 삭제 |