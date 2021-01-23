unit SQLCommands;

interface

uses
  Windows, Messages, SysUtils, Variants, Types, Classes, Graphics, Controls,
  Forms,
  M_Consts,
  M_Strings,
  M_StringLists,
  M_F_Forms_Main,
  M_F_Forms_cxGridMain,
  M_cxGrid,
  M_Databases,
  M_F_Databases,
  cxDropDownEdit, cxColorComboBox, cxCheckGroup, DB, Uni, Dialogs, ImgList,
  Math, cxGraphics, cxClasses, StrUtils, MemDS, VirtualTable, DBAccess, dxBar,
  cxFontNameComboBox, cxGridDBBandedTableView, cxGridCustomView, cxButtonEdit;

type
  TFieldInformation = record
    FieldName                   : string;
    UpperFieldName              : string;
    FieldNameWithLeftRightChars : string;
    FieldType                   : Integer;
    Size                        : Integer;
    Required                    : Boolean;
    ReadOnly                    : Boolean;
    UniqueKeyIndices            : array of Integer;
  end;

  TTableOrQueryInformation = record
    TableNameOrQuery   : string;
    SchemaName         : string;
    SchemaAndTableName : string;
    Query              : Boolean;
    View               : Boolean;
    TempTable          : Boolean;
    Butce              : Boolean;
    Donem              : Boolean;
    UniqueKeyCount     : Integer;
    FieldInformations  : array of TFieldInformation;
  end;

  TTableNameOrQueryAndJoinInformation = record
    TableNameOrQuery    : string;
    InnerJoin           : Boolean;
    DirectJoinStatement : string;
  end;

  TSQLCommandType = (sctInsert, sctUpdate, sctDelete);

  TSQLCommandsForm = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
  public
    ObjectIDsFindStringLists    : TFindStringLists;
    TableOrQueryFindStringLists : TFindStringLists;
    TableOrQueryInformations    : array of TTableOrQueryInformation;
  end;

var
  SQLCommandsForm: TSQLCommandsForm;

  AktifButce : record
    ButceID       : string;
    DonemID       : string;
    SirketID      : string;
    ButceAdi      : string;
    DonemAdi      : string;
    SirketAdi     : string;
    BaslangicYili : string;
    BaslangicAyi  : string;
    BitisYili     : string;
  end;

  fToplamButce : Int64   = -1;
  fToplamDonem : Int64   = -1;

procedure ClearAktifButceInformations;

procedure ClearAllTableInformationsAndOthers(const aResetButceDonemInformationsToo: Boolean);

function GetOtherButceSirketDonemInformationsOfAktifButce: Boolean;

function ToplamButce: Int64;
function ToplamDonem: Int64;

function TempTable(aTableName: string): Boolean;

function GetTableOrQueryInformationExpanding(const aTableNameOrQuery: string): TTableOrQueryInformation;

procedure qTruncate(aTableNames: array of string; const aProgressCaption: string = ''; const aTry: Boolean = FALSE; const aShowErrorMessageOnTry: Boolean = FALSE); overload;
procedure qTruncate(const aTableName: string; const aProgressCaption: string = ''); overload;
procedure qTruncateTry(aTableNames: array of string; const aProgressCaption: string = ''; const aShowErrorMessage: Boolean = FALSE); overload;
procedure qTruncateTry(const aTableName: string; const aProgressCaption: string = ''; const aShowErrorMessage: Boolean = FALSE); overload;

function qEmpty(aTableNames: array of string; const aExtraWhereConditions: array of string; const aProgressCaption: string = ''; const aTry: Boolean = FALSE; const aShowErrorMessageOnTry: Boolean = FALSE): Int64; overload;
function qEmpty(aTableNames: array of string; const aProgressCaption: string = ''; const aTry: Boolean = FALSE; const aShowErrorMessageOnTry: Boolean = FALSE): Int64; overload;
function qEmpty(const aTableName: string; const aExtraWhereCondition: string = ''; const aProgressCaption: string = ''): Int64; overload;
function qEmptyTry(aTableNames: array of string; const aExtraWhereConditions: array of string; const aProgressCaption: string = ''; const aShowErrorMessage: Boolean = FALSE): Int64; overload;
function qEmptyTry(aTableNames: array of string; const aProgressCaption: string = ''; const aShowErrorMessage: Boolean = FALSE): Int64; overload;
function qEmptyTry(const aTableName: string; const aExtraWhereCondition: string = ''; const aProgressCaption: string = ''; const aShowErrorMessage: Boolean = FALSE): Int64; overload;

function qCopyToTemp(aTableNamesOrQueries: array of string; const aTempTableNames: array of string; const aTempTablesPrimaryKeyFieldNames: array of string; const aWhereConditions: array of string; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE; const aTry: Boolean = FALSE; const aShowErrorMessageOnTry: Boolean = FALSE): Int64; overload;
function qCopyToTemp(aTableNames: array of string; const aTempTablesPrimaryKeyFieldNames: array of string; const aWhereConditions: array of string; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE; const aTry: Boolean = FALSE; const aShowErrorMessageOnTry: Boolean = FALSE): Int64; overload;
function qCopyToTemp(const aTableNameOrQuery: string; const aTempTableName: string = ''; const aTempTablePrimaryKeyFieldNames: string = ''; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE): Int64; overload;
function qCopyToTempTry(aTableNamesOrQueries: array of string; const aTempTableNames: array of string; const aTempTablesPrimaryKeyFieldNames: array of string; const aWhereConditions: array of string; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE; const aShowErrorMessage: Boolean = FALSE): Int64; overload;
function qCopyToTempTry(aTableNames: array of string; const aTempTablesPrimaryKeyFieldNames: array of string; const aWhereConditions: array of string; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE; const aShowErrorMessage: Boolean = FALSE): Int64; overload;
function qCopyToTempTry(const aTableNameOrQuery: string; const aTempTableName: string = ''; const aTempTablePrimaryKeyFieldNames: string = ''; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE; const aShowErrorMessage: Boolean = FALSE): Int64; overload;

function qCreateTemp(aTableNamesOrQueries: array of string; const aTempTableNames: array of string; const aTempTablesPrimaryKeyFieldNames: array of string; const aProgressCaption: string = ''; const aTry: Boolean = FALSE; const aShowErrorMessageOnTry: Boolean = FALSE): Int64; overload;
function qCreateTemp(aTableNames: array of string; const aTempTablesPrimaryKeyFieldNames: array of string; const aProgressCaption: string = ''; const aTry: Boolean = FALSE; const aShowErrorMessageOnTry: Boolean = FALSE): Int64; overload;
function qCreateTemp(const aTableNameOrQuery: string; const aTempTableName: string = ''; const aTempTablePrimaryKeyFieldNames: string = ''; const aProgressCaption: string = ''): Int64; overload;
function qCreateTempTry(aTableNamesOrQueries: array of string; const aTempTableNames: array of string; const aTempTablesPrimaryKeyFieldNames: array of string; const aProgressCaption: string = ''; const aShowErrorMessage: Boolean = FALSE): Int64; overload;
function qCreateTempTry(aTableNames: array of string; const aTempTablesPrimaryKeyFieldNames: array of string; const aProgressCaption: string = ''; const aShowErrorMessage: Boolean = FALSE): Int64; overload;
function qCreateTempTry(const aTableNameOrQuery: string; const aTempTableName: string = ''; const aTempTablePrimaryKeyFieldNames: string = ''; const aProgressCaption: string = ''; const aShowErrorMessage: Boolean = FALSE): Int64; overload;

function qJoin(const aTableNameOrQuery: string; const aInnerJoin: Boolean; const aDirectJoinStatement: string = ''): TTableNameOrQueryAndJoinInformation;
function qJoinLeft(const aTableNameOrQuery: string; const aDirectJoinStatement: string = ''): TTableNameOrQueryAndJoinInformation;
function qJoinInner(const aTableNameOrQuery: string; const aDirectJoinStatement: string = ''): TTableNameOrQueryAndJoinInformation;

function fqSQLCommand(const aSQLCommandType: TSQLCommandType; const aTargetTableName: string; const aMainSourceTableNameOrQuery: string; const aOtherSourceTableNameOrQueryAndJoinInformations: array of TTableNameOrQueryAndJoinInformation; const aFieldEqualities: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE; const aNonExistings: Boolean = FALSE): Int64; overload;
function fqSQLCommand(const aSQLCommandType: TSQLCommandType; const aTargetTableName: string; const aMainSourceTableNameOrQuery: string; const aOtherSourceTableNameOrQueries: array of string; const aFieldEqualities: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE; const aNonExistings: Boolean = FALSE): Int64; overload;
function fqSQLCommand(const aSQLCommandType: TSQLCommandType; const aTargetTableName: string; const aMainSourceTableNameOrQuery: string; const aFieldEqualities: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE; const aNonExistings: Boolean = FALSE): Int64; overload;
function fqSQLCommand(const aSQLCommandType: TSQLCommandType; const aTargetTableName: string; const aMainSourceTableNameOrQuery: string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE; const aNonExistings: Boolean = FALSE): Int64; overload;
function fqSQLCommandTry(const aSQLCommandType: TSQLCommandType; const aTargetTableName: string; const aMainSourceTableNameOrQuery: string; const aOtherSourceTableNameOrQueryAndJoinInformations: array of TTableNameOrQueryAndJoinInformation; const aFieldEqualities: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE; const aNonExistings: Boolean = FALSE; const aShowErrorMessage: Boolean = FALSE): Int64; overload;
function fqSQLCommandTry(const aSQLCommandType: TSQLCommandType; const aTargetTableName: string; const aMainSourceTableNameOrQuery: string; const aOtherSourceTableNameOrQueries: array of string; const aFieldEqualities: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE; const aNonExistings: Boolean = FALSE; const aShowErrorMessage: Boolean = FALSE): Int64; overload;
function fqSQLCommandTry(const aSQLCommandType: TSQLCommandType; const aTargetTableName: string; const aMainSourceTableNameOrQuery: string; const aFieldEqualities: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE; const aNonExistings: Boolean = FALSE; const aShowErrorMessage: Boolean = FALSE): Int64; overload;

function qAppend(const aTargetTableName: string; const aMainSourceTableNameOrQuery: string; const aOtherSourceTableNameOrQueryAndJoinInformations: array of TTableNameOrQueryAndJoinInformation; const aFieldEqualities: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE): Int64; overload;
function qAppend(const aTargetTableName: string; const aMainSourceTableNameOrQuery: string; const aOtherSourceTableNameOrQueries: array of string; const aFieldEqualities: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE): Int64; overload;
function qAppend(const aTargetTableName: string; const aMainSourceTableNameOrQuery: string; const aFieldEqualities: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE): Int64; overload;
function qAppend(const aTargetTableName: string; const aMainSourceTableNameOrQuery: string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE): Int64; overload;
function qAppendTry(const aTargetTableName: string; const aMainSourceTableNameOrQuery: string; const aOtherSourceTableNameOrQueryAndJoinInformations: array of TTableNameOrQueryAndJoinInformation; const aFieldEqualities: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE; const aShowErrorMessage: Boolean = FALSE): Int64; overload;
function qAppendTry(const aTargetTableName: string; const aMainSourceTableNameOrQuery: string; const aOtherSourceTableNameOrQueries: array of string; const aFieldEqualities: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE; const aShowErrorMessage: Boolean = FALSE): Int64; overload;
function qAppendTry(const aTargetTableName: string; const aMainSourceTableNameOrQuery: string; const aFieldEqualities: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE; const aShowErrorMessage: Boolean = FALSE): Int64; overload;
function qAppendTry(const aTargetTableName: string; const aMainSourceTableNameOrQuery: string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE; const aShowErrorMessage: Boolean = FALSE): Int64; overload;

