import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../hospital/hospital_search_screen.dart';
import '../pharmacy/pharmacy_search_screen.dart';
import '../emergency/emergency_screen.dart';

class SearchScreen extends ConsumerStatefulWidget {
  final int initialTab;
  
  const SearchScreen({
    Key? key,
    this.initialTab = 0,
  }) : super(key: key);

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialTab,
    );
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppStrings.search,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              tabs: List.generate(3, (index) {
                final isSelected = _tabController.index == index;
                IconData icon;
                String label;
                
                switch (index) {
                  case 0:
                    icon = Icons.local_hospital;
                    label = AppStrings.hospital;
                    break;
                  case 1:
                    icon = Icons.local_pharmacy;
                    label = AppStrings.pharmacy;
                    break;
                  case 2:
                    icon = Icons.emergency;
                    label = AppStrings.emergencyRoom;
                    break;
                  default:
                    icon = Icons.local_hospital;
                    label = AppStrings.hospital;
                }
                
                return Tab(
                  height: 65,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(icon, size: 26),
                        const SizedBox(height: 4),
                        Text(
                          label,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              indicator: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.primary,
                    width: 3,
                  ),
                ),
              ),
              labelColor: AppColors.primary,
              unselectedLabelColor: Colors.grey[600],
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          HospitalSearchContent(),
          PharmacySearchContent(),
          EmergencySearchContent(),
        ],
      ),
    );
  }
}

class HospitalSearchContent extends StatelessWidget {
  const HospitalSearchContent({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return const HospitalSearchScreen(
      isTabView: true,
    );
  }
}

class PharmacySearchContent extends StatelessWidget {
  const PharmacySearchContent({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return const PharmacySearchScreen(
      isTabView: true,
    );
  }
}

class EmergencySearchContent extends StatelessWidget {
  const EmergencySearchContent({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return const EmergencyScreen(
      isTabView: true,
    );
  }
}