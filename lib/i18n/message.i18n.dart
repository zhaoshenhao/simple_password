// GENERATED FILE, do not edit!
import 'package:i18n/i18n.dart' as i18n;

String get _languageCode => 'en';
String get _localeName => 'en';

String _plural(int count, {String zero, String one, String two, String few, String many, String other}) =>
	i18n.plural(count, _languageCode, zero:zero, one:one, two:two, few:few, many:many, other:other);
String _ordinal(int count, {String zero, String one, String two, String few, String many, String other}) =>
	i18n.ordinal(count, _languageCode, zero:zero, one:one, two:two, few:few, many:many, other:other);
String _cardinal(int count, {String zero, String one, String two, String few, String many, String other}) =>
	i18n.cardinal(count, _languageCode, zero:zero, one:one, two:two, few:few, many:many, other:other);

class Message {
	const Message();
	CommonMessage get common => CommonMessage(this);
	BasicMessage get basic => BasicMessage(this);
	CreateMessage get create => CreateMessage(this);
	FileMessage get file => FileMessage(this);
	PswdMessage get pswd => PswdMessage(this);
	HomeMessage get home => HomeMessage(this);
	LoadMessage get load => LoadMessage(this);
	SbsMessage get sbs => SbsMessage(this);
	PpMessage get pp => PpMessage(this);
	GroupMessage get group => GroupMessage(this);
	SettingsMessage get settings => SettingsMessage(this);
	IapMessage get iap => IapMessage(this);
	AboutMessage get about => AboutMessage(this);
}

class CommonMessage {
	final Message _parent;
	const CommonMessage(this._parent);
	String get about => """About""";
	String get actions => """Actions""";
	String get add => """Add""";
	String get app => """Application""";
	String appName(bool p) => """Simple Password Pro""";
	String get cancel => """Cancel""";
	String get check => """Check""";
	String get chgConfirmed => """Change confirmed""";
	String get chgSaveFailed => """Changes failed to save""";
	String get chgSaved => """Changes saved""";
	String get companyName => """Syspole Inc.""";
	String get confirm => """Confirm""";
	String get copyRight => """Copyright © 2002-2020 CompuSky Inc.""";
	String get create => """Create""";
	String get delete => """Delete""";
	String get deleteThisAsk => """Delete this item?""";
	String get developer => """Developer""";
	String get discard => """Discard""";
	String get discardMsg => """All changes will be lost.\nData will be restored to last saving point.""";
	String get discardDone => """Changes discarded.""";
	String get error => """Error""";
	String get file => """File""";
	String get gen => """Generate""";
	String get group => """Group""";
	String get groups => """Groups""";
	String get lastAccess => """Last Accessed""";
	String get lastCreate => """Last Created""";
	String get lastDelta => """Last Modified""";
	String get lookFeel => """Look and Feel""";
	String get move => """Move""";
	String get myGrpName => """my password group""";
	String get mySecret => """my secret""";
	String get no => """No""";
	String get noChange => """No change""";
	String get none => """None""";
	String get notEmpty => """Please enter something""";
	String get notes => """Notes""";
	String get off => """Off""";
	String get ok => """OK""";
	String get on => """On""";
	String get others => """Others""";
	String get password => """Password""";
	String get passwords => """Passwords""";
	String get privacy => """Privacy""";
	String get recent => """Recent""";
	String get reset => """Reset""";
	String get ro => """Read-only""";
	String get rw => """Read-write""";
	String get save => """Save""";
	String get saveAllAsk => """Save all changes？""";
	String get settings => """Settings""";
	String get terms => """Term of Use""";
	String get title => """Title""";
	String get un => """Username""";
	String get unsaved => """Unsaved changes""";
	String get url => """URL""";
	String get version => """Version""";
	String get yes => """Yes""";
	String get total => """Total""";
}

class BasicMessage {
	final Message _parent;
	const BasicMessage(this._parent);
	String get hint => """Please enter the name of the password collection.""";
	String get info => """Basic Information""";
	String get pswdName => """Password collection name""";
}