function qAppendNonExistings(const aTargetTableName: string; const aMainSourceTableNameOrQuery: string; const aOtherSourceTableNameOrQueryAndJoinInformations: array of TTableNameOrQueryAndJoinInformation; const aFieldEqualities: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE): Int64; overload;
function qAppendNonExistings(const aTargetTableName: string; const aMainSourceTableNameOrQuery: string; const aOtherSourceTableNameOrQueries: array of string; const aFieldEqualities: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE): Int64; overload;
function qAppendNonExistings(const aTargetTableName: string; const aMainSourceTableNameOrQuery: string; const aFieldEqualities: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE): Int64; overload;
function qAppendNonExistings(const aTargetTableName: string; const aMainSourceTableNameOrQuery: string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE): Int64; overload;
function qAppendNonExistingsTry(const aTargetTableName: string; const aMainSourceTableNameOrQuery: string; const aOtherSourceTableNameOrQueryAndJoinInformations: array of TTableNameOrQueryAndJoinInformation; const aFieldEqualities: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE; const aShowErrorMessage: Boolean = FALSE): Int64; overload;
function qAppendNonExistingsTry(const aTargetTableName: string; const aMainSourceTableNameOrQuery: string; const aOtherSourceTableNameOrQueries: array of string; const aFieldEqualities: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE; const aShowErrorMessage: Boolean = FALSE): Int64; overload;
function qAppendNonExistingsTry(const aTargetTableName: string; const aMainSourceTableNameOrQuery: string; const aFieldEqualities: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE; const aShowErrorMessage: Boolean = FALSE): Int64; overload;
function qAppendNonExistingsTry(const aTargetTableName: string; const aMainSourceTableNameOrQuery: string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE; const aShowErrorMessage: Boolean = FALSE): Int64; overload;

function qUpdate(const aTargetTableName: string; const aOtherSourceTableNameOrQueryAndJoinInformations: array of TTableNameOrQueryAndJoinInformation; const aFieldEqualities: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE): Int64; overload;
function qUpdate(const aTargetTableName: string; const aOtherSourceTableNameOrQueries: array of string; const aFieldEqualities: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE): Int64; overload;
function qUpdate(const aTargetTableName: string; const aFieldEqualities: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE): Int64; overload;
function qUpdateTry(const aTargetTableName: string; const aOtherSourceTableNameOrQueryAndJoinInformations: array of TTableNameOrQueryAndJoinInformation; const aFieldEqualities: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE; const aShowErrorMessage: Boolean = FALSE): Int64; overload;
function qUpdateTry(const aTargetTableName: string; const aOtherSourceTableNameOrQueries: array of string; const aFieldEqualities: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE; const aShowErrorMessage: Boolean = FALSE): Int64; overload;
function qUpdateTry(const aTargetTableName: string; const aFieldEqualities: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE; const aShowErrorMessage: Boolean = FALSE): Int64; overload;

function qEmpty(const aTargetTableName: string; const aOtherSourceTableNameOrQueryAndJoinInformations: array of TTableNameOrQueryAndJoinInformation; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE): Int64; overload;
function qEmpty(const aTargetTableName: string; const aOtherSourceTableNameOrQueries: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE): Int64; overload;
function qEmptyTry(const aTargetTableName: string; const aOtherSourceTableNameOrQueryAndJoinInformations: array of TTableNameOrQueryAndJoinInformation; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE; const aShowErrorMessage: Boolean = FALSE): Int64; overload;
function qEmptyTry(const aTargetTableName: string; const aOtherSourceTableNameOrQueries: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE; const aShowErrorMessage: Boolean = FALSE): Int64; overload;

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
  M_Compression,
  M_F_SelectFilter;

procedure ClearAktifButceInformations;
begin
  AktifButce.ButceID       := '';
  AktifButce.DonemID       := '';
  AktifButce.SirketID      := '';
  AktifButce.ButceAdi      := '';
  AktifButce.DonemAdi      := '';
  AktifButce.SirketAdi     := '';
  AktifButce.BaslangicYili := '';
  AktifButce.BaslangicAyi  := '';
  AktifButce.BitisYili     := '';
end;

procedure ClearAllTableInformationsAndOthers(const aResetButceDonemInformationsToo: Boolean);
begin
  SQLCommandsForm.ObjectIDsFindStringLists.Clear;
  SQLCommandsForm.TableOrQueryFindStringLists.Clear;
  SetLength(SQLCommandsForm.TableOrQueryInformations, 0);

  fToplamButce := -1;
  fToplamDonem := -1;

  if aResetButceDonemInformationsToo then ClearAktifButceInformations;
end;

function GetOtherButceSirketDonemInformationsOfAktifButce: Boolean;
begin
  Result := FALSE;

  if AktifButce.ButceID = '' then Exit;

  with TUniQuery.Create(nil) do
  try
    Connection     := MainConnection;
    UniDirectional := TRUE;

    SQL.Text := 'SELECT * FROM "' + ApplicationSchemaName + '"."Bütçe" WHERE "Bütçe ID" = ' + AktifButce.ButceID;
    Active   := TRUE;

    if Eof then
    begin
      ClearAktifButceInformations;
      Exit;
    end
    else
    begin
      AktifButce.ButceAdi := FindField('Bütçe').AsString;
      AktifButce.DonemID  := FindField('Dönem ID').AsString;
      AktifButce.SirketID := FindField('Şirket ID').AsString;

      Active   := FALSE;
      SQL.Text := 'SELECT * FROM "' + ApplicationSchemaName + '"."Şirket" WHERE "Şirket ID" = ' + AktifButce.SirketID;
      Active   := TRUE;

      AktifButce.SirketAdi := FindField('Şirket').AsString;
    end;

    Active   := FALSE;
    SQL.Text := 'SELECT * FROM "' + ApplicationSchemaName + '"."Dönem" WHERE "Dönem ID" = ' + AktifButce.DonemID;
    Active   := TRUE;

    AktifButce.DonemAdi      := FindField('Dönem').AsString;
    AktifButce.BaslangicYili := FindField('Başlangıç Yılı').AsString;
    AktifButce.BaslangicAyi  := FindField('Başlangıç Ayı').AsString;
    AktifButce.BitisYili     := FindField('Bitiş Yılı').AsString;
  finally
    Free;
  end;

  Result := TRUE;
end;

function ToplamButce: Int64;
begin
  if fToplamButce < 0 then fToplamButce := RecordCountOfTable('"' + ApplicationSchemaName + '"."Bütçe"', '', MainConnection);
  Result := fToplamButce;
end;

function ToplamDonem: Int64;
begin
  if fToplamDonem < 0 then fToplamDonem := RecordCountOfTable('"' + ApplicationSchemaName + '"."Dönem"', '', MainConnection);
  Result := fToplamDonem;
end;

function TempTable(aTableName: string): Boolean;
begin
  aTableName := TrimLeft(aTableName);

  if aTableName <> '' then
    Result := aTableName[1] = '#'
  else
    Result := FALSE;
end;

function GetTableOrQueryInformationExpanding(const aTableNameOrQuery: string): TTableOrQueryInformation;
var
  I, J, F, K, aIndex: Integer;
  St1, aHexaTableNameOrQuery, aObjectID: string;
  aApplicationSchemaName: Boolean;
