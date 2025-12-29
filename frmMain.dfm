object frmSorteio: TfrmSorteio
  Left = 0
  Top = 0
  Caption = 'Sorteio'
  ClientHeight = 641
  ClientWidth = 772
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object dbgDados: TDBGrid
    Left = 32
    Top = 248
    Width = 705
    Height = 377
    DataSource = dmConexao.dsConsulta
    Enabled = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object btnSortear: TBitBtn
    Left = 32
    Top = 193
    Width = 209
    Height = 49
    Caption = 'Executar Sorteio'
    TabOrder = 1
    OnClick = btnSortearClick
  end
  object btnConsultar: TBitBtn
    Left = 264
    Top = 193
    Width = 241
    Height = 49
    Caption = 'Executar Consulta Selecionada'
    TabOrder = 2
    OnClick = btnConsultarClick
  end
  object btnDeletar: TBitBtn
    Left = 528
    Top = 28
    Width = 209
    Height = 49
    Caption = 'Excluir Vendas N'#227'o Sorteadas'
    TabOrder = 3
    OnClick = btnDeletarClick
  end
  object Panel1: TPanel
    Left = 32
    Top = 17
    Width = 209
    Height = 170
    TabOrder = 4
    object Label1: TLabel
      Left = 8
      Top = 77
      Width = 23
      Height = 13
      Caption = 'Ano:'
    end
    object Label2: TLabel
      Left = 8
      Top = 126
      Width = 73
      Height = 13
      Caption = 'Cpf Inicia Com:'
    end
    object Label3: TLabel
      Left = 8
      Top = 32
      Width = 146
      Height = 13
      Caption = 'Maximo de Mareas por cliente:'
    end
    object Label4: TLabel
      Left = 8
      Top = 0
      Width = 105
      Height = 13
      Caption = 'Crit'#233'rios para sorteio:'
    end
    object edtAno: TEdit
      Left = 8
      Top = 91
      Width = 121
      Height = 21
      TabOrder = 0
      Text = '2021'
    end
    object edtIniCpf: TEdit
      Left = 8
      Top = 139
      Width = 121
      Height = 21
      TabOrder = 1
      Text = '0'
    end
    object edtQtdModelo: TEdit
      Left = 8
      Top = 45
      Width = 121
      Height = 21
      TabOrder = 2
      Text = '1'
    end
  end
  object rdgFiltros: TRadioGroup
    Left = 264
    Top = 17
    Width = 241
    Height = 170
    Caption = 'Filtros de busca:'
    Items.Strings = (
      'Qtd. de vendas Marea'
      'Qtd.  de vendas Uno por cliente'
      'Qtd. Clientes que n'#227'o efetuaram venda')
    TabOrder = 5
  end
  object btnNovosClientes: TBitBtn
    Left = 528
    Top = 83
    Width = 209
    Height = 49
    Caption = 'Inserir 5 novos clientes'
    TabOrder = 6
    OnClick = btnNovosClientesClick
  end
  object btnCarrosNovos: TBitBtn
    Left = 528
    Top = 138
    Width = 209
    Height = 49
    Caption = 'Inserir 5 modelos de carros novos'
    TabOrder = 7
    OnClick = btnCarrosNovosClick
  end
  object btnNovasVendas: TBitBtn
    Left = 528
    Top = 193
    Width = 209
    Height = 49
    Caption = 'Inserir uma venda para 5 novos clientes'
    TabOrder = 8
    OnClick = btnNovasVendasClick
  end
end
