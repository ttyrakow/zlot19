unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, DynArr, Vcl.StdCtrls,
  Vcl.ComCtrls;

type
  TMatchResult = (homeWin = 0, draw, awayWin);
  TGoals = record
    home: Integer;
    away: Integer;
  end;

  TMatch = record
    saeson: string;
    matchDate: TDateTime;
    home: string;
    away: string;
    matchResult: TMatchResult;
    goals: TGoals;
    pinnacleOdds: TDynArr<Double>;
    oddsPortalOdds: TDynArr<Double>;
  end;

  TFMainForm = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    reducedLabel: TLabel;
    iifLabel: TLabel;
    captureResultLabel: TLabel;
    quizButton: TButton;
    iif1Button: TButton;
    iif2Button: TButton;
    captureButton: TButton;
    captureSetButton: TButton;
    captureInvokeButton: TButton;
    outOfMemoryButton: TButton;
    grid: TStringGrid;
    arrayTooLargeButton: TButton;
    logMemo: TMemo;
    intfProcStoreButton: TButton;
    intfProcInvokeButton: TButton;
    intfProcClearButton: TButton;
    clearLogButton: TButton;
    ladujWynikiButton: TButton;
    OpenDialog1: TOpenDialog;
    druzynaEdit: TEdit;
    CheckBox1: TLabel;
    Label1: TLabel;
    sortCombo: TComboBox;
    bestPinnacleButton: TButton;
    bestOddsportalButton: TButton;
    procedure quizButtonClick(Sender: TObject);
    procedure iif1ButtonClick(Sender: TObject);
    procedure iif2ButtonClick(Sender: TObject);
    procedure captureButtonClick(Sender: TObject);
    procedure captureInvokeButtonClick(Sender: TObject);
    procedure captureSetButtonClick(Sender: TObject);
    procedure outOfMemoryButtonClick(Sender: TObject);
    procedure arrayTooLargeButtonClick(Sender: TObject);
    procedure intfProcStoreButtonClick(Sender: TObject);
    procedure intfProcInvokeButtonClick(Sender: TObject);
    procedure intfProcClearButtonClick(Sender: TObject);
    procedure clearLogButtonClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ladujWynikiButtonClick(Sender: TObject);
    procedure druzynaEditChange(Sender: TObject);
    procedure bestPinnacleButtonClick(Sender: TObject);
    procedure bestOddsportalButtonClick(Sender: TObject);
  private
    { Private declarations }
    ekstraklasa: TDynArr<TMatch>;

    procedure render(const m: TDynArr<TMatch>);
    procedure matchDialog(const m: TMatch; book: string; odds: Double);


  public
    { Public declarations }
  end;

//  Tak niestety się nie da :(
//  TArrHlp<T> = record helper for TRawArr<T>
//    forEach, map, reduce, ...
//  end;

var
  FMainForm: TFMainForm;

implementation

{$R *.dfm}

uses
  System.Generics.Defaults;

const
  resultNames: array[TMatchResult] of string = (
    'wygr. gosp.', 'remis', 'wygr. gości'
  );

type
  iif<T> = class
  public
    class function iif(const cond: Boolean; const ifYes, ifNo: T): T;
  end;

//type TMyClass<T> = class
//public
//  item: T;
//  function isEqual(other: T): Boolean;
//end;
//function TMyClass<T>.isEqual(other: T): Boolean;
//begin
//  Result := self.item = other;
//end;


class function iif<T>.iif(const cond: Boolean; const ifYes, ifNo: T): T;
begin
  if cond then
    Result := ifYes
  else
    Result := ifNo;
end;

function iif(const cond: Boolean; const ifYes, ifNo: string): string;
begin
  if cond then
    Result := ifYes
  else
    Result := ifNo;
end;

var fcs: array[0..3] of TProc;

procedure TFMainForm.captureInvokeButtonClick(Sender: TObject);
var
  j: Integer;
begin
  for j := 0 to 3 do
    fcs[j]();
end;

procedure TFMainForm.captureSetButtonClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to 3 do
    fcs[i] :=
      procedure()
      begin
        captureResultLabel.Caption :=
          captureResultLabel.Caption + ' ' + i.ToString();
      end;
  captureResultLabel.Caption := 'Capture result:';
end;

procedure TFMainForm.clearLogButtonClick(Sender: TObject);
begin
  logMemo.Clear();
end;

