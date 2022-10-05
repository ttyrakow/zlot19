unit DynMap;

interface
uses SysUtils, DynArr, System.Generics.Defaults;

type EKeyNotFound = class(Exception);
     EMapCreationError = class(Exception);

type TKeyValue<KeyType, ValueType> = record
  key: KeyType;
  value: ValueType;

  constructor from(const k: KeyType; const v: ValueType);
  property first: KeyType read key write key;
  property second: ValueType read value write value;
end;

// A map with keys of type KeyType and values of type ValueType.
// Unoptimized, operations like insert, update, delete, access take O(n) time
// (sequential scanning of keys).
// Effective only for relatively small maps.
type TDynMap<KeyType, ValueType> = record
  type Ptr = ^ValueType;

  public
  _keys: TDynArr<KeyType>;
  _values: TDynArr<ValueType>;
  // If assigned, keyCompare is used to compare map keys.
  // Otherwise, the default itemsEqual from DynArr is used.
  keyCompare: TFunc<KeyType, KeyType, Boolean>;

  // index of the given key, -1 if not found
  function indexOfKey(const k: KeyType): Integer;

  // set the value for the given key, add a new item if key not found
  procedure setVal(const k: KeyType; const v: ValueType);

  // set the value for a key via a pointer
  procedure setPtr(const k: KeyType; const p: Ptr);

  // get the value for a key, raises EKeyNotFound if no such key
  function getVal(const k: KeyType): ValueType; overload;

  // get the value for a key, return the fallBack if no such key
  function getVal(const k: KeyType; const fallBack: ValueType): ValueType; overload;

  // get the value for a key, return type default if no such key
  function getValDef(const k: KeyType): ValueType;

  // get the pointer to the value for a key (nil if not found in map)
  function getPtr(const k: KeyType): Ptr;

  // check if a key exists in the map
  function hasKey(const k: KeyType): Boolean;

  // the array of keys (actual, not a copy)
  property keys: TDynArr<KeyType> read _keys;

  // the array of values (actual, not a copy)
  property values: TDynArr<ValueType> read _values;

  // the value for a given key, returns type default if no such key
  property value[const k: KeyType]: ValueType
    read getValDef write setVal; default;

  // the pointer to the value for a given key, returns nil if no such key
  property ptrTo[const k: KeyType]: Ptr read getPtr write setPtr;

  // the value for a given key, EKeyNotFound if no such key
  property existingValues[const k: KeyType]: ValueType read getVal write setVal;


  // create a new map as a copy of the given map
  constructor from(const m: TDynMap<KeyType, ValueType>); overload;

  // create a new map, with the specified key-value pairs to start with
  constructor from(const kv: TDynArr<TKeyValue<KeyType, ValueType>>); overload;

  // create a new map with preallocated keys and values arrays
  constructor withSize(const size: Integer);

  // add a key-value pair to the map
  procedure add(const kv: TKeyValue<KeyType, ValueType>);

  // delete a key and its value
  procedure delete(const key: KeyType);

  // get the array of all key-value pairs for this map
  function enumerate(): TDynArr<TKeyValue<KeyType, ValueType>>;

  // merge another map into this map
  procedure merge(const m: TDynMap<KeyType, ValueType>);

  // clear the map
  procedure clear();

  // get a sub-map for the specified set of keys
  function submap(keys: TDynArr<KeyType>): TDynMap<KeyType, ValueType>;

  // clone the map
  function clone(): TDynMap<KeyType, ValueType>;

  // is the map empty / non empty?
  function _isEmpty(): Boolean;
  property isEmpty: Boolean read _isEmpty;
  function _isNotEmpty(): Boolean;
  property isNotEmpty: Boolean read _isNotEmpty;

  // the "length" of the map, i.e. the number of keys
  function _length(): Integer;
  property length: Integer read _length;

  // create an empty map
  class function empty(): TDynMap<KeyType, ValueType>; static;
end;

TVariantList = array of Variant;
TVariantLists = array of TVariantList;

// A shortcut function to create TKeyValue<string, Variant>.
function makeKV(const key: string; const value: Variant): TKeyValue<string, Variant>; overload;

// Creates a string-variant pair from the const array.
// The firs item of the array has to be convertible to a string.
function makeKV(const data: TVariantList): TKeyValue<string, Variant>; overload;

// Creates a string-variant map from the array of pairs.
function makeSVMap(const data: TVariantLists): TDynMap<string, Variant>;

// Creates a deep copy of the array of maps (clones each map individually).
function cloneSVArrayMap(
  const src: TDynArr<TDynMap<string, Variant>>
): TDynArr<TDynMap<string, Variant>>;

implementation

{ TDynMap<KeyType, ValueType> }

procedure TDynMap<KeyType, ValueType>.add(
  const kv: TKeyValue<KeyType, ValueType>);
begin
  self[kv.key] := kv.value;
end;

procedure TDynMap<KeyType, ValueType>.clear;
begin
  self._keys.clear();
  self._values.clear();
end;

function TDynMap<KeyType, ValueType>.clone: TDynMap<KeyType, ValueType>;
begin
  Result._keys := TDynArr<KeyType>.from(self._keys);
  Result._values := TDynArr<ValueType>.from(self._values);
end;

procedure TDynMap<KeyType, ValueType>.delete(const key: KeyType);
begin
  var ki := indexOfKey(key);
  if ki >= 0 then
  begin
    _keys.delete(ki);
    _values.delete(ki);
  end;
end;

class function TDynMap<KeyType, ValueType>.empty: TDynMap<KeyType, ValueType>;
begin
  Result._keys := TDynArr<KeyType>.empty();
  Result._values := TDynArr<ValueType>.empty();
end;

