import 'package:flutter/material.dart';

enum ExportTemplate {
  instagram,
  instagramStory,
  instagramReel,
  youtubeThumbnail,
  youtubeBanner,
  youtubeShorts,
  facebookPost,
  facebookCover,
  facebookStory,
  twitterPost,
  twitterHeader,
  twitterCard,
  linkedinPost,
  linkedinBanner,
  linkedinStory,
  tiktok,
  pinterest,
  snapchat,
  discord,
  whatsapp,
  telegram,
  wallpaper4k,
  wallpaperHD,
  wallpaperMobile,
}

extension ExportTemplateExtension on ExportTemplate {
  String get displayName {
    switch (this) {
      case ExportTemplate.instagram:
        return 'Instagram Post';
      case ExportTemplate.instagramStory:
        return 'IG Story';
      case ExportTemplate.instagramReel:
        return 'IG Reel';
      case ExportTemplate.youtubeThumbnail:
        return 'YT Thumbnail';
      case ExportTemplate.youtubeBanner:
        return 'YT Banner';
      case ExportTemplate.youtubeShorts:
        return 'YT Shorts';
      case ExportTemplate.facebookPost:
        return 'FB Post';
      case ExportTemplate.facebookCover:
        return 'FB Cover';
      case ExportTemplate.facebookStory:
        return 'FB Story';
      case ExportTemplate.twitterPost:
        return 'Twitter Post';
      case ExportTemplate.twitterHeader:
        return 'Twitter Header';
      case ExportTemplate.twitterCard:
        return 'Twitter Card';
      case ExportTemplate.linkedinPost:
        return 'LinkedIn Post';
      case ExportTemplate.linkedinBanner:
        return 'LinkedIn Banner';
      case ExportTemplate.linkedinStory:
        return 'LinkedIn Story';
      case ExportTemplate.tiktok:
        return 'TikTok';
      case ExportTemplate.pinterest:
        return 'Pinterest';
      case ExportTemplate.snapchat:
        return 'Snapchat';
      case ExportTemplate.discord:
        return 'Discord';
      case ExportTemplate.whatsapp:
        return 'WhatsApp';
      case ExportTemplate.telegram:
        return 'Telegram';
      case ExportTemplate.wallpaper4k:
        return '4K Wallpaper';
      case ExportTemplate.wallpaperHD:
        return 'HD Wallpaper';
      case ExportTemplate.wallpaperMobile:
        return 'Mobile Wallpaper';
    }
  }

  int get width {
    switch (this) {
      case ExportTemplate.instagram:
        return 1080;
      case ExportTemplate.instagramStory:
        return 1080;
      case ExportTemplate.instagramReel:
        return 1080;
      case ExportTemplate.youtubeThumbnail:
        return 1280;
      case ExportTemplate.youtubeBanner:
        return 2560;
      case ExportTemplate.youtubeShorts:
        return 1080;
      case ExportTemplate.facebookPost:
        return 1200;
      case ExportTemplate.facebookCover:
        return 1200;
      case ExportTemplate.facebookStory:
        return 1080;
      case ExportTemplate.twitterPost:
        return 1024;
      case ExportTemplate.twitterHeader:
        return 1500;
      case ExportTemplate.twitterCard:
        return 1200;
      case ExportTemplate.linkedinPost:
        return 1200;
      case ExportTemplate.linkedinBanner:
        return 1584;
      case ExportTemplate.linkedinStory:
        return 1080;
      case ExportTemplate.tiktok:
        return 1080;
      case ExportTemplate.pinterest:
        return 1000;
      case ExportTemplate.snapchat:
        return 1080;
      case ExportTemplate.discord:
        return 1024;
      case ExportTemplate.whatsapp:
        return 1080;
      case ExportTemplate.telegram:
        return 1080;
      case ExportTemplate.wallpaper4k:
        return 3840;
      case ExportTemplate.wallpaperHD:
        return 1920;
      case ExportTemplate.wallpaperMobile:
        return 1080;
    }
  }

  int get height {
    switch (this) {
      case ExportTemplate.instagram:
        return 1080;
      case ExportTemplate.instagramStory:
        return 1920;
      case ExportTemplate.instagramReel:
        return 1920;
      case ExportTemplate.youtubeThumbnail:
        return 720;
      case ExportTemplate.youtubeBanner:
        return 1440;
      case ExportTemplate.youtubeShorts:
        return 1920;
      case ExportTemplate.facebookPost:
        return 630;
      case ExportTemplate.facebookCover:
        return 630;
      case ExportTemplate.facebookStory:
        return 1920;
      case ExportTemplate.twitterPost:
        return 512;
      case ExportTemplate.twitterHeader:
        return 500;
      case ExportTemplate.twitterCard:
        return 628;
      case ExportTemplate.linkedinPost:
        return 627;
      case ExportTemplate.linkedinBanner:
        return 396;
      case ExportTemplate.linkedinStory:
        return 1920;
      case ExportTemplate.tiktok:
        return 1920;
      case ExportTemplate.pinterest:
        return 1500;
      case ExportTemplate.snapchat:
        return 1920;
      case ExportTemplate.discord:
        return 1024;
      case ExportTemplate.whatsapp:
        return 1080;
      case ExportTemplate.telegram:
        return 1080;
      case ExportTemplate.wallpaper4k:
        return 2160;
      case ExportTemplate.wallpaperHD:
        return 1080;
      case ExportTemplate.wallpaperMobile:
        return 1920;
    }
  }

