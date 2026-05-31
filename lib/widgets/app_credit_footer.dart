// ignore_for_file: prefer_const_constructors, unnecessary_const

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppCreditFooter extends StatelessWidget {
  const AppCreditFooter({super.key});

  Future<void> _openWebsoftWebsite() async {
    final Uri uri = Uri.parse('https://sanjoggodar.com.np/');
    final bool launched = await launchUrl(
      uri,
      mode: LaunchMode.platformDefault,
    );
    if (!launched) {
      throw Exception('Could not open https://sanjoggodar.com.np/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Material(
        color: const Color(0xFFF8FAFC),
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: Color(0xFFE5E7EB), width: 1),
            ),
          ),
          child: TextButton(
            onPressed: _openWebsoftWebsite,
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF1F2A74),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: const Text(
              'v 1.0.0, Powered by Websoft Technologies Nepal',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.underline,
                decorationColor: Color(0xFF1F2A74),
              ),
            ),
          ),
        ),
      ),
    );
  }
}