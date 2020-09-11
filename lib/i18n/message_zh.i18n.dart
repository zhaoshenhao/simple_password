// GENERATED FILE, do not edit!
import 'package:i18n/i18n.dart' as i18n;
import 'message.i18n.dart';

String get _languageCode => 'zh';
String get _localeName => 'zh';

String _plural(int count, {String zero, String one, String two, String few, String many, String other}) =>
	i18n.plural(count, _languageCode, zero:zero, one:one, two:two, few:few, many:many, other:other);
String _ordinal(int count, {String zero, String one, String two, String few, String many, String other}) =>
	i18n.ordinal(count, _languageCode, zero:zero, one:one, two:two, few:few, many:many, other:other);
String _cardinal(int count, {String zero, String one, String two, String few, String many, String other}) =>
	i18n.cardinal(count, _languageCode, zero:zero, one:one, two:two, few:few, many:many, other:other);

class Message_zh extends Message {
	const Message_zh();
	CommonMessage_zh get common => CommonMessage_zh(this);
	BasicMessage_zh get basic => BasicMessage_zh(this);
	CreateMessage_zh get create => CreateMessage_zh(this);
	FileMessage_zh get file => FileMessage_zh(this);
	PswdMessage_zh get pswd => PswdMessage_zh(this);
	HomeMessage_zh get home => HomeMessage_zh(this);
	LoadMessage_zh get load => LoadMessage_zh(this);
	SbsMessage_zh get sbs => SbsMessage_zh(this);
	PpMessage_zh get pp => PpMessage_zh(this);
	GroupMessage_zh get group => GroupMessage_zh(this);
	SettingsMessage_zh get settings => SettingsMessage_zh(this);
	IapMessage_zh get iap => IapMessage_zh(this);
	AboutMessage_zh get about => AboutMessage_zh(this);
}

class CommonMessage_zh extends CommonMessage {
	final Message_zh _parent;
	const CommonMessage_zh(this._parent):super(_parent);
	String get about => """关于""";
	String get actions => """操作""";
	String get add => """添加""";
	String get app => """应用名称""";
	String appName(bool p) => """密宝 Pro""";
	String get check => """检查""";
	String get chgConfirmed => """修改已确认""";
	String get chgSaveFailed => """保存修改失败""";
	String get chgSaved => """保存修改完成""";
	String get companyName => """Syspole Inc.""";
	String get confirm => """确定""";
	String get copyRight => """Copyright © 2002-2020 CompuSky Inc.""";
	String get create => """新建""";
	String get delete => """删除""";
	String get deleteThisAsk => """删除该项？""";
	String get developer => """开发者""";
	String get error => """错误""";
	String get file => """文件""";
	String get gen => """生成""";
	String get group => """密码组""";
	String get groups => """密码组""";
	String get lastAccess => """最近访问""";
	String get lastCreate => """创建时间""";
	String get lastDelta => """最近修改""";
	String get lookFeel => """界面和语言""";
	String get myGrpName => """我的密码组""";
	String get mySecret => """我的密码""";
	String get no => """否""";
	String get none => """无""";
	String get noChange => """没有修改""";
	String get notEmpty => """不可为空""";
	String get notes => """备注""";
	String get off => """关""";
	String get ok => """确认""";
	String get on => """开""";
	String get others => """其他""";
	String get password => """密码""";
	String get passwords => """密码""";
	String get privacy => """隐私保护条款""";
	String get recent => """最近""";
	String get reset => """回复""";
	String get ro => """只读""";
	String get rw => """可读写""";
	String get save => """保存""";
	String get saveAllAsk => """保存全部修改？""";
	String get settings => """配置""";
	String get terms => """使用条款""";
	String get title => """名称""";
	String get unsaved => """未保存的修改""";
	String get url => """URL""";
	String get version => """版本""";
	String get yes => """是""";
	String get total => """总计""";
}

