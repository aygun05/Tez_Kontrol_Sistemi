unit Events;

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
  cxFontNameComboBox, cxGridDBBandedTableView, cxGridCustomView, cxButtonEdit,
  StdCtrls;

type
  TEventsForm = class(TForm)
    btnGeneralEventSender: TButton;
    procedure btnGeneralEventSenderClick(Sender: TObject);
  private
  public
    procedure cxGridDBBandedTableViewColumnPropertiesButtonClick(Sender: TObject; aButtonIndex: Integer);
  end;

var
  EventsForm: TEventsForm;

  OnCalcFieldsPeriod: TDateTime = 0;
  OnCalcFieldsPeriodSayac: Int64 = 0;

procedure DataSetEvents(aUniQueryEx: TUniQueryEx; const aDataSetEventType: TDataSetEventType; aField: TField);

function MainFormEvents(aMainForm: TForms_MainForm; const aFormEventType: TFormEventType): Boolean;

function cxGridMainFormEvents(acxGridMainForm: TForms_cxGridMainForm; const acxGridMainFormEventType: TcxGridMainFormEventType): Boolean;

function GeneralEventSender(const aEventID: string = ''): TObject;

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
  M_F_SelectFilter,
  ProgrammerData,
  Genel,
  SQLCommands;

var
  TheGeneralEventSenderID: string = '';

function GeneralEventSender(const aEventID: string = ''): TObject;
begin
  TheGeneralEventSenderID := aEventID;

  if Assigned(EventsForm) and (aEventID <> '') then
    Result := EventsForm.btnGeneralEventSender
  else
    Result := nil;
end;

procedure TabloFiltresiBelirleEvent(aDataSet: TDataSet);
var
  aTableName, aSQLText, aFilterSQL, aFilterSQLStreamAsText: string;
begin
  aTableName := aDataSet.FindField('Tablo Adı').AsString;

  if Assigned(aDataSet.FindField('Filtre SQL')) then
    aSQLText := ExpandTablesForGroupsInSQLScript(aDataSet.FindField('Filtre SQL').AsString)
  else
    aSQLText := 'SELECT * FROM "' + ApplicationSchemaName + '"."' + aTableName + '"';

  if (aTableName = '') or (aSQLText = '') then MwAbort(Lang('Bilgiler düzgün girilmemiş.', 'No valid information.'));

  try
    aFilterSQLStreamAsText := MyDeCompressTextDecoding(aDataSet.FindField('Tablo Filtre Değeri').AsString);
  except
    on Ex: Exception do
    begin
      aFilterSQLStreamAsText := '';
      Me_X('aFilterSQLStreamAsText := MyDeCompressTextDecoding(aDataSet.FindField(''Tablo Filtre Değeri'').AsString);...' + LB2 + ExceptionMessage(Ex));
    end;
  end;

  aFilterSQL := aDataSet.FindField('Tablo Filtresi').AsString;

  if not GetFilterSQLBySQLText(Lang('Filtre Belirleyiniz "', 'Define Filter "') + aTableName + '"...', aSQLText, aFilterSQL, aFilterSQLStreamAsText, MainConnection) then Exit;

  if not (aDataSet.State in dsEditModes) then aDataSet.Edit;

  aDataSet.FindField('Tablo Filtresi').AsString := aFilterSQL;

  aFilterSQLStreamAsText := MyCompressTextEncoding(aFilterSQLStreamAsText);

  if aDataSet.FindField('Tablo Filtre Değeri').AsString <> aFilterSQLStreamAsText then aDataSet.FindField('Tablo Filtre Değeri').AsString := aFilterSQLStreamAsText;
end;

procedure TabloAcEvent(aDataSet: TDataSet; const aOpenFiltered: Boolean);
var
  aTableName, aSQLText: string;
begin
  aTableName := aDataSet.FindField('Tablo Adı').AsString;

  if not aOpenFiltered then
    aSQLText := 'SELECT * FROM "' + ApplicationSchemaName + '"."' + aTableName + '"'
  else
    if Assigned(aDataSet.FindField('Final SQL')) then
      aSQLText := ExpandTablesForGroupsInSQLScript(aDataSet.FindField('Final SQL').AsString)
    else
    begin
      aSQLText := 'SELECT * FROM "' + ApplicationSchemaName + '"."' + aTableName + '"';
      if Assigned(aDataSet.FindField('Tablo Filtresi')) then
        if aDataSet.FindField('Tablo Filtresi').AsString <> '' then aSQLText := aSQLText + ' WHERE ' + aDataSet.FindField('Tablo Filtresi').AsString;
    end;

  if (aTableName = '') or (aSQLText = '') then MwAbort(Lang('Bilgiler düzgün girilmemiş.', 'No valid information.'));

  VeriGirisi(nil,
             GetQuery(aSQLText, GetFullTableName(aTableName, ApplicationSchemaName, '', MainConnection), [GetTableInformation(aTableName, ApplicationSchemaName, '')], '', FALSE, '', aTableName, TRUE, FALSE, '', ApplicationSchemaName, MainConnection, '', TRUE),
             aTableName, '', TRUE);
