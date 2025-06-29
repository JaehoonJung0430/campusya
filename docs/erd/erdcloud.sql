CREATE TABLE `schools` (
	`id`	SERIAL	NOT NULL	COMMENT 'PK',
	`name`	VARCHAR	NOT NULL	COMMENT '예: 홍익대학교',
	`campus`	VARCHAR	NOT NULL	COMMENT '예: 서울캠퍼스',
	`domain`	VARCHAR	NULL	COMMENT '예: hongik.ac.kr (UNIQUE)'
);

CREATE TABLE `departments` (
	`id`	SERIAL	NOT NULL	COMMENT 'PK',
	`school_id`	INT	NOT NULL	COMMENT 'FK -> schools.id',
	`name`	VARCHAR	NOT NULL
);

CREATE TABLE `users` (
	`id`	UUID	NOT NULL	COMMENT 'PK',
	`school_id`	INT	NOT NULL	COMMENT 'FK -> schools.id',
	`department_id`	INT	NOT NULL	COMMENT 'FK -> departments.id',
	`email`	VARCHAR	NOT NULL	COMMENT 'UNIQUE',
	`password`	VARCHAR	NOT NULL	COMMENT '암호화 저장 (bcrypt)',
	`nickname`	VARCHAR	NOT NULL,
	`role`	ENUM('USER','ADMIN','MODERATOR')	NOT NULL	DEFAULT 'USER',
	`status`	ENUM('ACTIVE','BANNED','DELETED')	NOT NULL	DEFAULT 'ACTIVE',
	`birth_date`	DATE	NOT NULL,
	`gender`	ENUM('MALE','FEMALE','OTHER')	NOT NULL,
	`admission_year`	SMALLINT	NOT NULL	COMMENT '예: 2023 (23학번 의미)',
	`student_number`	VARCHAR	NOT NULL	COMMENT '예: C311158 등 숫자 또는 문자 포함 가능',
	`created_at`	TIMESTAMP	NOT NULL	DEFAULT now(),
	`updated_at`	TIMESTAMP	NULL
);

CREATE TABLE `boards` (
	`id`	SERIAL	NOT NULL	COMMENT 'PK',
	`school_id`	INT	NOT NULL	COMMENT 'FK -> schools.id',
	`name`	VARCHAR	NOT NULL	COMMENT 'UNIQUE per school',
	`description`	TEXT	NULL,
	`is_public`	BOOLEAN	NOT NULL	DEFAULT TRUE	COMMENT '공개 여부',
	`sort_order`	INT	NULL
);

CREATE TABLE `posts` (
	`id`	UUID	NOT NULL	COMMENT 'PK',
	`board_id`	INT	NOT NULL	COMMENT 'FK -> boards.id',
	`user_id`	UUID	NOT NULL	COMMENT 'FK -> users.id',
	`title`	VARCHAR	NOT NULL,
	`content`	TEXT	NOT NULL,
	`anonymous_flag`	BOOLEAN	NOT NULL	DEFAULT TRUE,
	`anonymous_nickname`	VARCHAR	NULL	COMMENT '예: 익명1, 익명2',
	`likes_count`	INT	NOT NULL	DEFAULT 0,
	`created_at`	TIMESTAMP	NOT NULL	DEFAULT now(),
	`updated_at`	TIMESTAMP	NULL
);

CREATE TABLE `comments` (
	`id`	UUID	NOT NULL	COMMENT 'PK',
	`post_id`	UUID	NOT NULL	COMMENT 'FK -> posts.id',
	`user_id`	UUID	NOT NULL	COMMENT 'FK -> users.id',
	`parent_comment_id`	UUID	NULL	COMMENT 'NULL이면 일반 댓글',
	`content`	TEXT	NOT NULL,
	`anonymous_flag`	BOOLEAN	NOT NULL	DEFAULT TRUE,
	`anonymous_nickname`	VARCHAR	NULL	COMMENT '예: 익명1, 익명2, ...',
	`likes_count`	INT	NOT NULL	DEFAULT 0,
	`created_at`	TIMESTAMP	NULL	DEFAULT now()
);

