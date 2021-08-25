unit SynHighlighterMooCode;

{$I SynEdit.inc}

interface

uses
  Windows,
  Graphics,
  SynEditTypes,
  SynEditHighlighter,
  SynUnicode,
  StrUtils,
  SysUtils,
  Classes;

type
  TtkTokenKind = (tkComment, tkIdentifier, tkKey, tkNull, tkNumber,
    tkPreprocessor, tkSpace, tkString, tkSymbol, tkVerb, tkProperty, tkList, tkUnknown);

  TCommentStyle = (csAnsiStyle, csPasStyle, csCStyle, csAsmStyle, csBasStyle,
    csCPPStyle);
  TCommentStyles = set of TCommentStyle;

  TRangeState = (rsANil, rsAnsi, rsPasStyle, rsCStyle, rsUnKnown);

  TStringDelim = (sdSingleQuote, sdDoubleQuote, sdSingleAndDoubleQuote);

  TGetTokenAttributeEvent = procedure (attribute : TSynHighlighterAttributes) of object;

const
   cDefaultIdentChars = '_0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ' +
                         'abcdefghijklmnopqrstuvwxyz';

type
  TSynMooCodeSyn = class(TSynCustomHighlighter)
  private
    fIdentChars: string;
    fRange: TRangeState;
    fTokenID: TtkTokenKind;
    fCommentAttri: TSynHighlighterAttributes;
    fIdentifierAttri: TSynHighlighterAttributes;
    fKeyAttri: TSynHighlighterAttributes;
    fNumberAttri: TSynHighlighterAttributes;
    fPreprocessorAttri: TSynHighlighterAttributes;
    fSpaceAttri: TSynHighlighterAttributes;
    fStringAttri: TSynHighlighterAttributes;
    fSymbolAttri: TSynHighlighterAttributes;
    fKeyWords: TStrings;
    fComments: TCommentStyles;
    fStringDelim: TStringDelim;
    fDetectPreprocessor: Boolean;
    fOnGetTokenAttribute: TGetTokenAttributeEvent;
    FStringMultiLine : Boolean;
    fVerbAttr:TSynHighlighterAttributes;
    fPropAttr:TSynHighlighterAttributes;
    fListAttr:TSynHighlighterAttributes;
    procedure AsciiCharProc;
    procedure BraceOpenProc;
    procedure PointCommaProc;
    procedure CRProc;
    procedure IdentProc;
    procedure IntegerProc;
    procedure LFProc;
    procedure NullProc;
    procedure NumberProc;
    procedure RoundOpenProc;
    procedure SlashProc;
    procedure SpaceProc;
    procedure StringProc;
    procedure UnknownProc;
    procedure AnsiProc;
    procedure PasStyleProc;
    procedure CStyleProc;
    procedure VerbProc;
    procedure SetComments(Value: TCommentStyles);
    function GetStringDelim: TStringDelim;
    procedure SetStringDelim(const Value: TStringDelim);
    function GetIdentifierChars: string;
    procedure SetIdentifierChars(const Value: string);
    function StoreIdentChars : Boolean;
    procedure SetDetectPreprocessor(Value: boolean);
    procedure PropertyProc;
  public
    class function GetLanguageName: string; override;
    class function GetFriendlyLanguageName: string; override;
    function IsStringDelim(aChar : WideChar) : Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetDefaultAttribute(Index: integer): TSynHighlighterAttributes;
      override;
    function GetEol: Boolean; override;
    function GetRange: Pointer; override;
    function GetTokenID: TtkTokenKind;
    function GetCharBeforeToken(offset : Integer = -1) : WideChar;
    function GetCharAfterToken(offset : Integer = 1) : WideChar;
    function GetTokenAttribute: TSynHighlighterAttributes; override;
    function GetTokenKind: integer; override;
    function IsIdentChar(AChar: WideChar): Boolean; override;
    function IsKeyword(const AKeyword: string): Boolean; override;
    function IsWordBreakChar(AChar: WideChar): Boolean; override;
    procedure Next; override;
    procedure ResetRange; override;
    procedure SetRange(Value: Pointer); override;
    property OnGetTokenAttribute : TGetTokenAttributeEvent read fOnGetTokenAttribute write fOnGetTokenAttribute;
    property StringMultiLine : Boolean read FStringMultiLine write FStringMultiLine;
  published
    property CommentAttri: TSynHighlighterAttributes read fCommentAttri
      write fCommentAttri;
    property Comments: TCommentStyles read fComments write SetComments default [];
    property DetectPreprocessor: boolean read fDetectPreprocessor
      write SetDetectPreprocessor;
    property IdentifierAttri: TSynHighlighterAttributes read fIdentifierAttri
      write fIdentifierAttri;
    property IdentifierChars: string read GetIdentifierChars
      write SetIdentifierChars stored StoreIdentChars;
    property KeyAttri: TSynHighlighterAttributes read fKeyAttri write fKeyAttri;
    property NumberAttri: TSynHighlighterAttributes read fNumberAttri
      write fNumberAttri;
    property PreprocessorAttri: TSynHighlighterAttributes
      read fPreprocessorAttri write fPreprocessorAttri;
    property SpaceAttri: TSynHighlighterAttributes read fSpaceAttri
      write fSpaceAttri;
    property StringAttri: TSynHighlighterAttributes read fStringAttri
      write fStringAttri;
    property SymbolAttri: TSynHighlighterAttributes read fSymbolAttri
      write fSymbolAttri;
    property StringDelim: TStringDelim read GetStringDelim write SetStringDelim
      default sdSingleQuote;
  end;

