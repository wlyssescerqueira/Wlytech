@IsTest
global class ParkServiceMock implements WebServiceMock {
    global void doInvoke(
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseNS,
        String responseName,
        String responseType
    ) {
        ParkService.byCountry requestBody = (ParkService.byCountry) request;

        System.assertEquals('https://th-apex-soap-service.herokuapp.com/service/parks', endpoint);
        System.assertEquals('United States', requestBody.arg0);
        System.assertEquals('byCountry', requestName);
        System.assertEquals('ParkService.byCountryResponse', responseType);

        ParkService.byCountryResponse responseBody = new ParkService.byCountryResponse();
        responseBody.return_x = new String[]{'Yellowstone', 'Yosemite', 'Grand Canyon'};
        response.put('response_x', responseBody);
    }
}
