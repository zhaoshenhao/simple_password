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
	String get about => """À propos""";
	String get actions => """Actions""";
	String get add => """Ajouter""";
	String get app => """L'application""";
	String appName(bool p) => """Simple Password ${p?'Pro':'Free'}""";
	String get appVer => """1.0.0""";
	String get check => """Vérifier""";
	String get chgConfirmed => """Changement confirmé""";
	String get chgSaveFailed => """Les modifications n'ont pas pu être enregistrées""";
	String get chgSaved => """Changements sauvegardés""";
	String get companyName => """Syspole Inc.""";
	String get confirm => """Confirmer""";
	String get copyRight => """Copyright © 2002-2020 CompuSky Inc.""";
	String get create => """Créer""";
	String get delete => """Supprimer""";
	String get deleteThisAsk => """Supprimer cet élément?""";
	String get developer => """Développeur""";
	String get error => """Erreur""";
	String get file => """Fichier""";
	String get gen => """Produire""";
	String get group => """Groupe""";
	String get groups => """Groupes""";
	String get lastAccess => """Dernier accès""";
	String get lastCreate => """Dernière création""";
	String get lastDelta => """Dernière modification""";
	String get lookFeel => """Regarde et ressent""";
	String get myGrpName => """mon groupe de mots de passe""";
	String get mySecret => """mon secret""";
	String get no => """Non""";
	String get noChange => """Pas de changement""";
	String get none => """Aucun""";
	String get notEmpty => """Veuillez saisir quelque chose""";
	String get notes => """Remarques""";
	String get off => """Off""";
	String get ok => """D'accord""";
	String get on => """On""";
	String get others => """Autres""";
	String get password => """Mot de passe""";
	String get passwords => """Mots de passe""";
	String get privacy => """Confidentialité""";
	String get recent => """Récent""";
	String get reset => """Réinitialiser""";
	String get ro => """Lecture seulement""";
	String get rw => """Lire écrire""";
	String get save => """Sauver""";
	String get saveAllAsk => """Enregistrer toutes les modifications?""";
	String get settings => """Paramètres""";
	String get terms => """Conditions d'utilisation""";
	String get title => """Titre""";
	String get unsaved => """Modifications non enregistrées""";
	String get url => """URL""";
	String get version => """Version""";
	String get yes => """Oui""";
	String get total => """Totale""";
}

class BasicMessage_fr extends BasicMessage {
	final Message_fr _parent;
	const BasicMessage_fr(this._parent):super(_parent);
	String get hint => """Veuillez saisir le nom de la collection de mots de passe.""";
	String get info => """Informations de Base""";
	String get pswdName => """Nom de la collection de mots de passe""";
}

class CreateMessage_fr extends CreateMessage {
	final Message_fr _parent;
	const CreateMessage_fr(this._parent):super(_parent);
	String get createFile => """Créer un Fichier de Mot de Passe""";
	String get fn => """Nom du fichier de mot de passe""";
	String get inputFn => """Veuillez saisir le nom du fichier de mot de passe.""";
}

class FileMessage_fr extends FileMessage {
	final Message_fr _parent;
	const FileMessage_fr(this._parent):super(_parent);
	String deleteFailed(String p) => """Échec de la suppression du fichier $p""";
	String fileExistErr(String name) => """Le fichier \"$name\" existe!\nVeuillez utiliser un autre nom""";
	String get fileExists => """Le fichier existe""";
	String fileNotExists(String p) => """Le fichier $p n'existe pas""";
	String get fileNotFound => """Fichier non trouvé""";
	String fileNotFoundErr(String name) => """Le fichier $name introuvable""";
	String get fnTips => """Veuillez utiliser [a-zA-Z0-9_-] uniquement""";
	String get loadCurrent => """Charger le fichier actuel""";
	String get loadNew => """Charger un nouveau fichier externe""";
	String openFailedErr(String name) => """Le fichier $name n'a pas pu s'ouvrir""";
	String get openErr => """Erreur Ouverte""";
	String saveErr(String name) => """Le fichier $name n'a pas pu être enregistré""";
	String get saveErrTitle => """Erreur d'enregistrement de fichier""";
	String get saveFailed => """Le fichier n'a pas pu être enregistré""";
	String get validFn => """Nom de fichier valide""";
}

