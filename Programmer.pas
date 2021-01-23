unit Programmer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, dxBar, StdCtrls, cxDropDownEdit, cxColorComboBox, cxCheckGroup,
  StrUtils, cxImage, cxStyles, cxBarEditItem, cxClasses, MemDS, DBAccess, Uni,
  Types, Math, Grids, ValEdit, ExtCtrls, ComCtrls, VirtualTable, DateUtils,
  cxMemo, EncdDecd, System.NetEncoding;

type
  TProgrammerForm = class(TForm)
    dxBarManager: TdxBarManager;
    dxBarManagerMenuBar: TdxBar;
    TestItem: TdxBarLargeButton;
    TablolarItem: TdxBarLargeButton;
    UserTablesScriptItem: TdxBarButton;
    ProgramciSubItem: TdxBarSubItem;
    TestlerSubItem: TdxBarSubItem;
    MessagesTestItem: TdxBarButton;
    SchemaNamesItem: TdxBarButton;
    SelectionsItem: TdxBarButton;
    ImageSeperatorEditItem: TcxBarEditItem;
    BackupPROGRAMCIDatabaseItem: TdxBarButton;
    TablolariOlusturItem: TdxBarButton;
    cxStyleRepository: TcxStyleRepository;
    cxStyleBold8Maroon: TcxStyle;
    cxStyleBold8Navy: TcxStyle;
    cxStyleBold8Purple: TcxStyle;
    cxStyleBold8Black: TcxStyle;
    cxStyleImageSeparator: TcxStyle;
    MetaDataItem: TdxBarButton;
    TablolariOnceSilItem: TdxBarButton;
    dxBarButton5: TdxBarButton;
    cxStyleBold8Red: TcxStyle;
    PASDosyalariniDuzenleItem: TdxBarButton;
    UserTablesTriggersComboBox: TComboBox;
    DatabaseUpgradeCodePanel: TPanel;
    Label1: TLabel;
    DatabaseUpgradeCodeYearEdit: TEdit;
    Label2: TLabel;
    DatabaseUpgradeCodeMonthEdit: TEdit;
    Label3: TLabel;
    DatabaseUpgradeCodeDayEdit: TEdit;
    Label4: TLabel;
    DatabaseUpgradeCodeSayacEdit: TEdit;
    UserTablesScriptComboBox: TComboBox;
    UserTablesItem: TdxBarButton;
    NOTTheProgrammersComputerCheckBox: TCheckBox;
    VeriGirisleriItem: TdxBarButton;
    ProgramDatasiniOlusturItem: TdxBarButton;
    ProgramciyaMesajlarBariniGosterItem: TdxBarButton;
    TablolariSonraTemptenGeriYukleItem: TdxBarButton;
    ButunMenulariAcItem: TdxBarButton;
    ButunMenuleriAcveKapatItem: TdxBarButton;
    TabloGruplariItem: TdxBarButton;
    ProgrammersMessagePanel: TPanel;
    ProgrammersMessageLabel: TLabel;
    ButunTablolariAcKapatItem: TdxBarButton;
    ButunTablolariveMenuleriAcveKapatItem: TdxBarButton;
    Panel1: TPanel;
    ProgrammersMessageMemo: TMemo;
    ProgrammersMessageEdit: TEdit;
    MevcutTempSilinmesinOrdanGeriYuklensinItem: TdxBarButton;
    cxStyleBarMemoEdit: TcxStyle;
    OnCalcTestItem: TdxBarButton;
    ProgramciTimer: TTimer;
    TESTBtn: TdxBarButton;
    cxStyleSeperator: TcxStyle;
    procedure TablolarItemClick(Sender: TObject);
    procedure TablolariOlusturItemClick(Sender: TObject);
    procedure UserTablesScriptItemClick(Sender: TObject);
    procedure BackupPROGRAMCIDatabaseItemClick(Sender: TObject);
    procedure TestItemClick(Sender: TObject);
    procedure MessagesTestItemClick(Sender: TObject);
    procedure SchemaNamesItemClick(Sender: TObject);
    procedure SelectionsItemClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MetaDataItemClick(Sender: TObject);
    procedure PASDosyalariniDuzenleItemClick(Sender: TObject);
    procedure dxBarManagerClickItem(Sender: TdxBarManager;
      ClickedItem: TdxBarItem);
    procedure UserTablesItemClick(Sender: TObject);
    procedure VeriGirisleriItemClick(Sender: TObject);
    procedure ProgramDatasiniOlusturItemClick(Sender: TObject);
    procedure ProgramciyaMesajlarBariniGosterItemClick(Sender: TObject);
    procedure ButunMenulariAcItemClick(Sender: TObject);
    procedure TabloGruplariItemClick(Sender: TObject);
    procedure ButunTablolariAcKapatItemClick(Sender: TObject);
    procedure ButunTablolariveMenuleriAcveKapatItemClick(Sender: TObject);
    procedure OnCalcTestItemClick(Sender: TObject);
    procedure ProgramciTimerTimer(Sender: TObject);
    procedure TESTBtnClick(Sender: TObject);
  private
  public
    ProgrammerStringLists       : array[0..60 - 1] of TStringList;
    ProgrammerSortedStringLists : array[0..10 - 1] of TStringList;

    procedure TablolariOlustur(const aJustShowSQLScripts: Boolean; const aTablolariSonraTemptenGeriYukle: Boolean);
    procedure ProgramDatasiniOlustur;
  end;

var
  ProgrammerForm: TProgrammerForm;

  DatabaseUpgradeCode: Int64 = 0;

procedure StartSQLLoggingMessagePanel;
procedure StopSQLLoggingMessagePanel;

implementation

{$R *.dfm}

uses
  M_Consts,
  M_Strings,
  M_cxGrid,
  M_Databases,
  M_F_Databases,
  M_F_Forms_cxGridMain,
  M_F_Forms_Main,
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
  M_Variants,
  M_F_ExcelEditor,
  Genel,
  ProgrammerData,
  SQLCommands,
  ProgramGirisi,
  Events,
  Main;

var
  SQLLoggingMessage: record
    Active          : Boolean;
    StartTime       : TDateTime;
    Count           : Int64;
    AffectedCount   : Int64;
    ExecSQLElapsed  : TDateTime;
    ElapsedDateTime : TDateTime;
  end = (Active     : FALSE);

procedure StartSQLLoggingMessagePanel;
begin
  if not TheProgrammersComputer or not Assigned(ProgrammerForm) then
  begin
    SQLLoggingMessage.Active := FALSE;
    Exit;
  end;

  ProgrammerForm.ProgrammersMessageLabel.Caption := '';
  ProgrammerForm.ProgrammersMessageEdit.Text     := '';
  ProgrammerForm.ProgrammersMessageMemo.Lines.Clear;

  ProgrammerForm.ProgrammersMessagePanel.Parent  := Application.MainForm;
  ProgrammerForm.ProgrammersMessagePanel.Align   := alClient;
  ProgrammerForm.ProgrammersMessagePanel.Visible := TRUE;
  ProgrammerForm.ProgrammersMessagePanel.BringToFront;

  SQLLoggingMessage.Active          := TRUE;
  SQLLoggingMessage.Count           := 0;
  SQLLoggingMessage.AffectedCount   := 0;
  SQLLoggingMessage.StartTime       := Now;
  SQLLoggingMessage.ExecSQLElapsed  := 0;
  SQLLoggingMessage.ElapsedDateTime := SQLLoggingMessage.StartTime;

  AddToMessageLog('SQL Logging', 'SQLLoggingMessage başladı...');
end;

procedure StopSQLLoggingMessagePanel;
begin
  SQLLoggingMessage.Active := FALSE;

  if not TheProgrammersComputer or not Assigned(ProgrammerForm) then Exit;

  ProgrammerForm.ProgrammersMessagePanel.Visible := FALSE;

  AddToMessageLog('SQL Logging', 'SQLLoggingMessage bitti... İşlem sayısı: ' + FormatInt(SQLLoggingMessage.Count) + ', Etkilenen: ' + FormatInt(SQLLoggingMessage.AffectedCount) + ', ExecSQL geçen süre: ' + FormatDateTime('hh:nn:ss.zzz', Now - SQLLoggingMessage.ExecSQLElapsed));
end;

procedure MySQLLoggingMessageProc(const aStep: Integer; const aSQLLoggingInfo: TSQLLoggingInfoRecord);
var
  D1: TDateTime;
begin
  if not TheProgrammersComputer or not Assigned(ProgrammerForm) then Exit;

  if SQLLoggingMessage.Active then
  begin
    if aStep = 1 then
    begin
      Inc(SQLLoggingMessage.Count);

      D1 := Now;

      ProgrammerForm.ProgrammersMessageLabel.Caption := FormatDateTime('hh:nn:ss.zzz', D1 - SQLLoggingMessage.StartTime) + ' - ' + FormatDateTime('hh:nn:ss', D1) + ' - ' + FormatInt(SQLLoggingMessage.Count) + LB + '----------------------------------------------' + LB + aSQLLoggingInfo.SQLText;
      ProgrammerForm.ProgrammersMessageLabel.Update;
    end;

    if aStep = 2 then
    begin
      if (aSQLLoggingInfo.RowsAffected > 0) or (aSQLLoggingInfo.FinishDateTime - aSQLLoggingInfo.StartDateTime >= (OneSecond / 2)) then
      begin
        Inc(SQLLoggingMessage.AffectedCount, aSQLLoggingInfo.RowsAffected);

        D1 := aSQLLoggingInfo.FinishDateTime - aSQLLoggingInfo.StartDateTime;

        ProgrammerForm.ProgrammersMessageMemo.Lines.Add(RightAlign(FormatInt(aSQLLoggingInfo.RowsAffected), 10) + ' ' + FormatDateTime(IfThen(D1 >= OneHour, 'hh:nn:ss', 'nn:ss.zzz'), D1));
        ProgrammerForm.ProgrammersMessageMemo.Update;
      end;

      SQLLoggingMessage.ExecSQLElapsed := SQLLoggingMessage.ExecSQLElapsed + (aSQLLoggingInfo.FinishDateTime - aSQLLoggingInfo.StartDateTime);

      ProgrammerForm.ProgrammersMessageEdit.Text := RightAlign(FormatInt(SQLLoggingMessage.AffectedCount), 10) + ' ' + FormatDateTime(IfThen(SQLLoggingMessage.ExecSQLElapsed >= OneHour, 'hh:nn:ss', 'nn:ss.zzz'), SQLLoggingMessage.ExecSQLElapsed);
      ProgrammerForm.ProgrammersMessageEdit.Update;
    end;
  end;

  if SQLLoggingMessage.Active then
    if ElapsedThatTime(SQLLoggingMessage.ElapsedDateTime, 0.1) then ProgressJustCheckCanceled;
end;

function GetUserTrigger(const aTriggerID: string): string;
var
  I, J: Integer;
begin
  Result := '';

  with TStringList.Create do
  try
    Text := Trim(MyAnsiReplaceStr(ProgrammerForm.UserTablesTriggersComboBox.Items.Text, '[ApplicationSchemaName]', ApplicationSchemaName));

    for I := 0 to Count - 1 do
      if System.Pos('//' + aTriggerID + '//', Strings[I]) = 1 then
      begin
        for J := I + 1 to Count - 1 do
        begin
          Result := Result + Strings[J] + LB;
          if StringIN(TrimRight(Strings[J]), ['END', 'END;']) then Break;
        end;

        Result := Trim(Result);

        Break;
      end;
  finally
    Free;
  end;

  if Result = '' then MeAbort('function GetUserTrigger(const aTriggerID: string): string;...: ' + aTriggerID);
end;

procedure TProgrammerForm.TabloGruplariItemClick(Sender: TObject);
begin
  with TVeriGirisiForm.Create(GetCaption(Sender), Sender, TheProgrammersConnection.Name) do
  try
    if MainForm.Exists then Exit;

    DataSet(GetTable_Programmer('User Table Groups', 'Tablo Grupları'));

    Grid(0);

    CreateForm(Forms(0));

    ShowForm(TRUE);
  finally
    Free;
  end;
end;

procedure SetTablesApplicationSchemaNames(aTableNames: array of string);
var
  I, J, K: Integer;
  St1: string;
  aDataSet: TUniQuery;
  aFound: Boolean;
begin
  aDataSet := TUniQuery.Create(nil);
  try
    aDataSet.Connection := TheProgrammersConnection;

    for K := 0 to 1 do
    begin
      for I := 0 to Length(aTableNames) - 1 do
      begin
        ProgressJustCheckCanceled;

        aDataSet.Active   := FALSE;
        aDataSet.SQL.Text := 'SELECT * FROM "' + aTableNames[I] + '"';
        aDataSet.Active   := TRUE;

        while not aDataSet.Eof do
        begin
          aFound := FALSE;

          for J := 0 to aDataSet.FieldCount - 1 do
          begin
            St1 := aDataSet.Fields[J].AsString;

            if System.Pos('[ApplicationSchemaName]', St1) > 0 then
            begin
              if not aFound then aDataSet.Edit;

              aDataSet.Fields[J].AsString := MyAnsiReplaceStr(St1, '[ApplicationSchemaName]', ApplicationSchemaName);

              aFound := TRUE;
            end;
          end;

          if aFound then
          begin
            aDataSet.Post;

            if K = 1 then
            begin
              Mw_X('"' + aTableNames[I] + '" tablosunda bir sorun var. [ApplicationSchemaName] ikinci tura kalmamalıydı.');

              aDataSet.Last;
            end;
          end;

          aDataSet.Next;
        end;
      end;
    end;
  finally
    aDataSet.Free;
  end;
end;

procedure TProgrammerForm.TablolariOlustur(const aJustShowSQLScripts: Boolean; const aTablolariSonraTemptenGeriYukle: Boolean);
var
  I, J, K, M, N, aSatisAlimIndex, aLength1, aLength2: Integer;
  St1, St2, St3, St4, St5, St6, aSQLText, aAllSQLText, aTableSQLScript, aTableName, aLogFieldNames, aLogSQLText,
  aErrorMessages, aTriggerName, aWhereClause1, aWhereClause2, aSetClause,
  aIsNotNULLORANDClause, aUpdateOrForChild, aUpdateOrForParent, aForeignIdentityFieldNames,
  aChildFieldNames, aParentFieldNames, aIfConditionForParent, aWhereConditionForParent, aPrimaryKeysAsText: string;
  aAllParentRequired, aAllChildRequired: Boolean;
  aDataSets: array[0..10] of TUniQuery;
  aExecuteSQLs, aYetkiVar, aReadOnly, aHicKimse, aSystemForeignTable, aDonemIDVar, aButceIDVar, aSubButceIDVar, aRequired: Boolean;
  aTabloSiraNo: Integer;
  aKeyValues: array of Variant;
  aColumnName, aDataTypeorComputeText: string;
  aButceBaslangicAyiParentTriggerText: string;
  aDefaultValue: string;
  aCollateTextForSystemForeignTables, aTempSchemaName: string;
