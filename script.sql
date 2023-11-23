-- CREATE TABLE public.vacinasbtu AS
-- SELECT monovalentebtu.cnes, monovalentebtu.estabelecimento, monovalentebtu.total_doses_monovalente, bivalentebtu.total_doses_bivalente
-- FROM monovalentebtu
-- JOIN bivalentebtu ON monovalentebtu.cnes = bivalentebtu.cnes;

-- SELECT * FROM public.vacinasbtu

-- CREATE TABLE public.vacinassp AS
-- SELECT monovalente.cnes, monovalente.estabelecimento, monovalente.total_doses_monovalente, bivalente.total_doses_bivalente
-- FROM monovalente
-- JOIN bivalente ON monovalente.cnes = bivalente.cnes;

SELECT * FROM public.vacinasbtu