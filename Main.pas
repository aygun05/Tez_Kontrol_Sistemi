unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, StrUtils, ExtCtrls, Menus, cxHint, DB, DBClient, SqlExpr,
  Types, dxBarExtItems, dxBar, ADODB, CRBatchMove, MemDS, VirtualTable, cxTL,
  DBAccess, Uni, UniProvider, cxClasses, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxCustomData, cxStyles, cxTextEdit, Buttons, UniDacVcl,
  cxTLdxBarBuiltInMenu, cxInplaceContainer, cxPropertiesStore, dxStatusBar,
  cxGridDBBandedTableView, dxRibbonStatusBar, dxRibbon, MemData, cxPC, dxmdaset,
  cxRadioGroup, cxMemo, cxCheckBox, cxSpinEdit, cxCheckGroup, cxLabel, dximctrl,
  cxDropDownEdit, cxFontNameComboBox, cxDBExtLookupComboBox, cxBarEditItem,
  cxShellComboBox, Grids, DBGrids, CRGrid, ComCtrls, CustomizeDlg, ActnMan,
  ActnColorMaps, RibbonLunaStyleActnCtrls, Ribbon, Keyboard, ImgList, ToolWin,
  ActnCtrls, ActnMenus, ActnList, dxRibbonGallery, cxContainer, cxEdit, jpeg,
  cxImage, CategoryButtons, ButtonGroup, cxColorComboBox, IBCClassesUni,
  cxDBLookupComboBox, cxRichEdit, cxShellBrowserDialog, ShlObj, cxShellCommon,
  cxShellTreeView, cxShellListView, cxMaskEdit, DateUtils, System.ImageList,
  cxImageComboBox, dxGDIPlusClasses;

