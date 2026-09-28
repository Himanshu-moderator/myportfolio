import 'package:flutter/material.dart';
import 'package:three_d_portfolio/utils/constants.dart';
import 'package:three_d_portfolio/personal_data/portfolio_content.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.cardBackground,
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '© ${DateTime.now().year} ${SiteBranding.formalName} All rights reserved.',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            SiteBranding.footerTagline,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}