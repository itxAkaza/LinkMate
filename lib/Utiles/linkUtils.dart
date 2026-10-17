class LinkUtils {
  // 1. Extract the actual URL from messy shared text
  static String? extractUrl(String text) {
    final RegExp urlRegExp = RegExp(
      r'((https?:\/\/)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*))',
      caseSensitive: false,
    );

    final match = urlRegExp.firstMatch(text);
    if (match == null) return null;

    String rawUrl = match.group(0)!;
    return normalizeUrl(rawUrl);
  }

  // 2. Ensure URL always has https:// and clean formatting
  static String normalizeUrl(String url) {
    String clean = url.trim();
    if (!clean.startsWith('http://') && !clean.startsWith('https://')) {
      clean = 'https://$clean';
    }
    // Remove trailing slash for consistency (e.g. https://google.com/ -> https://google.com)
    if (clean.endsWith('/')) {
      clean = clean.substring(0, clean.length - 1);
    }
    return clean;
  }

  // 3. Automatically detect category (Matches your Figma UI categories directly!)
  static String detectCategory(String url) {
    final lowerUrl = url.toLowerCase();

    if (lowerUrl.contains('youtube.com') ||
        lowerUrl.contains('youtu.be') ||
        lowerUrl.contains('tiktok.com') ||
        lowerUrl.contains('vimeo.com') ||
        lowerUrl.contains('twitch.tv')) {
      return 'Videos';
    }

    if (lowerUrl.contains('instagram.com') ||
        lowerUrl.contains('twitter.com') ||
        lowerUrl.contains('x.com') ||
        lowerUrl.contains('facebook.com') ||
        lowerUrl.contains('reddit.com') ||
        lowerUrl.contains('threads.net')) {
      return 'Social';
    }

    if (lowerUrl.contains('linkedin.com') ||
        lowerUrl.contains('slack.com') ||
        lowerUrl.contains('notion.so') ||
        lowerUrl.contains('figma.com') ||
        lowerUrl.contains('upwork.com') ||
        lowerUrl.contains('fiverr.com')) {
      return 'Work';
    }

    if (lowerUrl.contains('github.com') ||
        lowerUrl.contains('stackoverflow.com') ||
        lowerUrl.contains('leetcode.com') ||
        lowerUrl.contains('coursera.org') ||
        lowerUrl.contains('udemy.com') ||
        lowerUrl.contains('pub.dev')) {
      return 'Study';
    }

    if (lowerUrl.contains('medium.com') ||
        lowerUrl.contains('dev.to') ||
        lowerUrl.contains('substack.com') ||
        lowerUrl.contains('hashnode.com') ||
        lowerUrl.contains('wikipedia.org')) {
      return 'Articles';
    }

    if (lowerUrl.contains('espn.com') ||
        lowerUrl.contains('cricinfo.com') ||
        lowerUrl.contains('fifa.com') ||
        lowerUrl.contains('skysports.com')) {
      return 'Sports';
    }

    return 'Web'; // Clean default matching your UI list
  }

  // 4. Production-grade URL validation
  static bool isValidUrl(String url) {
    final clean = normalizeUrl(url);
    final uri = Uri.tryParse(clean);
    if (uri == null) return false;

    final hasValidScheme = uri.isScheme('http') || uri.isScheme('https');
    final hasValidHost = uri.host.isNotEmpty && uri.host.contains('.') && !uri.host.endsWith('.');

    return hasValidScheme && hasValidHost;
  }
}