implementation

uses
  SynEditStrConst;

const KeywordList:Array[1..14] of String = ('if','then','else','elseif','for',
           'while','endfor','endwhile','endif',
           'try','except','endtry','break','continue');

function TSynMooCodeSyn.IsIdentChar(AChar: WideChar): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 1 to Length(fIdentChars) do
    if AChar = fIdentChars[i] then
    begin
      Result := True;
      Exit;
    end;
end;

function TSynMooCodeSyn.IsKeyword(const AKeyword: string): Boolean;
var
  First, Last, I, Compare: Integer;
  Token: string;
begin
  First := 0;
  Last := fKeywords.Count - 1;
  Result := False;
  Token := SynWideUpperCase(AKeyword);
  while First <= Last do
  begin
    I := (First + Last) shr 1;
    Compare := WideCompareText(fKeywords[i], Token);
    if Compare = 0 then
    begin
      Result := True;
      break;
    end
    else if Compare < 0 then
      First := I + 1
    else
      Last := I - 1;
  end;
end; { IsKeyWord }

function TSynMooCodeSyn.IsWordBreakChar(AChar: WideChar): Boolean;
begin
  Result := inherited IsWordBreakChar(AChar) and not IsIdentChar(AChar);
end;

constructor TSynMooCodeSyn.Create(AOwner: TComponent);
var s:String;
begin
  inherited Create(AOwner);
  fKeyWords := TStringList.Create;
  for s in keywordlist do fKeyWords.Add(s);
  TStringList(fKeyWords).Sorted := True;
  TStringList(fKeyWords).Duplicates := dupIgnore;
  fCommentAttri := TSynHighlighterAttributes.Create(SYNS_AttrComment, SYNS_FriendlyAttrComment);
  fCommentAttri.Style := [fsItalic];
  AddAttribute(fCommentAttri);
  fIdentifierAttri := TSynHighlighterAttributes.Create(SYNS_AttrIdentifier, SYNS_FriendlyAttrIdentifier);
  AddAttribute(fIdentifierAttri);
  fKeyAttri := TSynHighlighterAttributes.Create(SYNS_AttrReservedWord, SYNS_FriendlyAttrReservedWord);
  fKeyAttri.Style := [fsBold];
  AddAttribute(fKeyAttri);
  fNumberAttri := TSynHighlighterAttributes.Create(SYNS_AttrNumber, SYNS_FriendlyAttrNumber);
  AddAttribute(fNumberAttri);
  fSpaceAttri := TSynHighlighterAttributes.Create(SYNS_AttrSpace, SYNS_FriendlyAttrSpace);
  AddAttribute(fSpaceAttri);
  fStringAttri := TSynHighlighterAttributes.Create(SYNS_AttrString, SYNS_FriendlyAttrString);
  AddAttribute(fStringAttri);
  fSymbolAttri := TSynHighlighterAttributes.Create(SYNS_AttrSymbol, SYNS_FriendlyAttrSymbol);
  AddAttribute(fSymbolAttri);
  fPreprocessorAttri := TSynHighlighterAttributes.Create(SYNS_AttrPreprocessor, SYNS_FriendlyAttrPreprocessor);
  AddAttribute(fPreprocessorAttri);
  SetAttributesOnChange(DefHighlightChange);
  fVerbAttr:=TSynHighlighterAttributes.Create('Verb','Verb');
  fPropAttr:=TSynHighlighterAttributes.Create('Property','Property');
  fVerbAttr.Foreground:=clWebMagenta;
  fPropAttr.Foreground:=clWebLawnGreen;
  fListAttr:=TSynHighlighterAttributes.Create('List','List');
  fListAttr.Foreground:=clWebCyan;
  fListAttr.Style:=[fsBold];
  fStringDelim := sdSingleQuote;
  fIdentChars := cDefaultIdentChars;
  fRange := rsUnknown;