end;

procedure TEventsForm.cxGridDBBandedTableViewColumnPropertiesButtonClick(Sender: TObject; aButtonIndex: Integer);
var
  I: Integer;
  aField: TField;
  aDataSet: TDataSet;
  acxGridDBBandedTableView: TcxGridDBBandedTableView;
begin
  if not Assigned(Sender) then Exit;
  if not (Sender is TcxButtonEdit) then Exit;

  aField                   := nil;
  acxGridDBBandedTableView := nil;

  if TcxButtonEdit(Sender).Parent is TcxGridSite then
    if TcxGridSite(TcxButtonEdit(Sender).Parent).GridView is TcxGridDBBandedTableView then acxGridDBBandedTableView := TcxGridDBBandedTableView(TcxGridSite(TcxButtonEdit(Sender).Parent).GridView);

  if not Assigned(acxGridDBBandedTableView) then Exit;

  for I := 0 to acxGridDBBandedTableView.ColumnCount - 1 do
    if acxGridDBBandedTableView.Columns[I].Properties is TcxButtonEditProperties then
      if @TcxButtonEditProperties(acxGridDBBandedTableView.Columns[I].Properties).OnButtonClick = @TcxButtonEdit(Sender).Properties.OnButtonClick then
        if TcxButtonEditProperties(acxGridDBBandedTableView.Columns[I].Properties).Buttons.Count = TcxButtonEdit(Sender).Properties.Buttons.Count then
          if TcxButtonEditProperties(acxGridDBBandedTableView.Columns[I].Properties).Buttons[0].Tag = TcxButtonEdit(Sender).Properties.Buttons[0].Tag then
          begin
            aField := acxGridDBBandedTableView.Columns[I].DataBinding.Field;
            Break;
          end;

  if not Assigned(aField) then Exit;

  aDataSet := aField.DataSet;

  if aField.FieldName = 'Tablo Filtresi' then TabloFiltresiBelirleEvent(aDataSet);
  if aField.FieldName = 'Tablo Sıra No'  then TabloAcEvent(aDataSet, FALSE);
end;

procedure TheStandartDataSetEvents(aDataSet: TDataSet; const aDataSetEventType: TDataSetEventType; aField: TField);
var
  I, J, K: Integer;
  St1: string;
  aSourceField: TField;
  F1, F2: Double;
  D1: TDateTime;
  aIsNotBoolean: Boolean;
