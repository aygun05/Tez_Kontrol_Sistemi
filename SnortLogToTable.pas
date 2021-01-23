unit SnortLogToTable;

interface

uses
  System.Zip, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore, cxTextEdit, cxMemo,
  StrUtils, cxRichEdit, Data.DB, MemDS, VirtualTable, Xml.xmldom, Xml.XMLIntf, Vcl.ExtCtrls, Vcl.Grids,
  Vcl.ValEdit, Xml.XMLDoc, dxRibbonSkins, dxRichEdit.DocumentModel.PieceTable,
  dxRichEdit.DocumentModel.Core, dxRichEdit.View.Core, dxRichEdit.Platform.Font, M_F_Databases;

type
  TSnortLogToTableForm = class(TForm)
    SnortLogVirtualTable: TVirtualTable;
    SnortLogVirtualTableSIRA_NO: TIntegerField;
    SnortLogVirtualTableS_ID: TStringField;
    SnortLogVirtualTableDESCRIPTION: TStringField;
    SnortLogVirtualTableCLASSIFICATION: TStringField;
    SnortLogVirtualTablePRIORITY: TIntegerField;
    SnortLogVirtualTableTIMESTAMP: TStringField;
    SnortLogVirtualTableSOURCE_IP: TStringField;
    SnortLogVirtualTableSOURCE_PORT: TIntegerField;
    SnortLogVirtualTableDESTINATION_IP: TStringField;
    SnortLogVirtualTableDESTINATION_PORT: TIntegerField;
    SnortLogVirtualTablePROTOCOL: TStringField;
    SnortLogVirtualTableTTL: TIntegerField;
    SnortLogVirtualTableTOS: TStringField;
    SnortLogVirtualTableID: TIntegerField;
    SnortLogVirtualTableIPLEN: TIntegerField;
    SnortLogVirtualTableDGMLEN: TStringField;
    Button1: TButton;
    XMLDocument1: TXMLDocument;
    XMLDocument2: TXMLDocument;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type
  TPageAnalizDesignInfo = record
    PageWidth      : Double;
    PageHeight     : Double;
    LayOutPortrait : Boolean;
    LeftMargin     : Double;
    RightMargin    : Double;
    TopMargin      : Double;
    BottomMargin   : Double;
    MinPageCount   : Integer;
    Duyarlilik     : Double;
  end;

procedure DoSnortLogToTable;

procedure DoWordAnaliz;

function GetTEZSonucTablolarFolder: string;

procedure DoRichEditControlWord(const aTag: Integer; aAnalizDesignInfo: string);

function GetTEZAnalizTable: TVirtualTableEx;

var
  SnortLogToTableForm: TSnortLogToTableForm;

implementation

{$R *.dfm}

uses
  M_Consts,
  M_Strings,
  M_Windows,
  M_F_Languages,
  M_Databases,
  M_INIFiles,
  M_F_Calculator,
  M_Maths,
  M_Files,
  M_Dialogs,
  M_DevExpress,
  M_DateTimes,
  M_Messages,
  M_F_Progress,
  M_Applications,
  M_F_FormUtilities,
  M_F_SelectFromSourceTargetcxGrid,
  M_KeyBoards,
  M_cxGrid,
  M_F_Selections,
  M_F_Forms_cxGridSpecialFiltering,
  M_F_TextRichEditor,
  M_F_OleContainer,
  M_F_ExcelEditor,
  M_StartupInfos,
  M_F_Forms_Main,
  M_DatabasesMetaData,
  M_F_SelectFilter,
  M_StringLists,
  M_F_Database_Dialog,
  M_F_Forms_cxGridMain,
  RibbonRichEditMainForm,
  Main;

var
  ThePagesRangeStarts: array of record
                                  Start      : Integer;
                                  OrdinalPage: Integer;
                                end;

  The72InchToCmConst: Double = 28.3464; // 72 x 0.39370

function GetTEZSonucTablolarFolder: string;
begin
  Result := TheProgramMAINPath + 'TEZ Rapor\';
  MyForceDirectories(Result);
end;

function GetTEZAnalizTable: TVirtualTableEx;
var
  aFileName, aPreFileName: string;
begin
  aFileName    := TheProgramMAINPath + 'TEZ Analiz Kontrol Dosyasi.VTD';
  aPreFileName := TheProgramMAINPath + 'TEZ Analiz Kontrol Dosyasi PRE.VTD';

  Result := nil;

  if FileExists(aFileName) then
  try
    Result := TVirtualTableEx.CreateEx(GetOwnerIfAssignedDatabasesFormElseNil, 'TEZ Analiz Kontrol Dosyasý');
    Result.LoadFromFileEx(aFileName, '"TEZ Analiz Kontrol Dosyasý" yükleniyor...', FALSE);

    Result.AutoSaveFileName := aFileName;
    Result.IndexFieldNames  := '"Sýra No"';

    if Assigned(Result.FindField('Sabit Sayfa No')) then
      Exit
    else
    begin
      FreeAndNil(Result);

      MyDeleteFile(aPreFileName);

      MyRenameFile(aFileName, aPreFileName);
    end;
  except
    on Ex: Exception do
    begin
      Me('"' + aFileName + '" dosyasýný açarken bir hata meydana geldi. Hata mesajý:' + LB2 + Ex.Message);
      if Assigned(Result) then FreeAndNil(Result);
    end;
  end;

  if Assigned(Result) then Exit;

  if not CreateVirtualTableEx(Result,
                              'TEZ Analiz Kontrol Dosyasý"',
                              ['Sýra No', 'Aranýlacak Grup', 'Aranacak Metin', 'Sabit Sayfa No', 'Tek Metin', 'Olmak Zorunda', 'Font Name', 'Font Size', 'Font Bold', 'Font Italic', 'Alignment', 'Sayfa Baþýnda', 'Büyülterek Ara', 'Hata Var', 'Hata Mesajý'],
                              [ftInteger, ftString,          ftString,         ftInteger,        ftBoolean,   ftBoolean,       ftString,    ftFloat,     ftBoolean,   ftBoolean,     ftString,    ftBoolean,       ftBoolean,        ftBoolean,  ftString],
                              [0,         25,                50,               0,                0,           0,               30,          0,           0,           0,             10,          0,               0,                0,          100],
                              [TRUE,      FALSE]) then Exit;

  Result.AutoSaveFileName := aFileName;

  Result.IndexFieldNames := '"Sýra No"';
end;

procedure DoSnortLogToTable;
var
  I, P, K1: Integer;
  St1, St2, aSnortLogFileName, aToTableName, aHataStr: string;
  aList1: TStringList;
  aLists: array [0..3] of TStringList;
  aTargetVirtualTableEx: TVirtualTableEx;
  aTabloFormdaAcildi: Boolean;
