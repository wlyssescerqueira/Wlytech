public with sharing class AccountProcessor {
    @future
    public static void countContacts(List<Id> accountIds) {
        if (accountIds == null || accountIds.isEmpty()) {
            return;
        }

        Set<Id> uniqueAccountIds = new Set<Id>(accountIds);
        Map<Id, Integer> contactCountByAccountId = new Map<Id, Integer>();

        for (AggregateResult result : [
            SELECT AccountId accountId, COUNT(Id) contactCount
            FROM Contact
            WHERE AccountId IN :uniqueAccountIds
            GROUP BY AccountId
        ]) {
            contactCountByAccountId.put(
                (Id) result.get('accountId'),
                (Integer) result.get('contactCount')
            );
        }

        List<Account> accountsToUpdate = [
            SELECT Id
            FROM Account
            WHERE Id IN :uniqueAccountIds
        ];

        for (Account accountRecord : accountsToUpdate) {
            accountRecord.Number_Of_Contacts__c = contactCountByAccountId.containsKey(accountRecord.Id)
                ? contactCountByAccountId.get(accountRecord.Id)
                : 0;
        }

        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}