procedure TFMainForm.druzynaEditChange(Sender: TObject);
begin
  render(
    ekstraklasa.filter(
      function(m: TMatch): Boolean
      begin
        Result :=
          (Pos(UpperCase(druzynaEdit.Text), UpperCase(m.home)) > 0)
          or
          (Pos(UpperCase(druzynaEdit.Text), UpperCase(m.away)) > 0);
      end
    )
  );
end;

procedure TFMainForm.FormCreate(Sender: TObject);
var
  col: Integer;
begin
  ekstraklasa := TDynArr<TMatch>.Create(0);
  col := 0;
  TDynArr<string>.from([
    'sezon', 'data', 'gospodarze', 'goście',
    'gole gosp.', 'gole gości', 'wynik',
    'Pinnacle gosp.', 'Pinnacle remis', 'Pinnacle goś',
    'Oddsportal gosp.', 'Oddsportal remis', 'Oddsportal goś.'
  ]).forEach(
    procedure(s: string)
    begin
      grid.Cells[col, 0] := s;
      col := col + 1;
    end
  );
  col := 0;
  TDynArr<Double>.from([
    1.5, 1.5, 2, 2,
    1, 1, 1,
    1.5, 1.5, 1.5,
    2, 2, 2
  ]).forEach(
    procedure(w: Double)
    begin
      grid.ColWidths[col] := Round(w * grid.DefaultColWidth);
      col := col + 1;
    end
  );
end;

procedure TFMainForm.FormDestroy(Sender: TObject);
begin
  FMainForm := nil;
end;

procedure TFMainForm.outOfMemoryButtonClick(Sender: TObject);
var
  a: array[1..100] of array of Byte;
  i: Integer;
begin
  // 100 x 1GB
  for i := 1 to 100 do
    SetLength(a[i], 1 * 1024 * 1024 * 1024);
end;

procedure TFMainForm.arrayTooLargeButtonClick(Sender: TObject);
var
  a: array of Double;
begin
  SetLength(a, 1 * 1024 * 1024 * 1024); // 1G x 8B = 8GB
end;

procedure TFMainForm.bestOddsportalButtonClick(Sender: TObject);
var
  bestm: TMatch;
begin
  if ekstraklasa.length = 0 then
    Exit;

  bestm := ekstraklasa.reduce<TMatch>(
    function(bm: TMatch; m: TMatch): TMatch
    var
      bmOdds, mOdds: Double;
    begin
      bmOdds := bm.oddsPortalOdds[Ord(bm.matchResult)];
      mOdds := m.oddsPortalOdds[Ord(m.matchResult)];
      if mOdds > bmOdds then
        Result := m
      else
        Result := bm;
    end,
    ekstraklasa[0]
  );

  matchDialog(bestm, 'Oddsportal', bestm.oddsPortalOdds[Ord(bestm.matchResult)]);
end;

procedure TFMainForm.bestPinnacleButtonClick(Sender: TObject);
var
  bestm: TMatch;
begin
  if ekstraklasa.length = 0 then
    Exit;

  bestm := ekstraklasa.reduce<TMatch>(
    function(bm: TMatch; m: TMatch): TMatch
    var
      bmOdds, mOdds: Double;
    begin
      bmOdds := bm.pinnacleOdds[Ord(bm.matchResult)];
      mOdds := m.pinnacleOdds[Ord(m.matchResult)];
      if mOdds > bmOdds then
        Result := m
      else
        Result := bm;
    end,
    ekstraklasa[0]
  );

  matchDialog(bestm, 'Pinnacle', bestm.pinnacleOdds[Ord(bestm.matchResult)]);
end;

procedure TFMainForm.captureButtonClick(Sender: TObject);
var
  fcs: array[0..3] of TProc;
  i, j: Integer;
begin
  for i := 0 to 3 do
    fcs[i] :=
      procedure()
      begin
        captureResultLabel.Caption :=
          captureResultLabel.Caption + ' ' + i.ToString();
      end;
  captureResultLabel.Caption := 'Capture result:';
  for j := 0 to 3 do
    fcs[j]();
end;

procedure TFMainForm.iif1ButtonClick(Sender: TObject);
var a: array of string;
begin
  a := [ 'Udało się!', 'Coś innego'];
  iifLabel.Caption := iif(Length(a) > 0, a[0], 'Brak danych');
end;

