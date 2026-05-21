public class AddPrimaryContact implements Queueable {
    private Contact contactTemplate;
    private String billingState;

    public AddPrimaryContact(Contact contactRecord, String stateAbbreviation) {
        this.contactTemplate = contactRecord;
        this.billingState = stateAbbreviation;
    }

    public void execute(QueueableContext context) {
        List<Contact> contactsToInsert = new List<Contact>();

        for (Account accountRecord : [
            SELECT Id
            FROM Account
            WHERE BillingState = :billingState
            LIMIT 200
        ]) {
            Contact contactRecord = contactTemplate.clone(false, false, false, false);
            contactRecord.AccountId = accountRecord.Id;
            contactsToInsert.add(contactRecord);
        }

        insert contactsToInsert;
    }
}
