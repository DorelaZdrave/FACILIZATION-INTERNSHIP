CREATE OR REPLACE FUNCTION fn_DOWI_does_contract_exist_no(p_udf_name VARCHAR2,
                                            p_udf_value VARCHAR2,
                                            p_fc_module VARCHAR2)
                                            RETURN VARCHAR2 AS

    L_UDF_NAME VARCHAR2;
    L_FIELD_NUM VARCHAR2;
    L_FIELD_NUM_VAL VARCHAR2;
    L_CHECK NUMBER ;     
    L_RETURN VARCHAR2;

     BEGIN

     L_UDF_NAME :=  p_udf_name;

     BEGIN
SELECT FIELD_NUM
INTO L_FIELD_NUM
FROM cstm_product_udf_fields_map
WHERE FIELD_NAME = L_UDF_NAME;
END;

L_FIELD_NUM_VAL := 'FIELD_VAL_' || L_FIELD_NUM;

BEGIN
EXECUTE IMMEDIATE 'SELECT COUNT(*)
INTO L_CHECK
FROM cstm_contract_userdef_fields
WHERE ' || L_FIELD_NUM_VAL || '=''' || p_udf_value || '''  AND MODULE =''' || p_fc_module || ''' ' ;
IF L_CHECK > 0 THEN
  L_RETURN := 'Y';

ELSE L_RETURN := 'N';
 END IF;

RETURN L_RETURN;

EXCEPTION
WHEN OTHERS THEN
Dbms_Output.put_line(DBMS_UTILITY.FORMAT_ERROR_STACK());
Dbms_Output.put_line(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());

END fn_DOWI_does_contract_exist_no;
/