begin
  if TempTable(aTableNameOrQuery) then
    with TUniQuery.Create(nil) do
    try
      Connection := MainConnection;

      Result.View               := FALSE;
      Result.TempTable          := TRUE;
      Result.Butce              := FALSE;
      Result.Donem              := FALSE;
      Result.Query              := FALSE;
      Result.TableNameOrQuery   := aTableNameOrQuery;
      Result.SchemaAndTableName := aTableNameOrQuery;
      Result.SchemaName         := '';

      SQL.Text  := 'SELECT * FROM ' + aTableNameOrQuery;
      FilterSQL := '1 = 2';

      try
        Active := TRUE;
      except
        on Ex: Exception do
        begin
          Me_X('function GetTableOrQueryInformationExpanding(...' + LB2 + 'FinalSQL:' + LB + FinalSQL + LB2 + 'SQL:' + LB + aTableNameOrQuery + LB2 + 'Hata mesajı:' + LB + ExceptionMessage(Ex));

          FilterSQL := '';

          try
            Active := TRUE;
          except
            on Ex: Exception do
            begin
              Me_X('Yazılım hatası!' + LB2 +
                   'Tablo adı veya Query: ' + aTableNameOrQuery + LB2 +
                   'TableNameOrQuery: ' + Result.TableNameOrQuery + LB2 +
                   'SchemaName: ' + Result.SchemaName + LB2 +
                   '(SQLCommands.pas... GetTableOrQueryInformationExpanding...)');

              raise Exception.Create(ExceptionMessage(Ex));
            end;
          end;
        end;
      end;

      SetLength(Result.FieldInformations, FieldCount);

      for I := 0 to FieldCount - 1 do
      begin
        if not Result.Butce then Result.Butce := Fields[I].FieldName = 'Bütçe ID';
        if not Result.Donem then Result.Donem := Fields[I].FieldName = 'Dönem ID';

        Result.FieldInformations[I].FieldName                   := Fields[I].FieldName;
        Result.FieldInformations[I].UpperFieldName              := AnsiUpperCase(Fields[I].FieldName);
        Result.FieldInformations[I].FieldNameWithLeftRightChars := GetObjectNameWithLeftRightCharacters(Fields[I].FieldName);
        Result.FieldInformations[I].FieldType                   := Integer(Fields[I].DataType);
        Result.FieldInformations[I].Size                        := Fields[I].Size;
        Result.FieldInformations[I].Required                    := Fields[I].Required;
        Result.FieldInformations[I].ReadOnly                    := not Fields[I].CanModify;
      end;

      Exit;
    finally
      Free;
    end;

  aHexaTableNameOrQuery := MyEncodeText(aTableNameOrQuery);

  if SQLCommandsForm.TableOrQueryFindStringLists.Find(aHexaTableNameOrQuery, J, F) then
    aIndex := StrToInt(SQLCommandsForm.TableOrQueryFindStringLists.ValuesLists[0][J][F])
  else
  begin
    aIndex := SQLCommandsForm.TableOrQueryFindStringLists.Count;

    if aIndex = Length(SQLCommandsForm.TableOrQueryInformations) then SetLength(SQLCommandsForm.TableOrQueryInformations, GetValidSetLengthLength(Length(SQLCommandsForm.TableOrQueryInformations)));

    SQLCommandsForm.TableOrQueryFindStringLists.Add(aHexaTableNameOrQuery, [IntToStr(aIndex)], J, F);

    SQLCommandsForm.TableOrQueryInformations[aIndex].View      := FALSE;
    SQLCommandsForm.TableOrQueryInformations[aIndex].TempTable := FALSE;
    SQLCommandsForm.TableOrQueryInformations[aIndex].Butce     := FALSE;
    SQLCommandsForm.TableOrQueryInformations[aIndex].Donem     := FALSE;
  end;

  if Length(SQLCommandsForm.TableOrQueryInformations[aIndex].FieldInformations) > 0 then
  begin
    Result := SQLCommandsForm.TableOrQueryInformations[aIndex];
    Exit;
  end;

  with TUniQuery.Create(nil) do
  try
    Connection := MainConnection;

    if SQLCommandsForm.ObjectIDsFindStringLists.Count = 0 then
    begin
      SQL.Text := 'SELECT' + LB +
                  '  T1.name AS "Schema Name", T2.name AS "Object Name", T2.object_id, T2.type' + LB +
                  'FROM sys.schemas T1' + LB +
                  '  INNER JOIN sys.all_objects T2 ON T2.schema_id = T1.schema_id AND T2.type IN (''S'', ''U'', ''V'')';

      Active := TRUE;

      while not Eof do
      begin
        SQLCommandsForm.ObjectIDsFindStringLists.Add('"' + AnsiUpperCase(Fields[0].AsString) + '"."' + AnsiUpperCase(Fields[1].AsString) + '"', [Fields[2].AsString, AnsiUpperCase(Fields[3].AsString)], J, F);

        Next;
      end;

      Active := FALSE;
    end;

    with SQLCommandsForm.TableOrQueryInformations[aIndex] do ExtractTableSchemaAndDatabaseNamesFromFullTableName(aTableNameOrQuery, TableNameOrQuery, SchemaName, St1);

    if SQLCommandsForm.TableOrQueryInformations[aIndex].SchemaName <> '' then
      if not SQLCommandsForm.ObjectIDsFindStringLists.Find('"' + AnsiUpperCase(SQLCommandsForm.TableOrQueryInformations[aIndex].SchemaName) + '"."' + AnsiUpperCase(SQLCommandsForm.TableOrQueryInformations[aIndex].TableNameOrQuery) + '"', J, F) then
        F := -1
      else
    else
      if SQLCommandsForm.ObjectIDsFindStringLists.Find('"' + ApplicationSchemaName + '"."' + AnsiUpperCase(SQLCommandsForm.TableOrQueryInformations[aIndex].TableNameOrQuery) + '"', J, F) then
        SQLCommandsForm.TableOrQueryInformations[aIndex].SchemaName := ApplicationSchemaName
      else
        if SQLCommandsForm.ObjectIDsFindStringLists.Find('"' + AnsiUpperCase(MainSchemaName) + '"."' + AnsiUpperCase(SQLCommandsForm.TableOrQueryInformations[aIndex].TableNameOrQuery) + '"', J, F) then
          SQLCommandsForm.TableOrQueryInformations[aIndex].SchemaName := MainSchemaName
        else
          F := -1;

    if F = -1 then
    begin
      if not IsSelectTry(aTableNameOrQuery, MainConnection, TheProgrammersComputer) then
      begin
        SIT_X(SQLCommandsForm.ObjectIDsFindStringLists.GetSortedListsTexts);
        raise Exception.Create('Yazılım hatası!' + LB2 +
                               'Tablo adı veya Query: ' + aTableNameOrQuery + LB2 +
                               'TableNameOrQuery: ' + SQLCommandsForm.TableOrQueryInformations[aIndex].TableNameOrQuery + LB2 +
                               'SchemaName: ' + SQLCommandsForm.TableOrQueryInformations[aIndex].SchemaName + LB2 +
                               '(SQLCommands.pas... GetTableOrQueryInformationExpanding...)');
      end;

      SQLCommandsForm.TableOrQueryInformations[aIndex].Query              := TRUE;
      SQLCommandsForm.TableOrQueryInformations[aIndex].TableNameOrQuery   := aTableNameOrQuery;
      SQLCommandsForm.TableOrQueryInformations[aIndex].SchemaAndTableName := '(' + aTableNameOrQuery + ')';
      SQLCommandsForm.TableOrQueryInformations[aIndex].SchemaName         := '';

      SQL.Text  := aTableNameOrQuery;
      FilterSQL := '1 = 2';

      try
        Active := TRUE;
      except
        on Ex: Exception do
        begin
          Me_X('function GetTableOrQueryInformationExpanding(...' + LB2 + 'FinalSQL:' + LB + FinalSQL + LB2 + 'SQL:' + LB + aTableNameOrQuery + LB2 + 'Hata mesajı:' + LB + ExceptionMessage(Ex));

          FilterSQL := '';

          try
            Active := TRUE;
          except
            on Ex: Exception do
            begin
              Me_X('Yazılım hatası!' + LB2 +
                   'Tablo adı veya Query: ' + aTableNameOrQuery + LB2 +
                   'TableNameOrQuery: ' + SQLCommandsForm.TableOrQueryInformations[aIndex].TableNameOrQuery + LB2 +
                   'SchemaName: ' + SQLCommandsForm.TableOrQueryInformations[aIndex].SchemaName + LB2 +
                   '(SQLCommands.pas... GetTableOrQueryInformationExpanding...)');

              raise Exception.Create(ExceptionMessage(Ex));
            end;
          end;
        end;
      end;

      SetLength(SQLCommandsForm.TableOrQueryInformations[aIndex].FieldInformations, FieldCount);

      for I := 0 to FieldCount - 1 do
      begin
        if not SQLCommandsForm.TableOrQueryInformations[aIndex].Butce then SQLCommandsForm.TableOrQueryInformations[aIndex].Butce := Fields[I].FieldName = 'Bütçe ID';
        if not SQLCommandsForm.TableOrQueryInformations[aIndex].Donem then SQLCommandsForm.TableOrQueryInformations[aIndex].Donem := Fields[I].FieldName = 'Dönem ID';

        SQLCommandsForm.TableOrQueryInformations[aIndex].FieldInformations[I].FieldName                   := Fields[I].FieldName;
        SQLCommandsForm.TableOrQueryInformations[aIndex].FieldInformations[I].UpperFieldName              := AnsiUpperCase(Fields[I].FieldName);
        SQLCommandsForm.TableOrQueryInformations[aIndex].FieldInformations[I].FieldNameWithLeftRightChars := GetObjectNameWithLeftRightCharacters(Fields[I].FieldName);
        SQLCommandsForm.TableOrQueryInformations[aIndex].FieldInformations[I].FieldType                   := Integer(Fields[I].DataType);
        SQLCommandsForm.TableOrQueryInformations[aIndex].FieldInformations[I].Size                        := Fields[I].Size;
        SQLCommandsForm.TableOrQueryInformations[aIndex].FieldInformations[I].Required                    := Fields[I].Required;
        SQLCommandsForm.TableOrQueryInformations[aIndex].FieldInformations[I].ReadOnly                    := not Fields[I].CanModify;
      end;

      Active := FALSE;
    end
    else
    begin
      SQLCommandsForm.TableOrQueryInformations[aIndex].Query := FALSE;
      SQLCommandsForm.TableOrQueryInformations[aIndex].View  := SQLCommandsForm.ObjectIDsFindStringLists.ValuesLists[1][J][F] = 'V';

      aObjectID := SQLCommandsForm.ObjectIDsFindStringLists.ValuesLists[0][J][F];

      SQL.Text := 'SELECT name, system_type_id, max_length, is_nullable, is_computed, is_identity FROM sys.all_columns WHERE object_id = ' + aObjectID + ' ORDER BY column_id';
      Active   := TRUE;

      SetLength(SQLCommandsForm.TableOrQueryInformations[aIndex].FieldInformations, RecordCount);

      //columns       => object_id, name, column_id, system_type_id, user_type_id, max_length, precision, scale, collation_name, is_nullable, is_ansi_padded, is_rowguidcol, is_identity, is_computed, is_filestream, is_replicated, is_non_sql_subscribed, is_merge_published, is_dts_replicated, is_xml_document, xml_collection_id, default_object_id, rule_object_id, is_sparse, is_column_set
      //indexes       => object_id, name, index_id, type, type_desc, is_unique, data_space_id, ignore_dup_key, is_primary_key, is_unique_constraint, fill_factor, is_padded, is_disabled, is_hypothetical, allow_row_locks, allow_page_locks, has_filter, filter_definition
      //index_columns => object_id, index_id, index_column_id, column_id, key_ordinal, partition_ordinal, is_descending_key, is_included_column

      aApplicationSchemaName := AnsiUpperCase(SQLCommandsForm.TableOrQueryInformations[aIndex].SchemaName) = AnsiUpperCase(ApplicationSchemaName);

      I := 0;
      while not Eof do
      begin
        if aApplicationSchemaName and not SQLCommandsForm.TableOrQueryInformations[aIndex].Butce then SQLCommandsForm.TableOrQueryInformations[aIndex].Butce := Fields[0].AsString = 'Bütçe ID';
        if aApplicationSchemaName and not SQLCommandsForm.TableOrQueryInformations[aIndex].Donem then SQLCommandsForm.TableOrQueryInformations[aIndex].Donem := Fields[0].AsString = 'Dönem ID';

        SQLCommandsForm.TableOrQueryInformations[aIndex].FieldInformations[I].FieldName                   := Fields[0].AsString;
        SQLCommandsForm.TableOrQueryInformations[aIndex].FieldInformations[I].UpperFieldName              := AnsiUpperCase(Fields[0].AsString);
        SQLCommandsForm.TableOrQueryInformations[aIndex].FieldInformations[I].FieldNameWithLeftRightChars := GetObjectNameWithLeftRightCharacters(Fields[0].AsString);
        SQLCommandsForm.TableOrQueryInformations[aIndex].FieldInformations[I].FieldType                   := Fields[1].AsInteger;
        SQLCommandsForm.TableOrQueryInformations[aIndex].FieldInformations[I].Size                        := Fields[2].AsInteger;
        SQLCommandsForm.TableOrQueryInformations[aIndex].FieldInformations[I].Required                    := not Fields[3].AsBoolean;
        SQLCommandsForm.TableOrQueryInformations[aIndex].FieldInformations[I].ReadOnly                    := Fields[4].AsBoolean or Fields[5].AsBoolean;

        Inc(I);

        Next;
      end;

      with SQLCommandsForm.TableOrQueryInformations[aIndex] do SchemaAndTableName := GetSchemaAndTableName(TableNameOrQuery, SchemaName, MainConnection);

      Active   := FALSE;
      SQL.Text := 'SELECT object_id FROM sys.indexes WHERE object_id = ' + aObjectID + ' AND is_unique = ''TRUE'' AND is_disabled = ''FALSE''';
      Active   := TRUE;

      K := RecordCount;
      SQLCommandsForm.TableOrQueryInformations[aIndex].UniqueKeyCount := K;

      if K > 0 then
      begin
        for I := 0 to Length(SQLCommandsForm.TableOrQueryInformations[aIndex].FieldInformations) - 1 do
        begin
          SetLength(SQLCommandsForm.TableOrQueryInformations[aIndex].FieldInformations[I].UniqueKeyIndices, K);

          for J := 0 to K - 1 do SQLCommandsForm.TableOrQueryInformations[aIndex].FieldInformations[I].UniqueKeyIndices[J] := -1;
        end;

        Active   := FALSE;
        SQL.Text := 'SELECT index_id, index_column_id, column_id FROM sys.index_columns WHERE object_id = ' + aObjectID;
        Active   := TRUE;

        while not Eof do
        begin
          SQLCommandsForm.TableOrQueryInformations[aIndex].FieldInformations[Fields[2].AsInteger - 1].UniqueKeyIndices[Fields[0].AsInteger - 1] := Fields[1].AsInteger - 1;

          Next;
        end;
      end;
    end;

    Result := SQLCommandsForm.TableOrQueryInformations[aIndex];
  finally
    Free;
  end;
end;

procedure qTruncate(aTableNames: array of string; const aProgressCaption: string = ''; const aTry: Boolean = FALSE; const aShowErrorMessageOnTry: Boolean = FALSE);
var
  I: Integer;
  aSchemaAndTableName: string;
begin
  if aProgressCaption <> '' then
    if Length(aTableNames) > 1 then
      ProgressStartAsNormalNeverCancel(aProgressCaption, Length(aTableNames), TRUE)
    else
      ProgressStartAsWaitMessage(aProgressCaption);
  try
    for I := 0 to Length(aTableNames) - 1 do
    try
      aTableNames[I] := Trim(aTableNames[I]);

      if TempTable(aTableNames[I]) then
      begin
        aTableNames[I] := GetObjectNameWithLeftRightCharacters(aTableNames[I]);

        if aProgressCaption <> '' then
          if Length(aTableNames) > 1 then
            ProgressCanceled(1, 1, aProgressCaption + LB2 + aTableNames[I])
          else
            ProgressChangeMessage(aProgressCaption + LB2 + aTableNames[I], TRUE);

        ExecSQL('DELETE FROM ' + aTableNames[I], '', MainConnection, 'Delete');
      end
      else
      begin
        aSchemaAndTableName := GetTableOrQueryInformationExpanding(aTableNames[I]).SchemaAndTableName;

        if aProgressCaption <> '' then
          if Length(aTableNames) > 1 then
            ProgressCanceled(1, 1, aProgressCaption + LB2 + aSchemaAndTableName)
          else
            ProgressChangeMessage(aProgressCaption + LB2 + aSchemaAndTableName, TRUE);

        try
          ExecSQL('TRUNCATE TABLE ' + aSchemaAndTableName, '', MainConnection, 'Truncate');
        except
          ExecSQL('DELETE FROM ' + aSchemaAndTableName, '', MainConnection, 'Delete');
        end;
      end;
    except
      on Ex: Exception do
        if not aTry then
          raise Exception.Create(ExceptionMessage(Ex))
        else
          if aShowErrorMessageOnTry then Me(ExceptionMessage(Ex));
    end;
  finally
    if aProgressCaption <> '' then ProgressFinish;
  end;
