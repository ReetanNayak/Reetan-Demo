/*
WebService Class= CalculatorServices, AsyncCalculatorServices
Apex Class= AwesomeCalculator, CalculatorCalloutMock, AwesomeCalculatorTest
*/

public class AwesomeCalculator {
    
    public static Double add(Double x, Double y) {
        CalculatorServices.CalculatorImplPort calc = new CalculatorServices.CalculatorImplPort();
        return calc.doAdd(x,y);
    }
}