object frmReplace: TfrmReplace
  Left = 0
  Top = 0
  Caption = 'Find and Replace'
  ClientHeight = 132
  ClientWidth = 434
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 19
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 30
    Height = 19
    Caption = 'Find'
  end
  object Label2: TLabel
    Left = 8
    Top = 41
    Width = 54
    Height = 19
    Caption = 'Replace'
  end
  object eFind: TEdit
    Left = 76
    Top = 5
    Width = 350
    Height = 27
    TabOrder = 0
  end
  object eReplace: TEdit
    Left = 76
    Top = 38
    Width = 350
    Height = 27
    TabOrder = 1
  end
  object ckSelection: TCheckBox
    Left = 8
    Top = 71
    Width = 97
    Height = 17
    Caption = 'Selection'
    TabOrder = 2
  end
  object Button1: TButton
    Left = 8
    Top = 99
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object Button2: TButton
    Left = 104
    Top = 99
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object ckAll: TCheckBox
    Left = 124
    Top = 71
    Width = 97
    Height = 17
    Caption = 'All'
    TabOrder = 5
  end
  object ckCase: TCheckBox
    Left = 224
    Top = 71
    Width = 129
    Height = 17
    Caption = 'Case Sensitive'
    TabOrder = 6
  end
end
