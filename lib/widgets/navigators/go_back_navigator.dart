import 'package:flutter/material.dart';

import '../../services/app_localizations.dart';

class GoBackNavigator extends StatelessWidget {
  final void Function(String) onTabSelected;

  const GoBackNavigator({Key? key, required this.onTabSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black87,
        border: Border(
          top: BorderSide(color: Colors.white, width: 0.5),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildButton(
            context,
            icon: "⬅️️",
            label: AppLocalizations.of(context)!.translate('back'),
            onTap: () => onTabSelected('back'),
          ),
          _buildButton(
            context,
            icon: "🚪",
            label: AppLocalizations.of(context)!.translate('exit'),
            onTap: () => onTabSelected('exit'),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context,
      {required String icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
