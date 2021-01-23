object ProgrammerForm: TProgrammerForm
  AlignWithMargins = True
  Left = 0
  Top = 0
  Caption = 'ProgrammerForm'
  ClientHeight = 514
  ClientWidth = 1048
  Color = clSkyBlue
  Ctl3D = False
  Font.Charset = TURKISH_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object UserTablesTriggersComboBox: TComboBox
    Left = 8
    Top = 64
    Width = 217
    Height = 21
    TabOrder = 0
    Text = 'UserTablesTriggersComboBox'
    Items.Strings = (
      '//Log Tables//'
      
        'CREATE TRIGGER [TriggerName] ON "[ApplicationSchemaName]"."[Tabl' +
        'eName]"'
      'AFTER INSERT, UPDATE, DELETE AS'
      'BEGIN'
      
        '  IF COALESCE((SELECT TOP 1 "Logging" FROM "[ApplicationSchemaNa' +
        'me]"."Main Setup"), '#39'TRUE'#39') = '#39'FALSE'#39' RETURN;'
      ''
      '  DECLARE @aLogTime      DATETIME;'
      '  DECLARE @aInsertCount  INTEGER;'
      '  DECLARE @aDeleteCount  INTEGER;'
      '  DECLARE @aUserID       INTEGER;'
      ''
      '  SET @aLogTime     = CURRENT_TIMESTAMP;'
      '  SET @aInsertCount = (SELECT COUNT(*) FROM inserted);'
      '  SET @aDeleteCount = (SELECT COUNT(*) FROM deleted);'
      
        '  SET @aUserID      = (SELECT "Kullan'#305'c'#305' ID" FROM "[ApplicationS' +
        'chemaName]"."Kullan'#305'c'#305'" WHERE "Kullan'#305'c'#305'" = SYSTEM_USER AND "Akt' +
        'if" = '#39'TRUE'#39');'
      ''
      '  IF @aInsertCount > 0 AND @aDeleteCount > 0'
      '  BEGIN'
      
        '    INSERT INTO "[ApplicationSchemaName]"."[TableName] LOG" ("Lo' +
        'g Type ID", "Log User ID", "Log Time", "Log Count", [FieldNames]' +
        ') SELECT 3, @aUserID, @aLogTime, @aDeleteCount, [FieldNames] FRO' +
        'M deleted;'
      
        '    INSERT INTO "[ApplicationSchemaName]"."[TableName] LOG" ("Lo' +
        'g Type ID", "Log User ID", "Log Time", "Log Count", [FieldNames]' +
        ') SELECT 4, @aUserID, @aLogTime, @aInsertCount, [FieldNames] FRO' +
        'M inserted;'
      '  END'
      '  ELSE'
      '  BEGIN'
      
        '    IF @aInsertCount > 0 INSERT INTO "[ApplicationSchemaName]"."' +
        '[TableName] LOG" ("Log Type ID", "Log User ID", "Log Time", "Log' +
        ' Count", [FieldNames]) SELECT 1, @aUserID, @aLogTime, @aInsertCo' +
        'unt, [FieldNames] FROM inserted;'
      
        '    IF @aDeleteCount > 0 INSERT INTO "[ApplicationSchemaName]"."' +
        '[TableName] LOG" ("Log Type ID", "Log User ID", "Log Time", "Log' +
        ' Count", [FieldNames]) SELECT 2, @aUserID, @aLogTime, @aDeleteCo' +
        'unt, [FieldNames] FROM deleted;'
      '  END;'
      'END'
      ''
      ''
      '//Foreign Key Child//'
      
        'CREATE TRIGGER [TriggerName] ON "[ApplicationSchemaName]"."[Tabl' +
        'eName]"'
      'AFTER INSERT, UPDATE AS'
      'BEGIN'
      '  IF [UpdateOrForChild]'
      
        '    IF EXISTS (SELECT 1 FROM inserted T1 WHERE ([IsNotNULLORANDC' +
        'lause]) AND NOT EXISTS (SELECT 1 FROM [ForeignTable] T2 WHERE [W' +
        'hereClause]))'
      '    BEGIN'
      '      DECLARE @aErrorMessage VARCHAR(1000);'
      
        '      SET @aErrorMessage = "[ApplicationSchemaName]"."FN GetData' +
        'baseLanguageMessage" ('#39'"Foreign Key" hatas'#305'. [ForeignTable] tabl' +
        'osunda ana (parent) kay'#305't mevcut de'#287'il ([ParentFieldNames]). Bu ' +
        'durumda "[ApplicationSchemaName]"."[TableName]" tablosunda alt (' +
        'child) kay'#305't olu'#351'turulamaz ([ChildFieldNames]).'#39', '#39'"Foreign Key"' +
        ' error. Parent does not exist in [ForeignTable] ([ParentFieldNam' +
        'es]). Cannot create child in "[ApplicationSchemaName]"."[TableNa' +
        'me]" ([ChildFieldNames]).'#39');'
      '      RAISERROR (@aErrorMessage, 11, 1);'
      '      ROLLBACK TRANSACTION;'
      '      RETURN;'
      '    END;'
      'END'
      ''
      '//Foreign Key Parent//'
      'CREATE TRIGGER [TriggerName] ON [ForeignTable]'
      'AFTER UPDATE, DELETE AS'
      'BEGIN'
      '  DECLARE @aUpdate INTEGER;'
      '  DECLARE @aDelete INTEGER;'
      '  DECLARE @aDeleteCascade INTEGER;'
      '  DECLARE @aErrorMessage VARCHAR(1000);'
      ''
      '  SET @aUpdate = 0;'
      '  SET @aDelete = 0;'
      ''
      '  SET @aDeleteCascade = [ON DELETE CASCADE];'
      ''
      '  IF EXISTS (SELECT 1 FROM inserted)'
      '    SET @aUpdate = 1'
      '  ELSE'
      '    IF EXISTS (SELECT 1 FROM deleted) SET @aDelete = 1;'
      ''
      '  IF @aUpdate = 0 AND @aDelete = 0 RETURN;'
      ''
      '  IF ([IfConditionForParent]) AND (@aUpdate = 1)'
      '    IF EXISTS (SELECT 1'
      '               FROM "[ApplicationSchemaName]"."[TableName]" T1'
      '                 INNER JOIN inserted T2 ON [WhereClauseT2T1]'
      '               WHERE [WhereConditionForParent])'
      '    BEGIN'
      
        '      SET @aErrorMessage = "[ApplicationSchemaName]"."FN GetData' +
        'baseLanguageMessage" ('#39'"Foreign Key" hatas'#305'. "[ApplicationSchema' +
        'Name]"."[TableName]" tablosunda '#351'arta ba'#287'l'#305' alt (child) kay'#305'tlar' +
        ' mevcut ([ChildFieldNames]). Bu durumda [ForeignTable] tablosund' +
        'aki ana (parent) kay'#305't de'#287'i'#351'tirilemez.'#39', '#39'"Foreign Key" error. C' +
        'hildren exist with condition in "[ApplicationSchemaName]"."[Tabl' +
        'eName]" ([ChildFieldNames]). Cannot update parent in [ForeignTab' +
        'le].'#39');'
      '      RAISERROR (@aErrorMessage, 11, 2);'
      '      ROLLBACK TRANSACTION;'
      '      RETURN;'
      '    END;'
      ''
      '  IF (@aUpdate = 1) AND ([UpdateOrForParent]) /*Update Cascade*/'
      '  BEGIN'
      
        '    SELECT IDENTITY(INTEGER, 1, 1) AS "ID_Number", [FieldNames] ' +
        'INTO #MyDeleted[TempTableSayac]  FROM deleted;'
      
        '    SELECT IDENTITY(INTEGER, 1, 1) AS "ID_Number", [FieldNames] ' +
        'INTO #MyInserted[TempTableSayac] FROM inserted;'
      ''
      '    UPDATE "[ApplicationSchemaName]"."[TableName]" SET'
      '      [SetClause]'
      '    FROM "[ApplicationSchemaName]"."[TableName]" T1'
      
        '      INNER JOIN #MyDeleted[TempTableSayac]  T2 ON [WhereClauseT' +
        '2T1]'
      
        '      INNER JOIN #MyInserted[TempTableSayac] T3 ON T3."ID_Number' +
        '" = T2."ID_Number" AND ([WhereClauseT3T2NotOr]);'
      ''
      '    DROP TABLE #MyDeleted[TempTableSayac];'
      '    DROP TABLE #MyInserted[TempTableSayac];'
      '  END;'
      ''
      '  IF (@aDelete = 1) AND (@aDeleteCascade = 1) /*Delete Cascade*/'
      '    DELETE FROM "[ApplicationSchemaName]"."[TableName]"'
      '    FROM "[ApplicationSchemaName]"."[TableName]" T1'
      
        '    WHERE EXISTS (SELECT 1 FROM deleted T2 WHERE [WhereClauseT2T' +
        '1])'
      ''
      
        '  IF (@aDelete = 1) AND (@aDeleteCascade = 0) /*Delete Not Casca' +
        'de*/'
      
        '    IF EXISTS (SELECT 1 FROM "[ApplicationSchemaName]"."[TableNa' +
        'me]" T1 INNER JOIN deleted T2 ON [WhereClauseT2T1])'
      '    BEGIN'
      
        '      SET @aErrorMessage = "[ApplicationSchemaName]"."FN GetData' +
        'baseLanguageMessage" ('#39'"Foreign Key" hatas'#305'. "[ApplicationSchema' +
        'Name]"."[TableName]" tablosunda alt (child) kay'#305'tlar mevcut ([Ch' +
        'ildFieldNames]). Bu durumda [ForeignTable] tablosundaki ana (par' +
        'ent) kay'#305't silinemez ([ParentFieldNames]).'#39', '#39'"Foreign Key" erro' +
        'r. Children exist in "[ApplicationSchemaName]"."[TableName]" ([C' +
        'hildFieldNames]). Cannot delete parent in [ForeignTable] ([Paren' +
        'tFieldNames]).'#39');'
      '      RAISERROR (@aErrorMessage, 11, 3);'
      '      ROLLBACK TRANSACTION;'
      '      RETURN;'
      '    END;'
      'END'
      ''
      ''
      '//Yetki//'
      
        'CREATE TRIGGER [TriggerName] ON "[ApplicationSchemaName]"."[Tabl' +
        'eName]"'
      'AFTER INSERT, UPDATE, DELETE AS'
      'BEGIN'
      
        '  IF EXISTS (SELECT 1 FROM "[ApplicationSchemaName]"."Kullan'#305'c'#305'"' +
        ' WHERE "Kullan'#305'c'#305'" = SYSTEM_USER AND "Aktif" = '#39'TRUE'#39' AND "Y'#246'net' +
        'ici" = '#39'TRUE'#39') RETURN;'
      ''
      '  DECLARE @aInsert INTEGER;'
      '  DECLARE @aUpdate INTEGER;'
      '  DECLARE @aDelete INTEGER;'
      '  DECLARE @aErrorMessage VARCHAR(1000);'
      ''
      '  SET @aErrorMessage = NULL;'
      ''
      
        '  IF EXISTS (SELECT 1 FROM inserted) SET @aInsert = 1 ELSE SET @' +
        'aInsert = 0;'
      
        '  IF EXISTS (SELECT 1 FROM deleted)  SET @aDelete = 1 ELSE SET @' +
        'aDelete = 0;'
      ''
      '  IF @aInsert = 0 AND @aDelete = 0 RETURN;'
      ''
      
        '  IF @aInsert = 1 AND @aDelete = 1 SET @aUpdate = 1 ELSE SET @aU' +
        'pdate = 0;'
      '  IF @aUpdate = 1 SET @aInsert = 0;'
      '  IF @aUpdate = 1 SET @aDelete = 0;'
      ''
      '  IF @aInsert = 1'
      '    IF EXISTS (SELECT'
      '                 1'
      '               FROM inserted T1'
      
        '                 INNER JOIN "[ApplicationSchemaName]"."Yetki" T2' +
        ' ON T2."Yetki ID" = T1."Yetki ID"'
      
        '                 LEFT JOIN "[ApplicationSchemaName]"."Yetki Kull' +
        'an'#305'c'#305'" T3 ON T3."Yetki ID" = T1."Yetki ID" AND T3."Kullan'#305'c'#305'" = ' +
        'SYSTEM_USER'
      
        '               WHERE T1."Yetki ID" IS NOT NULL AND ((T2."Eri'#351'im"' +
        ' = '#39'FALSE'#39') OR (COALESCE(T3."'#304'lave Et", T2."'#304'lave Et") = '#39'FALSE'#39 +
        ')))'
      
        '      SET @aErrorMessage = "[ApplicationSchemaName]"."FN GetData' +
        'baseLanguageMessage" ('#39'"Yetki" k'#305's'#305'tlamalar'#305' nedeniyle "[Applica' +
        'tionSchemaName]"."[TableName]" tablosunda kay'#305't ilave etme yetki' +
        'niz yoktur. "Yetki" ve "Yetki Kullan'#305'c'#305'" tablolar'#305'n'#305' kontrol edi' +
        'niz.'#39', '#39'You do not have authority to insert record in "[Applicat' +
        'ionSchemaName]"."[TableName]" table because of "Yetki" restricti' +
        'ons. Check "Yetki" and "Yetki Kullan'#305'c'#305'" tables.'#39');'
      ''
      '  IF @aUpdate = 1'
      '    IF EXISTS (SELECT'
      '                 1'
      '               FROM deleted T1'
      
        '                 INNER JOIN "[ApplicationSchemaName]"."Yetki" T2' +
        ' ON T2."Yetki ID" = T1."Yetki ID"'
      
        '                 LEFT JOIN "[ApplicationSchemaName]"."Yetki Kull' +
        'an'#305'c'#305'" T3 ON T3."Yetki ID" = T1."Yetki ID" AND T3."Kullan'#305'c'#305'" = ' +
        'SYSTEM_USER'
      
        '               WHERE T1."Yetki ID" IS NOT NULL AND ((T2."Eri'#351'im"' +
        ' = '#39'FALSE'#39') OR (COALESCE(T3."De'#287'i'#351'tir", T2."De'#287'i'#351'tir") = '#39'FALSE'#39 +
        ')))'
      
        '      SET @aErrorMessage = "[ApplicationSchemaName]"."FN GetData' +
        'baseLanguageMessage" ('#39'"Yetki" k'#305's'#305'tlamalar'#305' nedeniyle "[Applica' +
        'tionSchemaName]"."[TableName]" tablosunda kay'#305't de'#287'i'#351'tirme yetki' +
        'niz yoktur. "Yetki" ve "Yetki Kullan'#305'c'#305'" tablolar'#305'n'#305' kontrol edi' +
        'niz.'#39', '#39'You do not have authority to update record in "[Applicat' +
        'ionSchemaName]"."[TableName]" table because of "Yetki" restricti' +
        'ons. Check "Yetki" and "Yetki Kullan'#305'c'#305'" tables.'#39');'
      ''
      '  IF @aErrorMessage IS NULL AND @aUpdate = 1'
      '    IF EXISTS (SELECT'
      '                 1'
      '               FROM inserted T1'
      
        '                 INNER JOIN "[ApplicationSchemaName]"."Yetki" T2' +
        ' ON T2."Yetki ID" = T1."Yetki ID"'
      
        '                 LEFT JOIN "[ApplicationSchemaName]"."Yetki Kull' +
        'an'#305'c'#305'" T3 ON T3."Yetki ID" = T1."Yetki ID" AND T3."Kullan'#305'c'#305'" = ' +
        'SYSTEM_USER'
      
        '               WHERE T1."Yetki ID" IS NOT NULL AND ((T2."Eri'#351'im"' +
        ' = '#39'FALSE'#39') OR (COALESCE(T3."'#304'lave Et", T2."'#304'lave Et") = '#39'FALSE'#39 +
        ')))'
      
        '      SET @aErrorMessage = "[ApplicationSchemaName]"."FN GetData' +
        'baseLanguageMessage" ('#39'"Yetki" k'#305's'#305'tlamalar'#305' nedeniyle "[Applica' +
        'tionSchemaName]"."[TableName]" tablosunda kay'#305't de'#287'i'#351'tirme yetki' +
        'niz yoktur. "Yetki" ve "Yetki Kullan'#305'c'#305'" tablolar'#305'n'#305' kontrol edi' +
        'niz.'#39', '#39'You do not have authority to update record in "[Applicat' +
        'ionSchemaName]"."[TableName]" table because of "Yetki" restricti' +
        'ons. Check "Yetki" and "Yetki Kullan'#305'c'#305'" tables.'#39');'
      ''
      '  IF @aDelete = 1'
      '    IF EXISTS (SELECT'
      '                 1'
      '               FROM deleted T1'
      
        '                 INNER JOIN "[ApplicationSchemaName]"."Yetki" T2' +
        ' ON T2."Yetki ID" = T1."Yetki ID"'
      
        '                 LEFT JOIN "[ApplicationSchemaName]"."Yetki Kull' +
        'an'#305'c'#305'" T3 ON T3."Yetki ID" = T1."Yetki ID" AND T3."Kullan'#305'c'#305'" = ' +
        'SYSTEM_USER'
      
        '               WHERE T1."Yetki ID" IS NOT NULL AND ((T2."Eri'#351'im"' +
        ' = '#39'FALSE'#39') OR (COALESCE(T3."Sil", T2."Sil") = '#39'FALSE'#39')))'
      
        '      SET @aErrorMessage = "[ApplicationSchemaName]"."FN GetData' +
        'baseLanguageMessage" ('#39'"Yetki" k'#305's'#305'tlamalar'#305' nedeniyle "[Applica' +
        'tionSchemaName]"."[TableName]" tablosunda kay'#305't silme yetkiniz y' +
        'oktur. "Yetki" ve "Yetki Kullan'#305'c'#305'" tablolar'#305'n'#305' kontrol ediniz.'#39 +
        ', '#39'You do not have authority to delete record in "[ApplicationSc' +
        'hemaName]"."[TableName]" table because of "Yetki" restrictions. ' +
        'Check "Yetki" and "Yetki Kullan'#305'c'#305'" tables.'#39');'
      ''
      '  IF @aErrorMessage IS NOT NULL'
      '  BEGIN'
      '    RAISERROR (@aErrorMessage, 11, 4);'
      '    ROLLBACK TRANSACTION;'
      '    RETURN;'
      '  END;'
      'END'
      ''
      ''
      '//Read Only//'
      
        'CREATE TRIGGER [TriggerName] ON "[ApplicationSchemaName]"."[Tabl' +
        'eName]"'
      'AFTER INSERT, UPDATE, DELETE AS'
      'BEGIN'
      
        '  IF NOT EXISTS (SELECT 1 FROM "[ApplicationSchemaName]"."Kullan' +
        #305'c'#305'" WHERE "Kullan'#305'c'#305'" = SYSTEM_USER AND "Aktif" = '#39'TRUE'#39' AND "Y' +
        #246'netici" = '#39'TRUE'#39')'
      '  BEGIN'
      '    DECLARE @aErrorMessage VARCHAR(1000);'
      
        '    SET @aErrorMessage = "[ApplicationSchemaName]"."FN GetDataba' +
        'seLanguageMessage" ('#39'"Read Only" tablolarda ("[ApplicationSchema' +
        'Name]"."[TableName]") kay'#305't ilave etme, kay'#305't de'#287'i'#351'tirme veya ka' +
        'y'#305't silme yetkiniz yoktur. Bu i'#351'lemleri sadece "Y'#246'netici" yetkis' +
        'ine sahip kullan'#305'c'#305'lar ger'#231'ekle'#351'tirebilirler.'#39', '#39'You do not have' +
        ' authority to insert, update or delete any record on "Read Only"' +
        ' tables ("[ApplicationSchemaName]"."[TableName]"). Just "Adminis' +
        'trators" can do those kind of operations.'#39');'
      '    RAISERROR (@aErrorMessage, 11, 5);'
      '    ROLLBACK TRANSACTION;'
      '    RETURN;'
      '  END;'
      'END'
      ''
      ''
      '//Hi'#231' Kimse//'
      
        'CREATE TRIGGER [TriggerName] ON "[ApplicationSchemaName]"."[Tabl' +
        'eName]"'
      'AFTER INSERT, UPDATE, DELETE AS'
      'BEGIN'
      '  DECLARE @aErrorMessage VARCHAR(1000);'
      
        '  SET @aErrorMessage = "[ApplicationSchemaName]"."FN GetDatabase' +
        'LanguageMessage" ('#39'"[ApplicationSchemaName]"."[TableName]" tablo' +
        'sunda kimse kay'#305't ilave etme, kay'#305't de'#287'i'#351'tirme veya kay'#305't silme ' +
        'i'#351'lemi ger'#231'ekle'#351'tiremez.'#39', '#39'No one can insert, update or delete ' +
        'any record in table "[ApplicationSchemaName]"."[TableName]".'#39');'
      '  RAISERROR (@aErrorMessage, 11, 6);'
      '  ROLLBACK TRANSACTION;'
      '  RETURN;'
      'END'
      ''
      ''
      '//Log Tables Trigger//'
      
        'CREATE TRIGGER "[ApplicationSchemaName]"."TR [TableName] LOG, Re' +
        'ad Only" ON "[ApplicationSchemaName]"."[TableName] LOG"'
      'AFTER UPDATE, DELETE AS'
      'BEGIN'
      '  DECLARE @aErrorMessage VARCHAR(1000);'
      
        '  SET @aErrorMessage = "[ApplicationSchemaName]"."FN GetDatabase' +
        'LanguageMessage" ('#39'"[ApplicationSchemaName]"."[TableName] LOG" t' +
        'ablosunda kimse kay'#305't de'#287'i'#351'tirme veya kay'#305't silme i'#351'lemi ger'#231'ekl' +
        'e'#351'tiremez.'#39', '#39'No one can update or delete any record in table "[' +
        'ApplicationSchemaName]"."[TableName] LOG".'#39');'
      '  RAISERROR (@aErrorMessage, 11, 7);'
      '  ROLLBACK TRANSACTION;'
      '  RETURN;'
      'END'
      ''
      ''
      '//BB Ocak Aylar'#305' B'#252't'#231'e ID//'
      
        'CREATE TRIGGER [TriggerName] ON "[ApplicationSchemaName]"."[Tabl' +
        'eName]"'
      'AFTER INSERT, UPDATE AS'
      'BEGIN'
      '  IF EXISTS'
      '    ('
      '     SELECT'
      '       1'
      '     FROM inserted T1'
      
        '       INNER JOIN "[ApplicationSchemaName]"."B'#252't'#231'e" T2 ON T2."B'#252 +
        't'#231'e ID" = T1."B'#252't'#231'e ID"'
      
        '       INNER JOIN "[ApplicationSchemaName]"."D'#246'nem" T3 ON T3."D'#246 +
        'nem ID" = T2."D'#246'nem ID" AND T3."Ba'#351'lang'#305#231' Y'#305'l'#305'" = T1."Y'#305'l"'
      
        '       INNER JOIN "[ApplicationSchemaName]"."Y'#305'l" TY ON TY."D'#246'ne' +
        'm ID" = T2."D'#246'nem ID" AND TY."Y'#305'l" = T1."Y'#305'l"'
      '     WHERE [(TY."Ocak" = 0 AND T1."Ocak" <> 0) OR]'
      '    )'
      '    UPDATE "[ApplicationSchemaName]"."[TableName]" SET'
      '      ["Ocak" = T1."Ocak" * TY."Ocak"]'
      '    FROM "[ApplicationSchemaName]"."[TableName]" T1'
      
        '      INNER JOIN "[ApplicationSchemaName]"."B'#252't'#231'e" T2 ON T2."B'#252't' +
        #231'e ID" = T1."B'#252't'#231'e ID"'
      
        '      INNER JOIN "[ApplicationSchemaName]"."D'#246'nem" T3 ON T3."D'#246'n' +
        'em ID" = T2."D'#246'nem ID" AND T3."Ba'#351'lang'#305#231' Y'#305'l'#305'" = T1."Y'#305'l"'
      
        '      INNER JOIN "[ApplicationSchemaName]"."Y'#305'l" TY ON TY."D'#246'nem' +
        ' ID" = T2."D'#246'nem ID" AND TY."Y'#305'l" = T1."Y'#305'l"[INNER JOIN inserted' +
        ' T9 ON T9."" = T1.""]'
      '    WHERE [(TY."Ocak" = 0 AND T1."Ocak" <> 0) OR];'
      'END'
      ''
      ''
      '//BB Ocak Aylar'#305' D'#246'nem ID//'
      
        'CREATE TRIGGER [TriggerName] ON "[ApplicationSchemaName]"."[Tabl' +
        'eName]"'
      'AFTER INSERT, UPDATE AS'
      'BEGIN'
      '  IF EXISTS'
      '    ('
      '     SELECT'
      '       1'
      '     FROM inserted T1'
      
        '       INNER JOIN "[ApplicationSchemaName]"."D'#246'nem" T2 ON T2."D'#246 +
        'nem ID" = T1."D'#246'nem ID" AND T2."Ba'#351'lang'#305#231' Y'#305'l'#305'" = T1."Y'#305'l"'
      
        '       INNER JOIN "[ApplicationSchemaName]"."Y'#305'l" TY ON TY."D'#246'ne' +
        'm ID" = T1."D'#246'nem ID" AND TY."Y'#305'l" = T1."Y'#305'l"'
      '     WHERE [(TY."Ocak" = 0 AND T1."Ocak" <> 0) OR]'
      '    )'
      '    UPDATE "[ApplicationSchemaName]"."[TableName]" SET'
      '      ["Ocak" = T1."Ocak" * TY."Ocak"]'
      '    FROM "[ApplicationSchemaName]"."[TableName]" T1'
      
        '      INNER JOIN "[ApplicationSchemaName]"."D'#246'nem" T2 ON T2."D'#246'n' +
        'em ID" = T1."D'#246'nem ID" AND T2."Ba'#351'lang'#305#231' Y'#305'l'#305'" = T1."Y'#305'l"'
      
        '      INNER JOIN "[ApplicationSchemaName]"."Y'#305'l" TY ON TY."D'#246'nem' +
        ' ID" = T1."D'#246'nem ID" AND TY."Y'#305'l" = T1."Y'#305'l"[INNER JOIN inserted' +
        ' T9 ON T9."" = T1.""]'
      '    WHERE [(TY."Ocak" = 0 AND T1."Ocak" <> 0) OR];'
      'END'
      ''
      ''
      '//BB Ocak Aylar'#305' D'#246'nem Parent//'
      
        'CREATE TRIGGER [TriggerName] ON "[ApplicationSchemaName]"."D'#246'nem' +
        '"'
      'AFTER UPDATE AS'
      'BEGIN'
      
        '  IF NOT UPDATE("Ba'#351'lang'#305#231' Ay'#305'") AND NOT UPDATE("Ba'#351'lang'#305#231' Y'#305'l'#305'"' +
        ') RETURN;[UPDATE All Child BB Ocak Aylar'#305' Tables]'
      'END'
      ''
      ''
      '//D'#246'nem Read Only//'
      
        'CREATE TRIGGER [TriggerName] ON "[ApplicationSchemaName]"."[Tabl' +
        'eName]"'
      'AFTER INSERT, UPDATE, DELETE AS'
      'BEGIN'
      
        '  IF EXISTS (SELECT 1 FROM "[ApplicationSchemaName]"."D'#246'nem" T1 ' +
        'INNER JOIN (SELECT DISTINCT "D'#246'nem ID" FROM inserted UNION SELEC' +
        'T DISTINCT "D'#246'nem ID" FROM deleted) T2 ON T2."D'#246'nem ID" = T1."D'#246 +
        'nem ID" WHERE T1."Read Only" = '#39'TRUE'#39')'
      '  BEGIN'
      '    DECLARE @aErrorMessage VARCHAR(1000);'
      
        '    SET @aErrorMessage = "[ApplicationSchemaName]"."FN GetDataba' +
        'seLanguageMessage" ('#39'"D'#246'nem" tablosuyla ili'#351'kili olan tablolar'#305'n' +
        ' ("[ApplicationSchemaName]"."[TableName]") "Read Only" d'#246'nemlere' +
        ' ait kay'#305'tlarla ilgili kay'#305't ilave etme, kay'#305't de'#287'i'#351'tirme veya k' +
        'ay'#305't silme i'#351'lemi yap'#305'lamaz.'#39', '#39'You do not have authority to ins' +
        'ert, update or delete any record on tables ("[ApplicationSchemaN' +
        'ame]"."[TableName]") having referential integrity on "D'#246'nem" tab' +
        'le records those are "Read Only".'#39');'
      '    RAISERROR (@aErrorMessage, 11, 8);'
      '    ROLLBACK TRANSACTION;'
      '    RETURN;'
      '  END;'
      'END'
      ''
      ''
      '//B'#252't'#231'e Read Only//'
      
        'CREATE TRIGGER [TriggerName] ON "[ApplicationSchemaName]"."[Tabl' +
        'eName]"'
      'AFTER INSERT, UPDATE, DELETE AS'
      'BEGIN'
      
        '  IF EXISTS (SELECT 1 FROM "[ApplicationSchemaName]"."B'#252't'#231'e" T1 ' +
        'LEFT JOIN "[ApplicationSchemaName]"."D'#246'nem" T2 ON T2."D'#246'nem ID" ' +
        '= T1."D'#246'nem ID" INNER JOIN (SELECT DISTINCT "B'#252't'#231'e ID" FROM inse' +
        'rted UNION SELECT DISTINCT "B'#252't'#231'e ID" FROM deleted) T3 ON T3."B'#252 +
        't'#231'e ID" = T1."B'#252't'#231'e ID" WHERE T1."Read Only" = '#39'TRUE'#39' OR T2."Rea' +
        'd Only" = '#39'TRUE'#39')'
      '  BEGIN'
      '    DECLARE @aErrorMessage VARCHAR(1000);'
      
        '    SET @aErrorMessage = "[ApplicationSchemaName]"."FN GetDataba' +
        'seLanguageMessage" ('#39'"B'#252't'#231'e" tablosuyla ili'#351'kili olan tablolar'#305'n' +
        ' ("[ApplicationSchemaName]"."[TableName]") "Read Only" B'#252't'#231'elere' +
        ' (ve D'#246'nemlere) ait kay'#305'tlarla ilgili kay'#305't ilave etme, kay'#305't de' +
        #287'i'#351'tirme veya kay'#305't silme i'#351'lemi yap'#305'lamaz.'#39', '#39'You do not have a' +
        'uthority to insert, update or delete any record on tables ("[App' +
        'licationSchemaName]"."[TableName]") having referential integrity' +
        ' on "B'#252't'#231'e" (and "D'#246'nem") table records those are "Read Only".'#39')' +
        ';'
      '    RAISERROR (@aErrorMessage, 11, 9);'
      '    ROLLBACK TRANSACTION;'
      '    RETURN;'
      '  END;'
      'END'
      ''
      '')
  end
  object DatabaseUpgradeCodePanel: TPanel
    Left = 906
    Top = 39
    Width = 129
    Height = 134
    Font.Charset = TURKISH_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    object Label1: TLabel
      Left = 45
      Top = 20
      Width = 15
      Height = 16
      Alignment = taRightJustify
      Caption = 'Y'#305'l'
    end
    object Label2: TLabel
      Left = 42
      Top = 48
      Width = 18
      Height = 16
      Alignment = taRightJustify
      Caption = 'Ay'
    end
    object Label3: TLabel
      Left = 36
      Top = 76
      Width = 24
      Height = 16
      Alignment = taRightJustify
      Caption = 'G'#252'n'
    end
    object Label4: TLabel
      Left = 19
      Top = 103
      Width = 39
      Height = 16
      Alignment = taRightJustify
      Caption = 'Saya'#231
    end
    object DatabaseUpgradeCodeYearEdit: TEdit
      Left = 64
      Top = 16
      Width = 49
      Height = 22
      TabOrder = 0
      Text = '2012'
    end
    object DatabaseUpgradeCodeMonthEdit: TEdit
      Left = 64
      Top = 44
      Width = 49
      Height = 22
      TabOrder = 1
      Text = '1'
    end
    object DatabaseUpgradeCodeDayEdit: TEdit
      Left = 64
      Top = 72
      Width = 49
      Height = 22
      TabOrder = 2
      Text = '1'
    end
    object DatabaseUpgradeCodeSayacEdit: TEdit
      Left = 64
      Top = 100
      Width = 49
      Height = 22
      TabOrder = 3
      Text = '1'
    end
  end
  object UserTablesScriptComboBox: TComboBox
    Left = 8
    Top = 37
    Width = 217
    Height = 21
    TabOrder = 2
    Text = 'UserTablesScriptComboBox'
    Items.Strings = (
      'CREATE TABLE "User Table Groups" ('
      '             "Grup S'#305'ra No" FLOAT       NOT NULL,'
      '             "Grup"         VARCHAR(50) NOT NULL,'
      'CONSTRAINT "PK User Table Groups" PRIMARY KEY  ("Grup S'#305'ra No"),'
      'CONSTRAINT "UQ User Table Groups, Grup" UNIQUE ("Grup"));'
      ''
      'CREATE TABLE "User Tables" ('
      '             "Grup S'#305'ra No"   FLOAT         NOT NULL,'
      '             "Tablo S'#305'ra No"  FLOAT         NOT NULL,'
      '             "Table Name"     VARCHAR(128)  NOT NULL,'
      '             "Logging"        BIT           NOT NULL,'
      '             "Eri'#351'im"         VARCHAR(20)   NOT NULL,'
      '             "Veri Giri'#351'i"    BIT           NOT NULL,'
      '             "View SQL"       TEXT,'
      '             "View Tables"    VARCHAR(1000),'
      '             "Bands"          VARCHAR(1000),'
      '             "Skip"           BIT           NOT NULL,'
      '             "Display Key"    VARCHAR(200),'
      '             "BB Ocak Aylar'#305'" VARCHAR(200),'
      
        'CONSTRAINT "PK User Tables"                                  PRI' +
        'MARY KEY ("Table Name"),'
      
        'CONSTRAINT "UQ User Tables, Grup S'#305'ra No, Tablo S'#305'ra No"     UNI' +
        'QUE      ("Grup S'#305'ra No", "Tablo S'#305'ra No"),'
      
        'CONSTRAINT "FK User Tables, User Table Groups, Grup S'#305'ra No" FOR' +
        'EIGN KEY ("Grup S'#305'ra No") REFERENCES "User Table Groups" ("Grup ' +
        'S'#305'ra No") ON UPDATE CASCADE);'
      ''
      'CREATE TABLE "User Columns" ('
      
        '             "Table Name"                VARCHAR(128)   NOT NULL' +
        ','
      
        '             "S'#305'ra No"                   FLOAT          NOT NULL' +
        ','
      
        '             "Column Name"               VARCHAR(128)   NOT NULL' +
        ','
      
        '             "Data Type or Compute Text" VARCHAR(4000)  NOT NULL' +
        ','
      
        '             "Size"                      INTEGER        NOT NULL' +
        ','
      
        '             "Required"                  BIT            NOT NULL' +
        ','
      
        '             "Primary Key"               BIT            NOT NULL' +
        ','
      
        '             "Unique Column"             BIT            NOT NULL' +
        ','
      '             "Default Value"             VARCHAR(100),'
      
        '             "Index Column"              BIT            NOT NULL' +
        ','
      
        '             "Unique Columns 1"          BIT            NOT NULL' +
        ','
      
        '             "Unique Columns 2"          BIT            NOT NULL' +
        ','
      
        '             "Unique Columns 3"          BIT            NOT NULL' +
        ','
      '             "Check Rule 1"              VARCHAR(4000),'
      '             "Check Rule 2"              VARCHAR(4000),'
      '             "Check Rule 3"              VARCHAR(4000),'
      '             "Properties Class"          VARCHAR(30),'
      '             "Properties Info"           TEXT,'
      '             "Band Index"                INTEGER,'
      '             "Display Format"            VARCHAR(30),'
      
        '             "Klon '#304#231'in"                 BIT            NOT NULL' +
        ','
      
        'CONSTRAINT "PK User Columns"                          PRIMARY KE' +
        'Y ("Table Name", "S'#305'ra No"),'
      
        'CONSTRAINT "UQ User Columns, Table Name, Column Name" UNIQUE    ' +
        '  ("Table Name", "Column Name"),'
      
        'CONSTRAINT "FK User Columns, User Tables, Table Name" FOREIGN KE' +
        'Y ("Table Name") REFERENCES "User Tables" ("Table Name") ON UPDA' +
        'TE CASCADE ON DELETE CASCADE);'
      ''
      'CREATE TABLE "User Foreign Tables" ('
      '             "Table Name"              VARCHAR(128)  NOT NULL,'
      '             "S'#305'ra No"                 FLOAT         NOT NULL,'
      '             "Foreign Table Name"      VARCHAR(128)  NOT NULL,'
      '             "On Delete Cascade"       BIT           NOT NULL,'
      '             "Foreign Calc Fields"     VARCHAR(1000),'
      '             "Calc Fields New Names"   VARCHAR(1000),'
      '             "Calc Fields Pre Columns" VARCHAR(1000),'
      '             "Where For Child"         VARCHAR(4000),'
      '             "Klon '#304#231'in"               BIT           NOT NULL,'
      
        'CONSTRAINT "PK User Foreign Tables"                          PRI' +
        'MARY KEY ("Table Name", "S'#305'ra No", "Foreign Table Name"),'
      
        'CONSTRAINT "FK User Foreign Tables, User Tables, Table Name" FOR' +
        'EIGN KEY ("Table Name") REFERENCES "User Tables" ("Table Name") ' +
        'ON UPDATE CASCADE ON DELETE CASCADE);'
      ''
      'CREATE TABLE "User Foreign Table Columns" ('
      
        '             "Table Name"                  VARCHAR(128)  NOT NUL' +
        'L,'
      
        '             "S'#305'ra No"                     FLOAT         NOT NUL' +
        'L,'
      
        '             "Foreign Table Name"          VARCHAR(128)  NOT NUL' +
        'L,'
      
        '             "Column S'#305'ra No"              FLOAT         NOT NUL' +
        'L,'
      
        '             "Column Name"                 VARCHAR(128)  NOT NUL' +
        'L,'
      '             "Foreign Table Column"        VARCHAR(128),'
      
        '             "Lookup"                      BIT           NOT NUL' +
        'L,'
      '             "Lookup List Field Name"      VARCHAR(128),'
      '             "Lookup Table Name"           VARCHAR(128),'
      '             "Lookup Key Field Name"       VARCHAR(128),'
      '             "Lookup Filter SQL"           VARCHAR(1000),'
      '             "Lookup Filter MasterFields"  VARCHAR(1000),'
      '             "Lookup Filter DetailFields"  VARCHAR(1000),'
      '             "Lookup Column Name"          VARCHAR(128),'
      
        'CONSTRAINT "PK User Foreign Table Columns"                      ' +
        '                                         PRIMARY KEY ("Table Nam' +
        'e", "S'#305'ra No", "Foreign Table Name", "Column S'#305'ra No"),'
      
        'CONSTRAINT "FK User Foreign Table Columns, User Foreign Tables, ' +
        'Table Name, S'#305'ra No, Foreign Table Name" FOREIGN KEY ("Table Nam' +
        'e", "S'#305'ra No", "Foreign Table Name") REFERENCES "User Foreign Ta' +
        'bles" ("Table Name", "S'#305'ra No", "Foreign Table Name") ON UPDATE ' +
        'CASCADE ON DELETE CASCADE);'
      ''
      'CREATE TABLE "User Table Clones" ('
      '             "Table Name"          VARCHAR(128) NOT NULL,'
      '             "Replace From Text"   VARCHAR(50)  NOT NULL,'
      '             "Replace To Text"     VARCHAR(50)  NOT NULL,'
      '             "Replace From Text 2" VARCHAR(50),'
      '             "Replace To Text 2"   VARCHAR(50),'
      '             "Replace From Text 3" VARCHAR(200),'
      '             "Replace To Text 3"   VARCHAR(200),'
      '             "Replace From Text 4" VARCHAR(200),'
      '             "Replace To Text 4"   VARCHAR(200),'
      '             "Replace From Text 5" VARCHAR(200),'
      '             "Replace To Text 5"   VARCHAR(200),'
      '             "Columns To Remove"   VARCHAR(1000),'
      
        'CONSTRAINT "PK User Table Clones"                          PRIMA' +
        'RY KEY ("Table Name", "Replace From Text", "Replace To Text"),'
      
        'CONSTRAINT "FK User Table Clones, User Tables, Table Name" FOREI' +
        'GN KEY ("Table Name") REFERENCES "User Tables" ("Table Name") ON' +
        ' UPDATE CASCADE);'
      ''
      'CREATE TABLE "User Table ExecSQLs" ('
      '             "Table Name"  VARCHAR(128) NOT NULL,'
      '             "S'#305'ra No"     FLOAT        NOT NULL,'
      '             "ExecSQL"     TEXT         NOT NULL,'
      '             "Show Error"  BIT          NOT NULL,'
      '             "On Create"   BIT          NOT NULL,'
      '             "All Created" BIT          NOT NULL,'
      '             "Before Open" VARCHAR(1),'
      '             "After Close" VARCHAR(1),'
      '             "Progress"    VARCHAR(1000),'
      '             "Skip"        BIT          NOT NULL,'
      
        'CONSTRAINT "PK User Table ExecSQLs"                          PRI' +
        'MARY KEY ("Table Name", "S'#305'ra No"),'
      
        'CONSTRAINT "FK User Table ExecSQLs, User Tables, Table Name" FOR' +
        'EIGN KEY ("Table Name") REFERENCES "User Tables" ("Table Name") ' +
        'ON UPDATE CASCADE);'
      ''
      'CREATE TABLE "User Table Attach Tables" ('
      '             "Table Name"        VARCHAR(128) NOT NULL,'
      '             "S'#305'ra No"           FLOAT        NOT NULL,'
      '             "Attach Table"      VARCHAR(128) NOT NULL,'
      
        'CONSTRAINT "PK User Table Attach Tables"                        ' +
        '  PRIMARY KEY ("Table Name", "S'#305'ra No"),'
      
        'CONSTRAINT "FK User Table Attach Tables, User Tables, Table Name' +
        '" FOREIGN KEY ("Table Name") REFERENCES "User Tables" ("Table Na' +
        'me") ON UPDATE CASCADE);'
      ''
      'CREATE TABLE "User Object Display Labels" ('
      '             "Object Name" VARCHAR(128) NOT NULL,'
      '             "English"     VARCHAR(128) NOT NULL,'
      
        '             "Ayn'#305'"        AS CAST(CASE WHEN CAST("Object Name" ' +
        'AS VARBINARY) = CAST("English" AS VARBINARY) THEN '#39'TRUE'#39' ELSE '#39'F' +
        'ALSE'#39' END AS BIT),'
      
        'CONSTRAINT "PK User Object Display Labels"          PRIMARY KEY ' +
        '("Object Name"),'
      
        'CONSTRAINT "UQ User Object Display Labels, English" UNIQUE      ' +
        '("English"));'
      ''
      'CREATE TABLE "User Ana Men'#252'" ('
      '             "S'#305'ra No"  FLOAT       NOT NULL,'
      '             "Ana Men'#252'" VARCHAR(30) NOT NULL,'
      'CONSTRAINT "PK User Ana Men'#252'"          PRIMARY KEY ("Ana Men'#252'"),'
      'CONSTRAINT "UQ User Ana Men'#252', S'#305'ra No" UNIQUE ("S'#305'ra No"));'
      ''
      'CREATE TABLE "User Men'#252'" ('
      '             "Ana Men'#252'"         VARCHAR(30)   NOT NULL,'
      '             "S'#305'ra No"          FLOAT         NOT NULL,'
      '             "Men'#252'"             VARCHAR(100)  NOT NULL,'
      '             "Men'#252' English"     VARCHAR(100)  NOT NULL,'
      '             "Progress"         VARCHAR(1000),'
      
        'CONSTRAINT "PK User Men'#252'"                          PRIMARY KEY (' +
        '"Ana Men'#252'", "S'#305'ra No"),'
      
        'CONSTRAINT "UQ User Men'#252', Men'#252'"                    UNIQUE      (' +
        '"Men'#252'"),'
      
        'CONSTRAINT "UQ User Men'#252', Men'#252' English"            UNIQUE      (' +
        '"Men'#252' English"),'
      
        'CONSTRAINT "FK User Men'#252', User Ana Men'#252', Ana Men'#252'" FOREIGN KEY (' +
        '"Ana Men'#252'") REFERENCES "User Ana Men'#252'" ("Ana Men'#252'") ON UPDATE CA' +
        'SCADE);'
      ''
      'CREATE TABLE "User Men'#252' Tablo" ('
      '             "Men'#252'"                   VARCHAR(100)  NOT NULL,'
      '             "S'#305'ra No"                FLOAT         NOT NULL,'
      '             "Table Name"             VARCHAR(128)  NOT NULL,'
      '             "3x3 Index"              INTEGER,'
      '             "Master Table Index"     INTEGER,'
      '             "Master Field Names"     VARCHAR(500),'
      '             "Detail Field Names"     VARCHAR(500),'
      '             "Use Calc Fields"        BIT           NOT NULL,'
      '             "Extra ID"               VARCHAR(50),'
      '             "Read Only"              BIT           NOT NULL,'
      '             "Invisible Fields"       VARCHAR(1000),'
      '             "Read Only Fields"       VARCHAR(1000),'
      '             "Grid Read Only Fields"  VARCHAR(1000),'
      '             "Filter SQL"             VARCHAR(1000),'
      '             "Caption"                VARCHAR(200),'
      '             "Grid Buttons"           VARCHAR(1000),'
      '             "Refresh Master"         BIT           NOT NULL,'
      '             "B'#252't'#231'e A'#231'"               VARCHAR(15),'
      
        'CONSTRAINT "PK User Men'#252' Tablo"                  PRIMARY KEY ("M' +
        'en'#252'", "S'#305'ra No"),'
      
        'CONSTRAINT "FK User Men'#252' Tablo, User Men'#252', Men'#252'" FOREIGN KEY ("M' +
        'en'#252'") REFERENCES "User Men'#252'" ("Men'#252'") ON UPDATE CASCADE);'
      ''
      'CREATE TABLE "User Men'#252' Clones" ('
      '             "Men'#252'"                VARCHAR(100) NOT NULL,'
      '             "Replace From Text"   VARCHAR(50)  NOT NULL,'
      '             "Replace To Text"     VARCHAR(50)  NOT NULL,'
      '             "Replace From Text 2" VARCHAR(50),'
      '             "Replace To Text 2"   VARCHAR(50),'
      '             "Replace From Text 3" VARCHAR(200),'
      '             "Replace To Text 3"   VARCHAR(200),'
      
        'CONSTRAINT "PK User Men'#252' Clones"                  PRIMARY KEY ("' +
        'Men'#252'", "Replace From Text", "Replace To Text"),'
      
        'CONSTRAINT "FK User Men'#252' Clones, User Men'#252', Men'#252'" FOREIGN KEY ("' +
        'Men'#252'") REFERENCES "User Men'#252'" ("Men'#252'") ON UPDATE CASCADE);'
      ''
      '')
  end
  object NOTTheProgrammersComputerCheckBox: TCheckBox
    Left = 392
    Top = 39
    Width = 249
    Height = 17
    Caption = 'NOT The Programmer'#39's Computer'
    Color = clSkyBlue
    Ctl3D = False
    Font.Charset = TURKISH_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentColor = False
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 3
  end
  object ProgrammersMessagePanel: TPanel
    Left = 707
    Top = 192
    Width = 328
    Height = 177
    BevelOuter = bvLowered
    Color = clSilver
    Ctl3D = False
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 7
    Visible = False
    object ProgrammersMessageLabel: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 164
      Height = 169
      Align = alClient
      AutoSize = False
      Caption = 'ProgrammersMessageLabel'
      Color = clSilver
      Font.Charset = TURKISH_CHARSET
      Font.Color = clNavy
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
      ExplicitWidth = 61
      ExplicitHeight = 97
    end
    object Panel1: TPanel
      Left = 171
      Top = 1
      Width = 156
      Height = 175
      Align = alRight
      BevelOuter = bvNone
      Color = clSilver
      Ctl3D = False
      ParentBackground = False
      ParentCtl3D = False
      TabOrder = 0
      object ProgrammersMessageMemo: TMemo
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 150
        Height = 143
        Align = alClient
        Color = clMenu
        Ctl3D = False
        Font.Charset = TURKISH_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        Lines.Strings = (
          '91,232,176 45:57.325'
          '    32,176 45:57.325'
          '       176 45:57.325')
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 0
      end
      object ProgrammersMessageEdit: TEdit
        AlignWithMargins = True
        Left = 3
        Top = 152
        Width = 150
        Height = 20
        Align = alBottom
        Font.Charset = TURKISH_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        Text = 'ProgrammersMessageEdit'
      end
    end
  end
  object dxBarManager: TdxBarManager
    AllowCallFromAnotherForm = True
    Scaled = False
    Font.Charset = TURKISH_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    ImageOptions.ImageListBkColor = clSilver
    ImageOptions.StretchGlyphs = False
    ImageOptions.UseLargeImagesForLargeIcons = True
    LookAndFeel.Kind = lfOffice11
    LookAndFeel.NativeStyle = False
    MenusShowRecentItemsFirst = False
    PopupMenuLinks = <>
    ShowFullMenusAfterDelay = False
    ShowShortCutInHint = True
    Style = bmsOffice11
    SunkenBorder = True
    UseSystemFont = False
    OnClickItem = dxBarManagerClickItem
    Left = 248
    Top = 40
    DockControlHeights = (
      0
      0
      25
      0)
    object dxBarManagerMenuBar: TdxBar
      AllowClose = False
      AllowQuickCustomizing = False
      AllowReset = False
      Caption = 'Ana Men'#252
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 864
      FloatTop = 314
      FloatClientWidth = 127
      FloatClientHeight = 130
      Font.Charset = TURKISH_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ItemLinks = <
        item
          Visible = True
          ItemName = 'ProgramciSubItem'
        end>
      NotDocking = [dsNone]
      OneOnRow = True
      RotateWhenVertical = False
      Row = 0
      ShowMark = False
      UseOwnFont = True
      UseRecentItems = False
      UseRestSpace = True
      Visible = True
      WholeRow = False
    end
    object TestItem: TdxBarLargeButton
      Caption = 'Test'
      Category = 0
      Hint = 'Test'
      Style = cxStyleBold8Black
      Visible = ivAlways
      LargeImageIndex = 15
      OnClick = TestItemClick
      Width = 100
      SyncImageIndex = False
      ImageIndex = 4
    end
    object TablolarItem: TdxBarLargeButton
      Caption = 'Tablolar - Viewlar'
      Category = 0
      Hint = 'Tablolar - Viewlar'
      Style = cxStyleBold8Navy
      Visible = ivAlways
      LargeImageIndex = 13
      OnClick = TablolarItemClick
    end
    object UserTablesScriptItem: TdxBarButton
      Caption = 'User Tables Script'
      Category = 0
      Hint = 'User Tables Script'
      Style = cxStyleBold8Black
      Visible = ivAlways
      LargeImageIndex = 1
      OnClick = UserTablesScriptItemClick
    end
    object ProgramciSubItem: TdxBarSubItem
      Caption = 'Programc'#305
      Category = 0
      Style = cxStyleBold8Navy
      Visible = ivAlways
      ImageIndex = 8
      LargeImageIndex = 8
      ItemLinks = <
        item
          Visible = True
          ItemName = 'ImageSeperatorEditItem'
        end
        item
          Visible = True
          ItemName = 'TESTBtn'
        end
        item
          Visible = True
          ItemName = 'ImageSeperatorEditItem'
        end
        item
          Visible = True
          ItemName = 'TablolarItem'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'VeriGirisleriItem'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'TabloGruplariItem'
        end
        item
          Visible = True
          ItemName = 'ImageSeperatorEditItem'
        end
        item
          Visible = True
          ItemName = 'TablolariOlusturItem'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'TablolariOnceSilItem'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'TablolariSonraTemptenGeriYukleItem'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'MevcutTempSilinmesinOrdanGeriYuklensinItem'
        end
        item
          Visible = True
          ItemName = 'ImageSeperatorEditItem'
        end
        item
          Visible = True
          ItemName = 'dxBarButton5'
        end
        item
          Visible = True
          ItemName = 'ImageSeperatorEditItem'
        end
        item
          Visible = True
          ItemName = 'ProgramDatasiniOlusturItem'
        end
        item
          Visible = True
          ItemName = 'ImageSeperatorEditItem'
        end
        item
          Visible = True
          ItemName = 'UserTablesItem'
        end
        item
          Visible = True
          ItemName = 'ImageSeperatorEditItem'
        end
        item
          Visible = True
          ItemName = 'TestlerSubItem'
        end
        item
          Visible = True
          ItemName = 'ImageSeperatorEditItem'
        end
        item
          Distributed = False
          Visible = True
          ItemName = 'UserTablesScriptItem'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'PASDosyalariniDuzenleItem'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'BackupPROGRAMCIDatabaseItem'
        end
        item
          Visible = True
          ItemName = 'ImageSeperatorEditItem'
        end
        item
          Visible = True
          ItemName = 'ProgramciyaMesajlarBariniGosterItem'
        end
        item
          Visible = True
          ItemName = 'ImageSeperatorEditItem'
        end
        item
          Visible = True
          ItemName = 'ButunTablolariAcKapatItem'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'ButunMenulariAcItem'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'ButunMenuleriAcveKapatItem'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'ButunTablolariveMenuleriAcveKapatItem'
        end
        item
          Visible = True
          ItemName = 'ImageSeperatorEditItem'
        end>
      ItemOptions.ShowDescriptions = False
      ItemOptions.Size = misNormal
    end
    object TestlerSubItem: TdxBarSubItem
      Caption = 'Testler'
      Category = 0
      Style = cxStyleBold8Black
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'ImageSeperatorEditItem'
        end
        item
          Visible = True
          ItemName = 'TestItem'
        end
        item
          Visible = True
          ItemName = 'ImageSeperatorEditItem'
        end
        item
          Visible = True
          ItemName = 'MessagesTestItem'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'SchemaNamesItem'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'SelectionsItem'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'MetaDataItem'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'OnCalcTestItem'
        end
        item
          Visible = True
          ItemName = 'ImageSeperatorEditItem'
        end>
    end
    object MessagesTestItem: TdxBarButton
      Caption = 'Messages (Mi, Mw, Me, Mc...)'
      Category = 0
      Hint = 'Messages (Mi, Mw, Me, Mc)'
      Style = cxStyleBold8Black
      Visible = ivAlways
      OnClick = MessagesTestItemClick
    end
    object SchemaNamesItem: TdxBarButton
      Caption = 'Schema Names'
      Category = 0
      Hint = 'Schema Names'
      Style = cxStyleBold8Black
      Visible = ivAlways
      OnClick = SchemaNamesItemClick
    end
    object SelectionsItem: TdxBarButton
      Caption = 'Selections'
      Category = 0
      Hint = 'Selections'
      Style = cxStyleBold8Black
      Visible = ivAlways
      OnClick = SelectionsItemClick
    end
    object ImageSeperatorEditItem: TcxBarEditItem
      Category = 0
      Style = cxStyleImageSeparator
      Visible = ivAlways
      Width = 200
      PropertiesClassName = 'TcxImageProperties'
      CanSelect = False
      Properties.PopupMenuLayout.MenuItems = []
      StyleEdit = cxStyleImageSeparator
    end
    object BackupPROGRAMCIDatabaseItem: TdxBarButton
      Caption = 'Backup PROGRAMCI Database'
      Category = 0
      Hint = 'Backup PROGRAMCI Database'
      Style = cxStyleBold8Black
      Visible = ivAlways
      OnClick = BackupPROGRAMCIDatabaseItemClick
    end
    object TablolariOlusturItem: TdxBarButton
      Tag = 1
      Caption = 'Tablolar'#305' Olu'#351'tur'
      Category = 0
      Hint = 'Tablolar'#305' Olu'#351'tur'
      Style = cxStyleBold8Purple
      Visible = ivAlways
      OnClick = TablolariOlusturItemClick
    end
    object MetaDataItem: TdxBarButton
      Caption = 'Meta Data'
      Category = 0
      Hint = 'Meta Data'
      Visible = ivAlways
      OnClick = MetaDataItemClick
    end
    object TablolariOnceSilItem: TdxBarButton
      Caption = 'Tablolar'#305' '#214'nce Sil (Drop)'
      Category = 0
      Hint = 'Tablolar'#305' '#214'nce Sil (Drop)'
      Style = cxStyleBold8Red
      Visible = ivAlways
      ButtonStyle = bsChecked
      CloseSubMenuOnClick = False
      Down = True
    end
    object dxBarButton5: TdxBarButton
      Tag = 2
      Caption = 'Tablo Olu'#351'turma SQL Scriptini G'#246'ster'
      Category = 0
      Hint = 'Tablo Olu'#351'turma SQL Scriptini G'#246'ster'
      Style = cxStyleBold8Black
      Visible = ivAlways
      OnClick = TablolariOlusturItemClick
    end
    object PASDosyalariniDuzenleItem: TdxBarButton
      Caption = 
        'Program Klas'#246'r'#252'ndeki PAS Dosyalar'#305'ndaki "User Tables" vs. D'#252'zenl' +
        'e'
      Category = 0
      Hint = 
        'Program Klas'#246'r'#252'ndeki PAS Dosyalar'#305'ndaki "User Tables" vs. D'#252'zenl' +
        'e'
      Style = cxStyleBold8Black
      Visible = ivAlways
      DropDownEnabled = False
      OnClick = PASDosyalariniDuzenleItemClick
    end
    object UserTablesItem: TdxBarButton
      Caption = 'User All Tables - Menus'
      Category = 0
      Hint = 'User All Tables - Menus'
      Style = cxStyleBold8Black
      Visible = ivAlways
      OnClick = UserTablesItemClick
    end
    object VeriGirisleriItem: TdxBarButton
      Caption = 'Veri Giri'#351'leri'
      Category = 0
      Hint = 'Veri Giri'#351'leri'
      Style = cxStyleBold8Navy
      Visible = ivAlways
      OnClick = VeriGirisleriItemClick
    end
    object ProgramDatasiniOlusturItem: TdxBarButton
      Caption = 'Program Datas'#305'n'#305' (ProgrammerData.Pas) Olu'#351'tur'
      Category = 0
      Hint = 'Program Datas'#305'n'#305' (ProgrammerData.Pas) Olu'#351'tur'
      Style = cxStyleBold8Purple
      Visible = ivAlways
      OnClick = ProgramDatasiniOlusturItemClick
    end
    object ProgramciyaMesajlarBariniGosterItem: TdxBarButton
      Caption = 'Programc'#305'ya Mesajlar Bar'#305'n'#305' G'#246'ster'
      Category = 0
      Hint = 'Programc'#305'ya Mesajlar Bar'#305'n'#305' G'#246'ster'
      Style = cxStyleBold8Black
      Visible = ivAlways
      OnClick = ProgramciyaMesajlarBariniGosterItemClick
    end
    object TablolariSonraTemptenGeriYukleItem: TdxBarButton
      Caption = 'Tablolar'#305' Sonra Temp'#39'ten Geri Y'#252'kle'
      Category = 0
      Hint = 'Tablolar'#305' Sonra Temp'#39'ten Geri Y'#252'kle'
      Style = cxStyleBold8Red
      Visible = ivAlways
      ButtonStyle = bsChecked
      CloseSubMenuOnClick = False
      Down = True
    end
    object ButunMenulariAcItem: TdxBarButton
      Tag = 1
      Caption = 'B'#252't'#252'n Men'#252'leri A'#231
      Category = 0
      Hint = 'B'#252't'#252'n Men'#252'leri A'#231
      Style = cxStyleBold8Black
      Visible = ivAlways
      OnClick = ButunMenulariAcItemClick
    end
    object ButunMenuleriAcveKapatItem: TdxBarButton
      Tag = 2
      Caption = 'B'#252't'#252'n Men'#252'leri A'#231' ve Kapat'
      Category = 0
      Hint = 'B'#252't'#252'n Men'#252'leri A'#231' ve Kapat'
      Style = cxStyleBold8Black
      Visible = ivAlways
      OnClick = ButunMenulariAcItemClick
    end
    object TabloGruplariItem: TdxBarButton
      Caption = 'Tablo Gruplar'#305
      Category = 0
      Hint = 'Tablo Gruplar'#305
      Style = cxStyleBold8Navy
      Visible = ivAlways
      OnClick = TabloGruplariItemClick
    end
    object ButunTablolariAcKapatItem: TdxBarButton
      Caption = 'B'#252't'#252'n Tablolar'#305' A'#231' Kapat'
      Category = 0
      Hint = 'B'#252't'#252'n Tablolar'#305' A'#231' Kapat'
      Style = cxStyleBold8Black
      Visible = ivAlways
      OnClick = ButunTablolariAcKapatItemClick
    end
    object ButunTablolariveMenuleriAcveKapatItem: TdxBarButton
      Caption = 'B'#252't'#252'n Tablolar'#305' ve Men'#252'leri A'#231' ve Kapat'
      Category = 0
      Hint = 'B'#252't'#252'n Tablolar'#305' ve Men'#252'leri A'#231' ve Kapat'
      Style = cxStyleBold8Black
      Visible = ivAlways
      OnClick = ButunTablolariveMenuleriAcveKapatItemClick
    end
    object MevcutTempSilinmesinOrdanGeriYuklensinItem: TdxBarButton
      Caption = 'Mevcut Temp Silinmesin (Ordan Geri Y'#252'klensin)'
      Category = 0
      Hint = 'Mevcut Temp Silinmesin (Ordan Geri Y'#252'klensin)'
      Style = cxStyleBold8Red
      Visible = ivAlways
      ButtonStyle = bsChecked
      CloseSubMenuOnClick = False
    end
    object OnCalcTestItem: TdxBarButton
      Caption = 'OnCalc Test'
      Category = 0
      Hint = 'OnCalc Test'
      Visible = ivAlways
      OnClick = OnCalcTestItemClick
    end
    object TESTBtn: TdxBarButton
      Caption = 'TEST'
      Category = 0
      Hint = 'TEST'
      Style = cxStyleBold8Black
      Visible = ivAlways
      OnClick = TESTBtnClick
    end
  end
  object cxStyleRepository: TcxStyleRepository
    Left = 280
    Top = 40
    PixelsPerInch = 96
    object cxStyleBold8Maroon: TcxStyle
      AssignedValues = [svFont, svTextColor]
      Font.Charset = TURKISH_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      TextColor = clMaroon
    end
    object cxStyleBold8Navy: TcxStyle
      AssignedValues = [svFont, svTextColor]
      Font.Charset = TURKISH_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      TextColor = clNavy
    end
    object cxStyleBold8Purple: TcxStyle
      AssignedValues = [svFont, svTextColor]
      Font.Charset = TURKISH_CHARSET
      Font.Color = clPurple
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      TextColor = clPurple
    end
    object cxStyleBold8Black: TcxStyle
      AssignedValues = [svFont, svTextColor]
      Font.Charset = TURKISH_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      TextColor = clBlack
    end
    object cxStyleImageSeparator: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 13602864
      Font.Charset = TURKISH_CHARSET
      Font.Color = 14722420
      Font.Height = -1
      Font.Name = 'Tahoma'
      Font.Style = []
      TextColor = 14722420
    end
    object cxStyleBold8Red: TcxStyle
      AssignedValues = [svFont, svTextColor]
      Font.Charset = TURKISH_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      TextColor = clRed
    end
    object cxStyleBarMemoEdit: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 16247513
      Font.Charset = TURKISH_CHARSET
      Font.Color = clMaroon
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      TextColor = clMaroon
    end
    object cxStyleSeperator: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 14722420
      Font.Charset = TURKISH_CHARSET
      Font.Color = 14722420
      Font.Height = -1
      Font.Name = 'Tahoma'
      Font.Style = []
      TextColor = 14722420
    end
  end
  object ProgramciTimer: TTimer
    Enabled = False
    Interval = 333
    OnTimer = ProgramciTimerTimer
    Left = 320
    Top = 40
  end
end
