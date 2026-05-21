@IsTest
private class DailyLeadProcessorTest {
    @TestSetup
    static void setup() {
        List<Lead> leadsToInsert = new List<Lead>();

        for (Integer i = 0; i < 200; i++) {
            leadsToInsert.add(new Lead(
                FirstName = 'Daily',
                LastName = 'Lead ' + i,
                Company = 'Test Company ' + i,
                Status = 'Open - Not Contacted'
            ));
        }

        insert leadsToInsert;
    }

    @IsTest
    static void scheduleUpdatesAllBlankLeadSources() {
        String cronExpression = '0 0 0 1 1 ? 2099';

        Test.startTest();
        String jobId = System.schedule('Daily Lead Processor Test', cronExpression, new DailyLeadProcessor());
        Test.stopTest();

        System.assertNotEquals(null, jobId);
        System.assertEquals(
            200,
            [SELECT COUNT() FROM Lead WHERE LeadSource = 'Dreamforce']
        );
    }
}
