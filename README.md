# 헬스빌리지 (Health Village) 🏥

Supabase 백엔드를 활용한 Flutter 기반 병원/약국 찾기 앱으로, 게임화 요소를 통해 사용자의 지속적인 건강관리를 유도하는 모바일 애플리케이션입니다.

## 📱 주요 기능

### Phase 1 (MVP)
- [x] 기본 병원/약국 검색
- [x] 지도 통합
- [x] 사용자 인증
- [x] 기본 UI/UX 구조
- [x] 앱 아이콘 적용 (모든 플랫폼)

### Phase 2
- [ ] 포인트 시스템
- [ ] 일일 보상
- [ ] 룰렛 기능

### Phase 3
- [ ] 처방전 스캔/관리
- [ ] 복약 알림
- [ ] 약물 정보 검색

### Phase 4
- [ ] 고도화 기능
- [ ] 성능 최적화
- [ ] 사용자 피드백 반영

## 🛠 기술 스택

### Frontend
- **Framework**: Flutter 3.0+
- **State Management**: Riverpod 2.0
- **Local Storage**: Hive
- **HTTP Client**: Dio
- **Location**: Geolocator
- **Maps**: Google Maps Flutter
- **Image/Camera**: image_picker
- **OCR**: google_ml_kit
- **Notifications**: flutter_local_notifications
- **Security**: flutter_secure_storage

### Backend
- **Database**: Supabase (PostgreSQL)
- **Authentication**: Supabase Auth
- **Real-time**: Supabase Realtime
- **Storage**: Supabase Storage
- **Functions**: Supabase Edge Functions

### External APIs
- Google Maps/Places API
- 건강보험심사평가원 API (optional)
- 응급의료정보제공 API (optional)
- 식품의약품안전처 의약품 정보 API (optional)

## 🏗 프로젝트 구조

```
lib/
├── main.dart                 # 앱 진입점
├── app.dart                  # 메인 앱 위젯
├── core/                     # 핵심 기능
│   ├── constants/           # 상수 정의
│   │   ├── api_constants.dart
│   │   ├── app_colors.dart
│   │   ├── app_strings.dart
│   │   └── app_text_styles.dart
│   ├── errors/              # 에러 처리
│   ├── network/             # 네트워크 설정
│   └── utils/               # 유틸리티
├── data/                    # 데이터 레이어
│   ├── datasources/         # 데이터 소스
│   │   ├── remote/         # 원격 API
│   │   └── local/          # 로컬 저장소
│   ├── models/             # 데이터 모델
│   └── repositories/       # 리포지토리 구현
├── domain/                 # 도메인 레이어
│   ├── entities/           # 엔티티
│   ├── repositories/       # 리포지토리 인터페이스
│   └── usecases/          # 비즈니스 로직
├── presentation/           # 프레젠테이션 레이어
│   ├── providers/          # Riverpod 프로바이더
│   ├── screens/            # 화면
│   │   ├── splash/
│   │   ├── home/
│   │   ├── medicine/
│   │   ├── roulette/
│   │   ├── calendar/
│   │   ├── mypage/
│   │   └── prescription/
│   └── widgets/            # 재사용 위젯
│       ├── common/
│       └── specific/
└── routes/                 # 라우팅
```

## 🚀 시작하기

### 1. 요구사항
- Flutter SDK 3.1.0 이상
- Dart SDK 3.0.0 이상
- Android Studio / VS Code
- iOS 개발 시 Xcode 필요

### 2. 설치

```bash
# 저장소 클론
git clone [repository-url]
cd flutter-healthvillage

# 의존성 설치
flutter pub get

# 코드 생성
flutter packages pub run build_runner build

# 앱 아이콘 생성 (아이콘 변경 시)
dart run flutter_launcher_icons
```

### 3. Supabase 설정

