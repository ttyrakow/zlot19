///  Dynamic arrays based on JavaScript Array functionality.
///  author: Tomasz Tyrakowski (t.tyrakowski@sol-system.pl)
///  license: public domain

unit DynArr;

interface
uses SysUtils, System.Generics.Collections, System.Generics.Defaults;

type
  ///  Raw array of values of type T.
  TRawArr<T> = array of T;

  ///  Boxed value of type S.
  ///  Required for reduce to work properly in Delphi 10.4, where
  ///  returning a parametrizing type S results in access violation
  ///  (compiler can't handle a generic return type S in a generic
  ///  record parametrized with another type T).
  TBoxed<S> = record
    value: S;
    constructor from(const val: S);
  end;

  ///  Dynamic JS-like array of values of type T.
  TDynArr<T> = record
  type
    Ptr = ^T;

  private
    _items: TRawArr<T>;

    // property accessors
    function getLength(): Integer;
    procedure setLength(newLength: Integer);
    function getItem(itemNo: Integer): T;
    procedure setItem(itemNo: Integer; const newValue: T);
    function getLastIndex(): Integer;
    function getLastItem(): T;
    function getPtr(itemNo: Integer): Ptr;
    procedure setPtr(itemNo: Integer; const newPtr: Ptr);

  public
    ///  Create an array with the initial length as specified.
    constructor create(const initialLength: Integer);

    ///  An alias for create.
    constructor new(const initialLength: Integer);

    ///  Creates an array from a raw array
    constructor from(const a: TRawArr<T>; startIndex: Integer = -1; endIndex: Integer = -1); overload;

    ///  Creates an array from another TDynArr
    constructor from(const a: TDynArr<T>); overload;

    ///  Creates an array of length initialLength,
    ///  the second variant also filling it with the value initialVal
    ///  (the first one fills it with System.Default(T).
    constructor from(const initialLength: Integer); overload;
    constructor from(const initialLength: Integer; const initialVal: T); overload;

    ///  The length of the array.
    property length: Integer read getLength write setLength;

    ///  Access individual items of the array.
    property items[itemNo: Integer]: T read getItem write setItem; default;

    ///  Access pointers to individual items of the array.
    property ptrTo[itemNo: Integer]: Ptr read getPtr write setPtr;

    ///  Get a raw array of values.
    property raw: TRawArr<T> read _items write _items;

    ///  Get the last valid index number of this array.
    property lastIndex: Integer read getLastIndex;

    ///  Get the last value of this array. Raises an exception if used
    ///  on an empty array.
    property lastItem: T read getLastItem;

    ///  Array manipulation routines.

    ///  Append a new item to the end of the array.
    procedure append(const item: T); overload;

    ///  Append all items to the end of the array.
    procedure append(const fromHere: TDynArr<T>); overload;

    ///  Insert an item at index idx in the array.
    procedure insert(const item: T; const idx: Integer);

    ///  Clear the array.
    procedure clear();

    ///  Joins two or more arrays, and returns a copy of the joined arrays.
    function concat(const a: TDynArr<T>): TDynArr<T>;

    ///  Removes the item at the specified index.
    procedure delete(const idx: Integer; const howMany: Integer = 1);

    ///  Fill the elements in an array with a static value.
    procedure fill(const val: T);

    ///  Creates a new array with every item in an array that pass a test.
    ///  Where is just an alias.
    function filter(test: TFunc<T, Boolean>): TDynArr<T>; overload;
    function filter(test: TFunc<T, Integer, Boolean>): TDynArr<T>; overload;
    function where(test: TFunc<T, Boolean>): TDynArr<T>;
    function ptrFilter(test: TFunc<Ptr, Boolean>): TDynArr<T>; overload;
    function ptrFilter(test: TFunc<Ptr, Integer, Boolean>): TDynArr<T>; overload;
    function ptrWhere(test: TFunc<Ptr, Boolean>): TDynArr<T>;

    ///  Returns the value of the first item in an array that pass a test.
    ///  Raises an exception if there are no items passing the test.
    function find(test: TFunc<T, Boolean>): T; overload;
    function find(test: TFunc<T, Boolean>; const fallback: T): T; overload;

    ///  Returns the pointer to the first item in an array that pass a test.
    ///  If no such item exists, returns nil.
    function ptrFind(test: TFunc<Ptr, Boolean>): Ptr; overload;


    ///  Returns the index of the first element in an array that pass a test.
    function findIndex(test: TFunc<T, Boolean>): Integer;
    function ptrFindIndex(test: TFunc<Ptr, Boolean>): Integer;

    ///  Calls a function for each array element.
    ///  The second version also passes the item index.
    procedure forEach(process: TProc<T>); overload;
    procedure forEach(process: TProc<T, Integer>); overload;
    procedure ptrForEach(process: TProc<Ptr>); overload;
    procedure ptrForEach(process: TProc<Ptr, Integer>); overload;

    ///  Check if an array contains the specified element.
    function includes(const val: T): Boolean;

    ///  Search the array for an element and returns its position.
    function indexOf(const val: T): Integer;

    ///  Is this array empty (length is 0)?
    function _isEmpty(): Boolean;
    function _isNotEmpty(): Boolean;
    property isEmpty: Boolean read _isEmpty;
    property isNotEmpty: Boolean read _isNotEmpty;

    ///  Joins all elements of an array into a string.
    function join(mapper: TFunc<T, string>; const separator: string = ''): string;

    ///  Search the array for an element, starting at the end, and returns its position.
    function lastIndexOf(const val: T): Integer;

    ///  Creates a new array with the result of calling a function for each array element.
    ///  In the second variant the mapper receives the index of an item in addition to the item.
    function map<S>(mapper: TFunc<T, S>): TDynArr<S>; overload;
    function map<S>(mapper: TFunc<T, Integer, S>): TDynArr<S>; overload;
    function ptrMap<S>(mapper: TFunc<Ptr, S>): TDynArr<S>; overload;
    function ptrMap<S>(mapper: TFunc<Ptr, Integer, S>): TDynArr<S>; overload;

    ///  Removes the last element of an array, and returns that element.
    function pop(): T;

    ///  Adds new elements to the end of an array, and returns the new length.
    function push(const val: T): Integer;

    ///  Reduce the values of an array to a single value (going left-to-right).
    function reduce<S>(reducer: TFunc<S, T, Integer, S>; const initialValue: S): TBoxed<S>; overload;
    function reduce<S>(reducer: TFunc<S, T, S>; const initialValue: S): TBoxed<S>; overload;
    function ptrReduce<S>(reducer: TFunc<S, Ptr, Integer, S>; const initialValue: S): TBoxed<S>; overload;
    function ptrReduce<S>(reducer: TFunc<S, Ptr, S>; const initialValue: S): TBoxed<S>; overload;

    ///  Reverses the order of the elements in an array.
    procedure reverse();
    function reversed(): TDynArr<T>;

    ///  Removes the first element of an array, and returns that element.
    function shift(): T;

    ///  Selects a part of an array, and returns the new array.
    function slice(const startIndex, endIndex: Integer): TDynArr<T>;

    ///  Checks if any of the elements in the array pass a test.
    function some(test: TFunc<T, Integer, Boolean>): Boolean; overload;
    function some(test: TFunc<T, Boolean>): Boolean; overload;
    function ptrSome(test: TFunc<Ptr, Integer, Boolean>): Boolean; overload;
    function ptrSome(test: TFunc<Ptr, Boolean>): Boolean; overload;
    function any(test: TFunc<T, Integer, Boolean>): Boolean; overload;
    function any(test: TFunc<T, Boolean>): Boolean; overload;
    function ptrAny(test: TFunc<Ptr, Integer, Boolean>): Boolean; overload;
    function ptrAny(test: TFunc<Ptr, Boolean>): Boolean; overload;

    ///  Checks if all of the elements in the array pass a test.
    function all(test: TFunc<T, Integer, Boolean>): Boolean; overload;
    function all(test: TFunc<T, Boolean>): Boolean; overload;
    function every(test: TFunc<T, Integer, Boolean>): Boolean; overload;
    function every(test: TFunc<T, Boolean>): Boolean; overload;
    function ptrAll(test: TFunc<Ptr, Integer, Boolean>): Boolean; overload;
    function ptrAll(test: TFunc<Ptr, Boolean>): Boolean; overload;
    function ptrEvery(test: TFunc<Ptr, Integer, Boolean>): Boolean; overload;
    function ptrEvery(test: TFunc<Ptr, Boolean>): Boolean; overload;

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

    ///  Clones the array (returns an array with copies of items)
    function clone(): TDynArr<T>;

    ///  Swaps items with indices i and j
    procedure swapItems(const i, j: Integer);

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

