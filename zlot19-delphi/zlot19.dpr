program zlot19;

uses
  Vcl.Forms,
  MainForm in 'MainForm.pas' {FMainForm},
  DynArr in 'DynArr.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFMainForm, FMainForm);
  Application.Run;
end.
