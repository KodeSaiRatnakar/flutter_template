import 'package:flutter/material.dart';
import 'package:get/get.dart';

ThemeController threadItThemeController = Get.put(ThemeController());

enum SiteTheme {
  kDark,
  kLight,
}

extension ThemeExt on SiteTheme {
  Color get mainColor {
    switch (this) {
      case SiteTheme.kDark:
        return const Color(0xff83EFFF);
      default:
        return const Color(0xff2e5a61);
    }
  }

  Color get primaryColor {
    switch (this) {
      case SiteTheme.kDark:
        return const Color(0xff2e5a61);
      default:
        return const Color(0xff2e5a61);
    }
  }

  Color get cardColor {
    switch (this) {
      case SiteTheme.kDark:
        return const Color(0xff373844);
      default:
        return const Color(0xff2e5a61);
    }
  }

  Color get backGroundColor {
    switch (this) {
      case SiteTheme.kDark:
        return const Color(0xff2e2b32);
      default:
        return const Color(0xff2e5a61);
    }
  }

  Color get topicAddBorderColor {
    switch (this) {
      case SiteTheme.kDark:
        return const Color(0xff4c5864);
      default:
        return const Color(0xff2e5a61);
    }
  }

  Color get textColor {
    switch (this) {
      case SiteTheme.kDark:
        return Colors.white70;
      default:
        return Colors.black;
    }
  }

  TextStyle get cardHeadingTextStyle {
    switch (this) {
      case SiteTheme.kDark:
        return const TextStyle(
          color: Color(0xff83EFFF),
          fontWeight: FontWeight.w500,
          fontSize: 18,
        );
      default:
        return const TextStyle(
          color: Color(0xff373844),
          fontWeight: FontWeight.bold,
        );
    }
  }

  TextStyle get cardBodyTextStyle {
    switch (this) {
      case SiteTheme.kDark:
        return const TextStyle(
          color: Color(0xffe1e1e1),
          fontWeight: FontWeight.w400,
        );
      default:
        return const TextStyle(
          color: Color(0xff373844),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        );
    }
  }

  TextStyle get cardBodyMedium {
    switch (this) {
      case SiteTheme.kDark:
        return const TextStyle(
          color: Color(
            0xffe1e1e1,
          ),
          fontWeight: FontWeight.w500,
          fontSize: 14,
        );
      default:
        return const TextStyle(
          color: Color(0xff373844),
          fontSize: 15,
          fontWeight: FontWeight.w600,
        );
    }
  }

  TextStyle get likeButtonDisabledTextStyle {
    switch (this) {
      case SiteTheme.kDark:
        return const TextStyle(
          color: Color(0xff83EFFF),
          fontWeight: FontWeight.w500,
          fontSize: 14,
        );
      default:
        return const TextStyle(
          color: Color(0xff373844),
          fontSize: 15,
          fontWeight: FontWeight.w600,
        );
    }
  }

  TextStyle get commentUserTextStyle {
    switch (this) {
      case SiteTheme.kDark:
        return const TextStyle(
          color: Color(0xff83EFFF),
          fontWeight: FontWeight.w400,
          fontSize: 14,
        );
      default:
        return const TextStyle(
          color: Color(0xff373844),
          fontSize: 15,
          fontWeight: FontWeight.w400,
        );
    }
  }

  TextStyle get commentOrLikeTimeStyle {
    switch (this) {
      case SiteTheme.kDark:
        return const TextStyle(
          color: Colors.white38,
          fontSize: 10,
          fontWeight: FontWeight.w400,
        );
      default:
        return const TextStyle(
          color: Color(0xff373844),
          fontSize: 15,
          fontWeight: FontWeight.w400,
        );
    }
  }
}

class ThemeController extends GetxController {
  var currentTheme = SiteTheme.kDark.obs;
}
