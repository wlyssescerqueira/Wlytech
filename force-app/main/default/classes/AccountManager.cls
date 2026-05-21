@RestResource(urlMapping='/Accounts/*/contacts')
global with sharing class AccountManager {
    @HttpGet
    global static Account getAccount() {
        RestRequest request = RestContext.request;
        List<String> pathParts = request.requestURI.split('/');
        String accountId = pathParts[pathParts.size() - 2];

        List<Account> accounts = [
            SELECT Id, Name, (SELECT Id, Name FROM Contacts)
            FROM Account
            WHERE Id = :accountId
            LIMIT 1
        ];

        if (accounts.isEmpty()) {
            RestContext.response.statusCode = 404;
            return null;
        }

        return accounts[0];
    }
}
