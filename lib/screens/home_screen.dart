import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../widgets/shared_widgets.dart';
import 'find_donor_screen.dart'; // new find donors page
import 'donate_screen.dart'; // renamed donate page
import 'blood_bank_screen.dart';
import 'blood_request_screen.dart';
import 'inbox_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';
import 'support_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNav = 0;
  final TextEditingController _searchController = TextEditingController();
  String _search = '';
  String _filterType = 'name';

  final List<Map<String, dynamic>> _quickActions = [
    {'icon': Icons.favorite_rounded, 'label': 'Find Donors', 'index': 0},
    {'icon': Icons.water_drop_rounded, 'label': 'Donate', 'index': 1},
    {'icon': Icons.local_hospital_rounded, 'label': 'Blood Bank', 'index': 2},
    {'icon': Icons.support_agent_rounded, 'label': 'Support', 'index': 3},
    {'icon': Icons.bloodtype_rounded, 'label': 'Blood Req..', 'index': 4},
    {'icon': Icons.grid_view_rounded, 'label': 'More', 'index': 5},
  ];
  List<Map<String, dynamic>> get _filteredDonors {
    if (_search.isEmpty) return donorsList;

    return donorsList.where((donor) {
      final query = _search.toLowerCase();

      switch (_filterType) {
        case 'blood':
          return (donor['blood'] as String).toLowerCase().contains(query);

        case 'location':
          return (donor['location'] as String).toLowerCase().contains(query);

        case 'name':
        default:
          return (donor['name'] as String).toLowerCase().contains(query);
      }
    }).toList();
  }

  void _navigateFromQuickAction(int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FindDonorScreen()),
        ); // ← new donors page
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DonateScreen()),
        ); // ← donate page
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BloodBankScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SupportScreen()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BloodRequestScreen()),
        );
        break;
      case 5:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SupportScreen()),
        );
        break;
    }
  }

  void _navigateBottomNav(int index) {
    if (index == _currentNav) return;
    setState(() => _currentNav = index);
    Widget screen;
    switch (index) {
      case 1:
        screen = const InboxScreen();
        break;
      case 2:
        screen = const NotificationsScreen();
        break;
      case 3:
        screen = const ProfileScreen();
        break;
      default:
        return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    ).then((_) => setState(() => _currentNav = 0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: _buildDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopBar(),
                    _buildSearchBar(),
                    _buildMapSection(),
                    _buildQuickActions(),
                    _buildBloodSeekerSection(),
                  ],
                ),
              ),
            ),
            _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    final drawerItems = [
      {
        'icon': Icons.home_rounded,
        'label': 'Home',
        'action': () => Navigator.pop(context),
      },
      {
        'icon': Icons.favorite_rounded,
        'label': 'Find Donors',
        'action': () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FindDonorScreen()),
          );
        },
      },
      {
        'icon': Icons.water_drop_rounded,
        'label': 'Donate Blood',
        'action': () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DonateScreen()),
          );
        },
      },
      {
        'icon': Icons.bloodtype_rounded,
        'label': 'Blood Requests',
        'action': () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BloodRequestScreen()),
          );
        },
      },
      {
        'icon': Icons.local_hospital_rounded,
        'label': 'Blood Bank',
        'action': () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BloodBankScreen()),
          );
        },
      },
      {
        'icon': Icons.inbox_rounded,
        'label': 'Messages',
        'action': () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const InboxScreen()),
          );
        },
      },
      {
        'icon': Icons.notifications_rounded,
        'label': 'Notifications',
        'action': () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NotificationsScreen()),
          );
        },
      },
      {
        'icon': Icons.person_rounded,
        'label': 'Profile',
        'action': () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfileScreen()),
          );
        },
      },
      {
        'icon': Icons.support_agent_rounded,
        'label': 'Help & Support',
        'action': () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SupportScreen()),
          );
        },
      },
      {
        'icon': Icons.logout_rounded,
        'label': 'Logout',
        'action': () => Navigator.pop(context),
        'danger': true,
      },
    ];

    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.4),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'John Doe',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'O+ • Verified Donor',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: drawerItems.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, color: Color(0xFFF5F5F5)),
              itemBuilder: (context, i) {
                final item = drawerItems[i];
                final isDanger = item['danger'] == true;
                return ListTile(
                  leading: Icon(
                    item['icon'] as IconData,
                    color: isDanger ? AppColors.primary : AppColors.textDark,
                    size: 22,
                  ),
                  title: Text(
                    item['label'] as String,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDanger ? AppColors.primary : AppColors.textDark,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: isDanger
                        ? AppColors.primaryLight
                        : const Color(0xFFDDDDDD),
                    size: 20,
                  ),
                  onTap: item['action'] as VoidCallback,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'BloodConnect v1.0.0',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Builder(
            builder: (context) => GestureDetector(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _menuLine(24),
                  const SizedBox(height: 5),
                  _menuLine(16),
                  const SizedBox(height: 5),
                  _menuLine(20),
                ],
              ),
            ),
          ),

          const Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Good Morning 👋',
                style: TextStyle(color: AppColors.textGrey, fontSize: 12),
              ),
              Text(
                'Find Blood Donors',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),

          // ✅ EMPTY SPACE to keep alignment same
          const SizedBox(width: 48, height: 48),
        ],
      ),
    );
  }

  Widget _menuLine(double width) => Container(
    width: width,
    height: 2.5,
    decoration: BoxDecoration(
      color: AppColors.textDark,
      borderRadius: BorderRadius.circular(2),
    ),
  );

  // ── Search Bar — filter icon now goes to FindDonorScreen ──────────────────
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _search = value;
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey.shade400,
                      ),
                      hintText: 'Search donors...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // ✅ FILTER BUTTON (CORRECT POSITION)
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Search Filter",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),

                            ListTile(
                              leading: const Icon(Icons.person),
                              title: const Text("Search by Name"),
                              onTap: () {
                                setState(() => _filterType = 'name');
                                Navigator.pop(context);
                              },
                            ),

                            ListTile(
                              leading: const Icon(Icons.bloodtype),
                              title: const Text("Search by Blood Group"),
                              onTap: () {
                                setState(() => _filterType = 'blood');
                                Navigator.pop(context);
                              },
                            ),

                            ListTile(
                              leading: const Icon(Icons.location_on),
                              title: const Text("Search by Location"),
                              onTap: () {
                                setState(() => _filterType = 'location');
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.tune, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),

          // 🔥 SEARCH RESULTS
          if (_search.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                children: _filteredDonors.map((donor) {
                  return ListTile(
                    leading: const Icon(Icons.water_drop, color: Colors.red),
                    title: Text(donor['name']),
                    subtitle: Text("${donor['blood']} • ${donor['location']}"),
                    onTap: () {
                      _searchController.text = donor['name'];
                      setState(() {
                        _search = donor['name'];
                      });
                    },
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMapSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 180,
          width: double.infinity,
          child: Stack(
            children: [
              Container(color: AppColors.mapBg),
              CustomPaint(
                painter: MapPainter(),
                size: const Size(double.infinity, 180),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: const Text(
                        'Your Location',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Icon(
                      Icons.location_on,
                      color: AppColors.primary,
                      size: 32,
                    ),
                  ],
                ),
              ),
              Positioned(top: 40, left: 60, child: _mapDonorPin()),
              Positioned(top: 70, right: 70, child: _mapDonorPin()),
              Positioned(bottom: 40, left: 100, child: _mapDonorPin()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mapDonorPin() => Container(
    width: 28,
    height: 28,
    decoration: BoxDecoration(
      color: AppColors.primary,
      shape: BoxShape.circle,
      border: Border.all(color: Colors.white, width: 2),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4),
      ],
    ),
    child: const Icon(Icons.water_drop, color: Colors.white, size: 14),
  );

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _quickActions.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 1.1,
        ),
        itemBuilder: (context, i) {
          final action = _quickActions[i];
          return GestureDetector(
            onTap: () => _navigateFromQuickAction(i),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      action['icon'] as IconData,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    action['label'] as String,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Blood Seeker Section — Donate button → InboxScreen ────────────────────
  Widget _buildBloodSeekerSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Blood Seekers',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DonateScreen()),
                ), // ← see all → donate screen
                child: const Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...donorsList
              .take(3)
              .map(
                (seeker) => SeekerCard(
                  seeker: seeker,
                  onDonate: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          InboxScreen(openChatId: seeker['id'] as int),
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.home_rounded, 'label': 'Home'},
      {'icon': Icons.inbox_rounded, 'label': 'Inbox'},
      {'icon': Icons.notifications_rounded, 'label': 'Notification'},
      {'icon': Icons.person_rounded, 'label': 'Profile'},
    ];

    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 16,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: List.generate(items.length, (i) {
          final selected = _currentNav == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => _navigateBottomNav(i),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    items[i]['icon'] as IconData,
                    color: selected ? AppColors.primary : Colors.grey.shade400,
                    size: 24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    items[i]['label'] as String,
                    style: TextStyle(
                      fontSize: 10,
                      color: selected
                          ? AppColors.primary
                          : Colors.grey.shade400,
                      fontWeight: selected
                          ? FontWeight.w700
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