class PswdMessage_fr extends PswdMessage {
	final Message_fr _parent;
	const PswdMessage_fr(this._parent):super(_parent);
	String get checkKey => """Check main secret key and file format""";
	String containUpper(int cnt) => """Doit contenir $cnt majuscule ${_plural(cnt, one:'lettre', many:'lettres')}""";
	String containLower(int cnt) => """Doit contenir $cnt minuscule ${_plural(cnt, one:'lettre', many:'lettres')}""";
	String containDigit(int cnt) => """Doit contenir $cnt ${_plural(cnt, one:'chiffre', many:'chiffres')}.""";
	String containSpecial(int cnt) => """Doit contenir $cnt special ${_plural(cnt, one:'lettre', many:'lettres')}""";
	String get detail => """Détail du Mot de Passe""";
	String get msKey => """Clé Secrète Principale""";
	String get pswdCheck => """Vérification de Mot de Passe""";
	String get pswdCopied => """Mot de passe copié""";
	String get pswdEmpty => """Le mot de passe est vide""";
	String get pswdGood => """Le mot de passe est valide""";
	String get pswdHint => """Veuillez saisir votre clé secrète principale""";
	String get pswdHint2 => """Tapez votre mot de passe""";
	String get pswdLen => """Longueur inférieure à""";
	String get titleHint => """Le titre de l'article""";
	String get unCopied => """L'identifiant copié""";
	String get unHint => """L'identifiant""";
	String get urlCopied => """URL copiée""";
	String get urlHint => """Toute URL""";
}

class HomeMessage_fr extends HomeMessage {
	final Message_fr _parent;
	const HomeMessage_fr(this._parent):super(_parent);
	String get grpDeleted => """Groupe supprime""";
	String subTitle(String lastUpd, int pswdCnt) => """Dernière modification: $lastUpd. Articles: $pswdCnt""";
}

class LoadMessage_fr extends LoadMessage {
	final Message_fr _parent;
	const LoadMessage_fr(this._parent):super(_parent);
	String get loadFile => """Fichier ouvert""";
	String get loadPswdFile => """Charger le Fichier de Mot de Passe""";
	String get newFile => """Nouveau Fichier""";
	String get openInRo => """Ouvrir en mode lecture seule""";
	String get openOther => """Ouvert depuis un autre endroit""";
	String get auth => """Veuillez vous authentifier pour ouvrir cette application""";
	String get authErr => """Erreur d'authentification de l'appareil.\nVeuillez vérifier l'authentification de votre système.\nEt réessayer plus tard.""";
}

class SbsMessage_fr extends SbsMessage {
	final Message_fr _parent;
	const SbsMessage_fr(this._parent):super(_parent);
	String get bkClean => """Nettoyage de Sauvegarde""";
	String get bkCurrent => """Sauvegarder le Fichier Actuel""";
	String bkDone(String name) => """Une nouvelle sauvegarde de $name.sp est effectuée.""";
	String bkFailed(String name) => """La sauvegarde de $name.sp a échoué!""";
	String deleteAsk(String f) => """Supprimer $f.sp?""";
	String doPolicy(String name) => """Exécutez la politique de sauvegarde de\n $name.sp?\nCertaines anciennes sauvegardes seront supprimées.""";
	String get doPolicy1 => """Exécuter la politique de sauvegarde""";
	String get donePolicy => """Politique de sauvegarde effectuée""";
	String get enableSync => """Synchroniser les modifications dans un dossier local ou cloud""";
	String fileDeleted(String f) => """Fichier $f.sp supprimé""";
	String get pswdFileStatus => """État du fichier de mot de passe""";
	String get roMode => """Mode lecture seule""";
	String get sbp => """Exécutez la politique de sauvegarde avant d'enregistrer""";
	String get shareContent => """Il s'agit du fichier Simple Password.""";
	String get shareCurrent => """Partager le Fichier Actuel""";
	String get shareDone => """Partage terminé""";
	String get shareFailed => """Le partage du fichier a échoué""";
	String get syncTo => """Synchroniser avec""";
	String get title => """Enregistrer et Sauvegarder et Partager""";
	String get totalChanges => """Total des changements""";
}

