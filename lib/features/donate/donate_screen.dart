import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class DonateScreen extends StatefulWidget {
  const DonateScreen({super.key});

  @override
  State<DonateScreen> createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {
  double _amount = 50;
  String _fund = 'General';
  String _frequency = 'One time';

  static const _amounts = [25.0, 50.0, 100.0, 250.0, 500.0, 1000.0];
  static const _funds = ['General', 'Missions', 'Building', 'Benevolence'];
  static const _frequencies = ['One time', 'Weekly', 'Monthly', 'Yearly'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Give')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'Thank you for your generosity.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${_amount.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.w700,
                      color: AppColors.tpogBlueLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$_fund • $_frequency',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Amount',
            style: TextStyle(fontSize: 11, letterSpacing: 1.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textTertiary),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final a in _amounts)
                ChoiceChip(
                  selected: _amount == a,
                  onSelected: (_) => setState(() => _amount = a),
                  label: Text('\$${a.toStringAsFixed(0)}'),
                  selectedColor: AppColors.tpogBlue,
                  backgroundColor: AppColors.surface,
                  side: const BorderSide(color: AppColors.border),
                  labelStyle: TextStyle(
                    color: _amount == a
                        ? Colors.white
                        : AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ActionChip(
                label: const Text('Custom'),
                onPressed: _customAmount,
                backgroundColor: AppColors.surface,
                side: const BorderSide(color: AppColors.border),
                labelStyle: const TextStyle(color: AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Fund',
            style: TextStyle(fontSize: 11, letterSpacing: 1.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textTertiary),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: [
              for (final f in _funds)
                ChoiceChip(
                  selected: _fund == f,
                  onSelected: (_) => setState(() => _fund = f),
                  label: Text(f),
                  selectedColor: AppColors.tpogBlue,
                  backgroundColor: AppColors.surface,
                  side: const BorderSide(color: AppColors.border),
                  labelStyle: TextStyle(
                    color: _fund == f ? Colors.white : AppColors.textPrimary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Frequency',
            style: TextStyle(fontSize: 11, letterSpacing: 1.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textTertiary),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: [
              for (final f in _frequencies)
                ChoiceChip(
                  selected: _frequency == f,
                  onSelected: (_) => setState(() => _frequency = f),
                  label: Text(f),
                  selectedColor: AppColors.tpogBlue,
                  backgroundColor: AppColors.surface,
                  side: const BorderSide(color: AppColors.border),
                  labelStyle: TextStyle(
                    color:
                        _frequency == f ? Colors.white : AppColors.textPrimary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              icon: const Icon(Icons.lock_outline),
              label: Text('Give \$${_amount.toStringAsFixed(0)} $_frequency'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: _giveTapped,
            ),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock_outline,
                    size: 12, color: AppColors.textTertiary),
                SizedBox(width: 4),
                Text(
                  'Secured by Stripe',
                  style: TextStyle(
                    color: AppColors.textTertiary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _customAmount() async {
    final controller = TextEditingController();
    final v = await showDialog<double>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Custom amount'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: '\$0'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final parsed = double.tryParse(controller.text);
              Navigator.pop(ctx, parsed);
            },
            child: const Text('Set'),
          ),
        ],
      ),
    );
    if (v != null && v > 0) setState(() => _amount = v);
  }

  void _giveTapped() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        icon: const Icon(Icons.check_circle,
            color: AppColors.success, size: 48),
        title: const Text('Thank you'),
        content: Text(
          'Your gift of \$${_amount.toStringAsFixed(0)} to the $_fund fund has been received.',
          textAlign: TextAlign.center,
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}
