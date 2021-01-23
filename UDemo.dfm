object FormDemo: TFormDemo
  Left = 586
  Top = 404
  BorderStyle = bsDialog
  Caption = 'Word Component Suite demo'
  ClientHeight = 509
  ClientWidth = 799
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object EditHeader: TEdit
    Left = 8
    Top = 8
    Width = 305
    Height = 21
    TabOrder = 0
    Text = 'Demo - header'
  end
  object ButtonSetHeader: TButton
    Left = 320
    Top = 8
    Width = 75
    Height = 21
    Caption = 'Set header'
    TabOrder = 1
    OnClick = ButtonSetHeaderClick
  end
  object EditFooter: TEdit
    Left = 8
    Top = 32
    Width = 305
    Height = 21
    TabOrder = 2
    Text = 'Demo - footer'
  end
  object ButtonSetFooter: TButton
    Left = 320
    Top = 32
    Width = 75
    Height = 21
    Caption = 'Set footer'
    TabOrder = 3
    OnClick = ButtonSetFooterClick
  end
  object Button1: TButton
    Left = 64
    Top = 94
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 4
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 208
    Top = 96
    Width = 561
    Height = 377
    ScrollBars = ssBoth
    TabOrder = 5
  end
  object Button2: TButton
    Left = 72
    Top = 240
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 6
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 72
    Top = 271
    Width = 75
    Height = 25
    Caption = 'Button3'
    TabOrder = 7
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 72
    Top = 302
    Width = 75
    Height = 25
    Caption = 'Button4'
    TabOrder = 8
    OnClick = Button4Click
  end
  object WordApplication: TWordApplication
    Active = False
  end
  object WordDocument: TWordDocument
    Active = False
    Parent = WordApplication
    Left = 32
  end
  object XPManifest: TXPManifest
    Left = 64
  end
end