///  Return a range array, i.e. the array with values min, min+1, ..., max-1,
///  optionally with the given step.
///  The upper bound is always exclusive (like in Python).
///  Allows to do things like range(4).forEach(...) // exec for 0, 1, 2, 3
///  or range(10, 2, -2).forEach(...) // exec for 10, 8, 6, 4
function range(const upperBound: Integer): TDynArr<Integer>; overload;
function range(const lowerBound, upperBound: Integer; const step: Integer = 1): TDynArr<Integer>; overload;

type _Pstring = ^string;

implementation
uses TypInfo;

class operator TDynArr<T>.Add(const a1, a2: TDynArr<T>): TDynArr<T>;
begin
  Result := a1.concat(a2);
end;

function TDynArr<T>.all(test: TFunc<T, Boolean>): Boolean;
begin
  Result := not any(
    function(itm: T): Boolean
    begin
      Result := not test(itm);
    end
  );
end;

function TDynArr<T>.all(test: TFunc<T, Integer, Boolean>): Boolean;
begin
  Result := any(
    function(itm: T; idx: Integer): Boolean
    begin
      Result := not test(itm, idx);
    end
  );
end;

function TDynArr<T>.any(test: TFunc<T, Boolean>): Boolean;
begin
  Result := some(test);
end;

