#!/bin/bash

echo "🟡 PostgreSQL 설치 중..."
sudo apt update
sudo apt install postgresql postgresql-contrib -y

echo "🟢 사용자 및 데이터베이스 생성..."
sudo -u postgres psql <<EOF
CREATE USER campusya_user WITH PASSWORD 'campusya_pass';
CREATE DATABASE campusya_db OWNER campusya_user;
EOF

echo "✅ PostgreSQL 설정 완료!"