begin
  //User Table Groups             => Grup Sıra No, Grup
  //User Tables                   => Grup Sıra No, Tablo Sıra No, Table Name, Logging, Veri Girişi, Bands, Skip, BB Ocak Ayları, Display Key, View SQL, View Tables, Erişim
  //User Columns                  => Table Name, Sıra No, Column Name, Data Type or Compute Text, Size, Required, Primary Key, Unique Column, Default Value, Unique Columns 1, Unique Columns 2, Unique Columns 3, Check Rule 1, Check Rule 2, Check Rule 3, Properties Class, Properties Info, Band Index, Display Format, Index Column, Klon İçin
  //User Foreign Tables           => Table Name, Sıra No, Foreign Table Name, On Delete Cascade, Foreign Calc Fields, Calc Fields Pre Columns, Where For Child, Calc Fields New Names, Klon İçin
  //User Foreign Table Columns    => Table Name, Sıra No, Foreign Table Name, Column Sıra No, Column Name, Foreign Table Column, Lookup, Lookup List Field Name, Lookup Table Name, Lookup Key Field Name, Lookup Filter SQL, Lookup Filter MasterFields, Lookup Filter DetailFields, Lookup Column Name
  //User Table ExecSQLs           => Table Name, Sıra No, ExecSQL, Show Error, On Create, All Created, Before Open, After Close, Progress, Skip
  //User Table Clones             => Table Name, Replace From Text, Replace To Text, Replace From Text 2, Replace To Text 2, Replace From Text 3, Replace To Text 3, Replace From Text 4, Replace To Text 4, Replace From Text 5, Replace To Text 5, Columns To Remove
  //User Tables Ex                => Sıra No, Grup, Grup Sıra No, Tablo Sıra No, Table Name, Logging, Veri Girişi, Bands, Skip, BB Ocak Ayları, Display Key, View SQL, View Tables, Erişim, Is View, SQL Script, Has Group
  //User Columns Ex               => Table Name, Sıra No, Column Name, Data Type or Compute Text, Size, Required, Primary Key, Unique Column, Default Value, Unique Columns 1, Unique Columns 2, Unique Columns 3, Check Rule 1, Check Rule 2, Check Rule 3, Properties Class, Properties Info, Band Index, Display Format, Index Column, Klon İçin
  //User Foreign Tables Ex        => Table Name, Sıra No, Foreign Table Name, On Delete Cascade, Foreign Calc Fields, Calc Fields Pre Columns, Where For Child, Calc Fields New Names, Klon İçin, By Trigger
  //User Foreign Table Columns Ex => Table Name, Sıra No, Foreign Table Name, Column Sıra No, Column Name, Foreign Table Column, Lookup, Lookup List Field Name, Lookup Table Name, Lookup Key Field Name, Lookup Filter SQL, Lookup Filter MasterFields, Lookup Filter DetailFields, Lookup Column Name
  //User Table ExecSQLs Ex        => Table Name, Sıra No, ExecSQL, Show Error, On Create, All Created, Before Open, After Close, Progress, Skip
  //User Table Clones Ex          => Table Name, Replace From Text, Replace To Text, Replace From Text 2, Replace To Text 2, Replace From Text 3, Replace To Text 3, Replace From Text 4, Replace To Text 4, Replace From Text 5, Replace To Text 5, Columns To Remove
  //User Object Display Labels    => Object Name, English, Aynı

  aExecuteSQLs := not aJustShowSQLScripts;

  for I := 0 to Length(aDataSets) - 1 do
  begin
    aDataSets[I]            := TUniQuery.Create(nil);
    aDataSets[I].Connection := TheProgrammersConnection;
  end;

  aAllSQLText := '';

  ClearAllStringLists(ProgrammerStringLists);
  ClearAllStringLists(ProgrammerSortedStringLists);
  SetScreenCursor(crHourGlass);
  try
    aSQLText    := 'CREATE SCHEMA "' + ApplicationSchemaName + '"';
    aAllSQLText := aAllSQLText + LB2 + aSQLText;
    if aExecuteSQLs then ExecSQLTry(aSQLText, '', MainConnection);

    aSQLText    := 'CREATE SCHEMA "' + ApplicationSchemaName + 'Temp"';
    aAllSQLText := aAllSQLText + LB2 + aSQLText;
    if aExecuteSQLs then ExecSQLTry(aSQLText, '', MainConnection);

    ExecSQLTry('DROP TABLE "User Tables Ex"',                '', TheProgrammersConnection);
    ExecSQLTry('DROP TABLE "User Columns Ex"',               '', TheProgrammersConnection);
    ExecSQLTry('DROP TABLE "User Foreign Tables Ex"',        '', TheProgrammersConnection);
    ExecSQLTry('DROP TABLE "User Foreign Table Columns Ex"', '', TheProgrammersConnection);
    ExecSQLTry('DROP TABLE "User Table ExecSQLs Ex"',        '', TheProgrammersConnection);
    ExecSQLTry('DROP TABLE "User Table Clones Ex"',          '', TheProgrammersConnection);

    aSQLText := 'SELECT 10000000 AS "Sıra No", T2."Grup", T1.*, CAST(NULL AS BIT) AS "Is View", CAST(NULL AS TEXT) AS "SQL Script", CAST(''FALSE'' AS BIT) AS "Has Group" INTO "User Tables Ex" FROM "User Tables" T1 INNER JOIN "User Table Groups" T2 ON ' + 'T2."Grup Sıra No" = T1."Grup Sıra No" WHERE T1."Skip" <> ''TRUE''';
    ExecSQLTry(aSQLText, '', TheProgrammersConnection, TRUE);
    aSQLText := 'ALTER TABLE "User Tables Ex" ADD CONSTRAINT "PK User Tables Ex" PRIMARY KEY ("Table Name")';
    ExecSQLTry(aSQLText, '', TheProgrammersConnection, TRUE);

    aSQLText := 'SELECT * INTO "User Columns Ex" FROM "User Columns"';
    ExecSQLTry(aSQLText, '', TheProgrammersConnection, TRUE);
    aSQLText := 'ALTER TABLE "User Columns Ex" ADD CONSTRAINT "PK User Columns Ex" PRIMARY KEY ("Table Name", "Sıra No")';
    ExecSQLTry(aSQLText, '', TheProgrammersConnection, TRUE);

    aSQLText := 'SELECT T1.*, CAST(NULL AS BIT) AS "By Trigger" INTO "User Foreign Tables Ex" FROM "User Foreign Tables" T1';
    ExecSQLTry(aSQLText, '', TheProgrammersConnection, TRUE);
    aSQLText := 'ALTER TABLE "User Foreign Tables Ex" ADD CONSTRAINT "PK User Foreign Tables Ex" PRIMARY KEY ("Table Name", "Sıra No", "Foreign Table Name")';
    ExecSQLTry(aSQLText, '', TheProgrammersConnection, TRUE);

    aSQLText := 'SELECT * INTO "User Foreign Table Columns Ex" FROM "User Foreign Table Columns"';
    ExecSQLTry(aSQLText, '', TheProgrammersConnection, TRUE);
    aSQLText := 'ALTER TABLE "User Foreign Table Columns Ex" ADD CONSTRAINT "PK User Foreign Table Columns Ex" PRIMARY KEY ("Table Name", "Sıra No", "Foreign Table Name", "Column Sıra No")';
    ExecSQLTry(aSQLText, '', TheProgrammersConnection, TRUE);

    aSQLText := 'SELECT * INTO "User Table ExecSQLs Ex" FROM "User Table ExecSQLs" WHERE "Skip" <> ''TRUE''';
    ExecSQLTry(aSQLText, '', TheProgrammersConnection, TRUE);
    aSQLText := 'ALTER TABLE "User Table ExecSQLs Ex" ADD CONSTRAINT "PK User Table ExecSQLs Ex" PRIMARY KEY ("Table Name", "Sıra No")';
    ExecSQLTry(aSQLText, '', TheProgrammersConnection, TRUE);

    aSQLText := 'SELECT * INTO "User Table Clones Ex" FROM "User Table Clones"';
    ExecSQLTry(aSQLText, '', TheProgrammersConnection, TRUE);
    aSQLText := 'ALTER TABLE "User Table Clones Ex" ADD CONSTRAINT "PK User Table Clones Ex" PRIMARY KEY ("Table Name", "Replace From Text", "Replace To Text")';
    ExecSQLTry(aSQLText, '', TheProgrammersConnection, TRUE);


    ExecSQL('UPDATE "User Columns Ex" SET "Column Name" = "Table Name" + '' ID'' WHERE "Column Name" = ''[ID]''', '', TheProgrammersConnection);


    SetTablesApplicationSchemaNames(['User Tables Ex',
                                     'User Columns Ex',
                                     'User Foreign Tables Ex',
                                     'User Foreign Table Columns Ex',
                                     'User Table ExecSQLs Ex',
                                     'User Table Clones Ex'
                                     ]);


    aDataSets[0].Active   := FALSE;
    aDataSets[0].SQL.Text := 'SELECT * FROM "User Columns Ex" ORDER BY 1, 2, 3, 4, 5';
    aDataSets[0].Active   := TRUE;

    aDataSets[1].Active   := FALSE;
    aDataSets[1].SQL.Text := 'SELECT * FROM "User Columns Ex" WHERE 1 = 2';
    aDataSets[1].Active   := TRUE;

    while not aDataSets[0].Eof do
    begin
      St1 := aDataSets[0].FindField('Column Name').AsString;

      if System.Pos('[Ocak]', St1) < 1 then
      begin
        aDataSets[0].Next;
        Continue;
      end;

      K   := aDataSets[0].RecNo;
      St1 := aDataSets[0].FindField('Table Name').AsString;
      while not aDataSets[0].Eof do
      begin
        if aDataSets[0].FindField('Table Name').AsString <> St1 then
        begin
          aDataSets[0].Prior;
          Break;
        end;

        aDataSets[0].Next;
      end;

      while aDataSets[0].RecNo > K do
      begin
        aDataSets[0].Edit;
        aDataSets[0].FindField('Sıra No').AsInteger := aDataSets[0].FindField('Sıra No').AsInteger + 11;
        aDataSets[0].Post;
        aDataSets[0].Prior;
      end;

      aDataSets[0].RecNo := K;

      aDataSets[0].Edit;

      St1 := aDataSets[0].FindField('Column Name').AsString;
      St2 := aDataSets[0].FindField('Data Type or Compute Text').AsString;

      aDataSets[0].FindField('Column Name').AsString               := MyAnsiReplaceStr(St1, '[Ocak]', MyMonthNames[0]);
      aDataSets[0].FindField('Data Type or Compute Text').AsString := MyAnsiReplaceStr(St2, '[Ocak]', MyMonthNames[0]);

      aDataSets[0].Post;

      for I := 1 to 12 - 1 do
      begin
        aDataSets[1].Append;

        for J := 0 to aDataSets[1].FieldCount - 1 do
          if aDataSets[1].Fields[J].CanModify then aDataSets[1].Fields[J].Value := aDataSets[0].Fields[J].Value;

        aDataSets[1].FindField('Sıra No').AsInteger                  := aDataSets[0].FindField('Sıra No').AsInteger + I;
        aDataSets[1].FindField('Column Name').AsString               := MyAnsiReplaceStr(St1, '[Ocak]', MyMonthNames[I]);
        aDataSets[1].FindField('Data Type or Compute Text').AsString := MyAnsiReplaceStr(St2, '[Ocak]', MyMonthNames[I]);

        aDataSets[1].Post;
      end;

      aDataSets[0].Next;
    end;


    aDataSets[0].Active   := FALSE;
    aDataSets[0].SQL.Text := 'SELECT * FROM "User Tables Ex" ORDER BY "Grup Sıra No", "Tablo Sıra No", "Sıra No", "Table Name"';
    aDataSets[0].Active   := TRUE;

    if aDataSets[0].RecordCount = 0 then MwAbort('Tablo yok...');

    aTabloSiraNo := 0;

    aButceBaslangicAyiParentTriggerText := '';

    while not aDataSets[0].Eof do
    begin
      Inc(aTabloSiraNo);

      aPrimaryKeysAsText := '';

      aDataSets[0].Edit;
      aDataSets[0].FindField('Sıra No').AsInteger := aTabloSiraNo;

      ProgrammerStringLists[11].Text := aDataSets[0].FindField('View SQL').AsString;

      for J := ProgrammerStringLists[11].Count - 1 downto 0 do
        if System.Pos('//', Trim(ProgrammerStringLists[11][J])) = 1 then ProgrammerStringLists[11].Delete(J);

      St1 := Trim(ProgrammerStringLists[11].Text);

      if St1 = '' then
        aDataSets[0].FindField('View SQL').Value := NULL
      else
        aDataSets[0].FindField('View SQL').AsString := St1;

      aDataSets[0].FindField('Is View').AsBoolean := St1 <> '';
      aDataSets[0].Post;

      aTableName := aDataSets[0].FindField('Table Name').AsString;

      for J := 11 to 50 - 1 do ProgrammerStringLists[J].Clear;

      //User Table Clones Ex          => Table Name, Replace From Text, Replace To Text, Replace From Text 2, Replace To Text 2, Replace From Text 3, Replace To Text 3, Replace From Text 4, Replace To Text 4, Replace From Text 5, Replace To Text 5, Columns To Remove
      //User Foreign Tables Ex        => Table Name, Sıra No, Foreign Table Name, On Delete Cascade, Foreign Calc Fields, Calc Fields Pre Columns, Where For Child, Calc Fields New Names, Klon İçin, By Trigger
      //User Foreign Table Columns Ex => Table Name, Sıra No, Foreign Table Name, Column Sıra No, Column Name, Foreign Table Column, Lookup, Lookup List Field Name, Lookup Table Name, Lookup Key Field Name, Lookup Filter SQL, Lookup Filter MasterFields, Lookup Filter DetailFields, Lookup Column Name

      aDataSets[5].Active   := FALSE;
      aDataSets[5].SQL.Text := 'SELECT * FROM "User Table Clones Ex" WHERE "Table Name" = ''' + aTableName + ''' ORDER BY 1, 2, 3';
      aDataSets[5].Active   := TRUE;

      while not aDataSets[5].Eof do
      begin
        St3 := SetAndGetFieldNames(aDataSets[5].FindField('Columns To Remove').AsString, ';');
        if St3 <> '' then St3 := ';' + St3 + ';';

        for I := 0 to 5 - 1 do
        begin
          case I of
            1: St1 := 'User Columns Ex';
            2: St1 := 'User Foreign Tables Ex';
            3: St1 := 'User Foreign Table Columns Ex';
            4: St1 := 'User Table ExecSQLs Ex';
          else
            St1 := 'User Tables Ex';
          end;

          aDataSets[6].Active   := FALSE;
          aDataSets[6].SQL.Text := 'SELECT * FROM "' + St1 + '" WHERE "Table Name" = ''' + aDataSets[5].FindField('Table Name').AsString + '''';
          aDataSets[6].Active   := TRUE;

          aDataSets[7].Active   := FALSE;
          aDataSets[7].SQL.Text := 'SELECT * FROM "' + St1 + '" WHERE 1 = 2';
          aDataSets[7].Active   := TRUE;

          while not aDataSets[6].Eof do
          begin
            if (St3 <> '') and (I in [1, 3]) then
              if System.Pos(';' + aDataSets[6].FindField('Column Name').AsString + ';', St3) > 0 then
              begin
                aDataSets[6].Next;
                Continue;
              end;

            aDataSets[7].Insert;

            for J := 0 to aDataSets[7].FieldCount - 1 do
              if aDataSets[7].Fields[J].CanModify then
              begin
                aDataSets[7].Fields[J].Value := aDataSets[6].Fields[J].Value;

                St2 := aDataSets[7].Fields[J].AsString;

                if St2 <> '' then
                begin
                  St2 := MyAnsiReplaceStr(St2, aDataSets[5].FindField('Replace From Text').AsString,   aDataSets[5].FindField('Replace To Text').AsString);
                  St2 := MyAnsiReplaceStr(St2, aDataSets[5].FindField('Replace From Text 2').AsString, aDataSets[5].FindField('Replace To Text 2').AsString);
                  St2 := MyAnsiReplaceStr(St2, aDataSets[5].FindField('Replace From Text 3').AsString, aDataSets[5].FindField('Replace To Text 3').AsString);
                  St2 := MyAnsiReplaceStr(St2, aDataSets[5].FindField('Replace From Text 4').AsString, aDataSets[5].FindField('Replace To Text 4').AsString);
                  St2 := MyAnsiReplaceStr(St2, aDataSets[5].FindField('Replace From Text 5').AsString, aDataSets[5].FindField('Replace To Text 5').AsString);

                  if aDataSets[7].Fields[J].AsString <> St2 then aDataSets[7].Fields[J].AsString := St2;
                end;
              end;

            if I = 0 then aDataSets[7].FindField('Sıra No').AsInteger := 10000000;

            if I in [1, 2] then aDataSets[7].FindField('Klon İçin').AsBoolean := FALSE;

            aDataSets[7].Post;

            aDataSets[6].Next;
          end;
        end;

        aDataSets[5].Next;
      end;

      if aDataSets[5].RecordCount > 0 then
      begin
        aDataSets[0].Refresh;
        if aDataSets[0].FindField('Sıra No').AsInteger <> aTabloSiraNo then
        begin
          Me('Tablo sıra no düzgün değil (2)... Baştan sıra numarası aranacak...');

          aDataSets[0].First;
          while not aDataSets[0].Eof do
          begin
            if aDataSets[0].FindField('Sıra No').AsInteger = aTabloSiraNo then Break;

            aDataSets[0].Next;
          end;

          if aDataSets[0].FindField('Sıra No').AsInteger <> aTabloSiraNo then Me('Yazılım hatası!!!! Tablo sıra no bulunamadı...');
        end;
      end;                                                                                             

      ExecSQL('DELETE FROM "User Columns Ex" WHERE "Table Name" = ''' + aTableName + ''' AND "Klon İçin" = ''TRUE''', '', TheProgrammersConnection);
      ExecSQL('DELETE FROM "User Foreign Tables Ex" WHERE "Table Name" = ''' + aTableName + ''' AND "Klon İçin" = ''TRUE''', '', TheProgrammersConnection);

      aSQLText :=
        'DELETE FROM "User Foreign Tables Ex"' + LB +
        'FROM "User Foreign Tables Ex" T1' + LB +
        'WHERE NOT EXISTS (SELECT 1 AS KOD FROM "User Foreign Table Columns Ex" T2 WHERE T2."Table Name" = T1."Table Name" AND T2."Sıra No" = T1."Sıra No" AND T2."Foreign Table Name" = T1."Foreign Table Name")';

      ExecSQL(aSQLText, '', TheProgrammersConnection);

      aDataSets[6].Active   := FALSE;
      aDataSets[6].SQL.Text := 'SELECT * FROM "User Columns Ex" WHERE "Table Name" = ''' + aTableName + '''';
      aDataSets[6].Active   := TRUE;

      while not aDataSets[6].Eof do
      begin
        //Yıl, Ay

        St1 := aDataSets[6].FindField('Data Type or Compute Text').AsString;

        if StringIN(St1, ['Yıl', 'Ay']) then
        begin
          aDataSets[6].Edit;
          aDataSets[6].FindField('Data Type or Compute Text').AsString := 'INTEGER';
          aDataSets[6].FindField('Size').AsInteger                     := 0;

          if St1 = 'Ay' then
            St2 := '"[COLUMNNAME]" BETWEEN 1 AND 12'
          else
            St2 := '"[COLUMNNAME]" BETWEEN 1900 AND 9999';

          if not aDataSets[6].FindField('Required').AsBoolean then St2 := '"[COLUMNNAME]" IS NULL OR ' + St2;

          St3 := '';
          if aDataSets[6].FindField('Check Rule 1').AsString = '' then
            St3 := 'Check Rule 1'
          else
            if aDataSets[6].FindField('Check Rule 2').AsString = '' then
              St3 := 'Check Rule 2'
            else
              if aDataSets[6].FindField('Check Rule 3').AsString = '' then St3 := 'Check Rule 3';

          if St3 = '' then
          begin
            aDataSets[6].FindField('Check Rule 1').AsString := '(' + aDataSets[6].FindField('Check Rule 1').AsString + ') AND (' + St2 + ')';

            Mwe('Check Rule problemi... Üçü de dolu... Yıl, Ay...: ' + aDataSets[6].FindField('Table Name').AsString + ', ' + aDataSets[6].FindField('Column Name').AsString);
          end
          else
            aDataSets[6].FindField(St3).AsString := St2;

          aDataSets[6].Post;
        end;

        aDataSets[6].Next;
      end;

      if Trim(aDataSets[0].FindField('View SQL').AsString) <> '' then
      begin
        aSQLText        := 'DROP VIEW "' + ApplicationSchemaName + '"."' +  aTableName + '"';
        aAllSQLText     := aAllSQLText + LB2 + aSQLText;
        aTableSQLScript := aSQLText;
        if aExecuteSQLs then ExecSQLTry(aSQLText, '', MainConnection);

        aSQLText        := ExpandOcaks(Trim(aDataSets[0].FindField('View SQL').AsString));
        aAllSQLText     := aAllSQLText + LB2 + aSQLText;
        aTableSQLScript := aTableSQLScript + LB2 + aSQLText;
        if aExecuteSQLs then
        try
          ExecSQL(aSQLText, '', MainConnection);
        except
          on Ex: Exception do
          begin
            Me(ExceptionMessage(Ex));
            ProgrammerStringLists[9].Add(MyEncodeText(aSQLText));
          end;
        end;

        aDataSets[0].Edit;
        aDataSets[0].FindField('View SQL').AsString   := aSQLText;
        aDataSets[0].FindField('SQL Script').AsString := aTableSQLScript;
        aDataSets[0].Post;
      end
      else
      begin
        aDataSets[1].Active   := FALSE;
        aDataSets[1].SQL.Text := 'SELECT * FROM "User Columns Ex" WHERE "Table Name" = ''' + aTableName + ''' ORDER BY 1, 2, 3';
        aDataSets[1].Active   := TRUE;

        if aDataSets[1].RecordCount = 0 then
        begin
          aDataSets[0].Next;
          Continue;
        end;

        aLength1 := 0;
        aLength2 := 0;

        aYetkiVar   := FALSE;
        aButceIDVar := FALSE;
        aDonemIDVar := FALSE;

        aHicKimse := aDataSets[0].FindField('Erişim').AsString = 'Hiçkimse';
        aReadOnly := aDataSets[0].FindField('Erişim').AsString = 'Admin';

        while not aDataSets[1].Eof do
        begin
          aColumnName            := aDataSets[1].FindField('Column Name').AsString;
          aDataTypeorComputeText := aDataSets[1].FindField('Data Type or Compute Text').AsString;

          if not StringIN(aTableName, ['Yetki', 'Yetki Kullanıcı']) then
            if aColumnName = 'Yetki ID' then aYetkiVar := TRUE;

          if aColumnName = 'Bütçe ID' then aButceIDVar := TRUE;
          if aColumnName = 'Dönem ID' then aDonemIDVar := TRUE;

          J := Length(aColumnName) + 3;
          if J > aLength1 then aLength1 := J;

          K := 0;
          if aDataTypeorComputeText = 'NVARCHAR'      then K := Length('NVARCHAR(' + aDataSets[1].FindField('Size').AsString + ')');
          if aDataTypeorComputeText = 'INTEGER'       then K := Length('INTEGER');
          if aDataTypeorComputeText = 'IDENTITY'      then K := Length('INTEGER IDENTITY (1, 1)');
          if aDataTypeorComputeText = 'FLOAT'         then K := Length('FLOAT');
          if aDataTypeorComputeText = 'BIT'           then K := Length('BIT');
          if aDataTypeorComputeText = 'BIGIDENTITY'   then K := Length('BIGINT IDENTITY (1, 1)');
          if aDataTypeorComputeText = 'BIGINT'        then K := Length('BIGINT');
          if aDataTypeorComputeText = 'DATE'          then K := Length('DATE');
          if aDataTypeorComputeText = 'TIME'          then K := Length('TIME');
          if aDataTypeorComputeText = 'DATETIME'      then K := Length('DATETIME');
          if aDataTypeorComputeText = 'NVARCHARMAX'   then K := Length('NVARCHAR(MAX)');
          if aDataTypeorComputeText = 'NVARBINARYMAX' then K := Length('NVARBINARY(MAX)');

          if K > aLength2 then aLength2 := K;

          aDataSets[1].Next;
        end;

        aSQLText                   := '';
        aLogSQLText                := '';
        aLogFieldNames             := '';
        aForeignIdentityFieldNames := '';

        aDataSets[1].First;
        while not aDataSets[1].Eof do
        begin
          aColumnName            := aDataSets[1].FindField('Column Name').AsString;
          aDataTypeorComputeText := aDataSets[1].FindField('Data Type or Compute Text').AsString;

          if aSQLText = '' then
            aSQLText := 'CREATE TABLE "' + ApplicationSchemaName + '"."' + aTableName + '" (' + LB
          else
            aSQLText := aSQLText + ',' + LB;

          St1 := '';
          if aDataTypeorComputeText = 'NVARCHAR'      then St1 := '             ' + LeftAlign('"' + aColumnName + '"', aLength1) + LeftAlign('NVARCHAR(' + aDataSets[1].FindField('Size').AsString + ')', aLength2);
          if aDataTypeorComputeText = 'INTEGER'       then St1 := '             ' + LeftAlign('"' + aColumnName + '"', aLength1) + LeftAlign('INTEGER', aLength2);
          if aDataTypeorComputeText = 'IDENTITY'      then St1 := '             ' + LeftAlign('"' + aColumnName + '"', aLength1) + LeftAlign('INTEGER IDENTITY (1, 1)', aLength2);
          if aDataTypeorComputeText = 'FLOAT'         then St1 := '             ' + LeftAlign('"' + aColumnName + '"', aLength1) + LeftAlign('FLOAT', aLength2);
          if aDataTypeorComputeText = 'BIT'           then St1 := '             ' + LeftAlign('"' + aColumnName + '"', aLength1) + LeftAlign('BIT', aLength2);
          if aDataTypeorComputeText = 'BIGIDENTITY'   then St1 := '             ' + LeftAlign('"' + aColumnName + '"', aLength1) + LeftAlign('BIGINT IDENTITY (1, 1)', aLength2);
          if aDataTypeorComputeText = 'BIGINT'        then St1 := '             ' + LeftAlign('"' + aColumnName + '"', aLength1) + LeftAlign('BIGINT', aLength2);
          if aDataTypeorComputeText = 'DATE'          then St1 := '             ' + LeftAlign('"' + aColumnName + '"', aLength1) + LeftAlign('DATE', aLength2);
          if aDataTypeorComputeText = 'TIME'          then St1 := '             ' + LeftAlign('"' + aColumnName + '"', aLength1) + LeftAlign('TIME', aLength2);
          if aDataTypeorComputeText = 'DATETIME'      then St1 := '             ' + LeftAlign('"' + aColumnName + '"', aLength1) + LeftAlign('DATETIME', aLength2);
          if aDataTypeorComputeText = 'NVARCHARMAX'   then St1 := '             ' + LeftAlign('"' + aColumnName + '"', aLength1) + LeftAlign('NVARCHAR(MAX)', aLength2);
          if aDataTypeorComputeText = 'NVARBINARYMAX' then St1 := '             ' + LeftAlign('"' + aColumnName + '"', aLength1) + LeftAlign('NVARBINARY(MAX)', aLength2);

          if St1 = '' then
          begin
            K   := 0;
            St1 := '             ' + LeftAlign('"' + aColumnName + '"', aLength1) + 'AS ' + aDataTypeorComputeText;
          end
          else
            K := 1;

          aSQLText := aSQLText + St1;

          if K <> 0 then
          begin
            if aLogFieldNames <> '' then aLogFieldNames := aLogFieldNames + ', ';
            aLogFieldNames := aLogFieldNames + '"' + aColumnName + '"';

            if aForeignIdentityFieldNames <> '' then aForeignIdentityFieldNames := aForeignIdentityFieldNames + ', ';

            if aDataTypeorComputeText = 'IDENTITY' then
              aForeignIdentityFieldNames := aForeignIdentityFieldNames + 'CAST("' + aColumnName + '" AS INTEGER) AS "' + aColumnName + '"'
            else
              if aDataTypeorComputeText = 'BIGIDENTITY' then
                aForeignIdentityFieldNames := aForeignIdentityFieldNames + 'CAST("' + aColumnName + '" AS BIGINT) AS "' + aColumnName + '"'
              else
                aForeignIdentityFieldNames := aForeignIdentityFieldNames + '"' + aColumnName + '"';

            if aLength1 < 14 then
              J := 14
            else
              J := aLength1;

            if aLogSQLText = '' then
              aLogSQLText := 'CREATE TABLE "' + ApplicationSchemaName + '"."' + aTableName + ' LOG" (' + LB +
                             '             ' + LeftAlign('"Log ID"',      J) + 'BIGINT IDENTITY (1, 1) NOT NULL,' + LB +
                             '             ' + LeftAlign('"Log Type ID"', J) + 'INTEGER                NOT NULL,' + LB +
                             '             ' + LeftAlign('"Log Type"',    J) + 'AS CASE WHEN "Log Type ID" = 1 THEN ''Insert'' WHEN "Log Type ID" = 2 THEN ''Delete'' WHEN "Log Type ID" = 3 THEN ''Update-Delete'' WHEN "Log Type ID" = 4 THEN ''Update-Insert'' END,' + LB +
                             '             ' + LeftAlign('"Log User ID"', J) + 'INTEGER                NOT NULL,' + LB +
                             '             ' + LeftAlign('"Log Time"',    J) + 'DATETIME               NOT NULL,' + LB +
                             '             ' + LeftAlign('"Log Count"',   J) + 'INTEGER                NOT NULL,' + LB
            else
              aLogSQLText := aLogSQLText + ',' + LB;

            if aDataTypeorComputeText = 'IDENTITY' then
              St2 := '             ' + LeftAlign('"' + aColumnName + '"', aLength1) + 'INTEGER'
            else
              if aDataTypeorComputeText = 'BIGIDENTITY' then
                St2 := '             ' + LeftAlign('"' + aColumnName + '"', aLength1) + 'BIGINT'
              else
                St2 := St1;

            aLogSQLText := Trim(aLogSQLText + St2);

            aDefaultValue := aDataSets[1].FindField('Default Value').AsString;
            if aDefaultValue <> '' then
            begin
              if not StringIN(AnsiUpperCase(aDefaultValue), ['SYSTEM_USER']) and
                 not ((LeftStr(aDefaultValue, 1) = '''') and (RightStr(aDefaultValue, 1) = '''') and (Length(aDefaultValue) > 1)) and
                 (StringIN(aDataTypeorComputeText, ['NVARCHAR', 'NVARCHARMAX']) or StringIN(AnsiUpperCase(aDefaultValue), ['TRUE', 'FALSE'])) then aDefaultValue := '''' + aDefaultValue + '''';
              aSQLText := aSQLText + ' CONSTRAINT "DF ' + aTableName + ', ' + aColumnName + '" DEFAULT ' + aDefaultValue;
            end;

            if aDataSets[1].FindField('Required').AsBoolean           then aSQLText := aSQLText + ' NOT NULL';

            if aDataSets[1].FindField('Check Rule 1').AsString <> ''  then ProgrammerStringLists[18].Add(MyAnsiReplaceStr(aDataSets[1].FindField('Check Rule 1').AsString, '[COLUMNNAME]', aColumnName));
            if aDataSets[1].FindField('Check Rule 2').AsString <> ''  then ProgrammerStringLists[18].Add(MyAnsiReplaceStr(aDataSets[1].FindField('Check Rule 2').AsString, '[COLUMNNAME]', aColumnName));
            if aDataSets[1].FindField('Check Rule 3').AsString <> ''  then ProgrammerStringLists[18].Add(MyAnsiReplaceStr(aDataSets[1].FindField('Check Rule 3').AsString, '[COLUMNNAME]', aColumnName));

            if aDataSets[1].FindField('Check Rule 1').AsString <> ''  then ProgrammerStringLists[19].Add(aColumnName);
            if aDataSets[1].FindField('Check Rule 2').AsString <> ''  then ProgrammerStringLists[19].Add(aColumnName);
            if aDataSets[1].FindField('Check Rule 3').AsString <> ''  then ProgrammerStringLists[19].Add(aColumnName);
          end;

          if aDataSets[1].FindField('Primary Key').AsBoolean      then ProgrammerStringLists[11].Add(aColumnName);
          if aDataSets[1].FindField('Unique Column').AsBoolean    then ProgrammerStringLists[12].Add(aColumnName);
          if aDataSets[1].FindField('Index Column').AsBoolean     then ProgrammerStringLists[25].Add(MyEncodeText('CREATE INDEX "IX ' + aTableName + ', ' + aColumnName + '" ON "' + ApplicationSchemaName + '"."' + aTableName + '" ("' + aColumnName + '")'));

          if aDataSets[1].FindField('Unique Columns 1').AsBoolean then ProgrammerStringLists[13].Add(aColumnName);
          if aDataSets[1].FindField('Unique Columns 2').AsBoolean then ProgrammerStringLists[14].Add(aColumnName);
          if aDataSets[1].FindField('Unique Columns 3').AsBoolean then ProgrammerStringLists[15].Add(aColumnName);

          aSQLText := Trim(aSQLText);

          aDataSets[1].Next;
        end;


        ProgrammerStringLists[0].Add(aTableName);
        ProgrammerStringLists[1].Add(aForeignIdentityFieldNames);


        aPrimaryKeysAsText := ProgrammerStringLists[11].Text;

        if ProgrammerStringLists[11].Count > 0 then
        begin
          St1 := 'CONSTRAINT "PK ' + aTableName + '" PRIMARY KEY ("' + ProgrammerStringLists[11][0] + '"';
          for J := 1 to ProgrammerStringLists[11].Count - 1 do St1 := St1 + ', "' + ProgrammerStringLists[11][J] + '"';
          aSQLText := aSQLText + ',' + LB + St1 + ')';
        end;

        for J := 0 to ProgrammerStringLists[12].Count - 1 do aSQLText := aSQLText + ',' + LB + 'CONSTRAINT "UQ ' + aTableName + ', ' + ProgrammerStringLists[12][J] + '" UNIQUE ("' + ProgrammerStringLists[12][J] + '")';

        for M := 13 to 15 do
          if ProgrammerStringLists[M].Count > 0 then
          begin
            St1 := '"' + ProgrammerStringLists[M][0] + '"';
            for J := 1 to ProgrammerStringLists[M].Count - 1 do St1 := St1 + ', "' + ProgrammerStringLists[M][J] + '"';
            aSQLText := aSQLText + ',' + LB + 'CONSTRAINT "' + LeftStr('UQ ' + aTableName + ', ' + MyAnsiReplaceStr(St1, '"', ''), 128) + '" UNIQUE (' + St1 + ')';
          end;

        if ProgrammerStringLists[18].Count > 0 then
        begin
          ProgrammerStringLists[11].Clear;
          for J := 0 to ProgrammerStringLists[18].Count - 1 do
          begin
            St1 := ProgrammerStringLists[18][J];
            if IndexOfBySensitive(ProgrammerStringLists[11], St1) < 0 then ProgrammerStringLists[11].Add(St1);
          end;

          for J := 0 to ProgrammerStringLists[11].Count - 1 do
          begin
            St1 := '';
            for M := 0 to ProgrammerStringLists[18].Count - 1 do
              if ProgrammerStringLists[18][M] = ProgrammerStringLists[11][J] then
              begin
                if St1 <> '' then St1 := St1 + ', ';
                St1 := St1 + ProgrammerStringLists[19][M];
              end;

            aSQLText := aSQLText + ',' + LB + 'CONSTRAINT "' + LeftStr('CK ' + aTableName + ', ' + St1, 128) + '" CHECK (' + ProgrammerStringLists[11][J] + ')';
          end;
        end;


        //User Foreign Tables        => Table Name, Sıra No, Foreign Table Name, On Delete Cascade, Foreign Calc Fields, Calc Fields Pre Columns, Where For Child, Calc Fields New Names, Klon İçin
        //User Foreign Tables Ex     => Table Name, Sıra No, Foreign Table Name, On Delete Cascade, Foreign Calc Fields, Calc Fields Pre Columns, Where For Child, Calc Fields New Names, Klon İçin, By Trigger
        //User Foreign Table Columns => Table Name, Sıra No, Foreign Table Name, Column Sıra No, Column Name, Foreign Table Column, Lookup, Lookup List Field Name, Lookup Table Name, Lookup Key Field Name, Lookup Filter SQL, Lookup Filter MasterFields, Lookup Filter DetailFields, Lookup Column Name
        //User Columns               => Table Name, Sıra No, Column Name, Data Type or Compute Text, Size, Required, Primary Key, Unique Column, Default Value, Unique Columns 1, Unique Columns 2, Unique Columns 3, Check Rule 1, Check Rule 2, Check Rule 3, Properties Class, Properties Info, Band Index, Display Format, Index Column, Klon İçin

        aDataSets[2].Active   := FALSE;
        aDataSets[2].SQL.Text := 'SELECT * FROM "User Foreign Tables Ex" WHERE "Table Name" = ''' + aTableName + ''' ORDER BY 1, 2, 3';
        aDataSets[2].Active   := TRUE;

        while not aDataSets[2].Eof do
        begin
          St1 := aDataSets[2].FindField('Foreign Calc Fields').AsString;
          St2 := '';
          if St1 <> '' then
            with TStringList.Create do
            try
              Text := SetAndGetFieldNames(RemoveCharsFromText(St1, '"[]'), LB);

              for J := Count - 1 downto 0 do
              begin
                aDataSets[3].Active   := FALSE;
                aDataSets[3].SQL.Text := 'SELECT "Column Name" FROM "User Columns Ex" WHERE "Table Name" = ''' + aDataSets[2].FindField('Foreign Table Name').AsString + ''' AND "Column Name" = ''' + Strings[J] + '''';
                aDataSets[3].Active   := TRUE;
                if aDataSets[3].Fields[0].AsString <> Strings[J] then
                begin
                  St2 := 'Deleted';
                  MessageToProgrammer('"Foreign Calc Fields" alan karşılıksız: "' + Strings[J] + '", Table Name: "' + aTableName + '", Foreign Table Name: "' + aDataSets[2].FindField('Foreign Table Name').AsString + '", Foreign Calc Fields: "' + aDataSets[2].FindField('Foreign Calc Fields').AsString + '"', FALSE);
                  Delete(J);
                end;
              end;

              if St2 <> '' then
              begin
                St1 := '';
                for J := 0 to Count - 1 do
                begin
                  if J > 0 then St1 := St1 + ', ';
                  St1 := St1 + Strings[J];
                end;

                aDataSets[2].Edit;

                if St1 = '' then
                  aDataSets[2].FindField('Foreign Calc Fields').Value := NULL
                else
                  aDataSets[2].FindField('Foreign Calc Fields').AsString := St1;

                aDataSets[2].Post;
              end;
             finally
               Free;
             end;

          St1                   := '';
          St2                   := '';
          aWhereClause1         := '';
          aWhereClause2         := '';
          aSetClause            := '';
          aIsNotNULLORANDClause := '';
          aAllParentRequired    := TRUE;
          aAllChildRequired     := TRUE;
          aUpdateOrForChild     := '';
          aUpdateOrForParent    := '';
          aChildFieldNames      := '';
          aParentFieldNames     := '';
          aSystemForeignTable   := System.Pos('SYS.', AnsiUpperCase(aDataSets[2].FindField('Foreign Table Name').AsString)) = 1;

          if aSystemForeignTable then
            aCollateTextForSystemForeignTables := ' COLLATE database_default'
          else
            aCollateTextForSystemForeignTables := '';

          if aSystemForeignTable then
            if not ValidSQL('SELECT 1 AS KOD FROM ' + aDataSets[2].FindField('Foreign Table Name').AsString + ' WHERE 1 = 2', MainConnection) then Mw('"' + aDataSets[2].FindField('Foreign Table Name').AsString + '" tablosu sistem tablosu değil (Foreign Table Name). Yanlışlıkla sonradan oluşacak bir tabloya refere edilmiş galiba. (Tablo: "' + aTableName + '")');

          aDataSets[3].Active   := FALSE;
          aDataSets[3].SQL.Text := 'SELECT * FROM "User Foreign Table Columns Ex" WHERE "Table Name" = ''' + aTableName + ''' AND "Sıra No" = ''' + aDataSets[2].FindField('Sıra No').AsString + ''' AND "Foreign Table Name" = ''' + aDataSets[2].FindField('Foreign Table Name').AsString + ''' ORDER BY 1, 2, 3, 4, 5';
          aDataSets[3].Active   := TRUE;

          while not aDataSets[3].Eof do
          begin
            if aAllParentRequired then
            begin
              aDataSets[4].Active   := FALSE;
              aDataSets[4].SQL.Text := 'SELECT "Required" FROM "User Columns Ex" WHERE "Table Name" = ''' + aDataSets[2].FindField('Foreign Table Name').AsString + ''' AND "Column Name" = ''' + MyCoalesce([aDataSets[3].FindField('Foreign Table Column').AsString, aDataSets[3].FindField('Column Name').AsString]) + '''';
              aDataSets[4].Active   := TRUE;
              if not aDataSets[4].Fields[0].AsBoolean then aAllParentRequired := FALSE;
            end;

            if aAllChildRequired then
            begin
              aDataSets[4].Active   := FALSE;
              aDataSets[4].SQL.Text := 'SELECT "Required" FROM "User Columns Ex" WHERE "Table Name" = ''' + aTableName + ''' AND "Column Name" = ''' + aDataSets[3].FindField('Column Name').AsString + '''';
              aDataSets[4].Active   := TRUE;
              if not aDataSets[4].Fields[0].AsBoolean then aAllChildRequired := FALSE;
            end;

            if St1 <> '' then St1 := St1 + ', ';
            if St2 <> '' then St2 := St2 + ', ';
            St1 := St1 + '"' + aDataSets[3].FindField('Column Name').AsString + '"';

            if aDataSets[3].FindField('Foreign Table Column').AsString = '' then
              St2 := St2 + '"' + aDataSets[3].FindField('Column Name').AsString + '"'
            else
              St2 := St2 + '"' + aDataSets[3].FindField('Foreign Table Column').AsString + '"';

            if aWhereClause1         <> '' then aWhereClause1         := aWhereClause1         + ' AND ';
            if aWhereClause2         <> '' then aWhereClause2         := aWhereClause2         + ' OR ';
            if aSetClause            <> '' then aSetClause            := aSetClause            + ',' + LB + '      ';
            if aIsNotNULLORANDClause <> '' then aIsNotNULLORANDClause := aIsNotNULLORANDClause + ' ""OR-AND"" ';
            if aUpdateOrForChild     <> '' then aUpdateOrForChild     := aUpdateOrForChild     + ' OR ';
            if aUpdateOrForParent    <> '' then aUpdateOrForParent    := aUpdateOrForParent    + ' OR ';
            if aChildFieldNames      <> '' then aChildFieldNames      := aChildFieldNames      + ', ';
            if aParentFieldNames     <> '' then aParentFieldNames     := aParentFieldNames     + ', ';

            aIsNotNULLORANDClause := aIsNotNULLORANDClause  + 'T1."' + aDataSets[3].FindField('Column Name').AsString + '" IS NOT NULL';
            aUpdateOrForChild     := aUpdateOrForChild      + 'UPDATE("' + aDataSets[3].FindField('Column Name').AsString + '")';
            aChildFieldNames      := aChildFieldNames       + '"' + aDataSets[3].FindField('Column Name').AsString + '"';

            if aDataSets[3].FindField('Foreign Table Column').AsString = '' then
            begin
              aWhereClause1      := aWhereClause1      + '((T2."' + aDataSets[3].FindField('Column Name').AsString + '" IS NULL AND T1."' + aDataSets[3].FindField('Column Name').AsString + '" IS NULL) OR (T2."' + aDataSets[3].FindField('Column Name').AsString + '"' + aCollateTextForSystemForeignTables + ' = T1."' + aDataSets[3].FindField('Column Name').AsString + '"' + aCollateTextForSystemForeignTables + '))';
              aWhereClause2      := aWhereClause2      + '(T3."' + aDataSets[3].FindField('Column Name').AsString + '" IS NULL AND T2."' + aDataSets[3].FindField('Column Name').AsString + '" IS NOT NULL) OR (T3."' + aDataSets[3].FindField('Column Name').AsString + '" IS NOT NULL AND T2."' + aDataSets[3].FindField('Column Name').AsString + '" IS NULL) OR T3."' + aDataSets[3].FindField('Column Name').AsString + '"' + aCollateTextForSystemForeignTables + ' <> T2."' + aDataSets[3].FindField('Column Name').AsString + '"' + aCollateTextForSystemForeignTables;
              aSetClause         := aSetClause         + '"' + aDataSets[3].FindField('Column Name').AsString + '" = T3."'  + aDataSets[3].FindField('Column Name').AsString + '"';
              aUpdateOrForParent := aUpdateOrForParent + 'UPDATE("' + aDataSets[3].FindField('Column Name').AsString + '")';
              aParentFieldNames  := aParentFieldNames  + '"' + aDataSets[3].FindField('Column Name').AsString + '"';
            end
            else
            begin
              aWhereClause1      := aWhereClause1      + '((T2."' + aDataSets[3].FindField('Foreign Table Column').AsString + '" IS NULL AND T1."' + aDataSets[3].FindField('Column Name').AsString + '" IS NULL) OR (T2."' + aDataSets[3].FindField('Foreign Table Column').AsString + '"' + aCollateTextForSystemForeignTables + ' = T1."' + aDataSets[3].FindField('Column Name').AsString + '"' + aCollateTextForSystemForeignTables + '))';
              aWhereClause2      := aWhereClause2      + '(T3."' + aDataSets[3].FindField('Foreign Table Column').AsString + '" IS NULL AND T2."' + aDataSets[3].FindField('Foreign Table Column').AsString + '" IS NOT NULL) OR (T3."' + aDataSets[3].FindField('Foreign Table Column').AsString + '" IS NOT NULL AND T2."' + aDataSets[3].FindField('Foreign Table Column').AsString + '" IS NULL) OR T3."' + aDataSets[3].FindField('Foreign Table Column').AsString + '"' + aCollateTextForSystemForeignTables + ' <> T2."' + aDataSets[3].FindField('Foreign Table Column').AsString + '"' + aCollateTextForSystemForeignTables;
              aSetClause         := aSetClause         + '"' + aDataSets[3].FindField('Column Name').AsString + '" = T3."'  + aDataSets[3].FindField('Foreign Table Column').AsString + '"';
              aUpdateOrForParent := aUpdateOrForParent + 'UPDATE("' + aDataSets[3].FindField('Foreign Table Column').AsString + '")';
              aParentFieldNames  := aParentFieldNames  + '"' + aDataSets[3].FindField('Foreign Table Column').AsString + '"';
            end;

            aDataSets[3].Next;
          end;

          aIsNotNULLORANDClause := MyAnsiReplaceStr(aIsNotNULLORANDClause, '""OR-AND""', IfThen(aAllParentRequired and not aAllChildRequired, 'AND', 'OR'));

          aTriggerName := '"' + ApplicationSchemaName + '"."TR FK Child, ' + aTableName + ', ' + aDataSets[2].FindField('Foreign Table Name').AsString + ' ' + aDataSets[2].FindField('Sıra No').AsString + '"';

          St4 := MyEncodeText('DROP TRIGGER ' + aTriggerName);

          St3 := GetUserTrigger('Foreign Key Child');
          St3 := MyAnsiReplaceStr(St3, '[TriggerName]',          aTriggerName);
          St3 := MyAnsiReplaceStr(St3, '[TableName]',            aTableName);
          St3 := MyAnsiReplaceStr(St3, '[ForeignTable]',         IfThen(aSystemForeignTable, '', '"' + ApplicationSchemaName + '"."') + aDataSets[2].FindField('Foreign Table Name').AsString + IfThen(aSystemForeignTable, '', '"'));
          St3 := MyAnsiReplaceStr(St3, '[WhereClause]',          aWhereClause1 + IfThen(aDataSets[2].FindField('Where For Child').AsString <> '', ' AND (' + aDataSets[2].FindField('Where For Child').AsString + ')', ''));
          St3 := MyAnsiReplaceStr(St3, '[ChildFieldNames]',      aChildFieldNames);
          St3 := MyAnsiReplaceStr(St3, '[ParentFieldNames]',     aParentFieldNames);
          St3 := MyAnsiReplaceStr(St3, '[UpdateOrForChild]',     aUpdateOrForChild + IfThen(aDataSets[2].FindField('Where For Child').AsString <> '', ' OR (1 = 1)', ''));
          St3 := MyAnsiReplaceStr(St3, '[IsNotNULLORANDClause]', aIsNotNULLORANDClause);

          St4 := St4 + TAB + MyEncodeText(St3);

          if not aSystemForeignTable then
          begin
            aTriggerName := '"' + ApplicationSchemaName + '"."TR FK Parent, ' + aDataSets[2].FindField('Foreign Table Name').AsString + ', ' + aTableName + ' ' + aDataSets[2].FindField('Sıra No').AsString + '"';

            St3 := 'DROP TRIGGER ' + aTriggerName;

            St4 := St4 + TAB + MyEncodeText(St3);

            J := ProgrammerStringLists[0].IndexOf(aDataSets[2].FindField('Foreign Table Name').AsString);
            if J > -1 then
              aForeignIdentityFieldNames := ProgrammerStringLists[1][J]
            else
              aForeignIdentityFieldNames := '';

            aWhereConditionForParent := aDataSets[2].FindField('Where For Child').AsString;
            if aWhereConditionForParent = '' then
            begin
              aWhereConditionForParent := '1 = 2';
              aIfConditionForParent    := '1 = 2';
            end
            else
            begin
              aWhereConditionForParent := 'NOT (' + aWhereConditionForParent + ')';
              aIfConditionForParent := '1 = 1';
            end;

            St3 := GetUserTrigger('Foreign Key Parent');
            St3 := MyAnsiReplaceStr(St3, '[TriggerName]',             aTriggerName);
            St3 := MyAnsiReplaceStr(St3, '[TableName]',               aTableName);
            St3 := MyAnsiReplaceStr(St3, '[ForeignTable]',            '"' + ApplicationSchemaName + '"."' + aDataSets[2].FindField('Foreign Table Name').AsString + '"');
            St3 := MyAnsiReplaceStr(St3, '[WhereClauseT2T1]',         aWhereClause1);
            St3 := MyAnsiReplaceStr(St3, '[WhereClauseT3T2NotOr]',    aWhereClause2);
            St3 := MyAnsiReplaceStr(St3, '[SetClause]',               aSetClause);
            St3 := MyAnsiReplaceStr(St3, '[ChildFieldNames]',         aChildFieldNames);
            St3 := MyAnsiReplaceStr(St3, '[ParentFieldNames]',        aParentFieldNames);
            St3 := MyAnsiReplaceStr(St3, '[UpdateOrForParent]',       aUpdateOrForParent);
            St3 := MyAnsiReplaceStr(St3, '[ON DELETE CASCADE]',       IfThen(aDataSets[2].FindField('On Delete Cascade').AsBoolean, '1', '0'));
            St3 := MyAnsiReplaceStr(St3, '[TempTableSayac]',          IntToStr(aTabloSiraNo));
            St3 := MyAnsiReplaceStr(St3, '[WhereConditionForParent]', aWhereConditionForParent);
            St3 := MyAnsiReplaceStr(St3, '[IfConditionForParent]',    aIfConditionForParent);

            if aForeignIdentityFieldNames <> '' then
              St3 := MyAnsiReplaceStr(St3, '[FieldNames]', aForeignIdentityFieldNames)
            else
              St3 := aDataSets[2].FindField('Foreign Table Name').AsString + LB + St3;

            St4 := St4 + TAB + MyEncodeText(St3);
          end;

          if aSystemForeignTable or (aDataSets[2].FindField('Where For Child').AsString <> '') then
            St3 := ''
          else
            St3 := 'ALTER TABLE "' + ApplicationSchemaName + '"."' + aTableName + '" ADD CONSTRAINT "FK ' + aTableName + ', ' + aDataSets[2].FindField('Foreign Table Name').AsString + ', ' + MyAnsiReplaceStr(St1, '"', '') + '" FOREIGN KEY (' + St1 + ') REFERENCES "' + ApplicationSchemaName + '"."' + aDataSets[2].FindField('Foreign Table Name').AsString + '" (' + St2 + ') ON UPDATE CASCADE' + IfThen(aDataSets[2].FindField('On Delete Cascade').AsBoolean, ' ON DELETE CASCADE', '');

          St4 := MyEncodeText(St3) + TAB + St4;

          ProgrammerStringLists[25].Add(St4);

          aDataSets[2].Next;
        end;

        aSQLText        := aSQLText + ')';
        aTableSQLScript := aSQLText;
        aAllSQLText     := aAllSQLText + LB2 + aSQLText;
        if aExecuteSQLs then ExecSQLTry(aSQLText, '', MainConnection, TRUE);

        for J := 0 to ProgrammerStringLists[25].Count - 1 do
        begin
          aDataSets[2].RecNo := J + 1;

          ProgrammerStringLists[26].Text := MyAnsiReplaceStr(ProgrammerStringLists[25][J], TAB, LB);

          aSQLText := MyDecodeText(ProgrammerStringLists[26][0]);

          if aSQLText <> '' then
          try
            if aExecuteSQLs then ExecSQL(aSQLText, '', MainConnection);

            aAllSQLText     := aAllSQLText + LB2 + aSQLText;
            aTableSQLScript := aTableSQLScript + LB2 + aSQLText;

            aDataSets[2].Edit;
            aDataSets[2].FindField('By Trigger').AsBoolean := FALSE;
            aDataSets[2].Post;

            if aExecuteSQLs then Continue;
          except
          end;

          for M := 1 to ProgrammerStringLists[26].Count - 1 do
          begin
            aSQLText := MyDecodeText(ProgrammerStringLists[26][M]);

            aAllSQLText     := aAllSQLText + LB2 + aSQLText;
            aTableSQLScript := aTableSQLScript + LB2 + aSQLText;

            if System.Pos('[FieldNames]', aSQLText) > 0 then
            begin
              ProgrammerStringLists[50].Add(ProgrammerStringLists[26][M]);
              Continue;
            end;

            if aExecuteSQLs then ExecSQLTry(aSQLText, '', MainConnection, System.Pos('DROP ', aSQLText) <> 1);
          end;

          aDataSets[2].Edit;
          aDataSets[2].FindField('By Trigger').AsBoolean := TRUE;
          aDataSets[2].Post;
        end;


        if aHicKimse then
        begin
          aTriggerName := '"' + ApplicationSchemaName + '"."TR ' + aTableName + ', Insert, Update, Delete, Calc"';

          aSQLText        := 'DROP TRIGGER ' + aTriggerName;
          aAllSQLText     := aAllSQLText + LB2 + aSQLText;
          aTableSQLScript := aTableSQLScript + LB2 + aSQLText;
          if aExecuteSQLs then ExecSQLTry(aSQLText, '', MainConnection);

          aSQLText := GetUserTrigger('Hiç Kimse');
          aSQLText := MyAnsiReplaceStr(aSQLText, '[TriggerName]', aTriggerName);
          aSQLText := MyAnsiReplaceStr(aSQLText, '[TableName]',   aTableName);

          aAllSQLText     := aAllSQLText + LB2 + aSQLText;
          aTableSQLScript := aTableSQLScript + LB2 + aSQLText;
          if aExecuteSQLs then ProgrammerStringLists[9].Add(MyEncodeText(aSQLText));
        end;


        if aReadOnly then
        begin
          aTriggerName := '"' + ApplicationSchemaName + '"."TR ' + aTableName + ', Insert, Update, Delete, Read Only"';

          aSQLText        := 'DROP TRIGGER ' + aTriggerName;
          aAllSQLText     := aAllSQLText + LB2 + aSQLText;
          aTableSQLScript := aTableSQLScript + LB2 + aSQLText;
          if aExecuteSQLs then ExecSQLTry(aSQLText, '', MainConnection);

          aSQLText := GetUserTrigger('Read Only');
          aSQLText := MyAnsiReplaceStr(aSQLText, '[TriggerName]',  aTriggerName);
          aSQLText := MyAnsiReplaceStr(aSQLText, '[TableName]',    aTableName);
          aSQLText := MyAnsiReplaceStr(aSQLText, '[FOR Kullanıcı]', IfThen(aTableName <> 'Kullanıcı', '', 'IF EXISTS (SELECT 1 FROM deleted WHERE "Kullanıcı" = SYSTEM_USER) SET @aErrorMessage = "' + ApplicationSchemaName + '"."FN GetDatabaseLanguageMessage" (''"' + ApplicationSchemaName + '"."Kullanıcı" tablosunda kendi kendinizi silemez ve değiştiremezsiniz. Bir yöneticiyi ' + 'ancak başka bir yönetici silebilir veya değiştirebilir.'', ''You cannot delete or update yourself in the table "' + ApplicationSchemaName + '"."Kullanıcı". Only one another administrator can delete or update other administrators.'');' + LB + '    '));

          aAllSQLText     := aAllSQLText + LB2 + aSQLText;
          aTableSQLScript := aTableSQLScript + LB2 + aSQLText;
          if aExecuteSQLs then ProgrammerStringLists[9].Add(MyEncodeText(aSQLText));
        end;


        if aYetkiVar then
        begin
          aTriggerName := '"' + ApplicationSchemaName + '"."TR ' + aTableName + ', Insert, Update, Delete, Yetki"';

          aSQLText        := 'DROP TRIGGER ' + aTriggerName;
          aAllSQLText     := aAllSQLText + LB2 + aSQLText;
          aTableSQLScript := aTableSQLScript + LB2 + aSQLText;
          if aExecuteSQLs then ExecSQLTry(aSQLText, '', MainConnection);

          aSQLText := GetUserTrigger('Yetki');
          aSQLText := MyAnsiReplaceStr(aSQLText, '[TriggerName]', aTriggerName);
          aSQLText := MyAnsiReplaceStr(aSQLText, '[TableName]',   aTableName);

          aAllSQLText     := aAllSQLText + LB2 + aSQLText;
          aTableSQLScript := aTableSQLScript + LB2 + aSQLText;
          if aExecuteSQLs then ProgrammerStringLists[9].Add(MyEncodeText(aSQLText));
        end;


        if not aHicKimse and (aDonemIDVar) and (aTableName <> 'Dönem') then
        begin
          aTriggerName := '"' + ApplicationSchemaName + '"."TR ' + aTableName + ', Insert, Update, Delete, Dönem ' + IfThen(aDonemIDVar, 'ID ', '') + 'Read Only"';

          aSQLText        := 'DROP TRIGGER ' + aTriggerName;
          aAllSQLText     := aAllSQLText + LB2 + aSQLText;
          aTableSQLScript := aTableSQLScript + LB2 + aSQLText;
          if aExecuteSQLs then ExecSQLTry(aSQLText, '', MainConnection);

          aSQLText := GetUserTrigger('Dönem Read Only');
          aSQLText := MyAnsiReplaceStr(aSQLText, '[TriggerName]', aTriggerName);
          aSQLText := MyAnsiReplaceStr(aSQLText, '[TableName]',   aTableName);
          if not aDonemIDVar then aSQLText := MyAnsiReplaceStr(aSQLText, '"Dönem ID"', '"Dönem"');

          aAllSQLText     := aAllSQLText + LB2 + aSQLText;
          aTableSQLScript := aTableSQLScript + LB2 + aSQLText;
          if aExecuteSQLs then ProgrammerStringLists[9].Add(MyEncodeText(aSQLText));
        end;


        if not aHicKimse and aButceIDVar and (aTableName <> 'Bütçe') then
        begin
          aTriggerName := '"' + ApplicationSchemaName + '"."TR ' + aTableName + ', Insert, Update, Delete, Bütçe ID Read Only"';

          aSQLText        := 'DROP TRIGGER ' + aTriggerName;
          aAllSQLText     := aAllSQLText + LB2 + aSQLText;
          aTableSQLScript := aTableSQLScript + LB2 + aSQLText;
          if aExecuteSQLs then ExecSQLTry(aSQLText, '', MainConnection);

          aSQLText := GetUserTrigger('Bütçe Read Only');
          aSQLText := MyAnsiReplaceStr(aSQLText, '[TriggerName]', aTriggerName);
          aSQLText := MyAnsiReplaceStr(aSQLText, '[TableName]',   aTableName);

          aAllSQLText     := aAllSQLText + LB2 + aSQLText;
          aTableSQLScript := aTableSQLScript + LB2 + aSQLText;
          if aExecuteSQLs then ProgrammerStringLists[9].Add(MyEncodeText(aSQLText));
        end;


        if aDataSets[0].FindField('BB Ocak Ayları').AsString <> '' then
          with TStringList.Create do
          try
            Text := SetAndGetFieldNames(aDataSets[0].FindField('BB Ocak Ayları').AsString, LB);

            if not aButceIDVar and not aDonemIDVar then Me('"BB Ocak Ayları" sorunu var. Ne "Bütçe ID" var ne de "Dönem ID". Tablo adı: "' + aTableName + '"');

            for N := 1 to 2 do
            begin
              if N = 2 then
              begin
                if not aButceIDVar or not aDonemIDVar then Break;

                aSubButceIDVar := FALSE;
              end
              else
                aSubButceIDVar := aButceIDVar;

              St3 := '';
              St4 := '';
              St5 := '';
              St6 := '';
              for I := 0 to Count - 1 do
              begin
                St1 := Strings[I];

                if System.Pos('Ocak', St1) = 0 then
                begin
                  Mw_X('if System.Pos(''Ocak'', St1) = 0 then... "BB Ocak Ayları", TableName: ' + aTableName);
                  Continue;
                end;

                aDataSets[2].Active   := FALSE;
                aDataSets[2].SQL.Text := 'SELECT * FROM "User Columns Ex" WHERE "Table Name" = ''' + aTableName + ''' AND "Column Name" = ''' + St1 + '''';
                aDataSets[2].Active   := TRUE;

                if aDataSets[2].RecordCount <> 1 then
                begin
                  Mw_X('if aDataSets[2].RecordCount <> 1 then... "BB Ocak Ayları", TableName: ' + aTableName + ', ColumnName: ' + St1);
                  Continue;
                end;

                aRequired := aDataSets[2].FindField('Required').AsBoolean;

                for J := 0 to 12 - 1 do
                begin
                  St2 := MyAnsiReplaceStr(St1, 'Ocak', MyMonthNames[J]);

                  if St3 <> '' then St3 := St3 + ', ';
                  if St4 <> '' then St4 := St4 + ' OR ';

                  if aRequired then
                  begin
                    St3 := St3 + '"' + St2 + '" = T1."' + St2 + '" * TY."' + MyMonthNames[J] + '"';
                    St4 := St4 + '(TY."' + MyMonthNames[J] + '" = 0 AND T1."' + St2 + '" <> 0)';
                  end
                  else
                  begin
                    St3 := St3 + '"' + St2 + '" = CASE WHEN TY."' + MyMonthNames[J] + '" = 0 THEN NULL ELSE T1."' + St2 + '" END';
                    St4 := St4 + '(T1."' + St2 + '" IS NOT NULL AND TY."' + MyMonthNames[J] + '" = 0)';
                  end;
                end;

                if aSubButceIDVar then
                  St5 := St5 + LB + IfThen(aRequired,
                                           ExpandOcaks('    "' + St1 + '" = T1."' + St1 + '" * CASE WHEN T3."Başlangıç Ayı" > [1] THEN 0 ELSE 1 END,', 'Ocak', '[1]'),
                                           ExpandOcaks('    "' + St1 + '" = CASE WHEN T3."Başlangıç Ayı" > [1] THEN NULL ELSE T1."' + St1 + '" END,', 'Ocak', '[1]'))
                else
                  St5 := St5 + LB + IfThen(aRequired,
                                           ExpandOcaks('    "' + St1 + '" = T1."' + St1 + '" * CASE WHEN T3."Başlangıç Ayı" > [1] THEN 0 ELSE 1 END,', 'Ocak', '[1]'),
                                           ExpandOcaks('    "' + St1 + '" = CASE WHEN T3."Başlangıç Ayı" > [1] THEN NULL ELSE T1."' + St1 + '" END,', 'Ocak', '[1]'));

                for J := 0 to 12 - 1 do
                  if aRequired then
                    St6 := St6 + LB + '    T1."' + MyAnsiReplaceStr(St1, 'Ocak', MyMonthNames[J]) + '" <> T1."' + MyAnsiReplaceStr(St1, 'Ocak', MyMonthNames[J]) + '" * CASE WHEN T3."Başlangıç Ayı" > ' + IntToStr(J + 1) + ' THEN 0 ELSE 1 END OR'
                  else
                    St6 := St6 + LB + '    (T1."' + MyAnsiReplaceStr(St1, 'Ocak', MyMonthNames[J]) + '" IS NOT NULL AND T3."Başlangıç Ayı" > ' + IntToStr(J + 1) + ') OR';
              end;

              if St5 <> '' then
                if aSubButceIDVar then
                  aButceBaslangicAyiParentTriggerText := aButceBaslangicAyiParentTriggerText + LB2 + '  UPDATE "' + ApplicationSchemaName + '"."' + aTableName + '" SET' + DeleteFromRight(St5, 1) + LB +
                                                                                                     '  FROM "' + ApplicationSchemaName + '"."' + aTableName + '" T1' + LB +
                                                                                                     '    INNER JOIN "' + ApplicationSchemaName + '"."Bütçe" T2 ON T2."Bütçe ID" = T1."Bütçe ID"' + LB +
                                                                                                     '    INNER JOIN "' + ApplicationSchemaName + '"."Dönem" T3 ON T3."Dönem" = T2."Dönem" AND T3."Başlangıç Yılı" = T1."Yıl"' + LB +
                                                                                                     '  WHERE' + DeleteFromRight(St6, 3) + ';'
                else
                  aButceBaslangicAyiParentTriggerText := aButceBaslangicAyiParentTriggerText + LB2 + '  UPDATE "' + ApplicationSchemaName + '"."' + aTableName + '" SET' + DeleteFromRight(St5, 1) + LB +
                                                                                                     '  FROM "' + ApplicationSchemaName + '"."' + aTableName + '" T1' + LB +
                                                                                                     '    INNER JOIN "' + ApplicationSchemaName + '"."Dönem" T3 ON T3."Dönem ID" = T1."Dönem ID" AND T3."Başlangıç Yılı" = T1."Yıl"' + LB +
                                                                                                     '  WHERE' + DeleteFromRight(St6, 3) + ';';

              if aSubButceIDVar then
                aTriggerName := '"' + ApplicationSchemaName + '"."TR ' + aTableName + ', Insert, Update, Bütçe Başlangıç Ayları, Bütçe ID"'
              else
                aTriggerName := '"' + ApplicationSchemaName + '"."TR ' + aTableName + ', Insert, Update, Bütçe Başlangıç Ayları, Dönem ID"';

              aSQLText        := 'DROP TRIGGER ' + aTriggerName;
              aAllSQLText     := aAllSQLText + LB2 + aSQLText;
              aTableSQLScript := aTableSQLScript + LB2 + aSQLText;
              if aExecuteSQLs then ExecSQLTry(aSQLText, '', MainConnection);

              if aSubButceIDVar then
                aSQLText := GetUserTrigger('BB Ocak Ayları Bütçe ID')
              else
                aSQLText := GetUserTrigger('BB Ocak Ayları Dönem ID');

              aSQLText := MyAnsiReplaceStr(aSQLText, '[TriggerName]',                           aTriggerName);
              aSQLText := MyAnsiReplaceStr(aSQLText, '[TableName]',                             aTableName);
              aSQLText := MyAnsiReplaceStr(aSQLText, '["Ocak" = T1."Ocak" * TY."Ocak"]',        St3);
              aSQLText := MyAnsiReplaceStr(aSQLText, '[(TY."Ocak" = 0 AND T1."Ocak" <> 0) OR]', St4);

              ProgrammerStringLists[11].Text := aPrimaryKeysAsText;

              if ProgrammerStringLists[11].Count = 0 then
                St3 := ''
              else
              begin
                St3 := LB + '      INNER JOIN inserted T9 ON T9."' + ProgrammerStringLists[11][0] + '" = T1."' + ProgrammerStringLists[11][0] + '"';
                for J := 1 to ProgrammerStringLists[11].Count - 1 do St3 := St3 + ' AND T9."' + ProgrammerStringLists[11][J] + '" = T1."' + ProgrammerStringLists[11][J] + '"';
              end;

              aSQLText := MyAnsiReplaceStr(aSQLText, '[INNER JOIN inserted T9 ON T9."" = T1.""]', St3);

              aAllSQLText     := aAllSQLText + LB2 + aSQLText;
              aTableSQLScript := aTableSQLScript + LB2 + aSQLText;
              if aExecuteSQLs then ProgrammerStringLists[9].Add(MyEncodeText(aSQLText));
            end;
          finally
            Free;
          end;


        if aDataSets[0].FindField('Logging').AsBoolean  then
        begin
          aLogSQLText := aLogSQLText + ',' + LB + 'CONSTRAINT "PK ' + aTableName + ' LOG" PRIMARY KEY ("Log ID")';
          aLogSQLText := aLogSQLText + ',' + LB + 'CONSTRAINT "FK ' + aTableName + ' LOG, Kullanıcı, Log User ID, Kullanıcı" FOREIGN KEY ("Log User ID") REFERENCES "' + ApplicationSchemaName + '"."Kullanıcı" ("Kullanıcı ID"))';

          aAllSQLText     := aAllSQLText + LB2 + aLogSQLText;
          aTableSQLScript := aTableSQLScript + LB2 + aLogSQLText;
          if aExecuteSQLs then ProgrammerStringLists[9].Add(MyEncodeText(aLogSQLText));

          aTriggerName := '"' + ApplicationSchemaName + '"."TR ' + aTableName + ', Insert, Update, Delete, LOG"';

          aSQLText        := 'DROP TRIGGER ' + aTriggerName;
          aAllSQLText     := aAllSQLText + LB2 + aSQLText;
          aTableSQLScript := aTableSQLScript + LB2 + aSQLText;
          if aExecuteSQLs then ExecSQLTry(aSQLText, '', MainConnection);

          aSQLText := GetUserTrigger('Log Tables');
          aSQLText := MyAnsiReplaceStr(aSQLText, '[TriggerName]', aTriggerName);
          aSQLText := MyAnsiReplaceStr(aSQLText, '[TableName]',   aTableName);
          aSQLText := MyAnsiReplaceStr(aSQLText, '[FieldNames]',  aLogFieldNames);

          aAllSQLText     := aAllSQLText + LB2 + aSQLText;
          aTableSQLScript := aTableSQLScript + LB2 + aSQLText;
          if aExecuteSQLs then ProgrammerStringLists[9].Add(MyEncodeText(aSQLText));

          aSQLText        := 'DROP TRIGGER "' + ApplicationSchemaName + '"."TR ' + aTableName + ' LOG, Read Only"';
          aAllSQLText     := aAllSQLText + LB2 + aSQLText;
          aTableSQLScript := aTableSQLScript + LB2 + aSQLText;
          if aExecuteSQLs then ExecSQLTry(aSQLText, '', MainConnection);

          aSQLText := GetUserTrigger('Log Tables Trigger');
          aSQLText := MyAnsiReplaceStr(aSQLText, '[TableName]', aTableName);

          aAllSQLText     := aAllSQLText + LB2 + aSQLText;
          aTableSQLScript := aTableSQLScript + LB2 + aSQLText;
          if aExecuteSQLs then ProgrammerStringLists[9].Add(MyEncodeText(aSQLText));
        end;
      end;






      //User Table ExecSQLs Ex => Table Name, Sıra No, ExecSQL, Show Error, On Create, All Created, Before Open, After Close, Progress, Skip

      aDataSets[2].Active   := FALSE;
      aDataSets[2].SQL.Text := 'SELECT * FROM "User Table ExecSQLs Ex" WHERE "Table Name" = ''' + aTableName + ''' AND "Skip" <> ''TRUE'' ORDER BY "Sıra No"';
      aDataSets[2].Active   := TRUE;

      while not aDataSets[2].Eof do
      begin
        aSQLText        := ExpandOcaks(Trim(aDataSets[2].FindField('ExecSQL').AsString));
        aAllSQLText     := aAllSQLText + LB2 + aSQLText;
        aTableSQLScript := aTableSQLScript + LB2 + aSQLText;

        if aDataSets[2].FindField('On Create').AsBoolean then
          if aExecuteSQLs then ExecSQLTry(aSQLText, '', MainConnection, aDataSets[2].FindField('Show Error').AsBoolean);

        aDataSets[2].Next;
      end;

      aDataSets[0].Edit;
      aDataSets[0].FindField('SQL Script').AsString  := aTableSQLScript;
      aDataSets[0].Post;

      aDataSets[0].Next;
    end;


    for I := 0 to ProgrammerStringLists[50].Count - 1 do
    begin
      ProgrammerStringLists[11].Text := MyDecodeText(ProgrammerStringLists[50][I]);

      St1 := ProgrammerStringLists[11][0];
      ProgrammerStringLists[11].Delete(0);

      aSQLText := ProgrammerStringLists[11].Text;

      J := ProgrammerStringLists[0].IndexOf(St1);

      if J > -1 then
        aForeignIdentityFieldNames := ProgrammerStringLists[1][J]
      else
      begin
        aForeignIdentityFieldNames := '';
        Me('J := ProgrammerStringLists[0].IndexOf(St1);...' + LB2 + St1);
      end;

      aSQLText := MyAnsiReplaceStr(aSQLText, '[FieldNames]', aForeignIdentityFieldNames);

      aAllSQLText := aAllSQLText + LB2 + aSQLText;
      if aExecuteSQLs then ExecSQLTry(aSQLText, '', MainConnection, System.Pos('DROP ', aSQLText) <> 1);
    end;


    if aExecuteSQLs then
      for I := 0 to ProgrammerStringLists[9].Count - 1 do ExecSQLTry(MyDecodeText(ProgrammerStringLists[9][I]), '', MainConnection, TRUE);


    //User Tables Ex  => Sıra No, Grup, Grup Sıra No, Tablo Sıra No, Table Name, Logging, Veri Girişi, Bands, Skip, BB Ocak Ayları, Display Key, View SQL, View Tables, Erişim, Is View, SQL Script, Has Group
    //User Columns Ex => Table Name, Sıra No, Column Name, Data Type or Compute Text, Size, Required, Primary Key, Unique Column, Default Value, Unique Columns 1, Unique Columns 2, Unique Columns 3, Check Rule 1, Check Rule 2, Check Rule 3, Properties Class, Properties Info, Band Index, Display Format, Index Column, Klon İçin

    aDataSets[0].Active   := FALSE;
    aDataSets[0].SQL.Text := 'SELECT * FROM "User Tables Ex" WHERE "Display Key" IS NOT NULL OR "View Tables" IS NOT NULL ORDER BY "Grup Sıra No", "Tablo Sıra No"';
    aDataSets[0].Active   := TRUE;

    while not aDataSets[0].Eof do
    begin
      St1 := Trim(aDataSets[0].FindField('Display Key').AsString);

      if St1 <> '' then
      begin
        if StringIN(St1, ['Unique Columns 1', 'Unique Columns 2', 'Unique Columns 3']) then
        begin
          aDataSets[1].Active   := FALSE;
          aDataSets[1].SQL.Text := 'SELECT "Column Name" FROM "User Columns Ex" WHERE "Table Name" = ''' + aDataSets[0].FindField('Table Name').AsString + ''' AND "' + St1 + '" = ''TRUE'' ORDER BY "Sıra No"';
          aDataSets[1].Active   := TRUE;

          St1 := '';
          while not aDataSets[1].Eof do
          begin
            if St1 <> '' then St1 := St1 + ';';
            St1 := St1 + aDataSets[1].FindField('Column Name').AsString;

            aDataSets[1].Next;
          end;
        end
        else
        begin
          ProgrammerStringLists[11].Text := SetAndGetFieldNames(St1, LB);

          GetFieldNames(aDataSets[0].FindField('Table Name').AsString, ProgrammerStringLists[12], ApplicationSchemaName, MainConnection);

          St1 := '';
          for I := 0 to ProgrammerStringLists[11].Count - 1 do
          begin
            if IndexOfBySensitive(ProgrammerStringLists[12], ProgrammerStringLists[11][I]) < 0 then
            begin
              Me('"Display Key" tanımlama hatası.' + LB2 + 'Table Name: ' + aDataSets[0].FindField('Table Name').AsString + LB + 'Column Name: ' + ProgrammerStringLists[11][I]);
              St1 := '';
              Break;
            end;

            if St1 <> '' then St1 := St1 + ';';
            St1 := St1 + ProgrammerStringLists[11][I];
          end;
        end;

        if Length(St1) > aDataSets[0].FindField('Display Key').Size then Me('if Length(St1) > aDataSets[0].FindField(''Display Key'').Size...' + LB2 + 'Length(St1): ' + FormatInt(Length(St1)) + LB + 'aDataSets[0].FindField(''Display Key'').Size: ' + FormatInt(aDataSets[0].FindField('Display Key').Size));
      end;

      St2 := Trim(aDataSets[0].FindField('View Tables').AsString);

      if St2 <> '' then
      begin
        ProgrammerStringLists[11].Text := SetAndGetFieldNames(St2, LB);

        St2 := '';
        for I := 0 to ProgrammerStringLists[11].Count - 1 do
        begin
          if not TableOrViewExists(ProgrammerStringLists[11][I], ApplicationSchemaName) then
          begin
            Me('"View Tables" tanımlama hatası. Tablo veya view yok.' + LB2 + 'Table Name: ' + ProgrammerStringLists[11][I] + LB2 + 'View Name: ' + aDataSets[0].FindField('Table Name').AsString);
            Continue;
          end;

          if St2 <> '' then St2 := St2 + ';';
          St2 := St2 + ProgrammerStringLists[11][I];
        end;
      end;

      if (aDataSets[0].FindField('Display Key').AsString <> St1) or (aDataSets[0].FindField('View Tables').AsString <> St2) then
      begin
        aDataSets[0].Edit;
        aDataSets[0].FindField('Display Key').Value := M_Variants.Ifthen(St1 = '', NULL, St1);
        aDataSets[0].FindField('View Tables').Value := M_Variants.Ifthen(St2 = '', NULL, St2);
        aDataSets[0].Post;
      end;

      aDataSets[0].Next;
    end;


    if aButceBaslangicAyiParentTriggerText <> '' then
    begin
      aTriggerName := '"' + ApplicationSchemaName + '"."TR Dönem, Update, Bütçe Başlangıç Ayı, Parent"';

      aTableSQLScript := '';

      aSQLText        := 'DROP TRIGGER ' + aTriggerName;
      aAllSQLText     := aAllSQLText + LB2 + aSQLText;
      aTableSQLScript := aTableSQLScript + LB2 + aSQLText;
      if aExecuteSQLs then ExecSQLTry(aSQLText, '', MainConnection);

      aSQLText := GetUserTrigger('BB Ocak Ayları Dönem Parent');
      aSQLText := MyAnsiReplaceStr(aSQLText, '[TriggerName]',                            aTriggerName);
      aSQLText := MyAnsiReplaceStr(aSQLText, '[UPDATE All Child BB Ocak Ayları Tables]', aButceBaslangicAyiParentTriggerText);

      aAllSQLText     := aAllSQLText + LB2 + aSQLText;
      aTableSQLScript := aTableSQLScript + LB2 + aSQLText;
      if aExecuteSQLs then ProgrammerStringLists[9].Add(MyEncodeText(aSQLText));

      if aExecuteSQLs then
      begin
        aDataSets[0].Active   := FALSE;
        aDataSets[0].SQL.Text := 'SELECT * FROM "User Tables Ex" WHERE "Table Name" = ''Dönem''';
        aDataSets[0].Active   := TRUE;

        aDataSets[0].Edit;
        aDataSets[0].FindField('SQL Script').AsString := aDataSets[0].FindField('SQL Script').AsString + aTableSQLScript;
        aDataSets[0].Post;
      end;
    end;


    //User Object Display Labels => Object Name, English, Aynı

    ExecSQLTry('DROP TABLE #USEROBJECTDISPLAYLABELS', '', TheProgrammersConnection);

    aSQLText := 'SELECT IDENTITY(INTEGER, 1, 1) AS "Sıra No", "Object Name", "Object Name" AS "English" INTO #USEROBJECTDISPLAYLABELS FROM "User Object Display Labels" WHERE 1 = 2';
    ExecSQLTry(aSQLText, '', TheProgrammersConnection, TRUE);

    aSQLText := 'INSERT INTO #USEROBJECTDISPLAYLABELS ("Object Name", "English") SELECT "Table Name", "Table Name" FROM "User Tables Ex" UNION SELECT DISTINCT "Column Name", "Column Name" FROM "User Columns Ex" UNION ' + 'SELECT DISTINCT "Lookup Column Name", "Lookup Column Name" FROM "User Foreign Table Columns Ex" WHERE "Lookup Column Name" IS NOT NULL';
    ExecSQLTry(aSQLText, '', TheProgrammersConnection, TRUE);

    aDataSets[0].Active   := FALSE;
    aDataSets[0].SQL.Text := 'SELECT DISTINCT "Calc Fields New Names" FROM "User Foreign Tables Ex" WHERE "Calc Fields New Names" IS NOT NULL';
    aDataSets[0].Active   := TRUE;


    aSQLText := '';

    while not aDataSets[0].Eof do
    begin
      ProgrammerStringLists[0].Text := SetAndGetFieldNames(aDataSets[0].Fields[0].AsString, LB);

      for I := 0 to ProgrammerStringLists[0].Count - 1 do
        if ProgrammerStringLists[0][I] <> '' then aSQLText := aSQLText + 'INSERT INTO #USEROBJECTDISPLAYLABELS ("Object Name", "English") VALUES (''' + ProgrammerStringLists[0][I] + ''', ''' + ProgrammerStringLists[0][I] + ''')' + LB;

      aDataSets[0].Next;
    end;

    aDataSets[0].Active   := FALSE;
    aDataSets[0].SQL.Text := 'SELECT * FROM "User Tables Ex" WHERE "Is View" = ''TRUE''';
    aDataSets[0].Active   := TRUE;

    while not aDataSets[0].Eof do
    begin
      GetFieldNames(aDataSets[0].FindField('Table Name').AsString, ProgrammerStringLists[0], AnsiUpperCase(ApplicationSchemaName), MainConnection);

      for I := 0 to ProgrammerStringLists[0].Count - 1 do
        if ProgrammerStringLists[0][I] <> '' then aSQLText := aSQLText + 'INSERT INTO #USEROBJECTDISPLAYLABELS ("Object Name", "English") VALUES (''' + ProgrammerStringLists[0][I] + ''', ''' + ProgrammerStringLists[0][I] + ''')' + LB;

      aDataSets[0].Next;
    end;

    ExecSQLTry(Trim(aSQLText), '', TheProgrammersConnection, FALSE);

    ExecSQLTry('INSERT INTO #USEROBJECTDISPLAYLABELS ("Object Name", "English") VALUES (''Toplam'', ''Total'')', '', TheProgrammersConnection, FALSE);
    ExecSQLTry('INSERT INTO #USEROBJECTDISPLAYLABELS ("Object Name", "English") VALUES (''Ortalama'', ''Average'')', '', TheProgrammersConnection, FALSE);
    ExecSQLTry('INSERT INTO #USEROBJECTDISPLAYLABELS ("Object Name", "English") VALUES (''Sıfır'', ''Zero'')', '', TheProgrammersConnection, FALSE);
    ExecSQLTry('INSERT INTO #USEROBJECTDISPLAYLABELS ("Object Name", "English") VALUES (''Hayır'', ''False'')', '', TheProgrammersConnection, FALSE);

    aDataSets[0].Active   := FALSE;
    aDataSets[0].SQL.Text := 'SELECT * FROM #USEROBJECTDISPLAYLABELS';
    aDataSets[0].Active   := TRUE;

    while not aDataSets[0].Eof do
    begin
      St1 := aDataSets[0].FindField('Object Name').AsString;
      St2 := St1;

      for I := 0 to 12 - 1 do
        if System.Pos(' ' + MyMonthNames[I], St1) > 0 then
          St2 := MyAnsiReplaceStr(St1, ' ' + MyMonthNames[I], ' ' + MyMonthNamesEnglish[I])
        else
          if System.Pos(MyMonthNames[I], St1) > 0 then St2 := MyAnsiReplaceStr(St1, MyMonthNames[I], MyMonthNamesEnglish[I]);

      if RightStr(St1, Length(' Toplam'))   = ' Toplam'   then St2 := DeleteFromRight(St1, Length('Toplam'))   + 'Total';
      if RightStr(St1, Length(' Ortalama')) = ' Ortalama' then St2 := DeleteFromRight(St1, Length('Ortalama')) + 'Average';
      if RightStr(St1, Length(' Sıfır'))    = ' Sıfır'    then St2 := DeleteFromRight(St1, Length('Sıfır'))    + 'Zero';
      if RightStr(St1, Length(' Hayır'))    = ' Hayır'    then St2 := DeleteFromRight(St1, Length('Hayır'))    + 'False';

      if St1 <> St2 then
      begin
        aDataSets[0].Edit;

        aDataSets[0].FindField('English').AsString := St2;

        aDataSets[0].Post;
      end;

      aDataSets[0].Next;
    end;

    //User Object Display Labels => Object Name, English, Aynı

    aSQLText := 'DELETE FROM "User Object Display Labels" WHERE "Object Name" NOT IN (SELECT DISTINCT "Object Name" FROM #USEROBJECTDISPLAYLABELS)';
    ExecSQLTry(aSQLText, '', TheProgrammersConnection, TRUE);

    aSQLText := 'INSERT INTO "User Object Display Labels" ("Object Name", "English") SELECT DISTINCT T1."Object Name", ' + 'T1."English" FROM #USEROBJECTDISPLAYLABELS T1 WHERE NOT EXISTS (SELECT T2."Object Name" FROM "User Object Display Labels" T2 WHERE T2."Object Name" = T1."Object Name")';
    ExecSQLTry(aSQLText, '', TheProgrammersConnection, TRUE);

    ExecSQLTry('DROP TABLE #USEROBJECTDISPLAYLABELS', '', TheProgrammersConnection);


    aDataSets[1].Active   := FALSE;
    aDataSets[1].SQL.Text := 'SELECT "Table Name" FROM "User Tables Ex" ORDER BY 1';
    aDataSets[1].Active   := TRUE;

    while not aDataSets[1].Eof do
    begin
      St1 := aDataSets[1].FindField('Table Name').AsString;

      for I := 0 to Length(InValidDatabaseObjectNameCharacters) - 1 do
        if System.Pos(InValidDatabaseObjectNameCharacters[I + 1], St1) > 0 then Mw('"Table Name" içinde şu karakterleri kullanamazsınız: ' + InValidDatabaseObjectNameCharacters + LB2 + 'Table Name: "' + St1 + '"');

      aDataSets[1].Next;
    end;

    aDataSets[1].Active   := FALSE;
    aDataSets[1].SQL.Text := 'SELECT "Table Name", "Column Name" FROM "User Columns Ex" ORDER BY "Table Name", "Sıra No"';
    aDataSets[1].Active   := TRUE;

    while not aDataSets[1].Eof do
    begin
      St1 := aDataSets[1].FindField('Column Name').AsString;

      for I := 0 to Length(InValidDatabaseObjectNameCharacters) - 1 do
        if System.Pos(InValidDatabaseObjectNameCharacters[I + 1], St1) > 0 then Mw('"Column Name" içinde şu karakterleri kullanamazsınız: ' + InValidDatabaseObjectNameCharacters + LB2 + 'Column Name: "' + St1 + '"' + LB + 'Table Name: "' + aDataSets[1].FindField('Table Name').AsString + '"');

      aDataSets[1].Next;
    end;


    try
      if aExecuteSQLs and aTablolariSonraTemptenGeriYukle then
      begin
        SetScreenCursor(crHourGlass);

        aTempSchemaName := ApplicationSchemaName + 'Temp';
        //aTempSchemaName := 'Reflex';

        //User Tables Ex => Sıra No, Grup, Grup Sıra No, Tablo Sıra No, Table Name, Logging, Veri Girişi, Bands, Skip, BB Ocak Ayları, Display Key, View SQL, View Tables, Erişim, Is View, SQL Script, Has Group

        aDataSets[0].Active   := FALSE;
        aDataSets[0].SQL.Text := 'SELECT * FROM "User Tables Ex" ORDER BY "Sıra No"';
        aDataSets[0].Active   := TRUE;

        while not aDataSets[0].Eof do
        begin
          if TableExists(aDataSets[0].FindField('Table Name').AsString, aTempSchemaName, MainConnection) then
            if QueryReturnsRecord('SELECT 1 AS KOD FROM "' + aTempSchemaName + '"."' + aDataSets[0].FindField('Table Name').AsString + '"', MainConnection) then
            try
              ExecSQLTry('DISABLE TRIGGER ALL ON "' + ApplicationSchemaName + '"."' + aDataSets[0].FindField('Table Name').AsString + '"', '', MainConnection, TRUE);
              try
                ExecSQLTry('SET IDENTITY_INSERT "' + ApplicationSchemaName + '"."' + aDataSets[0].FindField('Table Name').AsString + '" ON', '', MainConnection);

                M := 1;
                if not QueryReturnsRecord('SELECT 1 AS KOD FROM "' + ApplicationSchemaName + '"."' + aDataSets[0].FindField('Table Name').AsString + '"', MainConnection) then
                try
                  aDataSets[1].Active     := FALSE;
                  aDataSets[1].Connection := MainConnection;
                  aDataSets[1].SQL.Text   := 'SELECT * FROM "' + aTempSchemaName + '"."' + aDataSets[0].FindField('Table Name').AsString + '" WHERE 1 = 2';
                  aDataSets[1].Active     := TRUE;

                  aDataSets[2].Active     := FALSE;
                  aDataSets[2].Connection := MainConnection;
                  aDataSets[2].SQL.Text   := 'SELECT * FROM "' + ApplicationSchemaName + '"."' + aDataSets[0].FindField('Table Name').AsString + '" WHERE 1 = 2';
                  aDataSets[2].Active     := TRUE;

                  St1 := 'SELECT T1.name FROM sys.columns T1 INNER JOIN sys.objects T2 ON T2.object_id = T1.object_id INNER JOIN sys.schemas T3 ON T3.schema_id = T2.schema_id AND T3.name = ''' + ApplicationSchemaName + ''' WHERE T1.is_computed = ''TRUE'' AND T2.name = ''' + aDataSets[0].FindField('Table Name').AsString + '''';
                  SQLToStringList(St1, [], ProgrammerSortedStringLists[0]);

                  St1 := '';
                  for I := 0 to aDataSets[2].FieldCount - 1 do
                    if Assigned(aDataSets[1].FindField(aDataSets[2].Fields[I].FieldName)) then
                      if aDataSets[2].Fields[I].CanModify or aDataSets[2].Fields[I].Required then
                        if not ProgrammerSortedStringLists[0].Find(aDataSets[2].Fields[I].FieldName, J) then
                        begin
                          if St1 <> '' then St1 := St1 + ', ';
                          St1 := St1 + '"' + aDataSets[2].Fields[I].FieldName + '"';
                        end;

                  St1 := 'INSERT INTO "' + ApplicationSchemaName + '"."' + aDataSets[0].FindField('Table Name').AsString + '" (' + St1 + ') SELECT ' + St1 + ' FROM "' + aTempSchemaName + '"."' + aDataSets[0].FindField('Table Name').AsString + '"';
                  ExecSQL(St1, '', MainConnection);
                  M := 0;
                except
                  on Ex: Exception do MessageToProgrammer('"' + aDataSets[0].FindField('Table Name').AsString + '" tablosu direk kopyalanamadı. Kayıt kayıt kopyalanıyor. Hata mesajı: ' + ExceptionMessage(Ex), FALSE);
                end;

                if M = 1 then
                try
                  ExecSQLTry('SET IDENTITY_INSERT "' + ApplicationSchemaName + '"."' + aDataSets[0].FindField('Table Name').AsString + '" OFF', '', MainConnection);

                  try
                    aDataSets[1].Active     := FALSE;
                    aDataSets[1].Connection := MainConnection;
                    aDataSets[1].SQL.Text   := 'SELECT * FROM "' + aTempSchemaName + '"."' + aDataSets[0].FindField('Table Name').AsString + '"';
                    aDataSets[1].Active     := TRUE;

                    aDataSets[2].Active     := FALSE;
                    aDataSets[2].Connection := MainConnection;
                    aDataSets[2].SQL.Text   := 'SELECT * FROM "' + ApplicationSchemaName + '"."' + aDataSets[0].FindField('Table Name').AsString + '"';
                    aDataSets[2].Active     := TRUE;

                    GetPrimaryKeyFieldNamesEx(aDataSets[0].FindField('Table Name').AsString, ProgrammerStringLists[10], ApplicationSchemaName, MainConnection);

                    for I := 0 to ProgrammerStringLists[10].Count - 1 do
                      if not Assigned(aDataSets[1].FindField(ProgrammerStringLists[10][I])) then
                      begin
                        ProgrammerStringLists[10].Clear;
                        Break;
                      end;

                    St1 := '';
                    St2 := '';
                    if ProgrammerStringLists[10].Count > 0 then
                    begin
                      St1 := '"' + MyAnsiReplaceStr(Trim(ProgrammerStringLists[10].Text), LB, '";"') + '"';
                      St2 := MyAnsiReplaceStr(Trim(ProgrammerStringLists[10].Text), LB, ';');
                      aDataSets[2].IndexFieldNames := St1;
                    end;

                    SetLength(aKeyValues, ProgrammerStringLists[10].Count);

                    while not aDataSets[1].Eof do
                    begin
                      try
                        if St1 = '' then
                          aDataSets[2].Insert
                        else
                        begin
                          for I := 0 to ProgrammerStringLists[10].Count - 1 do aKeyValues[I] := aDataSets[1].FindField(ProgrammerStringLists[10][I]).Value;

                          if aDataSets[2].LocateEx(St2, aKeyValues, []) then
                            aDataSets[2].Edit
                          else
                            aDataSets[2].Insert;
                        end;

                        for I := 0 to aDataSets[1].FieldCount - 1 do
                          if Assigned(aDataSets[2].FindField(aDataSets[1].Fields[I].FieldName)) then
                            with aDataSets[2].FindField(aDataSets[1].Fields[I].FieldName) do
                              if CanModify then Value := aDataSets[1].Fields[I].Value;

                        aDataSets[2].Post;
                      except
                        on Ex: Exception do
                        begin
                          MessageToProgrammer('"' + aDataSets[0].FindField('Table Name').AsString + '" tablosu kayıt kayıt kopyalanırken hata oluştu. Hata mesajı: ' + ExceptionMessage(Ex), FALSE);
                          if aDataSets[2].State in dsEditModes then aDataSets[2].Cancel;
                        end;
                      end;

                      aDataSets[1].Next;
                    end;
                  except
                    on Ex: Exception do Me('if M = 1 then...' + LB2 + ExceptionMessage(Ex));
                  end;
                finally
                  aDataSets[1].Active := FALSE;
                  aDataSets[2].Active := FALSE;
                  aDataSets[1].Connection := aDataSets[0].Connection;
                  aDataSets[2].Connection := aDataSets[0].Connection;
                  aDataSets[2].IndexFieldNames := '';
                end;
              finally
                ExecSQLTry('SET IDENTITY_INSERT "' + ApplicationSchemaName + '"."' + aDataSets[0].FindField('Table Name').AsString + '" OFF', '', MainConnection);
              end;
            finally
              ExecSQLTry('ENABLE TRIGGER ALL ON "' + ApplicationSchemaName + '"."' + aDataSets[0].FindField('Table Name').AsString + '"', '', MainConnection, TRUE);
            end;

          aDataSets[0].Next;
        end;
      end;


      //User Tables Ex => Sıra No, Grup, Grup Sıra No, Tablo Sıra No, Table Name, Logging, Veri Girişi, Bands, Skip, BB Ocak Ayları, Display Key, View SQL, View Tables, Erişim, Is View, SQL Script, Has Group

      aSQLText := 'UPDATE "User Tables Ex" SET "Has Group" = ''TRUE'' WHERE "View SQL" IS NULL AND "Table Name" IN (SELECT REPLACE("Table Name", '' Grup'', '''') FROM "User Tables Ex" WHERE "Table Name" LIKE ''% Grup'' AND "View SQL" IS NOT NULL)';
      if aExecuteSQLs then ExecSQLTry(aSQLText, '', TheProgrammersConnection, TRUE);


      //User Tables            => Grup Sıra No, Tablo Sıra No, Table Name, Logging, Veri Girişi, Bands, Skip, BB Ocak Ayları, Display Key, View SQL, View Tables, Erişim
      //User Table ExecSQLs Ex => Table Name, Sıra No, ExecSQL, Show Error, On Create, All Created, Before Open, After Close, Progress, Skip

      aDataSets[0].Active   := FALSE;
      aDataSets[0].SQL.Text := 'SELECT T1.* FROM "User Table ExecSQLs Ex" T1 INNER JOIN "User Tables Ex" T2 ON T2."Table Name" = T1."Table Name" WHERE T1."All Created" = ''TRUE'' AND T1."Skip" <> ''TRUE'' ORDER BY T2."Grup Sıra No", T2."Tablo Sıra No", T1."Sıra No"';
      aDataSets[0].Active   := TRUE;

      while not aDataSets[0].Eof do
      begin
        aSQLText := ExpandOcaks(Trim(aDataSets[0].FindField('ExecSQL').AsString));

        if aExecuteSQLs then ExecSQLTry(aSQLText, '', MainConnection, aDataSets[0].FindField('Show Error').AsBoolean);

        aDataSets[0].Next;
      end;


      aDataSets[0].Active   := FALSE;
      aDataSets[0].SQL.Text := 'SELECT' + LB +
                               '  T1."Table Name", T1."Sıra No", T1."Foreign Table Name", T1."Column Sıra No", T1."Column Name", T1."Foreign Table Column", T2."Size", T3."Size" AS "Foreign Size"' + LB +
                               'FROM "User Foreign Table Columns Ex" T1' + LB +
                               '  INNER JOIN "User Columns Ex" T2 ON T2."Table Name" = T1."Table Name" AND T2."Column Name" = T1."Column Name"' + LB +
                               '  INNER JOIN "User Columns Ex" T3 ON T3."Table Name" = T1."Foreign Table Name" AND T3."Column Name" = COALESCE(T1."Foreign Table Column", T1."Column Name")' + LB +
                               'WHERE T2."Size" <> T3."Size"';
      aDataSets[0].Active   := TRUE;
      
      if aDataSets[0].RecordCount > 0 then
      begin
        Me(FormatInt(aDataSets[0].RecordCount) + ' adet "User Foreign Table Columns Ex" tablosu "Size" sorunu var.');
        VGM(aDataSets[0], '"User Foreign Table Columns Ex" Tablosu "Size" Sorunu...');      
      end;                                                                                  
    finally
      SIT(Trim(aAllSQLText), 'SQL...');
      MyTextToFile(aAllSQLText, TheProgramEXEPath + '\TablolariOlusturSQLScript.TXT');
    end;
  finally
    try
      for I := 0 to Length(aDataSets) - 1 do IfAssignedFreeAndNil(aDataSets[I]);
      ClearAllStringLists(ProgrammerStringLists);
      ClearAllStringLists(ProgrammerSortedStringLists);
    finally
      SetScreenCursor(crDefault);
    end;
  end;
