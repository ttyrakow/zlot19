///  Dynamic arrays based on JavaScript Array functionality.
///  author: Tomasz Tyrakowski (t.tyrakowski@sol-system.pl)
///  license: public domain

unit DynArr;

interface
uses SysUtils, System.Generics.Collections, System.Generics.Defaults;

type
  ///  Raw array of values of type T.
  TRawArr<T> = array of T;

  ///  Dynamic JS-like array of values of type T.
  TDynArr<T> = record
  private
    _items: TRawArr<T>;

    // property accessors
    function getLength(): Integer;
    procedure setLength(newLength: Integer);
    function getItem(itemNo: Integer): T;
    procedure setItem(itemNo: Integer; const newValue: T);

  public
    ///  Create an array with the initial length as specified.
    constructor create(const initialLength: Integer);

    ///  Creates an array from a raw array
    constructor from(const a: TRawArr<T>; startIndex: Integer = -1; endIndex: Integer = -1); overload;

    ///  Creates an array from another TDynArr
    constructor from(const a: TDynArr<T>); overload;

    ///  The length of the array.
    property length: Integer read getLength write setLength;

    ///  Access individual items of the array.
    property items[itemNo: Integer]: T read getItem write setItem; default;

    ///  Get a raw array of values.
    property raw: TRawArr<T> read _items write _items;

    ///  Array manipulation routines.

    ///  Joins two or more arrays, and returns a copy of the joined arrays.
    function concat(const a: TDynArr<T>): TDynArr<T>;

    ///  Checks if every element in an array pass a test.
    function every(test: TFunc<T, Integer, Boolean>): Boolean; overload;
    function every(test: TFunc<T, Boolean>): Boolean; overload;

    ///  Fill the elements in an array with a static value.
    procedure fill(const val: T);

    ///  Creates a new array with every element in an array that pass a test.
    function filter(test: TFunc<T, Boolean>): TDynArr<T>;

    ///  Returns the value of the first element in an array that pass a test.
    ///  Raises an exception if there are no items passing the test.
    function find(test: TFunc<T, Boolean>): T;

    ///  Returns the index of the first element in an array that pass a test.
    function findIndex(test: TFunc<T, Boolean>): Integer;

    ///  Calls a function for each array element.
    procedure forEach(process: TProc<T>);

    ///  Check if an array contains the specified element.
    function includes(const val: T): Boolean;

    ///  Search the array for an element and returns its position.
    function indexOf(const val: T): Integer;

    ///  Joins all elements of an array into a string.
    function join(mapper: TFunc<T, string>; const separator: string = ''): string;

    ///  Search the array for an element, starting at the end, and returns its position.
    function lastIndexOf(const val: T): Integer;

    ///  Creates a new array with the result of calling a function for each array element.
    function map<S>(mapper: TFunc<T, S>): TDynArr<S>;

    ///  Removes the last element of an array, and returns that element.
    function pop(): T;

    ///  Adds new elements to the end of an array, and returns the new length.
    function push(const val: T): Integer;

    ///  Reduce the values of an array to a single value (going left-to-right).
    function reduce<S>(reducer: TFunc<S, T, Integer, S>; const initialValue: S): S; overload;
    function reduce<S>(reducer: TFunc<S, T, S>; const initialValue: S): S; overload;

    ///  Reduce the values of an array to a single value (going right-to-left).
    function reduceRight<S>(reducer: TFunc<S, T, Integer, S>; const initialValue: S): S; overload;
    function reduceRight<S>(reducer: TFunc<S, T, S>; const initialValue: S): S; overload;

    ///  Reverses the order of the elements in an array.
    procedure reverse();
    function reversed(): TDynArr<T>;

    ///  Removes the first element of an array, and returns that element.
    function shift(): T;

    ///  Selects a part of an array, and returns the new array.
    function slice(const startIndex, endIndex: Integer): TDynArr<T>;

    ///  Checks if any of the elements in an array pass a test.
    function some(test: TFunc<T, Integer, Boolean>): Boolean; overload;
    function some(test: TFunc<T, Boolean>): Boolean; overload;

    ///  Sorts the elements of an array.
    procedure sort(compare: TComparison<T>);
    function sorted(compare: TComparison<T>): TDynArr<T>;

    ///  Adds/removes items to/from an array, and returns the removed item(s).
    function splice(const startIndex, howMany: Integer; const newItems: TDynArr<T>): TDynArr<T>; overload;
    function splice(const startIndex, howMany: Integer): TDynArr<T>; overload;

    ///  Converts an array to a string, and returns the result.
    function toString(mapper: TFunc<T, string>): string;

    ///  Adds new elements to the beginning of an array, and returns the new length.
    function unshift(const toAdd: TDynArr<T>): Integer;

    ///  Operators

    ///  Implicit cast, e.g. const a: TDynArr<Integer> := [1, 2, 3];
    class operator Implicit(a: TRawArr<T>): TDynArr<T>;

    ///  Explicit cast, e.g. a := TDynArr<Integer>([1, 2, 3]);
    class operator Explicit(a: TRawArr<T>): TDynArr<T>;

    ///  Addition (concatenation), e.g. c := a + b;
    class operator Add(const a1, a2: TDynArr<T>): TDynArr<T>;

    ///  Multiply an array by an integer, creating an array with
    ///  n copies of a.
    class operator Multiply(const a: TDynArr<T>; const n: Integer): TDynArr<T>;

    ///  Check arrays for equality.
    class operator Equal(const a1, a2: TDynArr<T>): Boolean;

    ///  BitwiseAnd - return an array consisting of items common
    ///  to a1 and a2
    class operator BitwiseAnd(const a1, a2: TDynArr<T>): TDynArr<T>;

    ///  Checks whether two items of type T are equal (uses CompareMem).
    class function itemsEqual(const i1, i2: T): Boolean; static;

    ///  Swaps the values of two items of type T.
    class procedure swap(var i1, i2: T); static;

    ///  Returns an empty DynArray<T>.
    class function empty(): TDynArr<T>; static;
  end;

