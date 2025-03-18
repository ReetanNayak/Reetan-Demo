/*
WebService Class= CalculatorServices, AsyncCalculatorServices
Apex Class= AwesomeCalculator, CalculatorCalloutMock, AwesomeCalculatorTest
*/

@isTest
global class CalculatorCalloutMock implements WebServiceMock {
    
   global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
        // start - specify the response you want to send
        CalculatorServices.doAddResponse response_x = new CalculatorServices.doAddResponse();
        response_x.return_x = 3.0;
        // end
        response.put('response_x', response_x); 
   }
}