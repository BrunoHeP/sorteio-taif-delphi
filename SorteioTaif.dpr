program SorteioTaif;

uses
  Vcl.Forms,
  frmMain in 'frmMain.pas' {frmSorteio},
  uDM in 'uDM.pas' {dmConexao: TDataModule},
  uEntidades in 'uEntidades.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmSorteio, frmSorteio);
  Application.CreateForm(TdmConexao, dmConexao);
  Application.Run;
end.
