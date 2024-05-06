object Main: TMain
  Left = 192
  Top = 122
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1057#1083#1091#1095#1072#1081#1085#1099#1081' '#1092#1072#1081#1083
  ClientHeight = 192
  ClientWidth = 248
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object FolderPathLbl: TLabel
    Left = 8
    Top = 90
    Width = 75
    Height = 13
    Caption = #1055#1091#1090#1100' '#1076#1086' '#1087#1072#1087#1082#1080':'
  end
  object AboutLbl: TLabel
    Left = 231
    Top = 170
    Width = 6
    Height = 13
    Alignment = taCenter
    Caption = '?'
    OnClick = AboutLblClick
  end
  object NewBtn: TButton
    Left = 7
    Top = 56
    Width = 75
    Height = 25
    Caption = #1053#1086#1074#1099#1081
    TabOrder = 0
    OnClick = NewBtnClick
  end
  object ShowBtn: TButton
    Left = 87
    Top = 56
    Width = 75
    Height = 25
    Caption = #1055#1086#1082#1072#1079#1072#1090#1100
    TabOrder = 1
    OnClick = ShowBtnClick
  end
  object UndoBtn: TButton
    Left = 167
    Top = 56
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1080#1090#1100
    Enabled = False
    TabOrder = 2
    OnClick = UndoBtnClick
  end
  object PathEdt: TEdit
    Left = 8
    Top = 106
    Width = 233
    Height = 21
    ReadOnly = True
    TabOrder = 3
  end
  object SelectFolderBtn: TButton
    Left = 7
    Top = 136
    Width = 75
    Height = 25
    Caption = #1042#1099#1073#1088#1072#1090#1100
    TabOrder = 4
    OnClick = SelectFolderBtnClick
  end
  object SetPathBtn: TButton
    Left = 87
    Top = 136
    Width = 75
    Height = 25
    Caption = #1055#1086' '#1091#1084#1086#1083#1095'.'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    OnClick = SetPathBtnClick
  end
  object SaveHistoryCB: TCheckBox
    Left = 8
    Top = 168
    Width = 217
    Height = 17
    Caption = #1048#1089#1082#1083#1102#1095#1080#1090#1100' '#1088#1072#1085#1077#1077' '#1087#1086#1082#1072#1079#1072#1085#1085#1099#1077' '#1092#1072#1081#1083#1099
    TabOrder = 6
    OnClick = SaveHistoryCBClick
  end
  object FileNamePanel: TPanel
    Left = 8
    Top = 8
    Width = 233
    Height = 41
    Caption = #1057#1083#1091#1095#1072#1081#1085#1099#1081' '#1092#1072#1081#1083
    ParentShowHint = False
    ShowHint = True
    TabOrder = 7
  end
  object ExcludeExtBtn: TButton
    Left = 167
    Top = 136
    Width = 75
    Height = 25
    Hint = #1048#1089#1082#1083#1102#1095#1080#1090#1100' '#1088#1072#1089#1096#1080#1088#1077#1085#1080#1103
    Caption = #1048#1089#1082#1083'. '#1088#1072#1089#1096'.'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 8
    OnClick = ExcludeExtBtnClick
  end
  object XPManifest: TXPManifest
    Left = 160
    Top = 88
  end
end
