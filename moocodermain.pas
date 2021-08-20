unit moocodermain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Win.ScktComp, Vcl.StdCtrls,inifiles,
  Vcl.ExtCtrls, Vcl.ComCtrls,WinAPI.RichEdit,DateUtils,StrUtils,wgplib,generics.collections,
  Vcl.Menus, Vcl.AppEvnts,ClipBrd,Math,RegularExpressions,moocoderreplace,SynEdit,SynHighlighterMooCode,
  System.Actions, Vcl.ActnList,MoocoderUtils,SynEditMiscClasses, SynEditSearch;

type
  TxControl = class of TControl;

  TExamineLine = procedure(sender:TObject; line:String) of object;
  TfrmMoocoderMain = class(TForm)
    Panel1: TPanel;
    Edit1: TEdit;
    Button1: TButton;
    client: TClientSocket;
    ckConnect: TCheckBox;
    Memo2: TMemo;
    tmrQueue: TTimer;
    pages: TPageControl;
    tbMain: TTabSheet;
    Memo1: TRichEdit;
    btnDump: TButton;
    StatusBar1: TStatusBar;
    btnCompile: TButton;
    PopupMenu1: TPopupMenu;
    GotoLine1: TMenuItem;
    ApplicationEvents1: TApplicationEvents;
    FindTab1: TMenuItem;
    NewTab1: TMenuItem;
    Refresh1: TMenuItem;
    btnVerbs: TButton;
    tbVerbs: TTabSheet;
    lvVerbs: TListView;
    Find1: TMenuItem;
    FindAgain1: TMenuItem;
    Replace1: TMenuItem;
    MainMenu1: TMainMenu;
    Project1: TMenuItem;
    Compile1: TMenuItem;
    ActionList1: TActionList;
    ActCompile: TAction;
    actVerb: TAction;
    Verb1: TMenuItem;
    actNewVerb: TAction;
    NewVerb1: TMenuItem;
    Settings1: TMenuItem;
    Connection1: TMenuItem;
    actDump: TAction;
    Dump1: TMenuItem;
    SynEditSearch1: TSynEditSearch;
    RemoveTab1: TMenuItem;
    procedure clientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure clientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure clientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure Button1Click(Sender: TObject);
    procedure ckConnectClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tmrQueueTimer(Sender: TObject);
    procedure btnDumpClick(Sender: TObject);
    procedure Memo1SelectionChange(Sender: TObject);
    procedure pagesChange(Sender: TObject);
    procedure btnCompileClick(Sender: TObject);
    procedure clientWrite(Sender: TObject; Socket: TCustomWinSocket);
    procedure Button4Click(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure GotoLine1Click(Sender: TObject);
    procedure Memo2DblClick(Sender: TObject);
    procedure FindTab1Click(Sender: TObject);
    procedure NewTab1Click(Sender: TObject);
    procedure Refresh1Click(Sender: TObject);
    procedure btnVerbsClick(Sender: TObject);
    procedure lvVerbsDblClick(Sender: TObject);
    procedure Find1Click(Sender: TObject);
    procedure FindAgain1Click(Sender: TObject);
    procedure Replace1Click(Sender: TObject);
    procedure actNewVerbExecute(Sender: TObject);
    procedure Connection1Click(Sender: TObject);
    procedure RemoveTab1Click(Sender: TObject);
    procedure lvVerbsColumnClick(Sender: TObject; Column: TListColumn);
    procedure lvVerbsCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
  private
    testtab:TTabSheet;
    getstack:Boolean;
    lastobj:String;
    lastlno:Integer;
    errorobj,errorverb:String;
    findstr:String;
    replstr:String;
    useselection:Boolean;
    replall:Boolean;
    findcase:Boolean;
    moosyn:TSynMooCodeSyn;
    procedure ProcessEscape(cmd: String);
    procedure ResetStyle;
    procedure SetBackColor(re: TRichEdit; acolor: TColor);
    procedure ProcessDump;
    function AddTab(caption,txt:String; iscode:Integer): TTabsheet;
    function CurrentEditor: TSynEdit;
    function CurrentTest:TEdit;
    procedure SetChanged(sender: TObject; value: Boolean);
    function GetLineNo: Integer;
    procedure SetLineNo(const Value: Integer);
    function TestName(tb:TTabsheet):String;
    function FindByType(aparent:TWinControl; t:String): TControl;
    procedure SyntaxHighlight(re: TRichEdit; lno: Integer);
    procedure SetSynColor(re: TRichEdit; color: TColor; lno, x, len: Integer);
    function IsInList(aword: String; const words: array of String): Boolean;
    procedure ProcessVerb(t: TStrings);
    procedure UpdateVerbs;
    procedure DoCheckName(sender: TObject; line: String);
    function FindVerbEditor(obj,verb:String): TSynEdit;
    function FindVerbHelp(obj, verb: String): String;
    procedure FetchVerb(obj, verb: String);
    procedure CheckName(obj: String);
    procedure FitListContents(alistview: TListView);
    procedure FindVerb(obj, verb: String; lno: Integer);
    function parseVerb(value: String; var obj, verb: String): Boolean;
    procedure DoFind;
    procedure DoReplace;
    procedure Doconnection;
    function EditSettings: Boolean;
    { Private declarations }
  public
    { Public declarations }
    isEsc:Boolean;
    isCSI:Boolean;
    escparams:TStringList;
    isIAT:Boolean;
    iatCMD:Char;
    currenttext:String;
    myparam:String;
    mycolor:TColor;
    myfontStyle:TFontStyles;
    myfontcolor:TColor;
    optioncount:Integer;
    server:String;
    connectcmd:String;
    msgqueue:TStringList;
    queued:TDatetime;
    dumpobject:String;
    capture:Boolean;
    captureList:String;
    lastdata:TDatetime;
    ifile:TInifile;
    sendbuffer:AnsiString;
    lastline:String;
    thisline:String;
    OnExamineLine:TExamineLine;
    SynLine:Integer;
    synWait:TDatetime;
    lastverb:String;
    verbcollect:String;
    verblist:TStringList;
    namelist:TStringList;
    whenfinished:TThreadProcedure;
    sortby:Integer;
    function StripAnsi(s:String):String;
    function SelectError(obj, verb: String; lno: Integer): Boolean;
    procedure AddChar(c:Char);
    procedure Flush;
    procedure Addln(msg:String);
    procedure AddDebug(msg:String);
    procedure SendBulk(s:AnsiString);
    procedure DoCheckCompile(sender:TObject; line:String);
    procedure DoCheckTest(sender:TObject; line:String);
    procedure DoCheckVerb(sender:TObject; line:String);
    procedure DoCheckVerbs(sender:TObject; line:String);
    property LineNo:Integer read GetLineNo write SetLineNo;
  end;

var
  frmMoocoderMain: TfrmMoocoderMain;

implementation

{$R *.dfm}

const
  ColorTable:Array[0..7] of TColor = (clBlack,clRed,clLime,clYellow,clBlue,clFuchsia, clAqua,clWhite);
  SE =  #240;  //End of subnegotiation parameters.
  NOP=  #241;  //No operation.
  DataMark=#242;    //The data stream portion of a Synch.
  BRK=#243;    // NVT character BRK.
  IP=#244; //    The function IP.
  AO=#245; //   Abort output
  AYT=#246; //    Are You There
  EC=#247; //   Erase character         The function EC.
  EL=#248; //2    Erase Line              The function EL.
  GA=#249; //    Go ahead                The GA signal.
  SB=#250; //    Indicates that what follows is subnegotiation of the indicated option.
  WILL=#251; //Indicates the desire to begin  performing, or confirmation that you are now performing, the indicated option.
  WONT=#252;  //  Indicates the refusal to perform, or continue performing, the indicated option.
  _DO=#253;   // Indicates the request that the other party perform, or confirmation that you are expecting the other party to perform, the indicated option.
  DONT=#254; // Indicates the demand that the other party stop performing, or confirmation that you are no he other party to perform, the indicated option.
  IAC=#255;

  lf=#10;
  cr=#13;
  crlf=cr+lf;

  keywords:Array[1..12] of String = ('if','then','else','elseif','for','while','endfor','endwhile','endif',
           'try','except','endtry');

function TfrmMoocoderMain.IsInList(aword:String; const words:Array of String):Boolean;
var s:String;
begin
  for s in words do
  begin
    if ansiSameText(aword,s) then exit(true);
  end;
  result:=false;
end;

procedure TfrmMoocoderMain.lvVerbsColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  sortby:=column.Index;
  lvVerbs.AlphaSort;
end;

procedure TfrmMoocoderMain.lvVerbsCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
var s1,s2:String;

  function cmpobj:Integer;
  var n1,n2:Integer;
  begin
    n1:=atol(copy(item1.Caption,2));
    n2:=atol(copy(item2.Caption,2));
    result:=n1-n2;
  end;

begin
  case sortby of
  0: begin // Obj id/Verb
       compare:=cmpobj;
       if (compare=0) then compare:=AnsiCompareText(item1.SubItems[1],item2.SubItems[1]);
     end;
  1: begin // Obj Name/Verb
       compare:=AnsiCompareText(item1.SubItems[0],item2.SubItems[0]);
       if (compare=0) then compare:=AnsiCompareText(item1.SubItems[1],item2.SubItems[1]);
     end;
  2: begin // Verb/Obj
       compare:=AnsiCompareText(item1.SubItems[1],item2.SubItems[1]);
       if (compare=0) then compare:=cmpobj;
     end;
  else
    begin
      compare:=AnsiCompareText(item1.SubItems[sortby-1],item2.SubItems[sortby-1]);
    end;
  end; {Case}
end;

procedure TfrmMoocoderMain.lvVerbsDblClick(Sender: TObject);
var nd:TListItem; obj,verb:string;
begin
  nd:=lvVerbs.Selected;
  obj:=nd.Caption;
  verb:=nd.SubItems[1];
  verb:=GetSepField(verb,1,'*');
  FindVerb(obj,verb,0);
end;

procedure TfrmMoocoderMain.FindVerb(obj,verb:String; lno:Integer);
begin
  lastlno:=lno;
  if (obj='#-1') then exit; // Not a real verb.
  if not(SelectError(obj,verb,lno)) then FetchVerb(obj,verb);
end;

function TfrmMoocoderMain.SelectError(obj, verb: String; lno: Integer):Boolean;
var i:Integer; re:TSynEdit;
begin
  for i:=2 to pages.PageCount-1 do
  begin
    re:=FindByType(pages.Pages[i],'TSynEdit') as TSynEdit;
    if (re<>nil) and (re.Lines.Count>0) then
    begin
      if AnsiContainsText(re.Lines[0]+' ',obj+':'+verb+' ') then
      begin
        pages.ActivePageIndex:=i;
        LineNo:=lno;
        CurrentEditor.SelLength:=length(currentEditor.Lines[lno]);
        CurrentEditor.SetFocus;
        pagesChange(self);
        exit(true);
      end;
    end;
  end;
  result:=false;
end;

procedure TfrmMoocoderMain.SendBulk(s: AnsiString);
begin
  sendbuffer:=sendbuffer+s;
  clientWrite(self,client.Socket);
end;

procedure TfrmMoocoderMain.SetBackColor(re:TRichEdit; acolor:TColor);
var format:TCharFormat2;
begin
  fillchar(format,sizeof(format),0);
  format.cbSize:=sizeof(format);
  SendGetStructMessage(re.Handle, EM_GETCHARFORMAT,WPARAM(SCF_SELECTION), Format, True);
  format.dwMask:=format.dwMask or CFM_BACKCOLOR;
  format.crBackColor:=acolor;
  re.Perform(EM_SETCHARFORMAT,SCF_SELECTION,@format);
end;

procedure TfrmMoocoderMain.actNewVerbExecute(Sender: TObject);
var s,obj,verb:String;
begin
  s:='';
  if not(InputQuery('Verb','New verb definition',s)) then exit;
  if not(parseVerb(s,obj,verb)) or not(obj.StartsWith('#')) then
  begin
    MessageDlg('Invalid form. #(objectid):verb dopj prep iobj'+crlf+
               'ie: #151:widget this any any',mtWarning,[mbCancel],0);
    exit;
  end;
  msgqueue.Add('@verb '+s);
  msgqueue.Add('@program '+obj+':'+verb);
  msgqueue.Add('"'+obj+':'+verb+'";');
  msgqueue.Add('.');
  whenfinished:=procedure
  begin
    FetchVerb(obj,verb);
  end;
  queued:=now;
end;

procedure TfrmMoocoderMain.AddChar(c: Char);
var iatopt:Integer; s:String;
begin
  if isIAT then
  begin
    if optioncount>0 then
    begin
      iatopt:=ord(c);
      if iatcmd=will then
      begin
        adddebug('WILL '+inttostr(iatopt));
        if iatopt=42 then client.Socket.SendText(iac+dont+Ansichar(iatopt))
        else client.Socket.SendText(iac+_do+Ansichar(iatopt));
      end
      else if iatcmd=wont then
      begin
        adddebug('WON''T '+inttostr(iatopt));
        client.Socket.SendText(iac+DONT+Ansichar(iatopt));
      end
      else if iatcmd=_DO then
      begin
        case iatopt of
        34: s:='Linemode';
        24: s:='Terminal Type';
        31: s:='Negotiate Window Size';
        else s:=inttostr(iatopt);
        end;
        adddebug('DO '+s);
        client.Socket.SENDTEXT(iac+WILL+Ansichar(iatopt));
      end
      else if iatcmd=DONT then
      begin
        adddebug('DON''T '+inttostr(iatopt));
        client.Socket.SendText(iac+WONT+Ansichar(iatopt));
      end;
      isIAT:=false;
    end
    else
    begin
      iatCMD:=c;
      if iatCMD in [WILL,WONT,_DO,DONT] then optioncount:=1
      else optioncount:=0;
      if optioncount=0 then
      begin
        adddebug('Cmd='+Inttostr(ord(iatCmd)));
        isIAT:=false;
      end;
    end
  end
  else if c=IAC then
  begin
    isIAT:=true;
    optioncount:=0;
  end
  else if c=#27 then
  begin
    flush;
    isEsc:=true;
    iscsi:=false;
    myparam:='';
    escparams.Clear;
  end
  else if isEsc then
  begin
    if isCSI then
    begin
      if c in ['0'..'9'] then myparam:=myparam+c
      else if c=';' then
      begin
        escparams.Append(myparam);
        myparam:='';
      end
      else if c in ['A'..'Z','a'..'z'] then
      begin
        escparams.Append(myparam);
        myparam:='';
        isesc:=false;
        iscsi:=false;
        ProcessEscape(c);
      end;
    end
    else if c='[' then isCSI:=true
    else isEsc:=false;
  end
  else
  begin
    lastdata:=now;
    if capture then
    begin
      captureList:=captureList+c;
      if AnsiEndsText('***finished***',capturelist) then ProcessDump;
    end;
    if (c=lf) then
    begin
      lastline:=thisline;
      thisline:='';
      if assigned(OnExamineLine) then OnExamineLine(self,trimright(lastline));
    end
    else thisline:=thisline+c;
    currentText:=currentText+c;
  end;
end;

procedure TfrmMoocoderMain.Refresh1Click(Sender: TObject);
var re:TSynEdit; obj,verb,s:String;
begin
  re:=CurrentEditor;
  if (re=nil) or (re.Parent.Tag<1) then exit;
  if (re.Lines.Count<1) then exit;
  s:=re.Lines[0];
  if ParseVerb(s,obj,verb) then
  begin
    FetchVerb(obj,verb);
  end;
end;

procedure TfrmMoocoderMain.RemoveTab1Click(Sender: TObject);
var tb:TTabSheet;
begin
  tb:=pages.ActivePage;
  if (tb.Tag<1) then exit;
  if CurrentEditor.Modified then
  begin
    if MessageDlg('Delete modified tab?',mtConfirmation,mbOkCancel,0)<>mrOK then exit;
  end;
  tb.Free;
end;

procedure TfrmMoocoderMain.Replace1Click(Sender: TObject);
begin
  with frmReplace do
  begin
    eFind.Text:=findstr;
    eReplace.Text:=replstr;
    ckSelection.Checked:=CurrentEditor.SelLength>0;
    if ShowModal=mrOK then
    begin
      findstr:=eFind.Text;
      replstr:=eReplace.Text;
      useSelection:=ckSelection.Checked;
      replall:=ckAll.checked;
      findcase:=ckCase.Checked;
      DoReplace;
    end;
  end;
end;

procedure TfrmMoocoderMain.FetchVerb(obj,verb:String);
begin
  Edit1.Text:='@list '+obj+':'+verb+' without numbers'; button1.CLick;
  Edit1.Text:=';player:tell("***finished***")'; button1.CLick;
  verbcollect:='';
  OnExamineLine:=DoCheckVerb;
end;

procedure TfrmMoocoderMain.ResetStyle;
begin
  mycolor:=clBlack;
  myfontColor:=clWhite;
  myfontStyle:=[];
end;

procedure TfrmMoocoderMain.ProcessEscape(cmd:String);
var p:String; n:Integer;

begin
  for p in escparams do
  begin
    if p='' then continue;
    n:=StrToInt(p);
    case n of
    0: ResetStyle;
    1: myfontstyle:=myfontstyle+[fsBold];
    2: myfontstyle:=myfontstyle-[fsBold];
    3: myfontstyle:=myfontstyle+[fsItalic];
    4: myfontstyle:=myfontstyle+[fsUnderline];
    9: myfontstyle:=myfontstyle+[fsStrikeOut];
    30..37: begin
              myfontcolor:=ColorTable[n mod 10];
            end;
    end;
  end;
end;

procedure TfrmMoocoderMain.AddDebug(msg: String);
begin
  Memo2.Lines.Add(msg);
end;

procedure TfrmMoocoderMain.Addln(msg: String);
begin
  memo1.Lines.Add(msg);
end;

procedure TfrmMoocoderMain.Button1Click(Sender: TObject);
begin
  client.Socket.SendText(edit1.Text+#10);
  adddebug(edit1.Text);
  edit1.Text:='';
end;

procedure TfrmMoocoderMain.btnDumpClick(Sender: TObject);
var i:Integer;
begin
  for i:=2 to pages.PageCount-1 do
  begin
    if AnsiEndsText('*',pages.Pages[i].Caption) then
    begin
      if MessageDlg('Unsaved changed. Continue?',mtWarning,mbOkCancel,0)<>mrOK then exit;
    end;
  end;
  if inputquery('Dump','Dump object id:',dumpobject) then
  begin
    while pages.PageCount>2 do pages.Pages[2].Free;
    capture:=true;
    captureList:='';
    lastdata:=now;
    Edit1.Text:='@dump '+dumpobject;
    button1.Click;
  end;
end;

procedure TfrmMoocoderMain.btnVerbsClick(Sender: TObject);
begin
  if InputQuery('Verbs','Load Verb list for object:',dumpobject) then
  begin
    msgqueue.Add('@verbs '+dumpobject);
    OnExamineLine:=DoCheckVerbs;
  end;
end;

procedure TfrmMoocoderMain.btnCompileClick(Sender: TObject);
var cmd:String; e:TEdit;
begin
  cmd:=replacestr(CurrentEditor.Text,crlf,lf);
  SendBulk(cmd+lf);
  OnExamineLine:=DoCheckCompile;
  e:=CurrentTest;
  if assigned(e) then
  begin
    ifile.WriteString('Test',TestName(pages.ActivePage),e.Text);
  end;
end;

procedure TfrmMoocoderMain.Button4Click(Sender: TObject);
var p:TPOINTL;
begin
  CurrentEditor.perform(EM_POSFROMCHAR,cardinal(@p),currenteditor.SelStart);
  adddebug('POS: '+inttostr(p.x)+','+inttostr(p.y));
end;

procedure TfrmMoocoderMain.ckConnectClick(Sender: TObject);
begin
  client.Active:=ckConnect.Checked;
end;

procedure TfrmMoocoderMain.clientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
 addln('Connected');
 ckConnect.Checked:=true;
 if (connectcmd<>'') then
 begin
   msgqueue.Add(connectcmd);
 end;
end;

procedure TfrmMoocoderMain.clientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  addln('Disconnected');
  ckConnect.Checked:=false;
end;

procedure TfrmMoocoderMain.clientRead(Sender: TObject; Socket: TCustomWinSocket);
var c:AnsiChar;
begin
//  addln(socket.ReceiveText);
  for c in socket.ReceiveText do AddChar(Char(c));
  flush;
end;

procedure TfrmMoocoderMain.clientWrite(Sender: TObject; Socket: TCustomWinSocket);
var sent:Integer;
begin
  if (sendbuffer<>'') then
  begin
    sent:=client.Socket.SendText(sendbuffer);
    if (sent>0) then delete(sendbuffer,1,sent);
  end;
end;

procedure TfrmMoocoderMain.Flush;
begin
  if currentText<>'' then
  begin
    memo1.SelStart:=length(memo1.Text);
    memo1.SelAttributes.Color:=myfontcolor;
    memo1.SelAttributes.Style:=myfontstyle;
    memo1.SelAttributes.Name:='Courier';
    memo1.seltext:=currenttext;
    SetBackColor(memo1,mycolor);
    currenttext:='';
    SendMessage(memo1.handle, WM_VSCROLL, SB_BOTTOM, 0);
  end;
end;

procedure TfrmMoocoderMain.FormCreate(Sender: TObject);
begin
  ifile:=OpenIniFile('moocoder.ini');
  escparams:=TStringList.Create;
  mycolor:=clBlack;
  myfontStyle:=[];
  myfontcolor:=clwhite;
  msgqueue:=TStringList.Create;
  ckConnect.Checked:=client.Active;
  dumpobject:=ifile.ReadString('Settings','LastDump','');
  verblist:=TStringList.Create;
  verblist.Sorted:=true;
  verblist.Duplicates:=dupIgnore;
  namelist:=TStringList.Create;
  whenfinished:=procedure begin doConnection; end;
  pages.ActivePage:=tbMain;
  moosyn:=TSynMooCodeSyn.Create(self);
  moosyn.StringAttribute.Foreground:=clYellow;
  moosyn.KeywordAttribute.Foreground:=clWebCyan;
  moosyn.PreprocessorAttri.Foreground:=clWebSalmon;
  moosyn.StringDelim:=sdDoubleQuote;
  moosyn.DetectPreprocessor:=true;
end;

procedure TfrmMoocoderMain.FormDestroy(Sender: TObject);
begin
  ifile.WriteString('Settings','LastDump',dumpobject);
  freeandnil(ifile);
  freeandnil(msgqueue);
  freeandnil(verblist);
  freeandnil(namelist);
end;

function TfrmMoocoderMain.GetLineNo: Integer;
var  e:TSynEdit;
begin
  result:=0;
  e:=currenteditor;
  if assigned(e) then result:=e.CaretY-1;
end;

procedure TfrmMoocoderMain.GotoLine1Click(Sender: TObject);
var s:String;
begin
  s:=inttostr(lineno);
  if inputquery('Goto Line','Line no:',s) then
  begin
    LineNo:=atol(s);
  end;
end;

procedure TfrmMoocoderMain.Memo1Change(Sender: TObject);
begin
  SetChanged(sender,true);
  if sender=CurrentEditor then
  begin
    synline:=min(lineno,synline);
    SynWait:=now;
  end;
end;

procedure TfrmMoocoderMain.SetChanged(sender:TObject; value:Boolean);
var re:TRichEdit; tb:TTabsheet; s:String;
begin
  if not(sender is TRichedit) then exit;
  re:=sender as TRichEdit;
  if re=memo1 then exit;
  re.Modified:=value;
  tb:=re.Parent as TTabsheet;
  s:=tb.Caption;
  if (s.EndsWith('*')) then delete(s,length(s),1);
  if value then s:=s+'*';
  tb.Caption:=s;
end;

procedure TfrmMoocoderMain.SetLineNo(const Value: Integer);
var x:Integer; e:TSynEdit;
begin
  e:=CurrentEditor;
  e.CaretY:=value+1;
end;

procedure TfrmMoocoderMain.Memo1SelectionChange(Sender: TObject);
begin
  StatusBar1.Panels[1].Text:=inttostr(LineNo);
end;

procedure TfrmMoocoderMain.Memo2DblClick(Sender: TObject);
var lno:Integer; line:String; prog,obj,verb:String;
begin
//  ... called from #540:stacker (this == #540), line 2
  lno:=memo2.Perform(EM_LINEFROMCHAR, memo2.SelStart, 0);
  line:=memo2.Lines[lno];
  if trim(line).StartsWith('... called from') then
  begin
    delete(line,1,pos('#',line)-1);
    prog:=ParseSepField(line,',');
    Parse(line);
    lno:=atol(line);
    if ParseVerb(prog,obj,verb) then
    begin
      FindVerb(obj,verb,lno);
    end;
  end;
end;

procedure TfrmMoocoderMain.NewTab1Click(Sender: TObject);
var s:String; obj,verb:String;
begin
  s:='';
  if inputquery('New Tab','Enter obj:verb',s) then
  begin
    if not(parseVerb(s,obj,verb)) then
    begin
      MessageDlg('Invalid syntax',mtWarning,[mbCancel],0);
      exit;
    end;
    FindVerb(obj,verb,0);
  end;
end;

function TfrmMoocoderMain.StripAnsi(s: String): String;
var esc:Boolean; ancode:Boolean; c:Char;
begin
  result:='';
  esc:=false; ancode:=false;
  for c in s do
  begin
    if (c=#27) then esc:=true
    else if esc then
    begin
      if ancode then
      begin
        if c in ['A'..'Z','a'..'z'] then
        begin
          ancode:=false;
          esc:=false;
        end;
      end
      else if (c='[') then ancode:=true
      else esc:=false;
    end
    else result:=result+c;
  end;
end;

function TfrmMoocoderMain.TestName(tb: TTabsheet): String;
var s:String;
begin
  s:=tb.Caption;
  s:=replacestr(s,'*','');
  s:=replacestr(s,'=','_');
  result:=s;
end;

procedure TfrmMoocoderMain.tmrQueueTimer(Sender: TObject);
var cmd:String; tmp:TThreadProcedure;
begin
  if (msgqueue.Count>0) then
  begin
    cmd:=msgqueue[0];
    msgqueue.Delete(0);
    edit1.Text:=cmd;
    button1.Click;
    lastdata:=now;
  end;
  if capture and (SecondsBetween(now,lastdata)>=2) then
  begin
    ProcessDump;
  end;
  if (assigned(whenfinished)) and (SecondsBetween(now,lastdata)>=2) then
  begin
    tmp:=whenfinished;
    whenfinished:=nil;
    tmp();
  end;
end;

procedure TfrmMoocoderMain.Connection1Click(Sender: TObject);
begin
  if EditSettings then Doconnection;
end;

function TfrmMoocoderMain.CurrentEditor:TSynEdit;
var c:TControl; tb:TTabSheet; i:Integer;
begin
  tb:=pages.ActivePage;
  for i:=0 to tb.ControlCount-1 do
  begin
    c:=tb.Controls[i];
    if (c is TSynEdit) then
    begin
      exit(c as TSynEdit);
      break;
    end;
  end;
  result:=nil;
end;

procedure TfrmMoocoderMain.Find1Click(Sender: TObject);
begin
  if inputquery('Find','Search',findstr) then DoFind;
end;

procedure TfrmMoocoderMain.FindAgain1Click(Sender: TObject);
begin
  if findstr<>'' then DoFind;
end;

procedure TfrmMoocoderMain.DoFind;
var ret:Integer;
begin
  if not(assigned(CurrentEditor.SearchEngine)) then
  begin
    CurrentEditor.SearchEngine:=SynEditSearch1;
  end;
  ret:=CurrentEditor.SearchReplace(findstr,findstr,[]);
  if (ret<=0) then
  begin
    CurrentEditor.SelStart:=0;
    CurrentEditor.SearchReplace(findstr,findstr,[]);
  end;
end;

procedure TfrmMoocoderMain.DoReplace;
var tmp,orig:String; ix,loc,savestart:Integer; t:TStringList; header:String; flags:TReplaceFlags;
begin
  if findstr='' then exit;
  t:=TStringList.Create;
  header:='';
  orig:=ReplaceStr(CurrentEditor.Text,crlf,lf);
  savestart:=CurrentEditor.SelStart;
  try
    if useselection then t.text:=CurrentEditor.SelText
    else
    begin
      if replAll then
      begin
        t.text:=CurrentEditor.Text;
        if (t.Count>0) then
        begin
          header:=t[0];
          t.Delete(0);
        end;
      end
      else
      begin
        tmp:=replacestr(currenteditor.Text,crlf,lf);
        t.text:=copy(tmp,CurrentEditor.SelStart,length(tmp));
      end;
    end;
    tmp:=replacestr(t.text,crlf,lf);
    flags:=[];
    if not(findcase) then flags:=flags+[rfIgnoreCase];
    if replall then flags:=flags+[rfReplaceAll];
    tmp:=StringReplace(tmp,findstr,replstr,flags);
    if useselection then CurrentEditor.SelText:=tmp
    else
    begin
      if replall then
      begin
        if header<>'' then tmp:=header+lf+tmp;
      end
      else tmp:=copy(orig,1,currenteditor.SelStart)+tmp;
      Currenteditor.Text:=tmp;
      CurrentEditor.SelStart:=savestart;
    end;
    SynLine:=0;
  finally
    t.Free;
  end;
end;


function TfrmMoocoderMain.FindByType(aparent:TWinControl; t:String):TControl;
var c:TControl; i:Integer; w:TWincontrol;
begin
  for i:=0 to aparent.ControlCount-1 do
  begin
    c:=aparent.Controls[i];
    if AnsiSameText(c.ClassName,t) then
    begin
      exit(c);
    end;
    if (c is TWinControl) then
    begin
      w:=c as TWinControl;
      if w.ControlCount>0 then
      begin
        result:=FindByType(w,t);
        if result<>nil then exit;
      end;
    end;
  end;
  result:=nil;
end;

procedure TfrmMoocoderMain.FindTab1Click(Sender: TObject);
begin
  if InputQuery('Verb','Enter verb',lastverb) then
  begin
    if SelectError('',lastverb,0) then pages.ActivePage.PageIndex:=2;
  end;
end;

function TfrmMoocoderMain.CurrentTest: TEdit;
var c:TControl; tb:TTabSheet; i:Integer;
begin
  tb:=pages.ActivePage;
  result:=FindByType(tb,'TEdit') as TEdit;
end;

procedure TfrmMoocoderMain.DoCheckCompile(sender: TObject; line: String);
var lno,x,n:Integer; s1,s2:String;  e:TEdit;
begin
  adddebug(line);
  if (line.StartsWith('Line ')) then
  begin
    s1:=parseSepField(line,':');
    lno:=atol(copy(s1,5,255));
    CurrentEditor.Carety:=lno+1;
    CurrentEditor.CaretX:=1;
    n:=length(currenteditor.Lines[lno]);
    CurrentEditor.SelLength:=n;
    CurrentEditor.SetFocus;
//e 5:  syntax error
//1 error(s).
//Verb not programmed.
    adddebug('Error found: '+line);
  end
  else if line='Verb not programmed.' then
  begin
    OnExamineLine:=nil;
  end
  else if line='Verb programmed.' then
  begin
    adddebug('Compiled OK.');
    OnExamineLine:=nil;
    SetChanged(CurrentEditor,false);
    e:=CurrentTest;
    if assigned(e) and (trim(e.Text)<>'') then
    begin
      msgqueue.add(e.Text);
      testtab:=pages.ActivePage;
      onExamineLine:=DoChecktest;
      getstack:=false;
      pages.ActivePage:=tbMain;
    end;
  end;
end;

procedure TfrmMoocoderMain.DoCheckTest(sender: TObject; line: String);
var obj,prog,verb,lno,error:String; i:Integer; re:TRichEdit;
begin
  if (getstack) then adddebug(line);
  //#540:test (this == #540), line 5:  Type mismatch (expected integer; got float)
  //#151:+attacks, line 9:  Verb not found: #548:energy_cast()
  //#151:+deploy deploy, line 28:  Range error
  if line.StartsWith('#') and line.Contains(', line') then
  begin
    adddebug(line);
    prog:=ParseSepField(line,',');
    Parse(line); // Skip "line"
    lno:=ParseSepField(line,':');
    parseVerb(prog,obj,verb);     //Should strip out trailing defs.
    error:=line;
    getstack:=true;
    errorverb:='';
    if not SelectError(obj,verb,atol(lno)) then
    begin
      errorverb:=verb;
      errorobj:=obj;
      lastlno:=atol(lno);
    end;
  end
  else if (line='(End of traceback)') then
  begin
    getstack:=false;
    if errorverb<>'' then FindVerb(errorobj,errorverb,lastlno);
    errorverb:='';
  end;
end;

function TfrmMoocoderMain.parseVerb(value:String; var obj,verb:String):Boolean;
var i:Integer;
begin
  if value.StartsWith('@') then parse(value);
  obj:=parseSepFIeld(value,':');
  verb:=parse(value);
  if (verb.StartsWith('"')) then verb:=GetSepField(verb,2,'"');
  i:=pos('*',verb);
  if (i>0) then verb:=copy(verb,1,i-1);
  result:=(verb<>'') and (obj<>'');
end;

procedure TfrmMoocoderMain.DoCheckVerb(sender: TObject; line: String);
var t:TStringList; prog,s,obj,verb:String; i:Integer;
begin
  if (line.Contains('***finished***')) then
  begin
    OnExamineLine:=nil;
    t:=TStringList.Create;
    try
      t.Text:=verbcollect;
      t.Add('.');
      prog:=t[0];
      if (prog='That object does not define that verb.') then
      begin
        showmessage('Verb not found.');
        exit;
      end;
      for i:=0 to t.Count-1 do
      begin
        if t[i].EndsWith('[normal]') then // Stupid ansi is stupid.
        begin
          s:=t[i];
          t[i]:=copy(s,1,length(s)-length('[normal]'));
        end;
      end;
      obj:=parsesepfield(prog,':');
      verb:=parse(prog);
      if (verb.StartsWith('"')) then verb:=GetSepField(verb,2,'"');
      i:=pos('*',verb);
      if (i>0) then verb:=copy(verb,1,i-1);
      t[0]:='@program '+obj+':'+verb;
      if SelectError(obj,verb,lastlno) then
      begin
        CurrentEditor.lines.assign(t);
        synline:=0;
      end
      else
      begin
        pages.ActivePage:=AddTab(obj+':'+verb,t.Text,1);
        synline:=0;
        SelectError(obj,verb,lastlno);
      end;
      lastlno:=0;
      CheckName(obj);
      verblist.Add(obj+':'+verb);
      UpdateVerbs;
    finally
      freeandnil(t);
    end;
  end
  else verbcollect:=verbcollect+line+crlf;
end;

procedure TfrmMoocoderMain.DoCheckVerbs(sender: TObject; line: String);
var t:TStringList; obj,verb:String; s,s1:String; i:Integer;
begin
  OnExamineLine:=DoCheckTest;
  if not(line.StartsWith(';verb',true)) then
  begin
    MessageDlg('Verb not found.'+crlf+line,mtError,[mbCancel],0);
    exit;
  end;
  t:=TStringList.Create;
  parsesepfield(line,'(');
  obj:=parseSepField(line,')');
  parseSepField(line,'{');
  line:=trim(line);
  if AnsiEndsText('}',line) then delete(line,length(line),1);
  for i:=verblist.Count-1 downto 0 do
  begin
    if verblist[i].StartsWith(obj+':') then verblist.Delete(i);
  end;
  Explode(line,',',t);
  for s1 in t do
  begin
    s:=s1;
    delete(s,1,1);
    delete(s,length(s),1);
    verb:=GetField(s,1);
    VerbList.Add(obj+':'+verb);
  end;
  CheckName(obj);
  UpdateVerbs;
end;

procedure TfrmMoocoderMain.Doconnection;
begin
  server:=ifile.ReadString('Connection','Server','');
  if (server='') then
  begin
    if not EditSettings then exit;
  end;
  server:=ifile.ReadString('Connection','Server','');
  connectcmd:=ifile.ReadString('Connection','Login','');
  client.Active:=false;
  client.Host:=getsepfield(server,1,':');
  client.Port:=atol(getsepfield(server,2,':'));
  client.Active:=true;
end;

function TfrmMoocoderMain.EditSettings:Boolean;
var settings:Array of String;
begin
  setlength(settings,2);
  settings[0]:=server;
  settings[1]:=connectcmd;
  result:=InputQuery('Connection Settings',['Server','Login'],settings);
  if result then
  begin
    server:=settings[0];
    connectcmd:=settings[1];
    ifile.WriteString('Connection','Server',server);
    ifile.WriteString('Connection','Login',connectcmd);// 'connect robbie SRTDumpling';
  end;
end;

procedure TfrmMoocoderMain.FitListContents(alistview: TListView);
var
  w: Array of Integer;
  i, j, n: Integer;
  nd: TListItem;
  cnv: TCanvas;
  s: String;
begin
  if alistview.viewstyle <> vsReport then
    exit;
  if alistview.columns.Count < 1 then
    exit;
  if alistview.Items.Count < 1 then
    exit;
  alistview.Items.BeginUpdate;
  try
    setlength(w, alistview.columns.Count);
    for i := low(w) to high(w) do
      w[i] := 0;
    cnv := alistview.canvas;
    cnv.font.assign(alistview.font);
    if alistview.ShowColumnHeaders then
    begin
      for i := 0 to alistview.columns.Count - 1 do
      begin
        w[i] := cnv.TextWidth(alistview.columns[i].Caption);
      end;
    end;
    for j := 0 to alistview.Items.Count - 1 do
    begin
      nd := alistview.Items[j];
      n := min( high(w), nd.subitems.Count);
      for i := 0 to n do
      begin
        if i = 0 then
          s := nd.Caption
        else
          s := nd.subitems[i - 1];
        w[i] := max(w[i], cnv.TextWidth(s));
      end;
    end;
    if (alistview.CheckBoxes) then
      w[0] := w[0] + 24;
    for i := low(w) to high(w) do
    begin
      alistview.columns[i].width := w[i] + cnv.TextWidth('    ');
    end;
  finally
    alistview.Items.EndUpdate;
  end;
end;

procedure TfrmMoocoderMain.CheckName(obj:String);
begin
  if namelist.IndexOfName(obj)<0 then
  begin
    msgqueue.Add(';'+obj+'.name');
    OnExamineLine:=DoCheckName;
  end;
  lastobj:=obj;
end;

procedure TfrmMoocoderMain.DoCheckName(sender: TObject; line: String);
var aname:String;
begin
  if AnsiContainsText(line,'***finished***') then exit; // Ignore trailing stuff.
  if line.StartsWith('=> 0') then exit;// tailing result.
  OnExamineLine:=DoCheckTest;
  if not(line.StartsWith('=>')) then
  begin
    adddebug('Name not found.');
    exit;
  end;
  aname:=GetSepfield(line,2,'"');
  namelist.values[lastobj]:=aname;
  UpdateVerbs;
end;

procedure TfrmMoocoderMain.UpdateVerbs;
var nd:TListItem; s:String; obj,verb:String;
    oldverb,oldobj:String; i:Integer;
begin
  lvVerbs.Items.BeginUpdate;
  try
    oldverb:='';
    nd:=lvVerbs.Selected;
    if (nd<>nil) then
    begin
      oldobj:=nd.Caption;
      oldverb:=nd.SubItems[1];
    end;
    lvVerbs.Items.Clear;
    for s in verblist do
    begin
      nd:=lvVerbs.Items.Add;
      obj:=GetSepField(s,1,':');
      verb:=GetSepField(s,2,':');
      nd.Caption:=obj;
      nd.SubItems.Add(namelist.Values[obj]); // Name
      nd.SubItems.Add(verb);
      nd.SubItems.Add(FindVerbHelp(obj,verb));
    end;
    FitListContents(lvVerbs);
    if oldverb<>'' then
    begin
      for i:=0 to lvVerbs.Items.Count-1 do
      begin
        nd:=lvVerbs.Items[i];
        if AnsiSameText(nd.Caption,oldobj) and AnsiSameText(nd.SubItems[1],oldverb) then
        begin
          lvVerbs.ItemIndex:=i;
          break;
        end;
      end;
    end;
  finally
    lvVerbs.Items.EndUpdate;
  end;
end;

function TfrmMoocoderMain.FindVerbHelp(obj,verb:String):String;
var re:TSynEdit; s:String;
begin
  re:=FindVerbEditor(obj,verb);
  result:='No Help';
  if assigned(re) and (re.Lines.Count>=2) then
  begin
    s:=re.Lines[1];
    if (s.StartsWith('"')) then
    begin
      delete(s,1,1);
      delete(s,length(s)-1,2);
      result:=s;
    end;
  end;
end;

function TfrmMoocoderMain.FindVerbEditor(obj,verb:String):TSynEdit;
var i:Integer; re:TSynEdit; tb:TTabSheet; s:String; searchverb:String;
    averb,aobj:String;
begin
  searchverb:=GetSepField(verb,1,'*'); // Handle wildcards.
  for i:=1 to pages.PageCount-1 do
  begin
    tb:=pages.Pages[i];
    if tb.Tag<1 then continue;
    re:=FindByType(pages.Pages[i],'TSynEdit') as TSynEdit;
    if re<>nil then
    begin
      if re.Lines.Count>1 then
      begin
        s:=re.lines[0];
        if ParseVerb(s,aobj,averb) then
        begin
          if AnsiSameText(aobj,obj) and AnsiSameText(averb,searchverb) then exit(re);
        end;
      end;
    end;
  end;
  result:=nil;
end;

procedure TfrmMoocoderMain.pagesChange(Sender: TObject);
begin
  if CurrentEditor<>nil then Memo1SelectionChange(currentEditor);
  actCompile.Enabled:=pages.ActivePage.Tag>=1;
  synline:=0;
end;

procedure TfrmMoocoderMain.ProcessDump;
var t,t1:TStringList; s:String; cap:Boolean; prog,obj:String;
begin
  addln('Capture complete.');
  capture:=false;
  AddTab('Dump',capturelist,0);
  t:=TStringList.Create;
  t1:=TStringList.Create;
  t.Text:=capturelist;
  cap:=false;
  for s in t do
  begin
    if not(cap) and AnsiStartsText('@program',s) then
    begin
      t1.Clear;
      cap:=true;
      prog:=s;
    end;
    if (cap) then
    begin
      t1.Add(s);
      if (s='.') then
      begin
        cap:=false;
        ProcessVerb(t1);
      end;
    end;
  end;
  freeandnil(t);
  freeandnil(t1);
  pagesChange(self);
  SetChanged(memo1,false);
  s:=prog;
  Parse(s);
  obj:=ParseSepField(s,':');
  CheckName(obj);
  UpdateVerbs;
end;

procedure TfrmMoocoderMain.ProcessVerb(t:TStrings);
var prog,obj,verb:String; s:String;
begin
  prog:=t[0];
  AddTab(GetSepField(prog,2,':'),t.text,1);
  s:=prog;
  parse(s);
  obj:=parsesepfield(s,':');
  verb:=parse(s);
  verblist.Add(obj+':'+verb);
end;

function TfrmMoocoderMain.AddTab(caption,txt:String; iscode:Integer):TTabsheet;
var tb:TTabsheet; edit:TSynEdit; pn:TPanel; ed:TEdit; lb:TLabel;
begin
  tb:=TTabSheet.Create(self);
  tb.Tag:=iscode;
  tb.PageControl:=pages;
  tb.Caption:=caption;
  edit:=TSynEdit.Create(tb);
  edit.Parent:=tb;
  edit.Align:=alClient;
  edit.Text:='';
  edit.Perform(EM_SETTEXTMODE,TM_MULTILEVELUNDO or TM_RICHTEXT,0);
//  adddebug('Undo='+inttostr(edit.Perform(EM_SETUNDOLIMIT,20,0)));
  edit.text:=txt;
  edit.Font.Charset := DEFAULT_CHARSET;
  edit.Font.Color := clWhite;
//  edit.Font.Height := -13;
  edit.Font.Size:=12;
  edit.Font.Name := 'Courier New';
  edit.Font.Style := [];
//  edit.Font.Assign(memo1.font);
  edit.color:=memo1.color;
  tb.TabVisible:=true;
  edit.ScrollBars:=ssBoth;
  edit.HideSelection:=false;
  edit.OnChange:=Memo1Change;
  edit.Highlighter:=moosyn;
  edit.RightEdge:=0;
  edit.Gutter.ShowLineNumbers:=true;
  edit.Gutter.LineNumberStart:=0;
  SetChanged(edit,false);
  if iscode>=1 then
  begin
    pn:=TPanel.Create(tb);
    pn.Parent:=tb;
    pn.Caption:='';
    pn.Align:=alBottom;
    lb:=TLabel.Create(tb);
    lb.Parent:=pn;
    lb.Caption:='Test: ';
    lb.Align:=alLeft;
    ed:=TEdit.Create(tb);
    ed.Parent:=pn;
    ed.Text:=ifile.ReadString('Test',TestName(tb),'');
    pn.ClientHeight:=ed.Height;
    ed.Align:=alClient;
  end;
  exit(tb);
end;

procedure TfrmMoocoderMain.SyntaxHighlight(re:TRichEdit; lno:Integer);
var isquote,isescaped:Boolean; c:Char; line:String; startx,x:Integer; myword:String;
     color:TCOlor; wordonly:Boolean;  isverb,isproperty:Boolean; nextcolor:TColor;
     saveline,savestart,savelen:Integer;

  function NextWord:String;
  begin
    result:='';
    while x<=length(line) do
    begin
      c:=line[x];
      if pos(c,' "()[]+-/\*:.{}')>0 then
      begin
        if result='' then
        begin
          result:=c;
          inc(x);
        end;
        exit;
      end;
      result:=result+c;
      inc(x);
    end;
  end;

begin
  if (lno>=re.lines.count) or (lno<0) then exit;
  re.Lines.BeginUpdate;
  try
    re.OnSelectionChange:=nil;
    re.OnChange:=nil;
    line:=re.Lines[lno];
    isquote:=false;
    isescaped:=false;
    isverb:=false;
    isproperty:=true;
    wordonly:=false;
    x:=1;
    color:=clWhite;
    nextcolor:=clWhite;
    savestart:=re.SelStart;
    savelen:=re.SelLength;
    saveline:=re.perform( EM_GETFIRSTVISIBLELINE, 0, 0 );
    while (x<length(line)) do
    begin
      startx:=x;
      myword:=nextword;
      if (isEscaped) then
      begin
        isEscaped:=false;
      end
      else if isquote then
      begin
        color:=clYellow;
        if myword='\' then
        begin
          isEscaped:=true;
          color:=clWebOrange;
        end
        else if myword='"' then
        begin
          isQuote:=false;
          wordonly:=true;
        end;
      end
      else if (myword='"') then
      begin
        isQuote:=true;
        color:=clYellow;
      end
      else
      begin
        if myword=':' then nextcolor:=clwebMagenta
        else if myword='.' then nextColor:=clwebLawnGreen
        else if (nextcolor<>clWhite) then
        begin
          color:=nextcolor;
          nextcolor:=clWhite;
          wordonly:=true;
        end
        else if IsInList(myword,keywords) then begin color:=clWebCyan; wordonly:=true; end;
      end;
      SetSynColor(re,color,lno,startx,x-startx);
      if wordonly then color:=clWhite;
      wordonly:=false;
    end;
    re.SelStart:=savestart;
    re.SelLength:=savelen;

    re.Perform(EM_LINESCROLL,0,saveline-re.perform( EM_GETFIRSTVISIBLELINE, 0, 0 ));
  finally
    re.Lines.EndUpdate;
    re.OnSelectionChange:=Memo1SelectionChange;
    re.OnChange:=Memo1Change;
  end;
end;

procedure TfrmMoocoderMain.SetSynColor(re:TRichEdit; color:TColor; lno,x,len:Integer);
var format:TCharFormat2;
begin
  re.SelStart:=re.Perform(EM_LINEINDEX,lno,0)+(x-1);
  re.SelLength:=len;
  re.SelAttributes.Color:=color;
end;

end.
