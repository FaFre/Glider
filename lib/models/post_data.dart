import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_data.freezed.dart';
part 'post_data.g.dart';

abstract class PostData {
  String get acct;
  String get pw;

  Map<String, dynamic> toJson();
}

@freezed
abstract class RegisterPostData with _$RegisterPostData implements PostData {
  factory RegisterPostData({
    @required String acct,
    @required String pw,
    @required String creating,
    @required String goto,
  }) = _RegisterPostData;

  factory RegisterPostData.fromJson(Map<String, dynamic> json) =>
      _$RegisterPostDataFromJson(json);
}

@freezed
abstract class LoginPostData with _$LoginPostData implements PostData {
  factory LoginPostData({
    @required String acct,
    @required String pw,
    @required String goto,
  }) = _LoginPostData;

  factory LoginPostData.fromJson(Map<String, dynamic> json) =>
      _$LoginPostDataFromJson(json);
}

@freezed
abstract class FavoritePostData with _$FavoritePostData implements PostData {
  factory FavoritePostData({
    @required String acct,
    @required String pw,
    @required int id,
    String un,
  }) = _FavoritePostData;

  factory FavoritePostData.fromJson(Map<String, dynamic> json) =>
      _$FavoritePostDataFromJson(json);
}

@freezed
abstract class VotePostData with _$VotePostData implements PostData {
  factory VotePostData({
    @required String acct,
    @required String pw,
    @required int id,
    @required String how,
  }) = _VotePostData;

  factory VotePostData.fromJson(Map<String, dynamic> json) =>
      _$VotePostDataFromJson(json);
}

@freezed
abstract class CommentPostData with _$CommentPostData implements PostData {
  factory CommentPostData({
    @required String acct,
    @required String pw,
    @required int parent,
    @required String text,
  }) = _CommentPostData;

  factory CommentPostData.fromJson(Map<String, dynamic> json) =>
      _$CommentPostDataFromJson(json);
}
