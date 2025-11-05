import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studystay/views/seat_list_view.dart';
import '../controllers/home_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeController(),
      child: const _HomeScreen(),
    );
  }
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen();

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<HomeController>(context);

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu),
        title: const Text('READING CENTER'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ---------- AUTO-SCROLL BANNER ----------
            SizedBox(
              height: 200,
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: controller.banners.length,
                itemBuilder: (_, index) {
                  final banner = controller.banners[index];
                  return _BannerCard(banner: banner);
                },
              ),
            ),
            const SizedBox(height: 8),
            // Dots indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                controller.banners.length,
                    (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: controller.currentPage == i ? 12 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: controller.currentPage == i
                        ? Colors.deepPurple
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ---------- MENU CARDS ----------
            _MenuCard(
              icon: Icons.business,
              title: 'Hostel',
              onTap: () => _showSnack(context, 'Hostel tapped'),
            ),
          _MenuCard(
            icon: Icons.menu_book,
            title: 'Reading Room',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SeatListScreen()),
            ),
          ),
            _MenuCard(
              icon: Icons.restaurant,
              title: 'Mess',
              onTap: () => _showSnack(context, 'Mess tapped'),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

// ------------------------------------------------------------
// Banner card
class _BannerCard extends StatelessWidget {
  final dynamic banner;
  const _BannerCard({required this.banner});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  banner.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  banner.subtitle,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                const Spacer(),
                const Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    'EXCELLENCE',
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color(0xFFE3F2FD),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple, size: 32),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        onTap: onTap,
      ),
    );
  }
}