end; { Create }

destructor TSynMooCodeSyn.Destroy;
begin
  fKeyWords.Free;
  inherited Destroy;
end; { Destroy }

procedure TSynMooCodeSyn.AnsiProc;
begin
  case fLine[Run] of
     #0: NullProc;
    #10: LFProc;
    #13: CRProc;
  else
    fTokenID := tkComment;
    repeat
      if (fLine[Run] = '*') and (fLine[Run + 1] = ')') then
      begin
        fRange := rsUnKnown;
        Inc(Run, 2);
        break;
      end;
      Inc(Run);
    until IsLineEnd(Run);
  end;
end;

procedure TSynMooCodeSyn.PasStyleProc;
begin
  case fLine[Run] of
     #0: NullProc;
    #10: LFProc;
    #13: CRProc;
  else
    fTokenID := tkComment;
    repeat
      if fLine[Run] = '}' then
      begin
        fRange := rsUnKnown;
        Inc(Run);
        break;
      end;
      Inc(Run);
    until IsLineEnd(Run);
  end;
end;

procedure TSynMooCodeSyn.CStyleProc;
begin
  case fLine[Run] of
     #0: NullProc;
    #10: LFProc;
    #13: CRProc;
  else
    fTokenID := tkComment;
    repeat
      if (fLine[Run] = '*') and (fLine[Run + 1] = '/') then
      begin
        fRange := rsUnKnown;
        Inc(Run, 2);
        break;
      end;
      Inc(Run);
    until IsLineEnd(Run);
  end;
end;

procedure TSynMooCodeSyn.AsciiCharProc;
begin
  begin
    fTokenID := tkPreprocessor;
    repeat
      inc(Run);
    until not CharInSet(fLine[Run], ['0'..'9']);
  end;
end;

procedure TSynMooCodeSyn.BraceOpenProc;
begin
  if csPasStyle in fComments then
  begin
    fTokenID := tkComment;
    fRange := rsPasStyle;
    inc(Run);
    while FLine[Run] <> #0 do
      case FLine[Run] of
        '}':
          begin
            fRange := rsUnKnown;
            inc(Run);
            break;
          end;
        #10: break;

        #13: break;
      else
        inc(Run);
      end;
  end
  else
  begin
    inc(Run);
    fTokenID := tkSymbol;
  end;
end;

procedure TSynMooCodeSyn.PointCommaProc;
begin
  if (csASmStyle in fComments) or (csBasStyle in fComments) then
  begin
    fTokenID := tkComment;
    fRange := rsUnknown;
    inc(Run);
    while FLine[Run] <> #0 do
    begin
      fTokenID := tkComment;
      inc(Run);
    end;
  end
  else
  begin
    inc(Run);
    fTokenID := tkSymbol;
  end;
end;

procedure TSynMooCodeSyn.CRProc;
begin
  fTokenID := tkSpace;
  Inc(Run);
  if fLine[Run] = #10 then Inc(Run);
end;

procedure TSynMooCodeSyn.IdentProc;
begin
  while IsIdentChar(fLine[Run]) do inc(Run);
  if IsKeyWord(GetToken) then
    fTokenId := tkKey
  else
    fTokenId := tkIdentifier;
end;

procedure TSynMooCodeSyn.IntegerProc;

  function IsIntegerChar: Boolean;
  begin
    case fLine[Run] of
      '0'..'9', 'A'..'F', 'a'..'f':
        Result := True;
      else
        Result := False;
    end;
  end;

begin
  inc(Run);
  fTokenID := tkNumber;
  while IsIntegerChar do inc(Run);
end;

procedure TSynMooCodeSyn.LFProc;
begin
  fTokenID := tkSpace;
  inc(Run);
end;

procedure TSynMooCodeSyn.NullProc;
begin
  fTokenID := tkNull;
  inc(Run);
end;

procedure TSynMooCodeSyn.NumberProc;

  function IsNumberChar: Boolean;
  begin
    case fLine[Run] of
      '0'..'9', '.', 'e', 'E', 'x':
        Result := True;
      else
        Result := False;
    end;
  end;

