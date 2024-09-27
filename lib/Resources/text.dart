class TextRes {
  static const String dbName = "lfgBooks";

  static const String dbAccesError = "Datenbankinteraktion fehlgeschlagen: ";

  static const String timeOutException = "Ladefehler: ";

  static const String unexpectedDbError =
      "Ein unerwarteter Fehler bei der Datenbankinteraktion: ";

  static const String typeJson = 'type';

  static const String studentIdJson = 'id';
  static const String studentFirstNameJson = 'firstName';
  static const String studentLastNameJson = 'lastName';
  static const String studentClassLevelJson = TextRes.bookClassLevelJson;
  static const String studentClassCharJson = 'classChar';
  static const String studentTrainingDirectionsJson = 'trainingDirections';
  static const String studentBooksJson = 'books';
  static const String studentTypeJson = 'student';
  static const String studentAmountOfBooksJson = 'amountOfBooks';

  static const String bookIdJson = 'bookId';
  static const String bookNameJson = 'name';
  static const String bookSubjectJson = 'subject';
  static const String bookClassLevelJson = 'classLevel';
  static const String bookPublisherJson = 'bookPublisher';
  static const String bookPriceJson = 'bookPrice';
  static const String bookAdmissionNumberJson = 'admissionNumber';
  static const String bookFollowingBookJson = 'followingBook';
  static const String bookSatzNummerJson = 'bookSatzNummer';


  static const String studentSearchHint =
      'Suche nach Schülernamen, Klassen und Ausbildungen';

  static const String student = "Schüler";
  static const String book = "Buch";

  static const String addChipsHint = "Klicken zum Hinzufügen";

  static const String search = "Suche";

  static const String selectChipHelper = "Option auswählen";

  static const String cancel = "Abbrechen";

  static const String firstNameError = "Bitte Vornamen eingeben!";

  static const String lastNameError = "Bitte Nachnamen eingeben!";

  static const String classError = "Bitte Klasse auswählen!";

  static const String firstNameHint = "Vorname";

  static const String lastNameHint = "Nachname";

  static const String classDataDropdownDescription = "Klasse auswählen";

  static const String trainingDirectionsDataDropdownDescription =
      "Ausbildung(en) auswählen";

  static const String addStudentTitle = "Schüler hinzufügen";

  static const String saveActionText = "Speichern";

  static const String trainingDirectionsJson = 'label';

  static const String trainingDirectionsTypeJson = 'training_directions';

  static const String bookTrainingDirectionJson = 'trainingDirection';

  static const bookAmountInStudentOwnershipJson = 'amountInStudentOwnership';

  static const bookNowAvailableJson = 'nowAvailable';

  static const bookTotalAvailableJson = 'totalAvailable';

  static const bookTypeJson = 'book';

  static const String bookNegativeIntError =
      "Negative value for on or more of this variables: "
      "classLevel, expectedAmountNeeded, nowAvailable, totalAvailable";

  static const String idJson = 'id';

  static const String classDataClassLevelJson = "classLevel";

  static const String classDataClassCharJson = "classChar";

  static const String classDataTypeJson = "classData";

  static const String ftsStudent = "fts_student";

  static const String wasDeleted = "wurde gelöscht";

  static const String undo = "rückgängig";

  static const String updateActionText = "Entleiher aktualisieren";

  static const String updateTitle = "aktualisieren";

  static const String studentTagsJson = "tag";

  static const String sure = "Wirklich";

  static const String delete = "Löschen";

  static const String toDelete = "löschen?";

  static const String addFilter = "Filter hinzufügen";

  static const String severalStudents = "Schüler";

  static const String severalStudentsInfo =
      "Hinzufüge-Aktionen betreffen alle ausgewählten Schüler \n"
      "Löschen-Aktionen nur Diejenigen, die das Attribut auch besitzen";

  static const String warning = "Mahnung";

  static const String books = "Bücher";

  static const String duplicate = "Duplizieren";

  static const String addBookStudentDetailInstructions =
      "Wählen Sie die Bücher aus, die sie hinzufügen wollen";

  static const String ftsBookStudentDetail = "book_fts_index";

  static const String addBooks = "Ausgewählte Bücher hinzufügen";

  static const String from = "von";

  static const String severalStudentsGenitive = "Schülern";

  static const String toAdd = "hinzufügen";

  static const String standardWarningAdd =
      "Standard Mahnung kopieren und als Tag hinzufügen";

  static const String classLevel = ". Klasse";

  static const String classLevels = "Jahrgangsstufen";

  static const String switchStackBookView =
      "Wechseln zwischen Bücheransicht/Stapelansicht";

  static const String edit = "Bearbeiten";

  static const String bookClassLevelJsonIndex = "classLevelIndex";

  static const String basicTrainingDirection = "BASIC";

  static const String slash = "/";

  static const String hyphen = "—";

  static const String trainingDirectionSelectionRowError =
      "Einen der Buttons wählen!";

  static const String classLevelWithoutDot = "Jahrgangsstufe";

  static const String trainingDirectionLabelInput = "Ausbildungslabel";

  static const String trainingDirectionsNameError = "Bitte ein label eintippen";

  static const String classLevelError =
      "Nur Zahlen(=Jahrgangsstufe) sind gültig!";

  static const String trainingDirectionHyphen = "-";

  static const String bookNameHint = "Buchname";

  static const String bookSubjectHint = "Fach des Buchs";

  static const String classLevelHint = "Jahrgangsstufe";

  static const String bookAmountHint = "Bücheranzahl";

  static const String bookIsbnNumberJson = "isbnNumber";

  static const String availableClassLevelError =
      "Bitte eine der folgenden Klassen: ";

  static const String toInsert = "eingeben";

  static String bookSubjectError =
      "Bitte das Fach eingeben und Bindestriche entfernen!";

  static String bookNameError =
      "Bitte einen Buchnamen eingeben, Bindestriche und Punkte entfernen!";

  static String bookAmountError = "Den Buchbestand als Zahl eingeben!";

  static const String trainingDirectionsAdd = "Ausbildungen zuordnen";

  static const String trainingDirectionsDisplay = "Ausbildungen:";

  static const String isbnHint = "ISBN (optional)";

  static const String addBook = "Buch hinzufügen";

  static String trainingDirectionsJsonIndex = "trainingDirectionLabelIndex";

  static const String booksOfTrainingDirectionsIndex =
      "booksOfTrainingDirectionIndex";

  static const String bookDialogNotFullyEditable =
      "Hinweis: Da Schüler dieses Buch besitzen, sind Name, Fach, Ausbildungen nicht veränderbar";

  static const String studentsOfBookIdIndex = "StudentsOfBookIdIndex";

  static const String bookAmountAvailable = "Verfügbar: ";

  static const String useAsFilter = "Als Filter verwenden";

  static const String isbnDisplay = "ISBN:";

  static const String bookNotDeletable =
      "Buch kann nicht gelöscht werden, weil Schüler es besitzen!";

  static const String bookSet = ". Satz";

  static const String bookAmountInStudentOwnershipDisplay =
      "mal wurde dieses Buch entliehen";

  static const String booksNotAddable =
      "Folgende Bücher sind in zu geringer Anzahl verfügbar:";

  static const String settingsTooltip = "Einstellungen/Import";

  static const String seperator = "|";

  static const String equals = "=";

  static const String studentAttrbMapperFirstname = "Vorname";

  static const String studentAttrbMapperLastname = "Nachname";

  static const String studentAttrbMapperClass = "Klasse";

  static const String studentAttrbMapperTrainingDirection = "Ausbildung";

  static const String studentAttrbMapperTags = "Tags";



  static const String back = "Zurück";

  static const String next = "Weiter";

  static const String areMandatory = "verpflichtend auszuwählen!";

  static const String importNewSchoolYearTitle = "Neues Schuljahr";

  static const String importNewStudents = "Schüler importieren";

  static const String importNewAttributes = "Attribute importieren";

  static const String importPreferencesClassCharDescription = "Schüler die keiner Klasse mit Buchstabe zugeordnet sind importieren.\n"
      "Hinweis: Falls diese Option nicht gewählt wurde werden Schüler z.B. der Klasse 12 nicht importiert.";

  static const String importOptionsTitle = "Importoptionen:";

  static const String openExcelFileLabel = "Excel Datei auswählen";

  static const String selected = "ausgewählt";

  static const String selectExcelFileError = "Eine Excel Datei muss ausgewählt werden!";

  static const String importPreferencesExistingStudentsDescription = "Vorhandene Schüler behalten und mit neuen Daten aktualisieren.\n"
      "Hinweis: Dabei werden alte Ausbildungen gelöscht und neue Ausbildungen und Bücher hinzugefügt. Alte Bücher bleiben erhalten.";

  static const String success = "Operation erfolgreich - Weiterleitung erfolgt gleich";

  static const String excelFileTooManySheetsError = "Die Excel Datei darf nur 1 Tabellenblatt besitzen!";

  static const String excelNoHeaderError = "Die Excel Datei scheint keine Spaltentitel zu besitzen.\n"
      "Bitte in der ersten Zeile Titel für die Spalten eintragen.";

  static const String importFirstNameCannotBeEmptyError = " | Der Vorname darf nicht leer sein! | \n";

  static const String importFirstNameMustNotContainNonAlphabeticalError = " | Der Vorname darf keine Sonderzeichen (Kommas, Hashtags etc.) und Zahlen enthalten! | \n";

  static const String importLastNameCannotBeEmptyError = " | Der Nachname darf nicht leer sein! | \n";

  static const String importLastNameMustNotContainNonAlphabeticalError = " | Der Nachname darf keine Sonderzeichen (Kommas, Hashtags etc.) und Zahlen enthalten! | \n";

  static const String importClassCannotBeEmptyError = " | Die Klasse darf nicht leer sein! | \n";

  static const String importClassPatternNumericAllowedError = " | Die Klasse muss dem Muster Nummer+Text/Buchstabe folgen, z.B. 10K, 5A oder nur eine Nummer sein: 8, 12, 13 | \n";

  static const String importClassPatternError =" | Die Klasse muss dem Muster Nummer+Text/Buchstabe folgen, z.B. 10K, 5A | \n" ;

  static const String importTrainingDirectionInvalid = r'| Ausbildungen dürfen keine "-", "–", ",", ";" beinhalten! | ' "\n";

  static const String excelFormatErrorComment = "Fehlerkommentar";

  static const String importExcelFormatError = "Die Excel Datei enthält Formatierungsfehler. "
      "Bitte im nächsten Schritt die Excel Datei mit den fehlerhaften Zeilen herunterladen und ausbessern. \n"
      "Hinweis: Alle Zeilen ohne Formatierungsfehler werden importiert.";

  static const String downloadExcelFormatError = "Excel Datei mit fehlerhaft formatierten Zeilen herunterladen:";

  static const String download = "Herunterladen";

  static const String saveExcelFormatErrorLabel = "Excel Datei mti fehlerhaften Zeilen speichern";

  static const String excelFormatErrorFileName = "Buecherteam_Format_Error_Excel.xlsx";

  static const String fileSaved = "Datei gespeichert!";

  static const String goToDownload = "Zum Herunterladen";

  static const String goToImportError = "Zu den Fehlern";

  static const String finishImport = "Import abschließen";

  static const String importSuccess = "Import erfolgreich!";

  static const String classLettersError = "Bsp.: A, B, C - aktuelles Format ungültig!";

  static const String classLettersHint = "Buchstaben";

  static const String selectPath = "Pfad für die Datenbank auswählen";

  static const String dbPath = "dbPath";

  static const List<String> introPaths = ["/addClassData"];

  static const String selectPathError = "Pfad für die Datenbank auswählen";

  static const String comma = ",";

  static const String correctClassData = "Klassen korrigieren!";













}
