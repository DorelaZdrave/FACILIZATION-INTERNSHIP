CREATE DIRECTORY DORELA_CSV AS '/home/oracle/csv';
create table dorela_ex_rates (
                      TO_CURRENCY VARCHAR2(15) NOT NULL,
                      FROM_CURRENCY VARCHAR2(15) NOT NULL,
                      EX_RATE VARCHAR2(40) NOT NULL,
                      CONVERSION_DATE VARCHAR2(15) NOT NULL
);
DECLARE
  F                 UTL_FILE.FILE_TYPE;
  L_LINE            VARCHAR2(1000);
  L_CONTROL         VARCHAR2(15) ;
  L_TO_CURRENCY     VARCHAR2(15);
  L_FROM_CURRENCY   VARCHAR2(15);
  L_EX_RATE         VARCHAR2(40);
  L_CONVERSION_DATE VARCHAR2(15);
  L_INDEX NUMBER;
BEGIN
  F := UTL_FILE.FOPEN('DORELA_CSV', 'rates.csv', 'R');
  IF UTL_FILE.IS_OPEN(F) THEN
    LOOP
      BEGIN
        UTL_FILE.GET_LINE(F, L_LINE);
        IF L_LINE IS NULL THEN
          EXIT;
        END IF;
        DBMS_OUTPUT.PUT_LINE('Read line: '|| l_line);
        --KONTROLL (IF ONLY ONE CURRENCY IS SPECIFIED IN THE ROW THE OTHER IS EUR)
        dbms_output.put_line('l_control: ' || REGEXP_SUBSTR(L_LINE, '[^,]+', 1, 1));
        L_CONTROL := REGEXP_SUBSTR(L_LINE, '[^,]+', 1, 1);
        L_INDEX := INSTR(L_CONTROL,'=');
        IF L_INDEX != 0 THEN
         
          L_TO_CURRENCY := TRIM(SUBSTR(L_CONTROL, 1, 3));
          L_FROM_CURRENCY   := TRIM(SUBSTR(L_CONTROL, L_INDEX+1));
        ELSE
          dbms_output.put_line('L_TO_CURRENCY: ' || REGEXP_SUBSTR(L_LINE, '[^,]+', 1, 1));
          L_TO_CURRENCY := REGEXP_SUBSTR(L_LINE, '[^,]+', 1, 1);
          L_FROM_CURRENCY   := 'EUR';
        END IF;
        dbms_output.put_line('L_EX_RATE: ' || REGEXP_SUBSTR(L_LINE, '[^,]+', 1, 2));
        dbms_output.put_line('L_CONVERSION_DATE: ' || REGEXP_SUBSTR(L_LINE, '[^,]+', 1, 3));
        L_EX_RATE         := REGEXP_SUBSTR(L_LINE, '[^,]+', 1, 2);
        L_CONVERSION_DATE := REGEXP_SUBSTR(L_LINE, '[^,]+', 1, 3);
      
        INSERT INTO dorela_ex_rates
          (FROM_CURRENCY, TO_CURRENCY, EX_RATE, CONVERSION_DATE)
        VALUES
          (L_FROM_CURRENCY, L_TO_CURRENCY, L_EX_RATE, L_CONVERSION_DATE);
        DBMS_OUTPUT.PUT_LINE('SUCCESS');
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          EXIT;
      END;
    END LOOP;
  END IF;
  UTL_FILE.FCLOSE(F);
  EXCEPTION
    WHEN OTHERS THEN
  Dbms_Output.put_line ( DBMS_UTILITY.FORMAT_ERROR_STACK() );
  Dbms_Output.put_line ( DBMS_UTILITY.FORMAT_ERROR_BACKTRACE() );
END;
/
SELECT * FROM dorela_ex_rates ORDER BY TO_CURRENCY;



