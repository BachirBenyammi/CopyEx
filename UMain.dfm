object MainForm: TMainForm
  Left = 429
  Top = 196
  Width = 373
  Height = 449
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Extended Copy - BENBAC SOFT'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object gbFileName: TGroupBox
    Left = 0
    Top = 230
    Width = 365
    Height = 73
    Align = alTop
    TabOrder = 1
    object lbSize: TLabel
      Left = 8
      Top = 16
      Width = 57
      Height = 13
      Caption = 'Size (KB):'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Lab_Size: TLabel
      Left = 96
      Top = 16
      Width = 21
      Height = 13
      Caption = '0.00'
    end
    object Label3: TLabel
      Left = 184
      Top = 16
      Width = 81
      Height = 13
      Caption = 'Elapsed Time:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Lab_Elapsed_Time: TLabel
      Left = 280
      Top = 16
      Width = 42
      Height = 13
      Caption = '00:00:00'
    end
    object FileGauge: TGauge
      Left = 8
      Top = 48
      Width = 345
      Height = 17
      Progress = 0
    end
    object Lab_Time_Left: TLabel
      Left = 280
      Top = 32
      Width = 42
      Height = 13
      Caption = '00:00:00'
    end
    object Label2: TLabel
      Left = 184
      Top = 32
      Width = 54
      Height = 13
      Caption = 'Time left:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Lab_Speed: TLabel
      Left = 96
      Top = 32
      Width = 21
      Height = 13
      Caption = '0.00'
    end
    object lbSpeed: TLabel
      Left = 8
      Top = 32
      Width = 83
      Height = 13
      Caption = 'Speed (KB/S):'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object gbTotal: TGroupBox
    Left = 0
    Top = 141
    Width = 365
    Height = 89
    Align = alTop
    Caption = 'Total: '
    TabOrder = 2
    object Label7: TLabel
      Left = 8
      Top = 16
      Width = 57
      Height = 13
      Caption = 'Size (KB):'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbAllSize: TLabel
      Left = 96
      Top = 16
      Width = 21
      Height = 13
      Caption = '0.00'
    end
    object Label9: TLabel
      Left = 184
      Top = 16
      Width = 81
      Height = 13
      Caption = 'Elapsed Time:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbAllElapsed: TLabel
      Left = 280
      Top = 16
      Width = 42
      Height = 13
      Caption = '00:00:00'
    end
    object lbAllLeft: TLabel
      Left = 280
      Top = 32
      Width = 42
      Height = 13
      Caption = '00:00:00'
    end
    object Label20: TLabel
      Left = 184
      Top = 32
      Width = 54
      Height = 13
      Caption = 'Time left:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbAllSpeed: TLabel
      Left = 96
      Top = 32
      Width = 21
      Height = 13
      Caption = '0.00'
    end
    object Label22: TLabel
      Left = 8
      Top = 32
      Width = 83
      Height = 13
      Caption = 'Speed (KB/S):'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label23: TLabel
      Left = 184
      Top = 48
      Width = 90
      Height = 13
      Caption = 'Sub directories:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label24: TLabel
      Left = 8
      Top = 48
      Width = 31
      Height = 13
      Caption = 'Files:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbFiles: TLabel
      Left = 96
      Top = 48
      Width = 17
      Height = 13
      Caption = '0/0'
    end
    object lbFolders: TLabel
      Left = 280
      Top = 48
      Width = 17
      Height = 13
      Caption = '0/0'
    end
    object Gauge: TGauge
      Left = 8
      Top = 64
      Width = 345
      Height = 17
      Progress = 0
    end
  end
  object pnlSrcDest: TPanel
    Left = 0
    Top = 0
    Width = 365
    Height = 65
    Align = alTop
    TabOrder = 0
    object spSource: TSpeedButton
      Left = 328
      Top = 8
      Width = 23
      Height = 22
      Caption = '...'
      OnClick = spSourceClick
    end
    object sbDist: TSpeedButton
      Left = 328
      Top = 32
      Width = 23
      Height = 22
      Caption = '...'
      OnClick = sbDistClick
    end
    object Label5: TLabel
      Left = 8
      Top = 16
      Width = 32
      Height = 13
      Caption = 'From:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label6: TLabel
      Left = 8
      Top = 40
      Width = 20
      Height = 13
      Caption = 'To:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Edit_Dest: TEdit
      Left = 48
      Top = 32
      Width = 273
      Height = 21
      TabOrder = 0
    end
    object Edit_Src: TEdit
      Left = 48
      Top = 8
      Width = 273
      Height = 21
      TabOrder = 1
    end
  end
  object gbOptions: TGroupBox
    Left = 0
    Top = 303
    Width = 365
    Height = 73
    Align = alTop
    Caption = 'Options: '
    TabOrder = 3
    Visible = False
    object Label1: TLabel
      Left = 8
      Top = 48
      Width = 56
      Height = 13
      Caption = 'Size Unit:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 8
      Top = 24
      Width = 89
      Height = 13
      Caption = 'Block Size(KB):'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object cbUnit: TComboBox
      Left = 72
      Top = 40
      Width = 89
      Height = 22
      AutoDropDown = True
      AutoCloseUp = True
      Style = csOwnerDrawFixed
      ItemHeight = 16
      ItemIndex = 1
      TabOrder = 0
      Text = 'KB'
      Items.Strings = (
        'Byte'
        'KB'
        'MB'
        'GB')
    end
    object seBlockSize: TSpinEdit
      Left = 104
      Top = 16
      Width = 57
      Height = 22
      MaxLength = 5
      MaxValue = 65536
      MinValue = 64
      TabOrder = 1
      Value = 256
    end
    object btnOK: TButton
      Left = 280
      Top = 32
      Width = 73
      Height = 25
      Caption = '&Apply'
      TabOrder = 2
      OnClick = btnOKClick
    end
    object cbAnimateP: TCheckBox
      Left = 168
      Top = 16
      Width = 97
      Height = 17
      Caption = 'Animation'
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
    object cbFileP: TCheckBox
      Left = 168
      Top = 32
      Width = 97
      Height = 17
      Caption = 'File Progress'
      Checked = True
      State = cbChecked
      TabOrder = 4
    end
    object cbTotalP: TCheckBox
      Left = 168
      Top = 48
      Width = 97
      Height = 17
      Caption = 'Total Progress'
      Checked = True
      State = cbChecked
      TabOrder = 5
    end
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 376
    Width = 365
    Height = 39
    Align = alTop
    TabOrder = 4
    object btnStart: TButton
      Left = 192
      Top = 8
      Width = 81
      Height = 25
      Caption = '&Start'
      TabOrder = 0
      OnClick = btnStartClick
    end
    object btnStop: TButton
      Left = 280
      Top = 8
      Width = 75
      Height = 25
      Caption = 'S&top'
      TabOrder = 1
      OnClick = btnStopClick
    end
    object btnOptions: TButton
      Left = 112
      Top = 8
      Width = 75
      Height = 25
      Caption = '&Options'
      TabOrder = 2
      OnClick = btnOptionsClick
    end
  end
  object pnlAnimate: TPanel
    Left = 0
    Top = 65
    Width = 365
    Height = 76
    Align = alTop
    TabOrder = 5
    object aCopy: TAnimate
      Left = 48
      Top = 8
      Width = 272
      Height = 60
      CommonAVI = aviCopyFiles
      StopFrame = 37
    end
  end
  object OD: TOpenDialog
    Left = 96
    Top = 24
  end
  object pMenu: TPopupMenu
    Left = 160
    Top = 24
    object miFile: TMenuItem
      Caption = 'File...'
      OnClick = miFileClick
    end
    object miFolder: TMenuItem
      Caption = 'Folder...'
      OnClick = miFolderClick
    end
  end
  object tUpdate: TTimer
    Enabled = False
    Interval = 500
    OnTimer = tUpdateTimer
    Left = 128
    Top = 24
  end
end
