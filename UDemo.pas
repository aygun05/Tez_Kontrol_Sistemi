unit UDemo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, WordCS, Word, XPMan, Vcl.ExtCtrls;

type
  TFormDemo = class(TForm)
    EditHeader: TEdit;
    ButtonSetHeader: TButton;
    EditFooter: TEdit;
    ButtonSetFooter: TButton;
    WordApplication: TWordApplication;
    WordDocument: TWordDocument;
    XPManifest: TXPManifest;
    Button1: TButton;
    Memo1: TMemo;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    procedure ButtonSetHeaderClick(Sender: TObject);
    procedure ButtonSetFooterClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormDemo: TFormDemo;

implementation

{$ifdef CONDITIONALEXPRESSIONS}
  {$if CompilerVersion < 23} // no Delphi XE2 or higher
    uses Variants;
  {$ifend}
{$endif}

{$R *.DFM}

procedure TFormDemo.ButtonSetHeaderClick(Sender: TObject);
begin
  WordDocument.WordDocument.Sections.Item(1).Headers.Item(wdHeaderFooterPrimary).Range.Text := EditHeader.Text;
end;

procedure TFormDemo.FormCreate(Sender: TObject);
begin
  WordDocument.DocumentName := 'C:\Delphi\Veritabanlari Abdullah\Tez Projesi\FBE Tez Yazým Ver1.3 - 2.docx';
  WordDocument.Open;
end;

procedure TFormDemo.Button1Click(Sender: TObject);
var
  I, K: Integer;
begin
  Memo1.Lines.Clear;
  K := WordDocument.WordDocument.Sections.Count;
  Memo1.Lines.Add(IntToStr(K));
  for I := 1 to K do WordDocument.WordDocument.Sections.Item(I).Headers.Item(wdHeaderFooterPrimary).Range.Text := Trim(WordDocument.WordDocument.Sections.Item(I).Headers.Item(wdHeaderFooterPrimary).Range.Text) + ' + Headers Section = ' + IntToStr(I);
  for I := 1 to K do WordDocument.WordDocument.Sections.Item(I).Footers.Item(wdHeaderFooterPrimary).Range.Text := Trim(WordDocument.WordDocument.Sections.Item(I).Footers.Item(wdHeaderFooterPrimary).Range.Text) + ' + Footers Section = ' + IntToStr(I);
end;

procedure TFormDemo.Button2Click(Sender: TObject);
var
  St1: string;
