import 'package:json_annotation/json_annotation.dart';
import 'package:simple_password/utility.dart';

part 'data.g.dart';

@JsonSerializable(explicitToJson: true)
class BackupPolicy {
  bool autoBackup = true;
  int totalBackups = 10;
  bool keepOneDay = true;
  bool keepLastWeek = true;
  bool keepLastMonth = true;

  BackupPolicy();

  factory BackupPolicy.fromJson(Map<String, dynamic> json) =>
      _$BackupPolicyFromJson(json);
  BackupPolicy clone() {
    BackupPolicy o = new BackupPolicy();
    o.autoBackup = this.autoBackup;
    o.totalBackups = this.totalBackups;
    o.keepOneDay = this.keepOneDay;
    o.keepLastWeek = this.keepLastWeek;
    o.keepLastMonth = this.keepLastMonth;
    return o;
  }

  Map<String, dynamic> toJson() => _$BackupPolicyToJson(this);
}

@JsonSerializable(explicitToJson: true)
class BasicData {
  String name = "item name";
  String notes = "";
  DateTime createTime = new DateTime.now();
  DateTime deltaTime = new DateTime.now();
  DateTime accessTime = new DateTime.now();

  BasicData();

  factory BasicData.fromJson(Map<String, dynamic> json) =>
      _$BasicDataFromJson(json);
  BasicData clone() {
    BasicData o = new BasicData();
    o.name = this.name;
    o.notes = this.notes;
    o.createTime = this.createTime;
    o.deltaTime = this.deltaTime;
    o.accessTime = this.accessTime;
    return o;
  }

  Map<String, dynamic> toJson() => _$BasicDataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Data {
  String key = Util.randomString(1032);
  BackupPolicy backupPolicy = new BackupPolicy();
  PasswordPolicy passwordPolicy = new PasswordPolicy();
  SecurityPolicy securityPolicy = new SecurityPolicy();
  BasicData basicData = new BasicData();
  List<Group> groups = new List();

  Data();

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
  Data clone() {
    Data o = new Data();
    o.key = this.key;
    o.backupPolicy = this.backupPolicy.clone();
    o.passwordPolicy = this.passwordPolicy.clone();
    o.securityPolicy = this.securityPolicy.clone();
    o.basicData = this.basicData.clone();
    for (Group g in this.groups) {
      o.groups.add(g.clone());
    }
    return o;
  }

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Group {
  BasicData basicData = new BasicData();
  List<Password> passwords = new List();

  Group();

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
  Group clone() {
    Group o = new Group();
    o.basicData = this.basicData.clone();
    for (Password p in this.passwords) {
      o.passwords.add(p.clone());
    }
    return o;
  }

  Map<String, dynamic> toJson() => _$GroupToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Password {
  BasicData basicData = new BasicData();
  int key = Util.randomKey();
  String username = "";
  String password = "";
  String notes = "";
  String url = "";

  Password();

  factory Password.fromJson(Map<String, dynamic> json) =>
      _$PasswordFromJson(json);
  Password clone() {
    Password o = new Password();
    o.basicData = this.basicData.clone();
    o.key = this.key;
    o.username = this.username;
    o.password = this.password;
    o.notes = this.notes;
    o.url = this.url;
    return o;
  }

  Map<String, dynamic> toJson() => _$PasswordToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PasswordPolicy {
  int minLenght = 8;
  int minUpperCase = 1;
  int minLowerCase = 1;
  int minDigit = 1;
  int minSymbol = 1;
  String allowedSymbols = Util.symboles;

  PasswordPolicy();

  factory PasswordPolicy.fromJson(Map<String, dynamic> json) =>
      _$PasswordPolicyFromJson(json);
  PasswordPolicy clone() {
    PasswordPolicy o = new PasswordPolicy();
    o.minDigit = this.minDigit;
    o.minLenght = this.minLenght;
    o.minLowerCase = this.minLowerCase;
    o.minSymbol = this.minSymbol;
    o.minUpperCase = this.minUpperCase;
    o.allowedSymbols = this.allowedSymbols;
    return o;
  }

  Map<String, dynamic> toJson() => _$PasswordPolicyToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SecurityPolicy {
  bool autoHide = true;
  bool autoSave = true;
  int autoHideInterval = 15; // seconds
  int autoSaveInterval = 120; // seconds

  SecurityPolicy();

  factory SecurityPolicy.fromJson(Map<String, dynamic> json) =>
      _$SecurityPolicyFromJson(json);
  SecurityPolicy clone() {
    SecurityPolicy o = new SecurityPolicy();
    o.autoHide = this.autoHide;
    o.autoHideInterval = this.autoHideInterval;
    o.autoSave = this.autoSave;
    o.autoSaveInterval = this.autoSaveInterval;
    return o;
  }

  Map<String, dynamic> toJson() => _$SecurityPolicyToJson(this);
}
