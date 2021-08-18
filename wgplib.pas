{General purpose library}
unit wgplib;
interface

uses SysUtils,classes {$ifndef VER120} ,windows {$endif}, StrUtils;

type
  TOwnedList = class(TStringList) // A stringlist that manages it's own objects
     procedure Delete(Index:Integer); override;
     procedure Clear; override;
     destructor Destroy; override;
  end;

  TQuickValuesList = class(TStringList) // a faster implementation of 'Values'
  private
    procedure SetValues(const Name, Value: string);
  public
    constructor Create;
{$ifndef VER120}
    function IndexOfName(const Name: string): Integer; override;
{$else}
    function IndexOfName(const Name: string): Integer;
{$endif}
    property Values write SetValues;
  end;
  TCompareEvent = procedure(Sender:TStrings; const p1,p2:TStringItem; var cmp:Integer) of Object;

  TCustomSortList = class(TStringList)
  private
    FOnCompare: TCompareEvent;
    procedure SetOnCompare(const Value: TCompareEvent);
  protected
    function MakeItem(IX: Integer): TStringItem;
    procedure QuickSort(L, R: Integer); virtual;
  public
    sortcode:Integer;
    procedure Sort; override;
    function Find(const S: string; var Index: Integer): Boolean; override;
    property OnCompare:TCompareEvent read FOnCompare write SetOnCompare;
    function Compare(const p1,p2: TStringItem): Integer;
  end;

  TStringObject = class
    value:String;
    constructor Create(avalue:String);
  end;

  TStringObjectList = class(TOwnedList)
  private
    function GetStringObjects(aindex: Integer): String;
    procedure SetStringObjects(aindex: Integer; const Value: String);
  public
    function AddString(key,value:String):Integer;
    function IndexOfValue(avalue:String):Integer;
    property StringObjects[aindex:Integer]:String read GetStringObjects write SetStringObjects;
  end;

  TStringListCSV = class helper for TStringList
  private
    function getCsv: String;
    procedure setCsv(const Value: String);
  public
    property AsCsv:String read getCsv write setCsv;
  end;

function atof(AString:String):Double; {Friendlier version of StrToFloat}
function atom(AString:String):Double; {Like ATOF, deals with $ signs}
function atoML(AString:String):Longint; {Like ATOF, deals returns int * 100}

Function atol(s:String):LongInt;
Function atol64(s:String):Int64;

function OneSpace(s:String):String; overload; {Make sure only one space between words}
function NoJunk(s:String):String; overload; // Only printable characters, and onespace.
{$ifdef VER210}
function OneSpace(s:AnsiString):String; overload; {Make sure only one space between words}
function NoJunk(s:AnsiString):String; overload;
{$endif}


function SentenceCase(s:String):String;

function IsNumeric(s:String):Boolean; {Is this a valid Integer}
function IsNumericF(s:String):Boolean; {Is this a valid numeric?}
function GetField(s:String; num:Integer):String;
function GetFieldPOS(s:String; num:Integer):Integer; //Get start of field
function GetSepField(s:String; num:Integer; sep:String=','):String;
function GetSepFieldPos(s:String; num:Integer; sep:String):Integer;
function ParseSepField(var s:String; sep:String):String;
function Parse(var s:String):String;
function GetLast(s: String): String;
function GetLastSep(s:String; sep:String):String;
function ParseLast(var s:String; sep:String=' '): String;

//procedure GDate(S:String; var Dest:Longint); overload;
//procedure GDate(S:String; var Dest:Double); overload;
function  YN(AValue:Boolean):String;
function iff(b:Boolean; strue,sfalse:String):String;
function ifnull(snormal,sdefault:String):String;

procedure Explode(source, sep: String; t: TStrings);
function  Implode(sep: String; t: Tstrings): String; overload;
function  Implode(sep: String; t: Array of String): String; overload;

function tochar(s:String; def:AnsiChar=' '):AnsiChar;

function PAChar(s:String):PAnsiChar; // Handling silly wide/narrow string conversion politely.
procedure SplitCSV(source:String; dest:TStrings);
function IsAlphaNumeric(s:String):Boolean;

implementation

{$HINTS OFF}
function IsNumeric(s:String):Boolean; {Is this a valid numeric?}
var j:Integer; x:Int64;
begin
  result:=false;
  if Uppercase(copy(s,1,1))='X' then exit;
  s:=trim(s);
  if (s='') then exit;
  Val(s,x,j);
  result:=(j=0);
