unit moocoderUtils;

interface
uses windows,shlobj,sysutils,inifiles;

function IsVista: Boolean;
function LocalAppData:String;
function AppDataFolder:String;
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

end.
