CREATE OR REPLACE PROCEDURE PR_DORI_read_file(p_directory VARCHAR2,
                                           p_file_name VARCHAR2) AS
 l_id VARCHAR2(45); 
begin
  DBMS_OUTPUT.PUT_LINE('inside dori_Read_file');
  L_ID:=sys_guid();
INSERT INTO DORELA_xml_table(ID,Directory,File_Name,Xml_Data)
VALUES (l_id,p_directory,p_file_name,xmltype(
   bfilename(p_directory, p_file_name), nls_charset_id('AL32UTF8')    
  ));

   DBMS_OUTPUT.PUT_LINE('SUCCESS');      
   insert into dorela_table( ENDTOENDID,AMT,CCY,IBAN,BIC)       
  SELECT *
    FROM XMLTABLE('/Msg/Docs/Doc/Cctinit/Document/CstmrCdtTrfInitn/PmtInf/CdtTrfTxInf'
                  passing ( SELECT Xml_Data FROM DORELA_xml_table WHERE ID = l_id)
                  COLUMNS
                  "ENDTOENDID" varchar2(35) PATH './PmtId/EndToEndId',
                  "AMT" number PATH './Amt/InstdAmt',
                  "CCY" varchar2(3) PATH './Amt/InstdAmt/@Ccy',
                  "IBAN" varchar2(20) PATH './CdtrAcct/Id/IBAN',
                  "BIC" varchar2(12) PATH './CdtrAgt/FinInstnId/BIC');
  commit;
end PR_DORI_read_file;
/
