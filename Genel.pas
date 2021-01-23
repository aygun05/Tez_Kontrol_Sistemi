unit Genel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  M_Consts,
  M_Strings,
  M_F_Forms_Main,
  M_F_Forms_cxGridMain,
  M_cxGrid,
  M_Databases,
  M_F_Databases,
  cxDropDownEdit, cxColorComboBox, cxCheckGroup, DB, Uni, Dialogs, ImgList,
  Math, cxGraphics, cxClasses, StrUtils, MemDS, VirtualTable, DBAccess, dxBar,
  cxFontNameComboBox, cxGridDBBandedTableView, cxButtonEdit;

type
  TGenelForm = class(TForm)
    MainSQLLogVirtualTable: TVirtualTable;
    UserColumns: TVirtualTable;
    UserForeignTables: TVirtualTable;
    UserForeignTableColumns: TVirtualTable;
    UserTables: TVirtualTable;
    UserMenu: TVirtualTable;
    UserMenuTablo: TVirtualTable;
    UserTableExecSQLs: TVirtualTable;
    UserAllObjects: TVirtualTable;
    cxLargeImagesForButtons: TcxImageList;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
  public
    UserTableInformationsList: TStringList;
    procedure LoadProgrammersUserDataAndSet;
    procedure MainUserMenuItemClick(Sender: TObject);
  end;

var
  GenelForm: TGenelForm;

  InValidDatabaseObjectNameCharacters : string = '."''[]{}@=*/%&^$#+\|<>:;,';

function GetAndSetTable(const aTableName: string; const aExtraID: string; const aFilterSQL: string; const aReadOnly: Boolean; const aLookupExtraIDFieldNames: array of string; const aLookupExtraIDs: array of string; aNotLookupFieldNames: string; const aUseCalcFields: Boolean; const aLookupTable: Boolean): TUniQueryEx; overload;
function GetAndSetTable(const aTableName: string; const aExtraID: string; const aFilterSQL: string = ''; const aReadOnly: Boolean = FALSE; const aNotLookupFieldNames: string = ''; const aUseCalcFields: Boolean = FALSE; const aLookupTable: Boolean = FALSE): TUniQueryEx; overload;
function GetAndSetTable(const aTableName: string; const aExtraIDSender: TObject; const aFilterSQL: string; const aReadOnly: Boolean; const aLookupExtraIDFieldNames: array of string; const aLookupExtraIDs: array of string; const aNotLookupFieldNames: string; const aUseCalcFields: Boolean; const aLookupTable: Boolean; const aMoreExtraID: string = ''): TUniQueryEx; overload;
function GetAndSetTable(const aTableName: string; const aExtraIDSender: TObject; const aFilterSQL: string = ''; const aReadOnly: Boolean = FALSE; const aNotLookupFieldNames: string = ''; const aUseCalcFields: Boolean = FALSE; const aLookupTable: Boolean = FALSE; const aMoreExtraID: string = ''): TUniQueryEx; overload;

function Veri(const aSender: TObject; const aTableName: string; const aExtraIDSender: TObject = nil; const aTableReadOnly: Boolean = FALSE; const aExtraMainFormID: string = ''): TForms_MainForm;
function VeriMasterDetay(const aSender: TObject; const aMasterTableName, aDetailTableName, aMasterFieldNames, aDetailFieldNames: string; const aMasterExtraIDSender: TObject; const aDetailExtraIDSender: TObject; const aMasterTableReadOnly: Boolean = FALSE; const aDetailTableReadOnly: Boolean = FALSE; const aExtraMainFormID: string = ''): TForms_MainForm;

function MainConnectionControlFunction(aConnection: TUniConnection): Boolean;

function ExpandTablesForGroupsInSQLScript(const aSQLText: string): string;

implementation

{$R *.dfm}

uses
  M_Messages,
  M_Files,
  M_Maths,
  M_KeyBoards,
  M_F_FormUtilities,
  M_Applications,
  M_INIFiles,
  M_DateTimes,
  M_StartupInfos,
  M_DatabasesMetaData,
  M_F_Progress,
  M_F_Selections,
  M_F_Calculator,
  M_DevExpress,
  M_F_Forms_PageControl,
  M_F_OleContainer,
  M_F_Languages,
  M_F_TextRichEditor,
  M_Windows,
  M_F_SelectFromSourceTargetcxGrid,
  M_F_Forms_Vertical_Horizontal,
  M_F_SelectFromSourceTargetDataSet,
  M_F_TabloIslemleri,
  M_StringLists,
  M_Compression,
  ProgrammerData,
  SQLCommands,
  Events;

function ExpandTablesForGroupsInSQLScript(const aSQLText: string): string;
begin
  ///////
  Result := MyAnsiReplaceStr(MyAnsiReplaceStr(aSQLText, '[[', ''), ']]', '');








end;

procedure MyGetKullaniciTabloErisimVsInformationProc(const aTableOrViewName: string; const aConnection: TUniConnection; const aDatabaseName: string; var Erisim, IlaveEt, Degistir, Sil: Boolean; var TabloFiltresi: string; aNotErisimList, aNotDegistirList: TStringList);
var
  aUserID: string;
  aCurrentDatabase, aVeriGiris: Boolean;

