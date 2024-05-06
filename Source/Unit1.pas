unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, XPMan, ShellAPI, IniFiles, ExtCtrls, ShlObj;

type
  TMain = class(TForm)
    NewBtn: TButton;
    ShowBtn: TButton;
    XPManifest: TXPManifest;
    UndoBtn: TButton;
    PathEdt: TEdit;
    SelectFolderBtn: TButton;
    SetPathBtn: TButton;
    SaveHistoryCB: TCheckBox;
    FolderPathLbl: TLabel;
    FileNamePanel: TPanel;
    ExcludeExtBtn: TButton;
    AboutLbl: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure NewBtnClick(Sender: TObject);
    procedure UndoBtnClick(Sender: TObject);
    procedure ShowBtnClick(Sender: TObject);
    procedure SelectFolderBtnClick(Sender: TObject);
    procedure SetPathBtnClick(Sender: TObject);
    procedure SaveHistoryCBClick(Sender: TObject);
    procedure AboutLblClick(Sender: TObject);
    procedure ExcludeExtBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Main: TMain;
  RandomFiles, ShowedFiles: TStringList;
  ExcludeExts, RandomFileName: string;

  ID_ALL_FILES_SHOWED, ID_SELECT_FOLDER, ID_ENTER_EXCLUDE_EXTS, ID_LAST_UPDATE, ID_ABOUT_TITLE: string;

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
  SR: TSearchRec;
