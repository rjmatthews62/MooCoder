unit moocoderUtils;

interface
uses windows,shlobj,forms,sysutils,inifiles;

function IsVista: Boolean;
function LocalAppData:String;
function AppDataFolder:String;
function VersionNumber: String;

// Handle INI location - best default location differe.
function OpenIniFile(filename:String):TInifile;

implementation

function IsVista: Boolean;
var
  v: OSVERSIONINFO;
begin
  FillChar(v, sizeof(v), 0);
  v.dwOSVersionInfoSize := sizeof(v);
  GetVersionEx(v);
  Result := (v.dwMajorVersion >= 6);
end;


function LocalAppData:String;
var
  buf: Array [0 .. 512] of Char;
begin
  SHGetFolderPath(0, CSIDL_LOCAL_APPDATA, 0, 0, buf);
  result:=buf;
end;

function AppDataFolder:String;
begin
  result:=LocalAppData+'\Moocoder';
  ForceDirectories(result);
end;

// Handle INI location - best default location differe.
function OpenIniFile(filename:String):TInifile;
var newname:String;
begin
  if not(IsVista) then
  begin
    newname:=filename;
  end
  else
  begin
    newname:=AppDataFolder+'\'+filename;
  end;
  result:=TInifile.Create(newname);
end;

function GetVersion(afilename:String): String;
var
  aversion: String;
  Len, n: DWord;
  value, buf: pchar;
  p: Pointer;
  s: String;
begin
  aversion := afilename;
  n := GetFileVersionInfoSize(pchar(aversion), n);
  if n > 0 then
  begin
    buf := AllocMem(n);
    GetFileVersionInfo(pchar(aversion), 0, n, buf);
    VerQueryValue(buf, '\VarFileInfo\Translation', p, Len);
    s := inttohex(MakeLong(HiWord(Longint(p^)), LoWord(Longint(p^))), 8);
    aversion := 'Unknown';
    if VerQueryValue(buf, pchar('\StringFileInfo\' + s + '\FileVersion'),
      Pointer(value), Len) then
      aversion := value;
    FreeMem(buf, n);
  end
  else
    aversion := 'Unknown';
  result := aversion;
end;

function VersionNumber: String;
begin
  result:=getVersion(Application.exename);
end;

end.
