
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/src/constants/constants.dart';
import 'package:wechat_assets_picker/src/widget/scale_text.dart';

import '../../wechat_assets_picker.dart';

///图片和视频预览页面
class DLAssetPickerViewerBuilderDelegate extends DefaultAssetPickerViewerBuilderDelegate {
  DLAssetPickerViewerBuilderDelegate({
    required int currentIndex,
    required List<AssetEntity> previewAssets,
    AssetPickerProvider<AssetEntity, AssetPathEntity>? selectorProvider,
    required ThemeData themeData,
    AssetPickerViewerProvider<AssetEntity>? provider,
    List<AssetEntity>? selectedAssets,
    List<int>? previewThumbSize,
    SpecialPickerType? specialPickerType,
    int? maxAssets,
    bool shouldReversePreview = false,
    AssetSelectPredicate<AssetEntity>? selectPredicate,
  }) : super(
    previewThumbSize:previewThumbSize,
    specialPickerType:specialPickerType,
    currentIndex: currentIndex,
    previewAssets: previewAssets,
    provider: provider,
    themeData: themeData,
    selectedAssets: selectedAssets,
    selectorProvider: selectorProvider,
    maxAssets: maxAssets,
    shouldReversePreview: shouldReversePreview,
    selectPredicate: selectPredicate,
  );
  /// It'll pop with [AssetPickerProvider.selectedAssets] when there are
  /// any assets were chosen. Then, the assets picker will pop too.
  /// 当有资源已选时，点击按钮将把已选资源通过路由返回。
  /// 资源选择器将识别并一同返回。
  @override
  Widget confirmButton(BuildContext context) {
    return ChangeNotifierProvider<
        AssetPickerViewerProvider<AssetEntity>?>.value(
      value: provider,
      child: Consumer<AssetPickerViewerProvider<AssetEntity>?>(
        builder: (_, AssetPickerViewerProvider<AssetEntity>? provider, __) {
          assert(
          isWeChatMoment || provider != null,
          'Viewer provider must not be null'
              'when the special type is not WeChat moment.',
          );
          return GestureDetector(
            onTap: () {
              if (isWeChatMoment && hasVideo) {
                Navigator.of(context).pop(<AssetEntity>[currentAsset]);
                return;
              }
              if (provider!.isSelectedNotEmpty) {
                Navigator.of(context).pop(provider.currentlySelectedAssets);
                return;
              }
              selectAsset(currentAsset);
              Navigator.of(context).pop(
                selectedAssets ?? <AssetEntity>[currentAsset],
              );
            },
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: (isWeChatMoment && hasVideo) ? 48.0 :provider!.isSelectedNotEmpty ? 48.0 : 20.0,
              ),
              child: Container(
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Center(
                  child: ScaleText(() {
                    if (isWeChatMoment && hasVideo) {
                      return Constants.textDelegate.confirm;
                    }
                    if (provider!.isSelectedNotEmpty) {
                      return '${Constants.textDelegate.confirm}'
                          ' (${provider.currentlySelectedAssets.length}'
                          '/'
                          '${selectorProvider!.maxAssets})';
                    }
                    return Constants.textDelegate.confirm;
                  }(),
                    style: TextStyle(
                      color: themeData.textTheme.bodyText1?.color,
                      fontSize: 17,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }


  @override
  Widget selectButton(BuildContext context) {
    return Container(width: 0,height: 0,);
  }

  @override
  Widget bottomDetailBuilder(BuildContext context) {
    return Container(width: 0,height: 0,);
  }

}