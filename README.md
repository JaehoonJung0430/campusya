
# 🎓 CampusYA

> **전국 대학생 대상 AI 기반 캠퍼스 통합 앱**
> (🚀 초기 MVP: 홍익대학교 서울캠퍼스 전용)

---

## 📌 소개

CampusYA는 대학생활의 모든 것을 하나의 앱으로 통합하는 AI 마스코트 기반 캠퍼스 플랫폼입니다.
AI 챗봇, 커뮤니티, 학사 일정, 맛집, 족보, 공지 등 실시간 정보를 제공합니다.

---

## 🧱 프로젝트 구조

```
campusya/
├── backend/               # Spring Boot 백엔드 서버
│   └── src/main/resources/application.yml
├── frontend/              # React Native (Expo) 프론트
│   └── app/
├── crawler/               # 크롤링 스크립트 (Python)
├── setup-scripts/         # 초기화 셸 스크립트 (DB 등)
├── docker/                # Docker 설정
├── .github/workflows/     # GitHub Actions CI/CD
└── README.md
```

---

## 🧩 핵심 기능 (MVP 기준)

| 모듈          | 기능 요약                            |
| ----------- | -------------------------------- |
| 🤖 AI 챗봇 와우 | GPT 기반 챗봇, 학사/족보/공지 연동, 요약/링크 응답 |
| 🗣 커뮤니티     | 익명 게시판, 댓글, 반응 기능, 욕설 필터링        |
| 🔒 사용자 시스템  | 대학 이메일 인증, 프로필 설정, 알림 설정         |
| 📋 게시판      | 자유, 공부자료, 맛집, 공모전 등              |
| ❤️ 족보 업로드   | 파일 저장 (S3), 글+PDF 업로드            |
| 📡 알림       | FCM 기반 푸시 알림                     |
| 🛠 관리자      | 글/댓글 관리, 신고 누적, 정지 처리 등          |

---

## ⚙️ 기술 스택

| 분야          | 사용 기술                                                |
| ----------- | ---------------------------------------------------- |
| **프론트엔드**   | React Native (Expo), TypeScript, Zustand, NativeWind |
| **디자인 시스템** | Figma 기반, Tailwind 유사 설계                             |
| **백엔드**     | Spring Boot 3.2+, JPA, QueryDSL, JWT                 |
| **데이터베이스**  | PostgreSQL + Redis, PGVector                         |
| **AI 기능**   | OpenAI API + LangChain                               |
| **크롤러**     | Python + BeautifulSoup/Selenium                      |
| **배포 인프라**  | Docker + EC2 + RDS + S3 + CloudFront                 |
| **CI/CD**   | GitHub Actions + DockerHub                           |
| **모니터링**    | Logback, Sentry, Prometheus, Grafana                 |

---

## 🖥 개발 환경

| 환경                 | 설명                                     |
| ------------------ | -------------------------------------- |
| 📦 개발 플랫폼          | GitHub Codespaces 사용 (설치 없는 클라우드 개발환경) |
| 🔐 CLI 전용 DB 클라이언트 | `psql`                                 |
| ⚠️ 군 환경 특성상        | 설치 파일 다운로드 불가 → Codespaces에 모든 환경 구축   |

---

## 🚀 실행 방법 (Codespaces 기준)

### ✅ 1. PostgreSQL 설치 및 초기화

```bash
bash ./setup-scripts/setup-db.sh
```

* DB 이름: `campusya_db`
* 사용자: `campusya_user`
* 비밀번호: `campusya_pass`

자동으로 PostgreSQL을 설치하고, 사용자 및 DB를 생성합니다.

### ✅ 2. 백엔드 실행

```bash
cd backend
./gradlew bootRun
```

* `application.yml`에서 DB 설정을 확인하세요.

### ✅ 3. 프론트엔드 앱 실행 (Expo)

```bash
cd frontend
npm install
npx expo start
```

* Expo Go 앱으로 QR코드 스캔하여 모바일 테스트 가능

---

## 🗂 환경 변수 예시

> `.env` 또는 `application.yml`에 사용

### 🔧 `.env.example`

```
EXPO_PUBLIC_API_URL=http://localhost:8080
OPENAI_API_KEY=sk-xxxx
```

---

## 🧠 AI 챗봇 구성

* System Prompt: 홍익대학교 마스코트 ‘와우’의 성격 반영
* 데이터 연결: 게시판/맛집/학사일정/족보/공지 DB
* 응답 유형: 카드, 요약, 링크, 문서 응답
* 세션 및 학습 기반: Redis + PostgreSQL 저장

---

## 💾 데이터베이스 ERD (요약)

> 전체 ERD는 `/docs/ERD.md` 참고

| 주요 테이블                    | 설명                    |
| ------------------------- | --------------------- |
| `users`                   | 사용자 정보 (학교, 학과, 권한 등) |
| `posts`                   | 게시글 정보 (익명 포함)        |
| `comments`                | 트리형 댓글                |
| `chat_logs`               | AI 챗봇 대화 로그           |
| `boards`                  | 게시판 정의                |
| `schools` / `departments` | 캠퍼스 구조화               |
| `likes`                   | 좋아요 기록                |

---

## 🛠️ 테스트

### 백엔드 테스트

```bash
./gradlew test
```

### 프론트 테스트

```bash
npm test
```

---

## 🚢 배포 구성

| 구성요소      | 기술                               |
| --------- | -------------------------------- |
| 백엔드       | Docker + EC2                     |
| 프론트 정적 자산 | S3 + CloudFront                  |
| DB        | RDS (PostgreSQL)                 |
| AI 모델     | OpenAI API                       |
| 도메인/SSL   | Route 53 + ACM                   |
| CI/CD     | GitHub Actions → DockerHub 자동 빌드 |

---

## 📌 기여 가이드

1. `develop` 브랜치 기반으로 기능 브랜치 생성
2. PR 시, 관련 이슈 번호 & 테스트 코드 포함
3. 커밋 메시지 Convention 유지

---

## 🪪 라이선스

MIT License © 2025 CampusYA Team

---

