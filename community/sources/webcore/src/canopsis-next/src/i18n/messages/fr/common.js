import { THEMES_NAMES } from '@/config';
import {
  ENTITIES_STATES,
  ENTITIES_STATUSES,
  EVENT_ENTITY_TYPES,
  PATTERN_FIELD_TYPES,
  PATTERN_OPERATORS,
  TRIGGERS,
} from '@/constants';

export default {
  ok: 'Ok',
  undefined: 'Non défini',
  entity: 'Entité | Entités',
  service: 'Service',
  widget: 'Widget',
  addWidget: 'Ajouter un widget',
  addTab: 'Ajouter un onglet',
  shareLink: 'Créer un lien de partage',
  addPbehavior: 'Ajouter un comportement périodique',
  refresh: 'Rafraîchir',
  toggleEditView: 'Activer/Désactiver le mode édition',
  toggleEditViewSubtitle: 'Si vous souhaitez enregistrer les positions des widgets, vous devez désactiver le mode édition pour cela',
  name: 'Nom',
  description: 'Description',
  author: 'Auteur',
  submit: 'Soumettre',
  cancel: 'Annuler',
  continue: 'Continuer',
  stop: 'Fin',
  options: 'Options',
  type: 'Type',
  quitEditing: 'Quitter le mode édition',
  enabled: 'Activé(e)',
  disabled: 'Désactivé(e)',
  login: 'Connexion',
  yes: 'Oui',
  no: 'Non',
  default: 'Défaut',
  confirmation: 'Êtes-vous sûr(e) ?',
  parameter: 'Paramètre | Paramètres',
  by: 'Par',
  date: 'Date',
  comment: 'Commentaire | Commentaires',
  end: 'Fin',
  start: 'Début',
  message: 'Message',
  preview: 'Aperçu',
  recursive: 'Récursif',
  select: 'Sélectionner',
  states: 'Criticités',
  state: 'Criticité',
  sla: 'SLA',
  authors: 'Auteurs',
  stat: 'Statistique',
  trend: 'Tendance',
  user: 'Utilisateur | Utilisateurs',
  role: 'Rôle | Rôles',
  import: 'Importer',
  export: 'Exporter',
  profile: 'Profil',
  username: 'Identifiant utilisateur',
  password: 'Mot de passe',
  authKey: 'Clé d\'authentification',
  widgetId: 'Identifiant du widget',
  connect: 'Connexion',
  optional: 'Optionnel',
  logout: 'Se déconnecter',
  title: 'Titre',
  save: 'Sauvegarder',
  label: 'Label',
  field: 'Champ',
  value: 'Valeur',
  limit: 'Limite',
  add: 'Ajouter',
  create: 'Créer',
  delete: 'Supprimer',
  show: 'Afficher',
  hide: 'Cacher',
  edit: 'Éditer',
  duplicate: 'Dupliquer',
  play: 'Lecture',
  copyLink: 'Copier le lien',
  parse: 'Analyser',
  home: 'Accueil',
  step: 'Étape',
  paginationItems: 'Affiche {first} à {last} sur {total} Entrées',
  apply: 'Appliquer',
  from: 'Depuis',
  to: 'Vers',
  tags: 'Étiquettes',
  actionsLabel: 'Actions',
  noResults: 'Pas de résultats',
  result: 'Résultat',
  exploitation: 'Exploitation',
  administration: 'Administration',
  forbidden: 'Accès refusé',
  notFound: 'Introuvable',
  search: 'Recherche',
  filters: 'Filtres',
  filter: 'Filtre',
  emptyObject: 'Objet vide',
  startDate: 'Date de début',
  endDate: 'Date de fin',
  link: 'Lien | Liens',
  stack: 'Pile',
  edition: 'Édition',
  icon: 'Icône',
  fullscreen: 'Plein écran',
  interval: 'Période',
  status: 'Statut',
  unit: 'Unité',
  delay: 'Délai',
  begin: 'Début',
  timezone: 'Fuseau horaire',
  reason: 'Raison',
  or: 'OU',
  and: 'ET',
  priority: 'Priorité',
  clear: 'Nettoyer',
  deleteAll: 'Tout supprimer',
  payload: 'Payload',
  note: 'Note',
  output: 'Output',
  created: 'Date de création',
  updated: 'Date de dernière modification',
  expired: 'Date d\'expiration',
  accessed: 'Consulté à',
  lastEventDate: 'Date du dernier événement',
  lastPbehaviorDate: 'Date du dernier comportement',
  activated: 'Activé',
  pattern: 'Modèle | Modèles',
  correlation: 'Corrélation',
  periods: 'Périodes',
  range: 'Plage',
  duration: 'Durée',
  previous: 'Précédent',
  next: 'Suivant',
  eventPatterns: 'Modèles des événements',
  alarmPatterns: 'Modèles des alarmes',
  entityPatterns: 'Modèles des entités',
  pbehaviorPatterns: 'Modèles des comportements périodiques',
  totalEntityPatterns: 'Modèles des entités (Total)',
  serviceWeatherPatterns: 'Modèles des météos de service',
  addFilter: 'Ajouter un filtre',
  id: 'Identifiant',
  reset: 'Réinitialiser',
  selectColor: 'Sélectionner la couleur',
  disableDuringPeriods: 'Désactiver pendant les pauses',
  retryDelay: 'Délai entre les tentatives',
  retryUnit: 'Unité d\'essai',
  retryCount: 'Nombre de tentatives après échec',
  ticket: 'Ticket | Tickets',
  method: 'Méthode',
  url: 'URL',
  category: 'Catégorie',
  infos: 'Infos',
  impactLevel: 'Niveau d\'impact',
  impactState: 'État d\'impact',
  loadMore: 'Charger plus',
  download: 'Télécharger',
  initiator: 'Initiateur',
  percent: 'Pourcentage | Pourcentages',
  number: 'Nombre | Nombres',
  tests: 'Tests',
  total: 'Total',
  error: 'Erreur | Erreurs',
  failures: 'Échecs',
  skipped: 'Ignoré',
  current: 'Actuel',
  average: 'Moyenne',
  information: 'Information | Informations',
  file: 'Fichier',
  group: 'Groupe | Groupes',
  view: 'Vue | Vues',
  tab: 'Onglet | Onglets',
  access: 'Accès',
  communication: 'Communication | Communications',
  general: 'Général',
  notification: 'Notification | Notifications',
  dismiss: 'Rejeter',
  approve: 'Approuver',
  summary: 'Résumé',
  recurrence: 'Récurrence',
  statistics: 'Statistiques',
  action: 'Action | Actions',
  minimal: 'Minimal',
  optimal: 'Optimal',
  graph: 'Graphique | Graphiques',
  systemStatus: 'État du système',
  downloadAsPng: 'Télécharger en PNG',
  rating: 'Evaluation | Evaluations',
  sampling: 'Échantillonnage',
  parametersToDisplay: '{count} paramètres à afficher',
  uptime: 'Uptime',
  maintenance: 'Maintenance',
  downtime: 'Downtime',
  toTheTop: 'Vers le haut',
  time: 'Temps',
  lastModifiedOn: 'Dernière modification le',
  lastModifiedBy: 'Dernière modification par',
  exportAsCsv: 'Exporter en csv',
  criteria: 'Critères',
  ratingSettings: 'Paramètres d\'évaluation',
  pbehavior: 'Comportement périodique | Comportements périodiques',
  activePbehavior: 'Activer le comportement périodique | Activer les comportements périodiques',
  searchBy: 'Recherché par',
  dictionary: 'Dictionnaire',
  condition: 'Condition | Conditions',
  template: 'Template',
  pbehaviorList: 'Lister les comportements périodiques',
  canceled: 'Annulé',
  snooze: 'Snooze',
  snoozed: 'En attente',
  impact: 'Impact | Impacts',
  depend: 'Depend | Depends',
  componentInfo: 'Information du composant | Informations du composant',
  connector: 'Type de connecteur',
  connectorName: 'Nom du connecteur',
  component: 'Composant',
  resource: 'Ressource',
  ack: 'Acquittement',
  acked: 'Acquitté',
  extraInfo: 'Extra info | Extra infos',
  custom: 'Personnalisé',
  eventType: 'Type d\'événement',
  sourceType: 'Type de Source',
  cycleDependency: 'Dépendance au cycle',
  checkPattern: 'Vérification du modèle',
  checkFilter: 'Vérifier le filtre',
  itemFound: '{count} élément trouvé | {count} éléments trouvés',
  canonicalType: 'Type canonique',
  map: 'Cartographie | Cartographies',
  instructions: 'Consignes',
  playlist: 'Liste de lecture | Listes de lecture',
  ctrlZoom: 'Utilisez ctrl + molette de la souris pour zoomer',
  calendar: 'Calendrier',
  tag: 'Étiquette | Étiquettes',
  sharedTokens: 'Jetons partagés',
  notAvailable: 'Indisponible',
  addMore: 'Ajouter plus',
  attribute: 'Attribut',
  timeTaken: 'Temps passé',
  enginesMetrics: 'Métriques des moteurs',
  failed: 'Échoué',
  close: 'Fermer',
  alarmId: 'Identifiant de l\'alarme',
  longOutput: 'Sortie longue',
  timestamp: 'Horodatage',
  countOfMax: '{count} sur {total}',
  trigger: 'Déclencheur | Déclencheurs',
  column: 'Colonne | Colonnes',
  countOfTotal: '{count} sur {total}',
  deprecatedTrigger: 'Ce déclencheur n\'est plus pris en charge',
  initialLongOutput: 'Sortie initiale longue',
  totalStateChanges: 'Changements d\'état totaux',
  noReceivedEvents: 'Aucun événement reçu pendant {duration} par certaines dépendances',
  frequencyLimit: 'Nombre d\'oscillations',
  clearSearch: 'Ne plus appliquer cette recherche',
  noData: 'Aucune donnée',
  noColumns: 'Veuillez sélectionner au moins une colonne',
  theme: 'Thème | Thèmes',
  systemName: 'Nom du système',
  emitTrigger: 'Émettre un déclencheur',
  header: 'En-tête | En-têtes',
  headerKey: 'Clé d\'en-tête',
  headerValue: 'Valeur d\'en-tête',
  rule: 'Règle | Règles',
  copyValue: 'Copier la valeur',
  copyProperty: 'Copier la propriété',
  copyPropertyPath: 'Copier le chemin de la propriété',
  hidden: 'Caché',
  numberField: 'Champ numérique',
  chart: 'Graphique | Graphiques',
  currentDate: 'Date actuelle',
  chooseFile: 'Choisir le fichier',
  seeAlarms: 'Voir les alarmes',
  new: 'Nouvelle',
  regexp: 'Expression régulière',
  variableTypes: {
    string: 'Chaîne de caractères',
    number: 'Nombre',
    boolean: 'Booléen',
    null: 'Nul',
    array: 'Tableau',
    object: 'Object',
  },
  mixedField: {
    types: {
      [PATTERN_FIELD_TYPES.string]: '@:common.variableTypes.string',
      [PATTERN_FIELD_TYPES.number]: '@:common.variableTypes.number',
      [PATTERN_FIELD_TYPES.boolean]: '@:common.variableTypes.boolean',
      [PATTERN_FIELD_TYPES.null]: '@:common.variableTypes.null',
      [PATTERN_FIELD_TYPES.stringArray]: '@:common.variableTypes.array',
    },
  },
  saveChanges: 'Sauvegarder',
  ordinals: {
    first: 'D\'abord',
    second: 'Seconde',
    third: 'Troisième',
    fourth: 'Quatrième',
    fifth: 'Cinquième',
  },
  times: {
    second: 'seconde | secondes',
    minute: 'minute | minutes',
    hour: 'heure | heures',
    day: 'jour | jours',
    week: 'semaine | semaines',
    month: 'mois | mois',
    year: 'année | années',
  },
  timeFrequencies: {
    secondly: 'Par seconde',
    minutely: 'Par minute',
    hourly: 'Par heure',
    daily: 'Quotidien',
    weekly: 'Hebdomadiare',
    monthly: 'Mensuel',
    yearly: 'Annuel',
  },
  weekDays: {
    monday: 'Lundi',
    tuesday: 'Mardi',
    wednesday: 'Mercredi',
    thursday: 'Jeudi',
    friday: 'Vendredi',
    saturday: 'Samedi',
    sunday: 'Dimanche',
  },
  months: {
    january: 'Janvier',
    february: 'Février',
    march: 'Mars',
    april: 'Avril',
    may: 'Mai',
    june: 'Juin',
    july: 'Juillet',
    august: 'Août',
    september: 'Septembre',
    october: 'Octobre',
    november: 'Novembre',
    december: 'Décembre',
  },
  stateTypes: {
    [ENTITIES_STATES.ok]: 'Ok',
    [ENTITIES_STATES.minor]: 'Mineur',
    [ENTITIES_STATES.major]: 'Majeur',
    [ENTITIES_STATES.critical]: 'Critique',
  },
  statusTypes: {
    [ENTITIES_STATUSES.closed]: 'Fermée',
    [ENTITIES_STATUSES.ongoing]: 'En cours',
    [ENTITIES_STATUSES.flapping]: 'Bagot',
    [ENTITIES_STATUSES.stealthy]: 'Furtive',
    [ENTITIES_STATUSES.cancelled]: 'Annulée',
    [ENTITIES_STATUSES.noEvents]: 'Pas d\'événements',
  },
  operators: {
    [PATTERN_OPERATORS.equal]: 'Égal',
    [PATTERN_OPERATORS.contains]: 'Contient',
    [PATTERN_OPERATORS.notEqual]: 'n\'est pas égal',
    [PATTERN_OPERATORS.notContains]: 'Ne contient pas',
    [PATTERN_OPERATORS.beginsWith]: 'Commence par',
    [PATTERN_OPERATORS.notBeginWith]: 'Ne commence pas par',
    [PATTERN_OPERATORS.endsWith]: 'Se termine par',
    [PATTERN_OPERATORS.notEndWith]: 'Ne se termine pas par',
    [PATTERN_OPERATORS.exist]: 'Existe',
    [PATTERN_OPERATORS.notExist]: 'N\'existe pas',

    [PATTERN_OPERATORS.hasEvery]: 'Contient chaque',
    [PATTERN_OPERATORS.hasOneOf]: 'Contient l\'un des',
    [PATTERN_OPERATORS.isOneOf]: 'Est l\'un de',
    [PATTERN_OPERATORS.hasNot]: 'Ne contient pas',
    [PATTERN_OPERATORS.isNotOneOf]: 'N\'est pas l\'un des',
    [PATTERN_OPERATORS.isEmpty]: 'Est vide',
    [PATTERN_OPERATORS.isNotEmpty]: 'N\'est pas vide',

    [PATTERN_OPERATORS.higher]: 'Plus haut que',
    [PATTERN_OPERATORS.lower]: 'Plus bas que',

    [PATTERN_OPERATORS.longer]: 'Supérieure à',
    [PATTERN_OPERATORS.shorter]: 'Inférieure à',

    [PATTERN_OPERATORS.ticketAssociated]: 'Un ticket est associé',
    [PATTERN_OPERATORS.ticketNotAssociated]: 'Un ticket n\'est pas associé',

    [PATTERN_OPERATORS.canceled]: 'Annulé',
    [PATTERN_OPERATORS.notCanceled]: 'Non annulé',

    [PATTERN_OPERATORS.snoozed]: 'En attente',
    [PATTERN_OPERATORS.notSnoozed]: 'Non mis en attente',

    [PATTERN_OPERATORS.acked]: 'Acquitté',
    [PATTERN_OPERATORS.notAcked]: 'Non acquitté',

    [PATTERN_OPERATORS.isGrey]: 'Tuile grise',
    [PATTERN_OPERATORS.isNotGrey]: 'Tuile non grise',

    [PATTERN_OPERATORS.with]: 'Avec',
    [PATTERN_OPERATORS.without]: 'Sans',

    [PATTERN_OPERATORS.activated]: 'Activé',
    [PATTERN_OPERATORS.inactive]: 'Inactif',

    [PATTERN_OPERATORS.regexp]: 'Expression régulière',
  },
  entityEventTypes: {
    [EVENT_ENTITY_TYPES.ack]: 'Acquitter',
    [EVENT_ENTITY_TYPES.ackRemove]: 'Suppression d\'acquittement',
    [EVENT_ENTITY_TYPES.assocTicket]: 'Associer un ticket',
    [EVENT_ENTITY_TYPES.declareTicket]: 'Déclarer un incident',
    [EVENT_ENTITY_TYPES.cancel]: 'Annuler',
    [EVENT_ENTITY_TYPES.uncancel]: 'Annuler l\'annulation',
    [EVENT_ENTITY_TYPES.changeState]: 'Changer et vérrouiller la criticité',
    [EVENT_ENTITY_TYPES.check]: 'Vérifier',
    [EVENT_ENTITY_TYPES.comment]: 'Commenter l\'alarme',
    [EVENT_ENTITY_TYPES.snooze]: 'Mettre en veille',
  },

  triggers: {
    [TRIGGERS.create]: {
      text: 'Création d\'alarme',
    },
    [TRIGGERS.statedec]: {
      text: 'Diminution de la criticité',
    },
    [TRIGGERS.changestate]: {
      text: 'Changement et verrouillage de la criticité',
    },
    [TRIGGERS.stateinc]: {
      text: 'Augmentation de la criticité',
    },
    [TRIGGERS.changestatus]: {
      text: 'Changement de statut (flapping, bagot, ...)',
    },
    [TRIGGERS.ack]: {
      text: 'Acquittement d\'une alarme',
    },
    [TRIGGERS.ackremove]: {
      text: 'Suppression de l\'acquittement d\'une alarme',
    },
    [TRIGGERS.cancel]: {
      text: 'Annulation d\'une alarme',
    },
    [TRIGGERS.uncancel]: {
      text: 'Annulation de l\'annulation d\'une alarme',
      helpText: 'L\'annulation ne peut se faire que par un événement posté sur l\'API',
    },
    [TRIGGERS.comment]: {
      text: 'Commentaire sur une alarme',
    },
    [TRIGGERS.declareticket]: {
      text: 'Déclaration de ticket depuis l\'interface graphique',
    },
    [TRIGGERS.declareticketwebhook]: {
      text: 'Déclaration de ticket depuis un webhook',
    },
    [TRIGGERS.assocticket]: {
      text: 'Association de ticket sur une alarme',
    },
    [TRIGGERS.snooze]: {
      text: 'Mise en veille d\'une alarme',
    },
    [TRIGGERS.unsnooze]: {
      text: 'Sortie de veille d\'une alarme',
    },
    [TRIGGERS.resolve]: {
      text: 'Résolution d\'une alarme',
    },
    [TRIGGERS.activate]: {
      text: 'Activation d\'une alarme',
    },
    [TRIGGERS.pbhenter]: {
      text: 'Comportement périodique démarré',
    },
    [TRIGGERS.pbhleave]: {
      text: 'Comportement périodique terminé',
    },
    [TRIGGERS.instructionfail]: {
      text: 'Consigne manuelle en erreur',
    },
    [TRIGGERS.autoinstructionfail]: {
      text: 'Consigne automatique en erreur',
    },
    [TRIGGERS.instructionjobfail]: {
      text: 'Job de remédiation en erreur',
    },
    [TRIGGERS.instructionjobcomplete]: {
      text: 'Job de remédiation terminé',
    },
    [TRIGGERS.instructioncomplete]: {
      text: 'Consigne manuelle terminée',
    },
    [TRIGGERS.autoinstructioncomplete]: {
      text: 'Consigne automatique terminée',
    },
    [TRIGGERS.autoinstructionresultok]: {
      text: 'L\'alarme est en état OK après toutes les instructions automatiques',
    },
    [TRIGGERS.autoinstructionresultfail]: {
      text: 'L\'alarme n\'est pas dans l\'état OK après toutes les instructions automatiques',
    },
  },
  themes: {
    [THEMES_NAMES.canopsis]: 'Canopsis',
    [THEMES_NAMES.canopsisDark]: 'Canopsis sombre',
    [THEMES_NAMES.colorBlind]: 'Daltonien',
    [THEMES_NAMES.colorBlindDark]: 'Daltonien foncé',
  },
  request: {
    timeout: 'Temps libre',
    timeoutSettings: 'Paramètres de délai d\'attente',
    repeatRequest: 'Répéter la demande',
    skipVerify: 'Ne pas vérifier les certificats HTTPS',
    headersHelpText: 'Sélectionnez la clé et la valeur de l\'en-tête ou saisissez-les manuellement',
    emptyHeaders: 'Aucun en-tête ajouté pour le moment',
    urlHelp: '<p>Les variables accessibles sont : <strong>.Alarm</strong>, <strong>.Entity</strong> et <strong>.Children</strong></p>'
      + '<i>Quelques exemples :</i>'
      + '<pre>"https://exampleurl.com?resource={{ .Alarm.Value.Resource }}"</pre>'
      + '<pre>"https://exampleurl.com?entity_id={{ .Entity.ID }}"</pre>'
      + '<pre>"https://exampleurl.com?children_count={{ len .Children }}"</pre>'
      + '<pre>"https://exampleurl.com?children={{ range .Children }}{{ .ID }}{{ end }}"</pre>',
  },
};
