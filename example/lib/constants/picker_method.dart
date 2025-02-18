///
/// [Author] Alex (https://github.com/Alex525)
/// [Date] 2020-05-30 20:56
///

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_assets_picker_demo/customs/dl_custom.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

/// Define a regular pick method.
class PickMethod {
  const PickMethod({
    required this.icon,
    required this.name,
    required this.description,
    required this.method,
    this.onLongPress,
  });

  factory PickMethod.image(int maxAssetsCount) {
    const ColorScheme colorScheme = ColorScheme.light();

    int maxAssets = 9;
    int pageSize = 320;
    int pathThumbSize = 200;
    int gridCount = 4;

    return PickMethod(
      icon: '🖼️',
      name: 'Image picker',
      description: 'Only pick image from device.',
      method: (BuildContext context, List<AssetEntity> assets) {
        DefaultAssetPickerProvider provider = DLAssetPickerProvider(
          maxAssets: maxAssets,
          pageSize: pageSize,
          pathThumbSize: pathThumbSize,
          selectedAssets: assets,);

        return DLAssetPicker.pickAssets(context,
          maxAssets: maxAssetsCount,
          selectedAssets: assets,
          requestType: RequestType.image,
          specialPickerType: SpecialPickerType.wechatMoment,
          provider:provider,
          pickerTheme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.white,
            textTheme: const TextTheme(
              bodyText1:TextStyle(
                color: Colors.blue,
              ),
              caption: TextStyle(
                color: Colors.blue,
              ),
            ),
          ),
        );
        // return AssetPicker.pickAssets(
        //   context,
        //   maxAssets: maxAssetsCount,
        //   selectedAssets: assets,
        //   requestType: RequestType.image,
        // );

      },
    );
  }

  factory PickMethod.video(int maxAssetsCount) {

    int maxAssets = 1;
    int pageSize = 320;
    int pathThumbSize = 200;
    int gridCount = 4;

    return PickMethod(
      icon: '🎞',
      name: 'Video picker',
      description: 'Only pick video from device.',
      method: (BuildContext context, List<AssetEntity> assets) {
        DefaultAssetPickerProvider provider = DLAssetPickerProvider(
          maxAssets: maxAssets,
          pageSize: pageSize,
          requestType: RequestType.video,
          pathThumbSize: pathThumbSize,
          selectedAssets: assets,);

        return DLAssetPicker.pickAssets(context,
          maxAssets: maxAssetsCount,
          selectedAssets: assets,
          requestType: RequestType.video,
          provider:provider,
          selectPredicate: (BuildContext context, AssetEntity asset, bool isSelected){
            if (asset.type == AssetType.video) {
              log('asset.duration:${asset.duration}');
              //根据视频长度过滤
              if (asset.duration > 30) {
                log('选取视频的长度不能超过30秒');
                return false;
              }
            }
            return true;
          },
          pickerTheme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.white,
            textTheme: const TextTheme(
              bodyText1:TextStyle(
                color: Colors.blue,
              ),
              caption: TextStyle(
                color: Colors.blue,
              ),
            ),
          ),
        );
        return AssetPicker.pickAssets(
          context,
          maxAssets: maxAssetsCount,
          selectedAssets: assets,
          requestType: RequestType.video,
        );
      },
    );
  }

  factory PickMethod.audio(int maxAssetsCount) {
    return PickMethod(
      icon: '🎶',
      name: 'Audio picker',
      description: 'Only pick audio from device.',
      method: (BuildContext context, List<AssetEntity> assets) {
        return AssetPicker.pickAssets(
          context,
          maxAssets: maxAssetsCount,
          selectedAssets: assets,
          requestType: RequestType.audio,
        );
      },
    );
  }

  factory PickMethod.camera({
    required int maxAssetsCount,
    required Function(BuildContext, AssetEntity) handleResult,
  }) {
    return PickMethod(
      icon: '📷',
      name: 'Pick from camera',
      description: 'Allow pick an asset through camera.',
      method: (BuildContext context, List<AssetEntity> assets) {
        return AssetPicker.pickAssets(
          context,
          maxAssets: maxAssetsCount,
          selectedAssets: assets,
          requestType: RequestType.common,
          specialItemPosition: SpecialItemPosition.prepend,
          specialItemBuilder: (BuildContext context) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () async {
                final AssetEntity? result = await CameraPicker.pickFromCamera(
                  context,
                  enableRecording: true,
                );
                if (result != null) {
                  handleResult(context, result);
                }
              },
              child: const Center(
                child: Icon(Icons.camera_enhance, size: 42.0),
              ),
            );
          },
        );
      },
    );
  }

  factory PickMethod.cameraAndStay({required int maxAssetsCount}) {
    return PickMethod(
      icon: '📸',
      name: 'Pick from camera and stay',
      description: 'Take a photo or video with the camera picker, '
          'select the result and stay in the entities list.',
      method: (BuildContext context, List<AssetEntity> assets) {
        return AssetPicker.pickAssets(
          context,
          maxAssets: maxAssetsCount,
          selectedAssets: assets,
          requestType: RequestType.common,
          specialItemPosition: SpecialItemPosition.prepend,
          specialItemBuilder: (BuildContext context) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () async {
                final AssetEntity? result = await CameraPicker.pickFromCamera(
                  context,
                  enableRecording: true,
                );
                if (result == null) {
                  return;
                }
                final AssetPicker<AssetEntity, AssetPathEntity> picker =
                    context.findAncestorWidgetOfExactType()!;
                final DefaultAssetPickerProvider p =
                    picker.builder.provider as DefaultAssetPickerProvider;
                await p.currentPathEntity!.refreshPathProperties();
                await p.switchPath(p.currentPathEntity!);
                p.selectAsset(result);
              },
              child: const Center(
                child: Icon(Icons.camera_enhance, size: 42.0),
              ),
            );
          },
        );
      },
    );
  }

  factory PickMethod.common(int maxAssetsCount) {
    return PickMethod(
      icon: '📹',
      name: 'Common picker',
      description: 'Pick images and videos.',
      method: (BuildContext context, List<AssetEntity> assets) {
        return AssetPicker.pickAssets(
          context,
          maxAssets: maxAssetsCount,
          selectedAssets: assets,
          requestType: RequestType.common,
        );
      },
    );
  }

  factory PickMethod.threeItemsGrid(int maxAssetsCount) {
    return PickMethod(
      icon: '🔲',
      name: '3 items grid',
      description: 'Picker will served as 3 items on cross axis. '
          '(pageSize must be a multiple of gridCount)',
      method: (BuildContext context, List<AssetEntity> assets) {
        return AssetPicker.pickAssets(
          context,
          gridCount: 3,
          pageSize: 120,
          maxAssets: maxAssetsCount,
          selectedAssets: assets,
          requestType: RequestType.all,
        );
      },
    );
  }

  factory PickMethod.customFilterOptions(int maxAssetsCount) {
    return PickMethod(
      icon: '⏳',
      name: 'Custom filter options',
      description: 'Add filter options for the picker.',
      method: (BuildContext context, List<AssetEntity> assets) {
        return AssetPicker.pickAssets(
          context,
          maxAssets: maxAssetsCount,
          selectedAssets: assets,
          requestType: RequestType.video,
          filterOptions: FilterOptionGroup()
            ..setOption(
              AssetType.video,
              const FilterOption(
                durationConstraint: DurationConstraint(
                  max: Duration(minutes: 1),
                ),
              ),
            ),
        );
      },
    );
  }

  factory PickMethod.prependItem(int maxAssetsCount) {
    return PickMethod(
      icon: '➕',
      name: 'Prepend special item',
      description: 'A special item will prepend to the assets grid.',
      method: (BuildContext context, List<AssetEntity> assets) {
        return AssetPicker.pickAssets(
          context,
          maxAssets: maxAssetsCount,
          selectedAssets: assets,
          requestType: RequestType.common,
          specialItemPosition: SpecialItemPosition.prepend,
          specialItemBuilder: (BuildContext context) {
            return const Center(
              child: Text('Custom Widget', textAlign: TextAlign.center),
            );
          },
        );
      },
    );
  }

  factory PickMethod.noPreview(int maxAssetsCount) {
    return PickMethod(
      icon: '👁️‍🗨️',
      name: 'No preview',
      description: 'Pick assets like the WhatsApp/MegaTok pattern.',
      method: (BuildContext context, List<AssetEntity> assets) {
        return AssetPicker.pickAssets(
          context,
          maxAssets: maxAssetsCount,
          selectedAssets: assets,
          requestType: RequestType.common,
          specialPickerType: SpecialPickerType.noPreview,
        );
      },
    );
  }

  factory PickMethod.keepScrollOffset({
    required DefaultAssetPickerProvider Function() provider,
    required DefaultAssetPickerBuilderDelegate Function() delegate,
    required Function(PermissionState state) onPermission,
    GestureLongPressCallback? onLongPress,
  }) {
    return PickMethod(
      icon: '💾',
      name: 'Keep scroll offset',
      description: 'Pick assets from same scroll position.',
      method: (BuildContext context, List<AssetEntity> assets) async {
        final PermissionState _ps =
            await PhotoManager.requestPermissionExtend();
        if (_ps != PermissionState.authorized &&
            _ps != PermissionState.limited) {
          throw StateError('Permission state error with $_ps.');
        }
        onPermission(_ps);
        return AssetPicker.pickAssetsWithDelegate(
          context,
          provider: provider(),
          delegate: delegate(),
        );
      },
      onLongPress: onLongPress,
    );
  }

  factory PickMethod.changeLanguages(int maxAssetsCount) {
    return PickMethod(
      icon: '🔤',
      name: 'Change Languages',
      description: 'Pass text delegates to change between languages. '
          '(e.g. EnglishTextDelegate)',
      method: (BuildContext context, List<AssetEntity> assets) {
        return AssetPicker.pickAssets(
          context,
          maxAssets: maxAssetsCount,
          selectedAssets: assets,
          textDelegate: EnglishTextDelegate(),
        );
      },
    );
  }

  factory PickMethod.preventGIFPicked(int maxAssetsCount) {
    return PickMethod(
      icon: '🈲',
      name: 'Prevent GIF being picked',
      description: 'Use selectPredicate to banned GIF picking when tapped.',
      method: (BuildContext context, List<AssetEntity> assets) {
        return AssetPicker.pickAssets(
          context,
          maxAssets: maxAssetsCount,
          selectedAssets: assets,
          selectPredicate: (BuildContext c, AssetEntity a, bool isSelected) {
            print('Asset title: ${a.title}');
            return a.title?.endsWith('.gif') != true;
          },
        );
      },
    );
  }

  final String icon;
  final String name;
  final String description;

  /// The core function that defines how to use the picker.
  final Future<List<AssetEntity>?> Function(
    BuildContext context,
    List<AssetEntity> selectedAssets,
  ) method;

  final GestureLongPressCallback? onLongPress;
}
