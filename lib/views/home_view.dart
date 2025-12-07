import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studystay/views/seat_list_view.dart';
import '../controllers/home_controller.dart';
import '../models/ReadingRoom.dart';
import '../models/UserModel.dart';

class HomeView extends StatelessWidget {
  final UserModel user;
  const HomeView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeController(),
      child: _HomeScreen(user: user),
    );
  }
}

class _HomeScreen extends StatelessWidget {
  final UserModel user;
  const _HomeScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<HomeController>(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        leading: const Icon(Icons.menu),
        title: const Text(
          'READING CENTER',
          style: TextStyle(letterSpacing: 1.2),
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),

            SizedBox(
              height: 210,
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

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                controller.banners.length,
                    (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: controller.currentPage == i ? 12 : 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: controller.currentPage == i
                        ? Colors.deepPurple
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            _MenuCard(
              icon: Icons.business,
              title: 'Hostel',
              onTap: () => _showSnack(context, 'Hostel tapped'),
            ),

            _MenuCard(
              icon: Icons.menu_book,
              title: 'Reading Room',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => SeatListScreen(
                    room: ReadingRoom(
                      name: user.readingRoomName,
                      totalSeats: user.totalSeats ?? 0,
                      price: user.unreservedSeatFee ?? 0,
                      monthlyPrice: user.reservedSeatFee ?? 0,
                    ),
                    user: user, // Pass the user object
                  ),
                ),
              ),
            ),

            _MenuCard(
              icon: Icons.restaurant,
              title: 'Mess',
              onTap: () => _showSnack(context, 'Mess tapped'),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }
}

class _BannerCard extends StatelessWidget {
  final dynamic banner;
  const _BannerCard({required this.banner});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  banner.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  banner.subtitle,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
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
        ),
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
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: Colors.white,
      child: ListTile(
        contentPadding:
        const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        leading: Icon(icon, color: Colors.deepPurple, size: 34),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
        onTap: onTap,
      ),
    );
  }
}