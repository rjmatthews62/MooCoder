// JCL_DEBUG_EXPERT_GENERATEJDBG OFF
// JCL_DEBUG_EXPERT_INSERTJDBG OFF
program moocoder;

uses
  Vcl.Forms,
  moocodermain in 'moocodermain.pas' {frmMoocoderMain},
  wgplib in 'wgplib.pas',
  moocoderReplace in 'moocoderReplace.pas' {frmReplace},
  moocoderUtils in 'moocoderUtils.pas',
  SynHighlighterMooCode in 'SynHighlighterMooCode.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMoocoderMain, frmMoocoderMain);
  Application.CreateForm(TfrmReplace, frmReplace);
  Application.Run;
end.