begin
  //SnortLogVirtualTable.LoadFromFile('E:\AnalizTablosu.VTD');
  //CreateVirtualTableExFromDataSet(aSourceDataSet: TDataSet;

  aSnortLogFileName := ReadINI(SnortLogToTableForm.Button1, 'Aktarýlacak Snort Log Dosyasýný Seçiniz');
  if not MyOpenDialog('Aktarýlacak Snort Log Dosyasýný Seçiniz', '', ['Tüm Dosyalar (*.*)'], ['*.*'], aSnortLogFileName, FALSE) then Exit;
  WriteINI(SnortLogToTableForm.Button1, 'Aktarýlacak Snort Log Dosyasýný Seçiniz', aSnortLogFileName);

  aToTableName := ReadINI(SnortLogToTableForm.Button1, 'Kaydedilecek Tablo Adýný Giriniz veya Seçiniz');
  if not MySaveDialog('Kaydedilecek Tablo Adýný Giriniz veya Seçiniz', 'XML', ['XML Dosyalarý (*.XML)', 'VTD Tablo Dosyalarý (*.VTD)', 'Tüm Dosyalar (*.*)'], ['*.XML', '*.VTD', '*.*'], aToTableName, FALSE) then Exit;
  WriteINI(SnortLogToTableForm.Button1, 'Kaydedilecek Tablo Adýný Giriniz veya Seçiniz', aToTableName);

  aTabloFormdaAcildi := FALSE;

  aList1    := TStringList.Create;
  aLists[0] := TStringList.Create;
  aLists[1] := TStringList.Create;
  aLists[2] := TStringList.Create;
  aLists[3] := TStringList.Create;
  try
    ProgressStartAsWaitMessage('Snort Log Dosyasý yükleniyor...' + LB2 + '"' + aSnortLogFileName + '"');
    try
      aList1.LoadFromFile(aSnortLogFileName);
      aList1.Add('');

      ProgressChangeMessage('Snort Log Dosyasý düzenleniyor...' + LB2 + '"' + aSnortLogFileName + '"', TRUE);

      K1 := 0;

      for I := 0 to aList1.Count - 1 do
      begin
        St1 := Trim(aList1[I]);

        if St1 = '' then
          K1  := 0
        else
        begin
          Inc(K1);

          if K1 < 5 then aLists[K1 - 1].Add(St1);
        end;
      end;

      aList1.Clear;
    finally
      ProgressFinish;
    end;

    if aLists[0].Count = 0 then MwAbort('Snort Log Dosyasýnda bilgi mevcut deðil.' + LB2 + '"' + aSnortLogFileName + '"');

    if (aLists[0].Count <> aLists[1].Count) or
       (aLists[0].Count <> aLists[2].Count) or
       (aLists[0].Count <> aLists[3].Count) then MwAbort('Snort Log Dosyasýndaki satýr sayýlarý tutarsýz.' + LB2 + '"' + aSnortLogFileName + '"');

    if not CreateVirtualTableExFromDataSet(SnortLogToTableForm.SnortLogVirtualTable, aTargetVirtualTableEx, ExtractFileName(aToTableName), [], [], [], []) then Exit;

    ProgressStartAsNormal('Snort Log Dosyasý tabloya aktarýlýyor...' + LB2 + '"' + aSnortLogFileName + '" --> "' + aToTableName + '"', aLists[0].Count, TRUE);
    try
      for I := 0 to aLists[0].Count - 1 do
      begin
        if ProgressCanceled then Exit;

        aHataStr := 'Snort Log Dosyasýndaki bilgiler tutarsýz.' + LB2 + '"' + aSnortLogFileName + '"' + LB2 + 'Sýra No: ' + FormatInt(I + 1) + LB + aLists[0][I] + LB + aLists[1][I] + LB + aLists[2][I] + LB + aLists[3][I];

        aTargetVirtualTableEx.Append;
        aTargetVirtualTableEx.FindField('SIRA_NO').AsInteger := I + 1;


        //[**] [1:527:8] BAD-TRAFFIC same SRC/DST [**]
        //S_ID	   DESCRIPTION
        //1:527:8	BAD-TRAFFIC same SRC/DST

        St1 := aLists[0][I];

        if (LeftStr(St1, 5) <> '[**] ') or (RightStr(St1, 5) <> ' [**]') then MwAbort(aHataStr);

        System.Delete(St1, 1, 5);
        System.Delete(St1, Length(St1) - 4, 5);

        if System.Pos('[**]', St1) > 0 then MwAbort(aHataStr);

        P := System.Pos(']', St1);

        if (LeftStr(St1, 1) <> '[') or (P < 5) then MwAbort(aHataStr);

        System.Delete(St1, 1, 1);

        St2 := LeftStr(St1, P - 2);

        System.Delete(St1, 1, P - 1);

        St1 := Trim(St1);

        aTargetVirtualTableEx.FindField('S_ID').AsString        := St2;
        aTargetVirtualTableEx.FindField('DESCRIPTION').AsString := St1;



        //[Classification: Potentially Bad Traffic] [Priority: 2]
        //CLASSIFICATION	PRIORITY
        //Potentially Bad Traffic]	2

        St1 := aLists[1][I];

        if System.Pos('[Classification: ', St1) <> 1 then MwAbort(aHataStr);
        if System.Pos('] [Priority: ', St1) < 10 then MwAbort(aHataStr);
        if RightStr(St1, 1) <> ']' then MwAbort(aHataStr);

        St2 := St1;
        System.Delete(St2, Length(St2) - 1, 2);
        if RightStr(St2, Length('] [Priority: ')) <> '] [Priority: ' then MwAbort(aHataStr);

        St2 := St1;

        System.Delete(St1, 1, Length('[Classification: '));

        P := System.Pos('] [Priority: ', St1);

        St1 := Trim(LeftStr(St1, P - 1));

        try
          StrToInt(St2[Length(St2) - 1]);
        except
          MwAbort(aHataStr);
        end;

        aTargetVirtualTableEx.FindField('CLASSIFICATION').AsString := St1;
        aTargetVirtualTableEx.FindField('PRIORITY').AsString       := St2[Length(St2) - 1];



        //05/30-19:09:10.917356 0.0.0.0:68 -> 255.255.255.255:67
        //TIMESTAMP	             SOURCE IP	SOURCE PORT	DESTINATION IP	DESTINATION PORT
        //05/30-19:09:10.917356	 0.0.0.0	  68	        255.255.255.255	67

        St1 := aLists[2][I];

        if System.Pos(' -> ', St1) < 20 then MwAbort(aHataStr);

        P := System.Pos(' ', St1);
        if P < 20 then MwAbort(aHataStr);

        aTargetVirtualTableEx.FindField('TIMESTAMP').AsString := LeftStr(St1, P - 1);

        System.Delete(St1, 1, P);


        P := System.Pos(' -> ', St1);
        if P < 10 then MwAbort(aHataStr);

        St2 := LeftStr(St1, P - 1);
        System.Delete(St1, 1, P + 3);

        P := System.Pos(':', St2);

        if P < 1 then
          aTargetVirtualTableEx.FindField('SOURCE_IP').AsString := St2
        else
        begin
          aTargetVirtualTableEx.FindField('SOURCE_IP').AsString := LeftStr(St2, P - 1);

          System.Delete(St2, 1, P);

          aTargetVirtualTableEx.FindField('SOURCE_PORT').AsString := St2;
        end;


        St2 := St1;

        P := System.Pos(':', St2);

        if P < 1 then
          aTargetVirtualTableEx.FindField('DESTINATION_IP').AsString := St2
        else
        begin
          aTargetVirtualTableEx.FindField('DESTINATION_IP').AsString := LeftStr(St2, P - 1);

          System.Delete(St2, 1, P);

          aTargetVirtualTableEx.FindField('DESTINATION_PORT').AsString := St2;
        end;



        //UDP TTL:128 TOS:0x0 ID:0 IpLen:20 DgmLen:328
        //PROTOCOL	TTL	TOS	ID	IPLEN	DGMLEN
        //UDP	      128	0x0	0	  20	  328

        St1 := aLists[3][I];

        if System.Pos(' ', St1) < 4 then MwAbort(aHataStr);
        if System.Pos(' ', St1) > 5 then MwAbort(aHataStr);
        if System.Pos(' TTL:', St1) < 1 then MwAbort(aHataStr);
        if System.Pos(' TOS:', St1) < 1 then MwAbort(aHataStr);
        if System.Pos(' ID:', St1) < 1 then MwAbort(aHataStr);
        if System.Pos(' IpLen:', St1) < 1 then MwAbort(aHataStr);
        if System.Pos(' DgmLen:', St1) < 1 then MwAbort(aHataStr);

        P := System.Pos(' ', St1);
        aTargetVirtualTableEx.FindField('PROTOCOL').AsString := LeftStr(St1, P - 1);
        System.Delete(St1, 1, P);


        if System.Pos('TTL:', St1) <> 1 then MwAbort(aHataStr);
        System.Delete(St1, 1, Length('TTL:'));

        P := System.Pos(' ', St1);
        aTargetVirtualTableEx.FindField('TTL').AsString := LeftStr(St1, P - 1);
        System.Delete(St1, 1, P);


        if System.Pos('TOS:', St1) <> 1 then MwAbort(aHataStr);
        System.Delete(St1, 1, Length('TOS:'));

        P := System.Pos(' ', St1);
        aTargetVirtualTableEx.FindField('TOS').AsString := LeftStr(St1, P - 1);
        System.Delete(St1, 1, P);


        if System.Pos('ID:', St1) <> 1 then MwAbort(aHataStr);
        System.Delete(St1, 1, Length('ID:'));

        P := System.Pos(' ', St1);
        aTargetVirtualTableEx.FindField('ID').AsString := LeftStr(St1, P - 1);
        System.Delete(St1, 1, P);


        if System.Pos('IpLen:', St1) <> 1 then MwAbort(aHataStr);
        System.Delete(St1, 1, Length('IpLen:'));

        P := System.Pos(' ', St1);
        aTargetVirtualTableEx.FindField('IPLEN').AsString := LeftStr(St1, P - 1);
        System.Delete(St1, 1, P);


        if System.Pos('DgmLen:', St1) <> 1 then MwAbort(aHataStr);
        System.Delete(St1, 1, Length('DgmLen:'));

        aTargetVirtualTableEx.FindField('DGMLEN').AsString := St1;


        aTargetVirtualTableEx.Post;
      end;
    finally
      ProgressFinish;
    end;

    aTargetVirtualTableEx.SaveToFileEx(aToTableName, 'Tablo kaydediliyor...' + LB2 + '"' + aToTableName + '"', AnsiUpperCase(MyExtractFileExtWithoutDot(aToTableName)) = 'XML', TRUE);

    ProgressStartAsWaitMessage('Hafýza boþaltýlýyor...');
    try
      aList1.Clear;
      aLists[0].Clear;
      aLists[1].Clear;
      aLists[2].Clear;
      aLists[3].Clear;
    finally
      ProgressFinish;
    end;

    if Mc('Kaydedilen tabloyu ("' + aTargetVirtualTableEx.Caption + '") formda açmak ister misiniz?') = mrYes then
    begin
      aTabloFormdaAcildi := TRUE;

      aTargetVirtualTableEx.First;
      aTargetVirtualTableEx.AutoSaveFileName  := aToTableName;
      aTargetVirtualTableEx.AutoSaveFileAsXML := AnsiUpperCase(MyExtractFileExtWithoutDot(aToTableName)) = 'XML';

      if Assigned(DatabasesForm) then AssignStandartDataSetsEventsFromDataSetToDataSet(DatabasesForm.MainUniQuery, aTargetVirtualTableEx);
      VeriGirisi(nil, aTargetVirtualTableEx, aTargetVirtualTableEx.Caption, '', TRUE);
    end
    else
    begin
      ProgressStartAsWaitMessage('Hafýza boþaltýlýyor...');
      try
        aTargetVirtualTableEx.Clear;
      finally
        ProgressFinish;
      end;
    end;
  finally;
    aList1.Free;
    aLists[0].Free;
    aLists[1].Free;
    aLists[2].Free;
    aLists[3].Free;
    if Assigned(aTargetVirtualTableEx) then
      if not aTabloFormdaAcildi then FreeAndNil(aTargetVirtualTableEx);
  end;
