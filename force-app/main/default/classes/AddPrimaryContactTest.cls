@IsTest
private class AddPrimaryContactTest {
    @TestSetup
    static void setup() {
        List<Account> accountsToInsert = new List<Account>();

        for (Integer i = 0; i < 50; i++) {
            accountsToInsert.add(new Account(
                Name = 'NY Account ' + i,
                BillingState = 'NY'
            ));
            accountsToInsert.add(new Account(
                Name = 'CA Account ' + i,
                BillingState = 'CA'
            ));
        }

        insert accountsToInsert;
    }

    @IsTest
    static void executeInsertsPrimaryContactForMatchingAccounts() {
        Contact primaryContact = new Contact(
            FirstName = 'Primary',
            LastName = 'Contact'
        );

        Test.startTest();
        System.enqueueJob(new AddPrimaryContact(primaryContact, 'CA'));
        Test.stopTest();

        System.assertEquals(
            50,
            [SELECT COUNT() FROM Contact WHERE FirstName = 'Primary' AND LastName = 'Contact']
        );
        System.assertEquals(
            50,
            [SELECT COUNT() FROM Contact WHERE FirstName = 'Primary' AND LastName = 'Contact' AND Account.BillingState = 'CA']
        );
    }
}
