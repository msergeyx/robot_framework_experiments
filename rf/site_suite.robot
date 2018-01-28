*** Settings ***
Library  rf.site_interaction
Library  Collections
Suite Setup  Check Site Availability  ${MAIN_SITE}


*** Variables ***
${MAIN_SITE}  http://httpbin.org/
${GET_FUNC}  get
${STREAM_FUNC}  stream/
${OK}  200
${Unauthorized}  401
${NOT_FOUND}  404
&{DEFAULT_VALUES_FROM_GET}  X-Powered-By=Flask  Server=meinheld/0.6.1  Content-Type=application/json


*** Test Cases ***
Test get request to site
    ${link}=  Create Address  ${MAIN_SITE}  ${GET_FUNC}
    ${answer}=  Send Request  ${link}
    ${status_code}=  Get Answer Status Code  ${answer}
    Should Be Equal As Integers  ${OK}  ${status_code}
    ${default_headers}=  create dictionary  &{DEFAULT_VALUES_FROM_GET}
    ${answer_headers}=  Get Headers From Answer  ${answer}
    dictionaries should be equal  ${default_headers}  ${answer_headers}


Test get correct number of streams from site
    ${number_of_streams}=  Get Number Of Streams  correct
    ${link}=  create address  ${MAIN_SITE}  ${STREAM_FUNC}  ${number_of_streams}
    ${answer}=  Send Request  ${link}
    ${status_code}=  Get Answer Status Code  ${answer}
    Should Be Equal As Integers  ${OK}  ${status_code}
    ${number_of_streams_in_request}=  Get Number Of Streams In Request  ${answer}
    should be equal as integers  ${number_of_streams_in_request}  ${number_of_streams}


Test check number of streams from site in low boundary case
    ${number_of_streams}=  Get Number Of Streams  low_boundary
    ${link}=  create address  ${MAIN_SITE}  ${STREAM_FUNC}  ${number_of_streams}
    ${answer}=  Send Request  ${link}
    ${status_code}=  Get Answer Status Code  ${answer}
    Should Be Equal As Integers  ${OK}  ${status_code}
    ${number_of_streams_in_request}=  Get Number Of Streams In Request  ${answer}
    should be equal as integers  ${number_of_streams_in_request}  0
    should be equal as integers  ${number_of_streams}  0
    should be equal as integers  ${number_of_streams_in_request}  ${number_of_streams}


Test check number of streams from site in high boundary case
    ${number_of_streams}=  Get Number Of Streams  high_boundary
    ${link}=  create address  ${MAIN_SITE}  ${STREAM_FUNC}  ${number_of_streams}
    ${answer}=  Send Request  ${link}
    ${status_code}=  Get Answer Status Code  ${answer}
    Should Be Equal As Integers  ${OK}  ${status_code}
    ${number_of_streams_in_request}=  Get Number Of Streams In Request  ${answer}
    should be equal as integers  ${number_of_streams_in_request}  100
    should be equal as integers  ${number_of_streams}  100
    should be equal as integers  ${number_of_streams_in_request}  ${number_of_streams}


Test check number of streams from site in below boundary case
    ${number_of_streams}=  Get Number Of Streams  below_boundary
    ${link}=  create address  ${MAIN_SITE}  ${STREAM_FUNC}  ${number_of_streams}
    ${answer}=  Send Request  ${link}
    ${status_code}=  Get Answer Status Code  ${answer}
    Should Be Equal As Integers  ${NOT_FOUND}  ${status_code}


Test check number of streams from site in above boundary case
    ${number_of_streams}=  Get Number Of Streams  above_boundary
    ${link}=  create address  ${MAIN_SITE}  ${STREAM_FUNC}  ${number_of_streams}
    ${answer}=  Send Request  ${link}
    ${status_code}=  Get Answer Status Code  ${answer}
    Should Be Equal As Integers  ${OK}  ${status_code}
    ${number_of_streams_in_request}=  Get Number Of Streams In Request  ${answer}
    should not be equal as integers  ${number_of_streams_in_request}  ${number_of_streams}
    should be equal as integers  ${number_of_streams_in_request}  100