end;

procedure qTruncate(const aTableName: string; const aProgressCaption: string = '');
begin
  qTruncate([aTableName], aProgressCaption, FALSE, FALSE);
end;

procedure qTruncateTry(aTableNames: array of string; const aProgressCaption: string = ''; const aShowErrorMessage: Boolean = FALSE);
begin
  qTruncate(aTableNames, aProgressCaption, TRUE, aShowErrorMessage);
end;

procedure qTruncateTry(const aTableName: string; const aProgressCaption: string = ''; const aShowErrorMessage: Boolean = FALSE);
begin
  qTruncate([aTableName], aProgressCaption, TRUE, aShowErrorMessage);
end;

function qEmpty(aTableNames: array of string; const aExtraWhereConditions: array of string; const aProgressCaption: string = ''; const aTry: Boolean = FALSE; const aShowErrorMessageOnTry: Boolean = FALSE): Int64;
var
  I: Integer;
  I64: Int64;
  aSQLText, aExtraWhereCondition: string;
  aTableInformation: TTableOrQueryInformation;
begin
  Result := 0;

  if aProgressCaption <> '' then
    if Length(aTableNames) > 1 then
      ProgressStartAsNormalNeverCancel(aProgressCaption, Length(aTableNames), TRUE)
    else
      ProgressStartAsWaitMessage(aProgressCaption);
  try
    for I := 0 to Length(aTableNames) - 1 do
    try
      aTableNames[I] := Trim(aTableNames[I]);

      if Length(aExtraWhereConditions) > I then
        aExtraWhereCondition := Trim(aExtraWhereConditions[I])
      else
        aExtraWhereCondition := '';

      if TempTable(aTableNames[I]) then
      begin
        aTableNames[I] := GetObjectNameWithLeftRightCharacters(aTableNames[I]);

        if aProgressCaption <> '' then
          if Length(aTableNames) > 1 then
            ProgressCanceled(1, 1, aProgressCaption + LB2 + aTableNames[I])
          else
            ProgressChangeMessage(aProgressCaption + LB2 + aTableNames[I], TRUE);

        aSQLText := 'DELETE FROM ' + aTableNames[I] + IfThen(aExtraWhereCondition <> '', LB + 'FROM ' + aTableNames[I] + ' T1' + LB + 'WHERE ' + aExtraWhereCondition, '');
      end
      else
      begin
        aTableInformation := GetTableOrQueryInformationExpanding(aTableNames[I]);

        if aProgressCaption <> '' then
          if Length(aTableNames) > 1 then
            ProgressCanceled(1, 1, aProgressCaption + LB2 + aTableInformation.SchemaAndTableName)
          else
            ProgressChangeMessage(aProgressCaption + LB2 + aTableInformation.SchemaAndTableName, TRUE);

        if aExtraWhereCondition = '' then
          if (not aTableInformation.Butce or (ToplamButce = 1)) and (not aTableInformation.Donem or (ToplamDonem = 1)) then
          begin
            try
              ExecSQL('TRUNCATE TABLE ' + aTableInformation.SchemaAndTableName, '', MainConnection, 'Truncate');
            except
              I64 := ExecSQL('DELETE FROM ' + aTableInformation.SchemaAndTableName, '', MainConnection, 'Delete');
              if I64 > 0 then Inc(Result, I64);
            end;

            Continue;
          end;

        if aTableInformation.Butce then
          aSQLText := 'DELETE FROM ' + aTableInformation.SchemaAndTableName + LB + 'FROM ' + aTableInformation.SchemaAndTableName + ' T1' + LB + 'WHERE T1.' + GetObjectNameWithLeftRightCharacters('Bütçe ID') + ' = ' + AktifButce.ButceID + IfThen(aExtraWhereCondition <> '', ' AND (' + aExtraWhereCondition + ')', '')
        else
          if aTableInformation.Donem then
            aSQLText := 'DELETE FROM ' + aTableInformation.SchemaAndTableName + LB + 'FROM ' + aTableInformation.SchemaAndTableName + ' T1' + LB + 'WHERE T1.' + GetObjectNameWithLeftRightCharacters('Dönem ID') + ' = ' + AktifButce.DonemID + IfThen(aExtraWhereCondition <> '', ' AND (' + aExtraWhereCondition + ')', '')
          else
            aSQLText := 'DELETE FROM ' + aTableInformation.SchemaAndTableName + IfThen(aExtraWhereCondition <> '', LB + 'FROM ' + aTableInformation.SchemaAndTableName + ' T1' + LB + 'WHERE ' + aExtraWhereCondition, '');
      end;

      I64 := ExecSQL(aSQLText, '', MainConnection, 'Delete');
      if I64 > 0 then Inc(Result, I64);
    except
      on Ex: Exception do
        if not aTry then
          raise Exception.Create(ExceptionMessage(Ex))
        else
          if aShowErrorMessageOnTry then Me(ExceptionMessage(Ex));
    end;
  finally
    if aProgressCaption <> '' then ProgressFinish;
  end;
end;

function qEmpty(aTableNames: array of string; const aProgressCaption: string = ''; const aTry: Boolean = FALSE; const aShowErrorMessageOnTry: Boolean = FALSE): Int64;
begin
  Result := qEmpty(aTableNames, [], aProgressCaption, aTry, aShowErrorMessageOnTry);
end;

function qEmpty(const aTableName: string; const aExtraWhereCondition: string = ''; const aProgressCaption: string = ''): Int64;
begin
  Result := qEmpty([aTableName], [aExtraWhereCondition], aProgressCaption, FALSE, FALSE);
end;

function qEmptyTry(aTableNames: array of string; const aExtraWhereConditions: array of string; const aProgressCaption: string = ''; const aShowErrorMessage: Boolean = FALSE): Int64;
begin
  Result := qEmpty(aTableNames, aExtraWhereConditions, aProgressCaption, TRUE, aShowErrorMessage);
end;

function qEmptyTry(aTableNames: array of string; const aProgressCaption: string = ''; const aShowErrorMessage: Boolean = FALSE): Int64;
begin
  Result := qEmpty(aTableNames, [], aProgressCaption, TRUE, aShowErrorMessage);
end;

function qEmptyTry(const aTableName: string; const aExtraWhereCondition: string = ''; const aProgressCaption: string = ''; const aShowErrorMessage: Boolean = FALSE): Int64;
begin
  Result := qEmpty([aTableName], [aExtraWhereCondition], aProgressCaption, TRUE, aShowErrorMessage);
end;

function qCopyToTemp(aTableNamesOrQueries: array of string; const aTempTableNames: array of string; const aTempTablesPrimaryKeyFieldNames: array of string; const aWhereConditions: array of string; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE; const aTry: Boolean = FALSE; const aShowErrorMessageOnTry: Boolean = FALSE): Int64;
var
  I: Integer;
  I64: Int64;
  aTempTableName, aSQLText, aWhereCondition: string;
  aTableInformation: TTableOrQueryInformation;
begin
  Result := 0;

  if aProgressCaption <> '' then
    if Length(aTableNamesOrQueries) > 1 then
      ProgressStartAsNormalNeverCancel(aProgressCaption, Length(aTableNamesOrQueries), TRUE)
    else
      ProgressStartAsWaitMessage(aProgressCaption);
  try
    for I := 0 to Length(aTableNamesOrQueries) - 1 do
    try
      aTableNamesOrQueries[I] := Trim(aTableNamesOrQueries[I]);

      if Length(aTempTableNames) > I then
        aTempTableName := MyCoalesce([Trim(aTempTableNames[I]), aTableNamesOrQueries[I]])
      else
        aTempTableName := aTableNamesOrQueries[I];

      if not TempTable(aTempTableName) then aTempTableName := '#' + aTempTableName;

      aTempTableName := GetObjectNameWithLeftRightCharacters(aTempTableName);

      aTableInformation := GetTableOrQueryInformationExpanding(aTableNamesOrQueries[I]);

      if aProgressCaption <> '' then
        if Length(aTableNamesOrQueries) > 1 then
          ProgressCanceled(1, 1, aProgressCaption + LB2 + aTableInformation.SchemaAndTableName)
        else
          ProgressChangeMessage(aProgressCaption + LB2 + aTableInformation.SchemaAndTableName, TRUE);

      if ValidSQL('SELECT 1 AS KOD FROM ' + aTempTableName + ' WHERE 1 = 2', MainConnection) then ExecSQL('DROP TABLE ' + aTempTableName, '', MainConnection, 'Drop');

      aSQLText := 'SELECT * INTO ' + aTempTableName + ' FROM ' + aTableInformation.SchemaAndTableName + IfThen(aTableInformation.Query, ' T1', '');

      aWhereCondition := '';

      if not aAllRecordsNotJustCurrentBudgetOrPeriod then
        if aTableInformation.Butce then
          aWhereCondition := IfThen(aTableInformation.Query, 'T1.', '') + GetObjectNameWithLeftRightCharacters('Bütçe ID') + ' = ' + AktifButce.ButceID
        else
          if aTableInformation.Donem then aWhereCondition := IfThen(aTableInformation.Query, 'T1.', '') + GetObjectNameWithLeftRightCharacters('Dönem ID') + ' = ' + AktifButce.DonemID;

      if Length(aTempTableNames) > I then
        if Trim(aWhereConditions[I]) <> '' then
          if aWhereCondition = '' then
            aWhereCondition := Trim(aWhereConditions[I])
          else
            aWhereCondition := '(' + aWhereCondition + ') AND (' + Trim(aWhereConditions[I]) + ')';

      if aWhereCondition <> '' then aSQLText := aSQLText + ' WHERE ' + aWhereCondition;

      I64 := ExecSQL(aSQLText, '', MainConnection, 'SelectInto');
      if I64 > 0 then Inc(Result, I64);

      if Length(aTempTablesPrimaryKeyFieldNames) > I then
        if aTempTablesPrimaryKeyFieldNames[I] <> '' then
        begin
          aSQLText := 'ALTER TABLE ' + aTempTableName + ' ADD PRIMARY KEY (' + SetAndGetFieldNames(RemoveCharsFromText(aTempTablesPrimaryKeyFieldNames[I], '"[]'), ', ', '"', '"') + ')';

          ExecSQL(aSQLText, '', MainConnection, 'PrimaryKey');
        end;
    except
      on Ex: Exception do
        if not aTry then
          raise Exception.Create(ExceptionMessage(Ex))
        else
          if aShowErrorMessageOnTry then Me(ExceptionMessage(Ex));
    end;
  finally
    if aProgressCaption <> '' then ProgressFinish;
  end;
end;

function qCopyToTemp(aTableNames: array of string; const aTempTablesPrimaryKeyFieldNames: array of string; const aWhereConditions: array of string; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE; const aTry: Boolean = FALSE; const aShowErrorMessageOnTry: Boolean = FALSE): Int64;
begin
  Result := qCopyToTemp(aTableNames, [], aTempTablesPrimaryKeyFieldNames, aWhereConditions, aProgressCaption, aAllRecordsNotJustCurrentBudgetOrPeriod, aTry, aShowErrorMessageOnTry);
end;

function qCopyToTemp(const aTableNameOrQuery: string; const aTempTableName: string = ''; const aTempTablePrimaryKeyFieldNames: string = ''; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE): Int64;
begin
  Result := qCopyToTemp([aTableNameOrQuery], [aTempTableName], [aTempTablePrimaryKeyFieldNames], [aWhereCondition], aProgressCaption, aAllRecordsNotJustCurrentBudgetOrPeriod, FALSE, FALSE);
