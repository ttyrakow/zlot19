object FMainForm: TFMainForm
  Left = 0
  Top = 0
  Caption = 'Zlot19 - DynArr'
  ClientHeight = 653
  ClientWidth = 863
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    863
    653)
  PixelsPerInch = 96
  TextHeight = 16
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 847
    Height = 641
    ActivePage = TabSheet1
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Pr'#243'by do wyk'#322'adu'
      DesignSize = (
        839
        610)
      object reducedLabel: TLabel
        Left = 195
        Top = 27
        Width = 62
        Height = 16
        Caption = 'Reduced:'
      end
      object iifLabel: TLabel
        Left = 195
        Top = 74
        Width = 5
        Height = 16
      end
      object captureResultLabel: TLabel
        Left = 547
        Top = 58
        Width = 100
        Height = 16
        Caption = 'Capture result:'
      end
      object quizButton: TButton
        Left = 3
        Top = 24
        Width = 169
        Height = 25
        Caption = 'Wynik quiz'#39'u'
        TabOrder = 0
        OnClick = quizButtonClick
      end
      object iif1Button: TButton
        Left = 3
        Top = 55
        Width = 169
        Height = 25
        Caption = 'iif (pr'#243'ba 1)'
        TabOrder = 1
        OnClick = iif1ButtonClick
      end
      object iif2Button: TButton
        Left = 3
        Top = 86
        Width = 169
        Height = 25
        Caption = 'iif (pr'#243'ba 2)'
        TabOrder = 2
        OnClick = iif2ButtonClick
      end
      object captureButton: TButton
        Left = 355
        Top = 55
        Width = 169
        Height = 25
        Caption = 'Capture'
        TabOrder = 3
        OnClick = captureButtonClick
      end
      object captureSetButton: TButton
        Left = 355
        Top = 86
        Width = 169
        Height = 25
        Caption = 'Capture (set)'
        TabOrder = 4
        OnClick = captureSetButtonClick
      end
      object captureInvokeButton: TButton
        Left = 530
        Top = 86
        Width = 169
        Height = 25
        Caption = 'Capture (invoke)'
        TabOrder = 5
        OnClick = captureInvokeButtonClick
      end
      object outOfMemoryButton: TButton
        Left = 3
        Top = 117
        Width = 169
        Height = 25
        Caption = 'Brak pami'#281'ci'
        TabOrder = 6
        OnClick = outOfMemoryButtonClick
      end
      object arrayTooLargeButton: TButton
        Left = 3
        Top = 148
        Width = 169
        Height = 25
        Caption = 'Za du'#380'a tablica'
        TabOrder = 7
        OnClick = arrayTooLargeButtonClick
      end
      object logMemo: TMemo
        Left = 240
        Top = 328
        Width = 596
        Height = 279
        Anchors = [akLeft, akTop, akRight, akBottom]
        TabOrder = 8
      end
      object intfProcStoreButton: TButton
        Left = 3
        Top = 344
        Width = 231
        Height = 25
        Caption = 'Store proc with intf'
        TabOrder = 9
        OnClick = intfProcStoreButtonClick
      end
      object intfProcInvokeButton: TButton
        Left = 3
        Top = 375
        Width = 231
        Height = 25
        Caption = 'Invoke proc with intf'
        TabOrder = 10
        OnClick = intfProcInvokeButtonClick
      end
      object intfProcClearButton: TButton
        Left = 3
        Top = 406
        Width = 231
        Height = 25
        Caption = 'Clear proc with intf'
        TabOrder = 11
        OnClick = intfProcClearButtonClick
      end
      object clearLogButton: TButton
        Left = 72
        Top = 480
        Width = 162
        Height = 25
        Caption = 'Clear log'
        TabOrder = 12
        OnClick = clearLogButtonClick
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Ekstraklasa'
      ImageIndex = 1
      DesignSize = (
        839
        610)
      object CheckBox1: TLabel
        Left = 24
        Top = 63
        Width = 97
        Height = 16
        Alignment = taRightJustify
        Caption = 'Tylko dru'#380'yna:'
      end
      object Label1: TLabel
        Left = 41
        Top = 111
        Width = 80
        Height = 16
        Alignment = taRightJustify
        Caption = 'Sortowanie:'
      end
      object grid: TStringGrid
        Left = 3
        Top = 256
        Width = 833
        Height = 351
        Anchors = [akLeft, akTop, akRight, akBottom]
        ColCount = 13
        DefaultColWidth = 70
        FixedCols = 0
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goThumbTracking]
        TabOrder = 0
      end
      object ladujWynikiButton: TButton
        Left = 16
        Top = 16
        Width = 233
        Height = 25
        Caption = 'Za'#322'aduj wyniki Ekstraklasy'
        TabOrder = 1
        OnClick = ladujWynikiButtonClick
      end
      object druzynaEdit: TEdit
        Left = 216
        Top = 60
        Width = 177
        Height = 24
        TabOrder = 2
        OnChange = druzynaEditChange
      end
      object sortCombo: TComboBox
        Left = 216
        Top = 108
        Width = 385
        Height = 24
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 3
        Text = 'wg daty meczu'
        OnChange = druzynaEditChange
        Items.Strings = (
          'wg daty meczu'
          'wg '#322#261'cznej liczby strzelonych goli'
          'wg liczby goli strzelonych na wyje'#378'dzie'
          'wg liczby goli strzelonych u siebie')
      end
      object bestPinnacleButton: TButton
        Left = 16
        Top = 160
        Width = 377
        Height = 25
        Caption = 'Najlepsze obstawienie w Pinnacle'
        TabOrder = 4
        OnClick = bestPinnacleButtonClick
      end
      object bestOddsportalButton: TButton
        Left = 16
        Top = 191
        Width = 377
        Height = 25
        Caption = 'Najlepsze obstawienie w OddsPortal'
        TabOrder = 5
        OnClick = bestOddsportalButtonClick
      end
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'csv'
    Filter = 'Pliki CSV (*.csv)|*.csv|Wszystkie pliki (*.*)|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Wybierz plik z wynikami Ekstraklasy'
    Left = 276
    Top = 51
  end
end
