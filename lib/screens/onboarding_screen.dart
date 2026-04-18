import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'signin_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final List<Map<String, String>> data = [
    {
      "title": "Locate Donors Around You",
      "desc": "Lorem ipsum is simply dummy text of the printing and typesetting",
      "image": "assets/signin.jpg",
    },
    {
      "title": "Welcome RedFlow:\nNearby City",
      "desc": "Lorem ipsum is simply dummy text of the printing and typesetting",
      "image": "assets/signin.jpg",
    },
  ];

  void nextPage() {
    if (currentIndex < data.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void goToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SignUpScreen()),
    );
  }

  void goToSignIn() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SignInScreen()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: data.length,
                onPageChanged: (i) => setState(() => currentIndex = i),
                itemBuilder: (context, index) {
                  return _buildPage(data[index], index);
                },
              ),
            ),

            // Bottom controls
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () => _controller.jumpToPage(data.length - 1),
                    child: const Text(
                      "Skip",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),

                  const Spacer(),

                  _indicator(),

                  const Spacer(),

                  currentIndex == data.length - 1
                      ? const SizedBox(width: 48)
                      : FloatingActionButton(
                          onPressed: nextPage,
                          backgroundColor: Colors.red,
                          mini: true,
                          elevation: 0,
                          child: const Icon(Icons.arrow_forward, color: Colors.white),
                        ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(Map<String, String> item, int index) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 30),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Expanded(
                    child: Image.asset(item["image"]!, fit: BoxFit.contain),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item["title"]!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item["desc"]!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),

                  if (index == 1) ...[
                    const SizedBox(height: 20),
                    _button("Sign Up", Colors.red, Colors.white, onTap: goToSignUp),
                    const SizedBox(height: 10),
                    _button("Sign In", Colors.white, Colors.red, border: true, onTap: goToSignIn),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _button(
    String text,
    Color bg,
    Color fg, {
    bool border = false,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          elevation: 0,
          side: border ? const BorderSide(color: Colors.red) : null,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _indicator() {
    return Row(
      children: List.generate(
        data.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: currentIndex == index ? 12 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: currentIndex == index ? Colors.red : Colors.grey,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}