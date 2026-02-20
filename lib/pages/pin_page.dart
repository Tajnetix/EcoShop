import 'package:flutter/material.dart';

class PinPage extends StatefulWidget {
  const PinPage({super.key});

  @override
  State<PinPage> createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  final List<String> _pin = [];

  void _addDigit(String digit) {
    if (_pin.length < 4) {
      setState(() {
        _pin.add(digit);
      });

      if (_pin.length == 4) {
        _onComplete();
      }
    }
  }

  void _removeDigit() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin.removeLast();
      });
    }
  }

  void _onComplete() {
    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PIN set successfully!'),
          backgroundColor: Color(0xFF1B5E20),
        ),
      );

      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/login',
          (route) => false,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FBEF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1B5E20)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),
          _header(),
          const SizedBox(height: 24),
          _pinDisplay(),
          const SizedBox(height: 20),
          _keypad(),
        ],
      ),
    );
  }

  // ---------- UI PARTS ----------

  Widget _header() {
    return Column(
      children: const [
        CircleAvatar(
          radius: 30,
          backgroundColor: Color(0xFFE8F5E9),
          child: Icon(Icons.lock, size: 32, color: Color(0xFF1B5E20)),
        ),
        SizedBox(height: 12),
        Text(
          'ENTER YOUR FOUR DIGITS PIN',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B5E20),
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Add a 4-digit number to secure your account',
          style: TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _pinDisplay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        final filled = index < _pin.length;
        return Container(
          margin: const EdgeInsets.all(8),
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF1B5E20)),
            color: filled ? const Color(0xFF1B5E20) : Colors.transparent,
          ),
        );
      }),
    );
  }

  Widget _keypad() {
    final keys = [
      '1','2','3',
      '4','5','6',
      '7','8','9',
      '','0','⌫'
    ];

    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 60),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.3,
        ),
        itemCount: keys.length,
        itemBuilder: (context, index) {
          final key = keys[index];

          if (key.isEmpty) return const SizedBox();

          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              if (key == '⌫') {
                _removeDigit();
              } else {
                _addDigit(key);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  key,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B5E20),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}