class BasicMessage_zh extends BasicMessage {
	final Message_zh _parent;
	const BasicMessage_zh(this._parent):super(_parent);
	String get hint => """请为您的密码文件起个名称，作为标识.""";
	String get info => """基本信息""";
	String get pswdName => """密码文件的名称""";
}

class CreateMessage_zh extends CreateMessage {
	final Message_zh _parent;
	const CreateMessage_zh(this._parent):super(_parent);
	String get createFile => """创建密宝文件""";
	String get fn => """密宝文件名""";
	String get inputFn => """请输入密宝文件名""";
}

class FileMessage_zh extends FileMessage {
	final Message_zh _parent;
	const FileMessage_zh(this._parent):super(_parent);
	String deleteFailed(String p) => """删除文件 $p 失败""";
	String fileExistErr(String name) => """文件已经存在 $name。请使用其他名字。""";
	String get fileExists => """文件存在""";
	String fileNotExists(String p) => """文件 $p 未找到""";
	String get fileNotFound => """文件未找到""";
	String fileNotFoundErr(String name) => """文件 $name 未找到.""";
	String get fnTips => """请输入 [a-zA-Z0-9_-] 字符""";
	String get loadCurrent => """载入当前文件""";
	String get loadNew => """载入外部文件""";
	String get openErr => """打开错误""";
	String openFailedErr(String name) => """打开文件 $name 失败.""";
	String saveErr(String name) => """保存文件 $name 失败""";
	String get saveErrTitle => """保存文件出错""";
	String get saveFailed => """保存文件失败""";
	String get validFn => """合法的文件名""";
}

class PswdMessage_zh extends PswdMessage {
	final Message_zh _parent;
	const PswdMessage_zh(this._parent):super(_parent);
	String get checkKey => """请检查主密钥和文件格式.""";
	String get change => """修改主密钥""";
	String containUpper(int cnt) => """必须包含 $cnt 个大写字母""";
	String containLower(int cnt) => """必须包含 $cnt 个小写字母""";
	String containDigit(int cnt) => """必须包含 $cnt 个数字""";
	String containSpecial(int cnt) => """必须包含 $cnt 特殊字符""";
	String get detail => """密码信息""";
	String get error => """两次输入密码不匹配""";
	String get msKey => """主密钥""";
	String get msKeyCur => """当前主密钥""";
	String get msKeyNew => """新的主密钥""";
	String get oldMismatch => """请输入正确的旧主密钥""";
	String get pswdCheck => """密码检查""";
	String get pswdCopied => """密码已复制""";
	String get pswdEmpty => """空密码""";
	String get pswdGood => """这个密码看起来不错""";
	String get pswdHint => """输入您的主密钥""";
	String get pswdHint2 => """请输入密码""";
	String get pswdLen => """长度小于""";
	String get pswdSame => """请输入不同的主密钥""";
	String get titleHint => """请输入""";
	String get unCopied => """用户名已复制""";
	String get unHint => """用户名""";
	String get urlCopied => """URL 已复制""";
	String get urlHint => """请输入URL""";
}

class HomeMessage_zh extends HomeMessage {
	final Message_zh _parent;
	const HomeMessage_zh(this._parent):super(_parent);
	String get grpDeleted => """密码组已删除""";
	String subTitle(String lastUpd, int pswdCnt) => """最近修改: $lastUpd. 密码数: $pswdCnt""";
}

class LoadMessage_zh extends LoadMessage {
	final Message_zh _parent;
	const LoadMessage_zh(this._parent):super(_parent);
	String get loadFile => """载入""";
	String get loadPswdFile => """载入密宝文件""";
	String get newFile => """新建""";
	String get openInRo => """只读模式打开""";
	String get openOther => """从其他目录打开""";
	String get auth => """请进行认证来打开密宝""";
	String get authErr => """设备认证出错。\n请检查您的系统认证设置，\n确认无误后重试.""";
}