implementation

class operator TDynArr<T>.Add(const a1, a2: TDynArr<T>): TDynArr<T>;
begin
  Result := a1.concat(a2);
end;

class operator TDynArr<T>.BitwiseAnd(const a1, a2: TDynArr<T>): TDynArr<T>;
begin
  Result := a1.filter(
    function(it: T): Boolean
    begin
      Result := a2.includes(it);
    end
  );
end;

function TDynArr<T>.concat(const a: TDynArr<T>): TDynArr<T>;
var
  i: Integer;
begin
  Result := TDynArr<T>.create(self.length + a.length);
  for i := 0 to self.length - 1 do
    Result[i] := self._items[i];
  for i := 0 to a.length - 1 do
    Result[i + self.length] := a[i];
end;

constructor TDynArr<T>.create(const initialLength: Integer);
begin
  System.SetLength(self._items, initialLength);
end;

class function TDynArr<T>.empty: TDynArr<T>;
begin
  Result := TDynArr<T>.create(0);
end;

class operator TDynArr<T>.Equal(const a1, a2: TDynArr<T>): Boolean;
var
  i: Integer;
begin
  if a1.length = a2.length then
    Result := a1.every(
      function(it: T; idx: Integer): Boolean
      begin
        Result := TDynArr<T>.itemsEqual(it, a2[idx]);
      end
    )
  else
    Result := false;
end;

function TDynArr<T>.every(test: TFunc<T, Integer, Boolean>): Boolean;
var
  i: Integer;
begin
  Result := false;
  for i := 0 to self.length - 1 do
    if not test(self._items[i], i) then
      Exit;
  Result := true;
end;

function TDynArr<T>.every(test: TFunc<T, Boolean>): Boolean;
begin
  Result := self.every(
    function(val: T; idx: Integer): Boolean
    begin
      Result := test(val);
    end
  );
end;

class operator TDynArr<T>.Explicit(a: TRawArr<T>): TDynArr<T>;
begin
  Result := TDynArr<T>.from(a);
end;

procedure TDynArr<T>.fill(const val: T);
var
  i: Integer;
begin
  for i := 0 to self.length - 1 do
    self._items[i] := val;
end;

function TDynArr<T>.filter(test: TFunc<T, Boolean>): TDynArr<T>;
var
  i, ii: Integer;
begin
  Result := TDynArr<T>.create(self.length);
  ii := 0;
  for i := 0 to self.length - 1 do
    if test(self._items[i]) then
    begin
      Result[ii] := self._items[i];
      ii := ii + 1;
    end;
  Result.length := ii;
