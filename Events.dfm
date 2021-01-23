object EventsForm: TEventsForm
  Left = 0
  Top = 0
  Width = 570
  Height = 328
  AutoScroll = True
  Caption = 'EventsForm'
  Color = clBtnFace
  Font.Charset = TURKISH_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object btnGeneralEventSender: TButton
    Left = 8
    Top = 8
    Width = 89
    Height = 25
    Caption = 'Event Sender'
    TabOrder = 0
    OnClick = btnGeneralEventSenderClick
  end
end
