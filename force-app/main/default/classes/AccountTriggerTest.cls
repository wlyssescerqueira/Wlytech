/*
 * @coverage AccountTrigger
 */

@isTest
private class AccountTriggerTest {

    @isTest
    static void testInsertValidAccount() {
        Account acc = new Account(Name = 'Empresa Y', AnnualRevenue = 1000000);
        insert acc;

        Account inserted = [SELECT Name, AnnualRevenue FROM Account WHERE Id = :acc.Id];
        System.assertEquals('Empresa Y', inserted.Name);
        System.assertEquals(1000000, inserted.AnnualRevenue);
    }

    @isTest
    static void testInsertInvalidAccountName() {
        Account acc = new Account(Name = null);

        Test.startTest();
        try {
            insert acc;
            System.assert(false, 'Deveria lançar erro por nome nulo');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Nome é obrigatório'));
        }
        Test.stopTest();
    }

    @isTest
    static void testInsertInvalidRevenue() {
        Account acc = new Account(Name = 'Empresa Negativa', AnnualRevenue = -100);

        Test.startTest();
        try {
            insert acc;
            System.assert(false, 'Deveria lançar erro por receita negativa');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Receita Anual não pode ser negativa'));
        }
        Test.stopTest();
    }
}
