unit uDM;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, Forms,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Phys.FB, FireDAC.Phys.FBDef, System.IOUtils;

type
  TdmConexao = class(TDataModule)
    Conn : TFDConnection;
    dsConsulta : TDataSource;
    ExecutaComando : TFDQuery;
    ExecutarConsulta : TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure InserirDadosBD(const ASQL: string);
    procedure ExecutarSql(const ASQL: string);
  end;

var
  dmConexao: TdmConexao;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TdmConexao.DataModuleCreate(Sender: TObject);
var
  CaminhoBD, LogMsg : string;
begin
  CaminhoBD := ExtractFilePath(Application.ExeName);
  CaminhoBD := CaminhoBD + 'SORTEIO_TAIF.FDB';

  with Conn.Params do
  begin
    Clear;
    DriverID := 'FB';
    Database := CaminhoBD;
    UserName := 'SYSDBA';
    Password := 'masterkey';
    Add('CharacterSet=UTF8');
    Add('Protocol=Local');

  end;

  try
    Conn.Connected := True;
  except
    on E: Exception do
    begin
      LogMsg := Format('[%s] Erro: %s' + sLineBreak + 'BD: %s' + sLineBreak + sLineBreak,
        [FormatDateTime('dd/mm/yyyy hh:nn:ss', Now), E.Message, CaminhoBD]);

      TFile.AppendAllText('logconexao.txt', LogMsg, TEncoding.UTF8);
      end;
  end;
end;


procedure TdmConexao.InserirDadosBD(const ASQL: string);
begin
  with ExecutaComando do
  begin
    close;
    sql.Text := ASQL;
    ExecSQL
  end;


end;

procedure TdmConexao.ExecutarSql(const ASQL: string);
begin
  with ExecutarConsulta do
  begin
    close;
    sql.Text := ASQL;
    Open;
  end;
end;

end.