begin
  inc(Run);
  fTokenID := tkNumber;
  while IsNumberChar do
  begin
    case FLine[Run] of
      'x': begin // handle C style hex numbers
             IntegerProc;
             break;
           end;
      '.':
        if FLine[Run + 1] = '.' then break;
    end;
    inc(Run);
  end;
end;

procedure TSynMooCodeSyn.RoundOpenProc;
begin
  inc(Run);
  if csAnsiStyle in fComments then
  begin
    case fLine[Run] of
      '*':
        begin
          fTokenID := tkComment;
          fRange := rsAnsi;
          inc(Run);
          while fLine[Run] <> #0 do
            case fLine[Run] of
              '*':
                if fLine[Run + 1] = ')' then
                begin
                  fRange := rsUnKnown;
                  inc(Run, 2);
                  break;
                end else inc(Run);
              #10: break;
              #13: break;
            else inc(Run);
            end;
        end;
      '.':
        begin
          inc(Run);
          fTokenID := tkSymbol;
        end;
    else
      begin
        FTokenID := tkSymbol;
      end;
    end;
  end else fTokenId := tkSymbol;
end;

procedure TSynMooCodeSyn.SlashProc;
begin
  Inc(Run);
  case FLine[Run] of
    '/':
      begin
        if csCPPStyle in fComments then
        begin
          fTokenID := tkComment;
          Inc(Run);
          while FLine[Run] <> #0 do
          begin
            case FLine[Run] of
              #10, #13: break;
            end;
            inc(Run);
          end;
        end
        else
          fTokenId := tkSymbol;
      end;
    '*':
      begin
        if csCStyle in fComments then
        begin
          fTokenID := tkComment;
          fRange := rsCStyle;
          Inc(Run);
          while fLine[Run] <> #0 do
            case fLine[Run] of
              '*':
                if fLine[Run + 1] = '/' then
                begin
                  fRange := rsUnKnown;
                  inc(Run, 2);
                  break;
                end else inc(Run);
              #10, #13:
                break;
              else
                Inc(Run);
            end;
        end
        else
          fTokenId := tkSymbol;
      end;
    else
      fTokenID := tkSymbol;
  end;
end;

