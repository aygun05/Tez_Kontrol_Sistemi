object SnortLogToTableForm: TSnortLogToTableForm
  Left = 182
  Top = 112
  Caption = 'SnortLogToTableForm'
  ClientHeight = 320
  ClientWidth = 534
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 136
    Top = 24
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
  end
  object SnortLogVirtualTable: TVirtualTable
    IndexFieldNames = 'SIRA_NO'
    FieldDefs = <
      item
        Name = 'SIRA_NO'
        DataType = ftInteger
      end
      item
        Name = 'S_ID'
        DataType = ftString
        Size = 14
      end
      item
        Name = 'DESCRIPTION'
        DataType = ftString
        Size = 133
      end
      item
        Name = 'CLASSIFICATION'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'PRIORITY'
        DataType = ftInteger
      end
      item
        Name = 'TIMESTAMP'
        DataType = ftString
        Size = 21
      end
      item
        Name = 'SOURCE_IP'
        DataType = ftString
        Size = 15
      end
      item
        Name = 'SOURCE_PORT'
        DataType = ftInteger
      end
      item
        Name = 'DESTINATION_IP'
        DataType = ftString
        Size = 15
      end
      item
        Name = 'DESTINATION_PORT'
        DataType = ftInteger
      end
      item
        Name = 'PROTOCOL'
        DataType = ftString
        Size = 4
      end
      item
        Name = 'TTL'
        DataType = ftInteger
      end
      item
        Name = 'TOS'
        DataType = ftString
        Size = 4
      end
      item
        Name = 'ID'
        DataType = ftInteger
      end
      item
        Name = 'IPLEN'
        DataType = ftInteger
      end
      item
        Name = 'DGMLEN'
        DataType = ftString
        Size = 8
      end>
    Left = 160
    Top = 72
    Data = {
      030010000700534952415F4E4F03000000000000000400535F494401000E0000
      0000000B004445534352495054494F4E01008500000000000E00434C41535349
      4649434154494F4E010032000000000008005052494F52495459030000000000
      0000090054494D455354414D5001001500000000000900534F555243455F4950
      01000F00000000000B00534F555243455F504F525403000000000000000E0044
      455354494E4154494F4E5F495001000F0000000000100044455354494E415449
      4F4E5F504F52540300000000000000080050524F544F434F4C01000400000000
      00030054544C03000000000000000300544F5301000400000000000200494403
      00000000000000050049504C454E0300000000000000060044474D4C454E0100
      080000000000000000000000}
    object SnortLogVirtualTableSIRA_NO: TIntegerField
      FieldName = 'SIRA_NO'
      Required = True
    end
    object SnortLogVirtualTableS_ID: TStringField
      FieldName = 'S_ID'
    end
    object SnortLogVirtualTableDESCRIPTION: TStringField
      FieldName = 'DESCRIPTION'
      Size = 150
    end
    object SnortLogVirtualTableCLASSIFICATION: TStringField
      FieldName = 'CLASSIFICATION'
      Size = 60
    end
    object SnortLogVirtualTablePRIORITY: TIntegerField
      FieldName = 'PRIORITY'
    end
    object SnortLogVirtualTableTIMESTAMP: TStringField
      FieldName = 'TIMESTAMP'
      Size = 25
    end
    object SnortLogVirtualTableSOURCE_IP: TStringField
      FieldName = 'SOURCE_IP'
    end
    object SnortLogVirtualTableSOURCE_PORT: TIntegerField
      FieldName = 'SOURCE_PORT'
    end
    object SnortLogVirtualTableDESTINATION_IP: TStringField
      FieldName = 'DESTINATION_IP'
    end
    object SnortLogVirtualTableDESTINATION_PORT: TIntegerField
      FieldName = 'DESTINATION_PORT'
    end
    object SnortLogVirtualTablePROTOCOL: TStringField
      FieldName = 'PROTOCOL'
      Size = 5
    end
    object SnortLogVirtualTableTTL: TIntegerField
      FieldName = 'TTL'
    end
    object SnortLogVirtualTableTOS: TStringField
      FieldName = 'TOS'
      Size = 5
    end
    object SnortLogVirtualTableID: TIntegerField
      FieldName = 'ID'
    end
    object SnortLogVirtualTableIPLEN: TIntegerField
      FieldName = 'IPLEN'
    end
    object SnortLogVirtualTableDGMLEN: TStringField
      FieldName = 'DGMLEN'
      Size = 10
    end
  end
  object XMLDocument1: TXMLDocument
    Options = [doNodeAutoCreate, doNodeAutoIndent, doAttrNull, doAutoPrefix, doNamespaceDecl]
    Left = 250
    Top = 56
  end
  object XMLDocument2: TXMLDocument
    Left = 282
    Top = 56
  end
end