end;

function qCopyToTempTry(aTableNamesOrQueries: array of string; const aTempTableNames: array of string; const aTempTablesPrimaryKeyFieldNames: array of string; const aWhereConditions: array of string; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE; const aShowErrorMessage: Boolean = FALSE): Int64;
begin
  Result := qCopyToTemp(aTableNamesOrQueries, aTempTableNames, aTempTablesPrimaryKeyFieldNames, aWhereConditions, aProgressCaption, aAllRecordsNotJustCurrentBudgetOrPeriod, TRUE, aShowErrorMessage);
end;

function qCopyToTempTry(aTableNames: array of string; const aTempTablesPrimaryKeyFieldNames: array of string; const aWhereConditions: array of string; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE; const aShowErrorMessage: Boolean = FALSE): Int64;
begin
  Result := qCopyToTemp(aTableNames, [], aTempTablesPrimaryKeyFieldNames, aWhereConditions, aProgressCaption, aAllRecordsNotJustCurrentBudgetOrPeriod, TRUE, aShowErrorMessage);
end;

function qCopyToTempTry(const aTableNameOrQuery: string; const aTempTableName: string = ''; const aTempTablePrimaryKeyFieldNames: string = ''; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE; const aShowErrorMessage: Boolean = FALSE): Int64;
begin
  Result := qCopyToTemp([aTableNameOrQuery], [aTempTableName], aTempTablePrimaryKeyFieldNames, aWhereCondition, aProgressCaption, aAllRecordsNotJustCurrentBudgetOrPeriod, TRUE, aShowErrorMessage);
end;

function qCreateTemp(aTableNamesOrQueries: array of string; const aTempTableNames: array of string; const aTempTablesPrimaryKeyFieldNames: array of string; const aProgressCaption: string = ''; const aTry: Boolean = FALSE; const aShowErrorMessageOnTry: Boolean = FALSE): Int64;
var
  I: Integer;
  aWhereConditions: array of string;
begin
  SetLength(aWhereConditions, Length(aTableNamesOrQueries));
  for I := 0 to Length(aWhereConditions) - 1 do aWhereConditions[I] := '1 = 2';

  Result := qCopyToTemp(aTableNamesOrQueries, aTempTableNames, aTempTablesPrimaryKeyFieldNames, aWhereConditions, aProgressCaption, TRUE, aTry, aShowErrorMessageOnTry);
end;

function qCreateTemp(aTableNames: array of string; const aTempTablesPrimaryKeyFieldNames: array of string; const aProgressCaption: string = ''; const aTry: Boolean = FALSE; const aShowErrorMessageOnTry: Boolean = FALSE): Int64;
var
  I: Integer;
  aWhereConditions: array of string;
begin
  SetLength(aWhereConditions, Length(aTableNames));
  for I := 0 to Length(aWhereConditions) - 1 do aWhereConditions[I] := '1 = 2';

  Result := qCopyToTemp(aTableNames, [], aTempTablesPrimaryKeyFieldNames, aWhereConditions, aProgressCaption, TRUE, aTry, aShowErrorMessageOnTry);
end;

function qCreateTemp(const aTableNameOrQuery: string; const aTempTableName: string = ''; const aTempTablePrimaryKeyFieldNames: string = ''; const aProgressCaption: string = ''): Int64;
begin
  Result := qCopyToTemp([aTableNameOrQuery], [aTempTableName], [aTempTablePrimaryKeyFieldNames], ['1 = 2'], aProgressCaption, TRUE, FALSE, FALSE);
end;

function qCreateTempTry(aTableNamesOrQueries: array of string; const aTempTableNames: array of string; const aTempTablesPrimaryKeyFieldNames: array of string; const aProgressCaption: string = ''; const aShowErrorMessage: Boolean = FALSE): Int64;
var
  I: Integer;
  aWhereConditions: array of string;
begin
  SetLength(aWhereConditions, Length(aTableNamesOrQueries));
  for I := 0 to Length(aWhereConditions) - 1 do aWhereConditions[I] := '1 = 2';

  Result := qCopyToTemp(aTableNamesOrQueries, aTempTableNames, aTempTablesPrimaryKeyFieldNames, aWhereConditions, aProgressCaption, TRUE, TRUE, aShowErrorMessage);
end;

function qCreateTempTry(aTableNames: array of string; const aTempTablesPrimaryKeyFieldNames: array of string; const aProgressCaption: string = ''; const aShowErrorMessage: Boolean = FALSE): Int64;
var
  I: Integer;
  aWhereConditions: array of string;
begin
  SetLength(aWhereConditions, Length(aTableNames));
  for I := 0 to Length(aWhereConditions) - 1 do aWhereConditions[I] := '1 = 2';

  Result := qCopyToTemp(aTableNames, [], aTempTablesPrimaryKeyFieldNames, aWhereConditions, aProgressCaption, TRUE, TRUE, aShowErrorMessage);
end;

function qCreateTempTry(const aTableNameOrQuery: string; const aTempTableName: string = ''; const aTempTablePrimaryKeyFieldNames: string = ''; const aProgressCaption: string = ''; const aShowErrorMessage: Boolean = FALSE): Int64;
begin
  Result := qCopyToTemp([aTableNameOrQuery], [aTempTableName], [aTempTablePrimaryKeyFieldNames], ['1 = 2'], aProgressCaption, TRUE, TRUE, aShowErrorMessage);
end;

function qJoin(const aTableNameOrQuery: string; const aInnerJoin: Boolean; const aDirectJoinStatement: string = ''): TTableNameOrQueryAndJoinInformation;
begin
  Result.TableNameOrQuery    := aTableNameOrQuery;
  Result.InnerJoin           := aInnerJoin;
  Result.DirectJoinStatement := aDirectJoinStatement;
end;

function qJoinLeft(const aTableNameOrQuery: string; const aDirectJoinStatement: string = ''): TTableNameOrQueryAndJoinInformation;
begin
  Result := qJoin(aTableNameOrQuery, FALSE, aDirectJoinStatement);
end;

function qJoinInner(const aTableNameOrQuery: string; const aDirectJoinStatement: string = ''): TTableNameOrQueryAndJoinInformation;
begin
  Result := qJoin(aTableNameOrQuery, TRUE, aDirectJoinStatement);
end;

function fqSQLCommand(const aSQLCommandType: TSQLCommandType; const aTargetTableName: string; const aMainSourceTableNameOrQuery: string; const aOtherSourceTableNameOrQueryAndJoinInformations: array of TTableNameOrQueryAndJoinInformation; const aFieldEqualities: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE; const aNonExistings: Boolean = FALSE): Int64;
var
  I, J, P, K, L, M, N: Integer;
  St1, St2, St3, St4, St5, aSQLText, aWhereText, aGroupByText, aNotExistingsText1, aNotExistingsText2: string;
  aTargetTableInformation: TTableOrQueryInformation;
  aSourceTableOrQueryInformations: array of TTableOrQueryInformation;
  aHasGroupBy, aHasGroupByFunction: Boolean;
  aSQLCommandValues: array of string;
  aFromFieldEqualities: array of Boolean;
  aHasGroupByFunctions: array of Boolean;
