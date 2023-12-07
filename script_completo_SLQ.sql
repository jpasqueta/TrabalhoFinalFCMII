-- CREATE TABLE public.monovalentebtu (
--     "cnes" SERIAL PRIMARY KEY,
--     "estabelecimento" VARCHAR(255),
-- 	   "Total de doses monovalente" INTEGER,
--     "Primeira dose" INTEGER,
--     "Segunda dose" INTEGER,
--     "Terceira dose" INTEGER,
--     "Dose de reforco" INTEGER,
--     "Primeira dose de reforco" INTEGER,
--     "Segunda dose de reforco" INTEGER,
--     "Terceira dose de reforco" INTEGER,
--     "Dose adicional" INTEGER,
--     "Dose unica" INTEGER
-- );

-- CREATE TABLE public.bivalentebtu (
--     CNES SERIAL PRIMARY KEY,
--     estabelecimento VARCHAR(255),
-- 	   "Total de doses bivalente" INTEGER
--  );

-- CREATE TABLE public.vacinas AS
-- SELECT monovalentebtu.cnes, monovalentebtu.estabelecimento, monovalentebtu."Total de doses monovalente", monovalentebtu."Primeira dose", monovalentebtu."Segunda dose", monovalentebtu."Terceira dose", monovalentebtu."Dose de reforco", monovalentebtu."Primeira dose de reforco", monovalentebtu."Segunda dose de reforco", monovalentebtu."Terceira dose de reforco", monovalentebtu."Dose adicional", monovalentebtu."Dose unica", bivalentebtu."Total de doses bivalente"
-- FROM monovalentebtu
-- JOIN bivalentebtu ON monovalentebtu.cnes = bivalentebtu.cnes;

-- SELECT * FROM public.vacinas
