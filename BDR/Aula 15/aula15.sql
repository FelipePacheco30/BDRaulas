-- ==========================================
-- OBSERVAÇÕES GERAIS
-- - O script abaixo cria tabelas mínimas usadas nos exercícios (biblioteca + limnologia).
-- - Em seguida cria as Stored Procedures pedidas (biblioteca, projeto ABP e a versão com validação).
-- - Cada SP possui comentários explicando o propósito. Também há exemplos de execução (CALL)
--   e consultas de verificação (SELECT).
-- - Execute tudo em ordem; as cláusulas CREATE TABLE usam IF NOT EXISTS para evitar erro
--   se já existir no seu esquema.
-- ==========================================


-- ==========================================
-- DROP DAS PROCEDURES
-- ==========================================
DROP PROCEDURE IF EXISTS sp_atualizar_autor(INT, VARCHAR);
DROP PROCEDURE IF EXISTS sp_excluir_livro(INT);
DROP PROCEDURE IF EXISTS sp_cadastrar_reservatorio(VARCHAR, NUMERIC, NUMERIC, VARCHAR);
DROP PROCEDURE IF EXISTS sp_cadastrar_parametro(VARCHAR);
DROP PROCEDURE IF EXISTS sp_registrar_medicao(INT, INT, NUMERIC, TIMESTAMP);
DROP PROCEDURE IF EXISTS sp_registrar_medicao_validada(INT, INT, NUMERIC, TIMESTAMP);


-- ==========================================
-- CRIAÇÃO DAS TABELAS DE SUPORTE
-- (Biblioteca + Limnologia) — usam IF NOT EXISTS para segurança
-- ==========================================

-- Tabela: livro (Biblioteca)
CREATE TABLE IF NOT EXISTS livro (
    id_livro SERIAL PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    autor VARCHAR(150),
    ano INTEGER
);

-- Tabela: reservatorio (Limnologia / Projeto ABP)
CREATE TABLE IF NOT EXISTS reservatorio (
    id_reservatorio SERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    latitude NUMERIC(9,6),
    longitude NUMERIC(9,6),
    cidade VARCHAR(100)
);

-- Tabela: parametro (Limnologia / Projeto ABP)
CREATE TABLE IF NOT EXISTS parametro (
    id_parametro SERIAL PRIMARY KEY,
    nome_parametro VARCHAR(100) NOT NULL UNIQUE
);

-- Tabela: serie_temporal (Limnologia / Projeto ABP)
CREATE TABLE IF NOT EXISTS serie_temporal (
    id_serie SERIAL PRIMARY KEY,
    id_reservatorio INT REFERENCES reservatorio(id_reservatorio) ON DELETE CASCADE,
    id_parametro INT REFERENCES parametro(id_parametro) ON DELETE CASCADE,
    valor NUMERIC,
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ==========================================
-- A) BIBLIOTECA — Stored Procedures
-- ==========================================

-- 1) SP: Atualizar o autor de um livro (por id)
-- Comentário: recebe id do livro e novo autor; atualiza e dá NOTICE com resultado.
CREATE PROCEDURE sp_atualizar_autor(
    id_livro_p INT,
    autor_p VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Verifica se o livro existe
    IF NOT EXISTS (SELECT 1 FROM livro WHERE id_livro = id_livro_p) THEN
        RAISE EXCEPTION 'Livro com id % não encontrado.', id_livro_p;
    END IF;

    -- Atualiza o autor
    UPDATE livro
    SET autor = autor_p
    WHERE id_livro = id_livro_p;

    RAISE NOTICE 'Autor do livro (id=%) atualizado para: %', id_livro_p, autor_p;
END;
$$;


-- 2) SP: Excluir livro pelo id
-- Comentário: recebe id do livro e remove o registro; se não existir, gera NOTICE.
CREATE PROCEDURE sp_excluir_livro(
    id_livro_p INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM livro WHERE id_livro = id_livro_p) THEN
        RAISE NOTICE 'Nenhum livro encontrado com id % — nada a excluir.', id_livro_p;
        RETURN;
    END IF;

    DELETE FROM livro
    WHERE id_livro = id_livro_p;

    RAISE NOTICE 'Livro com id % excluído com sucesso.', id_livro_p;
END;
$$;


-- ==========================================
-- B) PROJETO ABP (Limnologia) — Stored Procedures
-- ==========================================

-- 3) SP: Cadastrar reservatório
-- Comentário: insere um reservatório e faz RAISE NOTICE com o id criado.
CREATE PROCEDURE sp_cadastrar_reservatorio(
    nome_p VARCHAR,
    latitude_p NUMERIC,
    longitude_p NUMERIC,
    cidade_p VARCHAR
)
LANGUAGE plpgsql
AS $$
DECLARE
    novo_id INT;
BEGIN
    INSERT INTO reservatorio (nome, latitude, longitude, cidade)
    VALUES (nome_p, latitude_p, longitude_p, cidade_p)
    RETURNING id_reservatorio INTO novo_id;

    RAISE NOTICE 'Reservatório "%", id criado = %', nome_p, novo_id;
END;
$$;