#### 3-1. Supabase 프로젝트 설정
1. Supabase 프로젝트가 이미 생성되어 있습니다 (프로젝트 ID: gcznkwmcjrecupdmtwfu)
2. [Supabase Dashboard](https://supabase.com/dashboard/project/gcznkwmcjrecupdmtwfu)에서 anon key를 확인하여 `.env` 파일에 추가하세요

#### 3-2. 데이터베이스 스키마 설정
다음 두 가지 방법 중 하나를 선택하여 데이터베이스를 설정합니다:

**방법 1: SQL 파일 사용 (권장)**
1. [Supabase Dashboard SQL Editor](https://supabase.com/dashboard/project/gcznkwmcjrecupdmtwfu/sql/new)로 이동
2. 다음 순서대로 SQL 파일을 실행:
   - `supabase/migrations/001_create_extensions.sql` - UUID 확장 기능 활성화
   - `supabase/migrations/002_create_users_table.sql` - 사용자 테이블 생성
   - `supabase/migrations/003_create_medical_tables.sql` - 병원, 약국, 약품 테이블 생성
   - `supabase/migrations/004_create_user_relations.sql` - 사용자 관계 테이블 생성
   - `supabase/migrations/005_create_functions.sql` - 위치 기반 검색 함수 생성
   - `supabase/migrations/006_rls_policies.sql` - 행 수준 보안 정책 적용

**방법 2: 수동 생성**
Supabase SQL Editor에서 다음 테이블들을 생성:

```sql
-- Users table (Supabase Auth와 연동)
CREATE TABLE users (
  id UUID PRIMARY KEY REFERENCES auth.users(id),
  email TEXT NOT NULL,
  name TEXT,
  phone TEXT,
  profile_image_url TEXT,
  birth_date DATE,
  gender TEXT,
  points INTEGER DEFAULT 0,
  level INTEGER DEFAULT 1,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Hospitals table
CREATE TABLE hospitals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  address TEXT NOT NULL,
  phone TEXT,
  latitude DOUBLE PRECISION NOT NULL,
  longitude DOUBLE PRECISION NOT NULL,
  category TEXT,
  operating_hours JSONB,
  departments TEXT[],
  rating DOUBLE PRECISION,
  review_count INTEGER DEFAULT 0,
  is_emergency_available BOOLEAN DEFAULT FALSE,
  is_parking_available BOOLEAN DEFAULT FALSE,
  image_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE hospitals ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Users can view own profile" ON users
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Public can view hospitals" ON hospitals
  FOR SELECT USING (true);
```

### 4. 환경 설정

`.env` 파일을 프로젝트 루트에 생성하고 다음 정보를 입력하세요:

```env
# Supabase
SUPABASE_URL=https://gcznkwmcjrecupdmtwfu.supabase.co
SUPABASE_ANON_KEY=your_supabase_anon_key  # Dashboard에서 확인 필요

# Google Maps API Key
GOOGLE_MAPS_API_KEY=your_google_maps_api_key
GOOGLE_PLACES_API_KEY=your_google_places_api_key

# 공공데이터 API Key (선택사항)
HIRA_API_KEY=your_hira_api_key
KFDAR_API_KEY=your_kfdar_api_key
EMS_API_KEY=your_ems_api_key
```

### 5. 실행

```bash
# 디버그 모드 실행
flutter run

# 릴리즈 모드 빌드
flutter build apk --release
flutter build ios --release
```

## 🔧 개발 규칙

### 네이밍 컨벤션
- **클래스**: PascalCase (`HospitalCard`)
- **변수/함수**: camelCase (`hospitalList`, `searchHospital()`)
- **상수**: SCREAMING_SNAKE_CASE (`API_BASE_URL`)
- **파일명**: snake_case (`hospital_card.dart`)
- **Provider**: 기능명 + Provider (`hospitalListProvider`)

### 코드 스타일
- Pretendard 폰트 사용
- Material Design 3 적용
- Clean Architecture 패턴
- Repository 패턴으로 데이터 관리
- Riverpod을 이용한 상태 관리

### Git 컨벤션
```
feat: 새로운 기능 추가
fix: 버그 수정
docs: 문서 업데이트
style: 코드 포맷팅
refactor: 코드 리팩토링
test: 테스트 추가
chore: 기타 작업
```

## 📋 주요 API 및 서비스

### Supabase 서비스
1. **인증 (Auth)**
   - 이메일/비밀번호 인증
   - 소셜 로그인 지원
   - JWT 토큰 기반 인증

2. **데이터베이스 (Database)**
   - PostgreSQL 기반
   - Row Level Security (RLS)
   - 실시간 구독 기능

3. **스토리지 (Storage)**
   - 이미지 및 파일 저장
   - CDN 지원
   - 액세스 권한 관리

### 외부 API
1. **Google Maps/Places API**
   - 지도 표시 및 위치 서비스
   - 장소 검색 및 상세 정보

2. **공공데이터 API (선택사항)**
   - 건강보험심사평가원 병원정보서비스
   - 응급의료정보제공
   - 식품의약품안전처 의약품 정보

## 🔒 보안 및 개인정보 보호

- API 키는 환경 변수로 관리
- 의료 정보는 암호화하여 저장
- 생체 인증을 통한 접근 제어
- 개인정보처리방침 준수

## 📱 지원 플랫폼

- Android 6.0 (API Level 23) 이상
- iOS 12.0 이상

## 🤝 기여하기

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다. 자세한 내용은 `LICENSE` 파일을 참조하세요.

## 📞 문의

프로젝트 관련 문의사항이 있으시면 Issues를 통해 연락해주세요.

---

**건강한 마을을 만들어가요! 🏥💚**
