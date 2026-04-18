import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

// ── Avatar Widget ───────────────────────────────────────────────────────────
class AvatarWidget extends StatelessWidget {
  final String name;
  final double size;
  final Color? color;

  const AvatarWidget({super.key, required this.name, this.size = 48, this.color});

  Color _colorFromName(String name) {
    final colors = [
      const Color(0xFFE8304A),
      const Color(0xFF2196F3),
      const Color(0xFF4CAF50),
      const Color(0xFFFF9800),
      const Color(0xFF9C27B0),
      const Color(0xFF00BCD4),
      const Color(0xFFFF5722),
      const Color(0xFF607D8B),
    ];
    return colors[name.codeUnitAt(0) % colors.length];
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.substring(0, 2).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color ?? _colorFromName(name),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          _initials(name),
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: size * 0.35,
          ),
        ),
      ),
    );
  }
}

// ── Blood Badge Widget ──────────────────────────────────────────────────────
class BloodBadge extends StatelessWidget {
  final String type;
  final bool small;

  const BloodBadge({super.key, required this.type, this.small = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 8 : 10,
        vertical: small ? 3 : 6,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.water_drop, color: AppColors.primary, size: small ? 10 : 13),
          const SizedBox(width: 4),
          Text(
            type,
            style: TextStyle(
              fontSize: small ? 10 : 13,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Top Bar Widget ──────────────────────────────────────────────────────────
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final List<Widget>? actions;

  const AppTopBar({super.key, required this.title, this.onBack, this.actions});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: onBack != null
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.textDark),
              onPressed: onBack,
            )
          : null,
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w800,
          color: AppColors.textDark,
        ),
      ),
      actions: actions,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: const Color(0xFFF0F0F0)),
      ),
    );
  }
}

// ── Map Painter ─────────────────────────────────────────────────────────────
class MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;

    final minorRoadPaint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final blockPaint = Paint()
      ..color = AppColors.mapBlock.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    canvas.drawRect(const Rect.fromLTWH(10, 20, 80, 50), blockPaint);
    canvas.drawRect(const Rect.fromLTWH(200, 10, 60, 40), blockPaint);
    canvas.drawRect(const Rect.fromLTWH(280, 80, 70, 55), blockPaint);
    canvas.drawRect(const Rect.fromLTWH(30, 110, 90, 50), blockPaint);

    canvas.drawLine(Offset(0, size.height * 0.3), Offset(size.width, size.height * 0.3), roadPaint);
    canvas.drawLine(Offset(0, size.height * 0.65), Offset(size.width, size.height * 0.65), roadPaint);
    canvas.drawLine(Offset(size.width * 0.25, 0), Offset(size.width * 0.25, size.height), roadPaint);
    canvas.drawLine(Offset(size.width * 0.65, 0), Offset(size.width * 0.65, size.height), roadPaint);
    canvas.drawLine(Offset(0, size.height * 0.5), Offset(size.width, size.height * 0.5), minorRoadPaint);
    canvas.drawLine(Offset(size.width * 0.45, 0), Offset(size.width * 0.45, size.height), minorRoadPaint);
    canvas.drawLine(Offset(size.width * 0.82, 0), Offset(size.width * 0.82, size.height), minorRoadPaint);
  }

  @override
  bool shouldRepaint(_) => false;
}

// ── Seeker Card Widget ───────────────────────────────────────────────────────
class SeekerCard extends StatelessWidget {
  final Map<String, dynamic> seeker;
  final VoidCallback? onDonate;

  const SeekerCard({super.key, required this.seeker, this.onDonate});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AvatarWidget(
                name: seeker['name'] as String,
                size: 50,
                color: seeker['color'] as Color?,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      seeker['name'] as String,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      seeker['time'] as String,
                      style: const TextStyle(fontSize: 11, color: AppColors.textLight),
                    ),
                  ],
                ),
              ),
              BloodBadge(type: seeker['blood'] as String),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            seeker['desc'] as String,
            style: const TextStyle(
              fontSize: 12.5,
              color: AppColors.textGrey,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.location_on, color: AppColors.textLight, size: 14),
              const SizedBox(width: 4),
              Text(
                seeker['location'] as String,
                style: const TextStyle(fontSize: 12, color: AppColors.textLight),
              ),
              const Spacer(),
              SizedBox(
                height: 36,
                child: ElevatedButton(
                  onPressed: onDonate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text(
                    'Donate',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
