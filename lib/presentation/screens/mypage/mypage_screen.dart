import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../providers/auth_provider.dart';

class MyPageScreen extends ConsumerStatefulWidget {
  const MyPageScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends ConsumerState<MyPageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('마이페이지'),
        backgroundColor: AppColors.primary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),
              _buildProfileSection(),
              const SizedBox(height: 16),
              _buildPointSection(),
              const SizedBox(height: 16),
              _buildMenuSection(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildProfileSection() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Consumer(
            builder: (context, ref, child) {
              final userAsync = ref.watch(authStateProvider);
              final profileImageUrl = userAsync.whenOrNull(
                data: (user) => user?.profileImageUrl,
              );
              
              return CircleAvatar(
                radius: 35,
                backgroundColor: AppColors.primary,
                backgroundImage: profileImageUrl != null
                    ? NetworkImage(profileImageUrl)
                    : null,
                child: profileImageUrl == null
                    ? const Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.white,
                      )
                    : null,
              );
            },
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final userAsync = ref.watch(authStateProvider);
                final user = userAsync.whenOrNull(data: (user) => user);
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.name ?? '사용자님',
                      style: AppTextStyles.headline5,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.email ?? 'user@example.com',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          IconButton(
            onPressed: () {
              _showPasswordConfirmDialog();
            },
            icon: const Icon(
              Icons.edit,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointSection() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '내 포인트',
                    style: AppTextStyles.body1.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '1,250',
                        style: AppTextStyles.heading1.copyWith(
                          color: Colors.white,
                          fontSize: 28,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Text(
                          'P',
                          style: AppTextStyles.headline5.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Lv. 3',
                      style: AppTextStyles.subtitle1.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.6,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '다음 레벨까지 250P',
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              Text(
                '1,250 / 1,500',
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuItem(
            icon: Icons.medical_information,
            title: '진료 기록',
            onTap: () {},
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.favorite,
            title: '즐겨찾기',
            onTap: () {
              context.push('/mypage/favorites');
            },
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.history,
            title: '포인트 내역',
            onTap: () {},
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.notifications,
            title: '알림 설정',
            onTap: () {},
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.help_outline,
            title: '고객센터',
            onTap: () {},
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.info_outline,
            title: '앱 정보',
            onTap: () {},
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.lock,
            title: '비밀번호 변경',
            onTap: () {
              context.push('/password_change/current');
            },
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.logout,
            title: '로그아웃',
            textColor: AppColors.error,
            onTap: () {
              _showLogoutDialog();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: textColor ?? AppColors.textSecondary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.body1.copyWith(
                  color: textColor ?? AppColors.textPrimary,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: AppColors.divider,
      indent: 60,
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: Text(
          '로그아웃',
          style: AppTextStyles.headline5.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          '정말 로그아웃 하시겠습니까?',
          style: AppTextStyles.body1.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '취소',
              style: AppTextStyles.button.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              
              // 로딩 표시
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                ),
              );
              
              try {
                // 로그아웃 처리
                await ref.read(authStateProvider.notifier).signOut();
                
                if (mounted) {
                  // 로딩 다이얼로그 닫기
                  Navigator.pop(context);
                  
                  // 로그인 화면으로 이동
                  context.go('/login');
                }
              } catch (e) {
                if (mounted) {
                  // 로딩 다이얼로그 닫기
                  Navigator.pop(context);
                  
                  // 에러 메시지 표시
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('로그아웃 중 오류가 발생했습니다: $e'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              }
            },
            child: Text(
              '로그아웃',
              style: AppTextStyles.button.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPasswordConfirmDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return _PasswordConfirmDialog(
          onCancel: () {
            Navigator.of(dialogContext).pop();
          },
          onConfirm: (password) async {
            // 먼저 다이얼로그를 닫습니다
            Navigator.of(dialogContext).pop();
            
            // 로딩 표시
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 16),
                      Text('비밀번호 확인 중...'),
                    ],
                  ),
                  duration: Duration(seconds: 30),
                ),
              );
            }
            
            try {
              // Supabase Auth로 비밀번호 확인
              print('[MyPageScreen] 비밀번호 확인 시작');
              final isValid = await ref.read(authStateProvider.notifier)
                  .verifyPassword(password);
              print('[MyPageScreen] 비밀번호 확인 결과: $isValid');
              
              if (!mounted) return;
              
              // 로딩 스낵바 제거
              ScaffoldMessenger.of(context).clearSnackBars();
              
              if (isValid) {
                print('[MyPageScreen] 비밀번호 확인 성공, 프로필 화면으로 이동');
                // 프로필 편집 화면으로 이동
                context.push('/profile/edit');
              } else {
                print('[MyPageScreen] 비밀번호 확인 실패');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('비밀번호가 올바르지 않습니다.'),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('오류가 발생했습니다: $e'),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            }
          },
        );
      },
    );
  }
}

class _PasswordConfirmDialog extends StatefulWidget {
  final VoidCallback onCancel;
  final Future<void> Function(String password) onConfirm;

  const _PasswordConfirmDialog({
    Key? key,
    required this.onCancel,
    required this.onConfirm,
  }) : super(key: key);

  @override
  State<_PasswordConfirmDialog> createState() => _PasswordConfirmDialogState();
}

class _PasswordConfirmDialogState extends State<_PasswordConfirmDialog> {
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      title: Text(
        '비밀번호 확인',
        style: AppTextStyles.headline5.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '프로필을 수정하시려면 비밀번호를 입력해주세요.',
              style: AppTextStyles.body1.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              style: AppTextStyles.body1.copyWith(
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                labelText: '비밀번호',
                labelStyle: AppTextStyles.body2.copyWith(
                  color: AppColors.textSecondary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
                fillColor: Colors.white,
                filled: true,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '비밀번호를 입력해주세요';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: widget.onCancel,
          child: Text(
            '취소',
            style: AppTextStyles.button.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onConfirm(_passwordController.text);
            }
          },
          child: Text(
            '확인',
            style: AppTextStyles.button.copyWith(
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
} 