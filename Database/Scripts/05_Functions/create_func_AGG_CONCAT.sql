create or replace 
FUNCTION           "AGG_CONCAT" (input VARCHAR2) RETURN VARCHAR2
    parallel_enable aggregate USING agg_t;
 