function TDynMap<KeyType, ValueType>.enumerate: TDynArr<TKeyValue<KeyType, ValueType>>;
var
  i: Integer;
begin
  Result := TDynArr<TKeyValue<KeyType, ValueType>>.create(keys.length);
  for i := 0 to keys.length - 1 do
    Result[i] := TKeyValue<KeyType, ValueType>.from(keys[i], values[i]);
end;

constructor TDynMap<KeyType, ValueType>.from(
  const m: TDynMap<KeyType, ValueType>);
begin
  self._keys := TDynArr<KeyType>.from(m.keys);
  self._values := TDynArr<ValueType>.from(m.values);
end;

constructor TDynMap<KeyType, ValueType>.from(
  const kv: TDynArr<TKeyValue<KeyType, ValueType>>);
var
  i: Integer;
begin
  self._keys.length := kv.length;
  self._values.length := kv.length;
  for i := 0 to kv.length - 1 do
  begin
    self._keys[i] := kv[i].key;
    self._values[i] := kv[i].value;
  end;
end;

function TDynMap<KeyType, ValueType>.getVal(const k: KeyType): ValueType;
var
  i: Integer;
begin
  i := self.indexOfKey(k);
  if i >= 0 then
    Result := _values[i]
  else
    raise EKeyNotFound.Create('Key not found in the map.');
end;

function TDynMap<KeyType, ValueType>.getPtr(const k: KeyType): Ptr;
var
  i: Integer;
begin
  i := self.indexOfKey(k);
  if i >= 0 then
    Result := @(_values[i])
  else
    raise EKeyNotFound.Create('Key not found in the map.');
end;

function TDynMap<KeyType, ValueType>.getVal(const k: KeyType;
  const fallBack: ValueType): ValueType;
var
  i: Integer;
begin
  i := self.indexOfKey(k);
  if i >= 0 then
    Result := _values[i]
  else
    Result := fallBack;
end;

function TDynMap<KeyType, ValueType>.getValDef(const k: KeyType): ValueType;
begin
  Result := self.getVal(k, Default(ValueType));
end;

function TDynMap<KeyType, ValueType>.hasKey(const k: KeyType): Boolean;
begin
  Result := self.indexOfKey(k) >= 0;
end;

function TDynMap<KeyType, ValueType>.indexOfKey(const k: KeyType): Integer;
var
  kc: TFunc<KeyType, KeyType, Boolean>;
begin
  if Assigned(self.keyCompare) then
  begin
    kc := self.keyCompare;
    Result := keys.findIndex(
      function(key: KeyType): Boolean
      begin
        Result := kc(key, k);
      end
    )
  end
  else
    Result := keys.indexOf(k);
end;

procedure TDynMap<KeyType, ValueType>.merge(
  const m: TDynMap<KeyType, ValueType>);
var
  kv: TKeyValue<KeyType, ValueType>;
begin
  for kv in m.enumerate.raw do
    setVal(kv.key, kv.value);
end;

procedure TDynMap<KeyType, ValueType>.setPtr(const k: KeyType; const p: Ptr);
begin
  self.setVal(k, p^);
end;

procedure TDynMap<KeyType, ValueType>.setVal(const k: KeyType;
  const v: ValueType);
var
  i: Integer;
begin
  i := self.indexOfKey(k);
  if i >= 0 then
    _values[i] := v
  else
  begin
    _keys.append(k);
    _values.append(v);
  end;
end;

function TDynMap<KeyType, ValueType>.submap(
  keys: TDynArr<KeyType>): TDynMap<KeyType, ValueType>;
var k: KeyType;
begin
  for k in keys.raw do
    if self.hasKey(k) then
      Result[k] := self[k];
end;

constructor TDynMap<KeyType, ValueType>.withSize(const size: Integer);
begin
  self._keys := TDynArr<KeyType>.create(size);
  self._values := TDynArr<ValueType>.create(size);
end;

function TDynMap<KeyType, ValueType>._isEmpty: Boolean;
begin
  Result := self._keys.isEmpty;
end;

function TDynMap<KeyType, ValueType>._isNotEmpty: Boolean;
begin
  Result := self._keys.isNotEmpty;
end;

function TDynMap<KeyType, ValueType>._length: Integer;
begin
  Result := self._keys.length;
end;

{ TKeyValue<KeyType, ValueType> }

constructor TKeyValue<KeyType, ValueType>.from(const k: KeyType;
  const v: ValueType);
begin
  self.key := k;
  self.value := v;
end;

function makeKV(const key: string; const value: Variant): TKeyValue<string, Variant>;
begin
  Result.key := key;
  Result.value := value;
end;

function makeKV(const data: TVariantList): TKeyValue<string, Variant>;
begin
  if Length(data) <> 2 then
    raise EMapCreationError.CreateFmt(
      'Cannot construct a map. %d args given, required 2.', [Length(data)]);

  Result.key := string(data[0]);
  Result.value := data[1];
end;

function makeSVMap(const data: TVariantLists): TDynMap<string, Variant>;
begin
  var l := Length(data);
  Result._keys := TDynArr<string>.create(l);
  Result._values := TDynArr<Variant>.create(l);
  for var i := Low(data) to High(data) do
  begin
    if Length(data[i]) <> 2 then
      raise EMapCreationError.CreateFmt(
        'Cannot construct a map for item %d. %d values given, required 2',
        [i, Length(data[i])]
      );
    Result._keys[i] := string(data[i][0]);
    Result._values[i] := data[i][1];
  end;
end;

function cloneSVArrayMap(
  const src: TDynArr<TDynMap<string, Variant>>
): TDynArr<TDynMap<string, Variant>>;
begin
  Result := TDynArr<TDynMap<string, Variant>>.create(src.length);
  for var i := 0 to src.lastIndex do
    Result[i] := src[i].clone();
end;

end.