end;

function TDynArr<T>.find(test: TFunc<T, Boolean>): T;
var
  ii: Integer;
begin
  ii := self.findIndex(test);
  if ii >= 0 then
    Result := self._items[ii]
  else
    raise Exception.Create('The value is not present in the TDynArr.');
end;

function TDynArr<T>.findIndex(test: TFunc<T, Boolean>): Integer;
var
  i: Integer;
begin
  for i := 0 to self.length - 1 do
    if test(self._items[i]) then
    begin
      Result := i;
      Exit;
    end;
  Result := -1;
end;

procedure TDynArr<T>.forEach(process: TProc<T>);
var
  i: Integer;
begin
  for i := 0 to self.length - 1 do
    process(self._items[i]);
end;

constructor TDynArr<T>.from(const a: TDynArr<T>);
var
  i: Integer;
begin
  System.SetLength(self._items, a.length);
  for i := 0 to a.length - 1 do
    self._items[i] := a[i];
end;

constructor TDynArr<T>.from(const a: TRawArr<T>; startIndex: Integer = -1; endIndex: Integer = -1);
var
  i: Integer;
begin
  if startIndex < 0 then
    startIndex := 0;
  if endIndex < 0 then
    endIndex := System.Length(a);
  System.SetLength(self._items, endIndex - startIndex);
  for i := startIndex to endIndex - 1 do
    self._items[i - startIndex] := a[i];
end;

function TDynArr<T>.getItem(itemNo: Integer): T;
begin
  if itemNo < self.length then
    Result := self._items[itemNo]
  else
    raise ERangeError.CreateFmt('DynArr item index out of range: %d (max allowed: %d)', [itemNo, self.length]);
end;

function TDynArr<T>.getLength: Integer;
begin
  Result := System.Length(self._items);
end;

class operator TDynArr<T>.Implicit(a: TRawArr<T>): TDynArr<T>;
begin
  Result := TDynArr<T>.from(a);
end;

function TDynArr<T>.includes(const val: T): Boolean;
begin
  Result := self.indexOf(val) >= 0;
end;

function TDynArr<T>.indexOf(const val: T): Integer;
var
  i: Integer;
begin
  for i := 0 to self.length - 1 do
    if TDynArr<T>.itemsEqual(self._items[i], val) then
    begin
      Result := i;
      Exit;
    end;
  Result := -1;
end;

class function TDynArr<T>.itemsEqual(const i1, i2: T): Boolean;
begin
  Result := CompareMem(@i1, @i2, SizeOf(T));
end;

function TDynArr<T>.join(mapper: TFunc<T, string>; const separator: string = ''): string;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to self.length - 1 do
  begin
    if Result <> '' then
      Result := Result + separator + mapper(self._items[i])
    else
      Result := Result + mapper(self._items[i]);
  end;
end;

function TDynArr<T>.lastIndexOf(const val: T): Integer;
var
  i: Integer;
begin
  for i := self.length - 1 downto 0 do
    if TDynArr<T>.itemsEqual(self._items[i], val) then
    begin
      Result := i;
      Exit;
    end;
  Result := -1;
end;

function TDynArr<T>.map<S>(mapper: TFunc<T, S>): TDynArr<S>;
var
  i: Integer;
begin
  Result := TDynArr<S>.Create(self.length);
  for i := Low(_items) to High(_items) do
    Result[i] := mapper(_items[i]);
end;

class operator TDynArr<T>.Multiply(const a: TDynArr<T>;
  const n: Integer): TDynArr<T>;
var
  i, j: Integer;
begin
  Result := TDynArr<T>.Create(n * a.length);
  for i := 0 to a.length - 1 do
    for j := 0 to n - 1 do
      Result[j * a.length + i] := a[i];
end;

function TDynArr<T>.pop: T;
begin
  if self.length > 0 then
  begin
    Result := self._items[self.length - 1];
    Delete(self._items, self.length - 1, 1);
  end
  else
    raise Exception.Create('Cannot pop an item from and empty TDynArr.');
end;

function TDynArr<T>.push(const val: T): Integer;
begin
  self.length := self.length + 1;
  self._items[self.length - 1] := val;
end;

