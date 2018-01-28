*** Settings ***
Test Template  Authentication
Library  rf.site_interaction
Library  Collections
Suite Setup  Check Site Availability  ${ROOT_LINK}


*** Variables ***
${ROOT_LINK}  http://httpbin.org/
${SITE}  http://httpbin.org/basic-auth
${OK}  200
${Unauthorized}  401
${NOT_FOUND}  404


*** Test Cases ***   Username   Password   Expected
Success              1          1          ${OK}
                     jhdvljb    dfjvbdl    ${OK}
                     iuhrgh0780q40gaerjp89-nfge0j{(*U*E(hjJ*(VNPE(W*UFJHEW{(V*  P*(&EGF&*WERGH*(VFEH*FGEWH*PGEWH*P(GFHEP&*GF*ESGHF*(E   ${OK}
                     11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111   11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111   ${OK}
                     ${SPACE}   1          ${OK}
                     ${SPACE}   ${SPACE}   ${OK}
                     !          !          ${OK}
                     print("hello,world!")   print("hello,world!")   ${OK}
                     # орвмишви   швамшгшг   ${OK}
NOT_FOUND            ${EMPTY}   1          ${NOT_FOUND}
                     ${EMPTY}   ${EMPTY}   ${NOT_FOUND}
                     1          ${EMPTY}   ${NOT_FOUND}
                     # \t         \t         ${NOT_FOUND}
                     # .          .          ${NOT_FOUND}
                     # \n         \n         ${NOT_FOUND}
Unauthorized     [Template]    Unauthorized try to access
                     333        333        ${Unauthorized}
                     1          1          ${Unauthorized}


*** Keywords ***
Authentication
    [Arguments]  ${username}  ${password}  ${expected}
    ${address}=  create address  ${SITE}  ${username}  ${password}  auth
    ${answer}=  send authentication data  ${address}  ${username}  ${password}
    ${status_code}=  Get Answer Status Code  ${answer}
    should be equal as integers  ${status_code}  ${expected}

Unauthorized try to access
    [Arguments]  ${username}  ${password}  ${expected}
    ${address}=  create address  ${SITE}  ${username}  ${password}  auth
    ${generated_username}=  generate username
    ${generated_password}=  generate password
    ${answer}=  send authentication data  ${address}  ${generated_username}  ${generated_password}
    ${status_code}=  Get Answer Status Code  ${answer}
    should be equal as integers  ${status_code}  ${expected}