procedure TDynArr<T>.append(const fromHere: TDynArr<T>);
begin
  if fromHere.isNotEmpty then
  begin
    var l := self.length;
    self.length := self.length + fromHere.length;
    for var i := 0 to fromHere.length-1 do
      self._items[i + l] := fromHere[i];
  end;
end;

function TDynArr<T>.any(test: TFunc<T, Integer, Boolean>): Boolean;
begin
  Result := some(test);
end;

procedure TDynArr<T>.append(const item: T);
begin
  self.length := self.length + 1;
  self._items[self.length - 1] := item;
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

procedure TDynArr<T>.clear;
begin
  self.length := 0;
end;

function TDynArr<T>.clone: TDynArr<T>;
begin
  Result := TDynArr<T>.from(self);
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

procedure TDynArr<T>.delete(const idx: Integer; const howMany: Integer = 1);
begin
  if (idx < 0) or (idx >= length) then
    raise ERangeError.CreateFmt('Index %d out of range. Array length is %d.', [idx, length]);
  System.Delete(_items, idx, howMany);
end;

constructor TDynArr<T>.new(const initialLength: Integer);
begin
  create(initialLength);
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
begin
  Result := self.all(test);
end;

function TDynArr<T>.every(test: TFunc<T, Boolean>): Boolean;
begin
  Result := self.all(test);
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
begin
  Result := self.filter(
    function(it: T; _: Integer): Boolean
    begin
      Result := test(it);
    end
  );
end;

function TDynArr<T>.filter(test: TFunc<T, Integer, Boolean>): TDynArr<T>;
var
  i, ii: Integer;
begin
  Result := TDynArr<T>.create(self.length);
  ii := 0;
  for i := 0 to self.length - 1 do
    if test(self._items[i], i) then
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

function TDynArr<T>.find(test: TFunc<T, Boolean>; const fallback: T): T;
var
  ii: Integer;
begin
  ii := self.findIndex(test);
  if ii >= 0 then
    Result := self._items[ii]
  else
    Result := fallback;
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