begin
  if not (aDataSet is TUniQueryEx) then Exit;

  with TUniQueryEx(aDataSet) do
  try
    if aDataSetEventType = detOnCalcFields then
    begin
      D1 := Now;

      for I := 0 to Length(MonthCalcFieldsInfos) - 1 do
      begin
        F1 := 0;
        K  := 0;

        aIsNotBoolean := not (MonthCalcFieldsInfos[I].MonthFields[0] is TBooleanField);

        for J := 0 to 12 - 1 do
        begin
          if aIsNotBoolean then
            F2 := MonthCalcFieldsInfos[I].MonthFields[J].AsFloat
          else
            if MonthCalcFieldsInfos[I].MonthFields[J].AsBoolean then
              F2 := 1
            else
              F2 := 0;

          F1 := F1 + F2;

          if F2 = 0 then Inc(K);
        end;

        if Assigned(MonthCalcFieldsInfos[I].MonthCalcSUMField) then MonthCalcFieldsInfos[I].MonthCalcSUMField.AsFloat := F1;

        if Assigned(MonthCalcFieldsInfos[I].MonthCalcAVGField) then
          if K = 12 then
            MonthCalcFieldsInfos[I].MonthCalcAVGField.AsFloat := 0
          else
            MonthCalcFieldsInfos[I].MonthCalcAVGField.AsFloat := F1 / (12 - K);

        if Assigned(MonthCalcFieldsInfos[I].MonthCalcZeroField) then MonthCalcFieldsInfos[I].MonthCalcZeroField.AsInteger := K;
      end;

      Inc(OnCalcFieldsPeriodSayac);

      OnCalcFieldsPeriod := OnCalcFieldsPeriod + (Now - D1);

      Exit;
    end;

    if AnsiUpperCase(MainTableInformation.SchemaName) <> AnsiUpperCase(ApplicationSchemaName) then Exit;

    //UserTableExecSQLs => Table Name, Sıra No, ExecSQL, Show Error, Before Open, After Close, Progress

    if not ReadOnly and (MainTableInformation.TableName <> '') and not ShiftAndCtrlKeysAreBeingPressed then
      case aDataSetEventType of
        detBeforeOpen,
        detAfterClose :
          begin
            if aDataSetEventType = detBeforeOpen then
              St1 := 'Before Open'
            else
              St1 := 'After Close';

            SetDataSetFilter(GenelForm.UserTableExecSQLs, '[Table Name] = ''' + MainTableInformation.TableName + ''' AND [' + St1 + '] IS NOT NULL');

            if GenelForm.UserTableExecSQLs.RecordCount > 0 then
            try
              SetScreenCursor(crHourGlass);

              aSourceField := GenelForm.UserTableExecSQLs.FindField(St1);

              while not GenelForm.UserTableExecSQLs.Eof do
              begin
                St1 := aSourceField.AsString;

                if (St1 = 'A') or
                   ((TheSource =  AnsiUpperCase(ApplicationSchemaName)) and (St1 = 'R')) or
                   ((TheSource <> AnsiUpperCase(ApplicationSchemaName)) and (St1 = 'D')) then
                  ExecSQLTry(GenelForm.UserTableExecSQLs.FindField('ExecSQL').AsString,
                             LangFromText(GenelForm.UserTableExecSQLs.FindField('Progress').AsString) + IfThen(GenelForm.UserTableExecSQLs.FindField('Progress').AsString <> '', LB2 + '"' + MainTableInformation.TableName + '"', ''),
                             Connection,
                             GenelForm.UserTableExecSQLs.FindField('Show Error').AsBoolean);

                GenelForm.UserTableExecSQLs.Next;
              end;
            finally
              SetScreenCursor(crDefault);
            end;
          end;
      end;

    case aDataSetEventType of
      detOnCalcFields : ;
      detBeforeDelete :
        try
          SetDataSetFilter(GenelForm.UserTables, '[Table Name] = ''' + Caption + '''');

          if GenelForm.UserTables.FindField('Erişim').AsString = 'Admin' then
            if Mcw('"' + Caption + '" tablosu yönetici (admin) kontrolünde olan bir tablodur ve silme işlemi çok dikkatli yapılmalıdır.' + LB2 + 'Silme işleminden başka tablo verileri de etkilenebilecektir.' + LB2 + 'Yine de kaydı sileyim mi?') <> mrYes then Abort;
        finally
          ClearDataSetFilter(GenelForm.UserTables);
        end;
      detBeforePost :
        begin
          St1 := ' Tanımı';
          for I := 0 to FieldCount - 1 do
            if Fields[I].Required and Fields[I].CanModify and (Fields[I].Size > 0) and (Fields[I].DataType in [ftString, ftFixedChar, ftWideString, ftFixedWideChar]) then
              if (RightStr(Fields[I].FieldName, Length(St1)) = St1) and (Fields[I].AsString = '') then
              begin
                aSourceField := FindField(DeleteFromRight(Fields[I].FieldName, Length(St1)));
                if Assigned(aSourceField) then
                  if aSourceField.Required and (Fields[I].Size >= aSourceField.Size) and (aSourceField.DataType = Fields[I].DataType) and (aSourceField.FieldKind = Fields[I].FieldKind) then Fields[I].Value := aSourceField.Value;
              end;
        end;
    end;
  except
    on Ex: Exception do
      if Ex is EAbort then
        Abort
      else
        Me_X(ExceptionMessage(Ex) + LB2 + 'procedure TheStandartDataSetEvents...' + LB2 + 'Tablo: "' + RemoveQuotationMarks(GetCaptionFromDataSet(aDataSet, '')) + '"' + LB + 'Event: "' + DataSetEventName(aDataSetEventType) + '"');
  end;
end;

procedure DataSetEvents(aUniQueryEx: TUniQueryEx; const aDataSetEventType: TDataSetEventType; aField: TField);
var
  I: Integer;
  aForms_cxGridMainForm: TForms_cxGridMainForm;
begin
  with aUniQueryEx do
  try
    //UserTableExecSQLs => Table Name, Sıra No, ExecSQL, Show Error, Before Open, After Close, Progress

    case aDataSetEventType of
      detAfterScroll,
      detFieldOnChange :
        if Caption = 'Yevmiye' then
        begin
          aForms_cxGridMainForm := GetForms_cxGridMainFormByDataSet(aUniQueryEx);
          if Assigned(aForms_cxGridMainForm) then
          begin
            aForms_cxGridMainForm.btnUser1.Enabled := (FindField('Tablo Adı').AsString <> '') and (FindField('Filtre SQL').AsString <> '');
            aForms_cxGridMainForm.btnUser2.Enabled := (FindField('Tablo Adı').AsString <> '') and (FindField('Final SQL').AsString  <> '');
          end;
        end;
      detBeforeEdit   : ;
      detBeforeDelete : ;
      detBeforePost   : ;
      detOnNewRecord  :
        if AktifButce.ButceID <> '' then
          for I := 0 to FieldCount - 1 do
            if Fields[I].Required and Fields[I].CanModify and (Fields[I].AsString = '') and (Fields[I] is TNumericField) then
            begin
              if Fields[I].FieldName = 'Bütçe ID'  then Fields[I].AsString := AktifButce.ButceID;
              if Fields[I].FieldName = 'Dönem ID'  then Fields[I].AsString := AktifButce.DonemID;
              if Fields[I].FieldName = 'Şirket ID' then Fields[I].AsString := AktifButce.SirketID;
            end;
      detAfterPost    : ;
    end;
  except
    on Ex: Exception do
      if Ex is EAbort then
        Abort
      else
        Me_X(ExceptionMessage(Ex) + LB2 + 'procedure DataSetEvents...' + LB2 + 'Tablo: "' + RemoveQuotationMarks(GetCaptionFromDataSet(aUniQueryEx, '')) + '"' + LB + 'Event: "' + DataSetEventName(aDataSetEventType) + '"');
  end;
end;

function MainFormEvents(aMainForm: TForms_MainForm; const aFormEventType: TFormEventType): Boolean;
begin
  Result := TRUE;

  with aMainForm do
  try
    case aFormEventType of
      fetOnClose      : ; //Sm('fetOnClose' + LB + aMainForm.Caption);
      fetOnCloseQuery : ; //Sm('fetOnCloseQuery' + LB + aMainForm.Caption);
      fetOnDestroy    : ; //Sm('fetOnDestroy' + LB + aMainForm.Caption);
      fetOnShow       : ; //Sm('fetOnShow' + LB + aMainForm.Caption);
    end;

  except
    on Ex: Exception do
      if Ex is EAbort then
        Abort
      else
        Me_X(ExceptionMessage(Ex) + LB2 + 'Form: "' + TheEventID + '"' + LB + 'Event: "' + FormEventName(aFormEventType) + '"');
  end;
end;

function cxGridMainFormEvents(acxGridMainForm: TForms_cxGridMainForm; const acxGridMainFormEventType: TcxGridMainFormEventType): Boolean;
var
  aDataSet: TDataSet;
begin
  Result := TRUE;

  aDataSet := acxGridMainForm.DataSource1.DataSet;
  if not Assigned(aDataSet) then MessageBeepAbort;

  if acxGridMainForm.TheClickedButtonEventID = 'Tablo Filtresi' then TabloFiltresiBelirleEvent(aDataSet);
  if acxGridMainForm.TheClickedButtonEventID = 'Tablo Aç'       then TabloAcEvent(aDataSet, FALSE);
  if acxGridMainForm.TheClickedButtonEventID = 'Filtreli Aç'    then TabloAcEvent(aDataSet, TRUE);

  case acxGridMainFormEventType of
    cetUserButton1Click : ;
    cetUserButton2Click : ;
    cetUserButton3Click : ;
    cetUserButton4Click : ;
    cetUserButton5Click : ;
    cetUserButton6Click : ;
    cetUserButton7Click : ;
    cetUserButton8Click : ;
    cetUserButton9Click : ;
    cetbtnOKClick       : ;
    cetbtnCancelClick   : ;
  end;
end;

procedure TEventsForm.btnGeneralEventSenderClick(Sender: TObject);
var
  St1: string;
begin
  if TheGeneralEventSenderID = '' then Exit;

  if TheGeneralEventSenderID = 'Aktif Kullanıcı Şifresini Değiştir' then
    with TStringList.Create do
    try
      Text := SelectionOkayButtonClickEventsValueAsText;

      St1 := '';
      if Strings[0] <> CurrentUser.Password then St1 := St1 + Lang('Girdiğiniz şifre mevcut şifreniz değil.', 'Password you entered is not your current password.')         + LB2;
      if Strings[1] <> Strings[2]           then St1 := St1 + Lang('Yeni şifrenin tekrarını aynı girmelisiniz.', 'You must enter the same value for new password (again).') + LB2;
      if Strings[0] =  Strings[1]           then St1 := St1 + Lang('Yeni şifreniz eski şifrenizle aynı olmamalıdır.', 'New password must be different from old password.')  + LB2;

      if St1 <> '' then MwAbort(Trim(St1));
    finally
      Free;
    end;
end;

initialization
  EventsForm := TEventsForm.Create(Application);

  StandartDataSetEvents := TheStandartDataSetEvents;

end.
