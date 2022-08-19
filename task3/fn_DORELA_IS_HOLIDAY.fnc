CREATE OR REPLACE FUNCTION fn_DORELA_IS_HOLIDAY(p_myDay DATE,
                                            p_n NUMBER,
                                            p_HorW   OUT  VARCHAR2,
                                            p_error_message OUT  VARCHAR2
                                           )

     RETURN BOOLEAN AS
l_newDate date;
l_day number;
l_year number;
l_month number;
l_Holiday varchar(50);


BEGIN

    l_newDate:=p_myDay+p_n;
   SELECT EXTRACT (DAY FROM  l_newDate) into l_day FROM DUAL;
   SELECT EXTRACT (month  FROM l_newDate) into l_month FROM DUAL;
   SELECT EXTRACT (YEAR  FROM l_newDate) into l_year FROM DUAL;
 


    BEGIN
        SELECT HOLIDAY_LIST INTO l_Holiday
        FROM STTMS_LCL_HOLIDAY
        WHERE YEAR=l_year AND MONTH=l_month;

  --KONTROLL
   Dbms_Output.put_line('L_DAY='||l_day);
   Dbms_Output.put_line('L_MONTH='||l_month);
   Dbms_Output.put_line('L_YEAR='||l_year);
   Dbms_Output.put_line('L_HOLIDAY='||l_Holiday);

    END;

   p_HorW:=SUBSTR(l_Holiday,l_day,1);
   IF
     p_HorW = 'H' THEN

     return true;
        else

          return false;
     end if;

  EXCEPTION
   WHEN OTHERS THEN
 p_error_message:='ERROR:INVALID DATE';
 Dbms_Output.put_line ( DBMS_UTILITY.FORMAT_ERROR_STACK() );
  Dbms_Output.put_line ( DBMS_UTILITY.FORMAT_ERROR_BACKTRACE() );

END fn_DORELA_IS_HOLIDAY;
/
