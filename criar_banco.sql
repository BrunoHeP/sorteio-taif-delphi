/* ============================================================
   Script de criação do banco de dados
   Firebird 2.5+
   ============================================================ */

-- ============================================================
-- 1. Tabelas
-- ============================================================

CREATE TABLE tb_clientes (
    id          INTEGER NOT NULL,
    nome        VARCHAR(100) NOT NULL,
    cpf         CHAR(11) NOT NULL,
    dtcadastro  DATE DEFAULT CURRENT_DATE NOT NULL
);

CREATE TABLE tb_modelos (
    id              INTEGER NOT NULL,
    nome            VARCHAR(50) NOT NULL,
    ano_lancamento  INTEGER NOT NULL
);

CREATE TABLE tb_vendas (
    id          INTEGER NOT NULL,
    id_cliente  INTEGER NOT NULL,
    id_modelo   INTEGER NOT NULL,
    data_venda  DATE NOT NULL,
    valor       DECIMAL(12,2) NOT NULL
);

-- ============================================================
-- 2. Generators
-- ============================================================

CREATE GENERATOR gen_tb_clientes_id;
CREATE GENERATOR gen_tb_modelos_id;
CREATE GENERATOR gen_tb_vendas_id;

-- ============================================================
-- 3. Constraints
-- ============================================================

ALTER TABLE tb_clientes
  ADD CONSTRAINT pk_tb_clientes PRIMARY KEY (id);

ALTER TABLE tb_clientes
  ADD CONSTRAINT uk_tb_clientes_cpf UNIQUE (cpf);

ALTER TABLE tb_modelos
  ADD CONSTRAINT pk_tb_modelos PRIMARY KEY (id);

ALTER TABLE tb_vendas
  ADD CONSTRAINT pk_tb_vendas PRIMARY KEY (id);

ALTER TABLE tb_vendas
  ADD CONSTRAINT fk_tb_vendas_cliente
  FOREIGN KEY (id_cliente) REFERENCES tb_clientes(id);

ALTER TABLE tb_vendas
  ADD CONSTRAINT fk_tb_vendas_modelo
  FOREIGN KEY (id_modelo) REFERENCES tb_modelos(id);

-- ============================================================
-- 4. Triggers
-- ============================================================

SET TERM ^ ;

CREATE TRIGGER trg_bi_tb_clientes
FOR tb_clientes
ACTIVE BEFORE INSERT POSITION 0
AS
BEGIN
  IF (NEW.id IS NULL OR NEW.id = 0) THEN
    NEW.id = GEN_ID(gen_tb_clientes_id, 1);
END^

CREATE TRIGGER trg_bi_tb_modelos
FOR tb_modelos
ACTIVE BEFORE INSERT POSITION 0
AS
BEGIN
  IF (NEW.id IS NULL OR NEW.id = 0) THEN
    NEW.id = GEN_ID(gen_tb_modelos_id, 1);
END^

CREATE TRIGGER trg_bi_tb_vendas
FOR tb_vendas
ACTIVE BEFORE INSERT POSITION 0
AS
BEGIN
  IF (NEW.id IS NULL OR NEW.id = 0) THEN
    NEW.id = GEN_ID(gen_tb_vendas_id, 1);
END^

SET TERM ; ^

-- ============================================================
-- 5. Índices
-- ============================================================

CREATE INDEX idx_tb_vendas_cliente ON tb_vendas (id_cliente);
CREATE INDEX idx_tb_vendas_modelo  ON tb_vendas (id_modelo);
CREATE INDEX idx_tb_vendas_data    ON tb_vendas (data_venda);

-- ============================================================

COMMIT;
