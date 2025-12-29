Aplicação Delphi VCL com banco Firebird para consulta e sorteio de clientes.

REQUISITOS:
- Windows
- Firebird 2.5 ou superior

INSTALAÇÃO:
1. Extraia para uma pasta:
   - SorteioTaif.exe
   - SORTEIO_TAIF.FDB
2. Execute SorteioTaif.exe
3. O sistema conecta automaticamente

FUNCIONALIDADES:

1. CONSULTAS (botão "Executar Consulta Selecionada"):
   - Total de vendas do modelo Marea
   - Vendas do Uno por cliente (ordenado por quantidade)
   - Clientes sem nenhuma venda

2. SORTEIO (botão "Executar Sorteio"):
   - Parâmetros: Ano, início do CPF, limite máximo de Mareas por cliente
   - Retorna os 15 primeiros clientes elegíveis
   - Ordenado pela data da primeira compra

3. EXCLUSÃO (botão "Excluir Vendas Não Sorteadas"):
   - Remove todas as vendas que não pertencem aos clientes sorteados
   - Implementada sem uso do comando IN

4. INSERÇÃO COM CLASSES (botões dedicados):
   - Inserir 5 novos clientes (usa classe TCliente)
   - Inserir 5 novos modelos (usa classe TModeloCarro)
   - Inserir 5 novas vendas (usa classe TVenda, cada cliente com modelo diferente)

ARQUIVOS INCLUÍDOS:
- SorteioTaif.exe          → Aplicativo executável
- SORTEIO_TAIF.FDB         → Banco de dados com registros de exemplo
- criar_banco.sql          → Script DDL para recriar o banco do zero

PARA RECRIAR O BANCO:
1. Abra FlameRobin ou IBExpert
2. Execute o conteúdo de criar_banco.sql

ESTRUTURA DO CÓDIGO (fonte):
- frmMain.pas     → Formulário principal com interface e lógica
- uDM.pas         → DataModule com conexão e métodos InserirDadosBD / ExecutarSql
- classes.pas     → Classes TCliente, TModeloCarro, TVenda

OBSERVAÇÕES:
- Ajuste automático de colunas no grid
- Máscara automática no campo CPF
- Mensagens de confirmação após operações