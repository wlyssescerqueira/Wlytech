@IsTest
private class ParkLocatorTest {
    @IsTest
    static void countryReturnsParksFromSoapService() {
        Test.setMock(WebServiceMock.class, new ParkServiceMock());

        Test.startTest();
        String[] parks = ParkLocator.country('United States');
        Test.stopTest();

        System.assertEquals(3, parks.size());
        System.assertEquals('Yellowstone', parks[0]);
        System.assertEquals('Yosemite', parks[1]);
        System.assertEquals('Grand Canyon', parks[2]);
    }
}