class PpMessage_fr extends PpMessage {
	final Message_fr _parent;
	const PpMessage_fr(this._parent):super(_parent);
	String get allowedSpecial => """Autoriser les caractères spéciaux""";
	String get minDidit => """Chiffres minimaux""";
	String get minLen => """Longueur minimale""";
	String get minLower => """Minuscules minimale""";
	String get minSpecial => """Lettres spéciaux minimes""";
	String get minUpper => """Majuscules minimale""";
	String get specialChar => """Lettres de symbole""";
	String get specialErr => """Seuls les lettres spéciaux""";
	String get specialHint => """Veuillez saisir des lettres spéciaux""";
	String get title => """Politique de Mot de Passe""";
}

class GroupMessage_fr extends GroupMessage {
	final Message_fr _parent;
	const GroupMessage_fr(this._parent):super(_parent);
	String get detail => """Détail du Groupe""";
	String get hint => """Veuillez saisir le nom du groupe.""";
	String get name => """Nom du groupe""";
	String get pswdCreated => """Nouveau mot de passe créé""";
	String get pswdDeleted => """Mot de passe supprimé""";
}

class SettingsMessage_fr extends SettingsMessage {
	final Message_fr _parent;
	const SettingsMessage_fr(this._parent):super(_parent);
	String get autoHide => """Masquer automatiquement le mot de passe""";
	String get autoHideInterval => """Masquer automatiquement interval(seconds)""";
	String get autoSave => """Sauvegarde automatique des modifications""";
	String get autoSaveInterval => """Sauvegarde automatique interval(seconds)""";
	String get bk => """Paramètres de sauvegarde""";
	String get bkB4Save => """Créer une sauvegarde avant d'enregistrer""";
	String get keepLastDay => """Gardez une sauvegarde pour hier""";
	String get keepLastMonth => """Gardez une sauvegarde pour le mois dernier""";
	String get keepLastWeek => """Gardez une sauvegarde pour la semaine dernière""";
	String get lang => """Langue""";
	String get theme => """Thème""";
	String get sec => """Les Paramètres de Sécurité""";
	String get totalBks => """Total des Sauvegardes""";
}

class IapMessage_fr extends IapMessage {
	final Message_fr _parent;
	const IapMessage_fr(this._parent):super(_parent);
	String get benefits1 => """Groupes de mots de passe et mots de passe illimités""";
	String get benefits2 => """Autoriser l'authentification de l'appareil pour les fichiers de mots de passe ouverts""";
	String get benefits => """Les avantages comprennent:""";
	String get buyConfirmMsg => """Es-tu sur de vouloir continuer?""";
	String get buyTitle => """Acheter""";
	String get failed => """Achat raté. Veuillez réessayer.""";
	String get freeVer => """Free Version""";
	String get freeLimit => """Vous pouvez avoir jusqu'à 5 groupes de mots de passe et 5 mots de passe dans chaque groupe. Passez à la version Pro pour avoir des groupes et des mots de passe illimités.""";
	String get paid => """Ceci est la version payante.""";
	String get thankYou => """Merci de nous soutenir.""";
	String get title => """Acheter Simple Password Pro""";
	String get unpaid => """Ceci est la version gratuite.""";
	String get verify => """J'ai 13 ans et plus, ou mon parent/tuteur légal consent à cet achat.""";
	String get thankYouTitle => """Merci""";
	String get succ => """L'achat est terminé.\nMerci de votre soutien.""";
	String get warn => """Notes de mise à niveau importantes""";
	String get warn1 => """Veuillez suivre les étapes pour passer à la version Pro.""";
	String get warn2 => """Achetez et installez la version Pro depuis l'App Store.""";
	String get warn3 => """Enregistrez les anciens fichiers de mots de passe de la version gratuite dans un dossier partagé.""";
	String get warn4 => """Ouvrez et confirmez TOUS les anciens fichiers de mots de passe.""";
	String get warn5 => """Après avoir transféré tous les anciens fichiers de mots de passe, vous pouvez choisir de conserver ou de supprimer la version gratuite.""";
}

class AboutMessage_fr extends AboutMessage {
	final Message_fr _parent;
	const AboutMessage_fr(this._parent):super(_parent);
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

