import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../widgets/shared_widgets.dart';
import 'home_screen.dart';
import 'inbox_screen.dart';


// ── Notifications Screen ─────────────────────────────────────────────────────
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late List<Map<String, dynamic>> _notifs;
  final int _currentNav = 2; // Notifications is index 2

  @override
  void initState() {
    super.initState();
    _notifs = List.from(notificationsList);
  }

  void _navigateBottomNav(int index) {
    if (index == _currentNav) return;
    switch (index) {
      case 0:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );
        break;
      case 1:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const InboxScreen()),
          (route) => false,
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProfileScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.textDark),
          onPressed: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
            (route) => false,
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => setState(() {
              _notifs = _notifs.map((n) => {...n, 'read': true}).toList();
            }),
            child: const Text(
              'Mark all read',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFF0F0F0)),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _notifs.length,
        itemBuilder: (context, i) => _buildNotifCard(_notifs[i], i),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildNotifCard(Map<String, dynamic> n, int index) {
    final isRead = n['read'] as bool;
    return GestureDetector(
      onTap: () => setState(() {
        _notifs[index] = {...n, 'read': true};
      }),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isRead ? AppColors.white : const Color(0xFFFFF5F6),
          border: Border.all(
            color: isRead ? const Color(0xFFF0F0F0) : const Color(0xFFFFD0D6),
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isRead ? const Color(0xFFF5F5F5) : AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(n['icon'] as String, style: const TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    n['title'] as String,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isRead ? FontWeight.w600 : FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    n['desc'] as String,
                    style: const TextStyle(
                        fontSize: 12.5, color: AppColors.textGrey, height: 1.5),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    n['time'] as String,
                    style: const TextStyle(fontSize: 11, color: AppColors.textLight),
                  ),
                ],
              ),
            ),
            if (!isRead)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 4),
                decoration: const BoxDecoration(
                    color: AppColors.primary, shape: BoxShape.circle),
              ),
          ],
        ),
      ),
    );
  }

  // ── Bottom Navigation ────────────────────────────────────────────────────
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
                      color: selected ? AppColors.primary : Colors.grey.shade400,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.normal,
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

// ── Profile Screen ───────────────────────────────────────────────────────────
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      {'icon': Icons.water_drop_rounded, 'label': 'My Donations', 'sub': '12 total donations'},
      {'icon': Icons.bloodtype_rounded, 'label': 'Blood Requests', 'sub': '2 active requests'},
      {'icon': Icons.emoji_events_rounded, 'label': 'Achievements', 'sub': '5 badges earned'},
      {'icon': Icons.notifications_rounded, 'label': 'Notifications', 'sub': 'Push, Email alerts'},
      {'icon': Icons.lock_rounded, 'label': 'Privacy & Security', 'sub': 'Manage your data'},
      {'icon': Icons.language_rounded, 'label': 'Language', 'sub': 'English'},
      {'icon': Icons.help_rounded, 'label': 'Help & Support', 'sub': 'FAQs, Contact us'},
      {
        'icon': Icons.logout_rounded,
        'label': 'Logout',
        'sub': 'Sign out of account',
        'danger': true,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppTopBar(
        title: 'My Profile',
        onBack: () => Navigator.pop(context),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded, color: AppColors.primary, size: 22),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            _buildStatsRow(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: menuItems.map((item) => _buildMenuItem(context, item)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      color: AppColors.white,
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    'JD',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.white, width: 2),
                  ),
                  child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'John Doe',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textDark),
          ),
          const SizedBox(height: 4),
          const Text(
            'johndoe@email.com',
            style: TextStyle(fontSize: 13, color: AppColors.textGrey),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const BloodBadge(type: 'O+'),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.verified_rounded, color: Color(0xFF1B5E20), size: 14),
                    SizedBox(width: 4),
                    Text(
                      'Verified Donor',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1B5E20),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    final stats = [
      {'label': 'Total Donations', 'value': '12'},
      {'label': 'Lives Saved', 'value': '36'},
      {'label': 'Badges', 'value': '5'},
    ];

    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: stats.asMap().entries.map((entry) {
          final i = entry.key;
          final s = entry.value;
          return Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                border: Border(
                  right: i < 2
                      ? const BorderSide(color: Color(0xFFFFD0D6), width: 1)
                      : BorderSide.none,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    s['value']!,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    s['label']!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 10, color: AppColors.primaryDark),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, Map<String, dynamic> item) {
    final isDanger = item['danger'] == true;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: isDanger ? const Color(0xFFFFE5E5) : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            item['icon'] as IconData,
            color: isDanger ? AppColors.primary : AppColors.textDark,
            size: 22,
          ),
        ),
        title: Text(
          item['label'] as String,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: isDanger ? AppColors.primary : AppColors.textDark,
          ),
        ),
        subtitle: Text(
          item['sub'] as String,
          style: const TextStyle(fontSize: 12, color: AppColors.textLight),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: isDanger ? AppColors.primary : const Color(0xFFDDDDDD),
          size: 20,
        ),
        onTap: () {},
      ),
    );
  }
}