end;

procedure TProgrammerForm.ProgramciyaMesajlarBariniGosterItemClick(Sender: TObject);
begin
  MainForm.ProgrammersBar.Visible := TRUE;
end;

procedure MemDataSetToStringListCompressing(aMemDataSet: TMemDataSet; aList: TStringList; const aTableCount: Integer);
var
  I: Integer;
  St1, aText: string;
  aStream: TStringStream;
  aSizes: array of Integer;
  aHasftStringField: Boolean;
begin
  with TVirtualTableEx.Create(nil) do
  try
    SetLength(aSizes, aMemDataSet.FieldCount);

    aHasftStringField := FALSE;
    for I := 0 to aMemDataSet.FieldCount - 1 do
      if aMemDataSet.Fields[I].DataType = ftString then
      begin
        aSizes[I] := 1;
        aHasftStringField := TRUE;
      end
      else
        aSizes[I] := aMemDataSet.Fields[I].Size;

    if aHasftStringField then
    begin
      aMemDataSet.First;
      while not aMemDataSet.Eof do
      begin
        for I := 0 to aMemDataSet.FieldCount - 1 do
          if aMemDataSet.Fields[I].DataType = ftString then
             if Length(aMemDataSet.Fields[I].AsString) > aSizes[I] then aSizes[I] := Length(aMemDataSet.Fields[I].AsString);

        aMemDataSet.Next;
      end;
    end;

    for I := 0 to aMemDataSet.FieldCount - 1 do FieldDefs.Add(aMemDataSet.Fields[I].FieldName, aMemDataSet.Fields[I].DataType, aSizes[I], aMemDataSet.Fields[I].Required);

    Active := TRUE;

    aMemDataSet.First;
    while not aMemDataSet.Eof do
    begin
      Append;
      for I := 0 to aMemDataSet.FieldCount - 1 do Fields[I].Value := aMemDataSet.Fields[I].Value;
      Post;

      aMemDataSet.Next;
    end;

    First;

    aStream := TStringStream.Create('', TEncoding.UTF8);
    try
      SaveToXML(aStream);

      aText := MyCompressTextEncoding(aStream.DataString);

      aList.Add('-' + IntToStr(aTableCount) + '-');

      repeat
        St1 := LeftStr(aText, 950);
        aText := DeleteFromLeft(aText, 950);

        if St1 <> '' then aList.Add(St1);

        if aText = '' then Break;
      until 1 = 2;
    finally
      aStream.Free;
    end;
  finally
    Free;
  end;
