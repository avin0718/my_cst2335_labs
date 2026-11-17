/// Translation helper class providing multilingual support.
class AppLocalizations {
  static String currentLanguage = 'en'; // Default language: English ('en')

  static final Map<String, Map<String, String>> _localizedValues = {
    'es': {
      'Flutter Demo Home Page': 'Página de Inicio Flutter Demo',
      'Contact List': 'Lista de Contactos',
      'Login': 'Iniciar Sesión',
      'Username': 'Nombre de usuario',
      'Password': 'Contraseña',
      'Welcome Back': 'Bienvenido de nuevo',
      'First Name': 'Nombre',
      'First name': 'Nombre',
      'Last Name': 'Apellido',
      'Last name': 'Apellido',
      'Phone Number': 'Número de teléfono',
      'Email address': 'Correo electrónico',
      'Email Address': 'Correo electrónico',
      'Type here': 'Escriba aquí',
      'Submit': 'Enviar',
      'Add': 'Agregar',
      'Language': 'Idioma',
      'Error': 'Error',
      'URL is not supported on this device.':
          'La URL no es compatible en este dispositivo.',
      'OK': 'Aceptar',
      'Invalid password!': '¡Contraseña incorrecta!',
      'Please enter username and password':
          'Por favor ingrese usuario y contraseña',
      'Profile Page': 'Página de Perfil',
      'Logout': 'Cerrar Sesión',
      'Save Credentials': 'Guardar Credenciales',
      'Would you like to save your username and password for next time?':
          '¿Desea guardar su nombre de usuario y contraseña para la próxima vez?',
      'Yes': 'Sí',
      'No': 'No',
      'Previous login name and password loaded':
          'Se han cargado el nombre de usuario y la contraseña anteriores',
      'There are no contacts in the list':
          'No hay contactos en la lista',
      'Delete Contact': 'Eliminar contacto',
      'Do you want to delete this item?':
          '¿Desea eliminar este elemento?',
      'Item Details': 'Detalles del elemento',
      'Item Name': 'Nombre del elemento',
      'Database ID': 'ID de base de datos',
      'Delete': 'Eliminar',
      'Close': 'Cerrar',
      'Select a contact to view details':
          'Seleccione un contacto para ver los detalles',
    },
    'fr': {
      'Flutter Demo Home Page': 'Page d\'accueil Flutter Demo',
      'Contact List': 'Liste de Contacts',
      'Login': 'Connexion',
      'Username': "Nom d'utilisateur",
      'Password': 'Mot de passe',
      'Welcome Back': 'Bon retour',
      'First Name': 'Prénom',
      'First name': 'Prénom',
      'Last Name': 'Nom de famille',
      'Last name': 'Nom de famille',
      'Phone Number': 'Numéro de téléphone',
      'Email address': 'Adresse e-mail',
      'Email Address': 'Adresse e-mail',
      'Type here': 'Tapez ici',
      'Submit': 'Soumettre',
      'Add': 'Ajouter',
      'Language': 'Langue',
      'Error': 'Erreur',
      'URL is not supported on this device.':
          "L'URL n'est pas prise en charge sur cet appareil.",
      'OK': "D'accord",
      'Invalid password!': 'Mot de passe incorrect !',
      'Please enter username and password':
          "Veuillez saisir un nom d'utilisateur et un mot de passe",
      'Profile Page': 'Page de Profil',
      'Logout': 'Déconnexion',
      'Save Credentials': 'Enregistrer les identifiants',
      'Would you like to save your username and password for next time?':
          'Souhaitez-vous enregistrer votre nom d\'utilisateur et votre mot de passe pour la prochaine fois ?',
      'Yes': 'Oui',
      'No': 'Non',
      'Previous login name and password loaded':
          'Nom d\'utilisateur et mot de passe précédents chargés',
      'There are no contacts in the list':
          'Il n\'y a pas de contacts dans la liste',
      'Delete Contact': 'Supprimer le contact',
      'Do you want to delete this item?':
          'Voulez-vous supprimer cet élément ?',
      'Item Details': 'Détails de l\'élément',
      'Item Name': 'Nom de l\'élément',
      'Database ID': 'ID de base de données',
      'Delete': 'Supprimer',
      'Close': 'Fermer',
      'Select a contact to view details':
          'Sélectionnez un contact pour voir les détails',
    },
  };

  /// Returns translated string for [text] based on [currentLanguage].
  static String translate(String text) {
    if (currentLanguage == 'en') return text;
    return _localizedValues[currentLanguage]?[text] ?? text;
  }
}

/// Helper extension function for convenient translate() calls.
String translate(String text) => AppLocalizations.translate(text);
