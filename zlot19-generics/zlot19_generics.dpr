program zlot19_generics;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  DynArr in 'DynArr.pas',
  Unit1 in 'Unit1.pas',
  Unit2 in 'Unit2.pas',
  Unit3 in 'Unit3.pas';

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
