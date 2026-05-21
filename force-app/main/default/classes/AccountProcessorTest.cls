@IsTest
private class AccountProcessorTest {
    @IsTest
    static void countContactsUpdatesEachAccountTotal() {
        List<Account> accountRecords = new List<Account>{
            new Account(Name = 'Account One'),
            new Account(Name = 'Account Two')
        };
        insert accountRecords;

        insert new List<Contact>{
            new Contact(FirstName = 'Ana', LastName = 'Silva', AccountId = accountRecords[0].Id),
            new Contact(FirstName = 'Bruno', LastName = 'Souza', AccountId = accountRecords[0].Id),
            new Contact(FirstName = 'Carla', LastName = 'Lima', AccountId = accountRecords[1].Id)
        };

        Test.startTest();
        AccountProcessor.countContacts(new List<Id>{ accountRecords[0].Id, accountRecords[1].Id });
        Test.stopTest();

        Set<Id> accountIds = new Set<Id>{ accountRecords[0].Id, accountRecords[1].Id };
        Map<Id, Account> refreshedAccounts = new Map<Id, Account>([
            SELECT Number_Of_Contacts__c
            FROM Account
            WHERE Id IN :accountIds
        ]);

        System.assertEquals(2, refreshedAccounts.get(accountRecords[0].Id).Number_Of_Contacts__c);
        System.assertEquals(1, refreshedAccounts.get(accountRecords[1].Id).Number_Of_Contacts__c);
    }

    @IsTest
    static void countContactsSetsZeroWhenAccountHasNoContacts() {
        Account accountRecord = new Account(Name = 'No Contacts');
        insert accountRecord;

        Test.startTest();
        AccountProcessor.countContacts(new List<Id>{ accountRecord.Id });
        Test.stopTest();

        Account refreshedAccount = [
            SELECT Number_Of_Contacts__c
            FROM Account
            WHERE Id = :accountRecord.Id
        ];

        System.assertEquals(0, refreshedAccount.Number_Of_Contacts__c);
    }

    @IsTest
    static void countContactsReturnsWhenAccountIdsAreEmpty() {
        Test.startTest();
        AccountProcessor.countContacts(new List<Id>());
        Test.stopTest();

        System.assert(true);
    }
}