begin
  //Kullanıcı            => Kullanıcı, Aktif, Yönetici, Tablo Erişim, Veri Giriş, Database English, Kullanıcı ID
  //Kullanıcı Tablo      => Kullanıcı ID, Tablo Adı, Sanal, Erişim, İlave Et, Değiştir, Sil, Tablo Filtresi, Açıklama, Tablo Filtre Değeri
  //Kullanıcı Tablo Alan => Kullanıcı ID, Tablo Adı, Sıra No, Alan Adı, Erişim, Değiştir

  Erisim        := TRUE;
  IlaveEt       := TRUE;
  Degistir      := TRUE;
  Sil           := TRUE;
  TabloFiltresi := '';

  if not Assigned(aConnection) then Exit;

  aCurrentDatabase := FALSE;

  if Assigned(MainConnection) then aCurrentDatabase := MainConnection.Database = MyCoalesce([aDatabaseName, aConnection.Database]);

  if not ShiftAndCtrlKeysAreBeingPressed and TheProgrammersComputer then Exit;

  if Assigned(aNotErisimList)   then aNotErisimList.Clear;
  if Assigned(aNotDegistirList) then aNotDegistirList.Clear;

  aVeriGiris := TRUE;

  with TUniQuery.Create(nil) do
  try
    Connection     := aConnection;
    UniDirectional := FALSE;
    SQL.Text       := 'SELECT * FROM ' + GetFullTableName('Kullanıcı', ApplicationSchemaName, aDatabaseName, aConnection) + ' WHERE "Kullanıcı" = SYSTEM_USER';

    try
      Active := TRUE;
    except
      Exit;
    end;

    try
      aUserID := FindField('Kullanıcı ID').AsString;

      if aUserID = '' then Exit;

      if FindField('Yönetici').AsBoolean then Exit;

      if RightStr(aTableOrViewName, 4) = ' LOG' then
      begin
        Erisim := FALSE;
        Exit;
      end;

      if not aCurrentDatabase then
      begin
        Erisim := FindField('Tablo Erişim').AsBoolean;

        if not Erisim then Exit;

        aVeriGiris := FindField('Veri Giriş').AsBoolean;

        IlaveEt    := aVeriGiris;
        Degistir   := aVeriGiris;
        Sil        := aVeriGiris;
      end;

      Active   := FALSE;
      SQL.Text := 'SELECT * FROM ' + GetFullTableName('Kullanıcı Tablo', ApplicationSchemaName, aDatabaseName, aConnection) + ' WHERE "Kullanıcı ID" = ' + aUserID + ' AND "Tablo Adı" = ''' + aTableOrViewName + '''';
      Active   := TRUE;

      if FindField('Kullanıcı ID').AsString = '' then Exit;

      Erisim := FindField('Erişim').AsBoolean;

      if not Erisim then Exit;

      IlaveEt       := aVeriGiris and FindField('İlave Et').AsBoolean;
      Degistir      := aVeriGiris and FindField('Değiştir').AsBoolean;
      Sil           := aVeriGiris and FindField('Sil').AsBoolean;
      TabloFiltresi := Trim(FindField('Tablo Filtresi').AsString);

      if not Assigned(aNotErisimList) and not Assigned(aNotDegistirList) then Exit;

      Active   := FALSE;
      SQL.Text := 'SELECT * FROM ' + GetFullTableName('Kullanıcı Tablo Alan', ApplicationSchemaName, aDatabaseName, aConnection) + ' "Kullanıcı ID" = ' + aUserID + ' AND "Tablo Adı" = ''' + aTableOrViewName + ''' AND ("Erişim" = ''FALSE'' OR "Değiştir" = ''FALSE'')';
      Active   := TRUE;

      while not Eof do
      begin
        if Assigned(aNotErisimList) then
          if not FindField('Erişim').AsBoolean   then aNotErisimList.Add(FindField('Alan Adı').AsString);

        if Assigned(aNotDegistirList) then
          if not FindField('Değiştir').AsBoolean then aNotDegistirList.Add(FindField('Alan Adı').AsString);

        Next;
      end;
    except
      on Ex : Exception do
      begin
        Me_X('procedure MyGetKullaniciTabloErisimVsInformationProc...' + LB + 'Hata mesajı:' + LB + ExceptionMessage(Ex) + LB2 + 'SQL:' + SQL.Text);

        if TheProgrammersComputer then
        begin
          Erisim        := TRUE;
          IlaveEt       := TRUE;
          Degistir      := TRUE;
          Sil           := TRUE;
          TabloFiltresi := '';
        end;
      end;
    end;
  finally
    Free;
  end;
end;

procedure MyAssignCalculatedFieldsToDataSetProc(aResultUniQueryEx: TUniQueryEx; const aTableName, aSchemaName, aDatabaseName: string);
var
  I, J, K: Integer;
  St1, St2, aZeroOrFalseStr: string;
  aMonthFields: array [0..12 - 1] of TField;
  aAllAssigned, aEnglishChars: Boolean;
begin
  if not Assigned(aResultUniQueryEx) then Exit;
  if not Assigned(GenelForm) then MeAbort('Yazılım hatası!!!' + LB2 + 'if not Assigned(GenelForm) then... procedure MyAssignCalculatedFieldsToDataSetProc(aResultUniQueryEx: TUniQueryEx; const aTableName, aSchemaName, aDatabaseName: string);...');

  //if aSchemaName <> ApplicationSchemaName then Exit;

  I := -1;
  repeat
    Inc(I);
    if I >= aResultUniQueryEx.FieldCount then Break;

    if (aResultUniQueryEx.Fields[I] is TNumericField) or (aResultUniQueryEx.Fields[I] is TBooleanField) then
    begin
      St1 := RightStr(aResultUniQueryEx.Fields[I].FieldName, 4);

      if (St1 = MyMonthNames[0]) or (St1 = MyMonthNamesTRENG[0]) then
      begin
        aAllAssigned  := TRUE;
        aEnglishChars := St1 = MyMonthNamesTRENG[0];

        if aResultUniQueryEx.Fields[I] is TBooleanField then
          aZeroOrFalseStr := 'Hayır'
        else
          aZeroOrFalseStr := 'Sıfır';

        St1 := DeleteFromRight(aResultUniQueryEx.Fields[I].FieldName, 4);

        for J := 1 to 12 - 1 do
        begin
          if aEnglishChars then
            St2 := St1 + MyMonthNamesTRENG[J]
          else
            St2 := St1 + MyMonthNames[J];

          aMonthFields[J] := aResultUniQueryEx.FindField(St2);

          if not Assigned(aMonthFields[J]) then
          begin
            aAllAssigned := FALSE;
            Break;
          end;

          if (aMonthFields[J].FieldName <> St2) or (aMonthFields[J].DataType <> aResultUniQueryEx.Fields[I].DataType) then
          begin
            aAllAssigned := FALSE;
            Break;
          end;
        end;

        if aAllAssigned then
        begin
          if Assigned(aResultUniQueryEx.FindField(St1 + 'Toplam'))       and
             Assigned(aResultUniQueryEx.FindField(St1 + 'Ortalama'))     and
             Assigned(aResultUniQueryEx.FindField(St1 + aZeroOrFalseStr)) then Continue;

          aMonthFields[0] := aResultUniQueryEx.Fields[I];

          K := Length(aResultUniQueryEx.MonthCalcFieldsInfos);
          SetLength(aResultUniQueryEx.MonthCalcFieldsInfos, K + 1);

          aResultUniQueryEx.MonthCalcFieldsInfos[K].MonthCalcSUMField  := nil;
          aResultUniQueryEx.MonthCalcFieldsInfos[K].MonthCalcAVGField  := nil;
          aResultUniQueryEx.MonthCalcFieldsInfos[K].MonthCalcZeroField := nil;

          for J := 0 to 12 - 1 do aResultUniQueryEx.MonthCalcFieldsInfos[K].MonthFields[J] := aMonthFields[J];

          if not Assigned(aResultUniQueryEx.FindField(St1 + aZeroOrFalseStr)) then
          begin
            aResultUniQueryEx.MonthCalcFieldsInfos[K].MonthCalcZeroField := AddCalculatedFieldToDataSet(aResultUniQueryEx, St1 + aZeroOrFalseStr, ftInteger, 0, FALSE, aMonthFields[12 - 1].Index + 1);
            TNumericField(aResultUniQueryEx.MonthCalcFieldsInfos[K].MonthCalcZeroField).DisplayFormat := '#,##0';
          end;

          if IsFloatField(aMonthFields[0]) then
          begin
            if not Assigned(aResultUniQueryEx.FindField(St1 + 'Ortalama')) then
            begin
              aResultUniQueryEx.MonthCalcFieldsInfos[K].MonthCalcAVGField := AddCalculatedFieldToDataSet(aResultUniQueryEx, St1 + 'Ortalama', aMonthFields[0].DataType, 0, FALSE, aMonthFields[12 - 1].Index + 1);
              TNumericField(aResultUniQueryEx.MonthCalcFieldsInfos[K].MonthCalcAVGField).DisplayFormat := MyCoalesce([TNumericField(aMonthFields[0]).DisplayFormat, '#,##0.00']);
            end;

            if not Assigned(aResultUniQueryEx.FindField(St1 + 'Toplam')) then
            begin
              aResultUniQueryEx.MonthCalcFieldsInfos[K].MonthCalcSUMField := AddCalculatedFieldToDataSet(aResultUniQueryEx, St1 + 'Toplam', aMonthFields[0].DataType, 0, FALSE, aMonthFields[12 - 1].Index + 1);
              TNumericField(aResultUniQueryEx.MonthCalcFieldsInfos[K].MonthCalcSUMField).DisplayFormat := TNumericField(aMonthFields[0]).DisplayFormat;
            end;
          end;

          I := aMonthFields[0].Index;
        end;
      end;
    end;
  until 1 = 2;
end;

procedure MyBeforeCreateFieldsFromDataSetToDataSetProc(var FilterSQL, AliasT1: string; aUniQuery: TUniQuery; aResultUniQueryEx: TUniQueryEx; const aTableName, aSchemaName, aDatabaseName: string);
var
  I, K: Integer;
  aOriginFieldName, aFiltreSQL, aControlTableName: string;
  aTableOrViewDefined, aLogTable, aYetkiVar, aView: Boolean;
  aDisplayFormat: string;
  aErisim, aIlaveEt, aDegistir, aSil: Boolean;
  aTabloFiltresi: string;
  aNotErisimList, aNotDegistirList: TStringList;
begin
  //UserTables     => Sıra No, Grup, Table Name, Logging, Veri Girişi, Bands, Display Key, View Tables, Erişim, Is View, Has Group
  //UserAllObjects => Object Name, English

  if not Assigned(aUniQuery) then Exit;
  if not Assigned(aResultUniQueryEx) then Exit;
  if not Assigned(GenelForm) then MeAbort('Yazılım hatası!!!' + LB2 + 'if not Assigned(GenelForm) then... procedure MyBeforeCreateFieldsFromDataSetToDataSetProc(var FilterSQL: string; aUniQuery: TUniQuery; aResultUniQueryEx: TUniQueryEx; const aTableName, aSchemaName, aDatabaseName: string);...');

  aNotErisimList   := TStringList.Create;
  aNotDegistirList := TStringList.Create;
  try
    MyGetKullaniciTabloErisimVsInformationProc(aTableName, aUniQuery.Connection, aDatabaseName, aErisim, aIlaveEt, aDegistir, aSil, aTabloFiltresi, aNotErisimList, aNotDegistirList);

    if not aErisim then raise Exception.Create(Lang('"' + aTableName + '" tablosuna erişim yetkiniz yok.', 'You don''t have authority to access to the table "' + aTableName + '".'));

    aResultUniQueryEx.Inserting := aIlaveEt;
    aResultUniQueryEx.Updating  := aDegistir;
    aResultUniQueryEx.Deleting  := aSil;

    if aSchemaName <> ApplicationSchemaName then Exit;

    if (aNotErisimList.Count > 0) or (aNotDegistirList.Count > 0) then
    begin
      K := 0;
      for I := 0 to aUniQuery.FieldCount - 1 do
      begin
        if IndexOfBySensitive(aNotErisimList,   aUniQuery.Fields[I].FieldName) > -1 then aUniQuery.Fields[I].Visible  := FALSE;
        if IndexOfBySensitive(aNotDegistirList, aUniQuery.Fields[I].FieldName) > -1 then aUniQuery.Fields[I].ReadOnly := TRUE;

        if aUniQuery.Fields[I].Visible then Inc(K);
      end;

      if K = 0 then raise Exception.Create(Lang('"' + aTableName + '" tablosuna erişim yetkiniz yok.', 'You don''t have authority to access to the table "' + aTableName + '".'));
    end;

    if aTabloFiltresi <> '' then
      if FilterSQL <> '' then
        FilterSQL := '(' + FilterSQL + ') AND (' + aTabloFiltresi + ')'
      else
        FilterSQL := aTabloFiltresi;

    if RightStr(aTableName, 4) = ' LOG' then
    begin
      aLogTable         := TRUE;
      aControlTableName := DeleteFromRight(aTableName, 4);
    end
    else
    begin
      aLogTable         := FALSE;
      aControlTableName := aTableName;
    end;

    aView               := FALSE;
    aTableOrViewDefined := FALSE;

    ClearDataSetFilter(GenelForm.UserTables);

    if GenelForm.UserTables.LocateEx('Table Name', VarArrayOf([aControlTableName]), []) then
      if GenelForm.UserTables.FindField('Table Name').AsString = aControlTableName then
      begin
        aView               := GenelForm.UserTables.FindField('Is View').AsBoolean;
        aTableOrViewDefined := TRUE;
      end;

    aYetkiVar := Assigned(aUniQuery.FindField('Yetki ID'));

    if aLogTable and aTableOrViewDefined then
      if not GenelForm.UserTables.FindField('Logging').AsBoolean then Exit;

    for I := 0 to aUniQuery.FieldCount - 1 do
    begin
      //UserAllObjects => Object Name, English

      if English or CurrentUser.DatabaseEnglish then
      begin
        SetDataSetFilter(GenelForm.UserAllObjects, '[Object Name] = ''' + aUniQuery.Fields[I].FieldName + '''');
        if GenelForm.UserAllObjects.RecordCount > 0 then aUniQuery.Fields[I].DisplayLabel := MyCoalesce([GenelForm.UserAllObjects.FindField('English').AsString, aUniQuery.Fields[I].DisplayLabel, aUniQuery.Fields[I].FieldName]);
      end;

      if aTableOrViewDefined and (aUniQuery.Fields[I] is TNumericField) then
      begin
        aOriginFieldName := GetOriginFieldName(aUniQuery.Fields[I]);

        if aOriginFieldName = '' then Continue;

        if not aView then
          SetDataSetFilter(GenelForm.UserColumns, '[Table Name] = ''' + aControlTableName + ''' AND [Column Name] = ''' + aOriginFieldName + ''' AND [Display Format] IS NOT NULL')
        else
          if (GenelForm.UserTables.FindField('View Tables').AsString = '') or not IsFloatAndNotCurrencyField(aUniQuery.Fields[I]) then
            Continue
          else
            SetDataSetFilter(GenelForm.UserColumns, '(' + SetAndGetFieldNames(GenelForm.UserTables.FindField('View Tables').AsString, ' OR ', '[Table Name] = ''', '''') + ') AND [Column Name] = ''' + aOriginFieldName + ''' AND [Display Format] IS NOT NULL');

        if GenelForm.UserColumns.RecordCount = 0 then Continue;

        aDisplayFormat := GenelForm.UserColumns.FindField('Display Format').AsString;

        if aView then
          if GenelForm.UserColumns.RecordCount > 1 then
          begin
            GenelForm.UserColumns.Next;
            while not GenelForm.UserColumns.Eof do
            begin
              if GenelForm.UserColumns.FindField('Display Format').AsString <> aDisplayFormat then
              begin
                aDisplayFormat := '';
                Break;
              end;

              GenelForm.UserColumns.Next;
            end;
          end;

        if aDisplayFormat <> '' then
        begin
          TNumericField(aUniQuery.Fields[I]).DisplayFormat := aDisplayFormat;
          TNumericField(aUniQuery.Fields[I]).EditFormat    := StandartNumericEditFormat;
        end;
      end;
    end;

    if aView then
    begin
      aDisplayFormat := '';

      for I := 0 to aUniQuery.FieldCount - 1 do
        if IsFloatAndNotCurrencyField(aUniQuery.Fields[I]) then
          with TNumericField(aUniQuery.Fields[I]) do
            if DisplayFormat <> '' then
              if (aDisplayFormat <> '') and (aDisplayFormat <> DisplayFormat) then
              begin
                aDisplayFormat := '';
                Break;
              end
              else
                aDisplayFormat := DisplayFormat;

      if aDisplayFormat <> '' then
        for I := 0 to aUniQuery.FieldCount - 1 do
          if IsFloatAndNotCurrencyField(aUniQuery.Fields[I]) then
            with TNumericField(aUniQuery.Fields[I]) do
              if DisplayFormat = '' then DisplayFormat := aDisplayFormat;
    end;

    for I := 0 to aUniQuery.FieldCount - 1 do
      if IsFloatAndNotCurrencyField(aUniQuery.Fields[I]) then
        with TNumericField(aUniQuery.Fields[I]) do
        begin
          if DisplayFormat = '' then DisplayFormat := StandartNumericDisplayFormat;
          if EditFormat    = '' then EditFormat    := StandartNumericEditFormat;
        end;

    if not CurrentUser.Administrator then
    begin
      if aYetkiVar then
      begin
        //Yetki           => Yetki, Erişim, İlave Et, Değiştir, Sil, Yetki ID
        //Yetki Kullanıcı => Yetki ID, Kullanıcı, İlave Et, Değiştir, Sil

        aFiltreSQL := '';
        AliasT1    := '';

        if (System.Pos('SELECT T1.* FROM ', aUniQuery.FinalSQL) = 1) or (System.Pos('SELECT' + LB + '  T1.*,', aUniQuery.FinalSQL) = 1) then AliasT1 := 'T1.';

        if aControlTableName = 'Yetki Kullanıcı' then
          if Assigned(aUniQuery.FindField('Kullanıcı')) then
            aFiltreSQL := AliasT1 + '"Kullanıcı" = SYSTEM_USER'
          else
        else
          if aControlTableName = 'Yetki' then
            aFiltreSQL := AliasT1 + '"Yetki ID" IN (SELECT "Yetki ID" FROM ' + IfThen(aDatabaseName <> '', '"' + aDatabaseName + '".', '') + '"' + ApplicationSchemaName + '"."Yetki Kullanıcı" WHERE "Kullanıcı" = SYSTEM_USER UNION SELECT "Yetki ID" FROM ' + IfThen(aDatabaseName <> '', '"' + aDatabaseName + '".', '') + '"' + ApplicationSchemaName + '"."Yetki" WHERE "Erişim" = ''TRUE'')'
          else
            aFiltreSQL := AliasT1 + '"Yetki ID" IS NULL OR ' + AliasT1 + '"Yetki ID" IN (SELECT "Yetki ID" FROM ' + IfThen(aDatabaseName <> '', '"' + aDatabaseName + '".', '') + '"' + ApplicationSchemaName + '"."Yetki Kullanıcı" WHERE "Kullanıcı" = SYSTEM_USER UNION SELECT "Yetki ID" FROM ' + IfThen(aDatabaseName <> '', '"' + aDatabaseName + '".', '') + '"' + ApplicationSchemaName + '"."Yetki" WHERE "Erişim" = ''TRUE'')';

        if aFiltreSQL <> '' then
          if FilterSQL <> '' then
            FilterSQL := '(' + FilterSQL + ') AND (' + aFiltreSQL + ')'
          else
            FilterSQL := aFiltreSQL;
      end;

      if aTableOrViewDefined then
        if GenelForm.UserTables.FindField('Erişim').AsString = 'Admin' then aUniQuery.ReadOnly := TRUE;
    end;

    if (aTableOrViewDefined and StringIN(GenelForm.UserTables.FindField('Erişim').AsString, ['Hiçkimse', 'Read Only'])) or aLogTable then aUniQuery.ReadOnly := TRUE;
  finally
    aNotErisimList.Free;
    aNotDegistirList.Free;
  end;

end;

function MainConnectionControlFunction(aConnection: TUniConnection): Boolean;
var
  I: Integer;
  aSQLText, aUserName: string;
begin
  //Kullanıcı  => Kullanıcı, Aktif, Yönetici, Tablo Erişim, Veri Giriş, Database English, Kullanıcı ID
  //UserTables => Sıra No, Grup, Table Name, Logging, Veri Girişi, Bands, Display Key, View Tables, Erişim, Is View, Has Group

  Result := FALSE;

  if not Assigned(aConnection) then Exit;

  if not Assigned(GenelForm) then MeAbort('Yazılım hatası!!!' + LB2 + 'if not Assigned(GenelForm) then... function MainConnectionControlFunction(aConnection: TUniConnection): Boolean;...');

  AddToMessageLog(Lang('Bağlantı', 'Connection'), 'MainConnectionControlFunction begin');

  aSQLText  := '';
  aUserName := aConnection.Username;

  try
    SetScreenCursor(crHourGlass);
    try
      if aUserName = '' then aUserName := VarToStr(GetFirstFieldValueOfSQLText('SELECT SYSTEM_USER', []));

      if TheProgrammersComputer then
        if not QueryReturnsRecord('SELECT 1 AS KOD FROM "' + ApplicationSchemaName + '"."Kullanıcı" WHERE "Kullanıcı" = SYSTEM_USER', aConnection) then ExecSQLTry('INSERT INTO "' + ApplicationSchemaName + '"."Kullanıcı" ("Kullanıcı", "Kullanıcı Tanımı", "Yönetici") VALUES (SYSTEM_USER, SYSTEM_USER, ''TRUE'')', '', aConnection);

      with TUniQuery.Create(nil) do
      try
        Connection         := aConnection;
        UniDirectional     := TRUE;
        aSQLText           := 'SELECT * FROM "' + ApplicationSchemaName + '"."Kullanıcı" WHERE "Kullanıcı" = :UserName';
        SQL.Text           := aSQLText;
        Params[0].DataType := ftString;
        Params[0].AsString := aUserName;
        Active             := TRUE;

        if not FindField('Aktif').AsBoolean or (FindField('Kullanıcı').AsString = '') or (FindField('Kullanıcı').AsString <> aUserName) then
        begin
          Me(Lang('"' + aUserName + '" kullanıcısının bu veritabanına girme yetkisi yok.', 'The user "' + aUserName + '" has no authority for this database.'));
          Exit;
        end;

        AddToMessageLog(Lang('Bağlantı', 'Connection'), 'Kullanıcı yetkisi kontrol edildi');

        CurrentUser.Administrator   := FindField('Yönetici').AsBoolean or TheProgrammersComputer;

        CurrentUser.Name            := aUserName;
        CurrentUser.Password        := aConnection.Password;

        CurrentUser.UserID          := FindField('Kullanıcı ID').AsString;
        CurrentUser.DatabaseEnglish := FindField('Database English').AsBoolean;

        Active   := FALSE;
        aSQLText := 'SELECT * FROM "' + ApplicationSchemaName + '"."Main Setup"';
        SQL.Text := aSQLText;
        Active   := TRUE;

        if RecordCount = 0 then raise Exception.Create(Lang('"' + ApplicationSchemaName + '"."Main Setup" tablosunda hiç kayıt yok.', 'No record in "' + ApplicationSchemaName + '"."Main Setup" table.'));
        if RecordCount > 1 then raise Exception.Create(Lang('"' + ApplicationSchemaName + '"."Main Setup" tablosunda birden fazla kayıt var.', 'More than one record in "' + ApplicationSchemaName + '"."Main Setup" table.'));

        CurrentUser.DatabaseLogging := FindField('Logging').AsBoolean;

        Result := TRUE;
      finally
        Free;
      end;
    except
      on Ex : Exception do Me(Lang('Veritabanı bu program için uygun değil.', 'Selected database is not valid for this application.') + LB2 + Lang('Hata mesajı:', 'Error Message:') + LB + ExceptionMessage(Ex) + IfThen(TheProgrammersComputer and (aSQLText <> ''), LB2 + 'SQL:' + aSQLText, ''));
    end;
  finally
    try
      //if not Result and TheProgrammersComputer then
      if not Result then
        if Mc(Lang('Yine de devam edeyim mi?', 'Continue anyway?')) = mrYes then
        begin
          CurrentUser.Name               := aUserName;
          CurrentUser.Password           := aConnection.Password;
          CurrentUser.UserID             := '';
          CurrentUser.Administrator      := TRUE;
          CurrentUser.DatabaseEnglish    := FALSE;
          CurrentUser.DatabaseLogging    := FALSE;

          Result := TRUE;
        end;
      if Result then
      begin
        SetScreenCursor(crHourGlass);

        SetdxBarItemVisibleByBoolean(MainFormUtilitiesForm.SQLSubItem, CurrentUser.Administrator);

        TabloIslemleriForm.KullanilacakBaglantiRadioGroupItem.EditValue := '0';

        SetdxBarItemVisibleByBoolean(TabloIslemleriForm.SQLSubItem,      CurrentUser.Administrator);
        SetdxBarItemVisibleByBoolean(TabloIslemleriForm.SQLCalistirItem, CurrentUser.Administrator);

        for I := 0 to MainFormUtilitiesForm.ImageSeperatorEditItem.LinkCount - 1 do MainFormUtilitiesForm.ImageSeperatorEditItem.Links[I].Visible := TRUE;
        for I := 0 to TabloIslemleriForm.ImageSeperatorEditItem.LinkCount    - 1 do TabloIslemleriForm.ImageSeperatorEditItem.Links[I].Visible    := TRUE;

        HideRepeatingItems(TabloIslemleriForm.TabloAcSubItem, TabloIslemleriForm.ImageSeperatorEditItem);
        HideRepeatingItems(TabloIslemleriForm.SQLSubItem,     TabloIslemleriForm.ImageSeperatorEditItem);

        HideRepeatingItems(MainFormUtilitiesForm.PencereSubItem, MainFormUtilitiesForm.ImageSeperatorEditItem);
        HideRepeatingItems(MainFormUtilitiesForm.GenelSubItem,   MainFormUtilitiesForm.ImageSeperatorEditItem);

        for I := 0 to Screen.FormCount - 1 do
          if Screen.Forms[I] is TForms_cxGridMainForm then TForms_cxGridMainForm(Screen.Forms[I]).GenelSubItem.ItemLinks := MainFormUtilitiesForm.GenelSubItem.ItemLinks;
      end;

      AddToMessageLog(Lang('Bağlantı', 'Connection'), 'MainConnectionControlFunction end');
    finally
      SetScreenCursor(crDefault);
    end;
  end;
end;

function GetAndSetTable(const aTableName: string; const aExtraID: string; const aFilterSQL: string; const aReadOnly: Boolean; const aLookupExtraIDFieldNames: array of string; const aLookupExtraIDs: array of string; aNotLookupFieldNames: string; const aUseCalcFields: Boolean; const aLookupTable: Boolean): TUniQueryEx;
var
  I, J, K, M: Integer;
  St1, St2, aSQLText: string;
  aField: TField;
  aLookupTableCount: Integer;
  aLookupUniQueryEx: TUniQueryEx;
  aForeignCalcUniQueryEx: TUniQueryEx;
  aList1, aList2, aList3: TStringList;
  aLookupExtraID: string;
  aColumnName: string;
  aFound, aView, aLookup, aLookupTableAndUseGroup: Boolean;
  aLookupTableName, aLookupKeyFieldName, aLookupListFieldName, aLookupFilterSQL,
  aLookupTableDisplayName, aLookupTableDisplayNameEnglish: string;
  aLookupReadOnly, aLookupEditableList, aSystemForeignTable: Boolean;
  aFieldLookupInfos: array [0..1000 - 1] of TFieldLookupInfoRecord;
  aTableInformations: array of TTableInformationRec;
  aFieldProperties: Boolean;
  aFieldPropertiesCount: Integer;
  aFieldPropertiesInfos: array [0..1000 - 1] of TFieldPropertiesInfoRecord;
  aLookupFilterMasterFields, aLookupFilterDetailFields, aLookupColumnDisplayLabel: string;
  aErisim, aIlaveEtDegistirSil: Boolean;
  aTabloFiltresi: string;
begin
  //UserTables              => Sıra No, Grup, Table Name, Logging, Veri Girişi, Bands, Display Key, View Tables, Erişim, Is View, Has Group
  //UserColumns             => Table Name, Sıra No, Column Name, Data Type or Compute Text, Size, Required, Primary Key, Unique Column, Properties Class, Properties Info, Band Index, Display Format, Klon İçin, Default
  //UserForeignTables       => Table Name, Sıra No, Foreign Table Name, On Delete Cascade, Foreign Calc Fields, Calc Fields Pre Columns, Calc Fields New Names, Klon İçin, By Trigger
  //UserForeignTableColumns => Table Name, Sıra No, Foreign Table Name, Column Sıra No, Column Name, Foreign Table Column, Lookup, Lookup List Field Name, Lookup Table Name, Lookup Key Field Name, Lookup Filter SQL, Lookup Filter MasterFields, Lookup Filter DetailFields, Lookup Column Name
  //UserAllObjects          => Object Name, English

  aView                   := FALSE;
  aFound                  := FALSE;
  aLookupTableAndUseGroup := FALSE;

  ClearDataSetFilter(GenelForm.UserTables);

  if GenelForm.UserTables.LocateEx('Table Name', VarArrayOf([aTableName]), []) then
    if GenelForm.UserTables.FindField('Table Name').AsString = aTableName then
    begin
      aView                   := GenelForm.UserTables.FindField('Is View').AsBoolean;;
      aFound                  := TRUE;
      aLookupTableAndUseGroup := aLookupTable and GenelForm.UserTables.FindField('Has Group').AsBoolean;
    end;

  if not aFound then
  begin
    Result := GetTable(aTableName, aTableName, aFilterSQL, aReadOnly, '', FALSE, FALSE, ApplicationSchemaName, nil, '', FALSE, aExtraID);
    Exit;
  end;

  aLookupTableCount     := 0;
  aFieldPropertiesCount := 0;
  aNotLookupFieldNames  := ';' + SetAndGetFieldNames(RemoveCharsFromText(aNotLookupFieldNames, '"[]')) + ';';

  aList1 := TStringList.Create;
  aList2 := TStringList.Create;
  aList3 := TStringList.Create;
  try
    aList1.Clear;

    if aView then
      aList1.Text := SetAndGetFieldNames(GenelForm.UserTables.FindField('View Tables').AsString, LB)
    else
      if aUseCalcFields then
      begin
        SetDataSetFilter(GenelForm.UserForeignTables, '[Table Name] = ''' + aTableName + ''' AND [Foreign Calc Fields] IS NOT NULL');

        while not GenelForm.UserForeignTables.Eof do
        begin
          St1 := GenelForm.UserForeignTables.FindField('Foreign Table Name').AsString;

          if IndexOfBySensitive(aList1, St1) < 0 then aList1.Add(St1);

          GenelForm.UserForeignTables.Next;
        end;

        GenelForm.UserForeignTables.First;
      end;

    if aLookupTableAndUseGroup then
      if aList1.IndexOf(aTableName) < 0 then aList1.Insert(0, aTableName);

    SetLength(aTableInformations, aList1.Count + 1);
    aTableInformations[0] := GetTableInformation(aTableName + IfThen(aLookupTableAndUseGroup, ' Grup Veri', ''), ApplicationSchemaName, '');
    for I := 0 to aList1.Count - 1 do aTableInformations[I + 1] := GetTableInformation(aList1[I], ApplicationSchemaName, '');

    if aView or not aUseCalcFields or (GenelForm.UserForeignTables.RecordCount = 0) then
      aSQLText := 'SELECT T1.* FROM ' + GetFullTableName(aTableName + IfThen(aLookupTableAndUseGroup, ' Grup Veri', ''), ApplicationSchemaName, '', MainConnection) + ' T1'
    else
    begin
      aSQLText := 'SELECT'  + LB +
                  '  T1.*,';

      //UserForeignTables       => Table Name, Sıra No, Foreign Table Name, On Delete Cascade, Foreign Calc Fields, Calc Fields Pre Columns, Calc Fields New Names, Klon İçin, By Trigger
      //UserForeignTableColumns => Table Name, Sıra No, Foreign Table Name, Column Sıra No, Column Name, Foreign Table Column, Lookup, Lookup List Field Name, Lookup Table Name, Lookup Key Field Name, Lookup Filter SQL, Lookup Filter MasterFields, Lookup Filter DetailFields, Lookup Column Name

      K := 0;
      while not GenelForm.UserForeignTables.Eof do
      begin
        SetDataSetFilter(GenelForm.UserForeignTableColumns, '[Table Name] = ''' + aTableName + ''' AND [Sıra No] = ' +
                                                                     GenelForm.UserForeignTables.FindField('Sıra No').AsString + ' AND [Foreign Table Name] = ''' +
                                                                     GenelForm.UserForeignTables.FindField('Foreign Table Name').AsString + '''');

        J   := 0;
        St1 := '';
        while not GenelForm.UserForeignTableColumns.Eof do
        begin
          if J > 0 then St1 := St1 + ' AND ';
          St1 := St1 + 'T' + IntToStr(K + 2) + '."' + MyCoalesce([GenelForm.UserForeignTableColumns.FindField('Foreign Table Column').AsString, GenelForm.UserForeignTableColumns.FindField('Column Name').AsString]) + '" = T1."' + GenelForm.UserForeignTableColumns.FindField('Column Name').AsString + '"';

          Inc(J);
          GenelForm.UserForeignTableColumns.Next;
        end;

        aList1.Text := SetAndGetFieldNames(GenelForm.UserForeignTables.FindField('Foreign Calc Fields').AsString,   LB);
        aList2.Text := SetAndGetFieldNames(GenelForm.UserForeignTables.FindField('Calc Fields New Names').AsString, LB);

        while aList2.Count < aList1.Count do aList2.Add('');

        MyGetKullaniciTabloErisimVsInformationProc(GenelForm.UserForeignTables.FindField('Foreign Table Name').AsString, MainConnection, MainConnection.Database, aErisim, aIlaveEtDegistirSil, aIlaveEtDegistirSil, aIlaveEtDegistirSil, aTabloFiltresi, aList3, nil);

        if not aErisim then
        begin
          GenelForm.UserForeignTables.Next;
          Continue;
        end;

        if aList3.Count > 0 then
          for I := aList1.Count - 1 downto 0 do
          begin
            J := IndexOfBySensitive(aList3, aList1[I]);

            if J > -1 then
            begin
              aList1.Delete(I);
              aList2.Delete(I);
            end;
          end;

        if aList1.Count = 0 then
        begin
          GenelForm.UserForeignTables.Next;
          Continue;
        end;

        if aTabloFiltresi <> '' then St1 := St1 + ' AND (' + aTabloFiltresi + ')';

        for I := 0 to aList1.Count - 1 do aSQLText := aSQLText + LB + '  (SELECT T' + IntToStr(K + 2) + '."' + aList1[I] + '" FROM ' + GetFullTableName(GenelForm.UserForeignTables.FindField('Foreign Table Name').AsString, ApplicationSchemaName, '', MainConnection) + ' T' + IntToStr(K + 2) + ' WHERE ' + St1 + ') AS "' + MyCoalesce([aList2[I], aList1[I]]) + '",';

        Inc(K);
        GenelForm.UserForeignTables.Next;
      end;

      aSQLText := DeleteFromRight(aSQLText, 1) + LB + 'FROM ' + GetFullTableName(aTableName + IfThen(aLookupTableAndUseGroup, ' Grup Veri', ''), ApplicationSchemaName, '', MainConnection) + ' T1';
    end;

    SetDataSetFilter(GenelForm.UserAllObjects, '[Object Name] = ''' + aTableName + IfThen(aLookupTableAndUseGroup, ' Grup Veri', '') + '''');

    Result := GetQuery(aSQLText,
                       MyCoalesce([IfThen(English or CurrentUser.DatabaseEnglish, GenelForm.UserAllObjects.FindField('English').AsString, ''), aTableName + IfThen(aLookupTableAndUseGroup, ' Grup Veri', '')]),
                       aTableInformations,
                       aFilterSQL,
                       aReadOnly,
                       '',
                       aTableName,
                       FALSE,
                       FALSE,
                       '',
                       ApplicationSchemaName,
                       MainConnection,
                       '',
                       FALSE,
                       aExtraID);

    if LastGetTableOrGetQueryIsPreCreated then Exit;

    Result.TheSource           := AnsiUpperCase(ApplicationSchemaName);
    Result.DataSetEventsProc   := DataSetEvents;
    Result.NeverCancelProgress := TRUE;

    St1 := SetAndGetFieldNames(GenelForm.UserTables.FindField('Display Key').AsString, ';', '"', '"');
    if St1 <> '' then
      if not DataSetIncludesAllThoseFields(Result, St1) then
        Mw('"' + aTableName + IfThen(aLookupTableAndUseGroup, ' Grup Veri', '') + '" tablosu için (' + St1 + ') uygun bir indeks değil.')
      else
        if Result.IndexFieldNames <> St1 then Result.IndexFieldNames := St1;

    //UserTables              => Sıra No, Grup, Table Name, Logging, Veri Girişi, Bands, Display Key, View Tables, Erişim, Is View, Has Group
    //UserColumns             => Table Name, Sıra No, Column Name, Data Type or Compute Text, Size, Required, Primary Key, Unique Column, Properties Class, Properties Info, Band Index, Display Format, Klon İçin, Default
    //UserForeignTables       => Table Name, Sıra No, Foreign Table Name, On Delete Cascade, Foreign Calc Fields, Calc Fields Pre Columns, Calc Fields New Names, Klon İçin, By Trigger
    //UserForeignTableColumns => Table Name, Sıra No, Foreign Table Name, Column Sıra No, Column Name, Foreign Table Column, Lookup, Lookup List Field Name, Lookup Table Name, Lookup Key Field Name, Lookup Filter SQL, Lookup Filter MasterFields, Lookup Filter DetailFields, Lookup Column Name

    if not aView then
    begin
      SetDataSetFilter(GenelForm.UserColumns, '[Table Name] = ''' + aTableName + '''');

      while not GenelForm.UserColumns.Eof do
      begin
        aColumnName := GenelForm.UserColumns.FindField('Column Name').AsString;
        aField      := Result.FindField(aColumnName);

        if not Assigned(aField) then
        begin
          GenelForm.UserColumns.Next;
          Continue;
        end;

        SetDataSetFilter(GenelForm.UserForeignTableColumns, '[Table Name] = ''' + aTableName + ''' AND [Column Name] = ''' + aColumnName + ''' AND [Lookup] = ''TRUE''');

        aLookup          := (GenelForm.UserForeignTableColumns.RecordCount = 1) and (System.Pos(';' + aColumnName + ';', aNotLookupFieldNames) < 1);
        aFieldProperties := GenelForm.UserColumns.FindField('Properties Class').AsString <> '';

        if aFieldProperties then
        begin
          Inc(aFieldPropertiesCount);

          aFieldPropertiesInfos[aFieldPropertiesCount - 1].FieldName       := aField.FieldName;
          aFieldPropertiesInfos[aFieldPropertiesCount - 1].PropertiesClass := AnsiUpperCase(GenelForm.UserColumns.FindField('Properties Class').AsString);
          aFieldPropertiesInfos[aFieldPropertiesCount - 1].PropertiesInfo  := GenelForm.UserColumns.FindField('Properties Info').AsString;
        end;

        if aLookup then
        begin
          if aLookupTableCount = Length(aFieldLookupInfos) then Me('Yazılım hatası!!!' + LB2 + 'function GetAndSetTable(... if aLookupTableCount = Length(aFieldLookupInfos)...');

          //UserTables              => Sıra No, Grup, Table Name, Logging, Veri Girişi, Bands, Display Key, View Tables, Erişim, Is View, Has Group
          //UserColumns             => Table Name, Sıra No, Column Name, Data Type or Compute Text, Size, Required, Primary Key, Unique Column, Properties Class, Properties Info, Band Index, Display Format, Klon İçin, Default
          //UserForeignTables       => Table Name, Sıra No, Foreign Table Name, On Delete Cascade, Foreign Calc Fields, Calc Fields Pre Columns, Calc Fields New Names, Klon İçin, By Trigger
          //UserForeignTableColumns => Table Name, Sıra No, Foreign Table Name, Column Sıra No, Column Name, Foreign Table Column, Lookup, Lookup List Field Name, Lookup Table Name, Lookup Key Field Name, Lookup Filter SQL, Lookup Filter MasterFields, Lookup Filter DetailFields, Lookup Column Name

          SetDataSetFilter(GenelForm.UserForeignTables, '[Table Name] = ''' + aTableName + ''' AND [Sıra No] = ' +
                                                                 GenelForm.UserForeignTableColumns.FindField('Sıra No').AsString + ' AND [Foreign Table Name] = ''' +
                                                                 GenelForm.UserForeignTableColumns.FindField('Foreign Table Name').AsString + '''');

          aSystemForeignTable := System.Pos('SYS.', AnsiUpperCase(GenelForm.UserForeignTables.FindField('Foreign Table Name').AsString)) = 1;

          aLookupTableName          := MyCoalesce([GenelForm.UserForeignTableColumns.FindField('Lookup Table Name').AsString, GenelForm.UserForeignTableColumns.FindField('Foreign Table Name').AsString]);
          aLookupKeyFieldName       := MyCoalesce([GenelForm.UserForeignTableColumns.FindField('Lookup Key Field Name').AsString, GenelForm.UserForeignTableColumns.FindField('Foreign Table Column').AsString, aColumnName]);
          aLookupListFieldName      := MyCoalesce([GenelForm.UserForeignTableColumns.FindField('Lookup List Field Name').AsString, aLookupKeyFieldName]);
          aLookupFilterSQL          := GenelForm.UserForeignTableColumns.FindField('Lookup Filter SQL').AsString;
          aLookupReadOnly           := aSystemForeignTable or not CurrentUser.Administrator;
          aLookupEditableList       := not aField.Required or aSystemForeignTable;
          aLookupFilterMasterFields := SetAndGetFieldNames(MyCoalesce([GenelForm.UserForeignTableColumns.FindField('Lookup Filter MasterFields').AsString, GenelForm.UserForeignTableColumns.FindField('Lookup Filter DetailFields').AsString]));
          aLookupFilterDetailFields := MyCoalesce([SetAndGetFieldNames(GenelForm.UserForeignTableColumns.FindField('Lookup Filter DetailFields').AsString), aLookupFilterMasterFields]);
          aLookupColumnDisplayLabel := MyCoalesce([GenelForm.UserForeignTableColumns.FindField('Lookup Column Name').AsString, GenelForm.UserForeignTableColumns.FindField('Lookup List Field Name').AsString, aColumnName]);

          if aLookupColumnDisplayLabel <> '' then
            if English or CurrentUser.DatabaseEnglish then
            begin
              SetDataSetFilter(GenelForm.UserAllObjects, '[Object Name] = ''' + aLookupColumnDisplayLabel + '''');
              aField.DisplayLabel := MyCoalesce([GenelForm.UserAllObjects.FindField('English').AsString, aLookupColumnDisplayLabel]);
            end
            else
              aField.DisplayLabel := aLookupColumnDisplayLabel;

          aLookupTableDisplayName        := aLookupTableName;
          aLookupTableDisplayNameEnglish := aLookupTableName;

          if not aSystemForeignTable then
          begin
            K := GenelForm.UserTables.RecNo;
            if GenelForm.UserTables.LocateEx('Table Name', VarArrayOf([aLookupTableName]), []) then
              if GenelForm.UserTables.FindField('Table Name').AsString = aLookupTableName then
              begin
                SetDataSetFilter(GenelForm.UserAllObjects, '[Object Name] = ''' + aLookupTableName + '''');
                aLookupTableDisplayNameEnglish := MyCoalesce([GenelForm.UserAllObjects.FindField('English').AsString, aLookupKeyFieldName])
              end;

            GenelForm.UserTables.RecNo := K;
          end;

          aLookupExtraID := '';
          if Length(aLookupExtraIDFieldNames) = Length(aLookupExtraIDs) then
            for J := 0 to Length(aLookupExtraIDFieldNames) - 1 do
              if aLookupExtraIDFieldNames[J] = aField.FieldName then
              begin
                aLookupExtraID := aLookupExtraIDs[J];
                Break;
              end;

          if aSystemForeignTable then
          begin
            St1 := 'SELECT "' + aLookupListFieldName + '" AS "' + aColumnName + '" FROM ' + aLookupTableName + IfThen(aLookupFilterSQL <> '', ' WHERE ' + aLookupFilterSQL, '');
            aLookupUniQueryEx := GetQuery(St1, Lang(MyCoalesce([aLookupTableDisplayName, aLookupTableName]), MyCoalesce([aLookupTableDisplayNameEnglish, aLookupTableName])), []);

            aLookupUniQueryEx.IndexFieldNames := '"' + aColumnName + '"';

            aLookupKeyFieldName  := aColumnName;
            aLookupListFieldName := aColumnName;
          end
          else
          begin
            K   := GenelForm.UserTables.RecNo;
            M   := GenelForm.UserColumns.RecNo;
            St1 := GenelForm.UserColumns.Filter;

            aList1.Clear;
            aList2.Clear;
            if aLookupFilterMasterFields <> '' then
            begin
              aList1.Text := MyAnsiReplaceStr(aLookupFilterMasterFields, ';', LB);
              aList2.Text := MyAnsiReplaceStr(aLookupFilterDetailFields, ';', LB);

              if aList1.Count <> aList2.Count then
              begin
                Me_X('Yazılım hatası!!!!... if aList1.Count <> aList2.Count then... GetAndSetTable... aLookupFilterMasterFields sayısı aLookupFilterDetailFields sayısından farklı: ' + LB2 + aLookupFilterMasterFields + LB + aLookupFilterDetailFields);
                aList1.Clear;
                aList2.Clear;
              end
              else
                aLookupExtraID := aLookupExtraID + ' - ' + aLookupFilterMasterFields + ', ' + aLookupFilterDetailFields;
            end;

            if (aLookupTableName = 'Yıl') and (AktifButce.ButceID <> '') then
            begin
              if aLookupFilterSQL <> '' then aLookupFilterSQL := '(' + aLookupFilterSQL + ') AND ';
              aLookupFilterSQL := aLookupFilterSQL + '"Dönem ID" = '   + AktifButce.DonemID;
            end;

            aLookupUniQueryEx := GetAndSetTable(aLookupTableName, 'Lookup Table' + aLookupExtraID, aLookupFilterSQL, aLookupReadOnly, [], [], '', TRUE, TRUE);

            if aList1.Count > 0 then
            begin
              SetLength(aLookupUniQueryEx.LookupFilterInfos, Length(aLookupUniQueryEx.LookupFilterInfos) + 1);

              aLookupUniQueryEx.LookupFilterInfos[Length(aLookupUniQueryEx.LookupFilterInfos) - 1].MasterDataSet := Result;

              SetLength(aLookupUniQueryEx.LookupFilterInfos[Length(aLookupUniQueryEx.LookupFilterInfos) - 1].MasterFieldNames, aList1.Count);
              SetLength(aLookupUniQueryEx.LookupFilterInfos[Length(aLookupUniQueryEx.LookupFilterInfos) - 1].DetailFieldNames, aList1.Count);

              for J := 0 to aList1.Count - 1 do
              begin
                aLookupUniQueryEx.LookupFilterInfos[Length(aLookupUniQueryEx.LookupFilterInfos) - 1].MasterFieldNames[J] := aList1[J];
                aLookupUniQueryEx.LookupFilterInfos[Length(aLookupUniQueryEx.LookupFilterInfos) - 1].DetailFieldNames[J] := aList2[J];
              end;

              aList1.Clear;
              aList2.Clear;
            end;

            GenelForm.UserTables.RecNo := K;
            SetDataSetFilter(GenelForm.UserColumns, St1);
            GenelForm.UserColumns.RecNo := M;
          end;

          if aLookupUniQueryEx <> Result then //Foreign key kendi kendine tanımlanmış ise diye ("Kar Zarar")...
          begin
            St2 := MyCoalesce([aLookupListFieldName, aLookupKeyFieldName]);

            aFieldLookupInfos[aLookupTableCount].FieldName      := aField.FieldName;
            aFieldLookupInfos[aLookupTableCount].ListFieldNames := St2;
            aFieldLookupInfos[aLookupTableCount].KeyFieldNames  := MyCoalesce([aLookupKeyFieldName, aLookupListFieldName]);
            aFieldLookupInfos[aLookupTableCount].ListSource     := GetDataSource(aLookupUniQueryEx);

            if aLookupEditableList then
              aFieldLookupInfos[aLookupTableCount].DropDownListStyle := lsEditList
            else
              aFieldLookupInfos[aLookupTableCount].DropDownListStyle := lsFixedList;

            M := 0;
            if RightStr(aLookupUniQueryEx.MainTableInformation.TableName, 10) = ' Grup Veri' then
            begin
              K := GenelForm.UserTables.RecNo;

              if GenelForm.UserTables.LocateEx('Table Name', VarArrayOf([aLookupTableName]), []) then
                if GenelForm.UserTables.FindField('Table Name').AsString = aLookupTableName then
                  if GenelForm.UserTables.FindField('Has Group').AsBoolean then M := 1;

              GenelForm.UserTables.RecNo := K;
            end;

            for J := 0 to aLookupUniQueryEx.FieldCount - 1 do
            begin
              if aLookupUniQueryEx.Fields[J].FieldName <> St2 then aFieldLookupInfos[aLookupTableCount].ListFieldNames := aFieldLookupInfos[aLookupTableCount].ListFieldNames + ';' + aLookupUniQueryEx.Fields[J].FieldName;
                if M = 1 then
                  if aLookupUniQueryEx.Fields[J].FieldName = aLookupTableName + ' ID' then Break;
            end;

            if aLookupTableCount < Length(aFieldLookupInfos) then Inc(aLookupTableCount);
          end;
        end;

        GenelForm.UserColumns.Next;
      end;


      if aUseCalcFields then
      begin
        SetDataSetFilter(GenelForm.UserForeignTables, '[Table Name] = ''' + aTableName + ''' AND [Foreign Calc Fields] IS NOT NULL');

        //UserTables              => Sıra No, Grup, Table Name, Logging, Veri Girişi, Bands, Display Key, View Tables, Erişim, Is View, Has Group
        //UserColumns             => Table Name, Sıra No, Column Name, Data Type or Compute Text, Size, Required, Primary Key, Unique Column, Properties Class, Properties Info, Band Index, Display Format, Klon İçin, Default
        //UserForeignTables       => Table Name, Sıra No, Foreign Table Name, On Delete Cascade, Foreign Calc Fields, Calc Fields Pre Columns, Calc Fields New Names, Klon İçin, By Trigger
        //UserForeignTableColumns => Table Name, Sıra No, Foreign Table Name, Column Sıra No, Column Name, Foreign Table Column, Lookup, Lookup List Field Name, Lookup Table Name, Lookup Key Field Name, Lookup Filter SQL, Lookup Filter MasterFields, Lookup Filter DetailFields, Lookup Column Name

        while not GenelForm.UserForeignTables.Eof do
        begin
          aList1.Text := SetAndGetFieldNames(GenelForm.UserForeignTables.FindField('Foreign Calc Fields').AsString,     LB);
          aList2.Text := SetAndGetFieldNames(GenelForm.UserForeignTables.FindField('Calc Fields New Names').AsString,   LB);
          aList3.Text := SetAndGetFieldNames(GenelForm.UserForeignTables.FindField('Calc Fields Pre Columns').AsString, LB);

          while aList2.Count < aList1.Count do aList2.Add('');

          if aList3.Count > 0 then
            while aList3.Count < aList1.Count do aList3.Add('');

          SetDataSetFilter(GenelForm.UserForeignTableColumns, '[Table Name] = ''' + aTableName + ''' AND [Sıra No] = ' +
                                                                       GenelForm.UserForeignTables.FindField('Sıra No').AsString + ' AND [Foreign Table Name] = ''' +
                                                                       GenelForm.UserForeignTables.FindField('Foreign Table Name').AsString + '''');

          GenelForm.UserForeignTableColumns.Last;

          for J := aList1.Count - 1 downto 0 do
          begin
            aField := Result.FindField(MyCoalesce([aList2[J], aList1[J]]));
            if not Assigned(aField) then Continue;

            aField.Index := Result.FieldCount + 1;
            aField.Index := Result.FindField(GenelForm.UserForeignTableColumns.FindField('Column Name').AsString).Index + 1;

            SetDataSetFilter(GenelForm.UserColumns, '[Table Name] = ''' + GenelForm.UserForeignTables.FindField('Foreign Table Name').AsString + ''' AND [Column Name] = ''' + aList1[J] + '''');

            if GenelForm.UserColumns.FindField('Properties Class').AsString <> '' then
            begin
              Inc(aFieldPropertiesCount);

              aFieldPropertiesInfos[aFieldPropertiesCount - 1].FieldName       := aField.FieldName;
              aFieldPropertiesInfos[aFieldPropertiesCount - 1].PropertiesClass := AnsiUpperCase(GenelForm.UserColumns.FindField('Properties Class').AsString);
              aFieldPropertiesInfos[aFieldPropertiesCount - 1].PropertiesInfo  := GenelForm.UserColumns.FindField('Properties Info').AsString;
            end;
          end;

          if aList3.Count > 0 then
            for J := aList1.Count - 1 downto 0 do
            begin
              St1 := Trim(aList3[J]);
              if St1 = '' then Continue;

              K := 0;
              aField := Result.FindField(St1);
              if Assigned(aField) then
                K := aField.Index + 1
              else
                if St1 <> 'XXX' then Continue;

              aField := Result.FindField(MyCoalesce([aList2[J], aList1[J]]));
              if not Assigned(aField) then Continue;

              if (aField.Index > -1) and (aField.Index < K) then
                aField.Index := K - 1
              else
                aField.Index := K;
            end;

          GenelForm.UserForeignTables.Next;
        end;
      end;
    end;

    SetLength(Result.FieldLookupInfos, aLookupTableCount);

    for I := 0 to Length(Result.FieldLookupInfos) - 1 do
    begin
      Result.FieldLookupInfos[I].FieldName         := aFieldLookupInfos[I].FieldName;
      Result.FieldLookupInfos[I].ListFieldNames    := aFieldLookupInfos[I].ListFieldNames;
      Result.FieldLookupInfos[I].KeyFieldNames     := aFieldLookupInfos[I].KeyFieldNames;
      Result.FieldLookupInfos[I].ListSource        := aFieldLookupInfos[I].ListSource;
      Result.FieldLookupInfos[I].DropDownListStyle := aFieldLookupInfos[I].DropDownListStyle;
    end;

    SetLength(Result.FieldPropertiesInfos, aFieldPropertiesCount);

    for I := 0 to Length(Result.FieldPropertiesInfos) - 1 do
    begin
      Result.FieldPropertiesInfos[I].FieldName       := aFieldPropertiesInfos[I].FieldName;
      Result.FieldPropertiesInfos[I].PropertiesClass := aFieldPropertiesInfos[I].PropertiesClass;
      Result.FieldPropertiesInfos[I].PropertiesInfo  := aFieldPropertiesInfos[I].PropertiesInfo;
    end;
  finally
    aList1.Free;
    aList2.Free;
    aList3.Free;
  end;
end;

function GetAndSetTable(const aTableName: string; const aExtraID: string; const aFilterSQL: string = ''; const aReadOnly: Boolean = FALSE; const aNotLookupFieldNames: string = ''; const aUseCalcFields: Boolean = FALSE; const aLookupTable: Boolean = FALSE): TUniQueryEx;
begin
  Result := GetAndSetTable(aTableName, aExtraID, aFilterSQL, aReadOnly, [], [], aNotLookupFieldNames, aUseCalcFields, aLookupTable);
end;

function GetAndSetTable(const aTableName: string; const aExtraIDSender: TObject; const aFilterSQL: string; const aReadOnly: Boolean; const aLookupExtraIDFieldNames: array of string; const aLookupExtraIDs: array of string; const aNotLookupFieldNames: string; const aUseCalcFields: Boolean; const aLookupTable: Boolean; const aMoreExtraID: string = ''): TUniQueryEx;
var
  aExtraID: string;
begin
  if aExtraIDSender is TComponent then
    aExtraID := TComponent(aExtraIDSender).Name + aMoreExtraID
  else
    aExtraID := aMoreExtraID;

  Result := GetAndSetTable(aTableName, aExtraID, aFilterSQL, aReadOnly, aLookupExtraIDFieldNames, aLookupExtraIDs, aNotLookupFieldNames, aUseCalcFields, aLookupTable);
end;

function GetAndSetTable(const aTableName: string; const aExtraIDSender: TObject; const aFilterSQL: string = ''; const aReadOnly: Boolean = FALSE; const aNotLookupFieldNames: string = ''; const aUseCalcFields: Boolean = FALSE; const aLookupTable: Boolean = FALSE; const aMoreExtraID: string = ''): TUniQueryEx;
begin
  Result := GetAndSetTable(aTableName, aExtraIDSender, aFilterSQL, aReadOnly, [], [], aNotLookupFieldNames, aUseCalcFields, aLookupTable, aMoreExtraID);
end;

function Veri(const aSender: TObject; const aTableName: string; const aExtraIDSender: TObject = nil; const aTableReadOnly: Boolean = FALSE; const aExtraMainFormID: string = ''): TForms_MainForm;
begin
  Result := VeriGirisi(aSender, GetAndSetTable(aTableName, aExtraIDSender, '', aTableReadOnly), '', MainConnection.Name + aExtraMainFormID, TRUE);
  if Result.Exists then Exit;
  Result.MainFormEventsProc := MainFormEvents;
  Result.cxGridForms[0].cxGridMainFormEventsProc := cxGridMainFormEvents;
end;

function VeriMasterDetay(const aSender: TObject; const aMasterTableName, aDetailTableName, aMasterFieldNames, aDetailFieldNames: string; const aMasterExtraIDSender: TObject; const aDetailExtraIDSender: TObject; const aMasterTableReadOnly: Boolean = FALSE; const aDetailTableReadOnly: Boolean = FALSE; const aExtraMainFormID: string = ''): TForms_MainForm;
begin
  with TVeriGirisiForm.Create(GetCaption(aSender), aSender, MainConnection.Name + aExtraMainFormID) do
  try
    Result := MainForm;
    if Result.Exists then Exit;

    Result.MainFormEventsProc := MainFormEvents;

    DataSet(GetAndSetTable(aMasterTableName, aMasterExtraIDSender, '', aMasterTableReadOnly));
    DataSet(GetAndSetTable(aDetailTableName, aDetailExtraIDSender, '', aDetailTableReadOnly));

    MasterDetail(0, 1, aMasterFieldNames, aDetailFieldNames, TRUE);

    Grid(0);
    Grid(1);

    Result.cxGridForms[0].cxGridMainFormEventsProc := cxGridMainFormEvents;
    Result.cxGridForms[1].cxGridMainFormEventsProc := cxGridMainFormEvents;

    HideCloseItemsExceptThose([0]);

    CreateForm(Horz(Forms(0), Forms(1)));

    ShowForm;
  finally
    Free;
  end;
end;

procedure TGenelForm.MainUserMenuItemClick(Sender: TObject);
var
  I, J, F, aCurrentDataSetIndex: Integer;
  St1, St2, aTableName: string;
  a3x3Index: Integer;
  aMasterTableIndex: Integer;
  aMasterFieldNames, aDetailFieldNames, aFilterSQL,
  aFormCaption, aInVisibleFields, aReadOnlyFields,
  aButceAc, aButceAcButceText, aButceAcDonemText, aButceAcSirketText: string;
  aGridCount, aCurrentGridIndex: Integer;
  aCellCounts: array [0..9 - 1] of Integer;
  aControls: array [0..9 - 1] of TControl;
  aCellControls: array [0..9 - 1] of array [0..9 - 1] of TControl;
  aPageCaptions: array of string;
  aPageControls: array of TControl;
  aBandText: string;
  aConstantBandCaption: string;
  aOtherBandCaptions, aOtherBandFieldNames: array of string;
  aList1: TStringList;
  aList2: TStringList;
  aSortedList1: TStringList;
  aSortedList2: TStringList;
  aDataSet: TDataSet;
begin
  //UserMenu      => Sıra No, Problem, Ana Menü, Menü, Menü English, Progress
  //UserMenuTablo => Menü, Sıra No, Table Name, 3x3 Index, Master Table Index, Master Field Names, Detail Field Names, Use Calc Fields, Extra ID, Read Only, Invisible Fields, Filter SQL, Caption, Grid Buttons, Read Only Fields, Refresh Master, Grid Read Only Fields, Bütçe Aç

  UserMenu.RecNo := TdxBarItem(Sender).Tag - 1000000;

  SetDataSetFilter(UserMenuTablo, '[Menü] = ''' + UserMenu.FindField('Menü').AsString + '''');

  aFormCaption := '';
  if (AktifButce.ButceID <> '') and (UserMenuTablo.RecordCount > 0) then
  begin
    aButceAcButceText  := '';
    aButceAcDonemText  := '';
    aButceAcSirketText := '';

    UserMenuTablo.First;
    while not UserMenuTablo.Eof do
    begin
      aButceAc := UserMenuTablo.FindField('Bütçe Aç').AsString;

      if StringIN(aButceAc, ['Bütçe', 'Bütçe-Dönem', 'Bütçe-Şirket']) then
      begin
        aButceAcButceText := 'E';
        Break;
      end;

      if aButceAc = 'Dönem'  then aButceAcDonemText  := 'E';
      if aButceAc = 'Şirket' then aButceAcSirketText := 'E';

      UserMenuTablo.Next;
    end;

    UserMenuTablo.First;

    if aButceAcButceText <> '' then
      aFormCaption := ' - "' + AktifButce.ButceAdi + ', ' + AktifButce.ButceID + '"'
    else
      if aButceAcSirketText <> '' then
        aFormCaption := ' - "' + AktifButce.SirketAdi + ', ' + AktifButce.SirketID + '"'
      else
       if aButceAcDonemText <> '' then aFormCaption := ' - "' + AktifButce.DonemAdi + ', ' + AktifButce.DonemID + '"';
  end;

  with TVeriGirisiForm.Create(GetCaption(Sender) + aFormCaption, Sender, MainConnection.Name + '-' + AktifButce.ButceID, TRUE) do
  try
    if MainForm.Exists then Exit;

    AddToMessageLog(Lang('Veri Girişi', 'Data Entrance'), 'Veri girişi formu otomatik ("User Menü" tablosundan) oluşturuluyor... "' + UserMenu.FindField('Ana Menü').AsString + '", "' + UserMenu.FindField('Menü').AsString + '"');

    MainForm.MainFormEventsProc := MainFormEvents;
    MainForm.TheEventID         := UserMenu.FindField('Menü').AsString;
    MainForm.TheINIFileName     := GetValidFileName(UserMenu.FindField('Ana Menü').AsString, '[]') + '.' + GetValidFileName(UserMenu.FindField('Menü').AsString, '[]') + '.INI';

    for I := 0 to Length(aCellCounts) - 1 do aCellCounts[I] :=  0;

    for I := 0 to Length(aControls) - 1 do aControls[I] :=  nil;
    for I := 0 to Length(aCellControls) - 1 do
      for J := 0 to Length(aCellControls[I]) - 1 do aCellControls[I][J] :=  nil;

    aGridCount := 0;

    if UserMenuTablo.RecordCount > 0 then
    begin
      //UserMenuTablo => Menü, Sıra No, Table Name, 3x3 Index, Master Table Index, Master Field Names, Detail Field Names, Use Calc Fields, Extra ID, Read Only, Invisible Fields, Filter SQL, Caption, Grid Buttons, Read Only Fields, Refresh Master, Grid Read Only Fields, Bütçe Aç

      aList1       := TStringList.Create;
      aList2       := TStringList.Create;
      aSortedList1 := TStringList.Create;
      aSortedList2 := TStringList.Create;
      try
        MakeStringListSorted(aSortedList1);
        MakeStringListSorted(aSortedList2);

        UserMenuTablo.First;
        while not UserMenuTablo.Eof do
        begin
          if StrToIntDef(UserMenuTablo.FindField('3x3 Index').AsString, IfThen(UserMenuTablo.RecordCount = 1, 0, -1)) > -1 then Inc(aGridCount);

          UserMenuTablo.Next;
        end;

        if aGridCount > 1 then ProgressStartAsExtra(Lang('Formlar oluşturuluyor...', 'Creating forms...'), '', aGridCount, TRUE);
        try
          aCurrentGridIndex := 0;

          aCurrentDataSetIndex := 0;
          UserMenuTablo.First;
          while not UserMenuTablo.Eof do
          begin
            aTableName           := UserMenuTablo.FindField('Table Name').AsString;
            a3x3Index            := StrToIntDef(UserMenuTablo.FindField('3x3 Index').AsString, IfThen(UserMenuTablo.RecordCount = 1, 0, -1));
            aMasterTableIndex    := StrToIntDef(UserMenuTablo.FindField('Master Table Index').AsString, -1);
            aMasterFieldNames    := UserMenuTablo.FindField('Master Field Names').AsString;
            aDetailFieldNames    := UserMenuTablo.FindField('Detail Field Names').AsString;
            aFilterSQL           := UserMenuTablo.FindField('Filter SQL').AsString;
            aFormCaption         := LangFromText(UserMenuTablo.FindField('Caption').AsString);
            aInVisibleFields     := UserMenuTablo.FindField('Invisible Fields').AsString;
            aReadOnlyFields      := UserMenuTablo.FindField('Read Only Fields').AsString;
            aButceAc             := UserMenuTablo.FindField('Bütçe Aç').AsString;

            if (aButceAc <> '') and (AktifButce.ButceID <> '') then
            begin
              aButceAcButceText  := '("Bütçe ID" IS NULL OR "Bütçe ID" = '   + AktifButce.ButceID  + ')';
              aButceAcDonemText  := '("Dönem ID" IS NULL OR "Dönem ID" = '   + AktifButce.DonemID  + ')';
              aButceAcSirketText := '("Şirket ID" IS NULL OR "Şirket ID" = ' + AktifButce.SirketID + ')';

              St1 := '';

              if aButceAc = 'Bütçe'        then St1 := aButceAcButceText;
              if aButceAc = 'Dönem'        then St1 := aButceAcDonemText;
              if aButceAc = 'Şirket'       then St1 := aButceAcSirketText;
              if aButceAc = 'Bütçe-Dönem'  then St1 := aButceAcButceText + ' AND ' + aButceAcDonemText;
              if aButceAc = 'Bütçe-Şirket' then St1 := aButceAcButceText + ' AND ' + aButceAcSirketText;

              if St1 <> '' then
              begin
                if aFilterSQL <> '' then aFilterSQL := '(' + aFilterSQL + ') AND ';
                aFilterSQL := aFilterSQL + St1;
              end;
            end;

            if aMasterTableIndex > -1 then
              St1 := MyCoalesce([aDetailFieldNames, aMasterFieldNames, GetIndexFieldNames(aMasterTableIndex)])
            else
              St1 := '';

            try
              aDataSet := GetAndSetTable(aTableName, Sender, aFilterSQL, FALSE, St1, UserMenuTablo.FindField('Use Calc Fields').AsBoolean, FALSE, UserMenuTablo.FindField('Extra ID').AsString);
              DataSet(aDataSet);
              TUniQueryEx(aDataSet).RefreshMasterDataSet := UserMenuTablo.FindField('Refresh Master').AsBoolean;
            except
              on Ex: Exception do
              begin
                Me(ExceptionMessage(Ex));
                DataSet(nil, aTableName);
              end;
            end;

            aDataSet := DataSets(aCurrentDataSetIndex);

            InVisibleFields(aCurrentDataSetIndex, aInVisibleFields);
            ReadOnlyFields(aCurrentDataSetIndex,  aReadOnlyFields, TRUE);

            if Assigned(aDataSet) then
              if UserMenuTablo.FindField('Read Only').AsBoolean then TUniQueryEx(aDataSet).ReadOnly := TRUE;

            if aMasterTableIndex > -1 then MasterDetail(aMasterTableIndex, aCurrentDataSetIndex, MyCoalesce([aMasterFieldNames, GetIndexFieldNames(aMasterTableIndex)]), aDetailFieldNames, TRUE);

            if a3x3Index > 8 then a3x3Index := 8;

            if a3x3Index > -1 then
            begin
              if aGridCount > 1 then
                if ProgressCanceled(1, 1, '', '"' + RemoveQuotationMarks(MainForm.DataSetInformations[aCurrentDataSetIndex].DataSetCaption) + '"') then
                begin
                  MainForm.Close;
                  Exit;
                end;

              Inc(aCellCounts[a3x3Index]);

              //UserTables  => Sıra No, Grup, Table Name, Logging, Veri Girişi, Bands, Display Key, View Tables, Erişim, Is View, Has Group
              //UserColumns => Table Name, Sıra No, Column Name, Data Type or Compute Text, Size, Required, Primary Key, Unique Column, Properties Class, Properties Info, Band Index, Display Format, Klon İçin, Default

              aBandText := '';
              if Assigned(aDataSet) then
                if UserTables.LocateEx('Table Name', VarArrayOf([aTableName]), []) then
                  if (UserTables.FindField('Table Name').AsString = aTableName) and (UserTables.FindField('Bands').AsString <> '') then
                  begin
                    aList1.Text := SetAndGetFieldNames(LangFromText(UserTables.FindField('Bands').AsString), LB);
                    if aList1.Count > 2 then
                    begin
                      aConstantBandCaption := aList1[0];

                      SetLength(aOtherBandCaptions,   aList1.Count - 1);
                      SetLength(aOtherBandFieldNames, aList1.Count - 1);

                      for I := 0 to Length(aOtherBandCaptions) - 1 do
                      begin
                        aOtherBandCaptions[I]   := aList1[I + 1];
                        aOtherBandFieldNames[I] := '';
                      end;

                      SetDataSetFilter(UserColumns, '[Table Name] = ''' + aTableName + '''');

                      SetDataSetFilter(UserForeignTables, '[Table Name] = ''' + aTableName + ''' AND [Foreign Calc Fields] IS NOT NULL');

                      aSortedList1.Clear;
                      aSortedList2.Clear;

                      //UserForeignTables => Table Name, Sıra No, Foreign Table Name, On Delete Cascade, Foreign Calc Fields, Calc Fields Pre Columns, Calc Fields New Names, Klon İçin, By Trigger

                      if UserForeignTables.RecordCount > 0 then
                      begin
                        while not UserColumns.Eof do
                        begin
                          aSortedList1.Add(UserColumns.FindField('Column Name').AsString);

                          UserColumns.Next;
                        end;

                        UserColumns.First;

                        while not UserForeignTables.Eof do
                        begin
                          aList1.Text := SetAndGetFieldNames(UserForeignTables.FindField('Foreign Calc Fields').AsString,   LB);
                          aList2.Text := SetAndGetFieldNames(UserForeignTables.FindField('Calc Fields New Names').AsString, LB);

                          while aList2.Count < aList1.Count do aList2.Add('');

                          for I := 0 to aList1.Count - 1 do
                          begin
                            St1 := MyCoalesce([Trim(aList2[I]), Trim(aList1[I])]);
                            if St1 <> '' then
                              if Assigned(aDataSet.FindField(St1)) then aSortedList2.Add(St1);
                          end;

                          UserForeignTables.Next;
                        end;
                      end;

                      while not UserColumns.Eof do
                      begin
                        J := UserColumns.FindField('Band Index').AsInteger;

                        if J > Length(aOtherBandFieldNames) then J := Length(aOtherBandFieldNames);

                        if J > 0 then
                        begin
                          St1 := UserColumns.FindField('Column Name').AsString;

                          if Assigned(aDataSet.FindField(St1)) then
                          begin
                            if aOtherBandFieldNames[J - 1] <> '' then aOtherBandFieldNames[J - 1] := aOtherBandFieldNames[J - 1] + ';';
                            aOtherBandFieldNames[J - 1] := aOtherBandFieldNames[J - 1] + St1;

                            if aSortedList2.Count > 0 then
                              for I := aDataSet.FindField(St1).Index + 1 to aDataSet.FieldCount - 1 do
                                if aSortedList1.Find(aDataSet.Fields[I].FieldName, F) then
                                  Break
                                else
                                  if aSortedList2.Find(aDataSet.Fields[I].FieldName, F) then
                                    aOtherBandFieldNames[J - 1] := aOtherBandFieldNames[J - 1] + ';' + aDataSet.Fields[I].FieldName
                                  else
                                    Break;
                          end;
                        end;

                        UserColumns.Next;
                      end;

                      for I := 0 to Length(TUniQueryEx(aDataSet).MonthCalcFieldsInfos) - 1 do
                      begin
                        St1 := ';' + TUniQueryEx(aDataSet).MonthCalcFieldsInfos[I].MonthFields[12 - 1].FieldName + ';';
                        St2 := '';
                        if Assigned(TUniQueryEx(aDataSet).MonthCalcFieldsInfos[I].MonthCalcSUMField)  then St2 := St2 + TUniQueryEx(aDataSet).MonthCalcFieldsInfos[I].MonthCalcSUMField.FieldName  + ';';
                        if Assigned(TUniQueryEx(aDataSet).MonthCalcFieldsInfos[I].MonthCalcAVGField)  then St2 := St2 + TUniQueryEx(aDataSet).MonthCalcFieldsInfos[I].MonthCalcAVGField.FieldName  + ';';
                        if Assigned(TUniQueryEx(aDataSet).MonthCalcFieldsInfos[I].MonthCalcZeroField) then St2 := St2 + TUniQueryEx(aDataSet).MonthCalcFieldsInfos[I].MonthCalcZeroField.FieldName + ';';

                        for J := 0 to Length(aOtherBandFieldNames) - 1 do aOtherBandFieldNames[J] := DeleteFromRight(DeleteFromLeft(MyAnsiReplaceStr(';' + aOtherBandFieldNames[J] + ';', St1, St1 + St2), 1), 1);
                      end;

                      aBandText := BandText(aConstantBandCaption, aOtherBandCaptions, aOtherBandFieldNames, TRUE);
                    end;
                  end;

              ActivateDataSet(aDataSet);

              aCellControls[a3x3Index][aCellCounts[a3x3Index] - 1] := Grid(aCurrentDataSetIndex, aFormCaption, aBandText);

              cxGridForms(aCurrentGridIndex).TheEventID               := aTableName;
              cxGridForms(aCurrentGridIndex).TheINIFileName           := GetValidFileName(UserMenu.FindField('Ana Menü').AsString, '[]') + '.' + GetValidFileName(UserMenu.FindField('Menü').AsString, '[]') + '.' + GetValidFileName(aTableName, '[]') + '-' + IntToStr(cxGridForms(aCurrentGridIndex).cxGrid1DBBandedTableViewMain.ColumnCount) + '.INI';
              cxGridForms(aCurrentGridIndex).CloseItem.Visible        := ivNever;
              cxGridForms(aCurrentGridIndex).cxGridMainFormEventsProc := cxGridMainFormEvents;

              if Assigned(EventsForm) then
                for I := 0 to cxGridViews(aCurrentGridIndex).ColumnCount - 1 do
                  if cxGridViews(aCurrentGridIndex).Columns[I].PropertiesClass = TcxButtonEditProperties then
                    with TcxButtonEditProperties(cxGridViews(aCurrentGridIndex).Columns[I].Properties) do
                      if not Assigned(OnButtonClick) then
                      begin
                        OnButtonClick := EventsForm.cxGridDBBandedTableViewColumnPropertiesButtonClick;
                        F := GetUniqueInteger;
                        for J := 0 to Buttons.Count - 1 do Buttons[J].Tag := F;
                      end;

              aList1.Text := SetAndGetFieldNames(UserMenuTablo.FindField('Grid Buttons').AsString, LB);

              for I := 0 to aList1.Count - 1 do
                if I = 10 then
                  Break
                else
                  UserButton(aCurrentGridIndex, I, LangFromText(aList1[I]), '', 0, cxLargeImagesForButtons, I, glLeft, LangFromTextTR(aList1[I]));

              aList1.Text := SetAndGetFieldNames(UserMenuTablo.FindField('Grid Read Only Fields').AsString, LB);

              if aList1.Count > 0 then
                for I := 0 to cxGridViews(aCurrentGridIndex).ColumnCount - 1 do
                  if IndexOfBySensitive(aList1, cxGridViews(aCurrentGridIndex).Columns[I].DataBinding.FieldName) > -1 then cxGridViews(aCurrentGridIndex).Columns[I].Options.Editing := FALSE;

              Inc(aCurrentGridIndex);
            end;

            Inc(aCurrentDataSetIndex);

            UserMenuTablo.Next;
          end;
        finally
          if aGridCount > 1 then ProgressFinish;
        end;

        for I := 0 to Length(aCellCounts) - 1 do
          if aCellCounts[I] > 0 then
            if aCellCounts[I] = 1 then
              aControls[I] := aCellControls[I][0]
            else
            begin
              SetLength(aPageCaptions, aCellCounts[I]);
              SetLength(aPageControls, aCellCounts[I]);

              for J := 0 to aCellCounts[I] - 1 do
              begin
                aPageCaptions[J] := TForms_cxGridMainForm(aCellControls[I][J]).Caption;
                aPageControls[J] := aCellControls[I][J];
                TForms_cxGridMainForm(aCellControls[I][J]).HideCaptionItemsCaption;
              end;

              aControls[I] := Page(aPageCaptions, aPageControls);
            end;

        J := -1;
        if aCellCounts[2] > 0 then J := 2 else
          if aCellCounts[1] > 0 then J := 1 else
            if aCellCounts[0] > 0 then J := 0 else
              if aCellCounts[5] > 0 then J := 5 else
                if aCellCounts[4] > 0 then J := 4 else
                  if aCellCounts[3] > 0 then J := 3 else
                    if aCellCounts[8] > 0 then J := 8 else
                      if aCellCounts[7] > 0 then J := 7 else
                        if aCellCounts[6] > 0 then J := 6;

        if J > -1 then
          for I := 0 to aCellCounts[J] - 1 do TForms_cxGridMainForm(aCellControls[J][I]).CloseItem.Visible := ivAlways;

        CreateForm(Horz(Vert(aControls[0], aControls[1], aControls[2], nil, nil, TRUE),
                        Vert(aControls[3], aControls[4], aControls[5], nil, nil, TRUE),
                        Vert(aControls[6], aControls[7], aControls[8], nil, nil, TRUE),
                        nil,
                        nil,
                        TRUE));
      finally
        aList1.Free;
        aList2.Free;
        aSortedList1.Free;
        aSortedList2.Free;
      end;
    end;

    ShowForm;
  finally
    Free;
  end;
end;

procedure TGenelForm.FormCreate(Sender: TObject);
begin
  UserTableInformationsList := TStringList.Create;
  BeforeCreateFieldsFromDataSetToDataSetProc := MyBeforeCreateFieldsFromDataSetToDataSetProc;
  GetKullaniciTabloErisimVsInformationProc   := MyGetKullaniciTabloErisimVsInformationProc;
  AssignCalculatedFieldsToDataSetProc        := MyAssignCalculatedFieldsToDataSetProc;
end;

procedure AssignTextToVirtualTable(aVirtualTable: TVirtualTable; var Text: string);
var
  aStream: TStringStream;
begin
  aStream := TStringStream.Create(MyDeCompressTextDecoding(Text), TEncoding.UTF8);
  try
    aVirtualTable.LoadFromStream(aStream);
    aVirtualTable.Active := TRUE;
  finally
    aStream.Free;
  end;

  Text := '';
end;

procedure TGenelForm.FormDestroy(Sender: TObject);
begin
  UserTableInformationsList.Free;
end;

procedure TGenelForm.LoadProgrammersUserDataAndSet;
var
  I: Integer;
  St1: string;
begin
  AddToMessageLog('User Data', 'LoadProgrammersUserDataAndSet begin');

  LoadProgrammersUserData;

  AddToMessageLog('User Data', 'LoadProgrammersUserData');

  try
    St1 := '';
    for I := 1 to UserTableInformationsList.Count - 1 do
    begin
      if UserTableInformationsList[I] <> '' then
        if UserTableInformationsList[I][1] <> '-' then St1 := St1 + UserTableInformationsList[I];

      if UserTableInformationsList[I] = '-2-' then begin AssignTextToVirtualTable(UserTables,              St1); Continue; end;
      if UserTableInformationsList[I] = '-3-' then begin AssignTextToVirtualTable(UserColumns,             St1); Continue; end;
      if UserTableInformationsList[I] = '-4-' then begin AssignTextToVirtualTable(UserAllObjects,          St1); Continue; end;
      if UserTableInformationsList[I] = '-5-' then begin AssignTextToVirtualTable(UserForeignTables,       St1); Continue; end;
      if UserTableInformationsList[I] = '-6-' then begin AssignTextToVirtualTable(UserForeignTableColumns, St1); Continue; end;
      if UserTableInformationsList[I] = '-7-' then begin AssignTextToVirtualTable(UserTableExecSQLs,       St1); Continue; end;
      if UserTableInformationsList[I] = '-8-' then begin AssignTextToVirtualTable(UserMenu,                St1); Continue; end;
    end;

    AssignTextToVirtualTable(UserMenuTablo, St1);

    AddToMessageLog('User Data', 'Veriler kaydedildi');

    UserTables.IndexFieldNames  := '"Table Name"';
    UserColumns.IndexFieldNames := '"Table Name";"Sıra No"';

    AddToMessageLog('User Data', '"Tables" index atandı');
  except
    on Ex: Exception do Me('Yazılım hatası!!!' + LB2 + 'Hata mesajı: ' + LB + ExceptionMessage(Ex) + LB2 + 'procedure TGenelForm.LoadProgrammersUserDataAndSet;');
  end;

  UserTableInformationsList.Clear;

  AddToMessageLog('User Data', 'LoadProgrammersUserDataAndSet end');
end;

initialization
  GenelForm := TGenelForm.Create(Application);
  GenelForm.LoadProgrammersUserDataAndSet;

end.