class CreateMessage {
	final Message _parent;
	const CreateMessage(this._parent);
	String get createFile => """Create Password File""";
	String get fn => """Password file name""";
	String get inputFn => """Please enter the name of the password file.""";
}

class FileMessage {
	final Message _parent;
	const FileMessage(this._parent);
	String deleteFailed(String p) => """Delete file $p failed""";
	String fileExistErr(String name) => """File \"$name\" exists!\nPlease use different name.""";
	String get fileExists => """File exists""";
	String fileNotExists(String p) => """File $p does not exist""";
	String get fileNotFound => """File not found""";
	String fileNotFoundErr(String name) => """File $name not found""";
	String get fnTips => """Please use [a-zA-Z0-9_-] only""";
	String get loadCurrent => """Load current file""";
	String get loadNew => """Load new external file""";
	String openFailedErr(String name) => """File $name failed to open""";
	String get openErr => """Open Error""";
	String saveErr(String name) => """File $name failed to save""";
	String get saveErrTitle => """File save error""";
	String get saveFailed => """File failed to save""";
	String get validFn => """Valid file name""";
}

class PswdMessage {
	final Message _parent;
	const PswdMessage(this._parent);
	String get checkKey => """Check main secret key and file format""";
	String get change => """Change master secret key""";
	String containUpper(int cnt) => """Must contain $cnt upper case ${_plural(cnt, one:'letter', many:'letters')}""";
	String containLower(int cnt) => """Must contain $cnt lower case ${_plural(cnt, one:'letter', many:'letters')}""";
	String containDigit(int cnt) => """Must contain $cnt ${_plural(cnt, one:'digit', many:'digits')}""";
	String containSpecial(int cnt) => """Must contain $cnt special ${_plural(cnt, one:'character', many:'characters')}""";
	String get detail => """Password Detail""";
	String get error => """Password confirmation not match""";
	String get movePswd => """Move password to other group.""";
	String get msKey => """Main Secret Key""";
	String get msKeyCur => """Current main secret key""";
	String get msKeyNew => """New main secret key""";
	String get oldMismatch => """Old main secret key is incorrect""";
	String get pswdCheck => """Password Check""";
	String get pswdCopied => """Password copied""";
	String get pswdEmpty => """Password is empty""";
	String get pswdGood => """Password looks good""";
	String get pswdHint => """Please enter your main secret key""";
	String get pswdHint2 => """Enter your password""";
	String get pswdLen => """Length less than""";
	String get pswdSame => """New master secret key is same as current one""";
	String get titleHint => """The item title""";
	String get unCopied => """Username copied""";
	String get unHint => """The Username""";
	String get urlCopied => """URL copied""";
	String get urlHint => """Any URL""";
}

class HomeMessage {
	final Message _parent;
	const HomeMessage(this._parent);
	String get grpDeleted => """Group deleted""";
	String subTitle(String lastUpd, int pswdCnt) => """Last Modified: $lastUpd. Passwords: $pswdCnt""";
}

class LoadMessage {
	final Message _parent;
	const LoadMessage(this._parent);
	String get loadFile => """Open File""";
	String get loadPswdFile => """Load Password File""";
	String get newFile => """New File""";
	String get openInRo => """Open in read-only mode""";
	String get openOther => """Open from other location""";
	String get auth => """Please authenticate yourself to open this app""";
	String get authErr => """Device authencation error.\nPlease check your system authencation.\nAnd try again later.""";
}

class SbsMessage {
	final Message _parent;
	const SbsMessage(this._parent);
	String get bkClean => """Backup Cleanup""";
	String get bkCurrent => """Backup Current File""";
	String bkDone(String name) => """New backup of $name.sp is done.""";
	String bkFailed(String name) => """Taking backup of $name.sp failed!""";
	String deleteAsk(String f) => """Delete $f.sp?""";
	String doPolicy(String name) => """Perform backup policy of\n$name.sp?\nSome old backups will be removed.""";
	String get doPolicy1 => """Perform Backup Policy""";
	String get donePolicy => """Backup policy performed.""";
	String get enableSync => """Sync changes to a local or cloud folder""";
	String fileDeleted(String f) => """File $f.sp deleted""";
	String get pswdFileStatus => """Password file status""";
	String get roMode => """Read-only mode""";
	String get sbp => """Run backup policy before save""";
	String get shareContent => """This is the Simple Password file.""";
	String get shareCurrent => """Share Current File""";
	String get shareDone => """Sharing completed""";
	String get shareFailed => """Sharing file failed""";
	String get syncTo => """Sync To""";
	String get title => """Save & Backup & Share""";
	String get totalChanges => """Total changes""";
}

