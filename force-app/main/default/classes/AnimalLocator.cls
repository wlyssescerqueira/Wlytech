public with sharing class AnimalLocator {
    private static final String BASE_URL = 'https://th-apex-http-callout.herokuapp.com/animals/';

    public static String getAnimalNameById(Integer animalId) {
        HttpRequest request = new HttpRequest();
        request.setEndpoint(BASE_URL + String.valueOf(animalId));
        request.setMethod('GET');

        Http http = new Http();
        HttpResponse response = http.send(request);
        AnimalResponse payload = (AnimalResponse) JSON.deserialize(response.getBody(), AnimalResponse.class);

        return payload.animal.name;
    }

    private class AnimalResponse {
        public Animal animal;
    }

    private class Animal {
        public Integer id;
        public String name;
        public String eats;
        public String says;
    }
}
