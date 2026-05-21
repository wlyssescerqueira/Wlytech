@IsTest
global class AnimalLocatorMockCopia implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest request) {
        System.assertEquals('GET', request.getMethod());
        System.assertEquals('https://th-apex-http-callout.herokuapp.com/animals/2', request.getEndpoint());

        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setStatusCode(200);
        response.setBody('{"animal":{"id":2,"name":"cow","eats":"grass","says":"moo"}}');
        return response;
    }
}