class PpMessage {
	final Message _parent;
	const PpMessage(this._parent);
	String get allowedSpecial => """Allow special characters""";
	String get minDidit => """Minimal digits""";
	String get minLen => """Minimal Length""";
	String get minLower => """Minimal lower case letters""";
	String get minSpecial => """Minimal special characters""";
	String get minUpper => """Minimal upper case letters""";
	String get specialChar => """Symbol characters""";
	String get specialErr => """Only special characters""";
	String get specialHint => """Please enter special characters""";
	String get title => """Password Policy""";
}

class GroupMessage {
	final Message _parent;
	const GroupMessage(this._parent);
	String get detail => """Group Detail""";
	String get hint => """Please enter the group name""";
	String get name => """Group name""";
	String get pswdCreated => """New password created""";
	String get pswdDeleted => """Password deleted""";
}

class SettingsMessage {
	final Message _parent;
	const SettingsMessage(this._parent);
	String get autoHide => """Auto-hide password""";
	String get autoHideInterval => """Auto-hide interval(seconds)""";
	String get autoSave => """Auto-save changes""";
	String get autoSaveInterval => """Auto-save interval(seconds)""";
	String get bk => """Backup Settings""";
	String get bkB4Save => """Create backup before saving""";
	String get keepLastDay => """Keep backup for yesterday""";
	String get keepLastMonth => """Keep backup for the last month""";
	String get keepLastWeek => """Keep backup for the last week""";
	String get lang => """Language""";
	String get theme => """Theme""";
	String get sec => """Security Settings""";
	String get totalBks => """Total backups""";
}

class IapMessage {
	final Message _parent;
	const IapMessage(this._parent);
	String get benefits1 => """Unlimited password groups and passwords""";
	String get benefits2 => """Allow device authentication for opened password files""";
	String get benefits3 => """More themes""";
	String get benefits => """Buy to get all features:""";
	String get buyConfirmMsg => """Are you sure you want to continue?""";
	String get buyError1 => """Purchase error. Please revisit this page.""";
	String get buyError2 => """Purchase invalid. Please revisit this page.""";
	String get buyError3 => """Purchase interrupted. Please revisit this page.""";
	String get buyRefund => """If refund is required, please contact us at https://www.syspole.com""";
	String get buyTitle => """Buy""";
	String get error1 => """Getting production detail is failed.""";
	String get error2 => """Product not found.""";
	String get error3 => """Purcahse function is not available.""";
	String get failed => """Please try again.""";
	String get freeVer => """Free Version""";
	String get freeLimit => """You can have up to 5 password groups and 5 passwords in each group. Upgrade to Pro version to have unlimited groups and passwords.""";
	String get paid => """This is the paid version.""";
	String get thankYou => """Thank you for supporting us.""";
	String get title => """Buy Simple Password Pro""";
	String get unpaid => """This is the free version.""";
	String get verify => """I am 13+ years old, or legal parent/guardian consents to this purchase.""";
	String get thankYouTitle => """Thank You""";
	String get succ => """The purchase is completed. \nThanks you for your supporting.""";
	String get unvail => """Payment function is unavailable now. Please try later.""";
	String get warn => """Important Upgrade Notes""";
	String get warn1 => """Please follow steps to upgrade to Pro Version.""";
	String get warn2 => """Buy and install Pro version from App Store.""";
	String get warn3 => """Save old password files from Free version to shared folder.""";
	String get warn4 => """Open and confirm ALL old password files.""";
	String get warn5 => """After transfering all old password files, you can choose to keep or delete Free version.""";
}

class AboutMessage {
	final Message _parent;
	const AboutMessage(this._parent);
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
13. If you have any questions or concerns about our Terms of Use, please contact us at simple_password@syspole.com.

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

