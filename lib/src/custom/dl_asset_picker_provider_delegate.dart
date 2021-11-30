import 'dart:developer';

import '../../wechat_assets_picker.dart';

///选择拦截器
typedef SelectInterceptor = bool Function(AssetEntity item);

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
  }) : super(
    selectedAssets: selectedAssets,
    requestType:requestType,
    sortPathDelegate:sortPathDelegate,
    filterOptions:filterOptions,
    maxAssets: maxAssets,
    pageSize: pageSize,
    pathThumbSize: pathThumbSize,
    routeDuration:routeDuration,
  );

 @override
 void selectAsset(AssetEntity item) {
   if (item.type == AssetType.image && selectedAssets.length == maxAssets) {
     log('DLAssetPickerProvider:已经选择的数量${selectedAssets.length}');
     return;
   }
   super.selectAsset(item);
 }
}