CREATE TABLE `post_likes` (
	`id`	SERIAL	NOT NULL	COMMENT 'PK',
	`post_id`	UUID	NOT NULL	COMMENT 'FK -> posts.id',
	`user_id`	UUID	NOT NULL	COMMENT 'FK -> users.id',
	`created_at`	TIMESTAMP	NOT NULL	DEFAULT now(),
	`UNIQUE(post_id, user_id)`	VARCHAR(255)	NOT NULL	COMMENT '복합 유니크'
);

CREATE TABLE `comment_likes` (
	`id`	SERIAL	NOT NULL	COMMENT 'PK',
	`comment_id`	UUID]	NOT NULL	COMMENT 'FK -> comments.id',
	`user_id`	UUID	NOT NULL	COMMENT 'FK -> users.id',
	`created_at`	TIMESTAMP	NOT NULL	DEFAULT now(),
	`UNIQUE(post_id, user_id)`	VARCHAR(255)	NOT NULL	COMMENT '복합 유니크'
);

CREATE TABLE `chat_logs` (
	`id`	UUID	NOT NULL	COMMENT 'PK',
	`session_id`	UUID	NOT NULL	COMMENT 'FK -> session.id',
	`question`	TEXT	NOT NULL,
	`answer`	TEXT	NOT NULL	COMMENT 'GPT 응답 내용',
	`summary`	TEXT	NULL	COMMENT '선택적',
	`source`	JSONB	NULL	COMMENT '관련 게시글 ID, 링크 등',
	`created_at`	TIMESTAMP	NOT NULL	DEFAULT now()
);

CREATE TABLE `user_consents` (
	`id`	SERIAL	NOT NULL	COMMENT 'PK',
	`id2`	UUID	NOT NULL	COMMENT 'FK -> users.id',
	`consent_type`	ENUM('PRIVACY_POLICY','TERMS_OF_SERVICE')	NOT NULL	COMMENT '개인정보, 이용약관 등',
	`consent_status`	BOOLEAN	NOT NULL	DEFAULT FALSE	COMMENT 'TRUE = 동의함',
	`consent_date`	TIMESTAMP	NOT NULL	DEFAULT now()
);

CREATE TABLE `user_notifications` (
	`id`	SERIAL	NOT NULL	COMMENT 'PK',
	`user_id`	UUID	NOT NULL	COMMENT 'FK -> users.id',
	`email_alert`	BOOLEAN	NOT NULL	DEFAULT TRUE	COMMENT '이메일 알림 수신 여부',
	`sms_alert`	BOOLEAN	NOT NULL	DEFAULT FALSE	COMMENT 'SMS 알림 수신 여부',
	`push_alert`	BOOLEAN	NOT NULL	DEFAULT TRUE	COMMENT '앱 푸시 알림 수신 여부',
	`created_at`	TIMESTAMP	NOT NULL	DEFAULT now(),
	`updated_at`	TIMESTAMP	NULL
);

CREATE TABLE `chat_sessions` (
	`id`	UUID	NOT NULL	COMMENT 'PK',
	`user_id`	UUID	NOT NULL	COMMENT 'FK -> users.id',
	`created_at`	TIMESTAMP	NOT NULL	DEFAULT now()	COMMENT '채팅 세션 생성 시각',
	`Field`	VARCHAR(255)	NULL
);

ALTER TABLE `schools` ADD CONSTRAINT `PK_SCHOOLS` PRIMARY KEY (
	`id`
);

ALTER TABLE `departments` ADD CONSTRAINT `PK_DEPARTMENTS` PRIMARY KEY (
	`id`,
	`school_id`
);

ALTER TABLE `users` ADD CONSTRAINT `PK_USERS` PRIMARY KEY (
	`id`,
	`school_id`,
	`department_id`
);

ALTER TABLE `boards` ADD CONSTRAINT `PK_BOARDS` PRIMARY KEY (
	`id`,
	`school_id`
);

ALTER TABLE `posts` ADD CONSTRAINT `PK_POSTS` PRIMARY KEY (
	`id`,
	`board_id`,
	`user_id`
);

ALTER TABLE `comments` ADD CONSTRAINT `PK_COMMENTS` PRIMARY KEY (
	`id`,
	`post_id`,
	`user_id`
);