-- 4) SP: Cadastrar parâmetro ambiental
-- Comentário: insere novo parâmetro se não existir; retorna NOTICE.
CREATE PROCEDURE sp_cadastrar_parametro(
    nome_parametro_p VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Evita duplicatas
    IF EXISTS (SELECT 1 FROM parametro WHERE nome_parametro = nome_parametro_p) THEN
        RAISE NOTICE 'Parâmetro "%" já existe — operação ignorada.', nome_parametro_p;
        RETURN;
    END IF;

    INSERT INTO parametro (nome_parametro)
    VALUES (nome_parametro_p);

    RAISE NOTICE 'Parâmetro "%" cadastrado com sucesso.', nome_parametro_p;
END;
$$;


-- 5) SP: Registrar medição (sem validação adicional)
-- Comentário: insere um registro em serie_temporal (assume ids válidos)
CREATE PROCEDURE sp_registrar_medicao(
    id_reservatorio_p INT,
    id_parametro_p INT,
    valor_p NUMERIC,
    data_p TIMESTAMP
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO serie_temporal (id_reservatorio, id_parametro, valor, data_hora)
    VALUES (id_reservatorio_p, id_parametro_p, valor_p, data_p);

    RAISE NOTICE 'Medição registrada: reservatorio_id=%, parametro_id=%, valor=% , data=%',
                 id_reservatorio_p, id_parametro_p, valor_p, data_p;
END;
$$;


-- ==========================================
-- C) BÔNUS: SP com VALIDAÇÃO (não permite valor negativo)
-- ==========================================

-- 6) SP: Registrar medição com validação (raise exception para valores negativos)
-- Comentário: checa valor_p >= 0; em caso contrário lança EXCEPTION e aborta.
CREATE PROCEDURE sp_registrar_medicao_validada(
    id_reservatorio_p INT,
    id_parametro_p INT,
    valor_p NUMERIC,
    data_p TIMESTAMP
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validação: valor não pode ser nulo nem negativo
    IF valor_p IS NULL THEN
        RAISE EXCEPTION 'Valor da medição não pode ser NULL.';
    END IF;

    IF valor_p < 0 THEN
        RAISE EXCEPTION 'Valor negativo não permitido: %', valor_p;
    END IF;

    -- Verifica existência de reservatório e parâmetro para dar mensagens claras
    IF NOT EXISTS (SELECT 1 FROM reservatorio WHERE id_reservatorio = id_reservatorio_p) THEN
        RAISE EXCEPTION 'Reservatório id=% não encontrado.', id_reservatorio_p;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM parametro WHERE id_parametro = id_parametro_p) THEN
        RAISE EXCEPTION 'Parâmetro id=% não encontrado.', id_parametro_p;
    END IF;

    -- Inserção (tudo ok)
    INSERT INTO serie_temporal (id_reservatorio, id_parametro, valor, data_hora)
    VALUES (id_reservatorio_p, id_parametro_p, valor_p, data_p);

    RAISE NOTICE 'Medição validada e registrada: reservatorio_id=%, parametro_id=%, valor=% , data=%',
                 id_reservatorio_p, id_parametro_p, valor_p, data_p;
END;
$$;


-- ==========================================
-- EXEMPLOS DE USO / TESTES (CALLs e SELECTs de verificação)
-- ==========================================

-- ---------- Biblioteca: testar SPs ----------
-- Inserir livros de exemplo
INSERT INTO livro (titulo, autor, ano) VALUES
('Dom Casmurro', 'Machado de Assis', 1899),
('Memórias Póstumas de Brás Cubas', 'Machado de Assis', 1881)
ON CONFLICT DO NOTHING; -- evita duplicação se já existirem (Postgres 9.5+)

-- Listar antes
-- SELECT * FROM livro;

-- Atualizar autor (exemplo): atualiza autor do id 1
CALL sp_atualizar_autor(1, 'A. N. Atualizado');

-- Verificar atualização
-- SELECT id_livro, titulo, autor FROM livro WHERE id_livro = 1;

-- Excluir livro (exemplo)
-- CALL sp_excluir_livro(9999); -- id inexistente: gera NOTICE
-- CALL sp_excluir_livro(2);    -- exclui livro id=2

-- ---------- Limnologia / Projeto ABP: testar SPs ----------
-- Inserir reservatórios de teste
CALL sp_cadastrar_reservatorio('Reservatorio Alpha', -23.210000, -45.900000, 'Jacareí');
CALL sp_cadastrar_reservatorio('Reservatorio Beta', -22.900000, -46.500000, 'São José');

-- Inserir parâmetros (exemplo)
CALL sp_cadastrar_parametro('Temperatura');
CALL sp_cadastrar_parametro('Turbidez');
CALL sp_cadastrar_parametro('Condutividade');

-- Verificar tabelas de referência
-- SELECT * FROM reservatorio;
-- SELECT * FROM parametro;

-- Registrar medições (sem validação)
CALL sp_registrar_medicao(1, 1, 25.6, '2025-11-01 10:00:00');
CALL sp_registrar_medicao(1, 2, 6.2,  '2025-11-01 10:05:00');

-- Registrar medição com validação (valor válido)
CALL sp_registrar_medicao_validada(2, 1, 22.8, '2025-11-02 09:30:00');

-- Teste de validação (valor negativo) — este CALL lançará EXCEPTION e não inserirá nada:
-- CALL sp_registrar_medicao_validada(2, 2, -3.5, '2025-11-02 09:40:00');

-- Verificar inserções
-- SELECT * FROM serie_temporal ORDER BY data_hora DESC LIMIT 20;

-- ==========================================
-- FIM DO SCRIPT
-- ==========================================
