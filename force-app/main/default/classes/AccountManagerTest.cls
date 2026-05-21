@IsTest
private class AccountManagerTest {
    @IsTest
    static void getAccountReturnsAccountWithContacts() {
        Account accountRecord = new Account(Name = 'Acme');
        insert accountRecord;

        insert new List<Contact>{
            new Contact(FirstName = 'Ana', LastName = 'Silva', AccountId = accountRecord.Id),
            new Contact(FirstName = 'Bruno', LastName = 'Souza', AccountId = accountRecord.Id)
        };

        RestRequest request = new RestRequest();
        request.requestUri = '/services/apexrest/Accounts/' + accountRecord.Id + '/contacts';
        request.httpMethod = 'GET';
        RestContext.request = request;
        RestContext.response = new RestResponse();

        Test.startTest();
        Account result = AccountManager.getAccount();
        Test.stopTest();

        System.assertEquals(accountRecord.Id, result.Id);
        System.assertEquals('Acme', result.Name);
        System.assertEquals(2, result.Contacts.size());

        Set<String> contactNames = new Set<String>();
        for (Contact contactRecord : result.Contacts) {
            contactNames.add(contactRecord.Name);
        }

        System.assert(contactNames.contains('Ana Silva'));
        System.assert(contactNames.contains('Bruno Souza'));
    }

    @IsTest
    static void getAccountReturnsNullWhenAccountIsNotFound() {
        Account accountRecord = new Account(Name = 'To Delete');
        insert accountRecord;
        delete accountRecord;

        RestRequest request = new RestRequest();
        request.requestUri = '/services/apexrest/Accounts/' + accountRecord.Id + '/contacts';
        request.httpMethod = 'GET';
        RestContext.request = request;
        RestContext.response = new RestResponse();

        Test.startTest();
        Account result = AccountManager.getAccount();
        Test.stopTest();

        System.assertEquals(null, result);
        System.assertEquals(404, RestContext.response.statusCode);
    }
}