type
  TMainForm = class(TForm)
    dxBarManager: TdxBarManager;
    UniConnectionForProgram: TUniConnection;
    MainFormTimer: TTimer;
    FavoritesFirstItem: TdxBarButton;
    ActiveFormsBar: TdxBar;
    cxLargeImages: TcxImageList;
    cxSmallImages: TcxImageList;
    dxBarManagerMenuBar: TdxBar;
    YapiSubItem: TdxBarSubItem;
    SatisSubItem: TdxBarSubItem;
    UretimSubItem: TdxBarSubItem;
    AlimSubItem: TdxBarSubItem;
    UniConnectionForProgrammer: TUniConnection;
    ProgramciSubItem: TdxBarSubItem;
    CloseItem: TdxBarLargeButton;
    cxStyleRepository: TcxStyleRepository;
    cxStyleBoldItalic11Blue: TcxStyle;
    cxStyleBold8Maroon: TcxStyle;
    cxStyleBold8Navy: TcxStyle;
    cxStyleBold8Purple: TcxStyle;
    cxStyleBold10Maroon: TcxStyle;
    cxStyleBold10Black: TcxStyle;
    cxStyleBold10Navy: TcxStyle;
    cxStyleBold11Navy: TcxStyle;
    cxStyleBold11Red: TcxStyle;
    cxStyleBarMemoEdit: TcxStyle;
    cxStyleBold8Black: TcxStyle;
    cxStyleNarrowBold8Maroon: TcxStyle;
    cxStyleNarrowBold8Navy: TcxStyle;
    PencereSubItem: TdxBarSubItem;
    GenelSubItem: TdxBarSubItem;
    PencereSubItem_2: TdxBarSubItem;
    KisayollarSubItem: TdxBarSubItem;
    AktifVeritabaniniDegistirItem: TdxBarButton;
    AktifKullaniciSifresiniDegistirItem: TdxBarButton;
    CurrentFormAndCountOfFormsItem: TdxBarButton;
    ButceAcItem: TdxBarButton;
    BackgroundImage: TImage;
    dxBarPopupMenu1: TdxBarPopupMenu;
    FormArkaRengiColorComboBoxEditItem: TcxBarEditItem;
    FormArkaResmiBelirleItem: TdxBarButton;
    FormArkaResminiCheckGroupEditItem: TcxBarEditItem;
    FormArkaResminiIptalEtItem: TdxBarButton;
    ImageSeperatorEditItem: TcxBarEditItem;
    cxStyleImageSeparatorRepository: TcxStyleRepository;
    cxStyleImageSeparator: TcxStyle;
    FormArkaResminiKaydetItem: TdxBarButton;
    DepartmanItem: TdxBarButton;
    SatisRaporSubItem: TdxBarSubItem;
    UretimRaporSubItem: TdxBarSubItem;
    AlimRaporSubItem: TdxBarSubItem;
    SatisVeriSubItem: TdxBarSubItem;
    UretimVeriSubItem: TdxBarSubItem;
    AlimVeriSubItem: TdxBarSubItem;
    BirimItem: TdxBarButton;
    KullaniciItem: TdxBarButton;
    ProgrammersBar: TdxBar;
    ProgrammersMessagesMemoEditItem: TcxBarEditItem;
    CloseProgrammersBarItem: TdxBarButton;
    ProgramciyaMesajlariEditordeGosterItem: TdxBarButton;
    UrunItem: TdxBarButton;
    cxStyleBold8Blue: TcxStyle;
    cxStyleBold8BlueItalicUnderline: TcxStyle;
    YetkiveKullaniciItem: TdxBarButton;
    SirketItem: TdxBarButton;
    DonemItem: TdxBarButton;
    SatisItem: TdxBarButton;
    AlimItem: TdxBarButton;
    ParaItem: TdxBarButton;
    YoneticiSubItem: TdxBarSubItem;
    YapiSetupSubItem: TdxBarSubItem;
    YoneticiVeriSubItem: TdxBarSubItem;
    FontItem: TdxBarButton;
    KarZararItem: TdxBarButton;
    VersiyonItem: TdxBarButton;
    DonemVersiyonItem: TdxBarButton;
    HesapItem: TdxBarButton;
    VarsayimItem: TdxBarButton;
    GrupItem: TdxBarButton;
    GruptanGrupItem: TdxBarButton;
    VarsayimSatisMiktarItem: TdxBarButton;
    VarsayimSatisFiyatItem: TdxBarButton;
    VarsayimAlimFiyatItem: TdxBarButton;
    VarsayimGiderOzetItem: TdxBarButton;
    VarsayimGiderDetayItem: TdxBarButton;
    ArtisItem: TdxBarButton;
    GiderSubItem: TdxBarSubItem;
    GiderRaporSubItem: TdxBarSubItem;
    GiderVeriSubItem: TdxBarSubItem;
    FiiliSubItem: TdxBarSubItem;
    FiiliRaporSubItem: TdxBarSubItem;
    FiiliVeriSubItem: TdxBarSubItem;
    FiiliSatisMiktarItem: TdxBarButton;
    FiiliAlimMiktarItem: TdxBarButton;
    FiiliGiderOzetItem: TdxBarButton;
    FiiliGiderDetayItem: TdxBarButton;
    NakitItem: TdxBarButton;
    VadeItem: TdxBarButton;
    ButceItem: TdxBarButton;
    ProgramGirisiItem: TdxBarButton;
    SQLLOGIslemleriSubItem: TdxBarSubItem;
    SQLLOGTablosunuGosterItem: TdxBarButton;
    MesajLOGTablosunuGosterItem: TdxBarButton;
    SQLLOGTablosunuKaydetItem: TdxBarButton;
    LOGAktifCheckGroupItem: TcxBarEditItem;
    FiiliKurItem: TdxBarButton;
    FiiliSatisFiyatItem: TdxBarButton;
    FiiliAlimFiyatItem: TdxBarButton;
    YoneticiRaporSubItem: TdxBarSubItem;
    YapiRaporSubItem: TdxBarSubItem;
    EventsItem: TdxBarButton;
    MesajLOGTablosunuKaydetItem: TdxBarButton;
    MesajLOGIslemleriSubItem: TdxBarSubItem;
    KademeItem: TdxBarButton;
    PersonelSubItem: TdxBarSubItem;
    PersonelVeriSubItem: TdxBarSubItem;
    PersonelRaporSubItem: TdxBarSubItem;
    VarsayimPersonelAdetItem: TdxBarButton;
    FiiliPersonelAdetItem: TdxBarButton;
    cxStyleBold8Red: TcxStyle;
    LOGTabloKayitlariniSilItem: TdxBarButton;
    VeritabaniOzelIslemleriSubItem: TdxBarSubItem;
    AktifVeritabaniniKucultShrinkItem: TdxBarButton;
    VarsayimPersonelUcretItem: TdxBarButton;
    FiiliPersonelUcretItem: TdxBarButton;
    YevmiyeItem: TdxBarButton;
    ProgramGirisTabloKayitlariniSilItem: TdxBarButton;
    ButceAcTimer: TTimer;
    KullaniciTabloAlanItem: TdxBarButton;
    KDVItem: TdxBarButton;
    DonemDetayItem: TdxBarButton;
    VarsayimButceItem: TdxBarButton;
    FiiliKurDetayItem: TdxBarButton;
    FiiliKurDetay2Item: TdxBarButton;
    dxBarSubItem1: TdxBarSubItem;
    TabloAcBtn: TdxBarButton;
    ProgramHakkindaBtn: TdxBarButton;
    SnortLogToTableBtn: TdxBarButton;
    WordAnalizBtn: TdxBarButton;
    dxBarSubItem2: TdxBarSubItem;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    dxBarSeparator1: TdxBarSeparator;
    AnalizDesigncxBarEditItem: TcxBarEditItem;
    OrientationcxBarEditItem: TcxBarEditItem;
    LeftMarjincxBarEditItem: TcxBarEditItem;
    MinimumSayfaSayisicxBarEditItem: TcxBarEditItem;
    TopMarjincxBarEditItem: TcxBarEditItem;
    BottomMarjincxBarEditItem: TcxBarEditItem;
    RightMarjincxBarEditItem: TcxBarEditItem;
    DuyarlilikcxBarEditItem: TcxBarEditItem;
    SayfaBoyutlaricxBarEditItem: TcxBarEditItem;
    dxBarButton4: TdxBarButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure MainFormTimerTimer(Sender: TObject);
    procedure FavoritesFirstItemClick(Sender: TObject);
    procedure CloseItemClick(Sender: TObject);
    procedure dxBarManagerClickItem(Sender: TdxBarManager; ClickedItem: TdxBarItem);
    procedure KisayollarSubItemPopup(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure dxBarManagerShowCustomizingForm(Sender: TObject);
    procedure dxBarManagerHideCustomizingForm(Sender: TObject);
    procedure AktifVeritabaniniDegistirItemClick(Sender: TObject);
    procedure AktifKullaniciSifresiniDegistirItemClick(Sender: TObject);
    procedure FormArkaRengiColorComboBoxEditItemChange(Sender: TObject);
    procedure FormArkaResmiBelirleItemClick(Sender: TObject);
    procedure FormArkaResminiIptalEtItemClick(Sender: TObject);
    procedure FormArkaResminiKaydetItemClick(Sender: TObject);
    procedure FormContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure CloseProgrammersBarItemClick(Sender: TObject);
    procedure ProgramciyaMesajlariEditordeGosterItemClick(Sender: TObject);
    procedure CurrentFormAndCountOfFormsItemClick(Sender: TObject);
    procedure SQLLOGTablosunuGosterItemClick(Sender: TObject);
    procedure MesajLOGTablosunuGosterItemClick(Sender: TObject);
    procedure SQLLOGTablosunuKaydetItemClick(Sender: TObject);
    procedure LOGAktifCheckGroupItemChange(Sender: TObject);
    procedure MesajLOGTablosunuKaydetItemClick(Sender: TObject);
    procedure ButceAcItemClick(Sender: TObject);
    procedure UniConnectionForProgrammerBeforeConnect(Sender: TObject);
    procedure LOGTabloKayitlariniSilItemClick(Sender: TObject);
    procedure AktifVeritabaniniKucultShrinkItemClick(Sender: TObject);
    procedure ProgramGirisTabloKayitlariniSilItemClick(Sender: TObject);
    procedure ButceAcTimerTimer(Sender: TObject);
    procedure TabloAcBtnClick(Sender: TObject);
    procedure ProgramHakkindaBtnClick(Sender: TObject);
    procedure SnortLogToTableBtnClick(Sender: TObject);
    procedure WordAnalizBtnClick(Sender: TObject);
    procedure dxBarButton4Click(Sender: TObject);
    procedure dxBarButton2Click(Sender: TObject);
  private
  public
    MainFormStringLists       : array[0..10 - 1] of TStringList;
    MainFormSortedStringLists : array[0..10 - 1] of TStringList;


    ProgrammerMessagesList     : TStringList;
    GroupFilterInfosSortedList : TStringList;

    FavoritesButtons          : array of TdxBarButton;
    FavoritesButtonHandles    : array of Int64;

    procedure SetItemsEnabledAndVisibleAndCaption;
    procedure MyMemoItemCurChange(Sender: TObject);
    procedure SetFormArkaRengiItemsEnabledAndVisibleAndCaption;
    procedure SetUserMenusTable;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  M_Consts,
  M_Strings,
  M_Messages,
  M_Files,
  M_Maths,
  M_KeyBoards,
  M_DevExpress,
  M_DateTimes,
  M_F_FormUtilities,
  M_Applications,
  M_INIFiles,
  M_StartupInfos,
  M_Databases,
  M_DatabasesMetaData,
  M_F_Progress,
  M_F_Selections,
  M_F_Calculator,
  M_F_Forms_cxGridMain,
  M_Dialogs,
  M_F_Forms_PageControl,
  M_F_Forms_Main,
  M_F_OleContainer,
  M_F_Languages,
  M_F_TextRichEditor,
  M_Windows,
  M_F_SelectFromSourceTargetcxGrid,
  M_F_Forms_Vertical_Horizontal,
  M_F_Databases,
  M_F_SelectFromSourceTargetDataSet,
  M_F_TabloIslemleri,
  M_StringLists,
  M_Compression,
  M_F_Database_Dialog,
  M_F_About,
  Programmer,
  Genel,
  SQLCommands,
  Events,
  ProgramGirisi,
  SnortLogToTable;

var
  ApplicationStartedWithoutAnyProblem: Boolean = FALSE;

  MainFormMainCaption: string = '';

procedure SetdxBarItemCaptionAndHint(adxBarItem: TdxBarItem; const aCaptionAndHint: string);
begin
  if not Assigned(adxBarItem) then Exit;
  adxBarItem.Caption := aCaptionAndHint;
  adxBarItem.Hint    := aCaptionAndHint;
end;

procedure TMainForm.SetItemsEnabledAndVisibleAndCaption;
begin
  AktifKullaniciSifresiniDegistirItem.Enabled := CurrentUser.Password <> '';

  MainSQLLogging.Active := VarToStr(LOGAktifCheckGroupItem.EditValue) = '1';

  SetdxBarItemVisibleByBoolean(YoneticiSubItem,                     CurrentUser.Administrator);
  SetdxBarItemVisibleByBoolean(SQLLOGIslemleriSubItem,              CurrentUser.Administrator);
  SetdxBarItemVisibleByBoolean(MesajLOGIslemleriSubItem,            CurrentUser.Administrator);
  SetdxBarItemVisibleByBoolean(YoneticiRaporSubItem,                CurrentUser.Administrator);
  SetdxBarItemVisibleByBoolean(AktifVeritabaniniKucultShrinkItem,   CurrentUser.Administrator and (GetDatabaseType(MainConnection) = dtSQLServer));
  SetdxBarItemVisibleByBoolean(VeritabaniOzelIslemleriSubItem,      CurrentUser.Administrator);
  SetdxBarItemVisibleByBoolean(LOGTabloKayitlariniSilItem,          CurrentUser.Administrator and CurrentUser.DatabaseLogging);
  SetdxBarItemVisibleByBoolean(ProgramGirisTabloKayitlariniSilItem, CurrentUser.Administrator);
end;

procedure TMainForm.MyMemoItemCurChange(Sender: TObject);
begin
  if Sender is TcxBarEditItem then
    if TcxBarEditItem(Sender).EditValue <> TcxBarEditItem(Sender).CurEditValue then TcxBarEditItem(Sender).EditValue := TcxBarEditItem(Sender).CurEditValue;

  SetItemsEnabledAndVisibleAndCaption;
end;

procedure TMainForm.SetFormArkaRengiItemsEnabledAndVisibleAndCaption;
var
  I: Integer;
  aColor: TColor;
  St1, aCheckGroupValue: string;
  aList: TStringList;
begin
  aColor := StrToIntDef(VarToStr(FormArkaRengiColorComboBoxEditItem.EditValue), Self.Color);
  if Self.Color <> aColor then Self.Color := aColor;

  aCheckGroupValue := VarToStr(FormArkaResminiCheckGroupEditItem.EditValue) + DupeString('0', 10);
  if BackgroundImage.Center       <> (aCheckGroupValue[1] = '1') then BackgroundImage.Center       := aCheckGroupValue[1] = '1';
  if BackgroundImage.Stretch      <> (aCheckGroupValue[2] = '1') then BackgroundImage.Stretch      := aCheckGroupValue[2] = '1';
  if BackgroundImage.Proportional <> (aCheckGroupValue[3] = '1') then BackgroundImage.Proportional := aCheckGroupValue[3] = '1';

  Realign;

  if Self.Visible then
  begin
    aList := TStringList.Create;
    try
      aList.Add('Color='              + IntToStr(Self.Color));
      aList.Add('Image.Center='       + MyBooleanToStr(BackgroundImage.Center));
      aList.Add('Image.Stretch='      + MyBooleanToStr(BackgroundImage.Stretch));
      aList.Add('Image.Proportional=' + MyBooleanToStr(BackgroundImage.Proportional));

      with TcxColorComboBoxProperties(FormArkaRengiColorComboBoxEditItem.Properties) do
      begin
        for I := MRUColors.Count - 1 downto 0 do
          if MRUColors[I].Color = Self.Color then MRUColors.Delete(I);

        MRUColors.InsertColor(0, Self.Color, '');

        while MRUColors.Count > MaxMRUColors do MRUColors.Delete(MRUColors.Count - 1);

        for I := 0 to MaxMRUColors - 1 do
        begin
          if MRUColors.Count > I then
            St1 := IntToStr(MRUColors[I].Color)
          else
            St1 := '';

          aList.Add('MRUColors[' + IntToStr(I) + ']=' + St1);
        end;
      end;

      WriteINI(Self, 'Form Background', aList);
    finally
      aList.Free;
    end;
  end;
end;

procedure TMainForm.SetUserMenusTable;
var
  I, aMenuDoesNotExistCount: Integer;
  aMenu, aMenuEnglish: string;
  adxBarItem: TdxBarItem;
  aHasOnclick, aDoesNotExist: Boolean;
  aList: TStringList;
begin
  aMenuDoesNotExistCount := 0;

  aList := TStringList.Create;
  try
    GenelForm.UserMenu.First;

    while not GenelForm.UserMenu.Eof do
    begin
      aMenu        := GenelForm.UserMenu.FindField('Menü').AsString;
      aMenuEnglish := GenelForm.UserMenu.FindField('Menü English').AsString;

      adxBarItem := nil;
      for I := 0 to dxBarManager.ItemCount - 1 do
        if aMenu = dxBarManager.Items[I].Caption then
        begin
          adxBarItem := dxBarManager.Items[I];
          Break;
        end;

      aHasOnclick   := FALSE;
      aDoesNotExist := not Assigned(adxBarItem);

      if Assigned(adxBarItem) then
      begin
        if adxBarItem.Tag <> 0 then MessageToProgrammer('Yazılım hatası gibi!!!....................... if adxBarItem.Tag <> 0 then...' + LB2 + IntToStr(adxBarItem.Tag) + LB2 + adxBarItem.Caption);

        SetdxBarItemVisibleByBoolean(adxBarItem, TRUE);

        adxBarItem.Tag := GenelForm.UserMenu.RecNo + 1000000;

        adxBarItem.Caption := Lang(aMenu, aMenuEnglish);
        adxBarItem.Hint    := adxBarItem.Caption;

        if Assigned(adxBarItem.OnClick) then
        begin
          aHasOnclick := TRUE;
          if TheProgrammersComputer then adxBarItem.Style := cxStyleBold8BlueItalicUnderline;
        end
        else
        begin
          adxBarItem.OnClick := GenelForm.MainUserMenuItemClick;
          if TheProgrammersComputer then adxBarItem.Style := cxStyleBold8Blue;
        end;
      end;

      if aHasOnclick or aDoesNotExist then
      begin
        GenelForm.UserMenu.Edit;
        GenelForm.UserMenu.FindField('Problem').AsBoolean := TRUE;
        GenelForm.UserMenu.Post;
      end;

      if aDoesNotExist then Inc(aMenuDoesNotExistCount);

      GenelForm.UserMenu.Next;
    end;
  finally
    aList.Free;
  end;

  if aMenuDoesNotExistCount > 0 then MessageToProgrammer('Tanımsız menüler var (' + FormatInt(aMenuDoesNotExistCount) + ' tane). "User Menus" tablosuna bakınız.', TRUE);
end;

var
  MessageToProgrammerCount: Integer = 0;

procedure MyMessageToProgrammerProc(const aMessage: string);
var
  K: Integer;
  St1: string;
begin
  if not TheProgrammersComputer or not Assigned(MainForm) then Exit;

  Inc(MessageToProgrammerCount);

  with TStringList.Create do
  try
    Text := FormatInt(MessageToProgrammerCount) + ') ' + Trim(aMessage);

    K := Count;
    if K > 5 then K := 5;
    if K = 0 then K := 1;

    St1 := Trim(Text);
  finally
    Free;
  end;

  if MainForm.ProgrammerMessagesList.Count > 0 then MainForm.ProgrammerMessagesList.Add(DupeString('----------', 10));
  MainForm.ProgrammerMessagesList.Add(St1);

  TcxMemoProperties(MainForm.ProgrammersMessagesMemoEditItem.Properties).VisibleLineCount := K;

  MainForm.ProgrammersMessagesMemoEditItem.EditValue := St1;
  MainForm.ProgrammersBar.Visible := TRUE;
end;

procedure MyGroupFilterInfosProc(aUniQueryEx: TUniQueryEx);
var
  I, F, K: Integer;
  St1, aTableName: string;
begin
  if not Assigned(aUniQueryEx) then Exit;
  if not Assigned(MainForm) then Exit;

  if aUniQueryEx.Connection <> MainConnection then Exit;


  if MainForm.GroupFilterInfosSortedList.Count = 0 then
  begin
    K := GenelForm.UserTables.RecNo;
    try
      SetDataSetFilter(GenelForm.UserTables, '[Has Group] = ''TRUE''');
      while not GenelForm.UserTables.Eof do
      begin
        MainForm.GroupFilterInfosSortedList.Add(GenelForm.UserTables.FindField('Table Name').AsString);

        GenelForm.UserTables.Next;
      end;
    finally
      ClearDataSetFilter(GenelForm.UserTables);
      GenelForm.UserTables.RecNo := K;
    end;
  end;

  ExtractTableSchemaAndDatabaseNamesFromFullTableName(GetTableNameFromDataSet(aUniQueryEx, ''), aTableName, St1, St1);

  SetLength(aUniQueryEx.GroupFilterInfos, aUniQueryEx.FieldCount);

  K := 0;
  for I := 0 to aUniQueryEx.FieldCount - 1 do
  begin
    St1 := '';

    case aUniQueryEx.Fields[I].DataType of
      ftString, ftFixedChar, ftWideString, ftFixedWideChar : St1 := aUniQueryEx.Fields[I].FieldName;
      ftInteger, ftAutoInc, ftLargeint, ftLongWord         : if RightStr(aUniQueryEx.Fields[I].FieldName, 3) = ' ID' then St1 := DeleteFromRight(aUniQueryEx.Fields[I].FieldName, 3);
    end;

    if (St1 = '') or (aTableName = St1 + ' Grup') then Continue;

    if MainForm.GroupFilterInfosSortedList.Find(St1, F) then
      if MainForm.GroupFilterInfosSortedList[F] = St1 then
      begin
        aUniQueryEx.GroupFilterInfos[K].GroupFieldName   := aUniQueryEx.Fields[I].FieldName;
        aUniQueryEx.GroupFilterInfos[K].GroupSchemaName  := ApplicationSchemaName;
        aUniQueryEx.GroupFilterInfos[K].GroupTableName   := St1 + ' Grup';
        aUniQueryEx.GroupFilterInfos[K].GroupPKTableName := St1;

        Inc(K);
      end;
  end;

  SetLength(aUniQueryEx.GroupFilterInfos, K);
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  I: Integer;
  St1: string;
begin
  ApplicationSchemaName := 'Tablolar';

  CreateAllStringLists(MainFormStringLists,       FALSE);
  CreateAllStringLists(MainFormSortedStringLists, TRUE);

  ProgrammerMessagesList     := TStringList.Create;
  GroupFilterInfosSortedList := TStringList.Create;

  BuildUsersApplicationEXEFile('User', 0.3);

  MainFormMainCaption := Self.Caption;

  if TheProgrammersComputer then MessageToProgrammerProc := MyMessageToProgrammerProc;

  GroupFilterInfosProc := MyGroupFilterInfosProc;

  MainConnection := UniConnectionForProgram;

  LOGAktifCheckGroupItem.EditValue := IfThen(TheProgrammersComputer, '1', '0');

  //if not GetConnectionInformation(Lang('Aktif Veritabanı Bilgilerini Giriniz...', 'Enter Current Database Information...') + ' [' + ApplicationSchemaName + ']', Self, 'Current Database', MainConnection, TheProgrammersComputer and not ShiftOrCtrlOrAltKeyIsBeingPressed, [{'SQL Server', 'Oracle', 'Interbase'}], nil{MainConnectionControlFunction}) then Exit;

  ProgressStartAsWaitMessage(Lang(ApplicationSchemaName + ' başlıyor...', ApplicationSchemaName + ' is starting...'));

  UserProgramEntranceStart;

  MainSchemaName := IfThen(AnsiUpperCase(MainConnection.ProviderName) = 'SQL SERVER', 'dbo', '');

  if TheProgrammersComputer then
  begin
    UniConnectionForProgrammer.Database := ApplicationSchemaName + 'Data';

    TheProgrammersConnection := UniConnectionForProgrammer;
    TheProgrammersSchemaName := 'dbo';
  end;

  dxBarManager.BeginUpdate;
  try
    PencereSubItem.ItemLinks   := MainFormUtilitiesForm.PencereSubItem.ItemLinks;
    PencereSubItem_2.ItemLinks := MainFormUtilitiesForm.PencereSubItem.ItemLinks;
    GenelSubItem.ItemLinks     := MainFormUtilitiesForm.GenelSubItem.ItemLinks;
    ProgramciSubItem.ItemLinks := ProgrammerForm.ProgramciSubItem.ItemLinks;

    if TheProgrammersComputer then
      ProgrammersBar.Visible := FALSE
    else
      ProgrammersBar.Free;

    SetdxBarItemCaptionAndHint(ProgramciSubItem, 'Prog.||Prog.');
    SetdxBarItemCaptionAndHint(YapiSubItem,      'Yapı||Main');
    SetdxBarItemCaptionAndHint(SatisSubItem,     'Satış||Sells');
    SetdxBarItemCaptionAndHint(UretimSubItem,    'Üretim||Product');
    SetdxBarItemCaptionAndHint(AlimSubItem,      'Alım||Buys');
    SetdxBarItemCaptionAndHint(PersonelSubItem,  'Personel||Persons');
    SetdxBarItemCaptionAndHint(GiderSubItem,     'Gider||Outgoings');
    SetdxBarItemCaptionAndHint(FiiliSubItem,     'Fiili||Actual');
    SetdxBarItemCaptionAndHint(PencereSubItem,   'Pencere||Window');
    SetdxBarItemCaptionAndHint(PencereSubItem_2, 'Pencere||Window');
    SetdxBarItemCaptionAndHint(GenelSubItem,     'Genel||General');

    try
      SetUserMenusTable;
    except
      on Ex: Exception do Me(ExceptionMessage(Ex));
    end;

    for I := 0 to ComponentCount - 1 do
      if Components[I] is TdxBarItem then
      begin
        if System.Pos('dxBarButton',  Components[I].Name) > 0 then Me_X('System.Pos(''dxBarButton'',  Components[I].Name) > 0...: ' + Components[I].Name);
        if System.Pos('dxBarSubItem', Components[I].Name) > 0 then Me_X('System.Pos(''dxBarSubItem'', Components[I].Name) > 0...: ' + Components[I].Name);

        if not (Components[I] is TdxBarSubItem) then
        begin
          if TdxBarItem(Components[I]).Caption <> TdxBarItem(Components[I]).Hint then Me_X('TdxBarItem(Components[I]).Caption <> TdxBarItem(Components[I]).Hint...: ' + Components[I].Name);
          if RightStr(TdxBarItem(Components[I]).Name, 4) <> 'Item' then Me_X('RightStr(TdxBarItem(Components[I]).Name, 4) <> ''Item''...: ' + Components[I].Name);
        end;
      end;

    CurrentFormAndCountOfFormsItem.Caption := '';

    SetdxBarItemVisibleByTheProgrammersComputer(ProgramciSubItem);

    SetLength(FavoritesButtons,       1);
    SetLength(FavoritesButtonHandles, 1);
    FavoritesButtons[0]       := FavoritesFirstItem;
    FavoritesButtonHandles[0] := -1;


    ///////////////////////Form Background işlemleri//////////////////////

    //Color := $00C08000;
    //Color := $00C08080;
    //Color := $00FF8080;

    BackgroundImage.Align   := alClient;
    BackgroundImage.Picture := nil;
    TcxColorComboBoxProperties(FormArkaRengiColorComboBoxEditItem.Properties).CustomColors[0].Color := Self.Color;

    ClearAllStringLists(MainFormStringLists);
    try
      ReadINI(Self, 'Form Background', MainFormStringLists[0]);

      FormArkaRengiColorComboBoxEditItem.EditValue := StrToIntDef(MainFormStringLists[0].Values['Color'], Self.Color);

      FormArkaResminiIptalEtItem.Enabled := FALSE;
      FormArkaResminiKaydetItem.Enabled  := FALSE;

      if MainFormStringLists[0].Values['FileName'] <> '' then
        if FileExists(MainFormStringLists[0].Values['FileName']) then
        try
          try
            SetScreenCursor(crHourGlass);

            BackgroundImage.Picture.LoadFromFile(MainFormStringLists[0].Values['FileName']);
          finally
            SetScreenCursor(crDefault);
          end;

          FormArkaResminiIptalEtItem.Enabled := TRUE;
          FormArkaResminiKaydetItem.Enabled  := TRUE;
        except
          on Ex: Exception do Me_X(ExceptionMessage(Ex));
        end;

      BackgroundImage.Center       := AnsiUpperCase(MainFormStringLists[0].Values['Image.Center'])       <> 'FALSE';
      BackgroundImage.Stretch      := AnsiUpperCase(MainFormStringLists[0].Values['Image.Stretch'])      <> 'FALSE';
      BackgroundImage.Proportional := AnsiUpperCase(MainFormStringLists[0].Values['Image.Proportional']) =  'TRUE';

      St1 := IfThen(BackgroundImage.Center, '1', '0') + IfThen(BackgroundImage.Stretch, '1', '0') + IfThen(BackgroundImage.Proportional, '1', '0');
      if FormArkaResminiCheckGroupEditItem.EditValue <> St1  then FormArkaResminiCheckGroupEditItem.EditValue := St1;

      with TcxColorComboBoxProperties(FormArkaRengiColorComboBoxEditItem.Properties) do
        for I := 0 to MaxMRUColors - 1 do
        begin
          St1 := MainFormStringLists[0].Values['MRUColors[' + IntToStr(I) + ']'];
          if not IsInteger(St1) then Continue;

          MRUColors.Add.Color := StrToInt(St1);
        end;
    finally
      ClearAllStringLists(MainFormStringLists);
    end;
    /////////////////////////////////////////////////

    SetLanguage(Self, FALSE, cxStyleBold8Black);

    SetcxEditItemsStandartEvents(Self, KisayollarSubItemPopup, LOGAktifCheckGroupItemChange, MyMemoItemCurChange, nil);
  finally
    dxBarManager.EndUpdate;
  end;

  ApplicationStartedWithoutAnyProblem := TRUE;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FreeAllStringLists(MainFormStringLists);
  FreeAllStringLists(MainFormSortedStringLists);
  ProgrammerMessagesList.Free;
  GroupFilterInfosSortedList.Free;
end;

procedure TMainForm.FormShow(Sender: TObject);
var
  I: Integer;
  St1: string;
begin
  if not ApplicationStartedWithoutAnyProblem then
  try
    Self.BorderStyle := bsNone;
    Self.SetBounds(Screen.Width + 1, Screen.Height + 1, 0, 0);
    Exit;
  finally
    FinishTheProgram;
  end;

  LoaddxBarItemLinksFromFile(Self, KisayollarSubItem, TheProgramLOGPath + 'ShortCuts_MainForm.LOG');

  LoaddxBarItemLinksFromFile(Self, MainFormUtilitiesForm.SonYapilanIslemlerSubItem, TheProgramLOGPath + 'LastClickedItems.LOG', MaxLastClickedItemCount);
  for I := 0 to MainFormUtilitiesForm.SonYapilanIslemlerSubItem.ItemLinks.Count - 1 do MainFormUtilitiesForm.SonYapilanIslemlerSubItem.ItemLinks.Items[I].BeginGroup := TRUE;

  KisayollarSubItemPopup(nil);

  AlignFormToScreenByPercent(Self, 98.3);

  LoadFormBoundsFromINI('Main Form Bounds', Self);

  St1 := AnsiUpperCase(ReadINI(Self, 'dxBarManager', 'dxBarManagerMenuBar.DockingStyle'));
  if St1 = 'LEFT'   then dxBarManagerMenuBar.DockingStyle := dsLeft;
  if St1 = 'RIGHT'  then dxBarManagerMenuBar.DockingStyle := dsRight;
  if St1 = 'BOTTOM' then dxBarManagerMenuBar.DockingStyle := dsBottom;
  if St1 = 'TOP'    then dxBarManagerMenuBar.DockingStyle := dsTop;

  St1 := AnsiUpperCase(ReadINI(Self, 'dxBarManager', 'ActiveFormsBar.DockingStyle'));
  if St1 = 'LEFT'   then ActiveFormsBar.DockingStyle := dsLeft;
  if St1 = 'RIGHT'  then ActiveFormsBar.DockingStyle := dsRight;
  if St1 = 'BOTTOM' then ActiveFormsBar.DockingStyle := dsBottom;
  if St1 = 'TOP'    then ActiveFormsBar.DockingStyle := dsTop;

  try St1 := ReadINI(Self, 'dxBarManager', 'AnalizDesigncxBarEditItem.EditValue'); if St1 <> '' then AnalizDesigncxBarEditItem.EditValue := St1; except end;
  try St1 := ReadINI(Self, 'dxBarManager', 'SayfaBoyutlaricxBarEditItem.EditValue'); if St1 <> '' then SayfaBoyutlaricxBarEditItem.EditValue := St1; except end;
  try St1 := ReadINI(Self, 'dxBarManager', 'OrientationcxBarEditItem.EditValue'); if St1 <> '' then OrientationcxBarEditItem.EditValue := St1; except end;
  try St1 := ReadINI(Self, 'dxBarManager', 'MinimumSayfaSayisicxBarEditItem.EditValue'); if St1 <> '' then MinimumSayfaSayisicxBarEditItem.EditValue := St1; except end;
  try St1 := ReadINI(Self, 'dxBarManager', 'LeftMarjincxBarEditItem.EditValue'); if St1 <> '' then LeftMarjincxBarEditItem.EditValue := St1; except end;
  try St1 := ReadINI(Self, 'dxBarManager', 'RightMarjincxBarEditItem.EditValue'); if St1 <> '' then RightMarjincxBarEditItem.EditValue := St1; except end;
  try St1 := ReadINI(Self, 'dxBarManager', 'TopMarjincxBarEditItem.EditValue'); if St1 <> '' then TopMarjincxBarEditItem.EditValue := St1; except end;
  try St1 := ReadINI(Self, 'dxBarManager', 'BottomMarjincxBarEditItem.EditValue'); if St1 <> '' then BottomMarjincxBarEditItem.EditValue := St1; except end;
  try St1 := ReadINI(Self, 'dxBarManager', 'DuyarlilikcxBarEditItem.EditValue'); if St1 <> '' then DuyarlilikcxBarEditItem.EditValue := St1; except end;

  ProgressFinish;

  ButceAcTimer.Enabled  := TRUE;
  MainFormTimer.Enabled := TRUE;
end;

procedure TMainForm.KisayollarSubItemPopup(Sender: TObject);
begin
  if Assigned(MainFormUtilitiesForm) then MainFormUtilitiesForm.PencereSubItemPopup(nil);
  SetItemsEnabledAndVisibleAndCaption;

  HideRepeatingItems(Sender, ImageSeperatorEditItem);

  if Sender = GenelSubItem then HideRepeatingItems(Sender, MainFormUtilitiesForm.ImageSeperatorEditItem);
end;

procedure TMainForm.LOGAktifCheckGroupItemChange(Sender: TObject);
begin
  SetItemsEnabledAndVisibleAndCaption;
end;

procedure TMainForm.LOGTabloKayitlariniSilItemClick(Sender: TObject);
var
  I: Integer;
  I64: Int64;
  aSQLText, aTableName: string;
begin
  if not CurrentUser.Administrator or not CurrentUser.DatabaseLogging then Exit;

  if Mc(Lang('LOG tablo kayıtlarını silmek istediğinize emin misiniz?', 'Are you sure to empty LOG tables?')) <> mrYes then Exit;

  ClearAllStringLists(MainFormStringLists);
  try
    ProgressStartAsWaitMessage(Lang('LOG tabloları tespit ediliyor...', 'Determining LOG tables...'));
    try
      GetTableNames(MainFormStringLists[0], ApplicationSchemaName, MainConnection);

      for I := MainFormStringLists[0].Count - 1 downto 0 do
        if RightStr(MainFormStringLists[0][I], 4) <> ' LOG' then MainFormStringLists[0].Delete(I);
    finally
      ProgressFinish;
    end;

    if MainFormStringLists[0].Count = 0 then MiAbort(Lang('LOG tablosu mevcut değil.', 'No LOG table.'));

    ProgressStartAsExtra(Lang('Kayıt olan LOG tabloları tespit ediliyor...', 'Determinig LOG tables having any record...'), '', MainFormStringLists[0].Count, TRUE);
    try
      for I := 0 to MainFormStringLists[0].Count - 1 do
      begin
        aTableName := MainFormStringLists[0][I];

        if ProgressCanceled(1, 1, '', '"' + aTableName + '"') then Exit;

        I64 := RecordCountOfTable('"' + ApplicationSchemaName + '"."' + aTableName + '"', '', MainConnection);

        if I64 > 0 then MainFormStringLists[1].Add(aTableName + TAB + IntToStr(I64));
      end;
    finally
      ProgressFinish;
    end;

    MainFormStringLists[0].Clear;

    if MainFormStringLists[1].Count = 0 then MiAbort(Lang('LOG tablolarından kayıt olan mevcut değil.', 'No LOG table having any record.'));

    if not SelectFromSourceTargetcxGrid(Lang('LOG tablolarını belirleyiniz', 'Select LOG tables'), '', '',
                                        [Lang('Tablo Adı', 'Table Name'), Lang('Kayıt Sayısı', 'Record Count')],
                                        ['String', 'Float'],
                                        [],
                                        [FALSE, TRUE],
                                        [],
                                        MainFormStringLists[1], MainFormStringLists[0], TRUE, 0, 0, FALSE) then Exit;

    ProgressStartAsExtra(Lang('LOG tablo kayıtları siliniyor...', 'Emtying LOG tables...'), '', MainFormStringLists[0].Count, TRUE);
    try
      for I := 0 to MainFormStringLists[0].Count - 1 do
      begin
        aTableName := LeftStr(MainFormStringLists[0][I], System.Pos(TAB, MainFormStringLists[0][I]) - 1);

        if ProgressCanceled(1, 1, '', '"' + aTableName + '"') then Exit;

        I64 := RecordCountOfTable('"' + ApplicationSchemaName + '"."' + aTableName + '"', '', MainConnection);

        if I64 = 0 then
          MainFormStringLists[2].Add(aTableName)
        else
        begin
          aSQLText := 'TRUNCATE TABLE "' + ApplicationSchemaName + '"."' + aTableName + '";' + LB +
                      'EXECUTE "' + ApplicationSchemaName + '"."PR ' + ApplicationSchemaName + ' Event, Append" ''"' + ApplicationSchemaName + '"."' + aTableName + '" tablo kayıtları silindi (' + FormatInt(I64) + ' kayıt).'';';
          ExecSQL(aSQLText, '', MainConnection);
        end;
      end;
    finally
      ProgressFinish;
    end;

    if MainFormStringLists[2].Count > 0 then Mw(Lang('Şu tabloların bu esnada kayıtları sıfırlanmış:', 'Those table records are already deleted:') + LB2 + MainFormStringLists[2].Text);
  finally
    ClearAllStringLists(MainFormStringLists);
  end;
end;

procedure TMainForm.MesajLOGTablosunuGosterItemClick(Sender: TObject);
begin
  VeriGirisi(Sender, MainFormUtilitiesForm.MainLogVirtualTable, Lang('Mesaj LOG Tablosu', 'Message LOG Table'), 'Message Log Table ID', FALSE);
end;

procedure TMainForm.MesajLOGTablosunuKaydetItemClick(Sender: TObject);
var
  aTableFileName: string;
begin
  aTableFileName := ReadINI(Sender, 'TableFileName');
  if not MySaveDialog(Lang('Kaydet (Tablo)...', 'Save (Table)...'), 'VTD', [Lang('Tablo-XML Dosyaları (*.VTD;*.XML)', 'Table-XML Files (*.VTD;*.XML)'), Lang('Tablo Dosyaları (*.VTD)', 'Table Files (*.VTD)'), Lang('XML Dosyaları (*.XML)', 'XML Files (*.XML)'), Lang('Tüm Dosyalar (*.*)', 'All Files (*.*)')], ['*.VTD;*.XML', '*.VTD', '*.XML', '*.*'], aTableFileName) then Exit;
  WriteINI(Sender, 'TableFileName', aTableFileName);

  ProgressStartAsWaitMessage(Lang('Mesaj LOG tablosu kaydediliyor...', 'Message LOG table is being saved...') + LB2 + '"' + aTableFileName + '"');
  try
    if AnsiUpperCase(MyExtractFileExtWithoutDot(aTableFileName)) = 'XML' then
      MainFormUtilitiesForm.MainLogVirtualTable.SaveToXML(aTableFileName)
    else
      MainFormUtilitiesForm.MainLogVirtualTable.SaveToFile(aTableFileName);
  finally
    ProgressFinish;
  end;
end;

procedure TMainForm.SQLLOGTablosunuGosterItemClick(Sender: TObject);
begin
  VeriGirisi(Sender, DatabasesForm.MainSQLLogVirtualTable, Lang('SQL LOG Tablosu', 'SQL LOG Table'), 'SQL Log Table ID', FALSE);
end;

procedure TMainForm.SQLLOGTablosunuKaydetItemClick(Sender: TObject);
var
  aTableFileName: string;
begin
  aTableFileName := ReadINI(Sender, 'TableFileName');
  if not MySaveDialog(Lang('Kaydet (Tablo)...', 'Save (Table)...'), 'VTD', [Lang('Tablo-XML Dosyaları (*.VTD;*.XML)', 'Table-XML Files (*.VTD;*.XML)'), Lang('Tablo Dosyaları (*.VTD)', 'Table Files (*.VTD)'), Lang('XML Dosyaları (*.XML)', 'XML Files (*.XML)'), Lang('Tüm Dosyalar (*.*)', 'All Files (*.*)')], ['*.VTD;*.XML', '*.VTD', '*.XML', '*.*'], aTableFileName) then Exit;
  WriteINI(Sender, 'TableFileName', aTableFileName);

  ProgressStartAsWaitMessage(Lang('SQL LOG tablosu kaydediliyor...', 'SQL LOG table is being saved...') + LB2 + '"' + aTableFileName + '"');
  try
    if AnsiUpperCase(MyExtractFileExtWithoutDot(aTableFileName)) = 'XML' then
      DatabasesForm.MainSQLLogVirtualTable.SaveToXML(aTableFileName)
    else
      DatabasesForm.MainSQLLogVirtualTable.SaveToFile(aTableFileName);
  finally
    ProgressFinish;
  end;
end;

procedure TMainForm.UniConnectionForProgrammerBeforeConnect(Sender: TObject);
begin
  if UniConnectionForProgrammer.Server <> '' then Exit;

  UniConnectionForProgrammer.ProviderName    := UniConnectionForProgram.ProviderName;
  UniConnectionForProgrammer.Server          := UniConnectionForProgram.Server;
  UniConnectionForProgrammer.Username        := UniConnectionForProgram.Username;
  UniConnectionForProgrammer.Password        := UniConnectionForProgram.Password;
  UniConnectionForProgrammer.Port            := UniConnectionForProgram.Port;
  UniConnectionForProgrammer.SpecificOptions := UniConnectionForProgram.SpecificOptions;
end;

procedure TMainForm.WordAnalizBtnClick(Sender: TObject);
begin
  //DoWordAnaliz;
  DoRichEditControlWord(TComponent(Sender).Tag, VarToStr(AnalizDesigncxBarEditItem.EditValue) + DupeString('00', 10));
end;

procedure TMainForm.FormArkaRengiColorComboBoxEditItemChange(Sender: TObject);
begin
  SetFormArkaRengiItemsEnabledAndVisibleAndCaption;
end;

procedure TMainForm.FormArkaResmiBelirleItemClick(Sender: TObject);
var
  aFileName: string;
begin
  aFileName := ReadINI(Self, 'Form Background', 'FileName');
  if not MyOpenDialog(Lang('Resim Belirleyiniz...', 'Select Picture...'), 'BMP', [Lang('Resim Dosyaları (*.BMP;*.JPG;*.JPEG)', 'Picture Files (*.BMP;*.JPG;*.JPEG)'), Lang('Tüm Dosyalar (*.*)', 'All Files (*.*)')], ['*.BMP;*.JPG;*.JPEG', '*.*'], aFileName, FALSE) then Exit;

  try
    SetScreenCursor(crHourGlass);

    BackgroundImage.Picture.LoadFromFile(aFileName);
  finally
    SetScreenCursor(crDefault);
  end;

  WriteINI(Self, 'Form Background', 'FileName', aFileName);

  FormArkaResminiIptalEtItem.Enabled := TRUE;
  FormArkaResminiKaydetItem.Enabled  := TRUE;

  SetFormArkaRengiItemsEnabledAndVisibleAndCaption;
end;

procedure TMainForm.FormArkaResminiIptalEtItemClick(Sender: TObject);
begin
  if Mc(Lang('Form arka resmini iptal etmek istediğinize emin misiniz?', 'Are you sure to remove background picture?')) <> mrYes then Exit;

  BackgroundImage.Picture            := nil;
  FormArkaResminiIptalEtItem.Enabled := FALSE;
  FormArkaResminiKaydetItem.Enabled  := FALSE;

  WriteINI(Self, 'Form Background', 'FileName', '');

  SetFormArkaRengiItemsEnabledAndVisibleAndCaption;
end;

procedure TMainForm.FormArkaResminiKaydetItemClick(Sender: TObject);
var
  aFileName: string;
begin
  aFileName := ReadINI(Self, 'Form Background', 'FileName');
  if not MySaveDialog(Lang('Resmi Kaydet...', 'Save Picture...'), MyCoalesce([MyExtractFileExtWithoutDot(aFileName), 'BMP']), [Lang('Resim Dosyaları (*.BMP;*.JPG;*.JPEG)', 'Picture Files (*.BMP;*.JPG;*.JPEG)'), Lang('Tüm Dosyalar (*.*)', 'All Files (*.*)')], ['*.BMP;*.JPG;*.JPEG', '*.*'], aFileName) then Exit;

  try
    SetScreenCursor(crHourGlass);

    BackgroundImage.Picture.SaveToFile(aFileName);
  finally
    SetScreenCursor(crDefault);
  end;

  SetFormArkaRengiItemsEnabledAndVisibleAndCaption;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  St1, St2: string;
begin
  CanClose := FALSE;

  CloseAllChildFormsOfAForm(Self, TRUE);

  CloseAllChildFormsOfAComponentHavingOnCloseOrOnCloseQueryEvent(Application, TRUE, [Self]);

  if ApplicationStartedWithoutAnyProblem then
  begin
    case dxBarManagerMenuBar.DockingStyle of
      dsLeft   : St1 := 'LEFT';
      dsRight  : St1 := 'RIGHT';
      dsBottom : St1 := 'BOTTOM';
    else
      St1 := 'TOP';
    end;

    case ActiveFormsBar.DockingStyle of
      dsLeft   : St2 := 'LEFT';
      dsRight  : St2 := 'RIGHT';
      dsBottom : St2 := 'BOTTOM';
    else
      St2 := 'TOP';
    end;

    WriteINI(Self, 'dxBarManager', ['dxBarManagerMenuBar.DockingStyle', 'ActiveFormsBar.DockingStyle'], [St1, St2]);

    SavedxBarItemLinksToFile(Self, MainFormUtilitiesForm.SonYapilanIslemlerSubItem, TheProgramLOGPath + 'LastClickedItems.LOG');
    SaveFormBoundsToINI('Main Form Bounds', Self);

    WriteINI(Self, 'dxBarManager', 'AnalizDesigncxBarEditItem.EditValue', VarToStr(AnalizDesigncxBarEditItem.EditValue));
    WriteINI(Self, 'dxBarManager', 'SayfaBoyutlaricxBarEditItem.EditValue', VarToStr(SayfaBoyutlaricxBarEditItem.EditValue));
    WriteINI(Self, 'dxBarManager', 'OrientationcxBarEditItem.EditValue', VarToStr(OrientationcxBarEditItem.EditValue));
    WriteINI(Self, 'dxBarManager', 'MinimumSayfaSayisicxBarEditItem.EditValue', VarToStr(MinimumSayfaSayisicxBarEditItem.EditValue));
    WriteINI(Self, 'dxBarManager', 'LeftMarjincxBarEditItem.EditValue', VarToStr(LeftMarjincxBarEditItem.EditValue));
    WriteINI(Self, 'dxBarManager', 'RightMarjincxBarEditItem.EditValue', VarToStr(RightMarjincxBarEditItem.EditValue));
    WriteINI(Self, 'dxBarManager', 'TopMarjincxBarEditItem.EditValue', VarToStr(TopMarjincxBarEditItem.EditValue));
    WriteINI(Self, 'dxBarManager', 'BottomMarjincxBarEditItem.EditValue', VarToStr(BottomMarjincxBarEditItem.EditValue));
    WriteINI(Self, 'dxBarManager', 'DuyarlilikcxBarEditItem.EditValue', VarToStr(DuyarlilikcxBarEditItem.EditValue));
  end;

  UserProgramEntranceFinish;

  CanClose := TRUE;
end;

procedure TMainForm.FormContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
  Handled := TRUE;
  dxBarPopupMenu1.PopupFromCursorPos;
end;

procedure TMainForm.AktifKullaniciSifresiniDegistirItemClick(Sender: TObject);
var
  aSQLText: string;
  aMultiInputQueryItems: array of TMultiInputQueryItemRec;
begin
  ClearAllStringLists(MainFormStringLists);

  case GetDatabaseType(MainConnection) of
    dtSQLServer, dtOracle, dtInterBase: ;
  else
    MwAbort(Lang('Mevcut veritabanının şifresini buradan değiştiremezsiniz.', 'You cannot change current database''s password here.'));
  end;

  try
    SetLength(aMultiInputQueryItems, 3);

    MakeNULLMultiInputQueryItemRecs(aMultiInputQueryItems);

    aMultiInputQueryItems[0].Caption      := Lang('Mevcut Şifreniz', 'Current Password');
    aMultiInputQueryItems[0].ItemType     := miqftString;
    aMultiInputQueryItems[0].MaxLength    := 100;
    aMultiInputQueryItems[0].Required     := TRUE;
    aMultiInputQueryItems[0].IsPassword   := TRUE;
    aMultiInputQueryItems[0].DefaultValue := '';

    aMultiInputQueryItems[1].Caption      := Lang('Yeni Şifreniz', 'New Password');
    aMultiInputQueryItems[1].ItemType     := miqftString;
    aMultiInputQueryItems[1].MaxLength    := 100;
    aMultiInputQueryItems[1].Required     := TRUE;
    aMultiInputQueryItems[1].IsPassword   := TRUE;
    aMultiInputQueryItems[1].DefaultValue := '';

    aMultiInputQueryItems[2].Caption      := Lang('Yeni Şifreniz (Tekrar)', 'New Password (Again)');
    aMultiInputQueryItems[2].ItemType     := miqftString;
    aMultiInputQueryItems[2].MaxLength    := 100;
    aMultiInputQueryItems[2].Required     := TRUE;
    aMultiInputQueryItems[2].IsPassword   := TRUE;
    aMultiInputQueryItems[2].DefaultValue := '';

    SelectionOkayButtonClickEventsSender := GeneralEventSender('Aktif Kullanıcı Şifresini Değiştir');
    try
      if not MyMultiInputQuery(Lang('Yeni Şifrenizi Giriniz...', 'Enter Your New Password...') + ' "' + MainConnection.Username + '"', aMultiInputQueryItems, MainFormStringLists[0]) then Exit;
    finally
      SelectionOkayButtonClickEventsSender := GeneralEventSender;
    end;

    if Mcw(Lang('Şifrenizi değiştirmek istediğinize emin misiniz?', 'Are you sure to change your password?')) <> mrYes then Exit;

    case GetDatabaseType(MainConnection) of
      dtSQLServer : aSQLText := 'ALTER LOGIN [' + MainConnection.Username + '] WITH PASSWORD = ''' + MyAnsiReplaceStr(MainFormStringLists[0][1], '''', '''''') + '''';
      dtOracle    : aSQLText := 'ALTER USER '   + MainConnection.Username + ' IDENTIFIED BY '      + MainFormStringLists[0][1];
      dtInterBase : aSQLText := 'ALTER USER "'  + MainConnection.Username + '" SET PASSWORD '''    + MyAnsiReplaceStr(MainFormStringLists[0][1], '''', '''''') + '''';
    else
      aSQLText := '';
    end;

    Inc(MainSQLLogging.PausedCount);
    try
      ExecSQL(aSQLText, Lang('Şifreniz değiştiriliyor...', 'Password is being changed...'), MainConnection);
      aSQLText := 'EXECUTE "' + ApplicationSchemaName + '"."PR ' + ApplicationSchemaName + ' Event, Append" ''Şifre bilgisi değiştirildi.''';
      ExecSQL(aSQLText, Lang('Şifreniz değiştirildi bilgisi kaydediliyor...', 'Saving the password change information...'), MainConnection);
    finally
      Dec(MainSQLLogging.PausedCount);
    end;

    CurrentUser.Password := MainFormStringLists[0][1];

    Mi(Lang('Şifreniz değiştirildi.', 'Your password is changed.'));
  finally
    ClearAllStringLists(MainFormStringLists);
  end;
end;

procedure TMainForm.AktifVeritabaniniDegistirItemClick(Sender: TObject);
var
  I: Integer;
  aUniConnection: TUniConnection;
  aNewAssigned: Boolean;
begin
  aNewAssigned   := FALSE;
  aUniConnection := TUniConnection.Create(Self);
  try
    aUniConnection.Name := 'RunTime_UniConnection_' + GetUniqueInt64AsText;
    aUniConnection.AssignConnect(MainConnection);

    if not GetConnectionInformation(Lang('Aktif Veritabanı Bilgilerini Giriniz...', 'Enter Current Database Information...'), Self, 'Current Database', aUniConnection, FALSE, [], MainConnectionControlFunction) then Exit;

    if (aUniConnection.ProviderName = MainConnection.ProviderName) and
       (aUniConnection.Username     = MainConnection.Username)     and
       (aUniConnection.Password     = CurrentUser.Password)        and
       (aUniConnection.Server       = MainConnection.Server)       and
       (aUniConnection.Port         = MainConnection.Port)         and
       (aUniConnection.Database     = MainConnection.Database)     then MwAbort(Lang('Mevcut aktif veritabanını seçtiniz.', 'You have selected current database.'));

    try
      for I := 0 to ComponentCount - 1 do
        if (Components[I] is TUniConnection) and (Components[I] <> aUniConnection) and (Components[I] <> UserConnection) and (Components[I] <> TheProgrammersConnection) then
          if (aUniConnection.ProviderName = TUniConnection(Components[I]).ProviderName) and
             (aUniConnection.Username     = TUniConnection(Components[I]).Username)     and
             (aUniConnection.Password     = TUniConnection(Components[I]).Password)     and
             (aUniConnection.Server       = TUniConnection(Components[I]).Server)       and
             (aUniConnection.Port         = TUniConnection(Components[I]).Port)         and
             (aUniConnection.Database     = TUniConnection(Components[I]).Database)     then
          begin
            MainConnection       := TUniConnection(Components[I]);
            CurrentUser.Password := MainConnection.Password;
            Exit;
          end;

      MainConnection := aUniConnection;
      aNewAssigned   := TRUE;
    finally
      ClearAllTableInformationsAndOthers(TRUE);
      UserProgramEntranceStart;
      ButceAcItemClick(nil);
    end;
  finally
    if not aNewAssigned then FreeAndNil(aUniConnection);
    MainSchemaName := IfThen(AnsiUpperCase(MainConnection.ProviderName) = 'SQL SERVER', 'dbo', '');
  end;
end;

procedure TMainForm.AktifVeritabaniniKucultShrinkItemClick(Sender: TObject);
begin
  if not CurrentUser.Administrator or (GetDatabaseType(MainConnection) <> dtSQLServer) then Exit;

  if Mc(Lang('Aktif veritabanını küçültmek (shrink) istediğinize emin misiniz?', 'Are you sure to shrink current database?')) <> mrYes then Exit;

  ProgressStartAsWaitMessage(Lang('Aktif veritabanı küçültülüyor (shrink)...', 'Shrinking current database...'));
  try
    ExecSQL('DBCC SHRINKDATABASE ("' + MainConnection.Database + '")', '', MainConnection);
  finally
    ProgressFinish;
  end;
end;

procedure TMainForm.CloseItemClick(Sender: TObject);
begin
  if ShiftAndCtrlKeysAreBeingPressed then
    FinishTheProgram
  else
    Close;
end;

procedure TMainForm.CloseProgrammersBarItemClick(Sender: TObject);
begin
  ProgrammersBar.Visible := FALSE;
end;

procedure TMainForm.CurrentFormAndCountOfFormsItemClick(Sender: TObject);
var
  I, aLength: Integer;
  St1, aMessage, aLine, aSpecialID: string;
  D1, D2: TDateTime;
  aFileInformation: TFileInformation;
begin
  D1    := Now;
  aLine := DupeString('-', 75);

  aMessage := LB + Lang('Aktif Kullanıcı           : "', 'Current User                : "') + MyCoalesce([MainConnection.Username, CurrentUser.Name]) + '", "';

  if AktifButce.BaslangicAyi <> '' then aMessage := aMessage + AktifButce.BaslangicYili + '.' + FormatFloat('00', StrToInt(AktifButce.BaslangicAyi)) + ' - ' + AktifButce.BitisYili + '.12';
  aMessage := aMessage + '"';

  if GetFileInformation(Application.ExeName, aFileInformation) then
  begin
    D2 := D1 - aFileInformation.LastWriteTime;
    if D2 < 0 then D2 := 0;

    aMessage := aMessage + LB +
                aLine    + LB +
                Lang('Program Dosya Adresi      : "', 'Application File Name       : "') + Application.ExeName + '"'                                                   + LB +
                Lang('Program Dosyası Büyüklüğü : "', 'Application File Size       : "') + FormatInt(aFileInformation.Size) + ' Bytes."'                               + LB +
                Lang('Şimdiki Tarih             : "', 'Current Time                : "') + FormatDateTime('dd.mm.yyyy hh:nn:ss', D1) + '"'                             + LB +
                Lang('Program Dosyası Tarihi    : "', 'Application File Time       : "') + FormatDateTime('dd.mm.yyyy hh:nn:ss', aFileInformation.LastWriteTime) + '"' + LB +
                Lang('Program Tarih Geçen Süre  : "', 'Application File Elapsed    : "') + TimeToStrWithMoreThan24Hours(D2, 0, TRUE) + '"' + LB;
  end;

  aMessage := aMessage + aSpecialID;

  with TStringList.Create do
  try
    Text := aMessage;

    aLength := 0;
    for I := 0 to Count - 1 do
      if Strings[I] <> aLine then
        if Length(Strings[I]) > aLength then aLength := Length(Strings[I]);

    if aLength > Length(aLine) then
    begin
      St1 := DupeString('-', aLength);
      for I := 0 to Count - 1 do
        if Strings[I] = aLine then Strings[I] := St1;
    end;

    for I := 0 to Count - 1 do Strings[I] := '  ' + Strings[I];

    aMessage := Text;
  finally
    Free;
  end;

  if not ShiftOrCtrlKeyIsBeingPressed then
    for I := 0 to Self.MDIChildCount - 1 do
      if Self.MDIChildren[I] is TTextRichEditorForm then
        with TTextRichEditorForm(Self.MDIChildren[I]) do
          if SpecialID = aSpecialID then
          begin
            Editor.Text := aMessage;

            if Self.MDIChildren[I].WindowState = wsMinimized then
              Self.MDIChildren[I].WindowState := wsNormal
            else
              Self.MDIChildren[I].BringToFront;

            Exit;
          end;

  ShowInTextEditorByScreenWidthHeightPercentMain(Self, Self.Caption, aMessage, 70, 50, '', 'Courier New', 10, TRUE).SpecialID := aSpecialID;
end;

procedure TMainForm.ButceAcItemClick(Sender: TObject);
var
  aCaption, aButceAcINIText, aButceID: string;
begin
  aButceAcINIText := MyEncodeText(MainConnection.ProviderName + TAB + MainConnection.Database + TAB + MyCoalesce([MainConnection.Username, CurrentUser.Name]));

  if not Assigned(Sender) then
  begin
    aButceID := ReadINI(Self, 'Bütçe Aç', aButceAcINIText);

    if IsInteger(aButceID) then
    begin
      ClearAllTableInformationsAndOthers(TRUE);

      AktifButce.ButceID := aButceID;

      GetOtherButceSirketDonemInformationsOfAktifButce;

      SetItemsEnabledAndVisibleAndCaption;

      if AktifButce.ButceID <> '' then Exit;
    end;
  end;

  aCaption := GetCaption(ButceAcItem);

  with TVeriGirisiForm.Create(nil, aCaption, ButceAcItem, '') do
  try
    MainForm.FreeMainFormOnClose := FALSE;

    ActivateDataSet(DataSet(GetAndSetTable('Bütçe', aCaption, '', TRUE, '', TRUE), '', TRUE));

    if DataSets(0).RecordCount = 0 then
    begin
      Mw(Lang('Tanımlı bütçe yok.', 'No defined budget.'));
      ClearAktifButceInformations;
      Exit;
    end;

    if AktifButce.ButceID <> '' then
      if DataSets(0).FindField('Bütçe ID').AsString <> AktifButce.ButceID then
      begin
        DataSets(0).Last;

        while not DataSets(0).Bof do
        begin
          if DataSets(0).FindField('Bütçe ID').AsString = AktifButce.ButceID then Break;

          DataSets(0).Prior;
        end;
      end;

    Grid(0, '', 'Confirmation=TRUE' + LB +
                'Confirmation.DoubleClick=TRUE' + LB +
                'Confirmation.SelectOneRow=TRUE' + LB +
                'ConstantMessage=' + Lang('Bütçeyi Seçip "Tamam" Tuşuna Basınız...', 'Select The Budget And Then Press "Okay" Button...'));

    MainForm.TheINIFileName := 'ButceAc.INI';
    MainForm.cxGridForms[0].TheINIFileName := 'ButceAc.Butce.INI';

    CreateForm(Forms(0));

    if ShowForm(FALSE, 'RememberLastRecNos=FALSE') = mrOK then
    begin
      ClearAllTableInformationsAndOthers(TRUE);

      AktifButce.ButceID := DataSets(0).FindField('Bütçe ID').AsString;

      GetOtherButceSirketDonemInformationsOfAktifButce;

      WriteINI(Self, 'Bütçe Aç', aButceAcINIText, AktifButce.ButceID);
    end;
  finally
    FreeAndNil(MainForm);
    Free;
    SetItemsEnabledAndVisibleAndCaption;
  end;
end;

procedure TMainForm.ButceAcTimerTimer(Sender: TObject);
begin
  ButceAcTimer.Enabled := FALSE;
  //ButceAcItemClick(nil);
end;

procedure TMainForm.ProgramGirisTabloKayitlariniSilItemClick(Sender: TObject);
var
  I64: Int64;
  aSQLText: string;
begin
  if not CurrentUser.Administrator then Exit;

  if Mc(Lang('"Program Giriş" tablo kayıtlarını silmek istediğinize emin misiniz?', 'Are you sure to empty "Program Entrance" table?')) <> mrYes then Exit;

  I64 := RecordCountOfTable('"' + ApplicationSchemaName + '"."Program Girişi Detay"', '', MainConnection);

  if I64 = 0 then MwAbort(Lang('Tabloda hiç kayıt yok.', 'No record in the table.'));

  aSQLText := 'TRUNCATE TABLE "' + ApplicationSchemaName + '"."Program Girişi Detay";' + LB +
  'EXECUTE "' + ApplicationSchemaName + '"."PR ' + ApplicationSchemaName + ' Event, Append" ''"' + ApplicationSchemaName + '"."Program Girişi Detay" tablo kayıtları silindi (' + FormatInt(I64) + ' kayıt).'';';
  ExecSQL(aSQLText, '', MainConnection);
end;

procedure TMainForm.TabloAcBtnClick(Sender: TObject);
begin
  TabloIslemleriForm.LokalTabloAcItem.Click;
end;

procedure TMainForm.ProgramHakkindaBtnClick(Sender: TObject);
begin
  MyShowAboutForm;
end;

procedure TMainForm.SnortLogToTableBtnClick(Sender: TObject);
begin
  DoSnortLogToTable;
end;

procedure TMainForm.dxBarButton2Click(Sender: TObject);
var
  aVirtualTableEx: TVirtualTableEx;
begin
  aVirtualTableEx := GetTEZAnalizTable;

  if not Assigned(aVirtualTableEx) then Exit;

  aVirtualTableEx.FindField('Hata Var').Visible    := FALSE;
  aVirtualTableEx.FindField('Hata Mesajı').Visible := FALSE;

  if Assigned(DatabasesForm) then AssignStandartDataSetsEventsFromDataSetToDataSet(DatabasesForm.MainUniQuery, aVirtualTableEx);
  VeriGirisi(nil, aVirtualTableEx, aVirtualTableEx.Caption, '', TRUE);
end;

procedure TMainForm.dxBarButton4Click(Sender: TObject);
begin
  TheLokalTabloDefaultFolder := GetTEZSonucTablolarFolder;
  try
    TabloIslemleriForm.LokalTabloAcItem.Click;
  finally
    TheLokalTabloDefaultFolder := '';
  end;
end;

procedure TMainForm.dxBarManagerClickItem(Sender: TdxBarManager; ClickedItem: TdxBarItem);
begin
  if (ClickedItem = CloseItem) or
     (@ClickedItem.OnClick = @FavoritesFirstItem.OnClick) or
     (ClickedItem = CloseProgrammersBarItem) or
     (ClickedItem = ProgramciyaMesajlariEditordeGosterItem) then Exit;

  AddClickedItemToSonYapilanIslemler(ClickedItem);
end;

var
  LastTimerText: string = '';

procedure TMainForm.dxBarManagerHideCustomizingForm(Sender: TObject);
var
  I: Integer;
  aFileName: string;
  adxBarItems: array of TdxBarItem;
  aBeginGroups: array of Boolean;
begin
  dxBarManager.BeginUpdate;
  try
    SetLength(adxBarItems,  KisayollarSubItem.ItemLinks.Count);
    SetLength(aBeginGroups, KisayollarSubItem.ItemLinks.Count);

    for I := 0 to KisayollarSubItem.ItemLinks.Count - 1 do
    begin
      adxBarItems[I]  := KisayollarSubItem.ItemLinks.Items[I].Item;
      aBeginGroups[I] := KisayollarSubItem.ItemLinks.Items[I].BeginGroup;
    end;

    aFileName := MyGetTempFileName('Customization', 'INI');
    try
      MainFormStringLists[0].SaveToFile(aFileName, TheActiveEncoding);
      dxBarManager.LoadFromIniFile(aFileName);
    except
      on Ex: Exception do Me(ExceptionMessage(Ex));
    end;
    MyDeleteFile(aFileName);

    for I := dxBarManager.Bars.Count - 1 downto StrToInt(MainFormStringLists[1][0]) do dxBarManager.Bars.Delete(I);

    KisayollarSubItem.ItemLinks.Clear;

    for I := 0 to Length(adxBarItems) - 1 do
      with KisayollarSubItem.ItemLinks.Add do
      begin
        Item       := adxBarItems[I];
        BeginGroup := aBeginGroups[I];
      end;

    PencereSubItem.ItemLinks   := MainFormUtilitiesForm.PencereSubItem.ItemLinks;
    PencereSubItem_2.ItemLinks := MainFormUtilitiesForm.PencereSubItem.ItemLinks;
    GenelSubItem.ItemLinks     := MainFormUtilitiesForm.GenelSubItem.ItemLinks;
    ProgramciSubItem.ItemLinks := ProgrammerForm.ProgramciSubItem.ItemLinks;

    SavedxBarItemLinksToFile(Self, KisayollarSubItem, TheProgramLOGPath + 'ShortCuts_MainForm.LOG');

    for I := 1 to Length(FavoritesButtons) - 1 do IfAssignedFreeAndNil(FavoritesButtons[I]);

    SetLength(FavoritesButtons,       1);
    SetLength(FavoritesButtonHandles, 1);
    FavoritesButtons[0]       := FavoritesFirstItem;
    FavoritesButtonHandles[0] := -1;
    LastTimerText             := '';
  finally
    ClearAllStringLists(MainFormStringLists);
    SetdxBarItemVisibleByBoolean(KisayollarSubItem, KisayollarSubItem.ItemLinks.Count > 0);
    SetItemsEnabledAndVisibleAndCaption;
    dxBarManager.EndUpdate;
  end;
end;

procedure TMainForm.dxBarManagerShowCustomizingForm(Sender: TObject);
var
  aFileName: string;
begin
  KisayollarSubItem.Visible := ivAlways;

  Mw(Lang('Kısayol oluşturmak istediğiniz menü öğelerini en başta bulunan "Kısayollar" menüsüne taşıyınız...',
          'Move menu items those you want to define as shortcuts to the first menu "Shortcuts".'));

  ClearAllStringLists(MainFormStringLists);

  MainFormStringLists[1].Add(IntToStr(dxBarManager.Bars.Count));

  aFileName := MyGetTempFileName('Customization', 'INI');
  try
    dxBarManager.SaveToIniFile(aFileName);
    MainFormStringLists[0].LoadFromFile(aFileName);
  except
    on Ex: Exception do Me(ExceptionMessage(Ex));
  end;
  MyDeleteFile(aFileName);
end;

procedure TMainForm.MainFormTimerTimer(Sender: TObject);
var
  I, J, K: Integer;
  I64, aActiveMDIChildHandle: Int64;
  St1, aHint, aAktifButceText: string;
  aActiveFormsBarLocked, aDown: Boolean;
  acxStyle: TcxStyle;
begin
  if MainFormTimer.Tag = 1 then Exit;

  aActiveFormsBarLocked := FALSE;
  try
    MainFormTimer.Tag := 1;

    try
      MakeAllUnAssignedScreenFormsContextPopupsHandled;

      with TStringList.Create do
      try
        St1 := MainFormMainCaption;

        if Self.Caption <> St1 then Self.Caption := St1;

        if AktifButce.ButceID = '' then
          aAktifButceText := '"' + ApplicationSchemaName + '"'
        else
          aAktifButceText := '"' + AktifButce.SirketAdi + ', ' + AktifButce.SirketID + '" - "' + AktifButce.ButceAdi + ', ' + AktifButce.ButceID + '"';

        //if Assigned(MainConnection) then aAktifButceText := '"' + MainConnection.Database + '"';

        aActiveMDIChildHandle := -1;

        for I := 0 to Self.MDIChildCount - 1 do
        begin
          if Self.MDIChildren[I].Active then aActiveMDIChildHandle := Self.ActiveMDIChild.Handle;
          Add(' ' + Self.MDIChildren[I].Caption + ' ' + FormatFloat(DupeString('0', 10), Self.MDIChildren[I].Handle));
        end;

        St1 := Text + LB + IntToStr(aActiveMDIChildHandle) + LB + Self.Caption + LB + aAktifButceText;
        if LastTimerText = St1 then Exit;
        LastTimerText := St1;

        Sort;

        ActiveFormsBar.LockUpdate := TRUE;
        aActiveFormsBarLocked     := TRUE;

        J := Length(FavoritesButtons);
        if J < Count then
        begin
          SetLength(FavoritesButtons,       Count + GetValidSetLengthLength(Count));
          SetLength(FavoritesButtonHandles, Length(FavoritesButtons));
          for I := J to Length(FavoritesButtons) - 1 do
          begin
            FavoritesButtons[I]             := TdxBarButton.Create(Self);
            FavoritesButtons[I].ButtonStyle := bsChecked;
            FavoritesButtons[I].Caption     := '';
            FavoritesButtons[I].OnClick     := FavoritesFirstItemClick;

            with ActiveFormsBar.ItemLinks.Add do
            begin
              BeginGroup := TRUE;
              Item       := FavoritesButtons[I];
            end;

            FavoritesButtonHandles[I] := -1;
          end;
        end;

        if aActiveMDIChildHandle = -1 then
        begin
          if Count = 0 then
            St1 := aAktifButceText
          else
            St1 := aAktifButceText + ' - "' + FormatInt(Count) + '"';

          aHint := LangFromText('Aktif Bilgiler - Toplam Form Sayısı: ||Current Informations - Form Count: ') + IfThen(St1 = '', '0', St1);

          if (CurrentFormAndCountOfFormsItem.Caption <> St1) or (CurrentFormAndCountOfFormsItem.Hint <> aHint) then
          begin
            CurrentFormAndCountOfFormsItem.Caption := St1;
            CurrentFormAndCountOfFormsItem.Hint    := aHint
          end;
        end;

        for I := 0 to Length(FavoritesButtons) - 1 do
        begin
          if Odd(I) then
            if Count > 5 then
              acxStyle := cxStyleNarrowBold8Maroon
            else
              acxStyle := cxStyleBold8Maroon
          else
            if Count > 5 then
              acxStyle := cxStyleNarrowBold8Navy
            else
              acxStyle := cxStyleBold8Navy;

          if FavoritesButtons[I].Style <> acxStyle then FavoritesButtons[I].Style := acxStyle;

          if ((I > Count - 1) and (FavoritesButtons[I].Visible <> ivNever)) or ((I <= Count - 1) and (FavoritesButtons[I].Visible <> ivAlways)) then
            if I > Count - 1 then
              FavoritesButtons[I].Visible := ivNever
            else
              FavoritesButtons[I].Visible := ivAlways;

          if I > Count - 1 then Continue;

          I64 := StrToInt64(RightStr(Strings[I], 10));

          Strings[I] := DeleteFromRight(Strings[I], 10);

          aDown := I64 = aActiveMDIChildHandle;

          if aDown then
          begin
            if not FavoritesButtons[I].Down then FavoritesButtons[I].Down := TRUE;

            St1 := aAktifButceText + ' - "' + FormatInt(I + 1) + '/' + FormatInt(Count) + '"';

            if CurrentFormAndCountOfFormsItem.Caption <> St1 then
            begin
              CurrentFormAndCountOfFormsItem.Caption := St1;
              CurrentFormAndCountOfFormsItem.Hint    := LangFromText('Aktif Bilgiler - Aktif Form İndeksi / Toplam Form Sayısı: ||Current Informations - Current Form Index / Form Count: ') + St1;
            end;
          end
          else
            if FavoritesButtons[I].Down then FavoritesButtons[I].Down := FALSE;

          aHint := Strings[I];

          for K := 0 to Self.MDIChildCount - 1 do
            if Self.MDIChildren[K].Handle = I64 then
            begin
              if Self.MDIChildren[K] is TForms_MainForm then
                for J := 0 to Length(TForms_MainForm(Self.MDIChildren[K]).DataSetInformations) - 1 do
                  if TForms_MainForm(Self.MDIChildren[K]).DataSetInformations[J].DataSet is TUniQueryEx then
                    if Assigned(TUniQueryEx(TForms_MainForm(Self.MDIChildren[K]).DataSetInformations[J].DataSet).Connection) then
                    begin
                      aHint := Trim(Strings[I]) + LB2 + GetConnectionMainInfo(TUniQueryEx(TForms_MainForm(Self.MDIChildren[K]).DataSetInformations[J].DataSet).Connection);
                      Break;
                    end;
              Break;
            end;

          if (FavoritesButtons[I].Caption <> Strings[I]) or (FavoritesButtons[I].Hint <> aHint) or (FavoritesButtonHandles[I] <> I64) or (FavoritesButtons[I].Down <> aDown) then
          begin
            FavoritesButtons[I].Caption := Strings[I];
            FavoritesButtons[I].Hint    := aHint;
            FavoritesButtonHandles[I]   := I64;
            FavoritesButtons[I].Down    := aDown;
          end;
        end;

        //if (Count > 0) and not ActiveFormsBar.Visible  then ActiveFormsBar.Visible := TRUE;
        //if (Count = 0) and ActiveFormsBar.Visible      then ActiveFormsBar.Visible := FALSE;
      finally
        Free;
      end;
    except
      on Ex: Exception do Me('TForm1.Timer1Timer...' + LB2 + ExceptionMessage(Ex));
    end;
  finally
    if aActiveFormsBarLocked then ActiveFormsBar.LockUpdate := FALSE;
    MainFormTimer.Tag := 0;
  end;
end;

procedure TMainForm.ProgramciyaMesajlariEditordeGosterItemClick(Sender: TObject);
begin
  SIT(ProgrammerMessagesList.Text, 'Programcıya Mesajlar...');
end;

procedure TMainForm.FavoritesFirstItemClick(Sender: TObject);
var
 I, J: Integer;
begin
  MainFormTimer.Enabled := FALSE;
  try
    LastTimerText := '';

    TdxBarButton(Sender).Down := TRUE;

    for I := 0 to Length(FavoritesButtons) - 1 do
      if FavoritesButtons[I] = Sender then
      begin
        for J := 0 to Self.MDIChildCount - 1 do
          if (FavoritesButtons[I].Caption = ' ' + Self.MDIChildren[J].Caption + ' ') and (FavoritesButtonHandles[I] = Self.MDIChildren[J].Handle) then
          begin
            if ShiftOrCtrlKeyIsBeingPressed then
            begin
              MainFormTimer.Enabled := TRUE;
              Mi(Trim(TdxBarButton(Sender).Hint));
            end
            else
              if (Self.MDIChildren[J] = Self.ActiveMDIChild) and (Self.MDIChildren[J].WindowState <> wsMinimized) then
                Self.MDIChildren[J].WindowState := wsMinimized
              else
                if Self.MDIChildren[J].WindowState = wsMinimized then
                  Self.MDIChildren[J].WindowState := wsNormal
                else
                  Self.MDIChildren[J].BringToFront;

            Exit;
          end;

        Exit;
      end;
  finally
    MainFormTimer.Enabled := TRUE;
  end;
end;

end.


Ocak
Şubat
Mart
Nisan
Mayıs
Haziran
Temmuz
Ağustos
Eylül
Ekim
Kasım
Aralık


OCAK
SUBAT
MART
NISAN
MAYIS
HAZIRAN
TEMMUZ
AGUSTOS
EYLUL
EKIM
KASIM
ARALIK



[Window Title]
Error

[Content]
Programcıya Mesaj... "function MyDecodeText(const aText: string): string;"

No mapping for the Unicode character exists in the target multi-byte code page

54006800650045006B00730074007200610047006F00730074006500720069006C006500630065006B0041006C0061006E006C0061007200490044004C006900730074003D000D000A00530068006F00770041006B00740069006600480075006300720065005600650045006B00730074007200610041006C0061006E006C006100720042006100720043006800650063006B00470072006F00750070004900740065006D002E004500640069007400560061006C00750065003D003100

[OK]
































Characters
Comments
ContentControls
Endnotes
Fields
FormFields
Frames
GrammaticalErrors
HTMLDivisions
Hyperlinks
Indexes
InlineShapes
ListParagraphs
Lists
Paragraphs
Revisions
Sections
Sentences
Shapes
SmartTags
SpellingErrors
StoryRanges
Subdocuments
Tables
TablesOfAuthorities
TablesOfContents
TablesOfFigures
Words
XMLNodes