end;

function IsNumericF(s:String):Boolean; {Is this a valid numeric?}
var j:Integer; x:Double;
begin
  result:=false;
  s:=trim(s);
  if (s='') then exit;
  Val(s,x,j);
  result:=(j=0);
end;
{$HINTS ON}

function IsAlphaNumeric(s:String):Boolean;
var c:Char;
begin
  result:=false;
  for c in uppercase(s) do if not (c in ['A'..'Z','0'..'9']) then exit;
  result:=true;
end;

function PAChar(s:String):PAnsiChar; // Handling silly wide/narrow string conversion politely.
begin
  result:=PAnsichar(AnsiString(s));
end;

function ParseSepField(var s:String; sep:String):String;
var i:Integer;
begin
  if (sep<>#9) then s:=trim(s);
  for i:=1 to length(s) do
  begin
    if (pos(s[i],sep)>0) then
    begin
      result:=copy(s,1,i-1);
      s:=copy(s,i+1,length(s));
      exit;
    end;
  end;
  result:=s;
  s:='';
end;

function Parse(var s:String):String;
var i:Integer;
begin
  s:=trim(s);
  i:=pos(' ',s);
  if (i<1) then i:=length(s)+1;
  result:=trim(copy(s,1,i-1));
  s:=trim(copy(s,i+1,length(s)));
end;

function GetLast(s: String): String;
begin
  result:=GetLastSep(s,'/');
end;

function GetLastSep(s:String; sep:String):String;
var i:Integer;
begin
  i:=length(s);
  while (i>0) and (copy(s,i,1)<>sep) do (dec(i));
  inc(i);
  result:=copy(s,i,length(s));
end;

function ParseLast(var s:String; sep:String):String;
var i:Integer;
begin
  if (sep=' ') then s:=trim(s);
  i:=length(s);
  while (i>0) and (copy(s,i,1)<>sep) do (dec(i));
  inc(i);
  result:=copy(s,i,length(s));
  delete(s,i,length(s));
  if (sep=' ') then
  begin
    result:=trim(result);
    s:=trim(s);
  end;
end;

Function atol(s:String):LongInt;
var i:LongInt; j:Integer;
begin
  val(s,i,j);
  if (j>0) then val(copy(s,1,j-1),i,j);
  atol:=i;
end;

Function atol64(s:String):Int64;
var i:Int64; j:Integer;
begin
  val(s,i,j);
  if (j>0) then val(copy(s,1,j-1),i,j);
  result:=i;
end;

{$HINTS OFF}
function atof(AString:String):Double; {Friendlier version of StrToFloat}
var v:Double; j:Integer;
begin
  v:=0;
  Val(AString,v,j);
  if (j>0) then Val(copy(AString,1,j-1),v,j);
  result:=v;
end;
{$HINTS ON}

function DateToString(ADate:TDateTime):String;
begin
  if ADate=0 then result:=''
  else result:=FormatDateTime('dd/mm/yyyy',ADate);
end;

function SentenceCase(s:String):String;
var s1:String; c:Char;
begin
  result:='';
  while (trim(s)<>'') do
  begin
    s1:=parse(s);
    if (s1<>'') then
    begin
      c:=s1[1];
      if (c>='a') and (c<='z') then s1:=uppercase(copy(s1,1,1))+lowercase(copy(s1,2,length(s1)));
      result:=trim(result+' '+s1);
    end;
  end;
end;

function OneSpace(s:String):String; {Make sure only one space between words}
var i:Integer;
begin
  result:='';
  i:=1;
  while i<=length(s) do
  begin
    if s[i]=' ' then
    begin
      while (i<=length(s)) and (s[i]=' ') do inc(i);
      if (i<=length(s)) and (result<>'') then result:=result+' ';
    end
    else
    begin
      result:=result+s[i];
      inc(i);
    end;
  end;
end;

function NoJunk(s:String):String; overload; // Only printable characters, and onespace.
var i:Integer; c:Char;
begin
  result:='';
  for i:=1 to length(s) do
  begin
    c:=s[i];
    if CharInSet(c,[' '..'~']) then result:=result+c
    else result:=result+' ';
  end;
  result:=OneSpace(result);
end;

{$ifdef VER210}
function OneSpace(s:AnsiString):String;
begin
  result:=OneSpace(String(s));
end;

function NoJunk(s:AnsiString):String; overload; // Only printable characters, and onespace.
begin
  result:=NoJunk(String(s));
end;

{$endif}

function GetField(s:String; num:Integer):String;
var i,j:Integer; t:String;
begin
  i:=1; j:=1; t:=''; s:=Trim(s);
  while (i<=length(s)) do
  begin
    if charinset(s[i],[' ',#9]) then
    begin
      inc(j);
      if (j>num) then break;
      while (i<=length(s)) and charinset(s[i],[' ',#9]) do inc(i)
    end
    else
    begin
      if (j=num) then t:=t+s[i];
      inc(i);
    end;
  end;
  GetField:=t;
end;

function GetFieldPOS(s:String; num:Integer):Integer;
var i,j:Integer; t:String;
begin
  i:=1; j:=1; t:='';
  while (i<=length(s)) and charinset(s[i],[' ',#9]) do inc(i);
  while (i<=length(s)) do
  begin
    if charinset(s[i],[' ',#9]) then
    begin
      inc(j);
      while (i<=length(s)) and charinset(s[i],[' ',#9]) do inc(i);
      if (j>=num) then break;
    end
    else inc(i);
  end;
  result:=i;
end;

function GetSepFieldPos(s:String; num:Integer; sep:String):Integer;
var i,j:Integer;
begin
  i:=1; j:=1;
  while (i<=length(s)) do
  begin
    if (pos(s[i],sep)>0) then
    begin
      inc(j);
      if (j>=num) then break;
      inc(i);
    end
    else
    begin
      inc(i);
    end;
  end;
  result:=(i+1);
end;

function GetSepField(s:String; num:Integer; sep:String):String;
var i,j:Integer; t:String;
begin
  i:=1; j:=1; t:=''; s:=trim(s);
  while (i<=length(s)) do
  begin
    if (pos(s[i],sep)>0) then
    begin
      inc(j);
      if (j>num) then break;
      inc(i);
    end
    else
    begin
      if (j=num) then t:=t+s[i];
      inc(i);
    end;
  end;
  GetSepField:=t;
end;

function atom(AString:String):Double; {Like ATOF, deals with $ signs}
begin
  AString:=TrimLeft(AString);
  if (copy(AString,1,1)='$') then AString:=copy(AString,2,255);
  result:=Atof(AString);
end;

function atoML(AString:String):Longint; {Like ATOF, deals returns int * 100}
begin
  result:=Round(Atof(AString)*100);
end;

function  YN(AValue:Boolean):String;
begin
  if AValue then result:='Y'
  else result:='N';
end;

function iff(b:Boolean; strue,sfalse:String):String;
begin
  if b then result:=strue else result:=sfalse;
end;

function ifnull(snormal,sdefault:String):String;
begin
  if (snormal<>'') then result:=snormal else result:=sdefault;
end;

procedure Explode(source, sep: String; t: TStrings);
var s:String;
begin
  t.clear;
  while (source<>'') do
  begin
    s:=ParseSepField(source,sep);
    t.add(s);
  end;
end;

function Implode(sep: String; t: Tstrings): String;
var i:Integer;
begin
  result:='';
  for i:=0 to t.count-1 do
  begin
    if (result<>'') then result:=result+sep;
    result:=result+t[i];
  end;
end;

function  Implode(sep: String; t: Array of String): String;
var i:Integer;
begin
  result:='';
  for i:=low(t) to high(t) do
  begin
    if (result<>'') then result:=result+sep;
    result:=result+trim(t[i]);
  end;
end;

function tochar(s:String; def:AnsiChar):AnsiChar;
begin
  if (s='') then result:=def else result:=AnsiChar(s[1]);
end;

procedure SplitCSV(source:String; dest:TStrings);
var s:String; qt:Boolean; c:Char; i:Integer;
begin
  qt:=false;
  dest.clear;
  s:='';
  i:=0;
  while (i<length(source)) do
  begin
    inc(i);
    c:=source[i];
    if c='"' then
    begin
      if (copy(source,i,2)='""') then
      begin
        s:=s+'"';
        inc(i);
      end
      else qt:=not(qt);
    end
    else
    begin
      if (c=',') and not(qt) then
      begin
        dest.add(s);
        s:='';
      end
      else s:=s+c;
    end;
  end;
  if s<>'' then dest.add(s);
end;

{ TOwnedList }

procedure TOwnedList.Clear;
var i:Integer;
begin
  for i:=0 to Count-1 do Objects[i].Free;
  inherited;
end;

procedure TOwnedList.Delete(Index: Integer);
begin
  Objects[index].Free;
  inherited;
end;

destructor TOwnedList.Destroy;
begin
  Clear;
  inherited;
end;


{ TQuickValuesList }

constructor TQuickValuesList.Create;
begin
  inherited;
  sorted:=true;
  Duplicates:=dupIgnore;
end;

function TQuickValuesList.IndexOfName(const Name: string): Integer;
var i:Integer; cmp:String;
begin
  if not(sorted) then result:=inherited IndexOfName(name)
  else
  begin
    cmp:=name+'=';
    Find(cmp,i);
    if (i<0) or (i>=count) or (AnsiCompareText(copy(strings[i],1,length(cmp)),cmp)<>0) then result:=-1
    else result:=i;
  end;
end;

procedure TQuickValuesList.SetValues(const Name, Value: string);
var i:Integer;
begin
  i:=indexofname(name);
  if (i>=0) then delete(i);
  add(name+'='+value)
end;

{ TCustomSortList }

procedure TCustomSortList.SetOnCompare(const Value: TCompareEvent);
begin
  FOnCompare := Value;
end;

function TCustomSortList.Compare(const p1,p2:TStringItem):Integer;
begin
  if assigned(foncompare) then oncompare(self,p1,p2,result)
  else result:=AnsiCompareText(p1.FString, p1.FString);
end;

function TCustomSortList.Find(const S: string; var Index: Integer): Boolean;
var
  L, H, I, C: Integer;
  SI:TStringItem;
begin
  Result := False;
  L := 0;
  H := Count - 1;
  SI.FString:=s;
  SI.FObject:=nil;
  while L <= H do
  begin
    I := (L + H) shr 1;
    C := Compare(MakeItem(I), SI);
    if C < 0 then L := I + 1 else
    begin
      H := I - 1;
      if C = 0 then
      begin
        Result := True;
        if Duplicates <> dupAccept then L := I;
      end;
    end;
  end;
  Index := L;
end;

function TCustomSortList.MakeItem(IX:Integer):TStringItem;
begin
  result.FString:=strings[ix];
  result.FObject:=objects[ix];
end;

procedure TCustomSortList.QuickSort(L, R: Integer);
var
  I, J: Integer;
  P: TStringItem;
begin
  repeat
    I := L;
    J := R;
    P := MakeItem((L + R) shr 1);
    repeat
      while Compare(MakeItem(I), P) < 0 do Inc(I);
      while Compare(MakeItem(J), P) > 0 do Dec(J);
      if I <= J then
      begin
        Exchange(I, J);
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then QuickSort(L, J);
    L := I;
  until I >= R;
end;

procedure TCustomSortList.Sort;
begin
  if not assigned(FOnCompare) then inherited
  else
  begin
    if (Count > 1) then
    begin
      Changing;
      QuickSort(0, Count - 1);
      Changed;
    end;
  end;
end;

{ TStringObjectsList }

function TStringObjectList.AddString(key, value:String): Integer;
begin
  result:=addObject(key,TStringObject.Create(value));
end;

function TStringObjectList.GetStringObjects(aindex: Integer): String;
var o:TObject;
begin
  o:=Objects[aIndex];
  if (o=nil) or not(o is TStringObject) then result:=''
  else result:=(o as TStringObject).value;
end;

function TStringObjectList.IndexOfValue(avalue: String): Integer;
var i:Integer;
begin
  for i:=0 to count-1 do
  begin
    if avalue=StringObjects[i] then
    begin
      result:=i;
      exit;
    end;
  end;
  result:=-1;
end;

procedure TStringObjectList.SetStringObjects(aindex: Integer;
  const Value: String);
var o:TObject;
begin
  o:=Objects[aIndex];
  if (o=nil) then Objects[aIndex]:=TStringObject.Create(value)
  else if not(o is TStringObject) then raise Exception.Create('Not a StringObject!')
  else (o as TStringObject).value:=value;
end;

{ TStringObject }

constructor TStringObject.Create(avalue: String);
begin
  value:=avalue;
end;

{ TStringListCSV }

function TStringListCSV.getCsv: String;
var s:String;
begin
  result:='';
  for s in self do
  begin
    if (result<>'') then result:=result+',';
    result:=result+'"'+AnsiReplaceStr(s,'"','""')+'"';
  end;
end;

procedure TStringListCSV.setCsv(const Value: String);
begin
  SplitCSV(value,self);
end;

end.