procedure TDynArr<T>.forEach(process: TProc<T, Integer>);
var
  i: Integer;
begin
  for i := 0 to self.length - 1 do
    process(self._items[i], i);
end;

constructor TDynArr<T>.from(const a: TDynArr<T>);
var
  i: Integer;
begin
  System.SetLength(self._items, a.length);
  for i := 0 to a.length - 1 do
    self._items[i] := a[i];
end;

constructor TDynArr<T>.from(const initialLength: Integer);
begin
  from(initialLength, System.Default(T));
end;

constructor TDynArr<T>.from(const initialLength: Integer; const initialVal: T);
begin
  create(initialLength);
  fill(initialVal);
end;

constructor TDynArr<T>.from(const a: TRawArr<T>; startIndex: Integer = -1; endIndex: Integer = -1);
var
  l, i: Integer;
begin
  l := System.Length(a);
  if startIndex < 0 then
    startIndex := 0;
  if endIndex < 0 then
    endIndex := l;
  if endIndex > l then
    endIndex := l;
  System.SetLength(self._items, endIndex - startIndex);
  for i := startIndex to endIndex - 1 do
    self._items[i - startIndex] := a[i];
end;

function TDynArr<T>.getItem(itemNo: Integer): T;
begin
  if itemNo < self.length then
    Result := self._items[itemNo]
  else
    raise ERangeError.CreateFmt(
      'DynArr item index out of range: %d (max allowed: %d)',
      [itemNo, self.lastIndex]);
end;

function TDynArr<T>.getLastIndex: Integer;
begin
  Result := self.length - 1;
end;

function TDynArr<T>.getLastItem: T;
begin
  if self.isEmpty then
    raise ERangeError.Create('Cannot access the last item of an empty array.');
  Result := self._items[self.lastIndex];
end;

function TDynArr<T>.getLength: Integer;
begin
  Result := System.Length(self._items);
end;

function TDynArr<T>.getPtr(itemNo: Integer): Ptr;
begin
  if itemNo < self.length then
    Result := @(self._items[itemNo])
  else
    raise ERangeError.CreateFmt(
      'DynArr item index out of range: %d (max allowed: %d)',
      [itemNo, self.lastIndex]);
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


procedure TDynArr<T>.insert(const item: T; const idx: Integer);
begin
  if (idx < 0) then
    raise ERangeError.CreateFmt(
      'Invalid insertion point: %d.', [idx]);
  if idx >= self.length then
    self.append(item)
  else
  begin
    self.length := self.length + 1;
    for var i := self.length - 2 downto idx do
      // shift everything right by one, from idx to the end of the array
      self._items[i + 1] := self._items[i];
    self._items[idx] := item;
  end;
end;

function TDynArr<T>._isEmpty: Boolean;
begin
  Result := self.length = 0;
end;

function TDynArr<T>._isNotEmpty: Boolean;
begin
  Result := not self._isEmpty();
end;

class function TDynArr<T>.itemsEqual(const i1, i2: T): Boolean;
var
  t_info: PTypeInfo;
begin
  t_info := System.TypeInfo(T);
  if (t_info <> nil) and ((t_info^.Kind in [tkString, tkWString, tkUString])) then
    // this is a special case for comparing strings, CompareMem doesn't
    // work properly with strings
    Result := string((_Pstring(@i1))^) = string((_Pstring(@i2))^)
  else
    // for all other types we use the brute CompareMem function
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

function TDynArr<T>.map<S>(mapper: TFunc<T, Integer, S>): TDynArr<S>;
var
  i: Integer;
begin
  Result := TDynArr<S>.Create(self.length);
  for i := Low(_items) to High(_items) do
    Result[i] := mapper(_items[i], i);
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
    System.Delete(self._items, self.length - 1, 1);
  end
  else
    raise Exception.Create('Cannot pop an item from and empty TDynArr.');
end;

