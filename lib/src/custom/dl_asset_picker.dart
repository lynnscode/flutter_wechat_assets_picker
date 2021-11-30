import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/src/constants/constants.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import 'dl_asset_picker_delegate.dart';

Future<PermissionState> permissionCheck() async {
  final PermissionState _ps = await PhotoManager.requestPermissionExtend();
  if (_ps != PermissionState.authorized && _ps != PermissionState.limited) {
    throw StateError('Permission state error with $_ps.');
  }
  return _ps;
}

/// Static method to push with the navigator.
/// 跳转至选择器的静态方法
/// 自定义布局类
Future<List<AssetEntity>?> pickDLAssets(
  BuildContext context, {
  List<AssetEntity>? selectedAssets,
  int maxAssets = 9,
  int pageSize = 80,
  int gridThumbSize = Constants.defaultGridThumbSize,
  int pathThumbSize = 80,
  int gridCount = 4,
  RequestType requestType = RequestType.image,
  List<int>? previewThumbSize,
  SpecialPickerType? specialPickerType,
  Color? themeColor,
  ThemeData? pickerTheme,
  SortPathDelegate<AssetPathEntity>? sortPathDelegate,
  AssetsPickerTextDelegate? textDelegate,
  FilterOptionGroup? filterOptions,
  WidgetBuilder? specialItemBuilder,
  IndicatorBuilder? loadingIndicatorBuilder,
  SpecialItemPosition specialItemPosition = SpecialItemPosition.none,
  bool allowSpecialItemWhenEmpty = false,
  AssetSelectPredicate<AssetEntity>? selectPredicate,
  bool? shouldRevertGrid,
  bool useRootNavigator = true,
  Curve routeCurve = Curves.easeIn,
  Duration routeDuration = const Duration(milliseconds: 300),
}) async {
  if (maxAssets < 1) {
    throw ArgumentError(
      'maxAssets must be greater than 1.',
    );
  }
  if (pageSize % gridCount != 0) {
    throw ArgumentError(
      'pageSize must be a multiple of gridCount.',
    );
  }
  if (pickerTheme != null && themeColor != null) {
    throw ArgumentError(
      'Theme and theme color cannot be set at the same time.',
    );
  }
  if (specialPickerType == SpecialPickerType.wechatMoment) {
    if (requestType != RequestType.image) {
      throw ArgumentError(
        'SpecialPickerType.wechatMoment and requestType cannot be set at the same time.',
      );
    }
    requestType = RequestType.common;
  }
  if ((specialItemBuilder == null &&
          specialItemPosition != SpecialItemPosition.none) ||
      (specialItemBuilder != null &&
          specialItemPosition == SpecialItemPosition.none)) {
    throw ArgumentError('Custom item did not set properly.');
  }

  final PermissionState _ps = await permissionCheck();

  final DefaultAssetPickerProvider provider = DefaultAssetPickerProvider(
    maxAssets: maxAssets,
    pageSize: pageSize,
    pathThumbSize: pathThumbSize,
    selectedAssets: selectedAssets,
    requestType: requestType,
    sortPathDelegate: sortPathDelegate,
    filterOptions: filterOptions,
    routeDuration: routeDuration,
  );
  final Widget picker =
      ChangeNotifierProvider<DefaultAssetPickerProvider>.value(
    value: provider,
    child: AssetPicker<AssetEntity, AssetPathEntity>(
      key: Constants.pickerKey,
      builder: DLAssetPickerBuilderDelegate(
        provider: provider,
        initialPermission: _ps,
        gridCount: gridCount,
        textDelegate: textDelegate,
        themeColor: themeColor,
        pickerTheme: pickerTheme,
        gridThumbSize: gridThumbSize,
        previewThumbSize: previewThumbSize,
        specialPickerType: specialPickerType,
        specialItemPosition: specialItemPosition,
        specialItemBuilder: specialItemBuilder,
        loadingIndicatorBuilder: loadingIndicatorBuilder,
        allowSpecialItemWhenEmpty: allowSpecialItemWhenEmpty,
        selectPredicate: selectPredicate,
        shouldRevertGrid: shouldRevertGrid,
      ),
    ),
  );
  final List<AssetEntity>? result = await Navigator.of(
    context,
    rootNavigator: useRootNavigator,
  ).push<List<AssetEntity>>(
    AssetPickerPageRoute<List<AssetEntity>>(
      builder: picker,
      transitionCurve: routeCurve,
      transitionDuration: routeDuration,
    ),
  );
  return result;
}