begin
  if FindFirst(Path + '*.*', faAnyFile, SR) = 0 then begin
    repeat
      Application.ProcessMessages;
      if (SR.name <> '.') and (SR.name <> '..') then

        if (SR.Attr and faDirectory) <> faDirectory then begin
          if (Pos(AnsiLowerCase(ExtractFileExt(SR.Name)), ExcludeExts) = 0) and
             (Pos(sr.Name, ShowedFiles.Text) = 0) then
            RandomFiles.Add(Path + SR.Name)
        end else
          ScanDir(Path + SR.Name + '\');

    until FindNext(SR) <> 0;
    FindClose(SR);
  end;
end;

function GetNameByPath(FilePath: string): string;
begin
  Result:=Copy(FilePath, 4, Length(FilePath) - 4);
  Result:=StringReplace(Result, ' ', '', [rfReplaceAll]);
  Result:=StringReplace(Result, '\', '_', [rfReplaceAll]);
end;

procedure RandomFile;
begin
  ScanDir(Main.PathEdt.Text);

  if Main.SaveHistoryCB.Checked then
    if FileExists(ExtractFilePath(ParamStr(0)) + 'History\' + GetNameByPath(Main.PathEdt.Text) + '.txt') then
      ShowedFiles.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'History\' + GetNameByPath(Main.PathEdt.Text) + '.txt');

  if RandomFiles.Count > 0 then begin
    RandomFileName:=RandomFiles.Strings[Random(RandomFiles.Count)];
    if Main.SaveHistoryCB.Checked then begin
      ShowedFiles.Add(RandomFileName);
      Main.UndoBtn.Enabled:=true;
    end;
  end else
    RandomFileName:=ID_ALL_FILES_SHOWED;

  if Main.SaveHistoryCB.Checked then begin
    if not DirectoryExists(ExtractFilePath(ParamStr(0)) + 'History\') then CreateDir(ExtractFilePath(ParamStr(0)) + 'History\');
    ShowedFiles.SaveToFile(ExtractFilePath(ParamStr(0)) + 'History\' + GetNameByPath(Main.PathEdt.Text) + '.txt');
  end;

  Main.FileNamePanel.Caption:=CutStr(ExtractFileName(RandomFileName), 33);
  Main.FileNamePanel.Hint:=ExtractFileName(RandomFileName);
end;

procedure TMain.FormCreate(Sender: TObject);
var
  Ini: TIniFile;
begin
  Ini:=TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Config.ini');
  PathEdt.Text:=Ini.ReadString('Main', 'Path', GetEnvironmentVariable('USERPROFILE') + '\Desktop\');
  SaveHistoryCB.Checked:=Ini.ReadBool('Main', 'FilesHistory', false);
  ExcludeExts:=Ini.ReadString('Main', 'ExcludeExts', '.pas');
  Ini.Free;

  if GetLocaleInformation(LOCALE_SENGLANGUAGE) = 'Russian' then begin
    ID_ALL_FILES_SHOWED:='Все файлы показаны';
    ID_SELECT_FOLDER:='Выберите папку';
    ID_ENTER_EXCLUDE_EXTS:='Введите расширения, например ".bat|.exe":';
    ID_LAST_UPDATE:='Последнее обновление:';
    ID_ABOUT_TITLE:='О программе...';
  end else begin
    Caption:='Random file';
    NewBtn.Caption:='New';
    ShowBtn.Caption:='Show';
    UndoBtn.Caption:='Undo';
    ID_ALL_FILES_SHOWED:='All files showed';
    FileNamePanel.Caption:='Random file';
    FolderPathLbl.Caption:='Folder path:';
    ID_SELECT_FOLDER:='Select folder';
    SelectFolderBtn.Caption:='Select';
    SetPathBtn.Caption:='By default';
    ExcludeExtBtn.Caption:='Exclude exts';
    ExcludeExtBtn.ShowHint:=false;
    ID_ENTER_EXCLUDE_EXTS:='Enter extensions, for example ".bat|.exe":';
    SaveHistoryCB.Caption:='Exclude previously shown files';
    ID_LAST_UPDATE:='Last update:';
    ID_ABOUT_TITLE:='About...';
  end;
  Application.Title:=Caption;
  RandomFiles:=TStringList.Create;
  ShowedFiles:=TStringList.Create;
  Randomize;
  RandomFile;
end;

procedure TMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  RandomFiles.Free;
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
  if not DirectoryExists(ExtractFilePath(ParamStr(0)) + 'History\') then CreateDir(ExtractFilePath(ParamStr(0)) + 'History\');
  ShowedFiles.SaveToFile(ExtractFilePath(ParamStr(0)) + 'History\' + GetNameByPath(Main.PathEdt.Text) + '.txt');
  Main.UndoBtn.Enabled:=false;
end;

procedure TMain.ShowBtnClick(Sender: TObject);
begin
  if (RandomFileName <> '') and (RandomFileName <> ID_ALL_FILES_SHOWED) then
    ShellExecute(0, 'open', 'explorer', PChar('/select, "' + RandomFileName + '"'), nil, SW_SHOW);
end;

function BrowseFolderDialog(Title:PChar):string;
var
  TitleName: string;
  lpItemId: pItemIdList;
  BrowseInfo: TBrowseInfo;
  DisplayName: array[0..MAX_PATH] of Char;
  TempPath: array[0..MAX_PATH] of Char;
begin
  FillChar(BrowseInfo, SizeOf(TBrowseInfo), #0);
  BrowseInfo.hWndOwner:=GetDesktopWindow;
  BrowseInfo.pSzDisplayName:=@DisplayName;
  TitleName:=Title;
  BrowseInfo.lpsztitle:=PChar(TitleName);
  BrowseInfo.ulflags:=bIf_ReturnOnlyFSDirs;
  lpItemId:=shBrowseForFolder(BrowseInfo);
  if lpItemId <> nil then begin
    shGetPathFromIdList(lpItemId, TempPath);
    Result:=TempPath;
    GlobalFreePtr(lpItemId);
  end;
end;

procedure TMain.SelectFolderBtnClick(Sender: TObject);
var
  TempPath: string;
begin
  TempPath:=BrowseFolderDialog(PChar(ID_SELECT_FOLDER));
  if TempPath = '' then Exit;
  if TempPath[Length(TempPath)] <> '\' then
    TempPath:=TempPath + '\';
  PathEdt.Text:=TempPath;
  RandomFiles.Clear;
  ShowedFiles.Clear;
end;

procedure TMain.SetPathBtnClick(Sender: TObject);
var
  Ini: TIniFile;
begin
  Ini:=TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Config.ini');
  Ini.WriteString('Main', 'Path', PathEdt.Text);
  Ini.Free;
end;

procedure TMain.SaveHistoryCBClick(Sender: TObject);
var
  Ini: TIniFile;
begin
  Ini:=TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Config.ini');
  Ini.WriteBool('Main', 'FilesHistory', SaveHistoryCB.Checked);
  Ini.Free;
end;

procedure TMain.AboutLblClick(Sender: TObject);
begin
  Application.MessageBox(PChar(Caption + ' 1.1' + #13#10 +
  ID_LAST_UPDATE + ' 06.05.24' + #13#10 +
  'https://r57zone.github.io' + #13#10 +
  'r57zone@gmail.com'), PChar(ID_ABOUT_TITLE), MB_ICONINFORMATION);
end;

procedure TMain.ExcludeExtBtnClick(Sender: TObject);
var
  Ini: TIniFile;
begin
  Ini:=TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Config.ini');
  ExcludeExts:=InputBox(Caption, ID_ENTER_EXCLUDE_EXTS, ExcludeExts);
  Ini.WriteString('Main', 'ExcludeExts', ExcludeExts);
  Ini.Free;
end;

end.
