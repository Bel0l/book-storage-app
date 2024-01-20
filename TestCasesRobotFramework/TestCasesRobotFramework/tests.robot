*** Settings ***
Library  SeleniumLibrary

*** Variables ***
${BASE_URL}  http://localhost:3000  # Replace with the actual base URL
${MODAL_SELECTOR}  .modal
${OPEN_MODAL_BUTTON}  [data-testid="open-modal-button"]
${CLOSE_BUTTON_SELECTOR}  ${MODAL_SELECTOR} .text-red-600
${BOOK_PUBLISH_YEAR}  ${MODAL_SELECTOR} h2
${BOOK_ID}  ${MODAL_SELECTOR} h4
${BOOK_TITLE}  ${MODAL_SELECTOR} h2
${BOOK_AUTHOR}  ${MODAL_SELECTOR} h2

*** Test Cases ***
Open And Close The Modal Correctly
    Open Browser  ${BASE_URL}  chrome
    Click Element  ${OPEN_MODAL_BUTTON}
    Wait Until Element Is Visible  ${MODAL_SELECTOR}
    Click Element  ${CLOSE_BUTTON_SELECTOR}
    Wait Until Element Is Not Visible  ${MODAL_SELECTOR}
    Close Browser

Display Book Details Correctly
    Open Browser  ${BASE_URL}  chrome
    Click Element  ${OPEN_MODAL_BUTTON}
    Wait Until Element Is Visible  ${MODAL_SELECTOR}
    ${book_publish_year} =  Get Text  ${BOOK_PUBLISH_YEAR}
    ${book_id} =  Get Text  ${BOOK_ID}
    ${book_title} =  Get Text  ${BOOK_TITLE}
    ${book_author} =  Get Text  ${BOOK_AUTHOR}
    Should Be Equal As Strings  ${book_publish_year}  2022
    Should Be Equal As Strings  ${book_id}  123456
    Should Be Equal As Strings  ${book_title}  Sample Book
    Should Be Equal As Strings  ${book_author}  John Doe
    Close Browser

Prevent Closing The Modal When Clicking Inside
    Open Browser  ${BASE_URL}  chrome
    Click Element  ${OPEN_MODAL_BUTTON}
    Wait Until Element Is Visible  ${MODAL_SELECTOR}
    Click Element  ${MODAL_SELECTOR}
    Sleep  1s  # Wait for the modal to stay open for verification
    Element Should Be Visible  ${MODAL_SELECTOR}
    Close Browser
/////////////////////////////////////////////////////////////////////////////////////////////

*** Settings ***
Library  SeleniumLibrary

*** Variables ***
${BASE_URL}  http://localhost:3000  # Replace with the actual base URL
${SHOW_ICON}  [data-testid="show-icon"]
${MODAL_SELECTOR}  .modal
${CLOSE_BUTTON_SELECTOR}  ${MODAL_SELECTOR} .text-red-600
${INFO_ICON}  [data-testid="info-icon"]
${EDIT_ICON}  [data-testid="edit-icon"]
${DELETE_ICON}  [data-testid="delete-icon"]
${BOOK_ID}  ${MODAL_SELECTOR} h4

*** Test Cases ***
Open And Close The Modal Correctly
    Open Browser  ${BASE_URL}  chrome
    Click Element  ${SHOW_ICON}
    Wait Until Element Is Visible  ${MODAL_SELECTOR}
    Click Element  ${CLOSE_BUTTON_SELECTOR}
    Wait Until Element Is Not Visible  ${MODAL_SELECTOR}
    Close Browser

Navigate To Book Details Page
    Open Browser  ${BASE_URL}  chrome
    Click Element  ${INFO_ICON}
    ${book_id} =  Get Text  ${BOOK_ID}
    Should Contain  ${book_id}  /books/details/
    Close Browser

Navigate To Book Edit Page
    Open Browser  ${BASE_URL}  chrome
    Click Element  ${EDIT_ICON}
    ${book_id} =  Get Text  ${BOOK_ID}
    Should Contain  ${book_id}  /books/edit/
    Close Browser

Navigate To Book Delete Page
    Open Browser  ${BASE_URL}  chrome
    Click Element  ${DELETE_ICON}
    ${book_id} =  Get Text  ${BOOK_ID}
    Should Contain  ${book_id}  /books/delete/
    Close Browser
/////////////////////////////////////////////////////////////////////////////////////////////////////

*** Settings ***
Library  SeleniumLibrary

*** Variables ***
${BASE_URL}  http://localhost:3000  # Replace with the actual base URL
${BOOKS_TABLE_PAGE}  /your-books-table-page
${BOOK_TITLE_SELECTOR}  table tbody tr td:nth-child(2)
${BOOK_AUTHOR_SELECTOR}  table tbody tr td:nth-child(3)
${BOOK_PUBLISH_YEAR_SELECTOR}  table tbody tr td:nth-child(4)
${INFO_ICON_SELECTOR}  table tbody tr:nth-child(1) a:nth-child(1)
${EDIT_ICON_SELECTOR}  table tbody tr:nth-child(1) a:nth-child(2)
${DELETE_ICON_SELECTOR}  table tbody tr:nth-child(1) a:nth-child(3)

*** Test Cases ***
Render Correct Number Of Rows And Columns
    Open Browser  ${BASE_URL}  chrome
    Go To  ${BOOKS_TABLE_PAGE}
    ${num_rows} =  Get Matching Xpath Count  //table/tbody/tr
    ${num_columns} =  Get Matching Xpath Count  //table/thead/tr/th
    Should Be Equal As Numbers  ${num_rows}  ${len(books)}
    Should Be Equal As Numbers  ${num_columns}  5  # Adjust this if the number of columns changes
    Close Browser

Display Book Details Correctly
    Open Browser  ${BASE_URL}  chrome
    Go To  ${BOOKS_TABLE_PAGE}
    @{book_titles} =  Get Texts  ${BOOK_TITLE_SELECTOR}
    @{book_authors} =  Get Texts  ${BOOK_AUTHOR_SELECTOR}
    @{book_publish_years} =  Get Texts  ${BOOK_PUBLISH_YEAR_SELECTOR}
    :FOR  ${index}  IN RANGE  0  ${len(books)}
        Should Be Equal As Strings  ${book_titles}[${index}]  ${books[${index}]['title']}
        Should Be Equal As Strings  ${book_authors}[${index}]  ${books[${index}]['author']}
        Should Be Equal As Strings  ${book_publish_years}[${index}]  ${books[${index}]['publishYear']
    Close Browser

Navigate To Book Details, Edit, And Delete Pages
    Open Browser  ${BASE_URL}  chrome
    Go To  ${BOOKS_TABLE_PAGE}
    Click Element  ${INFO_ICON_SELECTOR}
    ${current_url} =  Get Location
    Should Contain  ${current_url}  /books/details/${books[0]['_id']}
    
    Go To  ${BOOKS_TABLE_PAGE}
    Click Element  ${EDIT_ICON_SELECTOR}
    ${current_url} =  Get Location
    Should Contain  ${current_url}  /books/edit/${books[0]['_id']}
    
    Go To  ${BOOKS_TABLE_PAGE}
    Click Element  ${DELETE_ICON_SELECTOR}
    ${current_url} =  Get Location
    Should Contain  ${current_url}  /books/delete/${books[0]['_id']}
    
    Close Browser
