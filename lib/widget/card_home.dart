import 'package:flutter/material.dart';

class CardProdactHome extends StatelessWidget {
  const CardProdactHome({
    super.key,
    required this.nameProdact,
    required this.iconProdact,
    required this.onTap,
    required this.color,
  });

  final String nameProdact;
  final IconData iconProdact;
  final void Function()? onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 12.0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.0),
        splashColor: Colors.white.withOpacity(0.2),
        highlightColor: Colors.white.withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(iconProdact, color: Colors.white, size: 48),
              const SizedBox(height: 12),
              Text(
                nameProdact,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