end;

function GetProgrammersSelectText(const aTableName: string; const aExceptFieldNames: array of string): string;
var
  I, J: Integer;
  aExcept: Boolean;
begin
  with TUniQuery.Create(nil) do
  try
    Connection := TheProgrammersConnection;
    SQL.Text   := 'SELECT * FROM "' + aTableName + '" WHERE 1 = 2';
    Active     := TRUE;

    Result := '';
    for I := 0 to FieldCount - 1 do
    begin
      aExcept := FALSE;

      for J := 0 to Length(aExceptFieldNames) - 1 do
        if Fields[I].FieldName = aExceptFieldNames[J] then
        begin
          aExcept := TRUE;
          Break;
        end;

      if aExcept then Continue;

      if Result <> '' then Result := Result + ', ';
      Result := Result + '"' + Fields[I].FieldName + '"';
    end;
  finally
    Free;
  end;
end;

procedure TProgrammerForm.ProgramDatasiniOlustur;
var
  I, J, K, M, aMaxRowCountInProcedure: Integer;
  St1, aSQLText: string;
  aDataSets: array[0..10 - 1] of TUniQuery;
  aVirtualTableEx, aVirtualTableMenuEx, aVirtualTableMenuTabloEx: TVirtualTableEx;
begin
  for I := 0 to Length(aDataSets) - 1 do
  begin
    aDataSets[I]            := TUniQuery.Create(nil);
    aDataSets[I].Connection := TheProgrammersConnection;
  end;

  aVirtualTableEx          := nil;
  aVirtualTableMenuEx      := nil;
  aVirtualTableMenuTabloEx := nil;

  //User Tables Ex                => Sıra No, Grup, Grup Sıra No, Tablo Sıra No, Table Name, Logging, Veri Girişi, Bands, Skip, BB Ocak Ayları, Display Key, View SQL, View Tables, Erişim, Is View, SQL Script, Has Group
  //User Columns Ex               => Table Name, Sıra No, Column Name, Data Type or Compute Text, Size, Required, Primary Key, Unique Column, Default Value, Unique Columns 1, Unique Columns 2, Unique Columns 3, Check Rule 1, Check Rule 2, Check Rule 3, Properties Class, Properties Info, Band Index, Display Format, Index Column, Klon İçin
  //User Foreign Tables Ex        => Table Name, Sıra No, Foreign Table Name, On Delete Cascade, Foreign Calc Fields, Calc Fields Pre Columns, Where For Child, Calc Fields New Names, Klon İçin, By Trigger
  //User Foreign Table Columns Ex => Table Name, Sıra No, Foreign Table Name, Column Sıra No, Column Name, Foreign Table Column, Lookup, Lookup List Field Name, Lookup Table Name, Lookup Key Field Name, Lookup Filter SQL, Lookup Filter MasterFields, Lookup Filter DetailFields, Lookup Column Name
  //User Table ExecSQLs Ex        => Table Name, Sıra No, ExecSQL, Show Error, On Create, All Created, Before Open, After Close, Progress, Skip
  //User Object Display Labels    => Object Name, English, Aynı

  ClearAllStringLists(ProgrammerStringLists);
  ClearAllStringLists(ProgrammerSortedStringLists);

  try
    SetScreenCursor(crHourGlass);

    aDataSets[0].Active   := FALSE;
    aDataSets[0].SQL.Text := 'SELECT "Sıra No", ' + GetProgrammersSelectText('User Tables Ex', ['Sıra No', 'Grup Sıra No', 'Tablo Sıra No', 'Skip', 'BB Ocak Ayları', 'View SQL', 'SQL Script']) + ' FROM "User Tables Ex" ORDER BY "Grup Sıra No", "Tablo Sıra No", "Table Name"';
    aDataSets[0].Active   := TRUE;

    CreateVirtualTableExFromDataSet(aDataSets[0], aVirtualTableEx, 'Temp Tablo', [], [], [], []);

    M := 0;
    while not aDataSets[0].Eof do
    begin
      Inc(M);

      aVirtualTableEx.Append;

      for I := 0 to aVirtualTableEx.FieldCount - 1 do aVirtualTableEx.Fields[I].Value := aDataSets[0].Fields[I].Value;
      aVirtualTableEx.Fields[0].AsInteger := M;

      aVirtualTableEx.Post;

      aDataSets[0].Next;
    end;

    MemDataSetToStringListCompressing(aVirtualTableEx, ProgrammerStringLists[1], 1);

    aDataSets[1].Active   := FALSE;
    aDataSets[1].SQL.Text := 'SELECT ' + GetProgrammersSelectText('User Columns Ex', ['Default Value', 'Index Column', 'Unique Columns 1', 'Unique Columns 2', 'Unique Columns 3', 'Check Rule 1', 'Check Rule 2', 'Check Rule 3']) + ', CASE WHEN "Default Value" IS NULL THEN CAST(''FALSE'' AS BIT) ELSE CAST(''TRUE'' AS BIT) END AS "Default" FROM "User Columns Ex" ORDER BY "Table Name", "Sıra No"';
    aDataSets[1].Active   := TRUE;
    MemDataSetToStringListCompressing(aDataSets[1], ProgrammerStringLists[1], 2);

    aDataSets[1].Active   := FALSE;
    aDataSets[1].SQL.Text := 'SELECT "Object Name", "English" FROM "User Object Display Labels" ORDER BY "Object Name"';
    aDataSets[1].Active   := TRUE;
    MemDataSetToStringListCompressing(aDataSets[1], ProgrammerStringLists[1], 3);

    aDataSets[1].Active   := FALSE;
    aDataSets[1].SQL.Text := 'SELECT ' + GetProgrammersSelectText('User Foreign Tables Ex', ['Where For Child']) + ' FROM "User Foreign Tables Ex" ORDER BY "Table Name", "Sıra No", "Foreign Table Name"';
    aDataSets[1].Active   := TRUE;
    MemDataSetToStringListCompressing(aDataSets[1], ProgrammerStringLists[1], 4);

    aDataSets[1].Active   := FALSE;
    aDataSets[1].SQL.Text := 'SELECT ' + GetProgrammersSelectText('User Foreign Table Columns Ex', []) + ' FROM "User Foreign Table Columns Ex" ORDER BY "Table Name", "Sıra No", "Foreign Table Name", "Column Sıra No"';
    aDataSets[1].Active   := TRUE;
    MemDataSetToStringListCompressing(aDataSets[1], ProgrammerStringLists[1], 5);

    aDataSets[1].Active   := FALSE;
    aDataSets[1].SQL.Text := 'SELECT ' + GetProgrammersSelectText('User Table ExecSQLs Ex', ['On Create', 'All Created', 'Skip']) + ' FROM "User Table ExecSQLs Ex" WHERE "Skip" <> ''TRUE'' AND ("Before Open" IS NOT NULL OR "After Close" IS NOT NULL) ORDER BY "Table Name", "Sıra No"';
    aDataSets[1].Active   := TRUE;
    MemDataSetToStringListCompressing(aDataSets[1], ProgrammerStringLists[1], 6);

    //User Ana Menü       => Sıra No, Ana Menü
    //User Menü           => Ana Menü, Sıra No, Menü, Menü English, Progress
    //User Menü Ex        => Ana Menü, Sıra No, Menü, Menü English, Progress
    //User Menü Tablo     => Menü, Sıra No, Table Name, 3x3 Index, Master Table Index, Master Field Names, Detail Field Names, Use Calc Fields, Extra ID, Read Only, Invisible Fields, Filter SQL, Caption, Grid Buttons, Read Only Fields, Refresh Master, Grid Read Only Fields, Bütçe Aç
    //User Menü Clones    => Menü, Replace From Text, Replace To Text, Replace From Text 2, Replace To Text 2, Replace From Text 3, Replace To Text 3
    //User Tables Ex      => Sıra No, Grup, Grup Sıra No, Tablo Sıra No, Table Name, Logging, Veri Girişi, Bands, Skip, BB Ocak Ayları, Display Key, View SQL, View Tables, Erişim, Is View, SQL Script, Has Group
    //User Menü Ex        => Ana Menü, Sıra No, Menü, Menü English, Progress
    //User Menü Tablo Ex  => Menü, Sıra No, Table Name, 3x3 Index, Master Table Index, Master Field Names, Detail Field Names, Use Calc Fields, Extra ID, Read Only, Invisible Fields, Filter SQL, Caption, Grid Buttons, Read Only Fields, Refresh Master, Grid Read Only Fields, Bütçe Aç
    //User Menü Clones Ex => Menü, Replace From Text, Replace To Text, Replace From Text 2, Replace To Text 2, Replace From Text 3, Replace To Text 3

    ExecSQLTry('DROP TABLE "User Menü Ex"',        '', TheProgrammersConnection);
    ExecSQLTry('DROP TABLE "User Menü Tablo Ex"',  '', TheProgrammersConnection);
    ExecSQLTry('DROP TABLE "User Menü Clones Ex"', '', TheProgrammersConnection);

    aSQLText := 'SELECT * INTO "User Menü Ex" FROM "User Menü"';
    ExecSQLTry(aSQLText, '', TheProgrammersConnection, TRUE);
    aSQLText := 'ALTER TABLE "User Menü Ex" ADD CONSTRAINT "PK User Menü Ex" PRIMARY KEY ("Menü")';
    ExecSQLTry(aSQLText, '', TheProgrammersConnection, TRUE);

    aSQLText := 'SELECT * INTO "User Menü Tablo Ex" FROM "User Menü Tablo"';
    ExecSQLTry(aSQLText, '', TheProgrammersConnection, TRUE);
    aSQLText := 'ALTER TABLE "User Menü Tablo Ex" ADD CONSTRAINT "PK User Menü Tablo Ex" PRIMARY KEY ("Menü", "Sıra No")';
    ExecSQLTry(aSQLText, '', TheProgrammersConnection, TRUE);

    aSQLText := 'SELECT * INTO "User Menü Clones Ex" FROM "User Menü Clones"';
    ExecSQLTry(aSQLText, '', TheProgrammersConnection, TRUE);
    aSQLText := 'ALTER TABLE "User Menü Clones Ex" ADD CONSTRAINT "PK User Menü Clones Ex" PRIMARY KEY ("Menü", "Replace From Text", "Replace To Text")';
    ExecSQLTry(aSQLText, '', TheProgrammersConnection, TRUE);

    aSQLText := 'INSERT INTO "User Menü Ex" ("Ana Menü", "Sıra No", "Menü", "Menü English") SELECT "Grup" AS "Ana Menü", 1 AS "Sıra No", T1."Table Name", COALESCE(T2."English", T1."Table Name") FROM "User Tables Ex" T1 ' + 'LEFT JOIN "User Object Display Labels" T2 ON T2."Object Name" = T1."Table Name" WHERE T1."Veri Girişi" = ''TRUE''';
    ExecSQLTry(aSQLText, '', TheProgrammersConnection, TRUE);

    aSQLText := 'INSERT INTO "User Menü Tablo Ex" ("Menü", "Sıra No", "Table Name", "3x3 Index", "Use Calc Fields", "Read Only", "Refresh Master") SELECT "Table Name", 1 AS "Sıra No", ' + '"Table Name", 0 AS "3x3 Index", ''TRUE'' AS "Use Calc Fields", ''FALSE'' AS "Read Only", ''FALSE'' AS "Refresh Master" FROM "User Tables Ex" ' + 'WHERE "Veri Girişi" = ''TRUE''';
    ExecSQLTry(aSQLText, '', TheProgrammersConnection, TRUE);


    SetTablesApplicationSchemaNames(['User Menü Ex',
                                     'User Menü Tablo Ex',
                                     'User Menü Clones Ex'
                                     ]);


    aDataSets[0].Active   := FALSE;
    aDataSets[0].SQL.Text := 'SELECT * FROM "User Menü Tablo Ex" WHERE 1 = 2';
    aDataSets[0].Active   := TRUE;

    St1 := '"Menü"';
    for I := 0 to aDataSets[0].FieldCount - 1 do
      if not StringIN(aDataSets[0].Fields[I].FieldName, ['Menü']) then St1 := St1 + ', "' + aDataSets[0].Fields[I].FieldName + '"';

    aDataSets[0].Active   := FALSE;
    aDataSets[0].SQL.Text := 'SELECT ' + St1 + ' FROM "User Menü Tablo Ex" WHERE 1 = 2';
    aDataSets[0].Active   := TRUE;

    CreateVirtualTableExFromDataSet(aDataSets[0], aVirtualTableMenuTabloEx, 'Temp Tablo', [], [], [], []);

    aDataSets[0].Active   := FALSE;
    aDataSets[0].SQL.Text := 'SELECT * FROM "User Menü Ex" WHERE 1 = 2';
    aDataSets[0].Active   := TRUE;

    St1 := '"Sıra No", CAST(''FALSE'' AS BIT) AS "Problem"';
    for I := 0 to aDataSets[0].FieldCount - 1 do
      if not StringIN(aDataSets[0].Fields[I].FieldName, ['Sıra No']) then St1 := St1 + ', "' + aDataSets[0].Fields[I].FieldName + '"';

    aDataSets[0].Active   := FALSE;
    aDataSets[0].SQL.Text := 'SELECT ' + St1 + ' FROM "User Menü Ex" ORDER BY "Ana Menü", "Sıra No"';
    aDataSets[0].Active   := TRUE;

    CreateVirtualTableExFromDataSet(aDataSets[0], aVirtualTableMenuEx, 'Temp Tablo', [], [], [], []);

    M := 0;
    while not aDataSets[0].Eof do
    begin
      aDataSets[2].Active   := FALSE;
      aDataSets[2].SQL.Text := 'SELECT * FROM "User Menü Clones Ex" WHERE "Menü" = ''' + aDataSets[0].FindField('Menü').AsString + ''' ORDER BY 1, 2, 3';
      aDataSets[2].Active   := TRUE;

      for K := 0 to (aDataSets[2].RecordCount + 1) - 1 do
      begin
        if K > 1 then aDataSets[2].Next;

        //User Menü           => Ana Menü, Sıra No, Menü, Menü English, Progress
        //User Menü Tablo     => Menü, Sıra No, Table Name, 3x3 Index, Master Table Index, Master Field Names, Detail Field Names, Use Calc Fields, Extra ID, Read Only, Invisible Fields, Filter SQL, Caption, Grid Buttons, Read Only Fields, Refresh Master, Grid Read Only Fields, Bütçe Aç
        //User Menü Clones Ex => Menü, Replace From Text, Replace To Text, Replace From Text 2, Replace To Text 2, Replace From Text 3, Replace To Text 3

        aDataSets[1].Active   := FALSE;
        aDataSets[1].SQL.Text := 'SELECT * FROM "User Menü Tablo Ex" WHERE "Menü" = ''' + aDataSets[0].FindField('Menü').AsString + ''' ORDER BY "Sıra No"';
        aDataSets[1].Active   := TRUE;

        if aDataSets[1].RecordCount = 0 then Me('Tablo tanımlaması yapılmamış: ' + aDataSets[0].FindField('Menü').AsString);

        if K > 0 then
        begin
          aDataSets[0].Edit;

          for I := 0 to aDataSets[0].FieldCount - 1 do
          begin
            St1 := aDataSets[0].Fields[I].AsString;
            St1 := MyAnsiReplaceStr(St1, aDataSets[2].FindField('Replace From Text').AsString,   aDataSets[2].FindField('Replace To Text').AsString);
            St1 := MyAnsiReplaceStr(St1, aDataSets[2].FindField('Replace From Text 2').AsString, aDataSets[2].FindField('Replace To Text 2').AsString);
            St1 := MyAnsiReplaceStr(St1, aDataSets[2].FindField('Replace From Text 3').AsString, aDataSets[2].FindField('Replace To Text 3').AsString);

            if aDataSets[0].Fields[I].AsString <> St1 then aDataSets[0].Fields[I].AsString := St1;
          end;
        end;

        Inc(M);
        aVirtualTableMenuEx.Append;

        for I := 0 to aVirtualTableMenuEx.FieldCount - 1 do aVirtualTableMenuEx.Fields[I].Value := aDataSets[0].Fields[I].Value;

        aVirtualTableMenuEx.Fields[0].AsInteger := M;

        aVirtualTableMenuEx.Post;

        while not aDataSets[1].Eof do
        begin
          if K > 0 then
          begin
            aDataSets[1].Edit;

            for I := 0 to aDataSets[1].FieldCount - 1 do
            begin
              St1 := aDataSets[1].Fields[I].AsString;
              St1 := MyAnsiReplaceStr(St1, aDataSets[2].FindField('Replace From Text').AsString,   aDataSets[2].FindField('Replace To Text').AsString);
              St1 := MyAnsiReplaceStr(St1, aDataSets[2].FindField('Replace From Text 2').AsString, aDataSets[2].FindField('Replace To Text 2').AsString);
              St1 := MyAnsiReplaceStr(St1, aDataSets[2].FindField('Replace From Text 3').AsString, aDataSets[2].FindField('Replace To Text 3').AsString);

              if aDataSets[1].Fields[I].AsString <> St1 then aDataSets[1].Fields[I].AsString := St1;
            end;
          end;

          aVirtualTableMenuTabloEx.Append;

          for I := 0 to aVirtualTableMenuTabloEx.FieldCount - 1 do aVirtualTableMenuTabloEx.Fields[I].Value := aDataSets[1].FindField(aVirtualTableMenuTabloEx.Fields[I].FieldName).Value;

          aVirtualTableMenuTabloEx.Post;

          if K > 0 then aDataSets[1].Cancel;

          aDataSets[1].Next;
        end;

        if K > 0 then
        begin
          aDataSets[0].Cancel;
          aDataSets[1].Cancel;
        end;
      end;

      aDataSets[0].Next;
    end;

    MemDataSetToStringListCompressing(aVirtualTableMenuEx,      ProgrammerStringLists[1], 7);
    MemDataSetToStringListCompressing(aVirtualTableMenuTabloEx, ProgrammerStringLists[1], 8);

    ProgrammerStringLists[0].Add('unit ProgrammerData;');
    ProgrammerStringLists[0].Add('');
    ProgrammerStringLists[0].Add('interface');
    ProgrammerStringLists[0].Add('');
    ProgrammerStringLists[0].Add('uses');
    ProgrammerStringLists[0].Add('  Windows, SysUtils, Classes, Controls, M_Consts, Genel;');
    ProgrammerStringLists[0].Add('');
    ProgrammerStringLists[0].Add('procedure LoadProgrammersUserData;');
    ProgrammerStringLists[0].Add('');
    ProgrammerStringLists[0].Add('implementation');
    ProgrammerStringLists[0].Add('');

    aMaxRowCountInProcedure := 33;

    M := 0;
    for I := 0 to ProgrammerStringLists[1].Count - 1 do
    begin
      if I mod aMaxRowCountInProcedure = 0 then
      begin
        Inc(M);

        ProgrammerStringLists[0].Add('procedure LoadProgrammersUserData' + FormatFloat('000', M) + ';');
        ProgrammerStringLists[0].Add('begin');
        ProgrammerStringLists[0].Add('  with GenelForm.UserTableInformationsList do');
        ProgrammerStringLists[0].Add('  begin');
      end;

      St1 := ProgrammerStringLists[1][I];
      for J := Length(St1) div 200 downto 1 do System.Insert(''' + ''', St1, J * 200);

      ProgrammerStringLists[0].Add('    Add(''' + St1 + ''');');

      if (I mod aMaxRowCountInProcedure = aMaxRowCountInProcedure - 1) or (I = ProgrammerStringLists[1].Count - 1) then
      begin
        ProgrammerStringLists[0].Add('  end;');
        ProgrammerStringLists[0].Add('end;');
        ProgrammerStringLists[0].Add('');
      end;
    end;

    ProgrammerStringLists[0].Add('procedure LoadProgrammersUserData;');
    ProgrammerStringLists[0].Add('begin');

    for I := 0 to M - 1 do ProgrammerStringLists[0].Add('  LoadProgrammersUserData' + FormatFloat('000', I + 1) + ';');

    ProgrammerStringLists[0].Add('end;');
    ProgrammerStringLists[0].Add('');
    ProgrammerStringLists[0].Add('end.');

    St1 := TheProgramEXEPath + 'ProgrammerData.PAS';

    ProgrammerStringLists[1].Text := MyFileToText(St1);
    if ProgrammerStringLists[0].Text <> ProgrammerStringLists[1].Text then MyTextToFile(ProgrammerStringLists[0].Text, St1);
  finally
    try
      for I := 0 to Length(aDataSets) - 1 do IfAssignedFreeAndNil(aDataSets[I]);
      IfAssignedFreeAndNil(aVirtualTableEx);
      IfAssignedFreeAndNil(aVirtualTableMenuEx);
      IfAssignedFreeAndNil(aVirtualTableMenuTabloEx);
      ClearAllStringLists(ProgrammerStringLists);
      ClearAllStringLists(ProgrammerSortedStringLists);
    finally
      SetScreenCursor(crDefault);
    end;
  end;
end;

procedure TProgrammerForm.BackupPROGRAMCIDatabaseItemClick(Sender: TObject);
var
  I: Integer;
  St1: string;
begin
  try
    SetScreenCursor(crHourGlass);

    ExecSQL('DBCC SHRINKDATABASE ("' + ApplicationSchemaName + 'Data")');

    St1 := TheProgramEXEPath + ApplicationSchemaName + ' Data Backup\';

    MyForceDirectories(St1);

    St1 := St1 + ApplicationSchemaName + 'Data';

    MyDeleteFile(St1 + '999.BAK');

    for I := 998 downto 1 do MyRenameFile(St1 + FormatFloat('000', I) + '.BAK', St1 + FormatFloat('000', I + 1) + '.BAK');

    ExecSQL('BACKUP DATABASE "' + ApplicationSchemaName + 'Data" TO DISK = ''' + St1 + '001.BAK''');
  finally
    SetScreenCursor(crDefault);
  end;
