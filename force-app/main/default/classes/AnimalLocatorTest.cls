@IsTest
private class AnimalLocatorTest {
    @IsTest
    static void getAnimalNameByIdReturnsAnimalName() {
        Test.setMock(HttpCalloutMock.class, new AnimalLocatorMock());

        Test.startTest();
        String animalName = AnimalLocator.getAnimalNameById(1);
        Test.stopTest();

        System.assertEquals('chicken', animalName);
    }
}
