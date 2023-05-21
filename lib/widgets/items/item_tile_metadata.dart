import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:glider/models/item.dart';
import 'package:glider/models/item_type.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/utils/animation_util.dart';
import 'package:glider/widgets/common/fade_hero.dart';
import 'package:glider/widgets/common/metadata_item.dart';
import 'package:glider/widgets/common/metadata_username.dart';
import 'package:glider/widgets/common/smooth_animated_size.dart';
import 'package:glider/widgets/common/smooth_animated_switcher.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:relative_time/relative_time.dart';

class ItemTileMetadata extends HookConsumerWidget {
  const ItemTileMetadata(
    this.item, {
    super.key,
    this.root,
    this.dense = false,
    this.interactive = false,
    this.opacity = 1,
  });

  final Item item;
  final Item? root;
  final bool dense;
  final bool interactive;
  final double opacity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    final AsyncData<bool>? favoritedData =
        ref.watch(favoritedProvider(item.id)).asData;
    final AsyncData<bool>? upvotedData =
        ref.watch(upvotedProvider(item.id)).asData;

    return FadeHero(
      tag: 'item_${item.id}_metadata',
      child: AnimatedOpacity(
        opacity: opacity,
        duration: AnimationUtil.defaultDuration,
        child: Row(
          children: <Widget>[
            if (favoritedData != null)
              SmoothAnimatedSwitcher.horizontal(
                condition: favoritedData.value,
                child: const MetadataItem(
                  icon: FluentIcons.star_24_regular,
                  highlight: true,
                ),
              ),
            if (item.score != null && item.type != ItemType.job)
              SmoothAnimatedSize(
                child: _buildUpvotedMetadata(
                  upvoted: upvotedData?.value ?? false,
                ),
              )
            else if (upvotedData != null)
              SmoothAnimatedSwitcher.horizontal(
                condition: upvotedData.value,
                child: _buildUpvotedMetadata(upvoted: upvotedData.value),
              ),
            if (item.descendants != null &&
                item.type != ItemType.comment &&
                item.type != ItemType.pollopt)
              SmoothAnimatedSize(
                child: MetadataItem(
                  icon: FluentIcons.comment_24_regular,
                  text: item.descendants?.toString(),
                ),
              ),
            SmoothAnimatedSwitcher.horizontal(
              key: ValueKey<String>('item_${item.id}_dead_${item.dead}'),
              condition: item.dead,
              child: const MetadataItem(icon: FluentIcons.flag_24_regular),
            ),
            if (item.deleted) ...<Widget>[
              const MetadataItem(icon: FluentIcons.delete_24_regular),
              Text(
                '[${AppLocalizations.of(context).deleted}]',
                style: textTheme.bodyMedium
                    ?.copyWith(fontSize: textTheme.bodySmall?.fontSize),
              ),
              const SizedBox(width: 8),
            ] else if (item.by != null &&
                item.type != ItemType.pollopt) ...<Widget>[
              MetadataUsername(
                by: item.by!,
                rootBy: root?.by,
                tappable: !item.preview,
              ),
              const SizedBox(width: 8),
            ],
            if (item.by != null &&
                (ref.watch(blockedProvider(item.by!)).value ??
                    false)) ...<Widget>[
              Text(
                '[${AppLocalizations.of(context).blocked}]',
                style: textTheme.bodyMedium
                    ?.copyWith(fontSize: textTheme.bodySmall?.fontSize),
              ),
              const SizedBox(width: 8),
            ],
            if (item.hasOriginalYear)
              MetadataItem(
                icon: FluentIcons.shifts_activity_24_regular,
                text: AppLocalizations.of(context).fromYear(item.originalYear!),
              ),
            SmoothAnimatedSwitcher.horizontal(
              condition: item.cache,
              child: const MetadataItem(icon: FluentIcons.cloud_off_24_regular),
            ),
            if (interactive) _buildCollapsedIndicator(),
            if (item.type != ItemType.pollopt && item.time != null) ...<Widget>[
              const Spacer(),
              Text(
                item.timeDate!.relativeTime(context),
                style: textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildUpvotedMetadata({required bool upvoted}) {
    return MetadataItem(
      key: ValueKey<String>('item_${item.id}_score_${item.score}'),
      icon: FluentIcons.arrow_up_24_regular,
      text: item.score?.toString(),
      highlight: upvoted,
    );
  }

  Widget _buildCollapsedIndicator() {
    return SmoothAnimatedSwitcher(
      condition: dense,
      child: MetadataItem(
        icon: FluentIcons.add_circle_24_regular,
        text: item.id != root?.id &&
                item.descendants != null &&
                item.descendants! > 0
            ? item.descendants.toString()
            : null,
      ),
    );
  }
}