begin

  {
  qAppend('dbo.NET_MIKTAR', 'dbo.URUN_SATIS_DETAY', [JoinInner('SELECT * FROM dbo.URUN')], ['TOPLAM_MIKTAR = SUM(OCAK)', 'SUBAT = Null', 'MART = SUM(T2.SAFHA) + 1.0'], '', '', I = 0, TRUE);

  INSERT INTO [dbo].[NET_MIKTAR] ([BUTCE_KODU], [URUN_KODU], [SEZON], [SATIS_BOLUMU], [BOLGE], [KANAL], [YIL], [OCAK], [SUBAT], [MART], [NISAN], [MAYIS], [HAZIRAN], [TEMMUZ], [AGUSTOS], [EYLUL], [EKIM], [KASIM], [ARALIK], [TOPLAM_MIKTAR])
  SELECT
    T1.[BUTCE_KODU], T1.[URUN_KODU], T1.[SEZON], T1.[SATIS_BOLUMU], T1.[BOLGE], T1.[KANAL], T1.[YIL], T1.[OCAK], NULL AS [SUBAT], SUM(T2.SAFHA) + 1.0 AS [MART], T1.[NISAN], T1.[MAYIS], T1.[HAZIRAN], T1.[TEMMUZ], T1.[AGUSTOS], T1.[EYLUL], T1.[EKIM], T1.[KASIM], T1.[ARALIK], SUM(OCAK) AS [TOPLAM_MIKTAR]
  FROM [dbo].[URUN_SATIS_DETAY] T1
    INNER JOIN (SELECT * FROM dbo.URUN) T2 ON 1 = 1
  WHERE 1=2 AND NOT EXISTS (SELECT 1 AS KOD FROM [dbo].[NET_MIKTAR] S1 WHERE S1.[BUTCE_KODU] = T1.[BUTCE_KODU])
  GROUP BY T1.[BUTCE_KODU], T1.[URUN_KODU], T1.[SEZON], T1.[SATIS_BOLUMU], T1.[BOLGE], T1.[KANAL], T1.[YIL], T1.[OCAK], T1.[NISAN], T1.[MAYIS], T1.[HAZIRAN], T1.[TEMMUZ], T1.[AGUSTOS], T1.[EYLUL], T1.[EKIM], T1.[KASIM], T1.[ARALIK]
  }

  if aProgressCaption <> '' then ProgressStartAsWaitMessage(aProgressCaption);
  try
    aTargetTableInformation := GetTableOrQueryInformationExpanding(Trim(aTargetTableName));

    SetLength(aSQLCommandValues,    Length(aTargetTableInformation.FieldInformations));
    SetLength(aFromFieldEqualities, Length(aTargetTableInformation.FieldInformations));
    SetLength(aHasGroupByFunctions, Length(aTargetTableInformation.FieldInformations));

    for I := 0 to Length(aFromFieldEqualities) - 1 do aFromFieldEqualities[I] := TRUE;
    for I := 0 to Length(aHasGroupByFunctions) - 1 do aHasGroupByFunctions[I] := FALSE;

    SetLength(aSourceTableOrQueryInformations, Length(aOtherSourceTableNameOrQueryAndJoinInformations) + 1);

    if aSQLCommandType = sctInsert then
      aSourceTableOrQueryInformations[0] := GetTableOrQueryInformationExpanding(Trim(aMainSourceTableNameOrQuery))
    else
      aSourceTableOrQueryInformations[0] := aTargetTableInformation;

    for I := 1 to Length(aSourceTableOrQueryInformations) - 1 do aSourceTableOrQueryInformations[I] := GetTableOrQueryInformationExpanding(Trim(aOtherSourceTableNameOrQueryAndJoinInformations[I - 1].TableNameOrQuery));

    aHasGroupBy := FALSE;

    if aSQLCommandType in [sctInsert, sctUpdate] then
      for I := 0 to Length(aFieldEqualities) - 1 do
      begin
        P := System.Pos('=', aFieldEqualities[I]);
        if P < 1 then Continue;

        St1 := Trim(System.Copy(aFieldEqualities[I], 1, P - 1));
        St2 := Trim(DeleteFromLeft(aFieldEqualities[I], P));

        if (St1 = '') or (St2 = '') then Continue;

        St3 := AnsiUpperCase(St1);
        St4 := AnsiUpperCase(St2);

        aHasGroupByFunction := FALSE;

        if aSQLCommandType = sctInsert then
          for J := 0 to 5 - 1 do
            if not aHasGroupByFunction then
            begin
              case J of
                1: St5 := 'AVG';
                2: St5 := 'MAX';
                3: St5 := 'MIN';
                4: St5 := 'COUNT';
              else
                St5 := 'SUM';
              end;

              aHasGroupByFunction := System.Pos(St5 + '(', St4) > 0;
              if not aHasGroupByFunction then aHasGroupByFunction := System.Pos(St5 + ' (',  St4) > 0;
              if not aHasGroupByFunction then aHasGroupByFunction := System.Pos(St5 + '  (', St4) > 0;
            end;

        if not aHasGroupBy then aHasGroupBy := aHasGroupByFunction;

        if not StringIN(St3, ['[AY]', '[OCAK]', '[MONTH]']) then
        begin
          St5 := GetObjectNameWithOutLeftRightCharacters(St3);

          for J := 0 to Length(aTargetTableInformation.FieldInformations) - 1 do
            if aSQLCommandValues[J] = '' then
              if not aTargetTableInformation.FieldInformations[J].ReadOnly then
                if aTargetTableInformation.FieldInformations[J].UpperFieldName = St5 then
                begin
                  aSQLCommandValues[J]    := St2;
                  aHasGroupByFunctions[J] := aHasGroupByFunction;

                  Break;
                end;
        end
        else
          for K := 0 to 12 - 1 do
            for J := 0 to Length(aTargetTableInformation.FieldInformations) - 1 do
              if aSQLCommandValues[J] = '' then
                if not aTargetTableInformation.FieldInformations[J].ReadOnly then
                  if aTargetTableInformation.FieldInformations[J].FieldName = MyMonthNames[K] then
                  begin
                    St5 := MyAnsiReplaceStr(St2, '[AY]',    '"' + MyMonthNames[K] + '"');
                    St5 := MyAnsiReplaceStr(St5, '[OCAK]',  '"' + MyMonthNames[K] + '"');
                    St5 := MyAnsiReplaceStr(St5, '[MONTH]', '"' + MyMonthNames[K] + '"');
                    St5 := MyAnsiReplaceStr(St5, '[1]',     IntToStr(K + 1));

                    aSQLCommandValues[J]    := St5;
                    aHasGroupByFunctions[J] := aHasGroupByFunction;

                    Break;
                  end
                  else
                    if aTargetTableInformation.FieldInformations[J].FieldName = MyMonthNamesTRENG[K] then
                    begin
                      St5 := MyAnsiReplaceStr(St2, '[AY]',    '"' + MyMonthNamesTRENG[K] + '"');
                      St5 := MyAnsiReplaceStr(St5, '[OCAK]',  '"' + MyMonthNamesTRENG[K] + '"');
                      St5 := MyAnsiReplaceStr(St5, '[MONTH]', '"' + MyMonthNamesTRENG[K] + '"');
                      St5 := MyAnsiReplaceStr(St5, '[1]',     IntToStr(K + 1));

                      aSQLCommandValues[J]    := St5;
                      aHasGroupByFunctions[J] := aHasGroupByFunction;

                      Break;
                    end;
      end;

    if aSQLCommandType = sctInsert then
      for J := 0 to Length(aTargetTableInformation.FieldInformations) - 1 do
        if aSQLCommandValues[J] = '' then
          if not aTargetTableInformation.FieldInformations[J].ReadOnly then
            for I := 0 to Length(aSourceTableOrQueryInformations) - 1 do
              if not aSourceTableOrQueryInformations[I].Query then
              begin
                for K := 0 to Length(aSourceTableOrQueryInformations[I].FieldInformations) - 1 do
                  if aTargetTableInformation.FieldInformations[J].UpperFieldName = aSourceTableOrQueryInformations[I].FieldInformations[K].UpperFieldName then
                    if aTargetTableInformation.TempTable or aSourceTableOrQueryInformations[I].TempTable or ((aTargetTableInformation.FieldInformations[J].Size = aSourceTableOrQueryInformations[I].FieldInformations[K].Size) and (aTargetTableInformation.FieldInformations[J].FieldType = aSourceTableOrQueryInformations[I].FieldInformations[K].FieldType)) then
                    begin
                      aSQLCommandValues[J]    := 'T' + IntToStr(I + 1) + '.' + aSourceTableOrQueryInformations[I].FieldInformations[K].FieldNameWithLeftRightChars;
                      aFromFieldEqualities[J] := FALSE;

                      Break;
                    end;

                if aSQLCommandValues[J] <> '' then Break;
              end;

    St1 := '';
    St2 := '';

    case aSQLCommandType of
      sctUpdate:
        begin
          for I := 0 to Length(aTargetTableInformation.FieldInformations) - 1 do
            if aSQLCommandValues[I] <> '' then
            begin
              if St1 <> '' then St1 := St1 + ',' + LB;
              St1 := St1 + '  ' + aTargetTableInformation.FieldInformations[I].FieldNameWithLeftRightChars + ' = ';

              if AnsiUpperCase(aSQLCommandValues[I]) = 'NULL' then
                St1 := St1 + 'NULL'
              else
                St1 := St1 + aSQLCommandValues[I];
            end;

            aSQLText := 'UPDATE ' + aTargetTableInformation.SchemaAndTableName + ' SET' + LB +
                        St1 + LB +
                        'FROM ' + aSourceTableOrQueryInformations[0].SchemaAndTableName + ' T1';
        end;
      sctDelete: aSQLText := 'DELETE FROM ' + aTargetTableInformation.SchemaAndTableName + LB + 'FROM ' + aSourceTableOrQueryInformations[0].SchemaAndTableName + ' T1';
    else //sctInsert
      for I := 0 to Length(aTargetTableInformation.FieldInformations) - 1 do
        if aSQLCommandValues[I] <> '' then
        begin
          if St1 <> '' then St1 := St1 + ', ';
          St1 := St1 + aTargetTableInformation.FieldInformations[I].FieldNameWithLeftRightChars;

          if St2 <> '' then St2 := St2 + ', ';

          if AnsiUpperCase(aSQLCommandValues[I]) = 'NULL' then
            St2 := St2 + 'NULL'
          else
            St2 := St2 + aSQLCommandValues[I];

          if aFromFieldEqualities[I] then St2 := St2 + ' AS ' + aTargetTableInformation.FieldInformations[I].FieldNameWithLeftRightChars;
        end;

        aSQLText := 'INSERT INTO ' + aTargetTableInformation.SchemaAndTableName + ' (' + St1 + ')' + LB +
                    '  SELECT' + LB +
                    '    ' + St2 + LB +
                    '  FROM ' + aSourceTableOrQueryInformations[0].SchemaAndTableName + ' T1';
    end;

    aNotExistingsText1 := '';
    aNotExistingsText2 := '';

    if aNonExistings and (aSQLCommandType = sctInsert) then
    begin
      St3 := '';
      for K := 0 to aTargetTableInformation.UniqueKeyCount - 1 do
      begin
        St3 := '';
        for I := 0 to Length(aTargetTableInformation.FieldInformations) - 1 do
          if aTargetTableInformation.FieldInformations[I].UniqueKeyIndices[K] > -1 then
            if aSQLCommandValues[I] = '' then
            begin
              St3 := '';
              Break;
            end
            else
            begin
              if St3 <> '' then St3 := St3 + ' AND ';
              St3 := St3 + 'S1.' + aTargetTableInformation.FieldInformations[I].FieldNameWithLeftRightChars;

              if AnsiUpperCase(aSQLCommandValues[I]) = 'NULL' then
                St3 := St3 + ' IS NULL'
              else
                St3 := St3 + ' = ' + aSQLCommandValues[I];
            end;

        if St3 <> '' then Break;
      end;

      aNotExistingsText1 := St3;
    end;

    for I := 1 to Length(aSourceTableOrQueryInformations) - 1 do
    begin
      if aOtherSourceTableNameOrQueryAndJoinInformations[I - 1].DirectJoinStatement <> '' then
        St1 := aOtherSourceTableNameOrQueryAndJoinInformations[I - 1].DirectJoinStatement
      else
      begin
        St1 := '';

        if not aAllRecordsNotJustCurrentBudgetOrPeriod then
          if aSourceTableOrQueryInformations[I].Butce then
            St1 := 'T' + IntToStr(I + 1) + '.' + GetObjectNameWithLeftRightCharacters('Bütçe ID') + ' = ' + AktifButce.ButceID
           else
             if aSourceTableOrQueryInformations[I].Donem then St1 := 'T' + IntToStr(I + 1) + '.' + GetObjectNameWithLeftRightCharacters('Dönem ID') + ' = ' + AktifButce.DonemID;

        for J := 0 to aSourceTableOrQueryInformations[I].UniqueKeyCount - 1 do
        begin
          M := 0;
          N := 0;

          St2 := '';

          for L := 0 to Length(aSourceTableOrQueryInformations[I].FieldInformations) - 1 do
            if aSourceTableOrQueryInformations[I].FieldInformations[L].UniqueKeyIndices[J] > -1 then
            begin
              Inc(M);

              for K := 0 to Length(aSourceTableOrQueryInformations[0].FieldInformations) - 1 do
                if aSourceTableOrQueryInformations[0].FieldInformations[K].UpperFieldName = aSourceTableOrQueryInformations[I].FieldInformations[L].UpperFieldName then
                  if aSourceTableOrQueryInformations[0].TempTable or aSourceTableOrQueryInformations[I].TempTable or ((aSourceTableOrQueryInformations[0].FieldInformations[K].Size = aSourceTableOrQueryInformations[I].FieldInformations[L].Size) and (aSourceTableOrQueryInformations[0].FieldInformations[K].FieldType = aSourceTableOrQueryInformations[I].FieldInformations[L].FieldType)) then
                  begin
                    Inc(N);

                    if not aAllRecordsNotJustCurrentBudgetOrPeriod then
                      if aSourceTableOrQueryInformations[I].Butce then
                        if aSourceTableOrQueryInformations[I].FieldInformations[L].FieldName = 'Bütçe ID' then
                          Break
                        else
                      else
                        if aSourceTableOrQueryInformations[I].Donem then
                          if aSourceTableOrQueryInformations[I].FieldInformations[L].FieldName = 'Dönem ID' then Break;

                    if St2 <> '' then St2 := St2 + ' AND ';

                    if not aSourceTableOrQueryInformations[0].FieldInformations[K].Required and not aSourceTableOrQueryInformations[I].FieldInformations[L].Required then
                      St2 := St2 + '((T' + IntToStr(I + 1) + '.' + aSourceTableOrQueryInformations[I].FieldInformations[L].FieldNameWithLeftRightChars + ' IS NULL AND T1.' + aSourceTableOrQueryInformations[0].FieldInformations[K].FieldNameWithLeftRightChars + ' IS NULL) OR (T' + IntToStr(I + 1) + '.' + aSourceTableOrQueryInformations[I].FieldInformations[L].FieldNameWithLeftRightChars + ' = T1.' + aSourceTableOrQueryInformations[0].FieldInformations[K].FieldNameWithLeftRightChars + '))'
                    else
                      St2 := St2 + 'T' + IntToStr(I + 1) + '.' + aSourceTableOrQueryInformations[I].FieldInformations[L].FieldNameWithLeftRightChars + ' = T1.' + aSourceTableOrQueryInformations[0].FieldInformations[K].FieldNameWithLeftRightChars;

                    Break;
                  end;
            end;

          if M = N then
          begin
            if St1 <> '' then St1 := St1 + ' AND ';
            St1 := St1 + St2;

            Break;
          end;
        end;
      end;

      if St1 = '' then St1 := '1 = 1';

      aSQLText := aSQLText + LB +
                  IfThen(aSQLCommandType = sctInsert, '  ', '') + '  ' + IfThen(aOtherSourceTableNameOrQueryAndJoinInformations[I - 1].InnerJoin, 'INNER', 'LEFT') + ' JOIN ' +
                  IfThen((aSQLCommandType in [sctUpdate, sctDelete]) and (aSourceTableOrQueryInformations[0].SchemaAndTableName = aSourceTableOrQueryInformations[I].SchemaAndTableName), '(SELECT * FROM ' + aSourceTableOrQueryInformations[I].SchemaAndTableName + ')', aSourceTableOrQueryInformations[I].SchemaAndTableName) + ' T' + IntToStr(I + 1) + ' ON ' + St1;
    end;

    aWhereText := '';
    St1        := Trim(aWhereCondition);

    if not aAllRecordsNotJustCurrentBudgetOrPeriod then
      if aSourceTableOrQueryInformations[0].Butce then
        if St1 = '' then
          aWhereText := 'T1.' + GetObjectNameWithLeftRightCharacters('Bütçe ID') + ' = ' + AktifButce.ButceID
        else
          aWhereText := '(T1.' + GetObjectNameWithLeftRightCharacters('Bütçe ID') + ' = ' + AktifButce.ButceID + ')'
      else
        if aSourceTableOrQueryInformations[0].Donem then
          if St1 = '' then
            aWhereText := 'T1.' + GetObjectNameWithLeftRightCharacters('Dönem ID') + ' = ' + AktifButce.DonemID
          else
            aWhereText := '(T1.' + GetObjectNameWithLeftRightCharacters('Dönem ID') + ' = ' + AktifButce.DonemID + ')';

    if St1 <> '' then
      if aWhereText = '' then
        aWhereText := St1
      else
        aWhereText := aWhereText + ' AND (' + St1 + ')';

    aGroupByText := '';

    if aSQLCommandType = sctInsert then
    begin
      if aHasGroupBy or (aNonExistings and (aNotExistingsText1 = '')) then
        for I := 0 to Length(aTargetTableInformation.FieldInformations) - 1 do
          if (aSQLCommandValues[I] <> '') and not aHasGroupByFunctions[I] then
          begin
            if aFromFieldEqualities[I] then
            begin
              St2 := AnsiUpperCase(aSQLCommandValues[I]);

              if St2[1] <> 'T' then Continue;

              P := System.Pos('.', St2);
              if P < 3 then Continue;

              St3 := Trim(System.Copy(St2, 2, P - 2));

              K := StrToIntDef(St3, 0);
              if (K < 1) or (K > Length(aSourceTableOrQueryInformations)) then Continue;
              if IntToStr(K) <> St3 then Continue;

              St3 := GetObjectNameWithOutLeftRightCharacters(DeleteFromLeft(St2, P));
              if St3 = '' then Continue;

              St4 := '';
              for J := 0 to Length(aSourceTableOrQueryInformations[K - 1].FieldInformations) - 1 do
                if  aSourceTableOrQueryInformations[K - 1].FieldInformations[J].UpperFieldName = St3 then
                begin
                  St4 := St3;
                  Break;
                end;

              if St4 = '' then Continue;
            end;

            if aGroupByText <> '' then aGroupByText := aGroupByText + ', ';
            aGroupByText := aGroupByText + aSQLCommandValues[I];

            if aNonExistings then
            begin
              if aNotExistingsText2 <> '' then aNotExistingsText2 := aNotExistingsText2 + ' AND ';
              aNotExistingsText2 := aNotExistingsText2 + 'S1.' + aTargetTableInformation.FieldInformations[I].FieldNameWithLeftRightChars;

              if AnsiUpperCase(aSQLCommandValues[I]) = 'NULL' then
                aNotExistingsText2 := aNotExistingsText2 + ' IS NULL'
              else
                aNotExistingsText2 := aNotExistingsText2 + ' = ' + aSQLCommandValues[I];
            end;
          end;

      if aNonExistings then
      begin
        if aNotExistingsText1 = '' then aNotExistingsText1 := aNotExistingsText2;

        if aNotExistingsText1 <> '' then
        begin
          if aWhereText <> '' then aWhereText := aWhereText + ' AND ';

          aWhereText := aWhereText + 'NOT EXISTS (SELECT 1 AS KOD FROM ' + aTargetTableInformation.SchemaAndTableName + ' S1 WHERE ' + aNotExistingsText1 + ')';
        end;
      end;
    end;

    if aWhereText   <> '' then aWhereText   := LB + IfThen(aSQLCommandType = sctInsert, '  ', '') + 'WHERE ' + aWhereText;
    if aGroupByText <> '' then aGroupByText := LB + '  GROUP BY ' + aGroupByText;

    aSQLText := aSQLText + aWhereText + aGroupByText;

    case aSQLCommandType of
      sctUpdate : Result := ExecSQL(aSQLText, '', MainConnection, 'Update');
      sctDelete : Result := ExecSQL(aSQLText, '', MainConnection, 'Delete');
    else //sctInsert
      Result := ExecSQL(aSQLText, '', MainConnection, 'Append');
    end;
  finally
    if aProgressCaption <> '' then ProgressFinish;
  end;
