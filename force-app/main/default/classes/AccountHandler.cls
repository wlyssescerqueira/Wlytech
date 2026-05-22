public class AccountHandler {
    public static Account InsertNewAccount(String accountName) {
        try {
            Account acct = new Account(Name = accountName);
            insert acct;
            return acct;
        } catch (DmlException e) {
            return null;
        }
    }
}