function TDynArr<T>.ptrAll(test: TFunc<Ptr, Integer, Boolean>): Boolean;
begin
  Result := not ptrAny(
    function(itm: Ptr; idx: Integer): Boolean
    begin
      Result := not test(itm, idx);
    end
  );
end;

function TDynArr<T>.ptrAll(test: TFunc<Ptr, Boolean>): Boolean;
begin
  Result := ptrAny(
    function(itm: Ptr): Boolean
    begin
      Result := not test(itm);
    end
  );
end;

function TDynArr<T>.ptrAny(test: TFunc<Ptr, Integer, Boolean>): Boolean;
begin
  Result := ptrSome(test);
end;

function TDynArr<T>.ptrAny(test: TFunc<Ptr, Boolean>): Boolean;
begin
  Result := ptrSome(test);
end;

function TDynArr<T>.ptrEvery(test: TFunc<Ptr, Integer, Boolean>): Boolean;
begin
  Result := self.ptrAll(test);
end;

function TDynArr<T>.ptrEvery(test: TFunc<Ptr, Boolean>): Boolean;
begin
  Result := self.ptrAll(test);
end;

function TDynArr<T>.ptrFilter(test: TFunc<Ptr, Boolean>): TDynArr<T>;
begin
  Result := self.ptrFilter(
    function(it: Ptr; _: Integer): Boolean
    begin
      Result := test(it);
    end
  );
end;

function TDynArr<T>.ptrFilter(test: TFunc<Ptr, Integer, Boolean>): TDynArr<T>;
var
  i, ii: Integer;
begin
  Result := TDynArr<T>.create(self.length);
  ii := 0;
  for i := 0 to self.length - 1 do
    if test(@(self._items[i]), i) then
    begin
      Result[ii] := self._items[i];
      ii := ii + 1;
    end;
  Result.length := ii;
end;

function TDynArr<T>.ptrFind(test: TFunc<Ptr, Boolean>): Ptr;
var
  ii: Integer;
begin
  ii := self.ptrFindIndex(test);
  if ii >= 0 then
    Result := @(self._items[ii])
  else
    Result := nil;
end;

function TDynArr<T>.ptrFindIndex(test: TFunc<Ptr, Boolean>): Integer;
var
  i: Integer;
begin
  for i := 0 to self.length - 1 do
    if test(@(self._items[i])) then
    begin
      Result := i;
      Exit;
    end;
  Result := -1;
end;

procedure TDynArr<T>.ptrForEach(process: TProc<Ptr, Integer>);
var
  i: Integer;
begin
  for i := 0 to self.length - 1 do
    process(@(self._items[i]), i);
end;

function TDynArr<T>.ptrMap<S>(mapper: TFunc<Ptr, Integer, S>): TDynArr<S>;
var
  i: Integer;
begin
  Result := TDynArr<S>.Create(self.length);
  for i := Low(_items) to High(_items) do
    Result[i] := mapper(@(_items[i]), i);
end;

function TDynArr<T>.ptrReduce<S>(reducer: TFunc<S, Ptr, S>;
  const initialValue: S): TBoxed<S>;
begin
  Result := self.ptrReduce<S>(
    function(accumulated: S; it: Ptr; index: Integer): S
    begin
      Result := reducer(accumulated, it);
    end,
    initialValue
  );
end;

function TDynArr<T>.ptrReduce<S>(reducer: TFunc<S, Ptr, Integer, S>;
  const initialValue: S): TBoxed<S>;
var
  i: Integer;
  r: S;
begin
  r := initialValue;
  for i := 0 to self.length - 1 do
    r := reducer(r, @(self._items[i]), i);
  Result := TBoxed<S>.from(r);
end;

function TDynArr<T>.ptrMap<S>(mapper: TFunc<Ptr, S>): TDynArr<S>;
var
  i: Integer;
begin
  Result := TDynArr<S>.Create(self.length);
  for i := Low(_items) to High(_items) do
    Result[i] := mapper(@(_items[i]));
end;

function TDynArr<T>.ptrSome(test: TFunc<Ptr, Integer, Boolean>): Boolean;
var
  i: Integer;