class SbsMessage_zh extends SbsMessage {
	final Message_zh _parent;
	const SbsMessage_zh(this._parent):super(_parent);
	String get bkClean => """清理备份文件""";
	String get bkCurrent => """备份当前文件""";
	String bkDone(String name) => """备份 $name.sp 结束.""";
	String bkFailed(String name) => """备份 $name.sp 失败!""";
	String deleteAsk(String f) => """是否删除 $f.sp?""";
	String doPolicy(String name) => """对如下文件自行备份策略\n$name.sp?\n一些旧的备份会被删除.""";
	String get doPolicy1 => """执行备份策略""";
	String get donePolicy => """备份策略已执行.""";
	String get enableSync => """同步修改到本地共享或云端目录""";
	String fileDeleted(String f) => """文件 $f.sp 已删除""";
	String get pswdFileStatus => """密宝文件状态""";
	String get roMode => """只读模式""";
	String get sbp => """保存前按备份策略执行备份""";
	String get shareContent => """这是您的密宝文件""";
	String get shareCurrent => """分享当前文件""";
	String get shareDone => """分享文件完成""";
	String get shareFailed => """分享文件失败""";
	String get syncTo => """同步到""";
	String get title => """保存 & 备份 & 分享""";
	String get totalChanges => """总修改次数""";
}

class PpMessage_zh extends PpMessage {
	final Message_zh _parent;
	const PpMessage_zh(this._parent):super(_parent);
	String get allowedSpecial => """允许使用的特殊字符""";
	String get minDidit => """最少数字""";
	String get minLen => """最小长度""";
	String get minLower => """最少小写字母""";
	String get minSpecial => """最少特殊字符""";
	String get minUpper => """最少大写字母""";
	String get specialChar => """特殊字符""";
	String get specialErr => """只允许特殊字符""";
	String get specialHint => """请输入特殊字符""";
	String get title => """密码策略""";
}

class GroupMessage_zh extends GroupMessage {
	final Message_zh _parent;
	const GroupMessage_zh(this._parent):super(_parent);
	String get detail => """密码组""";
	String get hint => """请输入密码组名称.""";
	String get name => """密码组名称""";
	String get pswdCreated => """创建新密码完成""";
	String get pswdDeleted => """密码已经删除""";
}

class SettingsMessage_zh extends SettingsMessage {
	final Message_zh _parent;
	const SettingsMessage_zh(this._parent):super(_parent);
	String get autoHide => """自动隐藏密码""";
	String get autoHideInterval => """自动隐藏间隔(秒)""";
	String get autoSave => """自动保存修改""";
	String get autoSaveInterval => """自动保存间隔(秒)""";
	String get bk => """备份设置""";
	String get bkB4Save => """保存前创建备份""";
	String get keepLastDay => """保留最新的昨天的备份""";
	String get keepLastMonth => """保留最新的上周的备份""";
	String get keepLastWeek => """保留最新的上个月的备份""";
	String get lang => """界面语言""";
	String get theme => """界面主题""";
	String get sec => """安全设置""";
	String get totalBks => """保留总备份数""";
}

