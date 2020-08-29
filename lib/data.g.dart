// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BackupPolicy _$BackupPolicyFromJson(Map<String, dynamic> json) {
  return BackupPolicy()
    ..autoBackup = json['autoBackup'] as bool
    ..totalBackups = json['totalBackups'] as int
    ..keepOneDay = json['keepOneDay'] as bool
    ..keepLastWeek = json['keepLastWeek'] as bool
    ..keepLastMonth = json['keepLastMonth'] as bool;
}

Map<String, dynamic> _$BackupPolicyToJson(BackupPolicy instance) =>
    <String, dynamic>{
      'autoBackup': instance.autoBackup,
      'totalBackups': instance.totalBackups,
      'keepOneDay': instance.keepOneDay,
      'keepLastWeek': instance.keepLastWeek,
      'keepLastMonth': instance.keepLastMonth,
    };

BasicData _$BasicDataFromJson(Map<String, dynamic> json) {
  return BasicData()
    ..name = json['name'] as String
    ..notes = json['notes'] as String
    ..createTime = json['createTime'] == null
        ? null
        : DateTime.parse(json['createTime'] as String)
    ..deltaTime = json['deltaTime'] == null
        ? null
        : DateTime.parse(json['deltaTime'] as String)
    ..accessTime = json['accessTime'] == null
        ? null
        : DateTime.parse(json['accessTime'] as String);
}

Map<String, dynamic> _$BasicDataToJson(BasicData instance) => <String, dynamic>{
      'name': instance.name,
      'notes': instance.notes,
      'createTime': instance.createTime?.toIso8601String(),
      'deltaTime': instance.deltaTime?.toIso8601String(),
      'accessTime': instance.accessTime?.toIso8601String(),
    };

Data _$DataFromJson(Map<String, dynamic> json) {
  return Data()
    ..key = json['key'] as String
    ..syncTo = json['syncTo'] as String
    ..enableSync = json['enableSync'] as bool
    ..backupPolicy = json['backupPolicy'] == null
        ? null
        : BackupPolicy.fromJson(json['backupPolicy'] as Map<String, dynamic>)
    ..passwordPolicy = json['passwordPolicy'] == null
        ? null
        : PasswordPolicy.fromJson(
            json['passwordPolicy'] as Map<String, dynamic>)
    ..securityPolicy = json['securityPolicy'] == null
        ? null
        : SecurityPolicy.fromJson(
            json['securityPolicy'] as Map<String, dynamic>)
    ..basicData = json['basicData'] == null
        ? null
        : BasicData.fromJson(json['basicData'] as Map<String, dynamic>)
    ..groups = (json['groups'] as List)
        ?.map(
            (e) => e == null ? null : Group.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'key': instance.key,
      'syncTo': instance.syncTo,
      'enableSync': instance.enableSync,
      'backupPolicy': instance.backupPolicy?.toJson(),
      'passwordPolicy': instance.passwordPolicy?.toJson(),
      'securityPolicy': instance.securityPolicy?.toJson(),
      'basicData': instance.basicData?.toJson(),
      'groups': instance.groups?.map((e) => e?.toJson())?.toList(),
    };

Group _$GroupFromJson(Map<String, dynamic> json) {
  return Group()
    ..basicData = json['basicData'] == null
        ? null
        : BasicData.fromJson(json['basicData'] as Map<String, dynamic>)
    ..passwords = (json['passwords'] as List)
        ?.map((e) =>
            e == null ? null : Password.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'basicData': instance.basicData?.toJson(),
      'passwords': instance.passwords?.map((e) => e?.toJson())?.toList(),
    };

Password _$PasswordFromJson(Map<String, dynamic> json) {
  return Password()
    ..basicData = json['basicData'] == null
        ? null
        : BasicData.fromJson(json['basicData'] as Map<String, dynamic>)
    ..key = json['key'] as int
    ..username = json['username'] as String
    ..password = json['password'] as String
    ..notes = json['notes'] as String
    ..url = json['url'] as String;
}

Map<String, dynamic> _$PasswordToJson(Password instance) => <String, dynamic>{
      'basicData': instance.basicData?.toJson(),
      'key': instance.key,
      'username': instance.username,
      'password': instance.password,
      'notes': instance.notes,
      'url': instance.url,
    };

PasswordPolicy _$PasswordPolicyFromJson(Map<String, dynamic> json) {
  return PasswordPolicy()
    ..minLenght = json['minLenght'] as int
    ..minUpperCase = json['minUpperCase'] as int
    ..minLowerCase = json['minLowerCase'] as int
    ..minDigit = json['minDigit'] as int
    ..minSymbol = json['minSymbol'] as int
    ..allowedSymbols = json['allowedSymbols'] as String;
}

Map<String, dynamic> _$PasswordPolicyToJson(PasswordPolicy instance) =>
    <String, dynamic>{
      'minLenght': instance.minLenght,
      'minUpperCase': instance.minUpperCase,
      'minLowerCase': instance.minLowerCase,
      'minDigit': instance.minDigit,
      'minSymbol': instance.minSymbol,
      'allowedSymbols': instance.allowedSymbols,
    };

SecurityPolicy _$SecurityPolicyFromJson(Map<String, dynamic> json) {
  return SecurityPolicy()
    ..autoHide = json['autoHide'] as bool
    ..autoSave = json['autoSave'] as bool
    ..autoHideInterval = json['autoHideInterval'] as int
    ..autoSaveInterval = json['autoSaveInterval'] as int;
}

Map<String, dynamic> _$SecurityPolicyToJson(SecurityPolicy instance) =>
    <String, dynamic>{
      'autoHide': instance.autoHide,
      'autoSave': instance.autoSave,
      'autoHideInterval': instance.autoHideInterval,
      'autoSaveInterval': instance.autoSaveInterval,
    };
