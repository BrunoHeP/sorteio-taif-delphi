unit frmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, uClasses,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, uDM, Vcl.Buttons, Vcl.ExtCtrls;

type
  TfrmSorteio = class(TForm)
    dbgDados: TDBGrid;
    Label1: TLabel;
    Label2: TLabel;
    btnSortear: TBitBtn;
    btnConsultar: TBitBtn;
    btnDeletar: TBitBtn;
    edtAno: TEdit;
    edtIniCpf: TEdit;
    Panel1: TPanel;
    edtQtdModelo: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    rdgFiltros: TRadioGroup;
    btnNovosClientes: TBitBtn;
    btnCarrosNovos: TBitBtn;
    btnNovasVendas: TBitBtn;
    procedure btnSortearClick(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure AjustarColunasDBGrid(DBGrid: TDBGrid);
    procedure btnNovosClientesClick(Sender: TObject);
    procedure btnCarrosNovosClick(Sender: TObject);
    procedure btnNovasVendasClick(Sender: TObject);
    procedure btnDeletarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSorteio: TfrmSorteio;

implementation

{$R *.dfm}

procedure TfrmSorteio.btnCarrosNovosClick(Sender: TObject);
var
  Modelo: TModeloCarro;
  i: Integer;
begin
  for i := 1 to 5 do
  begin
    Modelo := TModeloCarro.Create;
    try
      Modelo.Nome := 'Modelo Novo 2026 ' + IntToStr(i);
      Modelo.AnoLancamento := 2026;

      dmConexao.InserirDadosBD(
        Format(' INSERT INTO tb_modelos (nome, ano_lancamento) VALUES (%s, %d) ',
               [QuotedStr(Modelo.Nome), Modelo.AnoLancamento])
      );
    finally
      Modelo.Free;

    end;
  end;

  dmConexao.ExecutarSql(' SELECT FIRST 5 ' +
                        ' id, nome, ano_lancamento ' +
                        ' FROM tb_modelos ' +
                        ' ORDER BY id DESC'
                        );

  if dbgDados.Columns.Count >= 3 then
  begin
    dbgDados.Columns[0].Title.Caption := 'ID';
    dbgDados.Columns[0].Title.Alignment := taCenter;
    dbgDados.Columns[0].Alignment := taCenter;

    dbgDados.Columns[1].Title.Caption := 'MODELO';
    dbgDados.Columns[1].Title.Alignment := taCenter;
    dbgDados.Columns[1].Alignment := taLeftJustify;

    dbgDados.Columns[2].Title.Caption := 'ANO LANÇAMENTO';
    dbgDados.Columns[2].Title.Alignment := taCenter;
    dbgDados.Columns[2].Alignment := taCenter;
  end;

  AjustarColunasDBGrid(dbgDados);

  ShowMessage('5 novos modelos inseridos usando a classe TModeloCarro!');
end;

procedure TfrmSorteio.btnConsultarClick(Sender: TObject);
var
  msql : string;
begin

  case rdgFiltros.ItemIndex of
    0:
      msql := ' SELECT COUNT(*) AS quantidade_vendas_marea ' +
              ' FROM tb_vendas v ' +
              ' INNER JOIN tb_modelos m ON m.id = v.id_modelo ' +
              ' WHERE m.nome = ' + QuotedStr('Marea');

    1:
      msql := ' SELECT ' +
              ' c.nome, ' +
              ' c.cpf, ' +
              ' COUNT(*) AS quantidade_vendas_uno ' +
              ' FROM tb_vendas v ' +
              ' INNER JOIN tb_modelos m ON m.id = v.id_modelo ' +
              ' INNER JOIN tb_clientes c ON c.id = v.id_cliente ' +
              ' WHERE m.nome = ' + QuotedStr('Uno') + ' ' +
              ' GROUP BY c.id, c.nome, c.cpf ' +
              ' ORDER BY quantidade_vendas_uno DESC, c.nome';

    2:
      msql := ' SELECT COUNT(*) AS quantidade_clientes_sem_venda ' +
              ' FROM tb_clientes c ' +
              ' LEFT JOIN tb_vendas v ON v.id_cliente = c.id ' +
              ' WHERE v.id IS NULL';
  else
    begin
      ShowMessage('Selecione uma consulta válida.');
      Exit;
    end;
  end;

  dmConexao.ExecutarSql(msql);
  dbgDados.Enabled := true;

  case rdgFiltros.ItemIndex of
    0:
      begin
        dbgDados.Columns[0].Title.Caption := 'QUANTIDADE VENDAS MAREA';
        dbgDados.Columns[0].Title.Alignment := taCenter;
        dbgDados.Columns[0].Alignment := taCenter;
      end;

    1:
      begin
        if dbgDados.Columns.Count >= 3 then
        begin
          dbgDados.Columns[0].Title.Caption := 'NOME';
          dbgDados.Columns[0].Title.Alignment := taCenter;
          dbgDados.Columns[0].Alignment := taLeftJustify;

          dbgDados.Columns[1].Title.Caption := 'CPF';
          dbgDados.Columns[1].Title.Alignment := taCenter;
          dbgDados.Columns[1].Alignment := taCenter;
          if dbgDados.Columns[1].Field <> nil then
            dbgDados.Columns[1].Field.EditMask := '999.999.999-99;0;_';

          dbgDados.Columns[2].Title.Caption := 'QTD. VENDAS UNO';
          dbgDados.Columns[2].Title.Alignment := taCenter;
          dbgDados.Columns[2].Alignment := taCenter;
        end;
      end;

    2:
      begin
        dbgDados.Columns[0].Title.Caption := 'CLIENTES SEM VENDA';
        dbgDados.Columns[0].Title.Alignment := taCenter;
        dbgDados.Columns[0].Alignment := taCenter;
      end;
  end;

  AjustarColunasDBGrid(dbgDados);

end;

procedure TfrmSorteio.btnDeletarClick(Sender: TObject);
var
  msql: string;
  MaxMareas, Ano: Integer;
  CpfInicio: string;
begin
  MaxMareas := StrToIntDef(edtQtdModelo.Text, 1);
  Ano := StrToIntDef(edtAno.Text, 2021);
  CpfInicio := edtIniCpf.Text;

  msql := ' DELETE FROM tb_vendas v ' +
          ' WHERE NOT EXISTS ( ' +
          ' SELECT 1 ' +
          ' FROM ( ' +
          ' SELECT FIRST 15 c.id AS id_cliente ' +
          ' FROM tb_vendas v2 ' +
          ' JOIN tb_clientes c ON c.id = v2.id_cliente ' +
          ' JOIN tb_modelos m ON m.id = v2.id_modelo ' +
          ' WHERE m.nome = ''Marea'' ' +
          ' AND m.ano_lancamento = ' + IntToStr(Ano) + ' ' +
          ' AND SUBSTRING(c.cpf FROM 1 FOR 1) = ''' + CpfInicio + ''' ' +
          ' AND NOT EXISTS ( ' +
          ' SELECT 1 ' +
          ' FROM tb_vendas v3 ' +
          ' JOIN tb_modelos m3 ON m3.id = v3.id_modelo ' +
          ' WHERE v3.id_cliente = v2.id_cliente ' +
          ' AND m3.nome = ''Marea'' ' +
          ' AND m3.ano_lancamento = ' + IntToStr(Ano) + ' ' +
          ' GROUP BY v3.id_cliente ' +
          ' HAVING COUNT(*) > ' + IntToStr(MaxMareas) +
          ' ) ' +
          ' GROUP BY c.id ' +
          ' ORDER BY MIN(v2.data_venda) ' +
          ' ) s ' +
          '  WHERE s.id_cliente = v.id_cliente ' +
          ' )';


  dmConexao.InserirDadosBD(msql);

  ShowMessage('Todas as vendas que não pertencem aos clientes sorteados foram excluídas.' + sLineBreak +
              'Conforme solicitado, sem utilizar o comando IN.');

  btnConsultarClick(Sender);
end;

procedure TfrmSorteio.btnNovasVendasClick(Sender: TObject);
var
  Venda: TVenda;
  i: Integer;
  UltimoIdCliente, UltimoIdModelo, UltimoIdVenda : Integer;

  function FloatToSql(const AValue: Currency): string;
  begin
    Result := StringReplace(FormatFloat('0.00', AValue), ',', '.', []);
  end;

begin
  dmConexao.ExecutarSql(' SELECT MAX(id) AS ultimo_id FROM tb_vendas ');
  UltimoIdVenda := dmConexao.ExecutarConsulta.FieldByName('ultimo_id').AsInteger;

  dmConexao.ExecutarSql(' SELECT MAX(id) AS ultimo_id FROM tb_clientes ');
  UltimoIdCliente := dmConexao.ExecutarConsulta.FieldByName('ultimo_id').AsInteger;

  dmConexao.ExecutarSql(' SELECT MAX(id) AS ultimo_id FROM tb_modelos ');
  UltimoIdModelo := dmConexao.ExecutarConsulta.FieldByName('ultimo_id').AsInteger;

  for i := 0 to 4 do
  begin
    Venda := TVenda.Create;
    try
      Venda.IdCliente := UltimoIdCliente - (4 - i);
      Venda.IdModelo  := UltimoIdModelo  - (4 - i);
      Venda.Valor     := 100000 + (i * 10000);

      dmConexao.InserirDadosBD(Format('INSERT INTO tb_vendas ' +
                              ' (id_cliente, id_modelo, data_venda, valor) ' +
                              ' VALUES (%d, %d, CURRENT_DATE, %s)',
                              [Venda.IdCliente, Venda.IdModelo, FloatToSql(Venda.Valor)]));
    finally
      Venda.Free;
    end;
  end;



  dmConexao.ExecutarSql(' SELECT ' +
                        ' v.id, ' +
                        ' c.nome AS cliente, ' +
                        ' m.nome AS modelo, ' +
                        ' v.data_venda, ' +
                        ' v.valor ' +
                        ' FROM tb_vendas v ' +
                        ' JOIN tb_clientes c ON c.id = v.id_cliente ' +
                        ' JOIN tb_modelos m ON m.id = v.id_modelo ' +
                        ' WHERE v.id > ' + IntToStr(UltimoIdVenda) + ' ' +
                        ' ORDER BY v.id'
                        );

  // Formatação básica do grid
  if dbgDados.Columns.Count >= 5 then
  begin
    dbgDados.Columns[0].Title.Caption := 'ID VENDA';
    dbgDados.Columns[1].Title.Caption := 'CLIENTE';
    dbgDados.Columns[2].Title.Caption := 'MODELO';
    dbgDados.Columns[3].Title.Caption := 'DATA';
    dbgDados.Columns[4].Title.Caption := 'VALOR (R$)';

    // Formata valor como moeda
    if dbgDados.Columns[4].Field <> nil then
      dbgDados.Columns[4].Field.EditMask := '#,##0.00';
  end;

  AjustarColunasDBGrid(dbgDados);

  ShowMessage('5 vendas inseridas usando a classe TVenda.' + sLineBreak +
              'Cada novo cliente comprou um modelo diferente.');



end;

procedure TfrmSorteio.btnNovosClientesClick(Sender: TObject);
var
  Cliente: TCliente;
  i: Integer;
  UltimoCPF, NovoCPF: Int64;
begin

  dbgdados.enabled := false;
  {
    Busca o maior CPF já cadastrado no banco para garantir
    a geração de um novo CPF numérico e único, inclusive
    entre diferentes execuções da aplicação. Isso não aconteceria em produção,
    é apenas para demonstrar o que foi pedido no teste.
  }
  dmConexao.ExecutarSql(
    'SELECT COALESCE(MAX(CAST(cpf AS BIGINT)), 0) AS ultimo_cpf FROM tb_clientes'
  );

  UltimoCPF := dmConexao.ExecutarConsulta.FieldByName('ultimo_cpf').AsLargeInt;

  for i := 1 to 5 do
  begin
    Cliente := TCliente.Create;
    try
      Inc(UltimoCPF);
      NovoCPF := UltimoCPF;

      Cliente.Nome := 'Cliente Exemplo' + formatdatetime('mmsszzz', now);
      Cliente.CPF  := Format('%11.11d', [NovoCPF]);
      Cliente.DataCadastro := Date;

      dmConexao.InserirDadosBD(
        Format(
          'INSERT INTO tb_clientes (nome, cpf, dtcadastro) VALUES (%s, %s, CURRENT_DATE)',
          [QuotedStr(Cliente.Nome), QuotedStr(Cliente.CPF)]
        )
      );
    finally
      Cliente.Free;
    end;
  end;

  dmConexao.ExecutarSql(' SELECT * FROM ( ' +
                        ' SELECT FIRST 5 id, nome, cpf, dtcadastro ' +
                        ' FROM tb_clientes ' +
                        ' ORDER BY id DESC ' +
                        ' ) ' +
                        ' ORDER BY id'
                        );

  AjustarColunasDBGrid(dbgDados);

  ShowMessage('5 novos clientes inseridos com sucesso.');

end;


procedure TfrmSorteio.btnSortearClick(Sender: TObject);
var
  msql: string;
  MaxMareas, Ano: Integer;
  CpfInicio: string;
begin
  MaxMareas := StrToIntDef(edtQtdModelo.Text, 1);
  Ano := StrToIntDef(edtAno.Text, 2021);
  CpfInicio := edtIniCpf.Text;

  msql := ' SELECT FIRST 15 ' +
          ' c.nome, ' +
          ' c.cpf, ' +
          ' MIN(v.data_venda) AS data_compra_marea ' +
          ' FROM tb_vendas v ' +
          ' JOIN tb_clientes c ON c.id = v.id_cliente ' +
          ' JOIN tb_modelos m ON m.id = v.id_modelo ' +
          ' WHERE m.nome = ''Marea'' ' +
          ' AND m.ano_lancamento = ' + IntToStr(Ano) + ' ' +
          ' AND SUBSTRING(c.cpf FROM 1 FOR 1) = ''' + CpfInicio + ''' ' +
          ' AND NOT EXISTS ( ' +
          ' SELECT 1 ' +
          ' FROM tb_vendas v2 ' +
          ' JOIN tb_modelos m2 ON m2.id = v2.id_modelo ' +
          ' WHERE v2.id_cliente = v.id_cliente ' +
          ' AND m2.nome = ''Marea'' ' +
          ' AND m2.ano_lancamento = ' + IntToStr(Ano) + ' ' +
          ' GROUP BY v2.id_cliente ' +
          ' HAVING COUNT(*) > ' + IntToStr(MaxMareas) +
          '  ) ' +
          ' GROUP BY c.id, c.nome, c.cpf ' +
          ' ORDER BY MIN(v.data_venda)';


  dmConexao.ExecutarSql(msql);

  dbgDados.Columns[0].Title.Caption := 'NOME';
  dbgDados.Columns[1].Title.Caption := 'CPF';
  dbgDados.Columns[2].Title.Caption := 'DATA DA COMPRA';
  dbgDados.Columns[0].Title.Alignment := taCenter;
  dbgDados.Columns[0].Alignment := taLeftJustify;
  dbgDados.Columns[1].Title.Alignment := taCenter;
  dbgDados.Columns[1].Alignment := taCenter;
  dbgDados.Columns[2].Title.Alignment := taCenter;
  dbgDados.Columns[2].Alignment := taCenter;
  dbgDados.Columns[1].Field.EditMask := '999.999.999-99;0;_';

  dbgDados.Enabled := true;
  AjustarColunasDBGrid(dbgDados);
end;


procedure TfrmSorteio.AjustarColunasDBGrid(DBGrid: TDBGrid);
var
  i: Integer;
  MaxWidth, TextWidth: Integer;
  Canvas: TCanvas;
begin

  Canvas := TCanvas.Create;
  try
    Canvas.Handle := GetDC(0);
    Canvas.Font := DBGrid.Font;


    for i := 0 to DBGrid.Columns.Count - 1 do
    begin
      MaxWidth := 0;


      TextWidth := Canvas.TextWidth(DBGrid.Columns[i].Title.Caption + '  ');
      if TextWidth > MaxWidth then
        MaxWidth := TextWidth;


      if (DBGrid.DataSource <> nil) and (DBGrid.DataSource.DataSet <> nil) and
         (DBGrid.DataSource.DataSet.Active) then
      begin
        DBGrid.DataSource.DataSet.DisableControls;
        try
          DBGrid.DataSource.DataSet.First;
          while not DBGrid.DataSource.DataSet.EOF do
          begin
            TextWidth := Canvas.TextWidth(
              DBGrid.DataSource.DataSet.FieldByName(
                DBGrid.Columns[i].FieldName).AsString + '  '
            );
            if TextWidth > MaxWidth then
              MaxWidth := TextWidth;

            DBGrid.DataSource.DataSet.Next;
          end;
          DBGrid.DataSource.DataSet.First;
        finally
          DBGrid.DataSource.DataSet.EnableControls;
        end;
      end;


      DBGrid.Columns[i].Width := MaxWidth + 8;
    end;
  finally
    ReleaseDC(0, Canvas.Handle);
    Canvas.Free;
  end;
end;

end.