class IapMessage_zh extends IapMessage {
	final Message_zh _parent;
	const IapMessage_zh(this._parent):super(_parent);
	String get benefits1 => """无限制的密码组和密码""";
	String get benefits2 => """使用设备提供的认证方式来访问已经打开的密宝文件。""";
	String get benefits3 => """更多主题风格""";
	String get benefits => """购买后您可以获取全部功能：""";
	String get buyConfirmMsg => """请确认是否继续?""";
	String get buyTitle => """购买""";
	String get buyError1 => """购买出错. 请再次进入本页面检查最终结果.""";
	String get buyError2 => """购买验证失败. 请再次进入本页面检查最终结果.""";
	String get buyError3 => """购买被中断. 请再次进入本页面检查最终结果.""";
	String get buyRefund => """如需退款，请联系我们: https://www.syspole.com""";
	String get error1 => """获取产品信息失败.""";
	String get error2 => """产品信息未找到.""";
	String get error3 => """购买功能不可用.""";
	String get failed => """请稍后重试.""";
	String get freeVer => """免费版本限制""";
	String get freeLimit => """您可以最多创建 5 个密码组，每个密码组最多包含 5 个密码。升级到 Pro 版本，可以创建任意多的密码组和密码。""";
	String get paid => """您正在使用付费版本""";
	String get thankYou => """感谢您对我们的支持。""";
	String get title => """购买密宝 Pro""";
	String get unpaid => """您正在使用免费版本。""";
	String get verify => """我的年龄超过 13 岁。或者我的监护人同意购买。""";
	String get thankYouTitle => """感谢购买""";
	String get succ => """购买成功。\n感谢您对我们的支持。""";
	String get unvail => """付款功能现在无法使用。请稍后再试。""";
	String get warn => """升级注意事项""";
	String get warn1 => """请按如下步骤升级到 Pro 版本""";
	String get warn2 => """在购买应用商店购买并安装密宝 Pro""";
	String get warn3 => """请将 Free 版的密码文件保存到共享目录""";
	String get warn4 => """从 Pro 版本中打开共享目录下的密宝文件，并确认""";
	String get warn5 => """完成全部密码文件的传递后，您可以选择保留或删除 Free 版本""";
}

class AboutMessage_zh extends AboutMessage {
	final Message_zh _parent;
	const AboutMessage_zh(this._parent):super(_parent);
	String get terms => """Simple Password Free/Pro Term of Use

"The application" means Simple Password Free or Simple Password Pro.
"Our terms of Use" means this term of use.

1. By using the application, you acknowledge and consent to our Terms of Use.
2. We grant to you a non-exclusive, non-transferable, non-sharable, revocable, limited license to use the application solely for personal, non-commercial use in accordance with the terms of use.
3. You must not modify, hack, recreate, copy or exploit any part of the application.
4. You must not upload or inject any malware, illegal or obscene content.
5. You must not reuse, modify, download or copy the application icon or the name “Simple Password” for any commercial use.
6. You must be 13+ years old to use and make any purchases pertaining to the app, or have granted consent from a legal parent/guardian.
7. The application is provided "as is".
8. We do not provide any kind of warranty.
9. Users are using the application at their own risk.
10. We do not guarantee that the application is free from mistakes, malware, errors or other issues that could potentially damage a user.
11. We will not be held liable for any damages that arise from the use of this application, such as data loss, conduct of third parties, inability to access the app, copyright infringement of others and any other damages that may occur.
12. We may modify the Terms of Use at any given time, so please review these terms periodically. We will notify any changes made through the application.
13. If you have any questions or concerns about our Terms of Use, please contact us.

""";
	String get privacy => """Simple Password Free/Pro Privacy Policy

"The application" means Simple Password Free or Simple Password Pro.
"Our Privacy Policy" means this Privacy Policy.

1. The application strives to protect your privacy. These policies disclose how the application handles and secures your personal information and data. By using this application, you give consent to abide by our Privacy Policy.
2. All information and data are stored on your electronic device, thus, the application does not collect or have access to any personal information or personal data.
3. The application does not share personal information and data with separate entities or third party companies. However, if you choose to export or share personal information and data with entities separate to the application, such as cloud services (Ex. Dropbox), we are not responsible, nor have control with what these services and/or related third parties do with your personal information and data.
4. We reserve the right to update and/or change our Privacy Policy at any given time. Your continued use of the application will constitute your acknowledgement of modifications and consent to abide by our Privacy Policy. Changes made to our Privacy Policy will be notified through the application prior to them becoming effective.
5. If you have any questions or concerns about our Privacy Policy, please contact us at simple_password@syspole.com.
""";
}

