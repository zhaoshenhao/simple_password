// GENERATED FILE, do not edit!
import 'package:i18n/i18n.dart' as i18n;
import 'message.i18n.dart';

String get _languageCode => 'fr';
String get _localeName => 'fr';

String _plural(int count, {String zero, String one, String two, String few, String many, String other}) =>
	i18n.plural(count, _languageCode, zero:zero, one:one, two:two, few:few, many:many, other:other);
String _ordinal(int count, {String zero, String one, String two, String few, String many, String other}) =>
	i18n.ordinal(count, _languageCode, zero:zero, one:one, two:two, few:few, many:many, other:other);
String _cardinal(int count, {String zero, String one, String two, String few, String many, String other}) =>
	i18n.cardinal(count, _languageCode, zero:zero, one:one, two:two, few:few, many:many, other:other);

class Message_fr extends Message {
	const Message_fr();
	CommonMessage_fr get common => CommonMessage_fr(this);
	BasicMessage_fr get basic => BasicMessage_fr(this);
	CreateMessage_fr get create => CreateMessage_fr(this);
	FileMessage_fr get file => FileMessage_fr(this);
	PswdMessage_fr get pswd => PswdMessage_fr(this);
	HomeMessage_fr get home => HomeMessage_fr(this);
	LoadMessage_fr get load => LoadMessage_fr(this);
	SbsMessage_fr get sbs => SbsMessage_fr(this);
	PpMessage_fr get pp => PpMessage_fr(this);
	GroupMessage_fr get group => GroupMessage_fr(this);
	SettingsMessage_fr get settings => SettingsMessage_fr(this);
	IapMessage_fr get iap => IapMessage_fr(this);
	AboutMessage_fr get about => AboutMessage_fr(this);
}

class CommonMessage_fr extends CommonMessage {
	final Message_fr _parent;
	const CommonMessage_fr(this._parent):super(_parent);
	String get about => """About""";
	String get actions => """Actions""";
	String get add => """Add""";
	String get app => """Application""";
	String appName(bool p) => """Simple Password ${p?'Pro':'Free'}""";
	String get appVer => """1.0.0""";
	String get check => """Check""";
	String get chgConfirmed => """Change confirmed""";
	String get chgSaveFailed => """Saving changes failed.""";
	String get chgSaved => """Changes saved""";
	String get companyName => """Syspole Inc.""";
	String get confirm => """Confirm""";
	String get copyRight => """Copyright © 2002-2020 CompuSky Inc.""";
	String get create => """Create""";
	String get delete => """Delete""";
	String get deleteThisAsk => """Delete this item?""";
	String get developer => """Developer""";
	String get error => """Error""";
	String get file => """File""";
	String get gen => """Generate""";
	String get group => """Group""";
	String get groups => """Groups""";
	String get lastAccess => """Last Access""";
	String get lastCreate => """Last Created""";
	String get lastDelta => """Last Modified""";
	String get lookFeel => """Look & Feel""";
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
	String get unsaved => """Unsaved changes""";
	String get url => """URL""";
	String get version => """Version""";
	String get yes => """Yes""";
}

class BasicMessage_fr extends BasicMessage {
	final Message_fr _parent;
	const BasicMessage_fr(this._parent):super(_parent);
	String get hint => """Please enter the name of the password collection.""";
	String get info => """Basic Information""";
	String get pswdName => """Password collection name""";
}

class CreateMessage_fr extends CreateMessage {
	final Message_fr _parent;
	const CreateMessage_fr(this._parent):super(_parent);
	String get createFile => """Create Password File""";
	String get fn => """Password file name""";
	String get inputFn => """Please enter the name of the password file.""";
}

class FileMessage_fr extends FileMessage {
	final Message_fr _parent;
	const FileMessage_fr(this._parent):super(_parent);
	String deleteFailed(String p) => """Delete file $p failed""";
	String fileExistErr(String name) => """File \"$name\" exist!\nPlease use different name.""";
	String get fileExists => """File exist""";
	String fileNotExists(String p) => """File $p not exists""";
	String get fileNotFound => """File not found""";
	String fileNotFoundErr(String name) => """File $name not found.""";
	String get fnTips => """Please use [a-zA-Z0-9_-] only""";
	String get loadCurrent => """Load current file""";
	String get loadNew => """Load new external file""";
	String openFailedErr(String name) => """Open filed $name failed.""";
	String get openErr => """Open Error""";
	String saveErr(String name) => """Save file $name failed.""";
	String get saveErrTitle => """File save error""";
	String get saveFailed => """Save file failed""";
	String get validFn => """A valid file name""";
}

class PswdMessage_fr extends PswdMessage {
	final Message_fr _parent;
	const PswdMessage_fr(this._parent):super(_parent);
	String get checkKey => """Check main secret key and file format.""";
	String containUpper(int cnt) => """Must contain $cnt upper case ${_plural(cnt, one:'letter', many:'letters')}.""";
	String containLower(int cnt) => """Must contain $cnt lower case ${_plural(cnt, one:'letter', many:'letters')}.""";
	String containDigit(int cnt) => """Must contain $cnt ${_plural(cnt, one:'digit', many:'digits')}.""";
	String containSpecial(int cnt) => """Must contain $cnt special ${_plural(cnt, one:'character', many:'characters')}.""";
	String get detail => """Password Detail""";
	String get msKey => """Main Secret Key""";
	String get pswdCheck => """Password Check""";
	String get pswdCopied => """Password copied""";
	String get pswdEmpty => """Password is empty""";
	String get pswdGood => """Password looks good.""";
	String get pswdHint => """Please enter you main secret key""";
	String get pswdHint2 => """Enter your password""";
	String get pswdLen => """Length less than""";
	String get titleHint => """The item title""";
	String get unCopied => """Username copied""";
	String get unHint => """The username""";
	String get urlCopied => """URL copied""";
	String get urlHint => """Any URL""";
}

