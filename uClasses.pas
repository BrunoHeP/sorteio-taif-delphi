unit uClasses;

interface

type
  TCliente = class
  private
    FId: Integer;
    FNome: string;
    FCpf: string;
    FDataCadastro: TDate;
  public
    property Id: Integer read FId write FId;
    property Nome: string read FNome write FNome;
    property CPF: string read FCpf write FCpf;
    property DataCadastro: TDate read FDataCadastro write FDataCadastro;
  end;

  TModeloCarro = class
  private
    FId: Integer;
    FNome: string;
    FAnoLancamento: Integer;
  public
    property Id: Integer read FId write FId;
    property Nome: string read FNome write FNome;
    property AnoLancamento: Integer read FAnoLancamento write FAnoLancamento;
  end;

  TVenda = class
  private
    FId: Integer;
    FIdCliente: Integer;
    FIdModelo: Integer;
    FDataVenda: TDate;
    FValor: Currency;
  public
    property Id: Integer read FId write FId;
    property IdCliente: Integer read FIdCliente write FIdCliente;
    property IdModelo: Integer read FIdModelo write FIdModelo;
    property DataVenda: TDate read FDataVenda write FDataVenda;
    property Valor: Currency read FValor write FValor;
  end;

implementation

end.