begin
  Result := true;
  for i := 0 to self.length - 1 do
    if test(@(self._items[i]), i) then
      Exit;
  Result := false;
end;

function TDynArr<T>.ptrSome(test: TFunc<Ptr, Boolean>): Boolean;
begin
  Result := self.ptrSome(
    function(val: Ptr; idx: Integer): Boolean
    begin
      Result := test(val);
    end
  );
end;

function TDynArr<T>.ptrWhere(test: TFunc<Ptr, Boolean>): TDynArr<T>;
begin
  Result := self.ptrFilter(test);
end;

procedure TDynArr<T>.ptrForEach(process: TProc<Ptr>);
var
  i: Integer;
begin
  for i := 0 to self.length - 1 do
    process(@(self._items[i]));
end;

function TDynArr<T>.push(const val: T): Integer;
begin
  self.length := self.length + 1;
  self._items[self.length - 1] := val;
end;

function TDynArr<T>.reduce<S>(reducer: TFunc<S, T, S>; const initialValue: S): TBoxed<S>;
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
  const initialValue: S): TBoxed<S>;
var
  i: Integer;
  r: S;
begin
  r := initialValue;
  for i := 0 to self.length - 1 do
    r := reducer(r, self._items[i], i);
  Result := TBoxed<S>.from(r);
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
    raise ERangeError.CreateFmt(
      'DynArr item index out of range: %d (max allowed: %d)',
      [itemNo, self.lastIndex]);
end;

procedure TDynArr<T>.setLength(newLength: Integer);
begin
  if newLength <> self.length then
    System.SetLength(_items, newLength);
end;

procedure TDynArr<T>.setPtr(itemNo: Integer; const newPtr: Ptr);
begin
  if itemNo < self.length then
    self._items[itemNo] := newPtr^
  else
    raise ERangeError.CreateFmt(
      'DynArr item index out of range: %d (max allowed: %d)',
      [itemNo, self.lastIndex]);
end;

function TDynArr<T>.shift: T;
begin
  if self.length > 0 then
  begin
    Result := self._items[0];
    System.Delete(self._items, 0, 1);
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
  System.Delete(self._items, startIndex, howMany);
  if newItems.length > 0 then
    System.Insert(newItems.raw, self._items, startIndex);
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

procedure TDynArr<T>.swapItems(const i, j: Integer);
begin
  if (i < 0) or (i >= length) or (j < 0) or (j >= length) then
    raise Exception.CreateFmt('Swap: invalid indices %d and %d', [i, j]);
  var tmp: T := items[i];
  items[i] := items[j];
  items[j] := tmp;
end;

function TDynArr<T>.toString(mapper: TFunc<T, string>): string;
begin
  Result := self.join(mapper, ', ');
end;

function TDynArr<T>.unshift(const toAdd: TDynArr<T>): Integer;
begin
  System.Insert(toAdd.raw, self._items, 0);
  Result := self.length;
end;

function TDynArr<T>.where(test: TFunc<T, Boolean>): TDynArr<T>;
begin
  Result := self.filter(test);
end;

function range(const upperBound: Integer): TDynArr<Integer>;
var
  i: Integer;
begin
  if upperBound <= 0 then
    Result.length := 0
  else
  begin
    Result.length := upperBound;
    for i := 0 to upperBound - 1 do
      Result.raw[i] := i;
  end;
end;

function range(const lowerBound, upperBound: Integer; const step: Integer = 1): TDynArr<Integer>;
var
  i, ii: Integer;
begin
  if
    ((step > 0) and (upperBound <= lowerBound))
    or ((step < 0) and (upperBound >= lowerBound))
    or (step = 0)
  then
    Result.length := 0
  else
  begin
    Result.length := upperBound - lowerBound;
    ii := 0;
    i := lowerBound;
    while i < upperBound do
    begin
      Result.raw[ii] := i;
      ii := ii + 1;
      i := i + step;
    end;
  end;
end;

{ TBoxed<S> }

constructor TBoxed<S>.from(const val: S);
begin
  self.value := val;
end;

end.