class HomeMessage_fr extends HomeMessage {
	final Message_fr _parent;
	const HomeMessage_fr(this._parent):super(_parent);
	String get grpDeleted => """Group deleted.""";
	String subTitle(String lastUpd, int pswdCnt) => """Last Modified: $lastUpd. Passwords: $pswdCnt""";
}

class LoadMessage_fr extends LoadMessage {
	final Message_fr _parent;
	const LoadMessage_fr(this._parent):super(_parent);
	String get loadFile => """Load File""";
	String get loadPswdFile => """Load Password File""";
	String get newFile => """New File""";
	String get openInRo => """Open in read-only mode""";
	String get openOther => """Open from other location""";
	String get auth => """Please authenticate to open Simple Password""";
	String get authErr => """Device authencation error.\nPlease check your system authencation.\nAnd try it later.""";
}

class SbsMessage_fr extends SbsMessage {
	final Message_fr _parent;
	const SbsMessage_fr(this._parent):super(_parent);
	String get bkClean => """Backup cleanup""";
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
	String get shareContent => """This is the simple password file.""";
	String get shareCurrent => """Share Current File""";
	String get shareDone => """Sharing completed""";
	String get shareFailed => """Sharing file failed.""";
	String get syncTo => """Sync To""";
	String get title => """Save & Backup & Share""";
	String get totalChanges => """Total changes""";
}

class PpMessage_fr extends PpMessage {
	final Message_fr _parent;
	const PpMessage_fr(this._parent):super(_parent);
	String get allowedSpecial => """Allowed special characters""";
	String get minDidit => """Minimal digits""";
	String get minLen => """Minimal Length""";
	String get minLower => """Minimal lower case letters""";
	String get minSpecial => """Minimal special characters""";
	String get minUpper => """Minimal upper case letters""";
	String get specialChar => """Symbol characters""";
	String get specialErr => """Only speical characters""";
	String get specialHint => """Please enter speical characters""";
	String get title => """Password Policy""";
}

class GroupMessage_fr extends GroupMessage {
	final Message_fr _parent;
	const GroupMessage_fr(this._parent):super(_parent);
	String get detail => """Group Detail""";
	String get hint => """Please enter the group name.""";
	String get name => """Group name""";
	String get pswdCreated => """New password created""";
	String get pswdDeleted => """Password deleted.""";
}

class SettingsMessage_fr extends SettingsMessage {
	final Message_fr _parent;
	const SettingsMessage_fr(this._parent):super(_parent);
	String get autoHide => """Auto-hide password""";
	String get autoHideInterval => """Auto-hide interval(seconds)""";
	String get autoSave => """Auto-save changes""";
	String get autoSaveInterval => """Auto-save interval(seconds)""";
	String get bk => """Backup Settings""";
	String get bkB4Save => """Create backup before saving""";
	String get keepLastDay => """Keep backup for yesterday""";
	String get keepLastMonth => """Keep back for last month""";
	String get keepLastWeek => """Keep backup for last week""";
	String get lang => """Language""";
	String get theme => """Theme""";
	String get sec => """Security Settings""";
	String get totalBks => """Total backups""";
}

class IapMessage_fr extends IapMessage {
	final Message_fr _parent;
	const IapMessage_fr(this._parent):super(_parent);
	String get benefits1 => """Unlimited password groups and passwords in each group""";
	String get benefits2 => """Using device authentication for opened password files""";
	String get benefits => """You will get:""";
	String get buyConfirmMsg => """Are you sure to continue?""";
	String get buyTitle => """Buy""";
	String get failed => """Purchase failed. Please try it again.""";
	String get freeVer => """Free Version""";
	String get freeLimit => """You can have up to 5 password groups and 5 passwords in each group. Upgrade to Pro version to have unlimited groups and password.""";
	String get paid => """This is paid version.""";
	String get thankYou => """Thank you for supporting us.""";
	String get title => """Buy Simple Password Pro""";
	String get unpaid => """This is free version.""";
	String get verify => """I am 13 years old. Or my guardian agree to purchase.""";
	String get thankYouTitle => """Thank You""";
	String get succ => """The purchase is completed. \nThanks you for your supporting.""";
	String get warn => """Important Upgrade Notes""";
	String get warn1 => """Please follow steps to upgrade to Pro Version.""";
	String get warn2 => """Buy and install Pro version from App Store.""";
	String get warn3 => """Save old password files from Free version to shared folder.""";
	String get warn4 => """Open and confirm ALL old password files.""";
	String get warn5 => """After transfering all old password files, you can choose to keep or delete Free version.""";
}

class AboutMessage_fr extends AboutMessage {
	final Message_fr _parent;
	const AboutMessage_fr(this._parent):super(_parent);
	String get terms => """Simple Password term of use
1. 
2. 
3.

""";
	String get privacy => """Simlple Password privacy
1.
2.
3.


""";
}