function TDynArr<T>.reduce<S>(reducer: TFunc<S, T, S>; const initialValue: S): S;
begin
  Result := self.reduce<S>(
    function(accumulated: S; it: T; index: Integer): S
    begin
      Result := reducer(accumulated, it);
    end,
    initialValue
  );
end;

function TDynArr<T>.reduce<S>(reducer: TFunc<S, T, Integer, S>;
  const initialValue: S): S;
var
  i: Integer;
begin
  Result := initialValue;
  for i := 0 to self.length - 1 do
    Result := reducer(Result, self._items[i], i);
end;

function TDynArr<T>.reduceRight<S>(reducer: TFunc<S, T, S>; const initialValue: S): S;
begin
  Result := self.reduceRight<S>(
    function(accumulated: S; it: T; index: Integer): S
    begin
      Result := reducer(accumulated, it);
    end,
    initialValue
  );
end;

function TDynArr<T>.reduceRight<S>(reducer: TFunc<S, T, Integer, S>; const initialValue: S): S;
var
  i: Integer;
begin
  Result := initialValue;
  for i := self.length - 1 downto 0 do
    Result := reducer(Result, self._items[i], i);
end;

procedure TDynArr<T>.reverse;
var
  i: Integer;
  tmp: T;
begin
  for i := 0 to self.length div 2 do
    TDynArr<T>.swap(self._items[i], self._items[self.length - i - 1]);
end;

function TDynArr<T>.reversed: TDynArr<T>;
begin
  Result := TDynArr<T>.from(self);
  Result.reverse();
end;

procedure TDynArr<T>.setItem(itemNo: Integer; const newValue: T);
begin
  if itemNo < self.length then
    self._items[itemNo] := newValue
  else
    raise ERangeError.CreateFmt('DynArr item index out of range: %d (max allowed: %d)', [itemNo, self.length]);
end;

procedure TDynArr<T>.setLength(newLength: Integer);
begin
  if newLength <> self.length then
    System.SetLength(_items, newLength);
end;

function TDynArr<T>.shift: T;
begin
  if self.length > 0 then
  begin
    Result := self._items[0];
    Delete(self._items, 0, 1);
  end
  else
    raise Exception.Create('Cannot shift an empty TDynArr');
end;

function TDynArr<T>.slice(const startIndex, endIndex: Integer): TDynArr<T>;
begin
  Result := TDynArr<T>.from(self._items, startIndex, endIndex);
end;

function TDynArr<T>.some(test: TFunc<T, Boolean>): Boolean;
begin
  Result := self.some(
    function(val: T; idx: Integer): Boolean
    begin
      Result := test(val);
    end
  );
end;

function TDynArr<T>.some(test: TFunc<T, Integer, Boolean>): Boolean;
var
  i: Integer;
begin
  Result := true;
  for i := 0 to self.length - 1 do
    if test(self._items[i], i) then
      Exit;
  Result := false;
end;

procedure TDynArr<T>.sort(compare: TComparison<T>);
var
  cmp: IComparer<T>;
begin
  if self.length > 1 then
  begin
    cmp := TDelegatedComparer<T>.Create(compare);
    TArray.Sort<T>(_items, cmp);
  end;
end;

function TDynArr<T>.sorted(compare: TComparison<T>): TDynArr<T>;
begin
  Result := TDynArr<T>.from(self);
  Result.sort(compare);
end;

function TDynArr<T>.splice(const startIndex, howMany: Integer;
  const newItems: TDynArr<T>): TDynArr<T>;
begin
  Result := self.slice(startIndex, startIndex + howMany);
  Delete(self._items, startIndex, howMany);
  if newItems.length > 0 then
    Insert(newItems.raw, self._items, startIndex);
end;

function TDynArr<T>.splice(const startIndex, howMany: Integer): TDynArr<T>;
begin
  Result := self.splice(startIndex, howMany, TDynArr<T>.empty);
end;

class procedure TDynArr<T>.swap(var i1, i2: T);
var
  tmp: T;
begin
  tmp := i1;
  i1 := i2;
  i2 := tmp;
end;

function TDynArr<T>.toString(mapper: TFunc<T, string>): string;
begin
  Result := self.join(mapper, ', ');
end;

function TDynArr<T>.unshift(const toAdd: TDynArr<T>): Integer;
begin
  Insert(toAdd.raw, self._items, 0);
  Result := self.length;
end;

end.