end;

function My32(const aText: string; const aLength: Integer = 1000): string;
begin
  if Length(aText) <= aLength then
    Result := aText
  else
    Result := LeftStr(aText, aLength);

  Result := MyChangeCharsUnder32To32(Result);
end;

function VarToStrTry32(aVariant: Variant): string;
begin
  try
    Result := My32(VarToStrDef(aVariant, ''));
  except
    Result := '';
  end;
end;

function GetNodeValueTry(aXmlNode: IXMLNode): string;
begin
  try
    Result := My32(VarToStrDef(aXmlNode.NodeValue, ''));
  except
    Result := '';
  end;
end;

procedure AddSubNodes(const TheLeftStr: string; const aDepth: Integer; const aParentNode: IXMLNode; const TheIXMLNodeList: IXMLNodeList; var TheList: TStringList);
var
  I, J: Integer;
  aXmlNode: IXMLNode;
  St1, aLeftStrs: string;
begin
  if not Assigned(TheIXMLNodeList) then Exit;
  if not Assigned(TheList) then Exit;

  if TheIXMLNodeList.Count = 0 then Exit;

  aLeftStrs := TheLeftStr + TAB + IntToStr(aDepth) + TAB;

  if Assigned(aParentNode) then aLeftStrs := aLeftStrs + My32(aParentNode.XML);

  aLeftStrs := aLeftStrs + TAB;

  for I := 0 to TheIXMLNodeList.Count - 1 do
  begin
    aXmlNode := TheIXMLNodeList.Nodes[I];

    //FILE_NAME,        DERINLIK,             PARENT_XML,
    //PARENT_NODE_TYPE, PARENT_LOCAL_NAME,    PARENT_NODE_NAME,    PARENT_NODE_VALUE,    PARENT_CHILD_COUNT, CHILD_INDEX,
    //NODE_TYPE,        NODE_XML,             LOCAL_NAME,          NODE_NAME,            NODE_VALUE,         NODE_HAS_CHILD_NODES, NODE_CHILD_COUNT, ATTRIBUTE_COUNT, ATTRIBUTE_INDEX,
    //XML,              ATTRIBUTE_LOCAL_NAME, ATTRIBUTE_NODE_NAME, ATTRIBUTE_NODE_VALUE,

    St1 := aLeftStrs;

    if Assigned(aParentNode) then
    begin
      St1 := St1 +
             NodeTypeNames[aParentNode.NodeType] + TAB +
             My32(aParentNode.LocalName) + TAB +
             My32(aParentNode.NodeName) + TAB +
             GetNodeValueTry(aParentNode) + TAB +
             IntToStr(aParentNode.ChildNodes.Count);
    end
    else
      St1 := St1 + TAB + TAB + TAB + TAB;

    St1 := St1 + TAB +
           IntToStr(I + 1) + TAB +
           NodeTypeNames[aXmlNode.NodeType] + TAB +
           My32(aXmlNode.XML) + TAB +
           My32(aXmlNode.LocalName) + TAB +
           My32(aXmlNode.NodeName) + TAB +
           GetNodeValueTry(aXmlNode) + TAB +
           IfThen(aXmlNode.HasChildNodes, 'YES', 'NO') + TAB +
           IntToStr(aXmlNode.ChildNodes.Count) + TAB +
           IntToStr(aXmlNode.AttributeNodes.Count);

    TheList.Add(St1);

    for J := 0 to aXmlNode.AttributeNodes.Count - 1 do TheList.Add(St1 + TAB +
                                                                   IntToStr(J + 1) + TAB +
                                                                   My32(aXmlNode.AttributeNodes[J].XML) + TAB +
                                                                   My32(aXmlNode.AttributeNodes[J].LocalName) + TAB +
                                                                   My32(aXmlNode.AttributeNodes[J].NodeName) + TAB +
                                                                   GetNodeValueTry(aXmlNode.AttributeNodes[J]));

    if aXmlNode.HasChildNodes then AddSubNodes(TheLeftStr, aDepth + 1, aXmlNode, aXmlNode.ChildNodes, TheList);
  end;