begin
  Memo1.Lines.Clear;

  with WordDocument.WordDocument do begin St1 := 'Bookmarks -> '; try St1 := St1 + IntToStr(Bookmarks.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument do begin St1 := 'Characters -> '; try St1 := St1 + IntToStr(Characters.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument do begin St1 := 'ChildNodeSuggestions -> '; try St1 := St1 + IntToStr(ChildNodeSuggestions.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument do begin St1 := 'CommandBars -> '; try St1 := St1 + IntToStr(CommandBars.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument do begin St1 := 'Comments -> '; try St1 := St1 + IntToStr(Comments.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument do begin St1 := 'ContentControls -> '; try St1 := St1 + IntToStr(ContentControls.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument do begin St1 := 'ContentTypeProperties -> '; try St1 := St1 + IntToStr(ContentTypeProperties.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument do begin St1 := 'CustomXMLParts -> '; try St1 := St1 + IntToStr(CustomXMLParts.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument do begin St1 := 'DocumentInspectors -> '; try St1 := St1 + IntToStr(DocumentInspectors.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument do begin St1 := 'DocumentLibraryVersions -> '; try St1 := St1 + IntToStr(DocumentLibraryVersions.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument do begin St1 := 'Endnotes -> '; try St1 := St1 + IntToStr(Endnotes.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument do begin St1 := 'Fields -> '; try St1 := St1 + IntToStr(Fields.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument do begin St1 := 'Footnotes -> '; try St1 := St1 + IntToStr(Footnotes.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument do begin St1 := 'FormFields -> '; try St1 := St1 + IntToStr(FormFields.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument do begin St1 := 'Frames -> '; try St1 := St1 + IntToStr(Frames.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument do begin St1 := 'GetWorkflowTasks -> '; try St1 := St1 + IntToStr(GetWorkflowTasks.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument do begin St1 := 'GetWorkflowTemplates -> '; try St1 := St1 + IntToStr(GetWorkflowTemplates.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument do begin St1 := 'GrammaticalErrors -> '; try St1 := St1 + IntToStr(GrammaticalErrors.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument do begin St1 := 'HTMLDivisions -> '; try St1 := St1 + IntToStr(HTMLDivisions.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument do begin St1 := 'Hyperlinks -> '; try St1 := St1 + IntToStr(Hyperlinks.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument do begin St1 := 'Indexes -> '; try St1 := St1 + IntToStr(Indexes.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument do begin St1 := 'InlineShapes -> '; try St1 := St1 + IntToStr(InlineShapes.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument do begin St1 := 'ListParagraphs -> '; try St1 := St1 + IntToStr(ListParagraphs.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument do begin St1 := 'Lists -> '; try St1 := St1 + IntToStr(Lists.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument do begin St1 := 'ListTemplates -> '; try St1 := St1 + IntToStr(ListTemplates.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument do begin St1 := 'OMaths -> '; try St1 := St1 + IntToStr(OMaths.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument do begin St1 := 'Paragraphs -> '; try St1 := St1 + IntToStr(Paragraphs.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument do begin St1 := 'ReadabilityStatistics -> '; try St1 := St1 + IntToStr(ReadabilityStatistics.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument do begin St1 := 'Revisions -> '; try St1 := St1 + IntToStr(Revisions.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument do begin St1 := 'Scripts -> '; try St1 := St1 + IntToStr(Scripts.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument do begin St1 := 'Sections -> '; try St1 := St1 + IntToStr(Sections.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument do begin St1 := 'Sentences -> '; try St1 := St1 + IntToStr(Sentences.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument do begin St1 := 'Shapes -> '; try St1 := St1 + IntToStr(Shapes.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument do begin St1 := 'Signatures -> '; try St1 := St1 + IntToStr(Signatures.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument do begin St1 := 'SmartTags -> '; try St1 := St1 + IntToStr(SmartTags.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument do begin St1 := 'SpellingErrors -> '; try St1 := St1 + IntToStr(SpellingErrors.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument do begin St1 := 'StoryRanges -> '; try St1 := St1 + IntToStr(StoryRanges.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument do begin St1 := 'Styles -> '; try St1 := St1 + IntToStr(Styles.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument do begin St1 := 'StyleSheets -> '; try St1 := St1 + IntToStr(StyleSheets.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument do begin St1 := 'Subdocuments -> '; try St1 := St1 + IntToStr(Subdocuments.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument do begin St1 := 'Tables -> '; try St1 := St1 + IntToStr(Tables.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument do begin St1 := 'TablesOfAuthorities -> '; try St1 := St1 + IntToStr(TablesOfAuthorities.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument do begin St1 := 'TablesOfAuthoritiesCategories -> '; try St1 := St1 + IntToStr(TablesOfAuthoritiesCategories.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument do begin St1 := 'TablesOfContents -> '; try St1 := St1 + IntToStr(TablesOfContents.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument do begin St1 := 'TablesOfFigures -> '; try St1 := St1 + IntToStr(TablesOfFigures.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument do begin St1 := 'Variables -> '; try St1 := St1 + IntToStr(Variables.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument do begin St1 := 'Versions -> '; try St1 := St1 + IntToStr(Versions.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument do begin St1 := 'Windows -> '; try St1 := St1 + IntToStr(Windows.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument do begin St1 := 'Words -> '; try St1 := St1 + IntToStr(Words.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument do begin St1 := 'XMLNodes -> '; try St1 := St1 + IntToStr(XMLNodes.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument do begin St1 := 'XMLSchemaReferences -> '; try St1 := St1 + IntToStr(XMLSchemaReferences.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument do begin St1 := 'XMLSchemaViolations -> '; try St1 := St1 + IntToStr(XMLSchemaViolations.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;

end;

procedure TFormDemo.Button3Click(Sender: TObject);
var
  St1: string;
begin
  Memo1.Lines.Clear;

  with WordDocument.WordDocument.Windows do begin St1 := 'Panes.Count -> '; try St1 := St1 + IntToStr(Item(1).Panes.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
  with WordDocument.WordDocument.Windows do begin St1 := 'Panes.Item(1).Pages.Count -> '; try St1 := St1 + IntToStr(Item(1).Panes.Item(1).Pages.Count); except St1 := St1 + 'HATA!'; end; Memo1.Lines.Add(St1); end;
end;

procedure TFormDemo.Button4Click(Sender: TObject);
var
  I: Integer;
begin
  Memo1.Lines.Clear;

  with WordDocument.WordDocument.Sentences do
    //for I := 1 to Count do Memo1.Lines.Add(FormatFloat('000', I) + ' - PageSetup.LinesPage -> ' + FloatToStr(Item(I).PageSetup.LinesPage));
    //for I := 1 to Count do Memo1.Lines.Add(FormatFloat('000', I) + ' - PageSetup.CharsLine -> ' + FloatToStr(Item(I).PageSetup.CharsLine));
    for I := 1 to Count do Memo1.Lines.Add(FormatFloat('000', I) + ' - -> ' +
      Item(I).Font.Name + ', ' +
      FloatToStr(Item(I).Font.Size) + ', ' +
      FloatToStr(Item(I).Font.Italic) + ', ' +
      FloatToStr(Item(I).Font.Color));


end;

procedure TFormDemo.ButtonSetFooterClick(Sender: TObject);
begin
  WordDocument.WordDocument.Sections.Item(1).Footers.Item(wdHeaderFooterPrimary).Range.Text := EditFooter.Text;
end;

end.



+Frames -> 8
+ -> 108
+Hyperlinks -> 318
+InlineShapes -> 42
+ListParagraphs -> 384
+Lists -> 6
+Sections -> 97
+Shapes -> 210
+ -> 150
+Styles -> 473
+Tables -> 60
?Windows -> 1


-Bookmarks -> 0
Characters -> 208255
ChildNodeSuggestions -> HATA!
-CommandBars -> 213
-Comments -> 0
-ContentControls -> 780
ContentTypeProperties -> HATA!
CustomXMLParts -> 5
DocumentInspectors -> 5
DocumentLibraryVersions -> HATA!
Endnotes -> 0
+Fields -> 822
+Footnotes -> 0
FormFields -> 0
+Frames -> 8
GetWorkflowTasks -> 0
GetWorkflowTemplates -> 0
+GrammaticalErrors -> 108
HTMLDivisions -> 0
+Hyperlinks -> 318
Indexes -> 0
+InlineShapes -> 42
+ListParagraphs -> 384
+Lists -> 6
ListTemplates -> 32
OMaths -> 24
+Paragraphs -> 5635
ReadabilityStatistics -> 7
Revisions -> 0
Scripts -> 0
+Sections -> 97
-Sentences -> 12840
+Shapes -> 210
Signatures -> 0
SmartTags -> 0
+SpellingErrors -> 150
StoryRanges -> 7
+Styles -> 473
StyleSheets -> 0
Subdocuments -> 0
+Tables -> 60
TablesOfAuthorities -> 0
TablesOfAuthoritiesCategories -> 16
TablesOfContents -> 6
TablesOfFigures -> 18
Variables -> 0
Versions -> 0
?Windows -> 1
Words -> 45343
XMLNodes -> 0
XMLSchemaReferences -> 0
XMLSchemaViolations -> HATA!



Characters -> 208255
CommandBars -> 213
ContentControls -> 780
CustomXMLParts -> 5
DocumentInspectors -> 5
Fields -> 822
Frames -> 3
GrammaticalErrors -> 108
Hyperlinks -> 318
InlineShapes -> 42
ListParagraphs -> 384
Lists -> 6
ListTemplates -> 32
OMaths -> 24
Paragraphs -> 5635
ReadabilityStatistics -> 7
Sections -> 97
Sentences -> 12840
Shapes -> 210
SpellingErrors -> 150
StoryRanges -> 7
Styles -> 473
Tables -> 60
TablesOfAuthoritiesCategories -> 16
TablesOfContents -> 6
TablesOfFigures -> 18
Windows -> 1
Words -> 45343


Bookmarks, Characters, ChildNodeSuggestions, CommandBars, Comments, ContentControls, ContentTypeProperties,
CustomXMLParts, DocumentInspectors, DocumentLibraryVersions, Endnotes, Fields, Footnotes, FormFields, Frames,
GetWorkflowTasks, GetWorkflowTemplates, GrammaticalErrors, HTMLDivisions, Hyperlinks, Indexes, InlineShapes,
ListParagraphs, Lists, ListTemplates, OMaths, Paragraphs, ReadabilityStatistics, Revisions, Scripts, Sections,
Sentences, Shapes, Signatures, SmartTags, SpellingErrors, StoryRanges, Styles, StyleSheets, Subdocuments,
Tables, TablesOfAuthorities, TablesOfAuthoritiesCategories, TablesOfContents, TablesOfFigures, Variables,
Versions, Windows, Words, XMLNodes, XMLSchemaReferences, XMLSchemaViolations

