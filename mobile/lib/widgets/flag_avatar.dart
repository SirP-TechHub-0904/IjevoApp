import 'package:flutter/material.dart';
import 'package:country_flags/country_flags.dart';

class FlagAvatar extends StatelessWidget {
  final String countryCode;
  final double size;

  const FlagAvatar({
    super.key,
    required this.countryCode,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: CountryFlag.fromCountryCode(
          countryCode,
          shape: const Circle(),
        ),
      ),
    );
  }
}
