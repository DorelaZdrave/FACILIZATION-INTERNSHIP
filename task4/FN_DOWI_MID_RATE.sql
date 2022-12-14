CREATE  FUNCTION FN_DOWI_MID_RATE(P_BRANCH_CODE VARCHAR2 ,P_CCY1 VARCHAR2,P_CC2 VARCHAR2  ) RETURN NUMBER
 AS
 L_MID_RATE NUMBER;
 
BEGIN
 
SELECT MID_RATE
  INTO L_MID_RATE
  FROM CYTMS_RATES
 WHERE BRANCH_CODE = P_BRANCH_CODE
   AND rate_type = 'STANDARD'
   AND CCY1 = P_CCY1
   AND CCY2 = P_CC2;

RETURN L_MID_RATE;
EXCEPTION WHEN OTHERS THEN Dbms_Output.put_line(DBMS_UTILITY.FORMAT_ERROR_STACK()); Dbms_Output.put_line(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());

END FN_DOWI_MID_RATE;
