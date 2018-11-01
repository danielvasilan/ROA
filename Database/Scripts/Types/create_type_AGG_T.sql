--------------------------------------------------------
--  DDL for Type AGG_T
--------------------------------------------------------

  CREATE OR REPLACE TYPE "APP_ROA"."AGG_T" AS OBJECT (

    str_agg VARCHAR2(4000),

    STATIC FUNCTION ODCIAggregateInitialize(sctx  IN OUT agg_t) 
                    RETURN NUMBER,

    MEMBER FUNCTION ODCIAggregateIterate   (self  IN OUT agg_t, 
                                            VALUE IN VARCHAR2 ) 
                    RETURN NUMBER,

    MEMBER FUNCTION ODCIAggregateTerminate (self         IN     agg_t   , 
                                            return_value    OUT VARCHAR2, 
                                            flags        IN NUMBER      )               
                    RETURN NUMBER,

    MEMBER FUNCTION ODCIAggregateMerge(self IN OUT agg_t, 
                                       ctx2 IN agg_t    ) 
                    RETURN NUMBER
);
/

CREATE OR REPLACE TYPE BODY "APP_ROA"."AGG_T" IS 

    STATIC FUNCTION ODCIAggregateInitialize(sctx IN OUT agg_t) 
        RETURN NUMBER IS 
    BEGIN
        sctx := agg_t(NULL);
        RETURN ODCIConst.Success;
    END;

    MEMBER FUNCTION ODCIAggregateIterate(
      self IN OUT agg_t, VALUE IN VARCHAR2) 
        RETURN NUMBER IS
    BEGIN
        str_agg := str_agg || VALUE;
        RETURN ODCIConst.Success;
    END;

    MEMBER FUNCTION ODCIAggregateTerminate(self IN agg_t, return_value OUT VARCHAR2, flags IN NUMBER) RETURN NUMBER IS
    BEGIN
        --FOR x IN (SELECT txt01 FROM TABLE(Pkg_Lib.f_sql_inlist(str_agg,',')) ORDER BY txt01 ) LOOP
        --    return_value := return_value||x.txt01 ||',';
        --END LOOP;
        return_value    :=  str_agg;
        RETURN ODCIConst.Success;
    END;

    MEMBER FUNCTION ODCIAggregateMerge(self IN OUT agg_t, 
        ctx2 IN agg_t) RETURN NUMBER IS
    BEGIN
        str_agg := str_agg || ctx2.str_agg;
        RETURN ODCIConst.Success;
    END;
END;

/
