object frmMoocoderMain: TfrmMoocoderMain
  Left = 0
  Top = 0
  Caption = 'MooCoder'
  ClientHeight = 594
  ClientWidth = 943
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 488
    Width = 943
    Height = 87
    Align = alBottom
    Caption = 'Panel1'
    TabOrder = 0
    object Edit1: TEdit
      Left = 8
      Top = 12
      Width = 834
      Height = 27
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = 'Edit1'
    end
    object Button1: TButton
      Left = 848
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Send'
      Default = True
      TabOrder = 1
      OnClick = Button1Click
    end
    object ckConnect: TCheckBox
      Left = 8
      Top = 45
      Width = 97
      Height = 17
      Caption = 'Connect'
      TabOrder = 2
      OnClick = ckConnectClick
    end
    object btnDump: TButton
      Left = 104
      Top = 45
      Width = 75
      Height = 25
      Action = actDump
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
    end
    object btnCompile: TButton
      Left = 185
      Top = 45
      Width = 75
      Height = 25
      Action = ActCompile
      TabOrder = 4
    end
    object btnVerbs: TButton
      Left = 300
      Top = 45
      Width = 75
      Height = 25
      Action = actVerb
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
    end
  end
  object Memo2: TMemo
    Left = 0
    Top = 399
    Width = 943
    Height = 89
    Align = alBottom
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    Lines.Strings = (
      'Memo2')
    ParentFont = False
    TabOrder = 1
    OnDblClick = Memo2DblClick
  end
  object pages: TPageControl
    Left = 0
    Top = 0
    Width = 943
    Height = 399
    ActivePage = tbMain
    Align = alClient
    MultiLine = True
    TabOrder = 2
    OnChange = pagesChange
    object tbMain: TTabSheet
      Caption = 'Main'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      object Memo1: TRichEdit
        Left = 0
        Top = 0
        Width = 935
        Height = 368
        Align = alClient
        Color = clBlack
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -16
        Font.Name = 'Courier'
        Font.Style = []
        HideSelection = False
        Lines.Strings = (
          'Memo1')
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
        Zoom = 100
        OnChange = Memo1Change
        OnDblClick = Memo2DblClick
        OnSelectionChange = Memo1SelectionChange
      end
    end
    object tbVerbs: TTabSheet
      Caption = 'Verbs'
      ImageIndex = 1
      object lvVerbs: TListView
        Left = 0
        Top = 0
        Width = 935
        Height = 368
        Align = alClient
        Columns = <
          item
            Caption = 'Obj'
          end
          item
            Caption = 'Name'
          end
          item
            Caption = 'Verb'
          end
          item
            AutoSize = True
            Caption = 'Detail'
          end>
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
        OnColumnClick = lvVerbsColumnClick
        OnCompare = lvVerbsCompare
        OnDblClick = lvVerbsDblClick
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 575
    Width = 943
    Height = 19
    Panels = <
      item
        Text = 'Line'
        Width = 50
      end
      item
        Text = 'Other'
        Width = 60
      end>
  end
  object client: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 8492
    OnConnect = clientConnect
    OnDisconnect = clientDisconnect
    OnRead = clientRead
    OnWrite = clientWrite
    Left = 536
    Top = 336
  end
  object tmrQueue: TTimer
    OnTimer = tmrQueueTimer
    Left = 448
    Top = 340
  end
  object PopupMenu1: TPopupMenu
    Left = 400
    Top = 211
    object GotoLine1: TMenuItem
      Caption = 'Goto Line'
      ShortCut = 16455
      OnClick = GotoLine1Click
    end
    object FindTab1: TMenuItem
      Caption = 'Find Verb'
      ShortCut = 24646
      OnClick = FindTab1Click
    end
    object NewTab1: TMenuItem
      Caption = 'New Tab'
      ShortCut = 16462
      OnClick = NewTab1Click
    end
    object Refresh1: TMenuItem
      Caption = 'Refresh'
      ShortCut = 16466
      OnClick = Refresh1Click
    end
    object Find1: TMenuItem
      Caption = 'Find'
      ShortCut = 16454
      OnClick = Find1Click
    end
    object FindAgain1: TMenuItem
      Caption = 'Find Again'
      ShortCut = 114
      OnClick = FindAgain1Click
    end
    object Replace1: TMenuItem
      Caption = 'Replace'
      ShortCut = 16456
      OnClick = Replace1Click
    end
    object RemoveTab1: TMenuItem
      Caption = 'Remove Tab'
      OnClick = RemoveTab1Click
    end
  end
  object ApplicationEvents1: TApplicationEvents
    Left = 716
    Top = 299
  end
  object MainMenu1: TMainMenu
    Left = 272
    Top = 199
    object Project1: TMenuItem
      Caption = '&Project'
      object Compile1: TMenuItem
        Action = ActCompile
      end
      object Verb1: TMenuItem
        Action = actVerb
      end
      object NewVerb1: TMenuItem
        Action = actNewVerb
      end
      object Dump1: TMenuItem
        Action = actDump
      end
      object Clear1: TMenuItem
        Action = actClear
      end
    end
    object Settings1: TMenuItem
      Caption = '&Settings'
      object Connection1: TMenuItem
        Caption = 'Connection'
        OnClick = Connection1Click
      end
    end
  end
  object ActionList1: TActionList
    Left = 600
    Top = 115
    object ActCompile: TAction
      Caption = '&Compile'
      Enabled = False
      ShortCut = 116
      OnExecute = btnCompileClick
    end
    object actVerb: TAction
      Caption = 'Get &Verbs'
      Hint = 'Load Verb list for an object'
      ShortCut = 24662
      OnExecute = btnVerbsClick
    end
    object actNewVerb: TAction
      Caption = 'New Verb'
      OnExecute = actNewVerbExecute
    end
    object actDump: TAction
      Caption = 'Dump'
      Hint = 'Grab the output of a dump.'
      ShortCut = 24644
      OnExecute = btnDumpClick
    end
    object actClear: TAction
      Caption = 'Clear All'
      OnExecute = actClearExecute
    end
  end
  object SynEditSearch1: TSynEditSearch
    Left = 532
    Top = 231
  end
end
