object Main: TMain
  Left = 192
  Top = 122
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1057#1083#1091#1095#1072#1081#1085#1099#1081' '#1092#1072#1081#1083
  ClientHeight = 67
  ClientWidth = 249
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
  object FileNameLbl: TLabel
    Left = 8
    Top = 48
    Width = 3
    Height = 13
    OnClick = FileNameLblClick
  end
  object NewBtn: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = #1053#1086#1074#1099#1081
    TabOrder = 0
    OnClick = NewBtnClick
  end
  object ShowBtn: TButton
    Left = 88
    Top = 8
    Width = 75
    Height = 25
    Caption = #1055#1086#1082#1072#1079#1072#1090#1100
    TabOrder = 1
    OnClick = ShowBtnClick
  end
  object UndoBtn: TButton
    Left = 168
    Top = 8
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1080#1090#1100
    Enabled = False
    TabOrder = 2
    OnClick = UndoBtnClick
  end
  object XPManifest: TXPManifest
    Left = 96
    Top = 40
  end
end