procedure TFMainForm.iif2ButtonClick(Sender: TObject);
var a: array of string;
begin
  SetLength(a, 0);
  iifLabel.Caption := iif(Length(a) > 0, a[0], 'Brak danych');
end;

procedure TFMainForm.quizButtonClick(Sender: TObject);
const mnoznik = 3;
const prog = 100;
var tab: TDynArr<Integer>;
begin
  tab := [10, 20, 30, 40, 50];
  var res := tab
    .map<Integer>(
      function(it: Integer): Integer
      begin
        Result := it * mnoznik;
      end
    )
    .filter(
      function (it: Integer): Boolean
      begin
        Result := it > prog;
      end
    )
    .reduce<Integer>(
      function (acc, it: Integer): Integer
      begin
        Result := acc + it;
      end, 0
    );
    // res = 270
  reducedLabel.Caption := 'Reduced: ' + res.ToString();
end;

procedure TFMainForm.render(const m: TDynArr<TMatch>);
var
  r: Integer;
  comparer: TComparison<TMatch>;
begin
  if m.length = 0 then
  begin
    grid.RowCount := grid.FixedRows + 1;
    for r := 0 to grid.ColCount - 1 do
      grid.Cells[r, grid.FixedRows] := '';
    Exit;
  end;
  grid.RowCount := m.length + grid.FixedRows;
  r := grid.FixedRows;

  case sortCombo.ItemIndex of
    // łączna liczba strzelonych goli
    1: comparer :=
      function(const m1, m2: TMatch): Integer
      begin
        Result := m1.goals.home + m1.goals.away - m2.goals.home - m2.goals.away;
      end
    ;
    // liczba goli strzelonych na wyjeździe
    2: comparer :=
      function(const m1, m2: TMatch): Integer
      begin
        Result := m1.goals.away - m2.goals.away;
      end
    ;
    // liczba goli strzelonych u siebie
    3: comparer :=
      function(const m1, m2: TMatch): Integer
      begin
        Result := m1.goals.home - m2.goals.home;
      end
    ;
    // w p.p. wg daty meczu
    else comparer :=
      function(const m1, m2: TMatch): Integer
      begin
        Result := Round(Int(m1.matchDate - m2.matchDate));
      end
    ;
  end;

  m
  .sorted(comparer)
  .map< TDynArr<string> >(
    function(match: TMatch): TDynArr<string>
    begin
      Result := [
        match.saeson,
        DateTimeToStr(match.matchDate),
        match.home,
        match.away,
        IntToStr(match.goals.home),
        IntToStr(match.goals.away),
        resultNames[match.matchResult],
        FloatToStr(match.pinnacleOdds[0]),
        FloatToStr(match.pinnacleOdds[1]),
        FloatToStr(match.pinnacleOdds[2]),
        FloatToStr(match.oddsPortalOdds[0]),
        FloatToStr(match.oddsPortalOdds[1]),
        FloatToStr(match.oddsPortalOdds[2])
      ];
    end
  ).forEach(
    procedure(row: TDynArr<string>)
    var
      c: Integer;
    begin
      c := grid.FixedCols;
      row.forEach(
        procedure(val: string)
        begin
          grid.Cells[c, r] := val;
          c := c + 1;
        end
      );
      r := r + 1;
    end
  );
end;

//var
//  p: TProc<Integer>;
//procedure setProc(toAdd: Integer);
//begin
//  p := Procedure(it: Integer)
//       begin
//         writeln(toAdd + it);
//       end;
//end;
//procedure invokeProc(it: Integer);
//begin
//  p(it);
//end;
//procedure p2;
//begin
//  setProc(10);
//  //...
//  invokeProc(20); // stdout: 30
//  invokeProc(2); // stdout: 12
//end;


procedure log(const s: string);
begin
  if Assigned(FMainForm) then
    FMainForm.logMemo.Lines.Add(s);
end;

type
  IMyIntf = interface
    procedure logMe(const s: string);
  end;

  TMyClass = class(TInterfacedObject, IMyIntf)
  private
    name: string;
  public
    procedure logMe(const s: string);
    constructor Create(aName: string);
    destructor Destroy(); override;
  end;

{ TMyClass }

constructor TMyClass.Create(aName: string);
begin
  inherited Create();
  name := aName;
  log('TMyClass object created, named: ' + name);
end;

destructor TMyClass.Destroy;
begin
  log('TMyClass object named ' + name + ' destroyed');
  inherited;
end;