end;

function fqSQLCommand(const aSQLCommandType: TSQLCommandType; const aTargetTableName: string; const aMainSourceTableNameOrQuery: string; const aOtherSourceTableNameOrQueries: array of string; const aFieldEqualities: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE; const aNonExistings: Boolean = FALSE): Int64;
var
  I: Integer;
  aOtherSourceTableNameOrQueryAndJoinInformations: array of TTableNameOrQueryAndJoinInformation;
begin
  SetLength(aOtherSourceTableNameOrQueryAndJoinInformations, Length(aOtherSourceTableNameOrQueries));
  for I := 0 to Length(aOtherSourceTableNameOrQueryAndJoinInformations) - 1 do
  begin
    aOtherSourceTableNameOrQueryAndJoinInformations[I].TableNameOrQuery    := aOtherSourceTableNameOrQueries[I];
    aOtherSourceTableNameOrQueryAndJoinInformations[I].InnerJoin           := FALSE;
    aOtherSourceTableNameOrQueryAndJoinInformations[I].DirectJoinStatement := '';
  end;

  Result := fqSQLCommand(aSQLCommandType, aTargetTableName, aMainSourceTableNameOrQuery, aOtherSourceTableNameOrQueryAndJoinInformations, aFieldEqualities, aWhereCondition, aProgressCaption, aAllRecordsNotJustCurrentBudgetOrPeriod, aNonExistings);
end;

function fqSQLCommand(const aSQLCommandType: TSQLCommandType; const aTargetTableName: string; const aMainSourceTableNameOrQuery: string; const aFieldEqualities: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE; const aNonExistings: Boolean = FALSE): Int64;
var
  aOtherSourceTableNameOrQueryAndJoinInformations: array of TTableNameOrQueryAndJoinInformation;
begin
  SetLength(aOtherSourceTableNameOrQueryAndJoinInformations, 0);
  Result := fqSQLCommand(aSQLCommandType, aTargetTableName, aMainSourceTableNameOrQuery, aOtherSourceTableNameOrQueryAndJoinInformations, aFieldEqualities, aWhereCondition, aProgressCaption, aAllRecordsNotJustCurrentBudgetOrPeriod, aNonExistings);
end;

function fqSQLCommand(const aSQLCommandType: TSQLCommandType; const aTargetTableName: string; const aMainSourceTableNameOrQuery: string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE; const aNonExistings: Boolean = FALSE): Int64;
var
  aOtherSourceTableNameOrQueryAndJoinInformations: array of TTableNameOrQueryAndJoinInformation;
begin
  SetLength(aOtherSourceTableNameOrQueryAndJoinInformations, 0);
  Result := fqSQLCommand(aSQLCommandType, aTargetTableName, aMainSourceTableNameOrQuery, aOtherSourceTableNameOrQueryAndJoinInformations, [], aWhereCondition, aProgressCaption, aAllRecordsNotJustCurrentBudgetOrPeriod, aNonExistings);
end;

function fqSQLCommandTry(const aSQLCommandType: TSQLCommandType; const aTargetTableName: string; const aMainSourceTableNameOrQuery: string; const aOtherSourceTableNameOrQueryAndJoinInformations: array of TTableNameOrQueryAndJoinInformation; const aFieldEqualities: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE; const aNonExistings: Boolean = FALSE; const aShowErrorMessage: Boolean = FALSE): Int64;
begin
  try
    Result := fqSQLCommand(aSQLCommandType, aTargetTableName, aMainSourceTableNameOrQuery, aOtherSourceTableNameOrQueryAndJoinInformations, aFieldEqualities, aWhereCondition, aProgressCaption, aAllRecordsNotJustCurrentBudgetOrPeriod, aNonExistings);
  except
    on Ex: Exception do
    begin
      Result := -1;
      if aShowErrorMessage then Me(ExceptionMessage(Ex));
    end;
  end;
end;

function fqSQLCommandTry(const aSQLCommandType: TSQLCommandType; const aTargetTableName: string; const aMainSourceTableNameOrQuery: string; const aOtherSourceTableNameOrQueries: array of string; const aFieldEqualities: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE; const aNonExistings: Boolean = FALSE; const aShowErrorMessage: Boolean = FALSE): Int64;
var
  I: Integer;
  aOtherSourceTableNameOrQueryAndJoinInformations: array of TTableNameOrQueryAndJoinInformation;
begin
  SetLength(aOtherSourceTableNameOrQueryAndJoinInformations, Length(aOtherSourceTableNameOrQueries));
  for I := 0 to Length(aOtherSourceTableNameOrQueryAndJoinInformations) - 1 do
  begin
    aOtherSourceTableNameOrQueryAndJoinInformations[I].TableNameOrQuery    := aOtherSourceTableNameOrQueries[I];
    aOtherSourceTableNameOrQueryAndJoinInformations[I].InnerJoin           := FALSE;
    aOtherSourceTableNameOrQueryAndJoinInformations[I].DirectJoinStatement := '';
  end;

  Result := fqSQLCommandTry(aSQLCommandType, aTargetTableName, aMainSourceTableNameOrQuery, aOtherSourceTableNameOrQueryAndJoinInformations, aFieldEqualities, aWhereCondition, aProgressCaption, aAllRecordsNotJustCurrentBudgetOrPeriod, aNonExistings, aShowErrorMessage);
end;

function fqSQLCommandTry(const aSQLCommandType: TSQLCommandType; const aTargetTableName: string; const aMainSourceTableNameOrQuery: string; const aFieldEqualities: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE; const aNonExistings: Boolean = FALSE; const aShowErrorMessage: Boolean = FALSE): Int64;
var
  aOtherSourceTableNameOrQueryAndJoinInformations: array of TTableNameOrQueryAndJoinInformation;
begin
  SetLength(aOtherSourceTableNameOrQueryAndJoinInformations,0 );
  Result := fqSQLCommandTry(aSQLCommandType, aTargetTableName, aMainSourceTableNameOrQuery, aOtherSourceTableNameOrQueryAndJoinInformations, aFieldEqualities, aWhereCondition, aProgressCaption, aAllRecordsNotJustCurrentBudgetOrPeriod, aNonExistings, aShowErrorMessage);
end;

function qAppend(const aTargetTableName: string; const aMainSourceTableNameOrQuery: string; const aOtherSourceTableNameOrQueryAndJoinInformations: array of TTableNameOrQueryAndJoinInformation; const aFieldEqualities: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE): Int64;
begin
  Result := fqSQLCommand(sctInsert, aTargetTableName, aMainSourceTableNameOrQuery, aOtherSourceTableNameOrQueryAndJoinInformations, aFieldEqualities, aWhereCondition, aProgressCaption, aAllRecordsNotJustCurrentBudgetOrPeriod, FALSE);
end;

function qAppend(const aTargetTableName: string; const aMainSourceTableNameOrQuery: string; const aOtherSourceTableNameOrQueries: array of string; const aFieldEqualities: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE): Int64;
begin
  Result := fqSQLCommand(sctInsert, aTargetTableName, aMainSourceTableNameOrQuery, aOtherSourceTableNameOrQueries, aFieldEqualities, aWhereCondition, aProgressCaption, aAllRecordsNotJustCurrentBudgetOrPeriod, FALSE);
end;

function qAppend(const aTargetTableName: string; const aMainSourceTableNameOrQuery: string; const aFieldEqualities: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE): Int64;
begin
  Result := fqSQLCommand(sctInsert, aTargetTableName, aMainSourceTableNameOrQuery, aFieldEqualities, aWhereCondition, aProgressCaption, aAllRecordsNotJustCurrentBudgetOrPeriod, FALSE);
