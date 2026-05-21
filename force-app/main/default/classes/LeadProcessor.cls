public with sharing class LeadProcessor implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, LeadSource
            FROM Lead
        ]);
    }

    public void execute(Database.BatchableContext bc, List<Lead> scope) {
        for (Lead leadRecord : scope) {
            leadRecord.LeadSource = 'Dreamforce';
        }

        if (!scope.isEmpty()) {
            update scope;
        }
    }

    public void finish(Database.BatchableContext bc) {
    }
}
