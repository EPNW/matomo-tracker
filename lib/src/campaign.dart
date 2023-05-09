/// Describes a campaign.
///
/// Read more about [Campaign Tracking](https://matomo.org/faq/reports/what-is-campaign-tracking-and-why-it-is-important/).
class Campaign {
  /// Creates a campaign description.
  ///
  /// Note: Strings filled with whitespace will be considered as (invalid) empty
  /// values.
  factory Campaign({
    required String name,
    String? keyword,
    String? source,
    String? medium,
    String? content,
    String? id,
    String? group,
    String? placement,
  }) {
    if (name.trim().isEmpty) {
      throw ArgumentError.value(
        name,
        'name',
        'Must not be empty or whitespace only.',
      );
    }

    if (keyword != null && keyword.trim().isEmpty) {
      throw ArgumentError.value(
        keyword,
        'keyword',
        'Must not be empty or whitespace only.',
      );
    }

    if (source != null && source.trim().isEmpty) {
      throw ArgumentError.value(
        source,
        'source',
        'Must not be empty or whitespace only.',
      );
    }

    if (medium != null && medium.trim().isEmpty) {
      throw ArgumentError.value(
        medium,
        'medium',
        'Must not be empty or whitespace only.',
      );
    }

    if (content != null && content.trim().isEmpty) {
      throw ArgumentError.value(
        content,
        'content',
        'Must not be empty or whitespace only.',
      );
    }

    if (id != null && id.trim().isEmpty) {
      throw ArgumentError.value(
        id,
        'id',
        'Must not be empty or whitespace only.',
      );
    }

    if (group != null && group.trim().isEmpty) {
      throw ArgumentError.value(
        group,
        'group',
        'Must not be empty or whitespace only.',
      );
    }

    if (placement != null && placement.trim().isEmpty) {
      throw ArgumentError.value(
        placement,
        'placement',
        'Must not be empty or whitespace only.',
      );
    }

    return Campaign._(
      name: name,
      keyword: keyword,
      source: source,
      medium: medium,
      content: content,
      id: id,
      group: group,
      placement: placement,
    );
  }

  const Campaign._({
    required this.name,
    this.keyword,
    this.source,
    this.medium,
    this.content,
    this.id,
    this.group,
    this.placement,
  });

  /// A descriptive name for the campaign, e.g. a blog post title or email campaign name.
  ///
  /// Corresponds with `mtm_campaign`.
  final String name;

  /// The specific keyword that someone searched for, or category of interest.
  ///
  /// Corresponds with `mtm_keyword`.
  final String? keyword;

  /// The actual source of the traffic, e.g. newsletter, twitter, ebay, etc.
  ///
  /// Requires Matomo Cloud or Marketing Campaigns Reporting Plugin.
  /// Corresponds with `mtm_source`.
  final String? source;

  /// The type of marketing channel, e.g. email, social, paid, etc.
  ///
  /// Requires Matomo Cloud or Marketing Campaigns Reporting Plugin.
  /// Corresponds with `mtm_medium`.
  final String? medium;

  /// This is a specific link or content that somebody clicked. e.g. banner, big-green-button.
  ///
  /// Requires Matomo Cloud or Marketing Campaigns Reporting Plugin.
  /// Corresponds with `mtm_content`.
  final String? content;

  /// A unique identifier for your specific ad. This parameter is often used with the numeric IDs automatically generated by advertising platforms.
  ///
  /// Requires Matomo Cloud or Marketing Campaigns Reporting Plugin.
  /// Corresponds with `mtm_cid`.
  final String? id;

  /// The audience your campaign is targeting e.g. customers, retargeting, etc.
  ///
  /// Requires Matomo Cloud or Matomo 4 or above with Marketing Campaigns Reporting Plugin.
  /// Corresponds with `mtm_group`.
  final String? group;

  ///The placement on an advertising network e.g. newsfeed, sidebar, home-banner, etc.
  ///
  /// Requires Matomo Cloud or Matomo 4 or above with Marketing Campaigns Reporting Plugin.
  /// Corresponds with `mtm_placement`.
  final String? placement;

  Map<String, String> toMap() {
    final mtmKeyword = keyword;
    final mtmSource = source;
    final mtmMedium = medium;
    final mtmContent = content;
    final mtmCid = id;
    final mtmGroup = group;
    final mtmPlacement = placement;

    return {
      'mtm_campaign': name,
      if (mtmKeyword != null) 'mtm_keyword': mtmKeyword,
      if (mtmSource != null) 'mtm_source': mtmSource,
      if (mtmMedium != null) 'mtm_medium': mtmMedium,
      if (mtmContent != null) 'mtm_content': mtmContent,
      if (mtmCid != null) 'mtm_cid': mtmCid,
      if (mtmGroup != null) 'mtm_group': mtmGroup,
      if (mtmPlacement != null) 'mtm_placement': mtmPlacement,
    };
  }
}
