unit ProgramGirisi;

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
  ExtCtrls;

type
  TProgramGirisiForm = class(TForm)
    ProgramGirisiUpdateTimer: TTimer;
    procedure ProgramGirisiUpdateTimerTimer(Sender: TObject);
  private
  public
  end;

var
  ProgramGirisiForm: TProgramGirisiForm;

  ProgramGirisiPaused: Boolean = FALSE;

procedure UserProgramEntranceFinish;
procedure UserProgramEntranceStart;

implementation

{$R *.dfm}

uses
  M_Messages,
  M_Files,
  M_Maths,
  M_KeyBoards,
  M_Applications,
  M_INIFiles,
  M_DateTimes,
  M_StartupInfos,
  M_DatabasesMetaData,
  M_F_Progress,
  M_DevExpress,
  M_F_Languages,
  M_Windows;

var
  ProgramGirisiDetayID     : string = '';
  ProgramGirisiStarted     : Boolean = FALSE;
  ProgramGirisiTimerPaused : Boolean = TRUE;

procedure UserProgramEntranceFinish;
begin
  try
    ProgramGirisiTimerPaused := TRUE;

    if not SQLServerConnection(MainConnection) or (ProgramGirisiDetayID = '') or (ApplicationSchemaName = '') then Exit;

    try
      ExecSQL('EXECUTE "' + ApplicationSchemaName + '"."PR Program Girişi, Finish" ' + ProgramGirisiDetayID, '', MainConnection, 'Program Entrance Finish');
    except
      on Ex: Exception do Me_X(ExceptionMessage(Ex));
    end;
  finally
    ProgramGirisiTimerPaused := FALSE;
  end;
end;

procedure UserProgramEntranceStart;
begin
  if ProgramGirisiStarted then UserProgramEntranceFinish;

  try
    ProgramGirisiTimerPaused := TRUE;

    ProgramGirisiStarted     := TRUE;

    if (CurrentUser.UserID = '') or not SQLServerConnection(MainConnection) then
    begin
      ProgramGirisiDetayID := '';
      Exit;
    end;

    ProgramGirisiDetayID := VarToStr(GetFirstFieldValueOfSQLTextTry('EXECUTE "' + ApplicationSchemaName + '"."PR Program Girişi, Start" :parDosyaAdi, :parKullaniciID, :parBilgisayarAdi',
                                                                    [GetParameterInfo(ftString, Application.ExeName), GetParameterInfo(ftString, CurrentUser.UserID), GetParameterInfo(ftString, ComputerName)],
                                                                    '', MainConnection, TRUE, 'Program Entrance Start'));
  finally
    ProgramGirisiTimerPaused := FALSE;
    if Assigned(ProgramGirisiForm) then ProgramGirisiForm.ProgramGirisiUpdateTimer.Enabled := TRUE;
  end;
end;

procedure TProgramGirisiForm.ProgramGirisiUpdateTimerTimer(Sender: TObject);
begin
  if ProgramGirisiPaused or ProgramGirisiTimerPaused then Exit;

  try
    ProgramGirisiTimerPaused         := TRUE;
    ProgramGirisiUpdateTimer.Enabled := FALSE;

    if not SQLServerConnection(MainConnection) or (ProgramGirisiDetayID = '') or (ApplicationSchemaName = '') then Exit;

    ExecSQLTry('UPDATE "' + ApplicationSchemaName + '"."Program Girişi Detay" SET "Çıkış" = CURRENT_TIMESTAMP WHERE "Program Girişi Detay ID" = ' + ProgramGirisiDetayID, '', MainConnection, FALSE, 'Program Entrance Update');
    //ExecSQLTry(DupeString('UPDATE "' + ApplicationSchemaName + '"."Program Girişi Detay" SET "Çıkış" = CURRENT_TIMESTAMP WHERE "Program Girişi Detay ID" = ' + ProgramGirisiDetayID + LB, 1000), '', MainConnection, FALSE, 'Program Entrance Update');
  finally
    ProgramGirisiTimerPaused         := FALSE;
    ProgramGirisiUpdateTimer.Enabled := TRUE;
  end;
end;

initialization
  ProgramGirisiForm := TProgramGirisiForm.Create(Application);

end.
