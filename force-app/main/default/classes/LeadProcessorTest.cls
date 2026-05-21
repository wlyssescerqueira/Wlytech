@IsTest
private class LeadProcessorTest {
    @TestSetup
    static void setup() {
        List<Lead> leadsToInsert = new List<Lead>();

        for (Integer i = 0; i < 200; i++) {
            leadsToInsert.add(new Lead(
                FirstName = 'Test',
                LastName = 'Lead ' + i,
                Company = 'Test Company ' + i,
                Status = 'Open - Not Contacted'
            ));
        }

        insert leadsToInsert;
    }

    @IsTest
    static void executeBatchUpdatesAllLeadSources() {
        Test.startTest();
        Id batchJobId = Database.executeBatch(new LeadProcessor(), 200);
        Test.stopTest();

        System.assertNotEquals(null, batchJobId);
        System.assertEquals(
            200,
            [SELECT COUNT() FROM Lead WHERE LeadSource = 'Dreamforce']
        );
    }
}
