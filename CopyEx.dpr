program CopyEx;

uses
  Forms,
  UMain in 'UMain.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Extended Copy - BENBAC SOFT';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
