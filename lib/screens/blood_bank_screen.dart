import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../widgets/shared_widgets.dart';

class BloodBankScreen extends StatefulWidget {
  const BloodBankScreen({super.key});

  @override
  State<BloodBankScreen> createState() => _BloodBankScreenState();
}

class _BloodBankScreenState extends State<BloodBankScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _search = '';

  List<Map<String, dynamic>> get _filtered => bloodBanksList
      .where((b) =>
          (b['name'] as String).toLowerCase().contains(_search.toLowerCase()) ||
          (b['location'] as String).toLowerCase().contains(_search.toLowerCase()))
      .toList();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppTopBar(
        title: 'Blood Bank',
        onBack: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _filtered.length,
              itemBuilder: (context, i) => _buildBankCard(_filtered[i]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 14),
                  Icon(Icons.search, color: Colors.grey.shade400, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (v) => setState(() => _search = v),
                      decoration: const InputDecoration(
                        hintText: 'Search blood banks...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Color(0xFFBBBBBB), fontSize: 14),
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.tune, color: Colors.white, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildBankCard(Map<String, dynamic> bank) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => BloodBankDetailScreen(bank: bank)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.mapBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(bank['emoji'] as String, style: const TextStyle(fontSize: 30)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bank['name'] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 12, color: AppColors.textLight),
                      const SizedBox(width: 2),
                      Text(
                        bank['location'] as String,
                        style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFFC107)),
                      const SizedBox(width: 3),
                      Text(
                        '${bank['rating']}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '• ${bank['distance']}',
                        style: const TextStyle(fontSize: 11, color: AppColors.textLight),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textLight),
          ],
        ),
      ),
    );
  }
}

// ── Blood Bank Detail Screen ─────────────────────────────────────────────────
class BloodBankDetailScreen extends StatelessWidget {
  final Map<String, dynamic> bank;

  const BloodBankDetailScreen({super.key, required this.bank});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.textDark),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.mapBg, Color(0xFFD0DFE8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Text(bank['emoji'] as String, style: const TextStyle(fontSize: 80)),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          bank['name'] as String,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3CD),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star_rounded, color: Color(0xFFFFC107), size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '${bank['rating']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF856404),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 14, color: AppColors.textGrey),
                      const SizedBox(width: 4),
                      Text(bank['location'] as String,
                          style: const TextStyle(color: AppColors.textGrey, fontSize: 13)),
                      const SizedBox(width: 12),
                      const Icon(Icons.schedule, size: 14, color: AppColors.textGrey),
                      const SizedBox(width: 4),
                      Text(bank['hours'] as String,
                          style: const TextStyle(color: AppColors.textGrey, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    bank['desc'] as String,
                    style: const TextStyle(
                        fontSize: 13.5, color: AppColors.textGrey, height: 1.7),
                  ),
                  const SizedBox(height: 20),
                  _buildReviewSection(),
                  const SizedBox(height: 24),
                  _buildActionButtons(context, bank['phone'] as String),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reviews (${bank['reviews']})',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textDark),
          ),
          const SizedBox(height: 12),
          // Write Review field
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                SizedBox(width: 14),
                Text('Write A Review', style: TextStyle(color: AppColors.textLight, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 16),
          Row(
            children: [
              const AvatarWidget(name: 'David Martin', size: 44),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('David Martin',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                    Row(
                      children: [
                        const Text('1 hour ago',
                            style: TextStyle(fontSize: 11, color: AppColors.textLight)),
                        const SizedBox(width: 8),
                        ...List.generate(
                          5,
                          (i) => Icon(
                            i < 4 ? Icons.star_rounded : Icons.star_half_rounded,
                            color: const Color(0xFFFFC107),
                            size: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Great facility with professional staff. The donation process was smooth and comfortable. Highly recommend for anyone looking to donate.',
            style: TextStyle(fontSize: 12.5, color: AppColors.textGrey, height: 1.6),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _reactionButton(Icons.thumb_up_rounded, '12'),
              const SizedBox(width: 10),
              _reactionButton(Icons.thumb_down_rounded, '2'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _reactionButton(IconData icon, String count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.textGrey),
          const SizedBox(width: 6),
          Text(count, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textGrey)),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, String phone) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.call_rounded, color: AppColors.primary, size: 18),
            label: const Text('Call', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 15)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary, width: 2),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.map_rounded, color: Colors.white, size: 18),
            label: const Text('Get Direction', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
      ],
    );
  }
}
