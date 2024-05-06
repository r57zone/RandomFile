unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, XPMan, ShellAPI, IniFiles;

type
  TMain = class(TForm)
    NewBtn: TButton;
    ShowBtn: TButton;
    FileNameLbl: TLabel;
    XPManifest: TXPManifest;
    UndoBtn: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure NewBtnClick(Sender: TObject);
    procedure UndoBtnClick(Sender: TObject);
    procedure ShowBtnClick(Sender: TObject);
    procedure FileNameLblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Main: TMain;
  RandomFiles, ShowedFiles: TStringList;
  MainPath, ExcludeExts, RandomFileName: string;
  FilesHistory: boolean;

  ID_ALL_FILES_SHOWED, ID_LAST_UPDATE, ID_ABOUT_TITLE: string;

implementation

{$R *.dfm}

function GetLocaleInformation(flag: integer): string;
var
  pcLCA: array [0..20] of char;
begin
  if GetLocaleInfo(LOCALE_SYSTEM_DEFAULT, flag, pcLCA, 19) <= 0 then
    pcLCA[0]:=#0;
  Result:=pcLCA;
end;

function CutStr(Str: string; CharCount: integer): string;
begin
  if Length(Str) > CharCount then
    Result:=Copy(Str, 1, CharCount - 3) + '...'
  else
    Result:=Str;
end;

procedure ScanDir(Path: string);
var
  sr: TSearchRec;
begin
  if FindFirst(Path + '*.*', faAnyFile, sr) = 0 then begin
    repeat
      Application.ProcessMessages;
      if (sr.name <> '.') and (sr.name <> '..') then

        if (sr.Attr and faDirectory) <> faDirectory then begin
          if (Pos(AnsiLowerCase(ExtractFileExt(sr.Name)), ExcludeExts) = 0) and
             (Pos(sr.Name, ShowedFiles.Text) = 0) then
            RandomFiles.Add(Path + sr.Name)
        end else
          ScanDir(Path + sr.Name + '\');

    until FindNext(sr) <> 0;
    FindClose(sr);
  end;
end;

procedure RandomFile;
begin
  ScanDir(MainPath);
  if RandomFiles.Count > 0 then begin
    RandomFileName:=RandomFiles.Strings[Random(RandomFiles.Count)];
    Main.UndoBtn.Enabled:=true;
    if FilesHistory then
      ShowedFiles.Add(RandomFileName);
  end else RandomFileName:=ID_ALL_FILES_SHOWED;
  Main.FileNameLbl.Caption:=CutStr(ExtractFileName(RandomFileName), 40);
end;

procedure TMain.FormCreate(Sender: TObject);
var
  Ini: TIniFile;
begin
  Ini:=TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Config.ini');
  MainPath:=Ini.ReadString('Main', 'Path', 'C:\Program Files');
  if MainPath[Length(MainPath)] <> '\' then MainPath:=MainPath + '\';
  FilesHistory:=Ini.ReadBool('Main', 'FilesHistory', true);
  ExcludeExts:=Ini.ReadString('Main', 'ExcludeExts', '.pas');
  Ini.Free;

  if GetLocaleInformation(LOCALE_SENGLANGUAGE) = 'Russian' then begin
    ID_ALL_FILES_SHOWED:='Все файлы показаны';
    ID_LAST_UPDATE:='Последнее обновление:';
    ID_ABOUT_TITLE:='О программе...';
  end else begin
    Caption:='Random file';
    NewBtn.Caption:='New';
    ShowBtn.Caption:='Show';
    UndoBtn.Caption:='Undo';
    ID_ALL_FILES_SHOWED:='All files showed';
    ID_LAST_UPDATE:='Last update:';
    ID_ABOUT_TITLE:='About...';
  end;
  Application.Title:=Caption;
  RandomFiles:=TStringList.Create;
  ShowedFiles:=TStringList.Create;
  if FileExists(ExtractFilePath(ParamStr(0)) + 'Showed.txt') then
    ShowedFiles.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'Showed.txt');
  Randomize;
  RandomFile;
end;

procedure TMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  RandomFiles.Free;
  if FilesHistory then
    ShowedFiles.SaveToFile(ExtractFilePath(ParamStr(0)) + 'Showed.txt');
  ShowedFiles.Free;
end;

procedure TMain.NewBtnClick(Sender: TObject);
begin
  RandomFile;
end;

procedure TMain.UndoBtnClick(Sender: TObject);
begin
  if ShowedFiles.Count > 0 then
    ShowedFiles.Delete(ShowedFiles.Count - 1);
  Main.UndoBtn.Enabled:=false;
end;

procedure TMain.ShowBtnClick(Sender: TObject);
begin
  if (RandomFileName <> '') and (RandomFileName <> ID_ALL_FILES_SHOWED) then
    ShellExecute(0, 'open', 'explorer', PChar('/select, "' + RandomFileName + '"'), nil, SW_SHOW);
end;

procedure TMain.FileNameLblClick(Sender: TObject);
begin
  Application.MessageBox(PChar(Caption + #13#10 +
  ID_LAST_UPDATE + ' 18.07.2018' + #13#10 +
  'https://r57zone.github.io' + #13#10 +
  'r57zone@gmail.com'), PChar(ID_ABOUT_TITLE), MB_ICONINFORMATION);
end;

end.
