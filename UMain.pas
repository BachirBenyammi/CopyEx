{retirer le dossier parrent ExtractDirPath
ex: c:\bnebac\file => benbac
}
unit UMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, FileCtrl, ComCtrls, ExtCtrls, Gauges, ShellAPI,
  Menus, Spin, Math, Mask;

type
  TMainForm = class(TForm)
    OD: TOpenDialog;
    pMenu: TPopupMenu;
    miFile: TMenuItem;
    miFolder: TMenuItem;
    gbFileName: TGroupBox;
    lbSize: TLabel;
    Lab_Size: TLabel;
    Label3: TLabel;
    Lab_Elapsed_Time: TLabel;
    FileGauge: TGauge;
    gbTotal: TGroupBox;
    Label7: TLabel;
    lbAllSize: TLabel;
    Label9: TLabel;
    lbAllElapsed: TLabel;
    Lab_Time_Left: TLabel;
    Label2: TLabel;
    Lab_Speed: TLabel;
    lbSpeed: TLabel;
    lbAllLeft: TLabel;
    Label20: TLabel;
    lbAllSpeed: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    lbFiles: TLabel;
    lbFolders: TLabel;
    Gauge: TGauge;
    tUpdate: TTimer;
    pnlSrcDest: TPanel;
    spSource: TSpeedButton;
    sbDist: TSpeedButton;
    Label5: TLabel;
    Label6: TLabel;
    Edit_Dest: TEdit;
    Edit_Src: TEdit;
    gbOptions: TGroupBox;
    Label1: TLabel;
    Label4: TLabel;
    cbUnit: TComboBox;
    seBlockSize: TSpinEdit;
    btnOK: TButton;
    cbAnimateP: TCheckBox;
    cbFileP: TCheckBox;
    cbTotalP: TCheckBox;
    pnlButtons: TPanel;
    btnStart: TButton;
    btnStop: TButton;
    btnOptions: TButton;
    pnlAnimate: TPanel;
    aCopy: TAnimate;
    procedure sbDistClick(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure miFileClick(Sender: TObject);
    procedure miFolderClick(Sender: TObject);
    procedure spSourceClick(Sender: TObject);
    procedure tUpdateTimer(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnOptionsClick(Sender: TObject);
  public
    function OpenFolder(var Folder: string): boolean;
    function OpenFile(var Folder: string): boolean;
    procedure CopyFile(FileSrc, FileDest: string);
    procedure ExCopyFile(FileSrc, FileDest: string);
    Procedure CopyDir(DirSrc, DirDest: string);
    Procedure ExCopyDir(DirSrc, DirDest: string);
    procedure CopyFileStream(FileSrc, FileDest: string);
    Function GetFileSize(FileName: String): LongInt;
    function strGetFileSize(FileName: String): string;
    procedure GetDirSize(var Folder: string; var CurrentFoldersSize: LongInt;
      var TotalFiles, TotalFolders: integer);
  end;

var
  MainForm: TMainForm;
  TimeFileCount, TimeFoldersCount : Cardinal;
  UnitSize: string = 'KB';
  UnitTaille: integer = 1024;
  BlockSize: integer = 256 * 1024;
  Cancel: LongBool = False;
  Copying, AnimatP, FileP, TotalP: Boolean;
  CurrentFileSize, CurrentFilePos, CurrentFoldersSize, CurrentFoldersPos: LongInt;
  NbrFilesCopy, NbrFoldersCopy, TotalFiles, TotalFolders: integer;
  CurrentFile, CurrentFolder: string;

implementation

uses StrUtils;

{$R *.dfm}

function FormatLongDate(Value: TDateTime): string;
var
  Buffer: array[0..1023] of Char;
  SystemTime: TSystemTime;
begin
{$IFDEF RX_D3}
  DateTimeToSystemTime(Value, SystemTime);
{$ELSE}
  with SystemTime do begin
    DecodeDate(Value, wYear, wMonth, wDay);
    DecodeTime(Value, wHour, wMinute, wSecond, wMilliseconds);
  end;
{$ENDIF}
  SetString(Result, Buffer, GetDateFormat(GetThreadLocale, DATE_LONGDATE,
    @SystemTime, nil, Buffer, SizeOf(Buffer) - 1));
  Result := TrimRight(Result);
end;

function MSecToStr(mSec: Extended): string;
var
  dt : TDateTime;
begin
   dt := mSec / 86400000;
   Result := FormatDateTime('hh:nn:ss', Frac(dt));
end;

function GetElapsedTime(TimeCount : Cardinal): string;
begin
  result := MSecToStr(GetTickCount - TimeCount);
end;

function GetTimeLeft(FileSize, FilePos, TimeCount : Cardinal): string;
begin
  if FilePos = 0 then FilePos := 1;
 result := MSecToStr((GetTickCount - TimeCount) / FilePos * (FileSize - FilePos));
end;

function GetSpeed(FilePos, TimeCount : Cardinal): String;
var
  Speed: Double;
begin
  Speed := abs(GetTickCount - TimeCount);
  if Speed = 0 then Speed := 1;
  Speed := 1000 * (FilePos / UnitTaille ) / Speed;
  Result := FormatFloat('0.00', Speed);
end;

Function TMainForm.GetFileSize(FileName:String): LongInt;
var
  Search: TSearchRec;
begin
  If FindFirst(ExpandFileName(FileName), faAnyFile, Search) = 0 Then
    Result := Search.Size
  else
    result := 0;
end;

function TMainForm.strGetFileSize(FileName:String): string;
var
  FileSize: LongInt;
begin
  FileSize := GetFileSize(FileName);
  Result := FormatFloat('0.00', FileSize / UnitTaille) ;
end;

Function AddSlash(Filename:String):String;
begin
  result := FileName;
  if result[length(result)] <> '\' then
    result := result + '\'
end;

Function DelSlash(Filename:String):String;
begin
  result := FileName;
  if result[length(result)] = '\' then
    result := Copy(result, 0, Length(result) - 1);
end;

function GetParentDir(Filename: String): String;
var
  FirstD, LastD:integer;
begin
  FirstD := Pos('\', FileName);
  LastD := LastDelimiter('\', FileName);
  if FirstD = LastD then
    result := Copy(FileName, 0 , FirstD - 2)
  else if FirstD < LastD then
    begin
      FileName := DelSlash(FileName);
      LastD := LastDelimiter('\', FileName);
      result := Copy(FileName, LastD + 1, Length(FileName) - LastD + 1);
    end;
end;

function GetFreeMem: Cardinal;
 Var
  MemStat : TMemoryStatus;
begin
  MemStat.dwLength := sizeof(TMemoryStatus);
  GlobalMemoryStatus(MemStat);
  result := MemStat.dwAvailPhys;
end;

procedure TMainForm.CopyFileStream(FileSrc, FileDest: string);
var
  BufSize, N: Integer;
  Buffer: PChar;
  Count: Int64;
  SrcFile, DestFile: TFileStream;
begin
  SrcFile := TFileStream.Create(FileSrc, fmOpenRead or fmShareDenyWrite);
  try
    DestFile := TFileStream.Create(FileDest, fmCreate or fmOpenWrite);
    with FileGauge do
      try
        Count := CurrentFileSize;
        if Count > BlockSize then BufSize := BlockSize else BufSize := Count;
        GetMem(Buffer, BufSize);
        try
          while (Count <> 0) and (Cancel = False) do
            begin
              if Count > BufSize then N := BufSize else N := Count;
              SrcFile.Read(Buffer^, N);
              Application.ProcessMessages;
              DestFile.WriteBuffer(Buffer^, N);
              Dec(Count, N);
              Inc(CurrentFilePos, N);
              Inc(CurrentFoldersPos, N);
            end;
      except
        FreeAndNil(DestFile);
        raise;
      end;
    finally
      DestFile.Free;
    end;
  finally
    SrcFile.Free;
  end;
end;

function TMainForm.OpenFile(var Folder: string): boolean;
begin
  result := false;
  if od.Execute then
    begin
      Folder := Od.FileName;
      result := true;
    end;
end;

function TMainForm.OpenFolder(var Folder: string): boolean;
begin
  Folder := OD.InitialDir;
  result := SelectDirectory('Selectionner un dossier', Folder, Folder);
end;

procedure TMainForm.sbDistClick(Sender: TObject);
var
  src: string;
begin
  if OpenFolder(src) then
    Edit_Dest.Text := src;
end;

procedure TMainForm.CopyDir(DirSrc, DirDest: string);
begin

  GetDirSize(DirSrc, CurrentFoldersSize, TotalFiles, TotalFolders);
  if TotalP then
    begin
      lbAllSize.Caption := FormatFloat('0.00', CurrentFoldersSize / UnitTaille);
      lbFiles.Caption := '0/' + IntToStr(TotalFiles);
      lbFolders.Caption := '0/' + IntToStr(TotalFolders);
      Gauge.MaxValue := CurrentFoldersSize;
    end;
  if FileP then ///////////////////////////////////////
    begin
      Lab_Speed.Caption := '0.00';
      Lab_Elapsed_Time.Caption := '00:00:00';
      Lab_Time_Left.Caption := '00:00:00';
      FileGauge.Progress := 0;
    end;
  if AnimatP then
    begin
  //    pnlAnimate.Visible := True;
      aCopy.Active := True;
    end;
  TimeFoldersCount := GetTickCount;
  tUpdate.Enabled := true;

  ExCopyDir(DirSrc, DirDest);

  tUpdate.Enabled := false;
 { CurrentFile := '';   //////////////////////////////////////////////
  CurrentFolder := '';   //////////////////////////////////////////
  if FileP then  /////////////////////////////////////////////////////////////
    begin
      Lab_Size.Caption := '0.00';
      Lab_Speed.Caption := '0.00';
      Lab_Elapsed_Time.Caption := '00:00:00';
      Lab_Time_Left.Caption := '00:00:00';
      FileGauge.Progress := 0;
    end;
  if TotalP then
    begin
      lbAllSize.Caption := '0.00';
      lbAllSpeed.Caption := '0.00';
      lbAllElapsed.Caption := '00:00:00';
      lbAllLeft.Caption := '00:00:00';
      lbFiles.Caption := '0/0';
      lbFolders.Caption := '0/0';
      Gauge.Progress := 0;
    end;     }
  Copying := False;
  if AnimatP then aCopy.Stop;
  if TotalP then Gauge.Progress := CurrentFoldersSize;
end;

procedure TMainForm.CopyFile(FileSrc, FileDest: string);
begin
  CurrentFile := '';     //////////////////////////////////////
  CurrentFolder := '';
  CurrentFileSize := GetFileSize(FileSrc);    ////////////////////////
  CurrentFoldersSize := CurrentFileSize;
  TotalFiles := 1;
  if TotalP then
    begin
      lbAllSize.Caption := FormatFloat('0.00', CurrentFileSize / UnitTaille);
      lbAllSpeed.Caption := '0.00';
      lbAllElapsed.Caption :='00:00:00';
      lbAllLeft.Caption :='00:00:00';
      lbFiles.Caption := '1/1';
      lbFolders.Caption := '0/0';
      Gauge.MaxValue := CurrentFileSize;
      Gauge.Progress := 0;
    end;
  if AnimatP then
    begin
  //    pnlAnimate.Visible := True;
      aCopy.Active := True;
    end;
  TimeFoldersCount := GetTickCount;
  tUpdate.Enabled := true;

  ExCopyFile(FileSrc, FileDest);

  tUpdate.Enabled := false;
 { CurrentFile := '';               ////////////////////////////////
  if TotalP then    ////////////////////////////////////////////////
    begin
      lbAllSize.Caption := '0.00';
      lbAllSpeed.Caption := '0.00';
      lbAllElapsed.Caption :='00:00:00';
      lbAllLeft.Caption :='00:00:00';
      lbFiles.Caption := '0/0';
      Gauge.Progress := 0;
    end;          }
  Copying := False;
  if AnimatP then aCopy.Stop;
  if TotalP then Gauge.Progress := CurrentFileSize;
end;

procedure TMainForm.ExCopyFile(FileSrc, FileDest: string);
begin
  CurrentFilePos := 0;
  CurrentFile := ExtractFileName(FileSrc);
  CurrentFileSize := GetFileSize(FileSrc);
  if FileP then
    begin
      gbFileName.Caption := CurrentFolder + CurrentFile;    
      Lab_Size.Caption := FormatFloat('0.00', CurrentFileSize / UnitTaille);
      Lab_Speed.Caption := '0.00';
      Lab_Elapsed_Time.Caption := '00:00:00';
      Lab_Time_Left.Caption := '00:00:00';
      FileGauge.MaxValue :=  CurrentFileSize;
      FileGauge.Progress := 0;
      gbFileName.Caption := CurrentFolder + CurrentFile;
    end;
  TimeFileCount := GetTickCount;
  Inc (NbrFilesCopy);
  Copying := True;
  CopyFileStream(FileSrc, FileDest);
 { if FileP then     ///////////////////////////////////////////////////
    begin
      Lab_Size.Caption := '0.00';
      Lab_Speed.Caption := '0.00';
      Lab_Elapsed_Time.Caption := '00:00:00';
      Lab_Time_Left.Caption := '00:00:00';
      FileGauge.Progress := 0;
      gbFileName.Caption := '';
    end;    }
  if FileP then FileGauge.Progress := CurrentFileSize;
end;

Procedure TMainForm.ExCopyDir(DirSrc, DirDest: string);
var
  ItemSR, DirSR: TSearchRec;
  Rslt: Integer;
  function DirNote(Dir: String): Boolean;
  begin
    result := (Dir = '.') or (Dir = '..');
  end;
begin
  DirSrc := AddSlash(DirSrc);
  DirDest := AddSlash(DirDest);
  ForceDirectories(DirDest);
  Rslt := Findfirst(DirSrc + '*.*', faAnyFile + faHidden + faSysFile
    + faReadOnly, ItemSR);
  try
    while Rslt = 0 do
    begin
     ExCopyFile (Pchar(DirSrc + ItemSR.name), Pchar(DirDest + ItemSR.name));
     Rslt := FindNext(ItemSR);
    end;
  finally
    FindClose(ItemSR);
  end;
    Rslt := FindFirst(DirSrc + '*.*', faDirectory, DirSR);
    try
      while Rslt = 0 do
      begin
        if ((DirSR.Attr and faDirectory) = faDirectory) and not
          DirNote(DirSR.Name) then
            begin
              CurrentFolder := DirSR.Name + '\';
              Inc (NbrFoldersCopy);              
              ExCopyDir(DirSrc + DirSR.Name, DirDest + DirSR.Name);
            end;
        Rslt := FindNext(DirSR);
      end;
    finally
      FindClose(DirSR);
    end;
end;

procedure TMainForm.btnStartClick(Sender: TObject);
var
  Source, Dest: string;
begin
  Cancel := False;
  Source := Edit_Src.Text;
  Dest := AddSlash(Edit_Dest.Text);

  CurrentFile := '';
  CurrentFolder := '';
  NbrFilesCopy := 0;
  NbrFoldersCopy := 0;
  CurrentFileSize := 0;
  CurrentFilePos := 0;
  CurrentFoldersSize := 0;
  CurrentFoldersPos := 0;
  if DirectoryExists(Source) then
    CopyDir(Source, Dest + GetParentDir(Source))
  else if FileExists(Source) then
    CopyFile(Source, Dest +  ExtractFileName(Source))
  else
    ShowMessage('Error');
  Caption := 'Extended Copy - BENBAC SOFT';
  Caption := Application.Title
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  btnOKClick(nil);
end;

procedure TMainForm.btnStopClick(Sender: TObject);
begin
  if MessageDlg('Age you sure you want to cancel the copying ?',
    mtConfirmation, [MbYes, MbCancel], 0) = MrYes then
      Cancel := True;
end;

procedure TMainForm.miFileClick(Sender: TObject);
var
  src: string;
begin
  if OpenFile(src) then
    Edit_Src.Text := src;
end;

procedure TMainForm.miFolderClick(Sender: TObject);
var
  src: string;
begin
  if OpenFolder(src) then
    Edit_Src.Text := src;
end;

procedure TMainForm.spSourceClick(Sender: TObject);
begin
  pMenu.Popup(Left + spSource.Left + 15 , Top + spSource.Top + 40);
end;

procedure TMainForm.GetDirSize(var Folder: string;
  var CurrentFoldersSize: LongInt; var TotalFiles, TotalFolders: integer);
  procedure GetDirSizeEx(Folder: string);
  var
    ItemSR, DirSR: TSearchRec;
    Rslt: integer;

    function DirNote(Dir: String): Boolean;
    begin
      result := (Dir = '.') or (Dir = '..');
    end;
  begin
    Folder := AddSlash(Folder);
    Rslt := Findfirst(Folder + '*.*', faAnyFile + faHidden + faSysFile
      + faReadOnly, ItemSR);
    try
      while Rslt = 0 do
      begin
          CurrentFoldersSize := CurrentFoldersSize + ItemSR.Size;
          Inc(TotalFiles);
        Rslt := FindNext(ItemSR);
      end;
    finally
      FindClose(ItemSR);
    end;
      Rslt := FindFirst(Folder + '*.*', faDirectory, DirSR);
      try
        while Rslt = 0 do
        begin
          if ((DirSR.Attr and faDirectory) = faDirectory) and not
            DirNote(DirSR.Name) then
              begin
                Inc(TotalFolders);
                GetDirSizeEx(Folder + DirSR.Name);
              end;
          Rslt := FindNext(DirSR);
        end;
      finally
        FindClose(DirSR);
      end;
  end;
begin
  CurrentFoldersSize := 0;
  TotalFiles := 0;
  TotalFolders := 0;
  GetDirSizeEx(Folder);
end;

procedure TMainForm.tUpdateTimer(Sender: TObject);
begin
  Caption :=  FormatFloat('0', (CurrentFoldersPos / CurrentFoldersSize * 100))
    + '% Extended Copy - BENBAC SOFT [Copying ...]';
  Application.Title := Caption;
  if FileP then
    begin
      FileGauge.progress := CurrentFilePos;
      Lab_Time_Left.Caption := GetTimeLeft(CurrentFileSize, CurrentFilePos,
        TimeFileCount);
      Lab_Elapsed_Time.Caption := GetElapsedTime(TimeFileCount);
      Lab_Speed.Caption := GetSpeed(CurrentFilePos, TimeFileCount);
    end;
  if TotalP then
    begin
      Gauge.progress := CurrentFoldersPos;
      lbAllLeft.Caption := GetTimeLeft(CurrentFoldersSize, CurrentFoldersPos,
        TimeFoldersCount);
      lbAllElapsed.Caption := GetElapsedTime(TimeFoldersCount);
      lbAllSpeed.Caption := GetSpeed(CurrentFoldersPos, TimeFoldersCount);
      lbFolders.Caption := Format('%d/%d',[NbrFoldersCopy, TotalFolders]);
      lbFiles.Caption := Format('%d/%d', [NbrFilesCopy, TotalFiles]);
    end;
 // aCopy.Active := AnimatP;
end;

procedure TMainForm.btnOKClick(Sender: TObject);
begin
  AutoSize := False;
  UnitSize := cbUnit.Items[cbUnit.ItemIndex];
  case cbUnit.ItemIndex of
    0: UnitTaille := 1;
    1: UnitTaille := 1024;
    2: UnitTaille := 1048576;
    3: UnitTaille := 1073741824;
  end;
  lbSpeed.Caption := 'Speed(' + UnitSize + '/S):';
  lbSize.Caption := 'Size('+ UnitSize + '):';
  BlockSize := seBlockSize.Value * 1024;
  AnimatP := cbAnimateP.Checked;
  if Copying then aCopy.Active := AnimatP;
  pnlAnimate.Visible := AnimatP;
  FileP := cbFileP.Checked;
  gbFileName.Visible := FileP;
  TotalP := cbTotalP.Checked;
  gbTotal.Visible := TotalP;
  gbOptions.Visible := False;
  AutoSize := True;
end;

procedure TMainForm.btnOptionsClick(Sender: TObject);
begin
  gbOptions.Visible := not gbOptions.Visible;
end;

end.