end;

function qAppend(const aTargetTableName: string; const aMainSourceTableNameOrQuery: string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE): Int64;
begin
  Result := fqSQLCommand(sctInsert, aTargetTableName, aMainSourceTableNameOrQuery, [], aWhereCondition, aProgressCaption, aAllRecordsNotJustCurrentBudgetOrPeriod, FALSE);
end;

function qAppendTry(const aTargetTableName: string; const aMainSourceTableNameOrQuery: string; const aOtherSourceTableNameOrQueryAndJoinInformations: array of TTableNameOrQueryAndJoinInformation; const aFieldEqualities: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE; const aShowErrorMessage: Boolean = FALSE): Int64;
begin
  Result := fqSQLCommandTry(sctInsert, aTargetTableName, aMainSourceTableNameOrQuery, aOtherSourceTableNameOrQueryAndJoinInformations, aFieldEqualities, aWhereCondition, aProgressCaption, aAllRecordsNotJustCurrentBudgetOrPeriod, FALSE, aShowErrorMessage);
end;

function qAppendTry(const aTargetTableName: string; const aMainSourceTableNameOrQuery: string; const aOtherSourceTableNameOrQueries: array of string; const aFieldEqualities: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE; const aShowErrorMessage: Boolean = FALSE): Int64;
begin
  Result := fqSQLCommandTry(sctInsert, aTargetTableName, aMainSourceTableNameOrQuery, aOtherSourceTableNameOrQueries, aFieldEqualities, aWhereCondition, aProgressCaption, aAllRecordsNotJustCurrentBudgetOrPeriod, FALSE, aShowErrorMessage);
end;

function qAppendTry(const aTargetTableName: string; const aMainSourceTableNameOrQuery: string; const aFieldEqualities: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE; const aShowErrorMessage: Boolean = FALSE): Int64;
begin
  Result := fqSQLCommandTry(sctInsert, aTargetTableName, aMainSourceTableNameOrQuery, aFieldEqualities, aWhereCondition, aProgressCaption, aAllRecordsNotJustCurrentBudgetOrPeriod, FALSE, aShowErrorMessage);
end;

function qAppendTry(const aTargetTableName: string; const aMainSourceTableNameOrQuery: string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE; const aShowErrorMessage: Boolean = FALSE): Int64;
begin
  Result := fqSQLCommandTry(sctInsert, aTargetTableName, aMainSourceTableNameOrQuery, [], aWhereCondition, aProgressCaption, aAllRecordsNotJustCurrentBudgetOrPeriod, FALSE, aShowErrorMessage);
end;

function qAppendNonExistings(const aTargetTableName: string; const aMainSourceTableNameOrQuery: string; const aOtherSourceTableNameOrQueryAndJoinInformations: array of TTableNameOrQueryAndJoinInformation; const aFieldEqualities: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE): Int64;
begin
  Result := fqSQLCommand(sctInsert, aTargetTableName, aMainSourceTableNameOrQuery, aOtherSourceTableNameOrQueryAndJoinInformations, aFieldEqualities, aWhereCondition, aProgressCaption, aAllRecordsNotJustCurrentBudgetOrPeriod, TRUE);
end;

function qAppendNonExistings(const aTargetTableName: string; const aMainSourceTableNameOrQuery: string; const aOtherSourceTableNameOrQueries: array of string; const aFieldEqualities: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE): Int64;
begin
  Result := fqSQLCommand(sctInsert, aTargetTableName, aMainSourceTableNameOrQuery, aOtherSourceTableNameOrQueries, aFieldEqualities, aWhereCondition, aProgressCaption, aAllRecordsNotJustCurrentBudgetOrPeriod, TRUE);
end;

function qAppendNonExistings(const aTargetTableName: string; const aMainSourceTableNameOrQuery: string; const aFieldEqualities: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE): Int64;
begin
  Result := fqSQLCommand(sctInsert, aTargetTableName, aMainSourceTableNameOrQuery, aFieldEqualities, aWhereCondition, aProgressCaption, aAllRecordsNotJustCurrentBudgetOrPeriod, TRUE);
end;

function qAppendNonExistings(const aTargetTableName: string; const aMainSourceTableNameOrQuery: string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE): Int64;
begin
  Result := fqSQLCommand(sctInsert, aTargetTableName, aMainSourceTableNameOrQuery, [], aWhereCondition, aProgressCaption, aAllRecordsNotJustCurrentBudgetOrPeriod, TRUE);
end;

function qAppendNonExistingsTry(const aTargetTableName: string; const aMainSourceTableNameOrQuery: string; const aOtherSourceTableNameOrQueryAndJoinInformations: array of TTableNameOrQueryAndJoinInformation; const aFieldEqualities: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE; const aShowErrorMessage: Boolean = FALSE): Int64;
begin
  Result := fqSQLCommandTry(sctInsert, aTargetTableName, aMainSourceTableNameOrQuery, aOtherSourceTableNameOrQueryAndJoinInformations, aFieldEqualities, aWhereCondition, aProgressCaption, aAllRecordsNotJustCurrentBudgetOrPeriod, TRUE, aShowErrorMessage);
end;

function qAppendNonExistingsTry(const aTargetTableName: string; const aMainSourceTableNameOrQuery: string; const aOtherSourceTableNameOrQueries: array of string; const aFieldEqualities: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE; const aShowErrorMessage: Boolean = FALSE): Int64;
begin
  Result := fqSQLCommandTry(sctInsert, aTargetTableName, aMainSourceTableNameOrQuery, aOtherSourceTableNameOrQueries, aFieldEqualities, aWhereCondition, aProgressCaption, aAllRecordsNotJustCurrentBudgetOrPeriod, TRUE, aShowErrorMessage);
end;

function qAppendNonExistingsTry(const aTargetTableName: string; const aMainSourceTableNameOrQuery: string; const aFieldEqualities: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE; const aShowErrorMessage: Boolean = FALSE): Int64;
begin
  Result := fqSQLCommandTry(sctInsert, aTargetTableName, aMainSourceTableNameOrQuery, aFieldEqualities, aWhereCondition, aProgressCaption, aAllRecordsNotJustCurrentBudgetOrPeriod, TRUE, aShowErrorMessage);
end;

function qAppendNonExistingsTry(const aTargetTableName: string; const aMainSourceTableNameOrQuery: string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE; const aShowErrorMessage: Boolean = FALSE): Int64;
begin
  Result := fqSQLCommandTry(sctInsert, aTargetTableName, aMainSourceTableNameOrQuery, [], aWhereCondition, aProgressCaption, aAllRecordsNotJustCurrentBudgetOrPeriod, TRUE, aShowErrorMessage);
end;

function qUpdate(const aTargetTableName: string; const aOtherSourceTableNameOrQueryAndJoinInformations: array of TTableNameOrQueryAndJoinInformation; const aFieldEqualities: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE): Int64;
begin
  Result := fqSQLCommand(sctUpdate, aTargetTableName, '', aOtherSourceTableNameOrQueryAndJoinInformations, aFieldEqualities, aWhereCondition, aProgressCaption, aAllRecordsNotJustCurrentBudgetOrPeriod, FALSE);
end;

function qUpdate(const aTargetTableName: string; const aOtherSourceTableNameOrQueries: array of string; const aFieldEqualities: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE): Int64;
begin
  Result := fqSQLCommand(sctUpdate, aTargetTableName, '', aOtherSourceTableNameOrQueries, aFieldEqualities, aWhereCondition, aProgressCaption, aAllRecordsNotJustCurrentBudgetOrPeriod, FALSE);
end;

function qUpdate(const aTargetTableName: string; const aFieldEqualities: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE): Int64;
begin
  Result := fqSQLCommand(sctUpdate, aTargetTableName, '', aFieldEqualities, aWhereCondition, aProgressCaption, aAllRecordsNotJustCurrentBudgetOrPeriod, FALSE);
end;

function qUpdateTry(const aTargetTableName: string; const aOtherSourceTableNameOrQueryAndJoinInformations: array of TTableNameOrQueryAndJoinInformation; const aFieldEqualities: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE; const aShowErrorMessage: Boolean = FALSE): Int64;
begin
  Result := fqSQLCommandTry(sctUpdate, aTargetTableName, '', aOtherSourceTableNameOrQueryAndJoinInformations, aFieldEqualities, aWhereCondition, aProgressCaption, aAllRecordsNotJustCurrentBudgetOrPeriod, FALSE, aShowErrorMessage);
end;

function qUpdateTry(const aTargetTableName: string; const aOtherSourceTableNameOrQueries: array of string; const aFieldEqualities: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE; const aShowErrorMessage: Boolean = FALSE): Int64;
begin
  Result := fqSQLCommandTry(sctUpdate, aTargetTableName, '', aOtherSourceTableNameOrQueries, aFieldEqualities, aWhereCondition, aProgressCaption, aAllRecordsNotJustCurrentBudgetOrPeriod, FALSE, aShowErrorMessage);
end;

function qUpdateTry(const aTargetTableName: string; const aFieldEqualities: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE; const aShowErrorMessage: Boolean = FALSE): Int64;
begin
  Result := fqSQLCommandTry(sctUpdate, aTargetTableName, '', aFieldEqualities, aWhereCondition, aProgressCaption, aAllRecordsNotJustCurrentBudgetOrPeriod, FALSE, aShowErrorMessage);
end;

function qEmpty(const aTargetTableName: string; const aOtherSourceTableNameOrQueryAndJoinInformations: array of TTableNameOrQueryAndJoinInformation; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE): Int64;
begin
  Result := fqSQLCommand(sctDelete, aTargetTableName, '', aOtherSourceTableNameOrQueryAndJoinInformations, [], aWhereCondition, aProgressCaption, aAllRecordsNotJustCurrentBudgetOrPeriod, FALSE);
end;

function qEmpty(const aTargetTableName: string; const aOtherSourceTableNameOrQueries: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE): Int64;
begin
  Result := fqSQLCommand(sctDelete, aTargetTableName, '', aOtherSourceTableNameOrQueries, [], aWhereCondition, aProgressCaption, aAllRecordsNotJustCurrentBudgetOrPeriod, FALSE);
end;

function qEmptyTry(const aTargetTableName: string; const aOtherSourceTableNameOrQueryAndJoinInformations: array of TTableNameOrQueryAndJoinInformation; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE; const aShowErrorMessage: Boolean = FALSE): Int64;
begin
  Result := fqSQLCommandTry(sctDelete, aTargetTableName, '', aOtherSourceTableNameOrQueryAndJoinInformations, [], aWhereCondition, aProgressCaption, aAllRecordsNotJustCurrentBudgetOrPeriod, FALSE, aShowErrorMessage);
end;

function qEmptyTry(const aTargetTableName: string; const aOtherSourceTableNameOrQueries: array of string; const aWhereCondition: string = ''; const aProgressCaption: string = ''; const aAllRecordsNotJustCurrentBudgetOrPeriod: Boolean = FALSE; const aShowErrorMessage: Boolean = FALSE): Int64;
begin
  Result := fqSQLCommandTry(sctDelete, aTargetTableName, '', aOtherSourceTableNameOrQueries, [], aWhereCondition, aProgressCaption, aAllRecordsNotJustCurrentBudgetOrPeriod, FALSE, aShowErrorMessage);
end;

procedure TSQLCommandsForm.FormCreate(Sender: TObject);
begin
  ObjectIDsFindStringLists    := TFindStringLists.Create(2);
  TableOrQueryFindStringLists := TFindStringLists.Create(1);
end;

procedure TSQLCommandsForm.FormDestroy(Sender: TObject);
begin
  IfAssignedFreeAndNil(ObjectIDsFindStringLists);
  IfAssignedFreeAndNil(TableOrQueryFindStringLists);
end;

initialization
  SQLCommandsForm := TSQLCommandsForm.Create(Application);

  ClearAllTableInformationsAndOthers(TRUE);

end.