procedure TSynMooCodeSyn.SpaceProc;
begin
  inc(Run);
  fTokenID := tkSpace;
  while (FLine[Run] <= #32) and not IsLineEnd(Run) do inc(Run);
end;

procedure TSynMooCodeSyn.StringProc;
var
   delim : WideChar;
begin
  fTokenID := tkString;
  if IsStringDelim(fLine[Run + 1]) and IsStringDelim(fLine[Run + 2]) then
    Inc(Run, 2);
  delim:=fLine[Run];
  repeat
    case FLine[Run] of
      #0 :  break;
      '\': inc(run); // Escaped.
      #10, #13: if not StringMultiLine then break;
    end;
    inc(Run);
  until FLine[Run] = delim;
  if FLine[Run] <> #0 then inc(Run);
end;

procedure TSynMooCodeSyn.UnknownProc;
begin
  inc(Run);
  fTokenID := tkUnknown;
end;

procedure TSynMooCodeSyn.VerbProc;
begin
  fTokenID := tkVerb;
  repeat
    inc(Run);
  until not AnsiContainsText(cDefaultIdentChars+'+',fLine[Run]);
end;

procedure TSynMooCodeSyn.PropertyProc;
begin
  fTokenID := tkProperty;
  repeat
    inc(Run);
  until not AnsiContainsText(cDefaultIdentChars,fLine[Run]);
end;

procedure TSynMooCodeSyn.Next;
begin
  fTokenPos := Run;
  case fRange of
    rsAnsi: AnsiProc;
    rsPasStyle: PasStyleProc;
    rsCStyle: CStyleProc;
  else
    if IsStringDelim(fLine[Run]) then
      StringProc
    else
      case fLine[Run] of
        '#': AsciiCharProc;
        ':': VerbProc;
        '.': PropertyProc;
        '{','}': begin
                   inc(run);
                   fTokenID:=tkList;
                 end;
//        '{': BraceOpenProc;
        ';': PointCommaProc;
        #13: CRProc;
        'A'..'Z', 'a'..'z', '_': IdentProc;
        '$': IntegerProc;
        #10: LFProc;
        #0: NullProc;
        '0'..'9': NumberProc;
        '(': RoundOpenProc;
        '/': SlashProc;
        #1..#9, #11, #12, #14..#32: SpaceProc;
        else UnknownProc;
      end;
  end;
  inherited;
end;

function TSynMooCodeSyn.GetDefaultAttribute(Index: integer): TSynHighlighterAttributes;
begin
  case Index of
    SYN_ATTR_COMMENT: Result := fCommentAttri;
    SYN_ATTR_IDENTIFIER: Result := fIdentifierAttri;
    SYN_ATTR_KEYWORD: Result := fKeyAttri;
    SYN_ATTR_STRING: Result := fStringAttri;
    SYN_ATTR_WHITESPACE: Result := fSpaceAttri;
    SYN_ATTR_SYMBOL: Result := fSymbolAttri;
  else
    Result := nil;
  end;
end;

function TSynMooCodeSyn.GetEol: Boolean;
begin
  Result := Run = fLineLen + 1;
end;

function TSynMooCodeSyn.GetRange: Pointer;
begin
  Result := Pointer(fRange);
end;

function TSynMooCodeSyn.GetTokenID: TtkTokenKind;
begin
  Result := fTokenId;
end;

// GetCharBeforeToken
//
function TSynMooCodeSyn.GetCharBeforeToken(offset : Integer = -1) : WideChar;
begin
   if fTokenPos+offset>=0 then
      Result:=FLine[fTokenPos+offset]
   else Result:=#0;
end;

// GetCharAfterToken
//
function TSynMooCodeSyn.GetCharAfterToken(offset : Integer = 1) : WideChar;
begin
   Result:=FLine[fTokenPos+offset];
end;

function TSynMooCodeSyn.GetTokenAttribute: TSynHighlighterAttributes;
begin
  case fTokenID of
    tkComment: Result := fCommentAttri;
    tkIdentifier: Result := fIdentifierAttri;
    tkKey: Result := fKeyAttri;
    tkNumber: Result := fNumberAttri;
    tkPreprocessor: Result := fPreprocessorAttri;
    tkSpace: Result := fSpaceAttri;
    tkString: Result := fStringAttri;
    tkSymbol:
       Result := fSymbolAttri;
    tkUnknown: Result := fSymbolAttri;
    tkVerb: result:= fVerbAttr;
    tkProperty: result:= fPropAttr;
    tkList: result:=fListAttr;
  else
    Result := nil;
  end;
  if Assigned(fOnGetTokenAttribute) then
    fOnGetTokenAttribute(Result);
end;

function TSynMooCodeSyn.GetTokenKind: integer;
begin
  Result := Ord(fTokenId);
end;

procedure TSynMooCodeSyn.ResetRange;
begin
  fRange := rsUnknown;
end;

procedure TSynMooCodeSyn.SetRange(Value: Pointer);
begin
  fRange := TRangeState(Value);
end;

procedure TSynMooCodeSyn.SetComments(Value: TCommentStyles);
begin
  if fComments <> Value then
  begin
    fComments := Value;
    DefHighLightChange(Self);
  end;
end;

class function TSynMooCodeSyn.GetLanguageName: string;
begin
  Result := SYNS_LangGeneral;
end;

function TSynMooCodeSyn.GetStringDelim: TStringDelim;
begin
  Result:=fStringDelim;
end;

procedure TSynMooCodeSyn.SetStringDelim(const Value: TStringDelim);
begin
   fStringDelim:=Value;
end;

function TSynMooCodeSyn.GetIdentifierChars: string;
begin
  Result := fIdentChars;
end;

procedure TSynMooCodeSyn.SetIdentifierChars(const Value: string);
begin
  fIdentChars := Value;
end;

function TSynMooCodeSyn.StoreIdentChars : Boolean;
begin
   Result := (fIdentChars<>cDefaultIdentChars);
end;

procedure TSynMooCodeSyn.SetDetectPreprocessor(Value: boolean);
begin
  if Value <> fDetectPreprocessor then
  begin
    fDetectPreprocessor := Value;
    DefHighlightChange(Self);
  end;
end;

class function TSynMooCodeSyn.GetFriendlyLanguageName: string;
begin
  Result := SYNS_FriendlyLangGeneral;
end;

// IsStringDelim
//
function TSynMooCodeSyn.IsStringDelim(aChar : WideChar) : Boolean;
begin
   case fStringDelim of
      sdSingleQuote : Result:=(aChar='''');
      sdDoubleQuote : Result:=(aChar='"');
   else
      Result:=(aChar='''') or (aChar='"');
   end;
end;

initialization
  RegisterPlaceableHighlighter(TSynMooCodeSyn);
end.
