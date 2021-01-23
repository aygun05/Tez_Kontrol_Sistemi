object ProgramGirisiForm: TProgramGirisiForm
  Left = 0
  Top = 0
  Width = 570
  Height = 328
  AutoScroll = True
  Caption = 'ProgramGirisiForm'
  Color = clBtnFace
  Font.Charset = TURKISH_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object ProgramGirisiUpdateTimer: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = ProgramGirisiUpdateTimerTimer
    Left = 16
    Top = 16
  end
end
