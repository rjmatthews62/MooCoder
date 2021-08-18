unit moocoderReplace;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfrmReplace = class(TForm)
    Label1: TLabel;
    eFind: TEdit;
    Label2: TLabel;
    eReplace: TEdit;
    ckSelection: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    ckAll: TCheckBox;
    ckCase: TCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmReplace: TfrmReplace;

implementation

{$R *.dfm}

end.
