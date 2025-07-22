# Supabase 데이터베이스 설정 가이드

## 1. 프로젝트 정보
- **프로젝트 ID**: gcznkwmcjrecupdmtwfu
- **프로젝트 URL**: https://gcznkwmcjrecupdmtwfu.supabase.co
- **Dashboard**: https://supabase.com/dashboard/project/gcznkwmcjrecupdmtwfu

## 2. SQL 실행 순서

### Step 1: SQL Editor 접속
1. [SQL Editor](https://supabase.com/dashboard/project/gcznkwmcjrecupdmtwfu/sql/new) 열기
2. 새 쿼리 창 생성

### Step 2: 확장 기능 활성화
```sql
-- 001_create_extensions.sql 내용 복사 후 실행
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
```

### Step 3: 사용자 테이블 생성
```sql
-- 002_create_users_table.sql 전체 내용 복사 후 실행
```

### Step 4: 의료 시설 테이블 생성
```sql
-- 003_create_medical_tables.sql 전체 내용 복사 후 실행
```

### Step 5: 사용자 관계 테이블 생성
```sql
-- 004_create_user_relations.sql 전체 내용 복사 후 실행
```

### Step 6: 함수 생성
```sql
-- 005_create_functions.sql 전체 내용 복사 후 실행
```

### Step 7: RLS 정책 적용
```sql
-- 006_rls_policies.sql 전체 내용 복사 후 실행
```

## 3. 실행 확인

### 테이블 확인
SQL Editor에서 다음 쿼리 실행:
```sql
-- 생성된 테이블 목록 확인
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public'
ORDER BY table_name;
```

예상 결과:
- hospitals
- medicines
- pharmacies
- points_history
- user_favorite_hospitals
- user_favorite_pharmacies
- users

### RLS 정책 확인
```sql
-- RLS 정책 확인
SELECT 
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd
FROM pg_policies
WHERE schemaname = 'public'
ORDER BY tablename, policyname;
```

### 함수 확인
```sql
-- 생성된 함수 목록 확인
SELECT 
  routine_name,
  routine_type
FROM information_schema.routines
WHERE routine_schema = 'public'
ORDER BY routine_name;
```

예상 함수 목록:
- add_points
- calculate_distance_km
- get_emergency_hospitals
- get_nearby_hospitals
- get_nearby_pharmacies
- handle_new_user
- update_updated_at_column

## 4. 테스트 데이터 (선택사항)

### 샘플 병원 데이터 추가
```sql
INSERT INTO public.hospitals (name, address, phone, latitude, longitude, category, is_emergency_available)
VALUES 
  ('서울대학교병원', '서울특별시 종로구 대학로 101', '02-2072-2114', 37.5798, 126.9996, '종합병원', true),
  ('삼성서울병원', '서울특별시 강남구 일원로 81', '1599-3114', 37.4881, 127.0857, '종합병원', true),
  ('강남세브란스병원', '서울특별시 강남구 언주로 211', '02-2019-3114', 37.4923, 127.0471, '종합병원', true);
```

### 샘플 약국 데이터 추가
```sql
INSERT INTO public.pharmacies (name, address, phone, latitude, longitude, is_night_pharmacy)
VALUES 
  ('온누리약국', '서울특별시 종로구 종로 33', '02-2265-2828', 37.5704, 126.9790, true),
  ('365약국', '서울특별시 강남구 테헤란로 152', '02-555-3655', 37.5002, 127.0365, true),
  ('건강약국', '서울특별시 서초구 서초대로 77', '02-585-8282', 37.4967, 127.0276, false);
```

## 5. 문제 해결

### PostGIS 관련 오류
PostGIS extension이 없는 경우, 위치 기반 검색은 간단한 거리 계산 함수를 사용합니다.

### RLS 정책 오류
- 모든 테이블이 생성된 후에 RLS 정책을 적용하세요
- auth.users 테이블 참조 오류 시, Supabase Auth가 활성화되어 있는지 확인

### 트리거 오류
- update_updated_at_column() 함수가 먼저 생성되어야 합니다
- 함수 생성 후 트리거를 생성하세요

## 6. 다음 단계

1. Flutter 앱에서 `.env` 파일에 Supabase URL과 anon key 설정
2. 앱 실행 후 회원가입/로그인 테스트
3. 병원/약국 검색 기능 테스트