end;

procedure DoWordAnaliz;
var
  aWordFileName, aFileName, St1: string;
  I: Integer;
  aZipStream: TStream;
  aLocalHeader: TZipHeader;
  aList: TStringList;
  aZipFile: TZipFile;
begin
  aWordFileName := ReadINI(SnortLogToTableForm.Button1, 'Analiz Edilecek Word Dosyasýný Seçiniz');
  if not MyOpenDialog('Analiz Edilecek Word Dosyasýný Seçiniz', 'DOC;DOCX', ['Word Dosyalarý (*.DOC;*.DOCX)','Tüm Dosyalar (*.*)'], ['*.DOC;*.DOCX', '*.*'], aWordFileName, FALSE) then Exit;
  WriteINI(SnortLogToTableForm.Button1, 'Analiz Edilecek Word Dosyasýný Seçiniz', aWordFileName);

  aZipFile := TZipFile.Create;
  aList    := TStringList.Create;
  try
    ProgressStartAsWaitMessage('Dosya açýlýp analiz ediliyor...' + LB2 + '"' + aWordFileName + '"');
    try
      aZipFile.Open(aWordFileName, TZipMode.zmRead);

      for I := 0 to Length(aZipFile.FileNames) - 1 do
      begin
        aFileName := aZipFile.FileNames[I];

        if aFileName <> 'word/document.xml' then Continue;

        aZipFile.Read(aFileName, aZipStream, aLocalHeader);

        aZipStream.Position := 0;

        try
          SnortLogToTableForm.XMLDocument1.LoadFromStream(aZipStream);
        except
          Continue;
        end;

        //[Content_Types].xml, NodeTypeName=Element, Default, ChildNodes Count: 12, Atrr Count: 2, NODENAME: Default NODEVALUE: , Attr No: 1 AttrNodeName: Extension AttrNodeValue: png, Attr No: 2 AttrNodeName: ContentType AttrNodeValue: image/png, CHILD NODES COUNT: 1

        AddSubNodes(aFileName, 1, nil, SnortLogToTableForm.XMLDocument1.DocumentElement.ChildNodes, aList);
      end;

      St1 := 'FILE_NAME,        DERINLIK,             PARENT_XML,' +
             'PARENT_NODE_TYPE, PARENT_LOCAL_NAME,    PARENT_NODE_NAME,    PARENT_NODE_VALUE,    PARENT_CHILD_COUNT, CHILD_INDEX,' +
             'NODE_TYPE,        NODE_XML,             LOCAL_NAME,          NODE_NAME,            NODE_VALUE,         NODE_HAS_CHILD_NODES, NODE_CHILD_COUNT, ATTRIBUTE_COUNT, ATTRIBUTE_INDEX,' +
             'XML,              ATTRIBUTE_LOCAL_NAME, ATTRIBUTE_NODE_NAME, ATTRIBUTE_NODE_VALUE';

      St1 := MyAnsiReplaceStr(RemoveCharsFromText(St1, ' '), ',', TAB);

      aList.Insert(0, St1);

      ProgressChangeMessage('Analiz bilgileri metin editöre aktarýlýyor...' + LB2 + '"' + aWordFileName + '"', TRUE);

      ShowInTextEditor(aWordFileName, aList.Text, '');
    finally
      ProgressFinish;
    end;
  finally
    aZipFile.Free;
    aList.Free;
  end;
end;

function GetPageNumber(aRangeStart: Integer): Integer;
var
  I: Integer;
begin
  Result := 0;

  for I := Length(ThePagesRangeStarts) - 1 downto 0 do
    if aRangeStart >= ThePagesRangeStarts[I].Start then Exit(I + 1);
end;

procedure DoRichEditControlWord(const aTag: Integer; aAnalizDesignInfo: string);
var
  I, J, K1, aActiveViewIndex: Integer;
  St1, St2, aWordFileName, aTempFileName: string;
  afrmRibbonRichEditMain: TfrmRibbonRichEditMain;
  aPagesVirtualTableEx: TVirtualTableEx;
  aPagesVirtualTableExFormdaAcildi: Boolean;
  aRangesVirtualTableEx: TVirtualTableEx;
  aRangesVirtualTableExFormdaAcildi: Boolean;
  aWordDosyasiAcikKalsin, aSayfaGenelBilgileriniGoster, aDosyaBilgileriniGoster, aAnalizKontrolDosyasiniGoster: Boolean;
  adxFontInfo: TdxFontInfo;
  aPageInfoWidth               : Double;
  aPageInfoHeight              : Double;
  aPageInfoOrientationPortrait : Boolean;
  aPageInfoMinimumSayfaSayisi  : Integer;
  aPageInfoLeftMarjin          : Double;
  aPageInfoRightMarjin         : Double;
  aPageInfoTopMarjin           : Double;
  aPageInfoBottomMarjin        : Double;
  aPageInfoDuyarlilik          : Double;
  aHataSayisi, aPagesHataSayisi, aRangesHataSayisi: Integer;
  aHataText, aTOPLAMHataText: string;
  aTEZAnalizTableEx: TVirtualTableEx;
  aTEZAnalizTableExFormdaAcildi: Boolean;
  aLastRecNo: Integer;
  aAranilacakGrup, aAranacakMetin, aMetin: string;
  aSabitSayfaNo: Integer;
  aTekMetin, aOlmakZorunda, aSayfaBasinda, aBuyulterekAra: Boolean;
  aBulundu: Boolean;
