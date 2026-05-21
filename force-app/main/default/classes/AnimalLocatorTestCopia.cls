@IsTest
private class AnimalLocatorTestCopia {
    @IsTest
    static void getAnimalNameByIdCopiaReturnsAnimalName() {
        Test.setMock(HttpCalloutMock.class, new AnimalLocatorMockCopia());

        Test.startTest();
        String animalName = AnimalLocatorCopia.getAnimalNameByIdCopia(2);
        Test.stopTest();

        System.assertEquals('cow', animalName);
    }
}