end;

procedure TProgrammerForm.ButunMenulariAcItemClick(Sender: TObject);
var
  I, K, aTag: Integer;
begin
  aTag := TComponent(Sender).Tag;

  K := 0;
  for I := 0 to MainForm.dxBarManager.ItemCount - 1 do
    if @MainForm.dxBarManager.Items[I].OnClick = @MainForm.KullaniciItem.OnClick then Inc(K);

  ProgressStartAsExtra('Menüler aç' + IfThen(aTag = 2, 'ılıp kapat', '') + 'ılıyor', '', K, TRUE);
  try
    for I := 0 to MainForm.dxBarManager.ItemCount - 1 do
      if @MainForm.dxBarManager.Items[I].OnClick = @MainForm.KullaniciItem.OnClick then
      begin
        ProgressChangeExtraMessage('"' + MainForm.dxBarManager.Items[I].Caption + '"', TRUE);
        if ProgressCanceled then Exit;

        try
          MainForm.dxBarManager.Items[I].Click;
        except
          on Ex: Exception do Me(ExceptionMessage(Ex));
        end;

        if aTag = 2 then LastMainForm.CloseImmediately := TRUE;
      end;
  finally
    ProgressFinish;
  end;
end;

procedure TProgrammerForm.ButunTablolariAcKapatItemClick( Sender: TObject);
var
  I: Integer;