ALTER TABLE `post_likes` ADD CONSTRAINT `PK_POST_LIKES` PRIMARY KEY (
	`id`,
	`post_id`,
	`user_id`
);

ALTER TABLE `comment_likes` ADD CONSTRAINT `PK_COMMENT_LIKES` PRIMARY KEY (
	`id`,
	`comment_id`,
	`user_id`
);

ALTER TABLE `chat_logs` ADD CONSTRAINT `PK_CHAT_LOGS` PRIMARY KEY (
	`id`,
	`session_id`
);

ALTER TABLE `user_consents` ADD CONSTRAINT `PK_USER_CONSENTS` PRIMARY KEY (
	`id`,
	`id2`
);

ALTER TABLE `user_notifications` ADD CONSTRAINT `PK_USER_NOTIFICATIONS` PRIMARY KEY (
	`id`,
	`user_id`
);

ALTER TABLE `chat_sessions` ADD CONSTRAINT `PK_CHAT_SESSIONS` PRIMARY KEY (
	`id`,
	`user_id`
);

ALTER TABLE `departments` ADD CONSTRAINT `FK_schools_TO_departments_1` FOREIGN KEY (
	`school_id`
)
REFERENCES `schools` (
	`id`
);

ALTER TABLE `users` ADD CONSTRAINT `FK_schools_TO_users_1` FOREIGN KEY (
	`school_id`
)
REFERENCES `schools` (
	`id`
);

ALTER TABLE `users` ADD CONSTRAINT `FK_departments_TO_users_1` FOREIGN KEY (
	`department_id`
)
REFERENCES `departments` (
	`id`
);

ALTER TABLE `boards` ADD CONSTRAINT `FK_schools_TO_boards_1` FOREIGN KEY (
	`school_id`
)
REFERENCES `schools` (
	`id`
);

ALTER TABLE `posts` ADD CONSTRAINT `FK_boards_TO_posts_1` FOREIGN KEY (
	`board_id`
)
REFERENCES `boards` (
	`id`
);

ALTER TABLE `posts` ADD CONSTRAINT `FK_users_TO_posts_1` FOREIGN KEY (
	`user_id`
)
REFERENCES `users` (
	`id`
);

ALTER TABLE `comments` ADD CONSTRAINT `FK_posts_TO_comments_1` FOREIGN KEY (
	`post_id`
)
REFERENCES `posts` (
	`id`
);

ALTER TABLE `comments` ADD CONSTRAINT `FK_users_TO_comments_1` FOREIGN KEY (
	`user_id`
)
REFERENCES `users` (
	`id`
);

ALTER TABLE `post_likes` ADD CONSTRAINT `FK_posts_TO_post_likes_1` FOREIGN KEY (
	`post_id`
)
REFERENCES `posts` (
	`id`
);

ALTER TABLE `post_likes` ADD CONSTRAINT `FK_users_TO_post_likes_1` FOREIGN KEY (
	`user_id`
)
REFERENCES `users` (
	`id`
);

ALTER TABLE `comment_likes` ADD CONSTRAINT `FK_comments_TO_comment_likes_1` FOREIGN KEY (
	`comment_id`
)
REFERENCES `comments` (
	`id`
);

ALTER TABLE `comment_likes` ADD CONSTRAINT `FK_users_TO_comment_likes_1` FOREIGN KEY (
	`user_id`
)
REFERENCES `users` (
	`id`
);

ALTER TABLE `chat_logs` ADD CONSTRAINT `FK_chat_sessions_TO_chat_logs_1` FOREIGN KEY (
	`session_id`
)
REFERENCES `chat_sessions` (
	`id`
);

ALTER TABLE `user_consents` ADD CONSTRAINT `FK_users_TO_user_consents_1` FOREIGN KEY (
	`id2`
)
REFERENCES `users` (
	`id`
);

ALTER TABLE `user_notifications` ADD CONSTRAINT `FK_users_TO_user_notifications_1` FOREIGN KEY (
	`user_id`
)
REFERENCES `users` (
	`id`
);

ALTER TABLE `chat_sessions` ADD CONSTRAINT `FK_users_TO_chat_sessions_1` FOREIGN KEY (
	`user_id`
)
REFERENCES `users` (
	`id`
);