begin
  aWordFileName := ReadINI(SnortLogToTableForm.Button1, 'Analiz Edilecek Word Dosyasýný Seçiniz');
  if not MyOpenDialog('Analiz Edilecek Word Dosyasýný Seçiniz', 'DOC;DOCX', ['Word Dosyalarý (*.DOC;*.DOCX)','Tüm Dosyalar (*.*)'], ['*.DOC;*.DOCX', '*.*'], aWordFileName, FALSE) then Exit;
  WriteINI(SnortLogToTableForm.Button1, 'Analiz Edilecek Word Dosyasýný Seçiniz', aWordFileName);

  afrmRibbonRichEditMain := TfrmRibbonRichEditMain.Create(Application.MainForm);

  try
    afrmRibbonRichEditMain.Visible      := FALSE;
    afrmRibbonRichEditMain.Ribbon.Style := rs2010;
  except
  end;

  ProgressStartAsWaitMessage('Dosya açýlýyor...' + LB2 + '"' + aWordFileName + '"');
  try
    afrmRibbonRichEditMain.RichEditControl.LoadDocument(aWordFileName);

    afrmRibbonRichEditMain.Caption := aWordFileName;
  finally
    ProgressFinish;
  end;

  if aTag = 2 then
  begin
    afrmRibbonRichEditMain.FormStyle := fsMDIChild;
    afrmRibbonRichEditMain.Visible   := TRUE;

    Exit;
  end;

  with MainForm do
  begin
    aPageInfoWidth               := 21.0;  //A4 - 21,0 x 29,7 cm
    aPageInfoHeight              := 29.7;

    St1 := SayfaBoyutlaricxBarEditItem.EditValue;

    if St1 = 'A3 – 29,7 x 42,0 cm' then
    begin
      aPageInfoWidth             := 29.7;
      aPageInfoHeight            := 42.0;
    end;
    if St1 = 'B4 – 25,0 x 35,3 cm' then
    begin
      aPageInfoWidth             := 25.0;
      aPageInfoHeight            := 35.3;
    end;
    if St1 = 'B  - 27,9 x 43,2 cm' then
    begin
      aPageInfoWidth             := 27.9;
      aPageInfoHeight            := 43.2;
    end;
    if St1 = 'C4 – 22,9 x 32,4 cm' then
    begin
      aPageInfoWidth             := 22.9;
      aPageInfoHeight            := 32.4;
    end;

    aPageInfoOrientationPortrait := OrientationcxBarEditItem.EditValue <> 'Landscape';
    aPageInfoMinimumSayfaSayisi  := MinimumSayfaSayisicxBarEditItem.EditValue;
    aPageInfoLeftMarjin          := LeftMarjincxBarEditItem.EditValue;
    aPageInfoRightMarjin         := RightMarjincxBarEditItem.EditValue;
    aPageInfoTopMarjin           := TopMarjincxBarEditItem.EditValue;
    aPageInfoBottomMarjin        := BottomMarjincxBarEditItem.EditValue;
    aPageInfoDuyarlilik          := DuyarlilikcxBarEditItem.EditValue / 10.0;
  end;

  aAnalizDesignInfo := aAnalizDesignInfo + DupeString('00', 10);

  aWordDosyasiAcikKalsin        := aAnalizDesignInfo[1] = '1';
  aSayfaGenelBilgileriniGoster  := aAnalizDesignInfo[2] = '1';
  aDosyaBilgileriniGoster       := aAnalizDesignInfo[3] = '1';
  aAnalizKontrolDosyasiniGoster := aAnalizDesignInfo[4] = '1';

  if afrmRibbonRichEditMain.RichEditControl.DocumentModel.IsEmpty then Mw('"' + aWordFileName + '" Dosyasý boþ bir dosya.');

  aPagesVirtualTableExFormdaAcildi  := FALSE;
  aRangesVirtualTableExFormdaAcildi := FALSE;
  aTEZAnalizTableExFormdaAcildi     := FALSE;

  aPagesHataSayisi  := 0;
  aRangesHataSayisi := 0;
  aTOPLAMHataText   := '';

  SetLength(ThePagesRangeStarts, 0);

  try
    ProgressStartAsWaitMessage('Dosya analiz bilgileri oluþturuluyor...' + LB2 + '"' + aWordFileName + '"');
    try
      if not CreateVirtualTableEx(aPagesVirtualTableEx,
                                  'Sayfa Genel Bilgileri - "' + ExtractFileName(aWordFileName) + '"',
                                  ['Sayfa',   'Ordinal Sayfa', 'Visible',   'Empty',   'Range Start', 'Range End', 'Left Margin', 'Right Margin', 'Top Margin', 'Bottom Margin', 'Orientation', 'Page Height', 'Page Width', 'Header',  'Footer',  'Hata Var', 'Hata Mesajý'],
                                  [ftInteger, ftInteger,       ftBoolean,   ftBoolean, ftInteger,     ftInteger,   ftFloat,       ftFloat,        ftFloat,      ftFloat,         ftString,      ftFloat,       ftFloat,      ftBoolean, ftBoolean, ftBoolean,  ftString],
                                  [0,         0,               0,           0,         0,             0,           0,             0,              0,            0,               10,            0,             0,            0,         0,         0,          100],
                                  [TRUE,      FALSE,           FALSE,       FALSE,     FALSE,         FALSE,       FALSE,         FALSE,          FALSE,        FALSE,           FALSE,         FALSE,         FALSE,        FALSE,     FALSE,     FALSE,      FALSE]) then Exit;


      K1 := 111;
      ProgressStartAsNormal('Word Dosyasý Ara Belleðe Alýnýyor...' + LB2 + '"' + aWordFileName + '"', K1, TRUE);
      try
        for I := 0 to K1 - 1 do
        begin
          if ProgressCanceled then Exit;

          if I mod 2 = 0 then Sleep(1);

          Application.ProcessMessages;
        end;
      finally
        ProgressFinish;
      end;

      K1 := -1;
      aActiveViewIndex := -1;

      for I := 0 to afrmRibbonRichEditMain.RichEditControl.Views.ViewCount - 1 do
        with afrmRibbonRichEditMain.RichEditControl.Views[I].FormattingController.PageController do
          if PageCount > K1 then
          begin
            K1 := PageCount;
            aActiveViewIndex := I;
          end;

      with afrmRibbonRichEditMain.RichEditControl.Views[aActiveViewIndex].FormattingController.PageController do
      try
        K1 := PageCount;

        SetLength(ThePagesRangeStarts, K1);

        for I := 0 to Length(ThePagesRangeStarts) - 1 do
        begin
          ThePagesRangeStarts[I].Start       := 0;
          ThePagesRangeStarts[I].OrdinalPage := 0;
        end;


        aPagesVirtualTableEx.Append;

        aPagesVirtualTableEx.FindField('Sayfa').AsInteger       := 0;
        aPagesVirtualTableEx.FindField('Left Margin').AsFloat   := aPageInfoLeftMarjin;
        aPagesVirtualTableEx.FindField('Right Margin').AsFloat  := aPageInfoRightMarjin;
        aPagesVirtualTableEx.FindField('Top Margin').AsFloat    := aPageInfoTopMarjin;
        aPagesVirtualTableEx.FindField('Bottom Margin').AsFloat := aPageInfoBottomMarjin;
        aPagesVirtualTableEx.FindField('Orientation').AsString  := IfThen(aPageInfoOrientationPortrait, 'Portrait', 'Landscape');
        aPagesVirtualTableEx.FindField('Page Height').AsFloat   := aPageInfoHeight;
        aPagesVirtualTableEx.FindField('Page Width').AsFloat    := aPageInfoWidth;
        aPagesVirtualTableEx.FindField('Hata Var').AsBoolean    := PageCount < aPageInfoMinimumSayfaSayisi;
        aPagesVirtualTableEx.FindField('Hata Mesajý').AsString  := Trim(IfThen(PageCount < aPageInfoMinimumSayfaSayisi, 'Sayfa sayýsý ' + FormatInt(PageCount) + '. Minimum ' + FormatInt(aPageInfoMinimumSayfaSayisi) + ' olmalýdýr. ', '') + '(Not: Duyarlýlýk ' + (aPageInfoDuyarlilik * 10.0).ToString + ' mm''dir.)');

        if PageCount < aPageInfoMinimumSayfaSayisi then Inc(aPagesHataSayisi);

        aPagesVirtualTableEx.Post;


        if K1 > 0 then
        begin
          ProgressStartAsNormal('"Sayfa Genel Bilgileri" Tespit Ediliyor...' + LB2 + '"' + aWordFileName + '"', K1, TRUE);
          try
            for I := 0 to K1 - 1 do
            begin
              if ProgressCanceled then Exit;

              ThePagesRangeStarts[I].Start       := Pages[I].GetFirstPosition(afrmRibbonRichEditMain.RichEditControl.DocumentModel.MainPieceTable).LogPosition;
              ThePagesRangeStarts[I].OrdinalPage := Pages[I].PageOrdinal;

              aPagesVirtualTableEx.Append;

              aPagesVirtualTableEx.Fields[0].AsInteger := I + 1;
              aPagesVirtualTableEx.Fields[1].AsInteger := Pages[I].PageOrdinal;
              aPagesVirtualTableEx.Fields[2].AsBoolean := Pages[I].IsVisible;
              aPagesVirtualTableEx.Fields[3].AsBoolean := Pages[I].IsEmpty;
              aPagesVirtualTableEx.Fields[4].AsFloat   := Pages[I].GetFirstPosition(afrmRibbonRichEditMain.RichEditControl.DocumentModel.MainPieceTable).LogPosition;
              aPagesVirtualTableEx.Fields[5].AsFloat   := Pages[I].GetLastPosition(afrmRibbonRichEditMain.RichEditControl.DocumentModel.MainPieceTable).LogPosition;
              aPagesVirtualTableEx.Fields[6].AsFloat   := Pages[I].ClientBounds.Left / 38.0;
              aPagesVirtualTableEx.Fields[7].AsFloat   := (Pages[I].Bounds.Right - Pages[I].ClientBounds.Right) / 38.0;
              aPagesVirtualTableEx.Fields[8].AsFloat   := Pages[I].ClientBounds.Top / 38.0;
              aPagesVirtualTableEx.Fields[9].AsFloat   := (Pages[I].Bounds.Bottom - Pages[I].ClientBounds.Bottom) / 38.0;
              aPagesVirtualTableEx.Fields[10].AsString := IfThen(Pages[I].Bounds.Right < Pages[I].Bounds.Bottom, 'Portrait', 'Landscape');
              aPagesVirtualTableEx.Fields[11].AsFloat  := (Pages[I].Bounds.Bottom + 5.6) / 38.0;
              aPagesVirtualTableEx.Fields[12].AsFloat  := (Pages[I].Bounds.Right + 4.0) / 38.0;

              if Assigned(Pages[I].Header) then
                aPagesVirtualTableEx.Fields[13].AsBoolean := not Pages[I].Header.IsEmpty
              else
                aPagesVirtualTableEx.Fields[13].AsBoolean := FALSE;

              if Assigned(Pages[I].Footer) then
                aPagesVirtualTableEx.Fields[14].AsBoolean := not Pages[I].Footer.IsEmpty
              else
                aPagesVirtualTableEx.Fields[14].AsBoolean := FALSE;

              for J := 6 to 12 do
                if aPagesVirtualTableEx.Fields[J] is TNumericField then aPagesVirtualTableEx.Fields[J].AsFloat := MyRound(aPagesVirtualTableEx.Fields[J].AsFloat * 100) / 100;


              aHataSayisi := 0;
              aHataText   := '';

              if aPagesVirtualTableEx.FindField('Orientation').AsString <> IfThen(aPageInfoOrientationPortrait, 'Portrait', 'Landscape') then
              begin
                Inc(aHataSayisi);
                aHataText := aHataText + '"Orientation", '
              end;

              if Abs(aPagesVirtualTableEx.FindField('Page Width').AsFloat - aPageInfoWidth) > aPageInfoDuyarlilik then
              begin
                Inc(aHataSayisi);
                aHataText := aHataText + '"Page Width", '
              end;

              if Abs(aPagesVirtualTableEx.FindField('Page Height').AsFloat - aPageInfoHeight) > aPageInfoDuyarlilik then
              begin
                Inc(aHataSayisi);
                aHataText := aHataText + '"Page Height", '
              end;

              if Abs(aPagesVirtualTableEx.FindField('Left Margin').AsFloat - aPageInfoLeftMarjin) > aPageInfoDuyarlilik then
              begin
                Inc(aHataSayisi);
                aHataText := aHataText + '"Left Margin", '
              end;

              if Abs(aPagesVirtualTableEx.FindField('Right Margin').AsFloat - aPageInfoRightMarjin) > aPageInfoDuyarlilik then
              begin
                Inc(aHataSayisi);
                aHataText := aHataText + '"Right Margin", '
              end;

              if Abs(aPagesVirtualTableEx.FindField('Top Margin').AsFloat - aPageInfoTopMarjin) > aPageInfoDuyarlilik then
              begin
                Inc(aHataSayisi);
                aHataText := aHataText + '"Top Margin", '
              end;

              if Abs(aPagesVirtualTableEx.FindField('Bottom Margin').AsFloat - aPageInfoBottomMarjin) > aPageInfoDuyarlilik then
              begin
                Inc(aHataSayisi);
                aHataText := aHataText + '"Bottom Margin", '
              end;

              aHataText := DeleteFromRight(aHataText, 2);

              Inc(aPagesHataSayisi, aHataSayisi);

              aPagesVirtualTableEx.FindField('Hata Var').AsBoolean   := aHataSayisi > 0;
              aPagesVirtualTableEx.FindField('Hata Mesajý').AsString := aHataText;


              aPagesVirtualTableEx.Post;
            end;
          finally
            ProgressFinish;
          end;
        end;
      except
        on Ex: Exception do Me('"Sayfa Genel Bilgileri" Hatasý!' + LB2 + Ex.Message);
      end;

      try
        if aPagesVirtualTableEx.State in dsEditModes then aPagesVirtualTableEx.Cancel;
      except
      end;


      if not CreateVirtualTableEx(aRangesVirtualTableEx,
                                  'Dosya Bilgileri - "' + ExtractFileName(aWordFileName) + '"',
                                  ['Sýra No', 'Özellik', 'Özellik Sayýsý', 'Özellik Sýra No', 'Sayfa',   'Ordinal Sayfa', 'Empty',   'Font Name', 'Font Size', 'Font Bold', 'Font Italic', 'Font Underline', 'Font Color', 'Text',  'Text Length', 'Text Detail', 'Range Start', 'Range End'],
                                  [ftInteger, ftString,  ftInteger,        ftInteger,         ftInteger, ftInteger, ftBoolean, ftString,    ftFloat,     ftBoolean,   ftBoolean,     ftBoolean,        ftInteger,    ftString, ftInteger,    ftMemo,        ftInteger,     ftInteger],
                                  [0,         25,        0,                0,                 0,         0,         0,         50,          0,           0,           0,             0,                0,            1000,     0,            0,             0,             0],
                                  [TRUE,      FALSE]) then Exit;

      with afrmRibbonRichEditMain.RichEditControl.DocumentModel.MainPieceTable do
      begin
        K1 := Paragraphs.Count;

        if K1 > 1 then ProgressStartAsNormal('Dosya Özellik Detaylarý Tespit Ediliyor...' + LB2 + '"Paragraphs"', K1, TRUE);
        try
          for I := 0 to K1 - 1 do
          begin
            if K1 > 1 then
              if ProgressCanceled then Exit;

            aRangesVirtualTableEx.Append;

            aRangesVirtualTableEx.Fields[0].AsInteger := I + 1;
            aRangesVirtualTableEx.Fields[1].AsString  := 'Paragraphs';
            aRangesVirtualTableEx.Fields[2].AsInteger := K1;
            aRangesVirtualTableEx.Fields[3].AsInteger := I + 1;
            aRangesVirtualTableEx.Fields[4].AsInteger := GetPageNumber(Paragraphs[I].LogPosition);

            if aRangesVirtualTableEx.Fields[4].AsInteger < 1 then
              aRangesVirtualTableEx.Fields[5].AsInteger := 0
            else
              aRangesVirtualTableEx.Fields[5].AsInteger := ThePagesRangeStarts[aRangesVirtualTableEx.Fields[4].AsInteger - 1].OrdinalPage;

            aRangesVirtualTableEx.Fields[6].AsBoolean := Paragraphs[I].IsEmpty;

            if Paragraphs[I].BoxCollection.Count > 0 then
              adxFontInfo := Paragraphs[I].BoxCollection[0].GetFontInfo(afrmRibbonRichEditMain.RichEditControl.DocumentModel.MainPieceTable)
            else
              try
                adxFontInfo := Paragraphs[I].GetNumerationFontInfo;
              except
                adxFontInfo := nil;
              end;

            if Assigned(adxFontInfo) then
            begin
              aRangesVirtualTableEx.Fields[7].AsString   := adxFontInfo.Name;
              aRangesVirtualTableEx.Fields[8].AsFloat    := adxFontInfo.Size;
              aRangesVirtualTableEx.Fields[9].AsBoolean  := adxFontInfo.Bold;
              aRangesVirtualTableEx.Fields[10].AsBoolean := adxFontInfo.Italic;
              aRangesVirtualTableEx.Fields[11].AsBoolean := adxFontInfo.Underline;
              try
                aRangesVirtualTableEx.Fields[12].AsInteger := Paragraphs[I].BoxCollection[0].GetStrikeoutColorCore(afrmRibbonRichEditMain.RichEditControl.DocumentModel.MainPieceTable);   //////////////COLOR!
              except
                aRangesVirtualTableEx.Fields[12].AsInteger := 0;
              end;
            end;

            St1 := GetRunText(Paragraphs[I].FirstRunIndex);

            aRangesVirtualTableEx.Fields[13].AsString  := LeftStr(St1, 1000);
            aRangesVirtualTableEx.Fields[14].AsInteger := Length(St1);
            aRangesVirtualTableEx.Fields[15].AsString  := St1;
            aRangesVirtualTableEx.Fields[16].AsInteger := Paragraphs[I].LogPosition;
            aRangesVirtualTableEx.Fields[17].AsInteger := Paragraphs[I].EndLogPosition;

            aRangesVirtualTableEx.Post;
          end;
        finally
          if K1 > 1 then ProgressFinish;
        end;
      end;




      aTEZAnalizTableEx := GetTEZAnalizTable;

      aTEZAnalizTableEx.AutoSaveFileName := '';

      aTEZAnalizTableEx.First;
      aRangesVirtualTableEx.First;

      aLastRecNo := -1;

      K1 := aTEZAnalizTableEx.RecordCount;


      //['Sýra No', 'Aranýlacak Grup', 'Aranacak Metin', 'Sabit Sayfa No', 'Tek Metin', 'Olmak Zorunda', 'Font Name', 'Font Size', 'Font Bold', 'Font Italic', 'Alignment', 'Sayfa Baþýnda', 'Büyülterek Ara', 'Hata Var', 'Hata Mesajý'],
      //['Sýra No', 'Özellik', 'Özellik Sayýsý', 'Özellik Sýra No', 'Sayfa',   'Ordinal Sayfa', 'Empty',   'Font Name', 'Font Size', 'Font Bold', 'Font Italic', 'Font Underline', 'Font Color', 'Text',  'Text Length', 'Text Detail', 'Range Start', 'Range End'],

      if K1 > 0 then
      begin
        ProgressStartAsNormal('"Belge Detay Bilgileri" Kontrol Ediliyor...' + LB2 + '"' + aWordFileName + '"', K1, TRUE);
        try
          for I := 0 to K1 - 1 do
          begin
            if ProgressCanceled then Exit;

            aBulundu    := FALSE;
            aHataText   := '';
            aHataSayisi := 0;

            aAranilacakGrup := EnglishUpperCase(aTEZAnalizTableEx.FindField('Aranýlacak Grup').AsString);
            aAranacakMetin  := Trim(aTEZAnalizTableEx.FindField('Aranacak Metin').AsString);
            aSabitSayfaNo   := aTEZAnalizTableEx.FindField('Sabit Sayfa No').AsInteger;
            aTekMetin       := aTEZAnalizTableEx.FindField('Tek Metin').AsBoolean;
            aOlmakZorunda   := aTEZAnalizTableEx.FindField('Olmak Zorunda').AsBoolean;
            aSayfaBasinda   := aTEZAnalizTableEx.FindField('Sayfa Baþýnda').AsBoolean;
            aBuyulterekAra  := aTEZAnalizTableEx.FindField('Büyülterek Ara').AsBoolean;

            if aBuyulterekAra then aAranacakMetin := EnglishUpperCase(aAranacakMetin);

            if aLastRecNo > -1 then aRangesVirtualTableEx.RecNo := aLastRecNo;

            if aOlmakZorunda then
              aLastRecNo := -1
            else
              aLastRecNo := aRangesVirtualTableEx.RecNo;

            while not aRangesVirtualTableEx.EOF do
            begin
              if EnglishUpperCase(aRangesVirtualTableEx.FindField('Özellik').AsString) <> aAranilacakGrup  then
              begin
                aRangesVirtualTableEx.Next;
                Continue;
              end;

              if aSabitSayfaNo > 0 then
              begin
                if aRangesVirtualTableEx.FindField('Sayfa').AsInteger < aSabitSayfaNo  then
                begin
                  aRangesVirtualTableEx.Next;
                  Continue;
                end;

                if aRangesVirtualTableEx.FindField('Sayfa').AsInteger > aSabitSayfaNo  then
                begin
                  aRangesVirtualTableEx.Last;
                  aRangesVirtualTableEx.Next;
                  Continue;
                end;
              end;

              aMetin := Trim(aRangesVirtualTableEx.FindField('Text Detail').AsString);
              if aBuyulterekAra then aMetin := EnglishUpperCase(aMetin);


              if aTekMetin then
                if aMetin <> aAranacakMetin then
                begin
                  aRangesVirtualTableEx.Next;
                  Continue;
                end;

              if not aTekMetin then
                if System.Pos(aAranacakMetin, aMetin) < 1 then
                begin
                  aRangesVirtualTableEx.Next;
                  Continue;
                end;

              aBulundu := TRUE;

              if EnglishUpperCase(aTEZAnalizTableEx.FindField('Font Name').AsString) <> EnglishUpperCase(aRangesVirtualTableEx.FindField('Font Name').AsString) then
              begin
                Inc(aHataSayisi);
                aHataText := aHataText + '"Font Name", '
              end;

              if aTEZAnalizTableEx.FindField('Font Size').AsString <> aRangesVirtualTableEx.FindField('Font Size').AsString then
              begin
                Inc(aHataSayisi);
                aHataText := aHataText + '"Font Size", '
              end;

              if aTEZAnalizTableEx.FindField('Font Bold').AsString <> aRangesVirtualTableEx.FindField('Font Bold').AsString then
              begin
                Inc(aHataSayisi);
                aHataText := aHataText + '"Font Bold", '
              end;

              if aTEZAnalizTableEx.FindField('Font Italic').AsString <> aRangesVirtualTableEx.FindField('Font Italic').AsString then
              begin
                Inc(aHataSayisi);
                aHataText := aHataText + '"Font Italic", '
              end;

              Break;
            end;

            if not aBulundu then
            begin
              aHataSayisi := 1;
              aHataText   := 'Metin Bulunamadý.';
            end;

            Inc(aRangesHataSayisi, aHataSayisi);

            aTEZAnalizTableEx.Edit;
            aTEZAnalizTableEx.FindField('Hata Var').AsBoolean   := aHataSayisi > 0;
            aTEZAnalizTableEx.FindField('Hata Mesajý').AsString := aHataText;
            aTEZAnalizTableEx.Post;

            aTEZAnalizTableEx.Next;
          end;
        finally
          ProgressFinish;
        end;
      end;





      if aPagesHataSayisi > 0 then aTOPLAMHataText := '"Sayfa Genel Bilgileri" ile ilgili ' + FormatInt(aPagesHataSayisi) + ' hata tespit edildi.';

      if aRangesHataSayisi > 0 then
      begin
        St1 := '"Belge Detay Bilgileri" ile ilgili ' + FormatInt(aRangesHataSayisi) + ' hata tespit edildi.';

        if aTOPLAMHataText = '' then
          aTOPLAMHataText := St1
        else
          aTOPLAMHataText := aTOPLAMHataText + LB2 + St1 + LB2 + 'Toplam ' + FormatInt(aPagesHataSayisi + aRangesHataSayisi) + ' hata tespit edildi.';
      end;



      aTempFileName := GetTEZSonucTablolarFolder + MyExtractFileNameWithoutExtension(aWordFileName) + ' - Sayfa Genel Bilgileri.VTD';
      try
        MyDeleteFile(aTempFileName);
        aPagesVirtualTableEx.SaveToFileEx(aTempFileName, 'Tablo kaydediliyor...' + LB2 + '"' + aTempFileName + '"', FALSE, FALSE);
      except
        on Ex: Exception do Me('"' + aTempFileName + '" tablosu kaydedilirken bir hata meydana geldi. Hata mesajý:' + LB2 + Ex.Message);
      end;

      aTempFileName := GetTEZSonucTablolarFolder + MyExtractFileNameWithoutExtension(aWordFileName) + ' - Detay Bilgileri.VTD';
      try
        MyDeleteFile(aTempFileName);
        aRangesVirtualTableEx.SaveToFileEx(aTempFileName, 'Tablo kaydediliyor...' + LB2 + '"' + aTempFileName + '"', FALSE, FALSE);
      except
        on Ex: Exception do Me('"' + aTempFileName + '" tablosu kaydedilirken bir hata meydana geldi. Hata mesajý:' + LB2 + Ex.Message);
      end;

      aTempFileName := GetTEZSonucTablolarFolder + MyExtractFileNameWithoutExtension(aWordFileName) + ' - Analiz Sonuc Bilgileri.VTD';
      try
        MyDeleteFile(aTempFileName);
        aTEZAnalizTableEx.SaveToFileEx(aTempFileName, 'Tablo kaydediliyor...' + LB2 + '"' + aTempFileName + '"', FALSE, FALSE);
      except
        on Ex: Exception do Me('"' + aTempFileName + '" tablosu kaydedilirken bir hata meydana geldi. Hata mesajý:' + LB2 + Ex.Message);
      end;

      if aWordDosyasiAcikKalsin then
      begin
        ProgressStartAsWaitMessage('Dosya gösteriliyor...' + LB2 + '"' + aWordFileName + '"');
        try
          afrmRibbonRichEditMain.FormStyle := fsMDIChild;
          afrmRibbonRichEditMain.Visible   := TRUE;
        finally
          ProgressFinish;
        end;
      end;

      if aDosyaBilgileriniGoster then
      begin
        aRangesVirtualTableExFormdaAcildi := TRUE;

        aRangesVirtualTableEx.First;

        if Assigned(DatabasesForm) then AssignStandartDataSetsEventsFromDataSetToDataSet(DatabasesForm.MainUniQuery, aRangesVirtualTableEx);
        VeriGirisi(nil, aRangesVirtualTableEx, aRangesVirtualTableEx.Caption, '', TRUE);
      end;

      if aSayfaGenelBilgileriniGoster or (aPagesHataSayisi > 0) then
      begin
        aPagesVirtualTableExFormdaAcildi := TRUE;

        aPagesVirtualTableEx.First;

        if Assigned(DatabasesForm) then AssignStandartDataSetsEventsFromDataSetToDataSet(DatabasesForm.MainUniQuery, aPagesVirtualTableEx);
        VeriGirisi(nil, aPagesVirtualTableEx, aPagesVirtualTableEx.Caption, '', TRUE);
      end;

      if aAnalizKontrolDosyasiniGoster or (aRangesHataSayisi > 0) then
      begin
        aTEZAnalizTableExFormdaAcildi := TRUE;

        aTEZAnalizTableEx.First;

        if Assigned(DatabasesForm) then AssignStandartDataSetsEventsFromDataSetToDataSet(DatabasesForm.MainUniQuery, aTEZAnalizTableEx);
        VeriGirisi(nil, aTEZAnalizTableEx, aTEZAnalizTableEx.Caption, '', TRUE);
      end;


    finally
      ProgressFinish(TRUE);
    end;
  finally
    SetScreenCursor(crDefault);
    if not aWordDosyasiAcikKalsin then
      if Assigned(afrmRibbonRichEditMain) then afrmRibbonRichEditMain.Close;
    if Assigned(aPagesVirtualTableEx) then
      if not aPagesVirtualTableExFormdaAcildi then FreeAndNil(aPagesVirtualTableEx);
    if Assigned(aRangesVirtualTableEx) then
      if not aRangesVirtualTableExFormdaAcildi then FreeAndNil(aRangesVirtualTableEx);
    if Assigned(aTEZAnalizTableEx) then
      if not aTEZAnalizTableExFormdaAcildi then FreeAndNil(aTEZAnalizTableEx);
  end;

  if aTOPLAMHataText <> '' then Mw(aTOPLAMHataText);
end;

initialization
  SnortLogToTableForm := TSnortLogToTableForm.Create(Application);

end.
