-- ==========================================
-- Observação:
-- Execute no banco limnologia_db (no psql: \c limnologia_db)
-- As tabelas usadas devem existir: reservatorio, serie_temporal, parametro

-- ==========================================
-- REMOVER VIEWS - Ordem segura
-- ==========================================
DROP VIEW IF EXISTS vw_reservatorios_turbidez_acima_5 CASCADE;
DROP VIEW IF EXISTS vw_eventos_reservatorio CASCADE;
DROP VIEW IF EXISTS vw_media_temperatura_reservatorio CASCADE;

-- ==========================================
-- CRIAÇÃO DAS VIEWS
-- ==========================================

-- 1) CREATE VIEW vw_media_temperatura_reservatorio
-- Descrição:
--   Calcula a média (com duas casas decimais), mínimo e máximo dos valores do parâmetro
--   'Temperatura' por reservatório. Exposição: reservatorio, media_temperatura, temp_min, temp_max.
CREATE VIEW vw_media_temperatura_reservatorio AS
SELECT
    r.nome AS reservatorio,
    ROUND(AVG(s.valor)::numeric, 2) AS media_temperatura,
    MIN(s.valor) AS temp_min,
    MAX(s.valor) AS temp_max
FROM reservatorio r
JOIN serie_temporal s ON s.id_reservatorio = r.id_reservatorio
JOIN parametro p ON p.id_parametro = s.id_parametro
WHERE p.nome_parametro = 'Temperatura'
GROUP BY r.nome
ORDER BY r.nome;

-- 2) CREATE VIEW vw_eventos_reservatorio
-- Descrição:
--   Lista eventos/leituras (linhas) das séries temporais juntando reservatório e parâmetro.
--   Colunas: nome_reservatorio, nome_parametro, valor, data_hora
CREATE VIEW vw_eventos_reservatorio AS
SELECT
    r.nome AS nome_reservatorio,
    p.nome_parametro AS nome_parametro,
    s.valor,
    s.data_hora
FROM serie_temporal s
JOIN reservatorio r ON r.id_reservatorio = s.id_reservatorio
JOIN parametro p ON p.id_parametro = s.id_parametro
ORDER BY r.nome, s.data_hora;

-- 3) CREATE VIEW vw_reservatorios_turbidez_acima_5
-- Descrição:
--   Exibe apenas reservatórios cuja média do parâmetro 'Turbidez' é maior que 5.
--   Colunas: reservatorio, media_turbidez (duas casas decimais)
CREATE VIEW vw_reservatorios_turbidez_acima_5 AS
SELECT
    r.nome AS reservatorio,
    ROUND(AVG(s.valor)::numeric, 2) AS media_turbidez
FROM reservatorio r
JOIN serie_temporal s ON s.id_reservatorio = r.id_reservatorio
JOIN parametro p ON p.id_parametro = s.id_parametro
WHERE p.nome_parametro = 'Turbidez'
GROUP BY r.nome
HAVING AVG(s.valor) > 5
ORDER BY media_turbidez DESC;

-- ==========================================
-- CONSULTAS PARA VERIFICAR AS VIEWS CRIADAS
-- (Uso / chamadas das views)
-- ==========================================

-- A) Mostrar médias de temperatura por reservatório (view 1)
SELECT * FROM vw_media_temperatura_reservatorio;

-- B) Mostrar eventos registrados com parâmetro, valor e data (view 2)
SELECT * FROM vw_eventos_reservatorio
-- opcional: limitar resultados para inspecionar (descomente se quiser)
-- LIMIT 100
;

-- C) Mostrar reservatórios com média de turbidez acima de 5 (view 3)
SELECT * FROM vw_reservatorios_turbidez_acima_5;

-- ==========================================
-- EXEMPLOS ADICIONAIS - como usar as views em filtros/relatórios
-- ==========================================

-- Exemplo: consultar apenas reservatórios da view de temperatura cuja média > 25º
-- (útil para detectar áreas quentes)
SELECT *
FROM vw_media_temperatura_reservatorio
WHERE media_temperatura > 25;

-- Exemplo: usar a view de eventos para filtrar somente leituras de pH
SELECT *
FROM vw_eventos_reservatorio
WHERE nome_parametro = 'pH'
ORDER BY data_hora DESC
LIMIT 50;

-- ==========================================
-- INSTRUÇÕES PARA REMOÇÃO
-- ==========================================
-- Para remover uma view específica:
-- DROP VIEW vw_media_temperatura_reservatorio;
-- DROP VIEW vw_eventos_reservatorio;
-- DROP VIEW vw_reservatorios_turbidez_acima_5;

-- ==========================================
-- FIM DO SCRIPT
-- ==========================================