  IconData get icon {
    switch (this) {
      case ExportTemplate.instagram:
      case ExportTemplate.instagramStory:
      case ExportTemplate.instagramReel:
        return Icons.camera_alt_outlined;
      case ExportTemplate.youtubeThumbnail:
      case ExportTemplate.youtubeBanner:
      case ExportTemplate.youtubeShorts:
        return Icons.play_circle_outline;
      case ExportTemplate.facebookPost:
      case ExportTemplate.facebookCover:
      case ExportTemplate.facebookStory:
        return Icons.facebook_outlined;
      case ExportTemplate.twitterPost:
      case ExportTemplate.twitterHeader:
      case ExportTemplate.twitterCard:
        return Icons.alternate_email;
      case ExportTemplate.linkedinPost:
      case ExportTemplate.linkedinBanner:
      case ExportTemplate.linkedinStory:
        return Icons.work_outline;
      case ExportTemplate.tiktok:
        return Icons.music_video_outlined;
      case ExportTemplate.pinterest:
        return Icons.push_pin_outlined;
      case ExportTemplate.snapchat:
        return Icons.camera_outlined;
      case ExportTemplate.discord:
        return Icons.discord_outlined;
      case ExportTemplate.whatsapp:
      case ExportTemplate.telegram:
        return Icons.chat_bubble_outline;
      case ExportTemplate.wallpaper4k:
      case ExportTemplate.wallpaperHD:
      case ExportTemplate.wallpaperMobile:
        return Icons.wallpaper_outlined;
    }
  }

  Color get brandColor {
    switch (this) {
      case ExportTemplate.instagram:
      case ExportTemplate.instagramStory:
      case ExportTemplate.instagramReel:
        return const Color(0xFFE4405F);
      case ExportTemplate.youtubeThumbnail:
      case ExportTemplate.youtubeBanner:
      case ExportTemplate.youtubeShorts:
        return const Color(0xFFFF0000);
      case ExportTemplate.facebookPost:
      case ExportTemplate.facebookCover:
      case ExportTemplate.facebookStory:
        return const Color(0xFF1877F2);
      case ExportTemplate.twitterPost:
      case ExportTemplate.twitterHeader:
      case ExportTemplate.twitterCard:
        return const Color(0xFF1DA1F2);
      case ExportTemplate.linkedinPost:
      case ExportTemplate.linkedinBanner:
      case ExportTemplate.linkedinStory:
        return const Color(0xFF0077B5);
      case ExportTemplate.tiktok:
        return const Color(0xFF000000);
      case ExportTemplate.pinterest:
        return const Color(0xFFBD081C);
      case ExportTemplate.snapchat:
        return const Color(0xFFFFFC00);
      case ExportTemplate.discord:
        return const Color(0xFF5865F2);
      case ExportTemplate.whatsapp:
        return const Color(0xFF25D366);
      case ExportTemplate.telegram:
        return const Color(0xFF0088CC);
      case ExportTemplate.wallpaper4k:
      case ExportTemplate.wallpaperHD:
      case ExportTemplate.wallpaperMobile:
        return const Color(0xFF6C5CE7);
    }
  }

  String get category {
    switch (this) {
      case ExportTemplate.instagram:
      case ExportTemplate.instagramStory:
      case ExportTemplate.instagramReel:
        return 'Instagram';
      case ExportTemplate.youtubeThumbnail:
      case ExportTemplate.youtubeBanner:
      case ExportTemplate.youtubeShorts:
        return 'YouTube';
      case ExportTemplate.facebookPost:
      case ExportTemplate.facebookCover:
      case ExportTemplate.facebookStory:
        return 'Facebook';
      case ExportTemplate.twitterPost:
      case ExportTemplate.twitterHeader:
      case ExportTemplate.twitterCard:
        return 'Twitter';
      case ExportTemplate.linkedinPost:
      case ExportTemplate.linkedinBanner:
      case ExportTemplate.linkedinStory:
        return 'LinkedIn';
      case ExportTemplate.tiktok:
        return 'TikTok';
      case ExportTemplate.pinterest:
        return 'Pinterest';
      case ExportTemplate.snapchat:
        return 'Snapchat';
      case ExportTemplate.discord:
        return 'Discord';
      case ExportTemplate.whatsapp:
        return 'WhatsApp';
      case ExportTemplate.telegram:
        return 'Telegram';
      case ExportTemplate.wallpaper4k:
      case ExportTemplate.wallpaperHD:
      case ExportTemplate.wallpaperMobile:
        return 'Wallpapers';
    }
  }

  String get name => toString().split('.').last;

  String get aspectRatio {
    final w = width;
    final h = height;
    final gcd = _gcd(w, h);
    return '${w ~/ gcd}:${h ~/ gcd}';
  }

  int _gcd(int a, int b) {
    return b == 0 ? a : _gcd(b, a % b);
  }
}