begin
  ClearAllStringLists(ProgrammerStringLists);
  try
    ClearDataSetFilter(GenelForm.UserTables, TRUE);

    while not GenelForm.UserTables.Eof do
    begin
      ProgrammerStringLists[0].Add(GenelForm.UserTables.FindField('Table Name').AsString);

      GenelForm.UserTables.Next;
    end;

    Inc(MainSQLLogging.GroupNo);

    ProgressStartAsExtra('Tablolar açılıp kapatılıyor', '', ProgrammerStringLists[0].Count, TRUE);
    try
      for I := 0 to ProgrammerStringLists[0].Count - 1 do
      begin
        if ProgressCanceled(1, 1, '', '"' + ProgrammerStringLists[0][I] + '"') then Exit;

        with GetAndSetTable(ProgrammerStringLists[0][I], '', '1 = 2') do
        begin
          ActivateDataSet(Fields[0].DataSet);
          Fields[0].DataSet.Active := FALSE;
          Free;
        end;
      end;
    finally
      ProgressFinish;
    end;
  finally
    ClearAllStringLists(ProgrammerStringLists);
  end;
end;

procedure TProgrammerForm.ButunTablolariveMenuleriAcveKapatItemClick(Sender: TObject);
begin
  STT;
  ButunTablolariAcKapatItem.Click;
  ButunMenuleriAcveKapatItem.Click;
  SWT('Toplam Geçen Süre: ');
end;

procedure TProgrammerForm.UserTablesScriptItemClick(Sender: TObject);
var
  I: Integer;
begin
  ClearAllStringLists(ProgrammerStringLists);
  try
    ProgrammerStringLists[3].Add('DBCC SHRINKDATABASE ("' + ApplicationSchemaName + 'Data")');
    ProgrammerStringLists[3].Add('');
    ProgrammerStringLists[3].Add('BACKUP DATABASE "' + ApplicationSchemaName + 'Data" TO DISK = ''' + TheProgramEXEPath + '\' + ApplicationSchemaName + 'Data.BAK.PAS''');
    ProgrammerStringLists[3].Add('');

    ProgrammerStringLists[0].Text := Trim(UserTablesScriptComboBox.Items.Text);
    for I := 0 to ProgrammerStringLists[0].Count - 1 do
      if System.Pos('CREATE TABLE ', ProgrammerStringLists[0][I]) > 0 then
      begin
        ProgrammerStringLists[1].Text := MyAnsiReplaceStr(ProgrammerStringLists[0][I], '"', LB);
        if ProgrammerStringLists[1].Count > 2 then ProgrammerStringLists[2].Add(ProgrammerStringLists[1][1]);
      end;

    for I := 0 to ProgrammerStringLists[2].Count - 1 do
    begin
      ProgrammerStringLists[3].Add('DROP TABLE "' + ProgrammerStringLists[2][I] + ' Previous";');
      ProgrammerStringLists[3].Add('');
    end;

    for I := 0 to ProgrammerStringLists[2].Count - 1 do
    begin
      ProgrammerStringLists[3].Add('SELECT * INTO "' + ProgrammerStringLists[2][I] + ' Previous" FROM "' + ProgrammerStringLists[2][I] + '";');
      ProgrammerStringLists[3].Add('');
    end;

    for I := ProgrammerStringLists[2].Count - 1 downto 0 do
    begin
      ProgrammerStringLists[3].Add('DROP TABLE "' + ProgrammerStringLists[2][I] + '";');
      ProgrammerStringLists[3].Add('');
    end;

    for I := 0 to ProgrammerStringLists[0].Count - 1 do ProgrammerStringLists[3].Add(ProgrammerStringLists[0][I]);

    SIT(Trim(ProgrammerStringLists[3].Text));
  finally
    ClearAllStringLists(ProgrammerStringLists);
  end;
end;

function SetPASFile(const aFileName: string; const aStrs1, aStrs2: array of string): Boolean;
var
  I, J, P1, P2: Integer;
  St1, St2: string;
begin
  MyDeleteFile(aFileName + '_BAK');
  Windows.CopyFile(PChar(aFileName), PChar(aFileName + '_BAK'), FALSE);

  Result := FALSE;
  with TStringList.Create do
  try
    Text := MyFileToText(aFileName);

    for I := 0 to Count - 1 do
    begin
      St1 := Strings[I];

      for J := 0 to Length(aStrs1) - 1 do
      begin
        P1 := System.Pos('//' + aStrs1[J], St1);
        if P1 > 0 then
        begin
          P2 := System.Pos(' =>', St1);

          if P2 > P1 then
          begin
            if RightStr(TrimRight(LeftStr(St1, P2)), Length('//' + aStrs1[J])) <> '//' + aStrs1[J] then Continue;

            St2 := St1;

            St1 := TrimRight(LeftStr(St1, P2 + 2) + ' ' + aStrs2[J]);

            if Length(St1) > 1023 then
            begin
              Me('Satır karakter sayısı 1023''ten büyük: ' + FormatInt(Length(St1)) + '. Satır No: ' + FormatInt(I + 1) + '.' + LB2 + St1);
              St1 := LeftStr(St1, 1023);
            end;

            if not Result then Result := St1 <> St2;

            Strings[I] := St1;

            Break;
          end;
        end;
      end;
    end;

    if Result then MyTextToFile(Text, aFileName);
  finally
    Free;
  end;
end;

procedure TProgrammerForm.PASDosyalariniDuzenleItemClick(Sender: TObject);
var
  I, K: Integer;
  aSQLText: string;
  aStrs1, aStrs2, aStrs3: array of string;
begin
  //User Tables Ex => Sıra No, Grup, Grup Sıra No, Tablo Sıra No, Table Name, Logging, Veri Girişi, Bands, Skip, BB Ocak Ayları, Display Key, View SQL, View Tables, Erişim, Is View, SQL Script, Has Group

  if Mc('"' + TheProgramEXEPath + '" klasöründeki PAS dosyalarındaki "User Tables" vs. düzenlemek istediğinize emin misiniz?') <> mrYes then Exit;

  ClearAllStringLists(ProgrammerStringLists);
  try
    ProgressStartAsWaitMessage('PAS dosyaları düzenleniyor...');
    try
      aSQLText :=
          'SELECT' + LB +
          '  "Table Name"' + LB +
          'FROM "User Tables Ex"' + LB +
          'ORDER BY 1';

      with GetQuery_Programmer(aSQLText, 'Tablolar', [], '', FALSE, '', '', TRUE) do
      begin
        ActivateDataSet(Fields[0].DataSet);

        ProgrammerStringLists[0].Text := Trim(UserTablesScriptComboBox.Items.Text);
        for I := 0 to ProgrammerStringLists[0].Count - 1 do
          if System.Pos('CREATE TABLE ', ProgrammerStringLists[0][I]) > 0 then
          begin
            ProgrammerStringLists[1].Text := MyAnsiReplaceStr(ProgrammerStringLists[0][I], '"', LB);
            if ProgrammerStringLists[1].Count > 2 then ProgrammerStringLists[2].Add(ProgrammerStringLists[1][1]);
          end;

        K := ProgrammerStringLists[2].Count * 2;
        SetLength(aStrs1, RecordCount + K);
        SetLength(aStrs2, RecordCount + K);
        SetLength(aStrs3, RecordCount + K);

        for I := 0 to ProgrammerStringLists[2].Count - 1 do aStrs1[I] := ProgrammerStringLists[2][I];
        for I := 0 to ProgrammerStringLists[2].Count - 1 do aStrs1[I + ProgrammerStringLists[2].Count] := ProgrammerStringLists[2][I] + ' Ex';

        for I := 0 to K - 1 do aStrs3[I] := TheProgrammersSchemaName;

        while not Eof do
        begin
          aStrs1[K] := FindField('Table Name').AsString;
          aStrs3[K] := ApplicationSchemaName;
          Inc(K);

          Next;
        end;
      end;

      for I := 0 to Length(aStrs1) - 1 do
        if TableOrViewExists(aStrs1[I], aStrs3[I], MainConnection) then
          with GetTable(aStrs1[I], aStrs1[I], '', FALSE, '', TRUE, FALSE, aStrs3[I], MainConnection) do
          try
            aStrs2[I] := GetDataSetFieldNames(Fields[0].DataSet, ', ', '', '', '');
          finally
            Free;
          end
        else
          if TableOrViewExists(aStrs1[I], aStrs3[I], TheProgrammersConnection) then
            with GetTable(aStrs1[I], aStrs1[I], '', FALSE, '', TRUE, FALSE, aStrs3[I], TheProgrammersConnection) do
            try
              aStrs2[I] := GetDataSetFieldNames(Fields[0].DataSet, ', ', '', '', '');
            finally
              Free;
            end;

      for I := 0 to GenelForm.ComponentCount - 1 do
        if GenelForm.Components[I] is TMemDataSet then
          with TMemDataSet(GenelForm.Components[I]) do
            if FieldCount > 0 then
            begin
              K := Length(aStrs1);
              SetLength(aStrs1, K + 1);
              SetLength(aStrs2, K + 1);
              aStrs1[K] := Name;
              aStrs2[K] := GetDataSetFieldNames(Fields[0].DataSet, ', ', '', '', '');
            end;

      ProgrammerStringLists[0].Clear;

      MyGetFileNamesOfAFolder(TheProgramEXEPath, ProgrammerStringLists[0], FALSE, FALSE, '', '', '*.PAS');

      ProgrammerStringLists[1].Clear;

      for I := 0 to ProgrammerStringLists[0].Count - 1 do
        if SetPASFile(ProgrammerStringLists[0][I], aStrs1, aStrs2) then ProgrammerStringLists[1].Add(ProgrammerStringLists[0][I]);
    finally
      ProgressFinish;
    end;

    if ProgrammerStringLists[1].Count > 0 then Mw('Şu source dosyaları değişti:' + LB2 + ProgrammerStringLists[1].Text);
  finally
    ClearAllStringLists(ProgrammerStringLists);
  end;
end;

procedure TProgrammerForm.ProgramDatasiniOlusturItemClick(Sender: TObject);
begin
  if Mc('Program datasını (ProgrammerData.Pas) oluşturmak istediğinize emin misiniz?') <> mrYes then Exit;

  ProgramDatasiniOlustur;
end;

procedure TProgrammerForm.TablolariOlusturItemClick(Sender: TObject);
var
  I, aTag: Integer;
begin
  aTag := TComponent(Sender).Tag;

  if aTag = 1 then
    if Mc('Tabloları oluşturmak istediğinize emin misiniz?') <> mrYes then Exit;

  ProgressStartAsWaitMessage('Tablolar oluşturuluyor...');
  try
    ProgramGirisiPaused := TRUE;

    Inc(MainSQLLogging.GroupNo);
    MainSQLLogging.MainGroup := 'Tabloları Oluştur';

    StartSQLLoggingMessagePanel;

    if aTag = 1 then BackupPROGRAMCIDatabaseItemClick(nil);

    if (aTag = 1) and TablolariOnceSilItem.Down then
    begin
      if not MevcutTempSilinmesinOrdanGeriYuklensinItem.Down then
        if not RemoveSchema(ApplicationSchemaName + 'Temp', MainConnection) then Mw('Not dropped ' + ApplicationSchemaName + 'Temp');

      ProgrammerStringLists[0].Clear;
      try
        GetTableNames(ProgrammerStringLists[0], ApplicationSchemaName);

        for I := 0 to ProgrammerStringLists[0].Count - 1 do
          if RightStr(ProgrammerStringLists[0][I], 4) = ' LOG' then ExecSQLTry('DROP TABLE "' + ApplicationSchemaName + '"."' + ProgrammerStringLists[0][I] + '"', '', nil, TRUE);
      finally
        ProgrammerStringLists[0].Clear;
      end;

      if not RemoveSchema(ApplicationSchemaName, MainConnection, '', FALSE, TRUE, IfThen(MevcutTempSilinmesinOrdanGeriYuklensinItem.Down, '', ApplicationSchemaName + 'Temp')) then Mw('Not dropped ' + ApplicationSchemaName);
    end;

    TablolariOlustur(aTag <> 1, TablolariSonraTemptenGeriYukleItem.Down);

    if aTag = 1 then ProgramDatasiniOlustur;
  finally
    ProgramGirisiPaused := FALSE;
    StopSQLLoggingMessagePanel;
    ProgressFinish;
  end;

  if aTag = 1 then PASDosyalariniDuzenleItem.Click;
end;

procedure TProgrammerForm.TestItemClick(Sender: TObject);
var
  I, J, K, L, M1, M2: Integer;
  I64: Int64;
  St1, St2, St3, St4: string;
  D1: TDateTime;
  aExcelGroupPageCount, aLengthaFieldIndices: Integer;
  aStrArray: TStringDynArray;
  aStrs: array[0..100 - 1] of string;
begin
  ClearAllStringLists(ProgrammerStringLists);
  ClearAllStringLists(ProgrammerSortedStringLists);

  Sm(DecodeString('RklMSVpcU1FMMjAwOFIyfExPR09fVEVTVHxIVVNFWUlOfGh1c2V5aW58RklMSVpcU1FMMjAwOFIyfFB1c3VsYTEyM3xIVVNFWUlOfGh1c2V5aW4='));
  Exit;

  St1 :=
    'SELECT' + LB +
    '  T1."Dönem ID", T1."Artış", T1."Artış ID", T1."Yıl",' + LB +
    '  T1."Y Ocak"    * (1 + T1."Ocak") * T2."Toplam Çarpımı" AS "Ocak",' + LB +
    '  T1."Y Şubat"   * (1 + T1."Ocak") * (1 + T1."Şubat") * T2."Toplam Çarpımı" AS "Şubat",' + LB +
    '  T1."Y Mart"    * (1 + T1."Ocak") * (1 + T1."Şubat") * (1 + T1."Mart") * T2."Toplam Çarpımı" AS "Mart",' + LB +
    '  T1."Y Nisan"   * (1 + T1."Ocak") * (1 + T1."Şubat") * (1 + T1."Mart") * (1 + T1."Nisan") * T2."Toplam Çarpımı" AS "Nisan",' + LB +
    '  T1."Y Mayıs"   * (1 + T1."Ocak") * (1 + T1."Şubat") * (1 + T1."Mart") * (1 + T1."Nisan") * (1 + T1."Mayıs") * T2."Toplam Çarpımı" AS "Mayıs",' + LB +
    '  T1."Y Haziran" * (1 + T1."Ocak") * (1 + T1."Şubat") * (1 + T1."Mart") * (1 + T1."Nisan") * (1 + T1."Mayıs") * (1 + T1."Haziran") * T2."Toplam Çarpımı" AS "Haziran",' + LB +
    '  T1."Y Temmuz"  * (1 + T1."Ocak") * (1 + T1."Şubat") * (1 + T1."Mart") * (1 + T1."Nisan") * (1 + T1."Mayıs") * (1 + T1."Haziran") * (1 + T1."Temmuz") * T2."Toplam Çarpımı" AS "Temmuz",' + LB +
    '  T1."Y Ağustos" * (1 + T1."Ocak") * (1 + T1."Şubat") * (1 + T1."Mart") * (1 + T1."Nisan") * (1 + T1."Mayıs") * (1 + T1."Haziran") * (1 + T1."Temmuz") * (1 + T1."Ağustos") * T2."Toplam Çarpımı" AS "Ağustos",' + LB +
    '  T1."Y Eylül"   * (1 + T1."Ocak") * (1 + T1."Şubat") * (1 + T1."Mart") * (1 + T1."Nisan") * (1 + T1."Mayıs") * (1 + T1."Haziran") * (1 + T1."Temmuz") * (1 + T1."Ağustos") * (1 + T1."Eylül") * T2."Toplam Çarpımı" AS "Eylül",' + LB +
    '  T1."Y Ekim"    * (1 + T1."Ocak") * (1 + T1."Şubat") * (1 + T1."Mart") * (1 + T1."Nisan") * (1 + T1."Mayıs") * (1 + T1."Haziran") * (1 + T1."Temmuz") * (1 + T1."Ağustos") * (1 + T1."Eylül") * (1 + T1."Ekim") * T2."Toplam Çarpımı" AS "Ekim",' + LB +
    '  T1."Y Kasım"   * (1 + T1."Ocak") * (1 + T1."Şubat") * (1 + T1."Mart") * (1 + T1."Nisan") * (1 + T1."Mayıs") * (1 + T1."Haziran") * (1 + T1."Temmuz") * (1 + T1."Ağustos") * (1 + T1."Eylül") * (1 + T1."Ekim") * ' + '(1 + T1."Kasım") * T2."Toplam Çarpımı" AS "Kasım",' + LB +
    '  T1."Y Aralık"  * (1 + T1."Ocak") * (1 + T1."Şubat") * (1 + T1."Mart") * (1 + T1."Nisan") * (1 + T1."Mayıs") * (1 + T1."Haziran") * (1 + T1."Temmuz") * (1 + T1."Ağustos") * (1 + T1."Eylül") * (1 + T1."Ekim") * ' + '(1 + T1."Kasım") * (1 + T1."Aralık") * T2."Toplam Çarpımı" AS "Aralık"' + LB +
    'FROM "#Artış Detay" T1' + LB +
    '  LEFT JOIN' + LB +
    '    (' + LB +
    '     SELECT' + LB +
    '       T1."Dönem ID", T1."Artış", T1."Yıl",' + LB +
    '       (SELECT COALESCE(EXP(SUM(LOG(S1."Toplam Çarpımı"))), 1) FROM "#Artış Detay" S1 WHERE S1."Dönem ID" = T1."Dönem ID" AND S1."Artış" = T1."Artış" AND S1."Yıl" < T1."Yıl") AS "Toplam Çarpımı"' + LB +
    '     FROM "#Artış Detay" T1' + LB +
    '    ) T2 ON T2."Dönem ID" = T1."Dönem ID" AND T2."Artış" = T1."Artış" AND T2."Yıl" = T1."Yıl"';

  qCopyToTemp(['Kur Detay', 'Vade Detay', 'KDV Detay', 'Artış Detay', 'Artış Detay Kümüle', ExpandOcaks(St1)], ['', '', '', '', '', 'Artış Detay Kümüle2'], [], [], 'Copying...');

  Exit;


  K := 100000;
  ProgressStartAsNormal('Test işlemi yapılıyor...', K, TRUE);
  try
    for I := 0 to K - 1 do
    begin
      if ProgressCanceled then Exit;

      ProgressStartAsWaitMessage('Test işlemi yapılıyor...: ' + LB2 + FormatFloat('0000000000000000000000.000', K * 199238498.9));
      ProgressFinish;
    end;
  finally
    ProgressFinish;
  end;
  Exit;



  St1 := 'SELECT';

  for I := 0 to 4096 - 1 do St1 := St1 + LB + '  URUN_KODU AS URUN_KODU_' + IntToStr(I) + ',';

  St1 := DeleteFromRight(St1, 1) + ' FROM URUN';

  SIT(St1);

  Exit;

  St1 := DupeString('Hakan CAN' + LB2, 10);
  for I := 0 to 10 - 1 do ProgrammerStringLists[0].Add(St1);

  Sw(ProgrammerStringLists[0].Count);

  SIT(ProgrammerStringLists[0].Text);

  ProgrammerStringLists[0].Text := ProgrammerStringLists[0].Text;

  Sw(ProgrammerStringLists[0].Count);

  SIT(ProgrammerStringLists[0].Text);


  Exit;


  Randomize;

  //HESAP_KODU_00001
  K := 50000;
  ProgressStartAsNormal('Tablo dolduruluyor...', K, TRUE);
  try
    for I := 0 to K - 1 do
    begin
      if ProgressCanceled then Exit;

      for J := 0 to 10 - 1 do
      begin
        St1 := 'INSERT INTO HESAPLAR (HESAPKODU, SIRA_NO, BORC, ALACAK) VALUES (''HESAP_KODU_' + FormatFloat('00000', I + 1) + ''', ' + IntToStr(J + 2) + ', ' + IntToStr(Random(50000000)) + ', ' + IntToStr(Random(50000000)) + ')';
        ExecSQL(St1);
      end;
    end;
  finally
    ProgressFinish;
  end;


  Exit;

  STT;
  for I := 0 to 1000 - 1 do qUpdateTry('dbo.NET_MIKTAR', [qJoinInner('SELECT * FROM dbo.URUN WHERE CINSI <> ''U''', '')], ['[OCAK]=T1.[OCAK] + 1.1', 'TOPLAM_MIKTAR = T1.OCAK + T2.SAFHA'], '', '', FALSE, I = 0);
  SWT;
  Exit;




  I64 := 0;
  K := 500000000;
  St1 := DupeString('Hakan Can', 100000);
  L := Length(St1);
  St2 := '0';
  J := 0;
  M1 := 0;
  M2 := 0;
  ProgressStartAsExtra('TStringList kapasite kontrolü yapılıyor...', '0', K, FALSE);
  try
    for I := 0 to K - 1 do
    begin
      if M1 = 10000000 then
      begin
        Inc(J);
        M1 := 0;
      end;

      if ProgressCanceled(33333, 1, '', St2) then Exit;

      ProgrammerStringLists[J].Add(St1);

      Inc(I64, L);

      if M2 = 10000 then
      begin
        St2 := FormatInt(I64);
        M2 := 0;
      end;

      Inc(M1);
      Inc(M2);
    end;
  finally
    ClearAllStringLists(ProgrammerStringLists);
    ProgressFinish;
  end;
  Exit;


  for I := 0 to Length(aStrs) - 1 do
  try
    SetLength(aStrs[I], MaxInt div 100);
  except
    Sw(I);
  end;

  Exit;


  ProgrammerStringLists[0].LoadFromFile('C:\UtilitiesFormStringLists.TXT');

  SMIT(ProgrammerStringLists[0].Text, 'İki Klasör Karşılaştırması...');
  Exit;


  ProgressStartAsNormal('Birinci klasör dosya bilgileri düzenleniyor...' + LB2 + '"C:\"', 8500000, FALSE);
  try
    for I := 0 to 8500000 - 1 do
      if ProgressCanceled(33) then Exit;
  finally
    ProgressFinish;
  end;
  Exit;


  StartMainSQLLogging('ROTA');

  qCreateTemp('ROTA_DETAY_AYLIK', '', GetPrimaryKeyFieldNamesAsText('ROTA_DETAY_AYLIK', '"', '"', ', '));
  qAppend('#ROTA_DETAY_AYLIK', 'ROTA_DETAY_AYLIK', ['MAKINA'], [], 'T2.AY = 1');

  Exit;


  qCopyToTemp('SELECT BUTCE_KODU, URUN_KODU, ADI FROM URUN', 'MURUN', 'BUTCE_KODU, URUN_KODU', 'Mürün oluşturuluyor...');
  Exit;


  qAppendNonExistings('Varsayım Sonuç Satış Miktar', 'Varsayım Sonuç Satış Miktar', ['SELECT * FROM "' + ApplicationSchemaName + '"."Varsayım Sonuç Satış Miktar"'], [], 'T2."Bütçe ID" <> 129', '', FALSE);

  STT;
  //for I := 0 to 1000 - 1 do AppendTry('dbo.NET_MIKTAR', 'dbo.URUN_SATIS_DETAY', [JoinInner('dbo.URUN')], ['TOPLAM_MIKTAR = T1.OCAK', 'SUBAT = Null', 'MART = T2.SAFHA + 1.0'], '', '', FALSE, I = 0);
  for I := 0 to 1000 - 1 do qAppendNonExistingsTry('dbo.NET_MIKTAR', 'dbo.URUN_SATIS_DETAY', [qJoinInner('SELECT * FROM dbo.URUN')], ['TOPLAM_MIKTAR = SUM(OCAK)', 'SUBAT = Null', 'MART = SUM(T2.SAFHA) + 1.0'], '', '', FALSE, I = 0);
  for I := 0 to 1000 - 1 do qUpdate('dbo.NET_MIKTAR', [qJoinInner('SELECT * FROM dbo.URUN', 'T2.BUTCE_KODU = T1.BUTCE_KODU AND T2.URUN_KODU = T1.URUN_KODU AND T2.CINSI <> ''U''')], ['TOPLAM_MIKTAR = T1.OCAK + T2.SAFHA'], '', '', FALSE);
  for I := 0 to 1000 - 1 do qUpdateTry('dbo.NET_MIKTAR', [qJoinInner('SELECT * FROM dbo.URUN WHERE CINSI <> ''U''', '')], ['TOPLAM_MIKTAR = T1.OCAK + T2.SAFHA'], '', '', FALSE, I = 0);
  for I := 0 to 1000 - 1 do qEmpty('dbo.NET_MIKTAR', [qJoinInner('SELECT * FROM dbo.URUN')], '1=2', '', FALSE);

  //for I := 0 to 1000 - 1 do Append('dbo.NET_MIKTAR', 'dbo.URUN_SATIS_DETAY', [JoinInner('SELECT * FROM dbo.URUN', '1 = 2 AND T2.BUTCE_KODU = T1.BUTCE_KODU AND T2.URUN_KODU = T1.URUN_KODU')], ['TOPLAM_MIKTAR = SUM(OCAK)', 'SUBAT = Null', 'MART = SUM(T2.SAFHA) + 1.0'], '1=2', '', not TRUE, I = 0);
  //for I := 0 to 10000 - 1 do Append('dbo.NET_MIKTAR', ['dbo.URUN_SATIS_DETAY'], ['TOPLAM_MIKTAR = 0.0', 'SUBAT = Null'], '1=2', '', TRUE, I = 0);
  //for I := 0 to 1000 - 1 do Append('dbo.NET_MIKTAR', ['dbo.URUN_SATIS_DETAY'], [], '', '', TRUE);
  SWT;
  Exit;

  //GetTableNamesAllSchemas(ProgrammerStringLists[1], ProgrammerStringLists[2]);
  GetObjectNamesAllSchemas(ProgrammerStringLists[1], ProgrammerStringLists[2], ProgrammerStringLists[3], TRUE, TRUE, TRUE, TRUE);

  for I := 0 to ProgrammerStringLists[1].Count - 1 do ProgrammerStringLists[0].Add(GetObjectNameWithLeftRightCharacters(ProgrammerStringLists[1][I]) + '.' + GetObjectNameWithLeftRightCharacters(ProgrammerStringLists[2][I]));

  K := 0;
  L := 0;
  STT;
  ProgressStartAsNormal('İşlem yapılıyor...', ProgrammerStringLists[0].Count, FALSE);
  try
    for I := 0 to ProgrammerStringLists[0].Count - 1 do
    begin
      if ProgressCanceled(1, 1, 'İşlem yapılıyor...' + LB2 + ProgrammerStringLists[0][I]) then Exit;

      with GetTableOrQueryInformationExpanding(ProgrammerStringLists[0][I]) do
      begin
        if Butce then Inc(K);
        if View  then Inc(L);
      end;
    end;
  finally
    ProgressFinish;
  end;
  SWT('', LB + FormatInt(ProgrammerStringLists[0].Count) + ', ' + FormatInt(K) + ', ' + FormatInt(L));
  Exit;


  GetObjectNamesAllSchemas(ProgrammerStringLists[1], ProgrammerStringLists[2], ProgrammerStringLists[3], TRUE, TRUE, not FALSE, not FALSE);

  for I := 0 to ProgrammerStringLists[1].Count - 1 do
  begin
    ProgrammerStringLists[5].Add('AAA' + IntToStr(I));
    ProgrammerStringLists[0].Add(GetObjectNameWithLeftRightCharacters(ProgrammerStringLists[1][I]) + '.' + GetObjectNameWithLeftRightCharacters(ProgrammerStringLists[2][I]));
  end;

  Sw(qCopyToTemp(TextToStringArray(ProgrammerStringLists[0].Text, LB), TextToStringArray(ProgrammerStringLists[5].Text, LB), [], 'Copying to temp...', TRUE));
  Exit;



  St4 := 'AirTies.dbo.URUN'; ExtractTableSchemaAndDatabaseNamesFromFullTableName(St4, St1, St2, St3); ProgrammerStringLists[0].Add(St4 + ' => "' + St3 + '"."' + St2 + '"."' + St1 + '"');
  St4 := 'AirTies..URUN'; ExtractTableSchemaAndDatabaseNamesFromFullTableName(St4, St1, St2, St3); ProgrammerStringLists[0].Add(St4 + ' => "' + St3 + '"."' + St2 + '"."' + St1 + '"');
  St4 := 'dbo.URUN'; ExtractTableSchemaAndDatabaseNamesFromFullTableName(St4, St1, St2, St3); ProgrammerStringLists[0].Add(St4 + ' => "' + St3 + '"."' + St2 + '"."' + St1 + '"');
  St4 := '.dbo.URUN'; ExtractTableSchemaAndDatabaseNamesFromFullTableName(St4, St1, St2, St3); ProgrammerStringLists[0].Add(St4 + ' => "' + St3 + '"."' + St2 + '"."' + St1 + '"');
  St4 := '..URUN'; ExtractTableSchemaAndDatabaseNamesFromFullTableName(St4, St1, St2, St3); ProgrammerStringLists[0].Add(St4 + ' => "' + St3 + '"."' + St2 + '"."' + St1 + '"');
  St4 := '.URUN'; ExtractTableSchemaAndDatabaseNamesFromFullTableName(St4, St1, St2, St3); ProgrammerStringLists[0].Add(St4 + ' => "' + St3 + '"."' + St2 + '"."' + St1 + '"');


  SIT(ProgrammerStringLists[0].Text);
  Exit;

  SetLength(aStrArray, 100000);

  St2 := DupeString('Hakan CAN ', 100);

  for I := 0 to Length(aStrArray) - 1 do aStrArray[I] := FormatInt(I) + St2;

  St1 := '';
  STT;
  for I := 0 to Length(aStrArray) - 1 do St1 := St1 + aStrArray[I];
  SWT;

  St2 := '';
  STT;
  K := 0;
  for I := 0 to Length(aStrArray) - 1 do Inc(K, Length(aStrArray[I]));
  SetLength(St2, K);
  K := 1;
  for I := 0 to Length(aStrArray) - 1 do
    if Length(aStrArray[I]) > 0 then
    begin
      System.Move(aStrArray[I][1], St2[K], Length(aStrArray[I]) * SizeOf(Char));
      Inc(K, Length(aStrArray[I]));
    end;
  SWT;
  Exit;


  STT;
  qCopyToTemp('Varsayım', '', 'Varsayım ID, Varsayım', '', '', TRUE);
  SWT;
  with GetTable('#Varsayım') do
  try
    VGM(Fields[0].DataSet);
  finally
    Free;
  end;

  Exit;

  K := 2000;
  ProgressStartAsNormal('İşlem yapılıyor...', K, FALSE);
  try
    for I := 0 to K - 1 do
    begin
      if ProgressCanceled then Exit;

      if ToplamButce > 200 then;

      //DropTempTry('Hakan');
    end;
  finally
    ProgressFinish;
  end;
  Exit;


  qCopyToTemp('Vade Detayı', '', 'Vade, Ay, AY Vade, Yıl', '', '', FALSE);
  with GetTable('#Vade Detayı') do
  try
    VGM(Fields[0].DataSet);
  finally
    Free;
  end;
  Exit;



  STT;
  for I := 0 to 10 - 1 do
  begin
    St1 := DupeString('Hakan CAN' + FormatInt(I * 10000), 10);
    MyTextToFile(St1, 'C:\Test00981.TXT');
    St2 := MyFileToText('C:\Test00981.TXT');
    if St1 <> St2 then SIT(FormatInt(Length(St1)) + LB2 + FormatInt(Length(St2)) + LB2 + LeftStr(St1, 1000) + LB2 + LeftStr(St2, 1000));
  end;
  SWT;
  Exit;


  D1 := Now;
  STT;
  for I := 0 to 100000 - 1 do St1 := TimeToStrWithMoreThan24Hours(Now - D1, 3, TRUE);
  SWT;
  for I := 0 to 100000 - 1 do St1 := FormatDateTime('hh:nn:ss.zzz', Now - D1);
  SWT;
  Exit;


  K := 10000000;
  ProgressStartAsNormal('İşlem yapılıyor...', K, FALSE);
  try
    for I := 0 to K - 1 do
      if ProgressCanceled then Exit;
  finally
    ProgressFinish;
  end;

  Exit;


  with TUniTable.Create(nil) do
  try
    Connection     := MainConnection;
    TableName := '"' + ApplicationSchemaName + '"."Ürün2"';
    Options.StrictUpdate := FALSE;
    Active   := TRUE;

    ProgressStartAsNormal('Kayıtlar siliniyor', RecordCount, TRUE);
    try
      while not Eof do
      begin
        if ProgressCanceled then Exit;

        Delete;
      end;
    finally
      ProgressFinish;
    end;
  finally
    Free;
  end;

  Exit;



  ClearAllStringLists(ProgrammerStringLists);
  ClearAllStringLists(ProgrammerSortedStringLists);

  //aRowCount := 77185;
  aLengthaFieldIndices := 7;
  aExcelGroupPageCount := (((aLengthaFieldIndices + 1) - 1) div 256) + 1;

  for I := 65537 downto 65533 do
    for J := 0 to aLengthaFieldIndices - 1 do ProgrammerStringLists[0].Add(FormatFloat('0000000', I) + ' - ' +
                                                                           FormatFloat('0000000', (I div (65535 * aExcelGroupPageCount)) + ((J + 1) div 256)) + ' - ' +
                                                                           FormatFloat('0000000', (J + 1) mod 256) + ' - ' +
                                                                           FormatFloat('0000000', ((I - 1) mod 65535) + 2) + ' - ' +
                                                                           FormatFloat('0000000', ((I - 0) mod 65535) + 1));

  SIT(ProgrammerStringLists[0].Text);
  Exit;

  for I := 65537 downto 65533 do
    for J := 0 to aLengthaFieldIndices - 1 do ProgrammerStringLists[0].Add(FormatFloat('0000000', I) + ' - ' +
                                                                           FormatFloat('0000000', (I div (65535 * aExcelGroupPageCount)) + ((J + 1) div 256)) + ' - ' +
                                                                           FormatFloat('0000000', (J + 1) mod 256) + ' - ' +
                                                                           FormatFloat('0000000', ((I - 1) mod 65535) + 2));

  SIT(ProgrammerStringLists[0].Text);
  Exit;

  GetTableNames(ProgrammerStringLists[0]);

  STT;
  for I := 0 to ProgrammerStringLists[0].Count - 1 do GetFieldNamesAndRequiredFieldNamesEx(ProgrammerStringLists[0][I], ProgrammerStringLists[1], ProgrammerStringLists[2]);
  SWT;
  Exit;


  ClearAllStringLists(ProgrammerStringLists);
  ClearAllStringLists(ProgrammerSortedStringLists);

  GetTableNames(ProgrammerStringLists[0]);

  STT;
  with TUniQuery.Create(nil) do
  try
    Connection     := MainConnection;
    UniDirectional := TRUE;

    for I := 0 to ProgrammerStringLists[0].Count - 1 do
    begin
      SQL.Text := 'SELECT * FROM "' + ProgrammerStringLists[0][I] + '" WHERE 1 = 2';
      Active   := TRUE;
      Active   := FALSE;
    end;
  finally
    Free;
  end;

  SWT;
  Exit;


  STT;
  for I := 0 to 10 - 1 do with TForms_cxGridMainForm.Create(Application.MainForm) do Free;
  SWT;
  Exit;

  SIT(MainConnection.SpecificOptions.Text);
  Exit;

  STT;
  for I := 1 to 100 do ReadFromINIFile('C:\Testing.INI', 'Genel-' + IntToStr(I), 'Tüzel-' + IntToStr(I), IntToStr(I));
  SWT;
  Exit;

  Mw('X');
  Mwe('X');
  Exit;

  K := 1000000;
  ProgressStartAsNormal('Tablolar oluşturuluyor', K, TRUE);
  try
    for I := 0 to K - 1 do
    begin
      if ProgressCanceled then Exit;

      if not TableExists('YIL_' + FormatFloat('0000000', I + 1)) then
      try
        ExecSQL('SELECT TOP 1 * INTO YIL_' + FormatFloat('0000000', I + 1) + ' FROM YIL');
      except
      end;
    end;
  finally
    ProgressFinish;
  end;