// ── Support Screen ───────────────────────────────────────────────────────────
class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  int? _openFaq;

  final List<Map<String, String>> _faqs = [
    {
      'q': 'Who can donate blood?',
      'a': 'Most healthy adults aged 17–65 who weigh at least 50kg can donate blood every 3 months. Some conditions may affect eligibility.',
    },
    {
      'q': 'How long does donation take?',
      'a': 'The actual donation takes about 10–15 minutes. The whole process including registration takes 45–60 minutes.',
    },
    {
      'q': 'Is blood donation safe?',
      'a': 'Yes, sterile needles are used for each donor and disposed after use. There is no risk of infection from donating.',
    },
    {
      'q': 'What should I eat before donating?',
      'a': 'Eat a healthy meal and drink plenty of fluids (not alcohol) before donating. Avoid fatty foods 24 hours before.',
    },
    {
      'q': 'How often can I donate?',
      'a': 'Whole blood can be donated every 56 days (8 weeks). Platelets can be donated every 7 days, up to 24 times per year.',
    },
    {
      'q': 'What happens to my blood after donation?',
      'a': 'Your blood is tested, processed, and separated into components — red cells, platelets, and plasma — each used for different patients.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppTopBar(title: 'Help & Support', onBack: () => Navigator.pop(context)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroCard(),
            const SizedBox(height: 20),
            _buildContactOptions(),
            const SizedBox(height: 24),
            const Text(
              'Frequently Asked Questions',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 14),
            ..._faqs.asMap().entries.map((e) => _buildFaqTile(e.key, e.value)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Need Help? 🤝',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
          ),
          const SizedBox(height: 6),
          Text(
            'Our support team is available 24/7 to assist you with any queries about blood donation.',
            style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.9), height: 1.6),
          ),
        ],
      ),
    );
  }

  Widget _buildContactOptions() {
    final options = [
      {'icon': Icons.call_rounded, 'label': 'Call Us', 'sub': '+1 800-BLOOD-00', 'color': AppColors.primary},
      {'icon': Icons.chat_bubble_rounded, 'label': 'Live Chat', 'sub': 'Chat with agent', 'color': const Color(0xFF2196F3)},
      {'icon': Icons.email_rounded, 'label': 'Email Us', 'sub': 'support@blood.com', 'color': const Color(0xFF4CAF50)},
    ];

    return Row(
      children: options.map((opt) {
        final color = opt['color'] as Color;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: opt != options.last ? 10 : 0),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(opt['icon'] as IconData, color: color, size: 20),
                ),
                const SizedBox(height: 8),
                Text(
                  opt['label'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  opt['sub'] as String,
                  style: const TextStyle(fontSize: 9, color: AppColors.textLight),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFaqTile(int index, Map<String, String> faq) {
    final isOpen = _openFaq == index;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() => _openFaq = isOpen ? null : index),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      faq['q']!,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: isOpen ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.keyboard_arrow_down_rounded,
                        color: AppColors.primary, size: 22),
                  ),
                ],
              ),
            ),
          ),
          if (isOpen)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                faq['a']!,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textGrey,
                  height: 1.7,
                ),
              ),
            ),
        ],
      ),
    );
  }
}