import 'package:flutter_localization/flutter_localization.dart';

const List<MapLocale> LOCALES = [
  MapLocale("fr", LocaleData.FR),
  MapLocale("en", LocaleData.EN),
];

mixin LocaleData {
  static const String title = 'title';
  static const String body = 'body';
  static const String langueFr = 'langueFr';
  static const String langueEn = 'langueEn';
  static const String onboardbtn1 = 'onboardbtn1';
  static const String onboardbtn2 = 'onboardbtn2';
  static const String onboardbtn3 = 'onboardbtn3';
  static const String welcome = 'welcome';
  static const String login = 'login';
  static const String compte = 'compte';
  static const String create = 'create';
  static const String back = 'back';
  static const String forget = 'forget';
  static const String noAccount = 'noAccount';
  static const String signUp = 'signUp';
  static const String username = 'username';
  static const String password = 'password';
  static const String connexion = 'connexion';
  static const String dialogTitle = 'dialogTitle';
  static const String dialogBody = 'dialogBody';
  static const String dialogBtnText = 'dialogBtnText';
  static const String inscription = 'inscription';
  static const String bodyRegister = 'bodyRegister';
  static const String surname = 'surname';
  static const String firstname = 'firstname';
  static const String number = 'number';
  static const String help = 'help';
  static const String yesAccount = 'yesAccount';
  static const String sexeH = 'sexeH';
  static const String sexeF = 'sexeF';
  static const String code = 'code';
  static const String advanceText = 'advanceText';
  static const String otpBtn = 'otpBtn';
  static const String resend = 'resend';
  static const String firsText = 'firsText';
  static const String serviceText = 'serviceText';
  static const String categories = 'categories';
  static const String voirPlus = 'voirPlus';
  static const String lesMieuxNote = 'lesMieuxNote';
  static const String wait = 'wait';
  static const String disconnectText = 'disconnectText';
  static const String deleteText = 'deleteText';
  static const String yes = 'yes';
  static const String no = 'no';
  static const String acceuil = 'acceuil';
  static const String histMenu = 'histMenu';
  static const String paramMenu = 'paramMenu';
  static const String catMenu = 'catMenu';
  static const String keyword = 'keyword';
  static const String presta = 'presta';
  static const String devPresta = 'devPresta';
  static const String fPresta = 'fPresta';
  static const String profil = 'profil';
  static const String langue = 'langue';
  static const String mention = 'mention';
  static const String about = 'about';
  static const String deconnexion = 'deconnexion';
  static const String email = 'email';
  static const String adresse = 'adresse';
  static const String mesAdresse = 'mesAdresse';
  static const String prestataire = 'prestataire';
  static const String locality = 'locality';
  static const String tarifs = 'tarifs';
  static const String phVideo = 'phVideo';
  static const String reset = 'reset';
  static const String validate = 'validate';
  static const String location = 'location';
  static const String heure = 'heure';
  static const String jour = 'jour';
  static const String reservez = 'reservez';
  static const String reservation = 'reservation';
  static const String selectService = 'selectService';
  static const String selectAdress = 'selectAdress';
  static const String dateTravaille = 'dateTravaille';
  static const String dateRendevous = 'dateRendevous';
  static const String custom = 'custom';
  static const String confirmer = 'confirmer';
  static const String snackAppointText = 'snackAppointText';
  static const String services = 'services';
  static const String sousCategories = 'sousCategories';
  static const String newAdress = 'newAdress';
  static const String designation = 'designation';
  static const String recupPos = 'recupPos';
  static const String maPosition = 'maPosition';
  static const String adresseSnack = 'adresseSnack';
  static const String modifAdresse = 'modifAdresse';
  static const String commandes = 'commandes';
  static const String profilPresta = 'profilPresta';
  static const String galerie = 'galerie';
  static const String ajoutService = 'ajoutService';
  static const String modifService = 'modifService';
  static const String saveModif = 'saveModif';
  static const String prixH = 'prixH';
  static const String prixJ = 'prixJ';
  static const String errorServiceStack = 'errorServiceStack';
  static const String errorServiceStack2 = 'errorServiceStack2';
  static const String dans = 'dans';
  static const String map = 'map';
  static const String passwordModif = 'passwordModif';
  static const String oldPassw = 'oldPassw';
  static const String newPassw = 'newPassw';
  static const String changPasw = 'changPasw';
  static const String changMyPasw = 'changMyPasw';
  static const String confirmPassw = 'confirmPassw';
  static const String snackPass1 = 'snackPass1';
  static const String snackPass2 = 'snackPass2';
  static const String snackPass3 = 'snackPass3';
  static const String precedent = 'precedent';
  static const String chooseService = 'chooseService';
  static const String chooseDate = 'chooseDate';
  static const String unitprice = 'unitprice';
  static const String numberProviders = 'numberProviders';
  static const String whenyouWant = 'whenyouWant';
  static const String immediately = 'immediately';
  static const String program = 'program';
  static const String serviceAdress = 'serviceAdress';
  static const String additional = 'additional';
  static const String abbregAdditional = 'abbregAdditional';
  static const String summary = 'summary';
  static const String selectCity = 'selectCity';
  static const String selectOneCity = 'selectOneCity';
  static const String providerCity = 'providerCity';
  static const String total = 'total';
  static const String when = 'when';
  static const String position = 'position';
  static const String tout = 'tout';
  static const String endPay = 'endPay';
  static const String motif = 'motif';
  static const String datePresta = 'datePresta';
  static const String saveChanges = 'saveChanges';
  static const String recupCurrent = 'recupCurrent';
  static const String loading = 'loading';
  static const String morethanThree = 'morethanThree';
  static const String avertissement = 'avertissement';
  static const String envoyer = 'envoyer';
  static const String jeMesouviens = 'jeMesouviens';
  static const String processV = 'processV';
  static const String load = 'load';
  static const String connectWait = 'connectWait';
  static const String keyword2 = 'keyword2';
  static const String noBook = 'noBook';
  static const String deletesucces = 'deletesucces';
  static const String adresseName = 'adresseName';
  static const String renit = 'renit';
  static const String birthdate = 'birthdate';
  static const String test = 'test';

  // les langues
  static const Map<String, dynamic> FR = {
    firsText: 'Choisir une langue',
    title: 'langue',
    body: 'Content de vous revoir',
    langueFr: 'Français',
    langueEn: 'Anglais',
    onboardbtn1: 'Passer',
    onboardbtn2: 'Suivant',
    onboardbtn3: 'Démarrer',
    welcome: 'Bienvenue',
    login: 'Se connecter',
    compte: 'Mon compte',
    create: 'Créer un compte',
    back: 'Retour',
    forget: 'Mot de passe oublié',
    noAccount: 'Vous n\'avez pas de compte?',
    signUp: 'S\'inscrire',
    username: 'Nom d\'utilisateur',
    password: 'Mot de passe',
    connexion: 'Connexion',
    dialogTitle: 'Bientôt disponible',
    dialogBody: 'Service indisponible pour \n le moment !',
    dialogBtnText: 'Compris',
    inscription: 'Inscription',
    bodyRegister: 'Créer un compte et continuer',
    surname: 'Nom',
    firstname: 'Prénom',
    number: 'Numero de téléphone',
    help: 'Bésoin d\'aide',
    yesAccount: 'J\'ai un compte',
    sexeH: 'Masculin',
    sexeF: 'Féminin',
    code: 'Code de vérification',
    advanceText: 'Entrez le code pour avancer',
    otpBtn: 'Vérifier',
    resend: 'Renvoyer le code',
    serviceText: 'Quels services vous \nfaut-il ?',
    categories: 'Catégories',
    voirPlus: 'Voir plus',
    lesMieuxNote: 'Les plus demandés',
    wait: "Veuillez patienter...",
    disconnectText: "Êtes-vous sûr de vouloir vous déconnecter?",
    deleteText: "Êtes-vous sûr de vouloir  supprimer?",
    yes: "Oui",
    no: "Non",
    acceuil: 'Accueil',
    histMenu: 'Historique',
    paramMenu: 'Paramètres',
    catMenu: 'Catégories',
    keyword: 'Taper un mot clé',
    presta: 'Compte prestataire',
    devPresta: 'Devenir prestataire maintenant.',
    fPresta: 'Faire une demande.',
    profil: 'Mon profil',
    langue: 'Langue',
    mention: 'Mentions légales',
    about: 'A propos',
    deconnexion: 'Déconnexion',
    email: 'Email',
    adresse: 'Adresse',
    mesAdresse: 'Mes adresses',
    prestataire: 'Prestataires',
    locality: 'Toutes les localités',
    tarifs: 'Tarifs',
    phVideo: 'Galerie',
    reset: 'Réinitialiser',
    validate: 'Valider',
    location: 'Choix localité.s',
    heure: 'Heure',
    jour: 'Jour',
    reservez: 'Réserver',
    reservation: 'Réservations',
    selectService: 'Sélectionner le service',
    selectAdress: 'Sélectionner une adresse',
    dateTravaille: 'Date',
    dateRendevous: 'Date rendez-vous',
    custom: 'Periode',
    confirmer: 'Confirmer',
    snackAppointText: 'Rendez-vous pris avec succès',
    services: 'Services',
    sousCategories: 'Sous-catégories',
    newAdress: 'Nouvelle adresse',
    designation: 'Désignation',
    recupPos: 'Récupérer ma position actuelle',
    maPosition: 'Enrégistrer ma position',
    adresseSnack: 'Veuillez entrer un nom',
    modifAdresse: 'Modifier adresse',
    commandes: 'Commandes',
    profilPresta: 'Profil',
    galerie: 'Galerie',
    ajoutService: 'Ajouter un service',
    modifService: 'Modifier service',
    saveModif: 'Enrégistrer modification',
    prixH: 'Prix horaire',
    prixJ: 'Prix journalier',
    errorServiceStack: 'Tous les champs doivent être remplis',
    errorServiceStack2: 'Veuillez choisir un service',
    dans: 'dans',
    map: 'Voir sur une carte',
    oldPassw: 'Ancien mot de passe',
    newPassw: 'Nouveau mot de passe',
    changPasw: 'Modifier mot de passe',
    changMyPasw: 'Modifier mon mot de passe',
    confirmPassw: 'Confirmation mot de passe',
    snackPass1:
        'Le nouveau mot de passe doit être différent de l\'ancien mot de passe',
    snackPass2:
        'Le nouveau mot de passe et la confirmation ne correspondent pas',
    snackPass3: 'Tous les champs doivent être remplis',
    precedent: 'Précédent',
    chooseService: 'Veuillez choisir l\'adresse de service',
    chooseDate: 'Veuillez choisir la date ',
    unitprice: 'Prix horaire',
    numberProviders: 'Nombre de prestaire.s',
    whenyouWant: 'Quand voulez vous le.s prestataire.s',
    immediately: 'Immédiatement',
    program: 'Programmer',
    serviceAdress: 'Adresse de prestation',
    additional: 'Informations supplementaires',
    summary: 'Récapitulatif',
    selectCity: 'Sélectionner la ville du prestataire',
    selectOneCity: 'Sélectionner une ville',
    providerCity: 'Ville du prestataire',
    total: 'Prix total',
    when: 'Quand',
    position: ' Ma position',
    tout: ' Tout',
    endPay: 'Finaliser le paiement',
    motif: 'Motif de rejet',
    datePresta: 'Date de prestation',
    saveChanges: 'Enregistrer les modifications',
    recupCurrent: 'Réccupération de la position actuelle',
    loading: 'Soumission en cours',
    morethanThree: 'Vous ne pouvez pas ajouter de trois services',
    avertissement: 'Avertissement!',
    abbregAdditional: 'Info supp',
    envoyer: 'Envoyer',
    jeMesouviens: 'Je me souviens!',
    processV: 'Procéder à la vérification',
    load: 'Chargement',
    connectWait: 'Connexion en cours...',
    keyword2: 'Rechercher par service, par catégorie de service...',
    noBook: 'Aucune réservation',
    deletesucces: "Êtes-vous sûr de vouloir annuler?",
    renit: 'Rénitialisation de mot de passe',
    birthdate: 'Date de naissance',
    test: 'un'
  };
  static const Map<String, dynamic> EN = {
    firsText: 'Choose a language',
    title: 'Language',
    body: 'Welcome back',
    langueFr: 'French',
    langueEn: 'English',
    onboardbtn1: 'Skip',
    onboardbtn2: 'Next',
    onboardbtn3: 'Start',
    welcome: 'Welcome',
    login: 'Login',
    compte: 'My account',
    create: 'Create an account',
    back: 'Back',
    forget: 'Password forgot',
    noAccount: 'Don\'t have an account?',
    signUp: 'Signup now',
    username: 'Username',
    password: 'Password',
    connexion: 'Login',
    dialogTitle: 'Available soon',
    dialogBody: 'Service currently unavailable!',
    dialogBtnText: 'Ok',
    inscription: 'Registration',
    bodyRegister: 'Create an account and continue',
    surname: 'Name',
    firstname: 'First name',
    number: 'Phone number',
    help: 'Need help',
    yesAccount: 'I have an account',
    sexeH: 'Male',
    sexeF: 'Female',
    code: 'Verification code',
    advanceText: 'Enter code to continue',
    otpBtn: 'Verify',
    resend: 'Resend code',
    serviceText: 'What services do \nyou need?',
    categories: 'Categories',
    voirPlus: 'See More',
    lesMieuxNote: 'Most requested',
    wait: "Please wait...",
    disconnectText: "Are you sure you want to logout?",
    yes: "Yes",
    no: "No",
    acceuil: 'Home',
    histMenu: 'History',
    paramMenu: 'Settings',
    catMenu: 'Categories',
    keyword: 'Enter a keyword',
    keyword2: 'Search by service, by categorie services',
    presta: 'Provider account',
    devPresta: 'Become a provider now.',
    fPresta: 'Make a request.',
    profil: 'My profile',
    langue: 'Language',
    mention: 'Terms of use',
    about: 'About us',
    deconnexion: 'Logout',
    email: 'Email',
    adresse: 'Address',
    mesAdresse: 'My addresses',
    prestataire: 'Providers',
    locality: 'All locations',
    tarifs: 'Prices',
    phVideo: 'Galery',
    reset: 'Reset',
    validate: 'Validate',
    location: 'Select location.s',
    heure: 'Time',
    jour: 'Day',
    reservez: 'Book',
    reservation: 'Reservations',
    selectService: 'Select service',
    selectAdress: 'Select adress',
    dateTravaille: 'Date',
    dateRendevous: 'Appointment date',
    custom: 'Period',
    confirmer: 'Confirm',
    snackAppointText: 'Appointment successfully booked',
    services: 'Services',
    sousCategories: 'Subcategories',
    newAdress: 'New address',
    designation: 'Designation',
    recupPos: 'Get my current position',
    maPosition: 'Save my adress',
    adresseSnack: 'Please enter a designation',
    modifAdresse: 'Modify address',
    commandes: 'Orders',
    profilPresta: 'Profile',
    galerie: 'Galery',
    ajoutService: 'Add service',
    modifService: 'Update service',
    saveModif: 'Save',
    prixH: 'Hourly price',
    prixJ: 'Daily price',
    errorServiceStack: 'All fields are required',
    errorServiceStack2: 'Please select a service',
    deleteText: 'Are you sure you want to delete?',
    dans: 'in',
    map: 'See on a map',
    oldPassw: 'Old password',
    newPassw: 'New password',
    changPasw: 'Update password',
    changMyPasw: 'Update my password',
    confirmPassw: 'Confirm password',
    snackPass1: 'new password must be different from the old password',
    snackPass2: 'New password and confirmation do not match',
    snackPass3: 'All fields are required',
    precedent: 'Previous',
    chooseService: 'Please choose the service address',
    chooseDate: 'Please choose the date',
    unitprice: 'Unit price',
    numberProviders: 'Number of providers',
    whenyouWant: 'When do you want the provider?',
    immediately: 'Immediately',
    program: 'Program',
    serviceAdress: 'Service address',
    additional: 'Additional information',
    summary: 'Summary',
    selectCity: 'Select provider city',
    selectOneCity: 'Select a city',
    providerCity: 'Provider city',
    total: 'Total price',
    when: 'When',
    position: 'My position',
    tout: ' All',
    endPay: 'Finalize payment',
    motif: 'Reason for rejection',
    datePresta: 'Date of service',
    saveChanges: 'Saves changes',
    recupCurrent: 'Recovery of current position ',
    loading: 'Submission in progress',
    morethanThree: 'You cannot add three services',
    avertissement: 'Warning!',
    abbregAdditional: 'Info add',
    envoyer: 'Send',
    jeMesouviens: 'I remember!',
    processV: 'Proceed to verification',
    load: 'Loading ...',
    connectWait: 'Connecting...',
    noBook: 'No reservations',
    deletesucces: 'Are you sure you want to cancel?',
    renit: 'Password reset',
    birthdate: 'Date of birth',
    test: 'One'
  };
}