end;

procedure TProgrammerForm.ProgramciTimerTimer(Sender: TObject);
var
  St1: string;
begin
  St1 := 'OnCalc => ' + FormatDateTime('hh:nn:ss.zzz', OnCalcFieldsPeriod) + ', ' + FormatInt(OnCalcFieldsPeriodSayac);
  if OnCalcTestItem.Caption <> St1 then OnCalcTestItem.Caption := St1;
end;

procedure TProgrammerForm.TESTBtnClick(Sender: TObject);
var
  I, K, L1, L2, L3: Integer;
  St1, St2, St3: string;
  aStreamWriter: TStreamWriter;
  aAddresses1: array of Int64;
  aAddresses2: array of Int64;
  aAddresses3: array of Int64;
  aStreamReader: TStreamReader;
  aChars: TCharArray;
begin
  aStreamReader := TStreamReader.Create('D:\TextFileAsStringList8.DAT');
  STT;
  K := 0;

  while not aStreamReader.EndOfStream do
  begin
    St1 := aStreamReader.ReadLine;
    Inc(K);
  end;
  SWT(FormatInt(K) + LB);
  aStreamReader.Free;

  //Exit;


  aStreamReader := TStreamReader.Create('D:\TextFileAsStringList8.DAT');
  STT;
  K := 0;

  while not aStreamReader.EndOfStream do
  begin
    St1 := MyDecodeText(aStreamReader.ReadLine);
    Inc(K);
  end;
  SWT(FormatInt(K) + LB);
  aStreamReader.Free;

  Exit;


  aStreamReader := TStreamReader.Create('D:\TextFileAsStringList1.DAT');
  STT;
  K := 0;

  SetLength(aChars, 1000);
  L1 := 0;
  L3 := 0;
  while not aStreamReader.EndOfStream do
  begin
    L2 := aStreamReader.Read(aChars, 0, 1000);
    Inc(L1, L2);
    Inc(K);

    for I := 0 to L2 - 1 do
      if aChars[I] = Chr(13) then Inc(L3);
  end;
  SWT(FormatInt(K) + LB + FormatInt(L1) + LB + FormatInt(L3) + LB);

  aStreamReader.Free;

  Exit;


  SetLength(aAddresses1, 60 * 1000 * 1000);
  Sw(Length(aAddresses1));

  SetLength(aAddresses2, 60 * 1000 * 1000);
  Sw(Length(aAddresses2));

  SetLength(aAddresses3, 60 * 1000 * 1000);
  Sw(Length(aAddresses3));

  Exit;

  MyKillFolder('C:\Delphi Old Projects\', 'Klasör tamamen kaldırılıyor..');
  Exit;

  St2 := DupeString('0123456789', 30);

  St1 := '';
  for I := 0 to 1000 do St1 := St1 + St2 + LB;

  STT;
  aStreamWriter := TStreamWriter.Create('D:\TStreamWriterTest.TXT', FALSE);
  try
    for I := 0 to 1 * 1000 do aStreamWriter.WriteLine(St1);
  finally
    aStreamWriter.Free;
  end;
  SWT;
  Exit;


  ClearAllStringLists(ProgrammerStringLists);

  ProgrammerStringLists[0].Add('1');

  STT;
  for I := 0 to 1000 * 1000 do ProgrammerStringLists[0][0] := IntToStr(StrToInt(ProgrammerStringLists[0][0]) + 1);
  SWT;

  Exit;


  ClearAllStringLists(ProgrammerStringLists);

  St1 := DupeString('01234567890', 100000);

  L1 := 1 * 100;
  L1 := L1 * 10; ProgrammerStringLists[0].Clear; for I := 0 to L1 do ProgrammerStringLists[0].Add(St1); Sw(L1);
  L1 := L1 * 10; ProgrammerStringLists[0].Clear; for I := 0 to L1 do ProgrammerStringLists[0].Add(St1); Sw(L1);
  L1 := L1 * 10; ProgrammerStringLists[0].Clear; for I := 0 to L1 do ProgrammerStringLists[0].Add(St1); Sw(L1);
  L1 := L1 * 10; ProgrammerStringLists[0].Clear; for I := 0 to L1 do ProgrammerStringLists[0].Add(St1); Sw(L1);
  L1 := L1 * 10; ProgrammerStringLists[0].Clear; for I := 0 to L1 do ProgrammerStringLists[0].Add(St1); Sw(L1);
  L1 := L1 * 10; ProgrammerStringLists[0].Clear; for I := 0 to L1 do ProgrammerStringLists[0].Add(St1); Sw(L1);
  L1 := L1 * 10; ProgrammerStringLists[0].Clear; for I := 0 to L1 do ProgrammerStringLists[0].Add(St1); Sw(L1);
  L1 := L1 * 10; ProgrammerStringLists[0].Clear; for I := 0 to L1 do ProgrammerStringLists[0].Add(St1); Sw(L1);

  Exit;



  L1 := 100000 * 1000; ProgrammerStringLists[0].Clear;
  for I := 0 to L1 do
    for K := 0 to ProgrammerStringLists[1].Count - 1 do ProgrammerStringLists[0].Add(ProgrammerStringLists[1][K]);
  Sw(L1);

  L1 := 1000000 * 1000; ProgrammerStringLists[0].Clear;
  for I := 0 to L1 do
    for K := 0 to ProgrammerStringLists[1].Count - 1 do ProgrammerStringLists[0].Add(ProgrammerStringLists[1][K]);
  Sw(L1);

  Exit;


  ProgrammerStringLists[1].SaveToFile('D:\ProgrammerStringLists.TXT');
  Exit;

  ClearAllStringLists(ProgrammerStringLists);
  St1 := DupeString('0123456789', 10000);

  for I := 0 to 1 * 1000 do ProgrammerStringLists[0].Add(St1 + IntToStr(I));

  Sm('1 * 1000');

  ProgrammerStringLists[0].Clear;
  for I := 0 to 10 * 1000 do ProgrammerStringLists[0].Add(St1 + IntToStr(I));

  Sm('10 * 1000');

  ProgrammerStringLists[0].Clear;
  for I := 0 to 1000 * 1000 do ProgrammerStringLists[0].Add(St1 + IntToStr(I));

  Sm('1000 * 1000');
  Exit;

  ProgrammerStringLists[1].Clear;

  ProgressStartAsExtra(Lang('Dosyalar tespit ediliyor...', 'Files are being determined...') + ' "*.*"', '', -191, FALSE);
  try
    MyGetFileInformationsOfFolders(ProgrammerStringLists[0], FALSE, TRUE, '*.*', '', ';', '', '', ProgrammerStringLists[1], TRUE);
  finally
    ProgressFinish;
  end;

  L2 := Length(ProgrammerStringLists[1].Text);

  Sm(L1.ToString + LB + L2.ToString);


  Exit;

  SIT(ProgrammerStringLists[1].Text);

  Exit;

  ClearAllStringLists(ProgrammerStringLists);
  St1 := 'Hakan CAN';
  ProgrammerStringLists[0].Add('   ' + St1 + ' (DeleteFromLeft)');
  for I := 0 to 15 do ProgrammerStringLists[0].Add(FormatFloat('00', I) + ' ' + DeleteFromLeft(St1, I));

  ProgrammerStringLists[0].Add('');
  ProgrammerStringLists[0].Add('');
  ProgrammerStringLists[0].Add('   ' + St1 + ' (DeleteFromRight)');
  for I := 0 to 15 do ProgrammerStringLists[0].Add(FormatFloat('00', I) + ' ' + DeleteFromRight(St1, I));

  SIT(ProgrammerStringLists[0].Text);

  Exit;



  St1 := '';
  for I := 0 to 1255555 do St1 := St1 + Chr(I);

  sw(St1.Length);

  //St1 := DupeString('Hello How Are You?' + LB, 100);

  //MyKillFolder('C:\KillFolder\', 'Klasör tamamen kaldırılıyor..', DupeString('Hello How Are You?' + LB, 1));
  MyKillFolder('C:\KillFolder\', 'Klasör tamamen kaldırılıyor..', St1);
  Exit;

  ClearAllStringLists(ProgrammerStringLists);

  ProgrammerStringLists[0].LoadFromFile(Application.ExeName + '.TXT');

  STT;
  for I := 0 to ProgrammerStringLists[0].Count - 1 do ProgrammerStringLists[1].Add(ProgrammerStringLists[0][I]);
  SWT;
  L1 := Length(ProgrammerStringLists[1].Text);

  ProgrammerStringLists[1].Clear;
  STT;
  for I := 0 to ProgrammerStringLists[0].Count - 1 do ProgrammerStringLists[1].Add(MyCompressTextEncoding(ProgrammerStringLists[0][I]));
  SWT;
  L2 := Length(ProgrammerStringLists[1].Text);

  ProgrammerStringLists[1].Clear;
  STT;
  ProgrammerStringLists[1].Add(MyCompressTextEncoding(ProgrammerStringLists[0].Text));
  SWT;
  L3 := Length(ProgrammerStringLists[1].Text);

  SIT(FormatInt(L1) + LB + FormatInt(L2) + LB + FormatInt(L3));

  Exit;


  ClearAllStringLists(ProgrammerStringLists);

  ProgrammerStringLists[0].LoadFromFile('D:\Test.txt');

  St1 := DupeString('ABC', 1000);
  for I := 0 to ProgrammerStringLists[0].Count - 1 do ProgrammerStringLists[0][I] := ProgrammerStringLists[0][I] + St1;

  //for I := 0 to ProgrammerStringLists[0].Count - 1 do
    //if NumberOfSubStringInString('a', ProgrammerStringLists[0][I]) <> PosCount('a', ProgrammerStringLists[0][I]) then Sw(999);

  //Exit;


  STT;
  for I := 0 to ProgrammerStringLists[0].Count - 1 do
  for K := 0 to 1000 do;
    //if NumberOfSubStringInString2('a', ProgrammerStringLists[0][I]) = -21 then Sw(89);
  SWT;

  STT;
  for I := 0 to ProgrammerStringLists[0].Count - 1 do
  for K := 0 to 1000 do
    if PosCount('a', ProgrammerStringLists[0][I]) = -21 then Sw(89);
  SWT;

  Exit;


  St1 := ProgrammerStringLists[0].Text;

  SIT(MyAnsiReplaceStr(TNetEncoding.Base64.Encode(St1), LB, '*'));
  Exit;

  Sm(MyEncodeText(St1).Length.ToString + LB + TNetEncoding.Base64.Encode(St1).Length.ToString);
  Exit;

  STT;
  for I := 0 to 100 do
  begin
    St2 := MyEncodeText(St1 + FormatInt(I));
    if St2 = '' then Sw(89);
  end;
  SWT;

  STT;
  for I := 0 to 100 do
  begin
    St2 := TNetEncoding.Base64.Encode(St1 + FormatInt(I));
    if St2 = '' then Sw(89);
  end;
  SWT;
  Exit;



  ClearAllStringLists(ProgrammerStringLists);

  ProgrammerStringLists[0].LoadFromFile('D:\Test.txt');

  for I := 0 to 100 do
    if ProgrammerStringLists[0][I] <> '' then ProgrammerStringLists[1].Add(ProgrammerStringLists[0][I] + LB + TNetEncoding.Base64.Encode(ProgrammerStringLists[0][I]) + LB +
    TNetEncoding.Base64.Decode(TNetEncoding.Base64.Encode(ProgrammerStringLists[0][I])) + LB);

  SIT(ProgrammerStringLists[1].Text);
  Exit;



  St1 := 'Hakan CAN';

  SIT(St1 + LB + TNetEncoding.Base64.Encode(St1) + LB2 + AnsiUpperCase(St1) + LB + TNetEncoding.Base64.Encode(AnsiUpperCase(St1)));
  Exit;

  for I := 0 to 1024 do ProgrammerStringLists[0].Add('"' + IntToHex(I, 3) + '"');


  SIT(ProgrammerStringLists[0].Text);
  Exit;


  ProgrammerStringLists[0].LoadFromFile('D:\Test.txt');

  St1 := ProgrammerStringLists[0].Text;

  if MyAnsiReplaceStr(St1, 'a', 'Test') <> MyAnsiReplaceStr2(St1, 'a', 'Test') then MeAbort('Prob!');

  for I := 0 to 1024 do
  begin
    St2 := Char(I);
    St3 := Char(I + 1) + Char(I + 33) + Char(I - 21);
    if MyAnsiReplaceStr(St1, St2, St3) <> MyAnsiReplaceStr2(St1, St2, St3) then MeAbort(I.ToString);
  end;

  Mi('Bitti');
  Exit;


  K := 10000;
  St1 := DupeString('Hakan CAN', 10000);
  STT;

  for I := 0 to K - 1 do
  begin
    St2 := MyAnsiReplaceStr(St1, 'a', 'ALOV');
    if St2 = St1 + 'K' then Break;
  end;
  SWT;

  for I := 0 to K - 1 do
  begin
    St2 := MyAnsiReplaceStr2(St1, 'a', 'ALOV');
    if St2 = St1 + 'K' then Break;
  end;
  SWT;

  SIT(MyAnsiReplaceStr(St1, 'a', 'ALOV') + LB2 + MyAnsiReplaceStr2(St1, 'a', 'ALOV'));

  //Exit;

  //for I := 0 to K - 1 do
    if MyAnsiReplaceStr(St1, 'a', 'ALOV') <> MyAnsiReplaceStr2(St1, 'a', 'ALOV') then Sw(23);

  Exit;


  STT;

  St1 := DupeString('Hakan CAN ', 100);

  for I := 0 to 1000000 - 1 do
  begin
    St2 := IntToStr(I);

    K := System.Pos(St2, St1 + St2);

    if K = -9 then Exit;
  end;
  SWT;

  for I := 0 to 1000000 - 1 do
  begin
    St2 := IntToStr(I);

    K := PosEx(St2, St1 + St2);

    if K = -9 then Exit;
  end;
  SWT;
  Exit;


  ClearAllStringLists(ProgrammerStringLists);
  try
    St1 := 'Hakan CANana';
    St2 := 'a';
    ProgrammerStringLists[0].Add(St1 + LB + St2 + LB + PosCount(St2, St1).ToString);

    St2 := 'B';
    ProgrammerStringLists[0].Add(LB + St1 + LB + St2 + LB + PosCount(St2, St1).ToString);

    St2 := 'a';
    ProgrammerStringLists[0].Add(LB + St1 + LB + St2 + LB + PosCount(St2, St1, TRUE).ToString + ' - UPPER');

    St2 := '';
    ProgrammerStringLists[0].Add(LB + St1 + LB + St2 + LB + PosCount(St2, St1).ToString);

    St2 := 'an';
    ProgrammerStringLists[0].Add(LB + St1 + LB + St2 + LB + PosCount(St2, St1).ToString);

    St2 := 'an';
    ProgrammerStringLists[0].Add(LB + St1 + LB + St2 + LB + PosCount(St2, St1, TRUE).ToString + ' - UPPER');

    St1 := 'AHakan CANaNA';
    St2 := 'A';
    ProgrammerStringLists[0].Add(LB + St1 + LB + St2 + LB + PosCount(St2, St1).ToString);

    St2 := 'B';
    ProgrammerStringLists[0].Add(LB + St1 + LB + St2 + LB + PosCount(St2, St1).ToString);

    St2 := 'a';
    ProgrammerStringLists[0].Add(LB + St1 + LB + St2 + LB + PosCount(St2, St1, TRUE).ToString + ' - UPPER');

    St2 := '';
    ProgrammerStringLists[0].Add(LB + St1 + LB + St2 + LB + PosCount(St2, St1).ToString);

    St2 := 'an';
    ProgrammerStringLists[0].Add(LB + St1 + LB + St2 + LB + PosCount(St2, St1).ToString);

    St2 := 'an';
    ProgrammerStringLists[0].Add(LB + St1 + LB + St2 + LB + PosCount(St2, St1, TRUE).ToString + ' - UPPER');

    SIT(ProgrammerStringLists[0].Text.TrimRight);
  finally
    ClearAllStringLists(ProgrammerStringLists);
  end;
  Exit;

  STT;
  St1 := 'Hakan CAN - Hakan CAN - Hakan CAN ';
  K := 1000000;
  St2 := St1;
  ProgressStartAsExtra('TEST...', St1, K, FALSE);
  try
    for I := 0 to K - 1 do
    begin
      St2 := St1.ToUpper + '- ' + I.ToHexString + ' - ' + I.ToString(2176 * 5033);
      //St2 := DupeString(St1, I + 1) + ' - ' + FormatInt(I);
      //St2 := St2 + St1;
      //if St2 = St1 then Sw(23);

      if ProgressCanceled(1, 1, '', St2) then Break;

      //Sw(St2.Length);

      //Sleep(399);
    end;
  finally
    ProgressFinish;
  end;
  SWT;
  Exit;

  STT;
  St1 := 'Hakan CAN Patlıcan ';
  K := 20;
  ProgressStartAsExtra('TEST...', St1, K, FALSE);
  try
    for I := 0 to K - 1 do
    begin
      St2 := St1 + DupeString('A B C', I + 1) + LB + 'Test';
      if ProgressCanceled(1, 1, '', St2) then Exit;

      Sw(I);
    end;
  finally
    ProgressFinish;
  end;
  Exit;
end;

procedure TProgrammerForm.dxBarManagerClickItem(Sender: TdxBarManager; ClickedItem: TdxBarItem);
begin
  AddClickedItemToSonYapilanIslemler(ClickedItem);
end;

procedure TProgrammerForm.FormCreate(Sender: TObject);
begin
  if TheProgrammersComputer then
    if NOTTheProgrammersComputerCheckBox.Checked then SetTheProgrammersComputer(FALSE);

  CreateAllStringLists(ProgrammerStringLists,       FALSE);
  CreateAllStringLists(ProgrammerSortedStringLists, TRUE);

  DatabaseUpgradeCode := StrToInt64(DatabaseUpgradeCodeYearEdit.Text)  * 1000000 +
                         StrToInt64(DatabaseUpgradeCodeMonthEdit.Text) * 10000 +
                         StrToInt64(DatabaseUpgradeCodeDayEdit.Text)   * 100 +
                         StrToInt64(DatabaseUpgradeCodeSayacEdit.Text) * 1;

  if TheProgrammersComputer then SQLLoggingMessageProc := MySQLLoggingMessageProc;

  ProgramciTimer.Enabled := TheProgrammersComputer;
end;

procedure TProgrammerForm.FormDestroy(Sender: TObject);
begin
  FreeAllStringLists(ProgrammerStringLists);
  FreeAllStringLists(ProgrammerSortedStringLists);
end;

procedure TProgrammerForm.MessagesTestItemClick(Sender: TObject);
begin
  MessagesTest;
end;

procedure TProgrammerForm.MetaDataItemClick(Sender: TObject);
begin
  //VeriGirisi(nil, GetMetaDataDataSetOpening('Constraints', ['CONSTRAINT_TYPE=PRIMARY KEY']), 'Meta Data', '', '', TRUE);
  //VeriGirisi(nil, GetMetaDataDataSetOpening('Constraints', ['TABLE_SCHEMA=' + ApplicationSchemaName]), 'Meta Data', '', '', TRUE);
  //VeriGirisi(nil, GetMetaDataDataSetOpening('Columns', []), 'Meta Data', '', TRUE);
  VeriGirisi(nil, GetMetaDataDataSetOpening('Tables', []), 'Meta Data', '', TRUE);
  //VeriGirisi(nil, GetMetaDataDataSetOpening('Procedures', []), 'Meta Data', '', '', TRUE);
  //VeriGirisi(nil, GetMetaDataDataSetOpening('Indexes', []), 'Meta Data', '', '', TRUE);
  //VeriGirisi(nil, GetMetaDataDataSetOpening('IndexColumns', []), 'Meta Data', '', '', TRUE);

end;

procedure TProgrammerForm.OnCalcTestItemClick(Sender: TObject);
begin
  OnCalcFieldsPeriod      := 0;
  OnCalcFieldsPeriodSayac := 0;
end;

procedure TProgrammerForm.SchemaNamesItemClick(Sender: TObject);
begin
  ClearAllStringLists(ProgrammerStringLists);
  ClearAllStringLists(ProgrammerSortedStringLists);
  try
    GetSchemaNames(ProgrammerStringLists[0], MainConnection);
    SMIT(ProgrammerStringLists[0].Text, 'Schema Names...');
  finally
    ClearAllStringLists(ProgrammerStringLists);
    ClearAllStringLists(ProgrammerSortedStringLists);
  end;
end;

procedure TProgrammerForm.SelectionsItemClick(Sender: TObject);
begin
  SelectionsMainFormExamples;
end;

function ProgrammerscxGridMainFormEvents(acxGridMainForm: TForms_cxGridMainForm; const acxGridMainFormEventType: TcxGridMainFormEventType): Boolean;
begin
  Result := TRUE;

  case acxGridMainFormEventType of
    cetUserButton1Click :
      if acxGridMainForm.Caption = 'Tablolar' then Veri(Application.MainForm, acxGridMainForm.DataSource1.DataSet.FindField('Table Name').AsString, nil, FALSE, acxGridMainForm.DataSource1.DataSet.FindField('Table Name').AsString);
    cetUserButton2Click :
      if acxGridMainForm.Caption = 'Tablolar' then Veri(Application.MainForm, acxGridMainForm.DataSource1.DataSet.FindField('Table Name').AsString + ' LOG', nil, FALSE, acxGridMainForm.DataSource1.DataSet.FindField('Table Name').AsString + ' LOG');
  end;
end;

function ProgrammersMainFormEvents(aMainForm: TForms_MainForm; const aFormEventType: TFormEventType): Boolean;
begin
  Result := TRUE;

  case aFormEventType of
    fetOnClose      : ; //Sm('fetOnClose' + LB + aMainForm.Caption);
    fetOnCloseQuery : ; //Sm('fetOnCloseQuery' + LB + aMainForm.Caption);
    fetOnDestroy    : ; //Sm('fetOnDestroy' + LB + aMainForm.Caption);
    fetOnShow       : ; //Sm('fetOnShow' + LB + aMainForm.Caption);
  end;
end;

procedure ProgrammersDataSetEvents(aUniQueryEx: TUniQueryEx; const aDataSetEventType: TDataSetEventType; aField: TField);
var
  aForms_cxGridMainForm: TForms_cxGridMainForm;
begin
  case aDataSetEventType of
    detAfterScroll :
      if aUniQueryEx.Caption = 'Tablolar' then
      begin
        aForms_cxGridMainForm := GetForms_cxGridMainFormByDataSet(aUniQueryEx);
        if Assigned(aForms_cxGridMainForm) then
        begin
          aForms_cxGridMainForm.btnUser1.Enabled := TableOrViewExists(aUniQueryEx.FindField('Table Name').AsString, ApplicationSchemaName);
          aForms_cxGridMainForm.btnUser2.Enabled := TableOrViewExists(aUniQueryEx.FindField('Table Name').AsString + ' LOG', ApplicationSchemaName);
        end;
      end;

    detBeforePost: ;
    detBeforeEdit: ;
    detBeforeDelete:
      if Mce('Bu tablolara ait kayıtları çok dikkatli silmelisiniz?' + LB2 + 'Silmek istediğinize emin misiniz?') <> mrYes then Abort;

    detBeforeInsert: ;
    detOnNewRecord:
      if aUniQueryEx.Caption = 'Kolonlar' then aUniQueryEx.FindField('Required').AsBoolean := TRUE;

    detAfterPost: ;
    detFieldOnChange:
      if (aUniQueryEx.Caption = 'Kolonlar') and (aField.FieldName = 'Data Type or Compute Text') then
        if aField.AsString <> 'NVARCHAR' then aUniQueryEx.FindField('Size').AsInteger := 0;
  end;
end;

procedure TProgrammerForm.TablolarItemClick(Sender: TObject);
var
  I, J: Integer;
  St1: string;
begin
  //User Table Groups          => Grup Sıra No, Grup
  //User Tables                => Grup Sıra No, Tablo Sıra No, Table Name, Logging, Veri Girişi, Bands, Skip, BB Ocak Ayları, Display Key, View SQL, View Tables, Erişim
  //User Columns               => Table Name, Sıra No, Column Name, Data Type or Compute Text, Size, Required, Primary Key, Unique Column, Default Value, Unique Columns 1, Unique Columns 2, Unique Columns 3, Check Rule 1, Check Rule 2, Check Rule 3, Properties Class, Properties Info, Band Index, Display Format, Index Column, Klon İçin
  //User Foreign Tables        => Table Name, Sıra No, Foreign Table Name, On Delete Cascade, Foreign Calc Fields, Calc Fields Pre Columns, Where For Child, Calc Fields New Names, Klon İçin
  //User Foreign Table Columns => Table Name, Sıra No, Foreign Table Name, Column Sıra No, Column Name, Foreign Table Column, Lookup, Lookup List Field Name, Lookup Table Name, Lookup Key Field Name, Lookup Filter SQL, Lookup Filter MasterFields, Lookup Filter DetailFields, Lookup Column Name
  //User Table Clones          => Table Name, Replace From Text, Replace To Text, Replace From Text 2, Replace To Text 2, Replace From Text 3, Replace To Text 3, Replace From Text 4, Replace To Text 4, Replace From Text 5, Replace To Text 5, Columns To Remove
  //User Table ExecSQLs        => Table Name, Sıra No, ExecSQL, Show Error, On Create, All Created, Before Open, After Close, Progress, Skip
  //User Object Display Labels => Object Name, English, Aynı

  with TVeriGirisiForm.Create(GetCaption(Sender), Sender, TheProgrammersConnection.Name) do
  try
    if MainForm.Exists then Exit;

    MainForm.MainFormEventsProc := ProgrammersMainFormEvents;

    DataSet(GetTable_Programmer('User Table Groups',          'Tablo Grupları'));
    DataSet(GetTable_Programmer('User Tables',                'Tablolar'));
    DataSet(GetTable_Programmer('User Columns',               'Kolonlar'));
    DataSet(GetTable_Programmer('User Foreign Tables',        'Foreign Tablolar'));
    DataSet(GetTable_Programmer('User Foreign Table Columns', 'Foreign Tablo Kolonları'));
    DataSet(GetTable_Programmer('User Table Clones',          'Tablo Klonları (Kopya)'));
    DataSet(GetTable_Programmer('User Table ExecSQLs',        'Tablo ExecSQLleri'));
    DataSet(GetTable_Programmer('User Object Display Labels', 'Object Display Labels'));

    MasterDetail(0, 1, '"Grup Sıra No"',                              '"Grup Sıra No"',                              TRUE);
    MasterDetail(1, 2, '"Table Name"',                                '"Table Name"',                                TRUE);
    MasterDetail(1, 3, '"Table Name"',                                '"Table Name"',                                TRUE);
    MasterDetail(3, 4, '"Table Name";"Sıra No";"Foreign Table Name"', '"Table Name";"Sıra No";"Foreign Table Name"', TRUE);
    MasterDetail(1, 5, '"Table Name"',                                '"Table Name"',                                TRUE);
    MasterDetail(1, 6, '"Table Name"',                                '"Table Name"',                                TRUE);

    IndexFields(1, '"Grup Sıra No";"Tablo Sıra No"');

    for I := 0 to Length(MainForm.DataSetInformations) - 1 do TUniQueryEx(MainForm.DataSetInformations[I].DataSet).DataSetEventsProc := ProgrammersDataSetEvents;

    Grid(1);
    Grid(2, '', BandText('Sabitler', ['Ana Bilgiler', 'Diğer Bilgiler'], ['Data Type or Compute Text, Size, Required, Primary Key, Unique Column, Default Value, Display Format, Index Column',
                                                                          'Unique Columns 1, Unique Columns 2, Unique Columns 3, Check Rule 1, Check Rule 2, Check Rule 3, Properties Class, Properties Info, Band Index, Klon İçin'], TRUE));
    Grids([3, 4, 5, 6, 7]);

    UserButton(0, 0, 'Tablo Aç',     'Open The Table',     0, MainFormUtilitiesForm.cxLargeImages, 1, glLeft, '');
    UserButton(0, 1, 'LOG Tablo Aç', 'Open The LOG Table', 0, MainFormUtilitiesForm.cxLargeImages, 5, glLeft, '');

    for I := 0 to Length(MainForm.cxGridForms) - 1 do
    begin
      MainForm.cxGridForms[I].cxGridMainFormEventsProc := ProgrammerscxGridMainFormEvents;

      for J := 0 to MainForm.cxGridViews(I).ColumnCount - 1 do
        if MainForm.cxGridViews(I).Columns[J].DataBinding.Field.DataType = ftBoolean then AssignCheckBoxProperties(MainForm.cxGridViews(I).Columns[J], MainForm.cxGridViews(I).Columns[J].DataBinding.Field.Required);
    end;

    cxGridForms(0).SetLookupBar('Tablo Grubu', DataSets(0), 'Grup, Grup Sıra No', 'Grup', 0, 300);

    HideCloseItemsExceptThose([0]);

    AssignComboBoxProperties(cxGridViews(0).GetColumnByFieldName('Erişim'),      lsEditFixedList, ['', 'Admin', 'Hiçkimse', 'Read Only']);
    AssignComboBoxProperties(cxGridViews(0).GetColumnByFieldName('Display Key'), lsEditList,      ['', 'Unique Columns 1', 'Unique Columns 2', 'Unique Columns 3']);

    AssignComboBoxProperties(cxGridViews(1).GetColumnByFieldName('Data Type or Compute Text'), lsEditList, ['',
                                                                                                            'NVARCHAR',
                                                                                                            'INTEGER',
                                                                                                            'IDENTITY',
                                                                                                            'FLOAT',
                                                                                                            'BIT',
                                                                                                            'BIGIDENTITY',
                                                                                                            'BIGINT',
                                                                                                            'DATE',
                                                                                                            'TIME',
                                                                                                            'DATETIME',
                                                                                                            'NVARCHARMAX',
                                                                                                            'NVARBINARYMAX',
                                                                                                            'Yıl',
                                                                                                            'Ay']);

    AssignComboBoxProperties(cxGridViews(1).GetColumnByFieldName('Size'), lsEditFixedList, ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '15', '20', '25', '30', '35', '40', '45', '50', '75', '100', '128', '200', '256', '500', '512', '1000', '1024', '2000', '4000']);

    AssignComboBoxProperties(cxGridViews(1).GetColumnByFieldName('Default Value'), lsEditList, ['', 'TRUE', 'FALSE', '1', '0', 'CURRENT_TIMESTAMP']);

    AssignComboBoxProperties(cxGridViews(1).GetColumnByFieldName('Properties Class'), lsEditList, ['',
                                                                                                   'Color',
                                                                                                   'FontCharacterSet',
                                                                                                   'FontName',
                                                                                                   'Spin',
                                                                                                   'Check',
                                                                                                   'ZeroOneCheck',
                                                                                                   'ComboBoxEdit',
                                                                                                   'ComboBoxFixed',
                                                                                                   'ImageComboBox',
                                                                                                   'Month',
                                                                                                   'MonthName',
                                                                                                   'Month ID',
                                                                                                   'Button']);

    AssignComboBoxProperties(cxGridViews(1).GetColumnByFieldName('Display Format'), lsEditList, ['',
                                                                                                 '#,##0',
                                                                                                 '#,##0.0',
                                                                                                 '#,##0.00',
                                                                                                 '#,##0.000',
                                                                                                 '#,##0.0000',
                                                                                                 '#,##0.00000',
                                                                                                 '#,##0.000000',
                                                                                                 '#,##0.0000000',
                                                                                                 '#,##0.00000000',
                                                                                                 '#,##0.000000000',
                                                                                                 '#,##0.0000000000',
                                                                                                 '#,##0.00000000000',
                                                                                                 '#,##0.000000000000',
                                                                                                 '#,##0.0000000000000',
                                                                                                 '#,##0.00000000000000',
                                                                                                 '#,##0.#',
                                                                                                 '#,##0.##',
                                                                                                 '#,##0.###',
                                                                                                 '#,##0.####',
                                                                                                 '#,##0.#####',
                                                                                                 '#,##0.######',
                                                                                                 '#,##0.#######',
                                                                                                 '#,##0.########',
                                                                                                 '#,##0.#########',
                                                                                                 '#,##0.##########',
                                                                                                 '#,##0.###########',
                                                                                                 '#,##0.############',
                                                                                                 '#,##0.#############',
                                                                                                 '#,##0.##############',
                                                                                                 '#,##0.0#',
                                                                                                 '#,##0.00##',
                                                                                                 '#,##0.000###',
                                                                                                 '#,##0.0000####',
                                                                                                 '#,##0.00000#####',
                                                                                                 '#,##0.000000######',
                                                                                                 '#,##0.0000000#######']);

    St1 := '"[COLUMNNAME]" > 0'  + LB +
           '"[COLUMNNAME]" >= 0' + LB +
           '"[COLUMNNAME]" BETWEEN 0 AND 1';

    St1 := St1 + LB + MyAnsiReplaceStr(St1, '"[COLUMNNAME]"', '"[COLUMNNAME]" IS NULL OR "[COLUMNNAME]"');

    AssignComboBoxProperties(cxGridViews(1).GetColumnByFieldName('Check Rule 1'), lsEditList, St1);
    AssignComboBoxProperties(cxGridViews(1).GetColumnByFieldName('Check Rule 2'), lsEditList, St1);
    AssignComboBoxProperties(cxGridViews(1).GetColumnByFieldName('Check Rule 3'), lsEditList, St1);

    AssignImageComboBoxProperties(cxGridViews(5).GetColumnByFieldName('Before Open'), ['', ApplicationSchemaName, ApplicationSchemaName + ' Dışı', 'Hepsi'], [NULL, 'R', 'D', 'A']).DropDownSizeable := FALSE;
    AssignImageComboBoxProperties(cxGridViews(5).GetColumnByFieldName('After Close'), ['', ApplicationSchemaName, ApplicationSchemaName + ' Dışı', 'Hepsi'], [NULL, 'R', 'D', 'A']).DropDownSizeable := FALSE;

    CreateForm(Horz(Forms(0),
                    Page(['Kolonlar', 'Foreign Tablolar-Kolonlar', 'Tablo Klonları (Kopya)', 'Tablo ExecSQLleri', 'Object Display Labels'],
                         [Forms(1),   Horz(Forms(2), Forms(3)),    Forms(4),                 Forms(5),            Forms(6)]
                         )
                    )
               );

    ShowForm(TRUE);
  finally
    Free;
  end;
end;

procedure TProgrammerForm.UserTablesItemClick(Sender: TObject);
var
  I: Integer;
begin
  with TVeriGirisiForm.Create(GetCaption(Sender), Sender, 'User Tables ID') do
  try
    if MainForm.Exists then Exit;

    DataSet(GenelForm.UserTables,              'User Tables',                FALSE);
    DataSet(GenelForm.UserColumns,             'User Columns',               FALSE);
    DataSet(GenelForm.UserAllObjects,          'User All Objects',           FALSE);
    DataSet(GenelForm.UserForeignTables,       'User Foreign Tables',        FALSE);
    DataSet(GenelForm.UserForeignTableColumns, 'User Foreign Table Columns', FALSE);
    DataSet(GenelForm.UserTableExecSQLs,       'User Table ExecSQLs',        FALSE);
    DataSet(GenelForm.UserMenu,                'User Menü',                  FALSE);
    DataSet(GenelForm.UserMenuTablo,           'User Menü Tablo',            FALSE);

    for I := 0 to Length(MainForm.DataSetInformations) - 1 do ClearDataSetFilter(MainForm.DataSetInformations[I].DataSet, TRUE);

    Grids([0, 1, 2, 3, 4, 5, 6, 7]);

    HideCaptionItemsCaptionsExceptThose([]);

    CreateForm(Page(['User Tables', 'User Columns', 'User All Objects', 'User Foreign Tables', 'User Foreign Table Columns', 'User Table ExecSQLs', 'User Menü', 'User Menü Tablo'],
                    [Forms(0),      Forms(1),       Forms(2),           Forms(3),              Forms(4),                     Forms(5),              Forms(6),    Forms(7)]));

    ShowForm(TRUE);
  finally
    Free;
  end;
end;

procedure TProgrammerForm.VeriGirisleriItemClick(Sender: TObject);
var
  I: Integer;
begin
  //User Ana Menü    => Sıra No, Ana Menü
  //User Menü        => Ana Menü, Sıra No, Menü, Menü English, Progress
  //User Menü Tablo  => Menü, Sıra No, Table Name, 3x3 Index, Master Table Index, Master Field Names, Detail Field Names, Use Calc Fields, Extra ID, Read Only, Invisible Fields, Filter SQL, Caption, Grid Buttons, Read Only Fields, Refresh Master, Grid Read Only Fields, Bütçe Aç
  //User Menü Clones => Menü, Replace From Text, Replace To Text, Replace From Text 2, Replace To Text 2, Replace From Text 3, Replace To Text 3
  //User Tables      => Grup Sıra No, Tablo Sıra No, Table Name, Logging, Veri Girişi, Bands, Skip, BB Ocak Ayları, Display Key, View SQL, View Tables, Erişim

  with TVeriGirisiForm.Create(GetCaption(Sender), Sender, TheProgrammersConnection.Name) do
  try
    if MainForm.Exists then Exit;

    DataSet(GetTable_Programmer('User Ana Menü',    'Ana Menüler'));
    DataSet(GetTable_Programmer('User Menü',        'Menüler'));
    DataSet(GetTable_Programmer('User Menü Tablo',  'Menü Tabloları'));
    DataSet(GetTable_Programmer('User Menü Clones', 'Menü Clones'));
    DataSet(GetTable_Programmer('User Tables Ex',   'Tablolar', '', FALSE, '', FALSE, FALSE, FALSE, 'VeriGirisleriItem'));

    TrimDisplayWidthsOfDataSet(DataSets(3), 50);

    MasterDetail(0, 1, '"Ana Menü"', '', TRUE);
    MasterDetail(1, 2, '"Menü"',     '', TRUE);
    MasterDetail(1, 3, '"Menü"',     '', TRUE);

    IndexFields(0, '"Sıra No"');

    for I := 0 to Length(MainForm.DataSetInformations) - 1 do TUniQueryEx(MainForm.DataSetInformations[I].DataSet).DataSetEventsProc := ProgrammersDataSetEvents;

    Grids([0, 1, 2, 3]);

    HideCloseItemsExceptThose([1]);

    //cxGridForms(0).SetLookupBar('Ana Menü', DataSets(0), 'Ana Menü;Sıra No', 'Ana Menü', 0, 150);

    AssignComboBoxProperties(cxGridViews(2).GetColumnByFieldName('3x3 Index'),          lsFixedList,     ['', '0', '1', '2', '3', '4', '5', '6', '7', '8']);
    AssignComboBoxProperties(cxGridViews(2).GetColumnByFieldName('Master Table Index'), lsEditFixedList, ['', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10']);
    AssignComboBoxProperties(cxGridViews(2).GetColumnByFieldName('Bütçe Aç'),           lsFixedList,     ['', 'Bütçe', 'Dönem', 'Şirket', 'Bütçe-Dönem', 'Bütçe-Şirket']);

    with AssigncxLookupComboBoxProperties(cxGridForms(2).cxGrid1DBBandedTableViewMain.GetColumnByFieldName('Table Name'), lsEditList) do
    begin
      ListFieldNames := SetAndGetFieldNames('Table Name, Grup Sıra No, Tablo Sıra No, Logging, Erişim');
      KeyFieldNames  := 'Table Name';
      ListSource     := GetDataSource(DataSets(4));
    end;

    CreateForm(Horz(Vert(Forms(0), Forms(1)), Page(['Menü Tabloları', 'Menü Clones'], [Forms(2), Forms(3)])));

    ShowForm(TRUE);
  finally
    Free;
  end;
end;

initialization
  ProgrammerForm := TProgrammerForm.Create(Application);

end.
