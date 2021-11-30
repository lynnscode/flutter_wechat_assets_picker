import 'dart:developer';

import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class DLAssetPickerProvider extends DefaultAssetPickerProvider {

  DLAssetPickerProvider({
    List<AssetEntity>? selectedAssets,
    RequestType requestType = RequestType.image,
    SortPathDelegate<AssetPathEntity>? sortPathDelegate,
    FilterOptionGroup? filterOptions,
    int maxAssets = 9,
    int pageSize = 80,
    int pathThumbSize = 80,
    Duration routeDuration = const Duration(milliseconds: 300),
  }) :super(maxAssets:maxAssets,pageSize:pageSize,
      pathThumbSize:pathThumbSize,requestType:requestType,
      sortPathDelegate:sortPathDelegate,filterOptions:filterOptions,
      selectedAssets:selectedAssets,routeDuration:routeDuration);

  @override
  void selectAsset(AssetEntity item) {
    if (item.type == AssetType.image && selectedAssets.length == maxAssets) {
      log('最多只能选择$maxAssets张图片');
      // DLToast.showText("最多只能选择$maxAssets张图片");
      return;
    }
    super.selectAsset(item);
  }
}