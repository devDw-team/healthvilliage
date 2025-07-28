import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../providers/auth_provider.dart';
import '../mypage/mypage_screen.dart';
import '../medicine/medicine_screen.dart';

/// 홈 화면 - 메인 네비게이션과 주요 기능들
class HomeScreen extends ConsumerStatefulWidget {
  final int initialTab;
  
  const HomeScreen({
    Key? key,
    this.initialTab = 0,
  }) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
  }

  final List<Widget> _screens = [
    const HomeTabScreen(),
    const MedicineScreen(showBackButton: false),  // 탭에서는 뒤로 가기 버튼 숨김
    const RouletteTabScreen(),
    const CalendarTabScreen(),
    const MyPageScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: AppStrings.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medication),
            label: AppStrings.medicine,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.casino),
            label: AppStrings.roulette,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: AppStrings.calendar,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: AppStrings.myPage,
          ),
        ],
      ),
    );
  }
}

/// 홈 탭 화면
class HomeTabScreen extends StatelessWidget {
  const HomeTabScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // TODO: 알림 화면으로 이동
            },
          ),
          Consumer(
            builder: (context, ref, child) {
              return IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  final shouldLogout = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('로그아웃'),
                        content: const Text('정말 로그아웃 하시겠습니까?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('취소'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('로그아웃'),
                          ),
                        ],
                      );
                    },
                  );
                  
                  if (shouldLogout == true) {
                    try {
                      await ref.read(authStateProvider.notifier).signOut();
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('로그아웃 실패: ${e.toString()}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  }
                },
              );
            },
          ),
        ],
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 환영 메시지
            WelcomeSection(),
            SizedBox(height: 24),
            
            // 빠른 액세스 버튼들
            QuickAccessSection(),
            SizedBox(height: 24),
            
            // 내 주변 병원/약국
            NearbyFacilitiesSection(),
            SizedBox(height: 24),
            
            // 최근 활동
            RecentActivitySection(),
          ],
        ),
      ),
    );
  }
}

/// 환영 메시지 섹션
class WelcomeSection extends ConsumerWidget {
  const WelcomeSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final userName = currentUser?.name ?? '사용자';
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$userName님 안녕하세요! 👋',
                      style: AppTextStyles.headline5.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '오늘도 건강한 하루 보내세요',
                      style: AppTextStyles.body2.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              Consumer(
                builder: (context, ref, child) {
                  final userAsync = ref.watch(authStateProvider);
                  final profileImageUrl = userAsync.whenOrNull(
                    data: (user) => user?.profileImageUrl,
                  );
                  
                  return Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.5),
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: profileImageUrl != null
                          ? Image.network(
                              profileImageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 32,
                                );
                              },
                            )
                          : Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 32,
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
          if (currentUser != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.stars,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '포인트: ${currentUser.points ?? 0}P',
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    Icons.trending_up,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Lv.${currentUser.level ?? 1}',
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// 빠른 액세스 섹션
class QuickAccessSection extends StatelessWidget {
  const QuickAccessSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '빠른 메뉴',
          style: AppTextStyles.headline6,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _QuickAccessButton(
                icon: Icons.local_hospital,
                label: AppStrings.hospital,
                color: AppColors.hospital,
                onTap: () {
                  context.push('/hospital');
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickAccessButton(
                icon: Icons.local_pharmacy,
                label: AppStrings.pharmacy,
                color: AppColors.pharmacy,
                onTap: () {
                  context.push('/pharmacy');
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickAccessButton(
                icon: Icons.emergency,
                label: AppStrings.emergencyRoom,
                color: AppColors.emergency,
                onTap: () {
                  context.push('/emergency');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// 빠른 액세스 버튼
class _QuickAccessButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAccessButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// 내 주변 병원/약국 섹션
class NearbyFacilitiesSection extends StatelessWidget {
  const NearbyFacilitiesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '내 주변 의료시설',
              style: AppTextStyles.headline6,
            ),
            TextButton(
              onPressed: () {
                // TODO: 전체 목록으로 이동
              },
              child: const Text(AppStrings.more),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          '위치 권한을 허용하면 내 주변 병원과 약국을 볼 수 있습니다.',
          style: AppTextStyles.body2,
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            // TODO: 위치 권한 요청
          },
          icon: const Icon(Icons.location_on),
          label: const Text('위치 권한 허용'),
        ),
      ],
    );
  }
}

/// 최근 활동 섹션
class RecentActivitySection extends StatelessWidget {
  const RecentActivitySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '최근 활동',
          style: AppTextStyles.headline6,
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.casino,
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '오늘의 룰렛에 참여해보세요!',
                        style: AppTextStyles.subtitle1,
                      ),
                      Text(
                        '매일 포인트를 획득할 수 있는 기회',
                        style: AppTextStyles.body2,
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.textTertiary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}


/// 룰렛 탭 화면 (임시)
class RouletteTabScreen extends StatelessWidget {
  const RouletteTabScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.roulette),
      ),
      body: const Center(
        child: Text('룰렛 화면\n(개발 예정)'),
      ),
    );
  }
}

/// 캘린더 탭 화면 (임시)
class CalendarTabScreen extends StatelessWidget {
  const CalendarTabScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.calendar),
      ),
      body: const Center(
        child: Text('캘린더 화면\n(개발 예정)'),
      ),
    );
  }
}

 