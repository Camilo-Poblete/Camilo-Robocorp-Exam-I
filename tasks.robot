*** Settings ***
Documentation    Robot to enter weekly sales data into the RobotSpareBin Industries Intranet.
Library    RPA.Browser.Selenium   auto_close=${FALSE}
Library    RPA.Excel.Files
Library    RPA.PDF
Library    RPA.HTTP
Library    RPA.Dialogs



*** Keywords ***
Open the Intranet website
    Open Available Browser    https://robotsparebinindustries.com/

Downloas the excel file
    Download    https://robotsparebinindustries.com/SalesData.xlsx

Log in 
    Input Text    username    maria
    Input Text    password    thoushallnotpass
    Submit Form
    Wait Until Page Contains Element   id:sales-form


Fill and submit the form for one person
    [Arguments]   ${sales_rep}
    Input Text    firstname   ${sales_rep}[First Name]
    Input Text    lastname   ${sales_rep}[Last Name]
    Select From List By Value   salestarget    ${sales_rep}[Sales Target]
    Input Text   salesresult     ${sales_rep}[Sales]
    Click Button    Submit

Fill the form using the data from the excel file
  Open Workbook    SalesData.xlsx
  ${sales_reps}=  Read Worksheet As Table   header=True
  Close Workbook
  FOR   ${sales_rep}  IN  @{sales_reps}
    Fill and submit the form for one person   ${sales_rep} 

  END



Collect the results
    Screenshot     css:div.sales-summary   ${OUTPUT_DIR}${/}sales_summary.png


log out and close
   Click Button    logout
 


Export the table as a PDF
   Wait Until Element Is Visible     id:sales-results
   ${sales_result_html}=     Get Element Attribute   id:sales-results   outerHTML
   Html To Pdf    ${sales_result_html}   ${OUTPUT_DIR}${/}salesData.pdf


*** Tasks ***
Ingresar a la web 
    Open the Intranet website
    Log in
    Downloas the excel file  
    Fill the form using the data from the excel file
    Collect the results
    Export the table as a PDF
    [Teardown]  log out and close
   
    