procedure TMyClass.logMe(const s: string);
begin
  log('TMyClass object named ' + name + ' logs: ' + s);
end;

var
  pr: TProc;

procedure TFMainForm.intfProcStoreButtonClick(Sender: TObject);
var
  obj1, obj2: IMyIntf;
begin
  obj1 := TMyClass.Create('Object1');
  obj2 := TMyClass.Create('Object2');

  pr :=
    procedure()
    begin
      obj1.logMe('hello!');
      obj2.logMe('hello!');
    end;
end;

function toFloat(s: string): Double;
begin
  if s = '' then
    s := '0';
  Result := StrToFloat(StringReplace(s, '.', FormatSettings.DecimalSeparator, [rfReplaceAll]));
end;

procedure TFMainForm.ladujWynikiButtonClick(Sender: TObject);

  function tokenize(const line: string; const separator: string = ';'): TDynArr<string>;
  var
    colonPos, prevColonPos: Integer;
  begin
    Result := TDynArr<string>.Create(0);
    prevColonPos := 0;
    colonPos := Pos(separator, line, prevColonPos + 1);
    while colonPos > 0 do
    begin
      Result.push(Copy(line, prevColonPos + 1, colonPos - prevColonPos - 1));
      prevColonPos := colonPos;
      colonPos := Pos(separator, line, prevColonPos + 1);
    end;
    Result.push(Copy(line, prevColonPos + 1, Length(line) - prevColonPos))
  end;

var
  sl: TStringList;
  i: Integer;
  tokenized: TDynArr< TDynArr<string> >;
begin
  if not OpenDialog1.Execute() then
    Exit;

  sl := TStringList.Create();
  try
  try
    sl.LoadFromFile(OpenDialog1.FileName, TEncoding.UTF8);
    tokenized.length := sl.Count - 1; // pierwszy wiersz to nagłówki
    for i := 1 to sl.Count - 1 do
      tokenized[i - 1] := tokenize(sl[i], ';');

    ekstraklasa := tokenized.map<TMatch>(
      function(ms: TDynArr<string>): TMatch
      begin
        Result.saeson := ms[2];
        Result.matchDate :=
          EncodeDate(
            StrToInt(Copy(ms[3], 7, 4)),
            StrToInt(Copy(ms[3], 4, 2)),
            StrToInt(Copy(ms[3], 1, 2))
          ) +
          EncodeTime(
            StrToInt(Copy(ms[4], 1, 2)),
            StrToInt(Copy(ms[4], 4, 2)),
            0, 0
          );
        Result.home := ms[5];
        Result.away := ms[6];
        if ms[9] = 'H' then
          Result.matchResult := homeWin
        else if ms[9] = 'A' then
          Result.matchResult := awayWin
        else
          Result.matchResult := draw;
        Result.goals.home := StrToInt(ms[7]);
        Result.goals.away := StrToInt(ms[8]);
        Result.pinnacleOdds :=
          [ toFloat(ms[10]), toFloat(ms[11]), toFloat(ms[12]) ];
        Result.oddsPortalOdds :=
          [ toFloat(ms[13]), toFloat(ms[14]), toFloat(ms[15]) ];
      end
    );
    render(ekstraklasa);
  except
    on e: Exception do
    begin
      Application.MessageBox(PChar(
        'Błąd przetwarzania pliku wyników Ekstraklasy:' + #13#10 +
        e.Message
      ), 'DynArrDemo', MB_ICONERROR);
      Exit;
    end;
  end;
  finally
    sl.Free();
  end;
end;

procedure TFMainForm.matchDialog(const m: TMatch; book: string; odds: Double);
begin
  Application.MessageBox(PChar(
    'Sezon: ' + m.saeson + #13#10 +
    'Data: ' + DateToStr(m.matchDate) + #13#10 +
    'Gospodarze: ' + m.home + #13#10 +
    'Goście: ' + m.away + #13#10 +
    'Wynik: ' + IntToStr(m.goals.home) + ' : ' + IntToStr(m.goals.away) + #13#10 +
    'Obstawienie w ' + book + ': ' + FloatToStr(odds) + ' : 1'
  ), 'Info', MB_ICONINFORMATION
  );
end;

procedure TFMainForm.intfProcInvokeButtonClick(Sender: TObject);
begin
  if Assigned(pr) then
    pr();
end;

procedure TFMainForm.intfProcClearButtonClick(Sender: TObject);
begin
  pr := nil;
end;

end.
