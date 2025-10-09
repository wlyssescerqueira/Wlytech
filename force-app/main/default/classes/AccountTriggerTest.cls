/*
 * @coverage AccountTrigger
 */
@isTest
private class AccountTriggerTest {

    // Método auxiliar para criar contas em massa
    private static List<Account> createTestAccounts(Integer count, String namePrefix, Decimal revenue) {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < count; i++) {
            accounts.add(new Account(Name = namePrefix + ' ' + i, AnnualRevenue = revenue));
        }
        return accounts;
    }

    @isTest
    static void testInsertValidAccount() {
        Account acc = new Account(Name = 'Empresa YZZZ', AnnualRevenue = 1000000);
        insert acc;

        Account inserted = [SELECT Name, AnnualRevenue FROM Account WHERE Id = :acc.Id];
        System.assertEquals('Empresa YZZZ', inserted.Name, 'Nome da conta deve ser Empresa YZZZ');
        System.assertEquals(1000000, inserted.AnnualRevenue, 'Receita anual deve ser 1000000');
    }

    @isTest
    static void testInsertInvalidAccountName() {
        Account acc = new Account(Name = null);

        Test.startTest();
        try {
            insert acc;
            System.assert(false, 'Deveria lançar erro por nome nulo');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Nome é obrigatório'), 'Erro esperado por nome nulo');
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
            System.assert(e.getMessage().contains('Receita Anual não pode ser negativa'), 'Erro esperado por receita negativa');
        }
        Test.stopTest();
    }

    @isTest
    static void testUpdateValidAccount() {
        Account acc = new Account(Name = 'Empresa Inicial', AnnualRevenue = 500000);
        insert acc;

        acc.Name = 'Empresa Atualizada';
        acc.AnnualRevenue = 750000;

        Test.startTest();
        update acc;
        Test.stopTest();

        Account updated = [SELECT Name, AnnualRevenue FROM Account WHERE Id = :acc.Id];
        System.assertEquals('Empresa Atualizada', updated.Name, 'Nome da conta deve ser atualizado');
        System.assertEquals(750000, updated.AnnualRevenue, 'Receita anual deve ser atualizada');
    }

    @isTest
    static void testUpdateInvalidAccountName() {
        Account acc = new Account(Name = 'Empresa Inicial', AnnualRevenue = 500000);
        insert acc;

        acc.Name = '';

        Test.startTest();
        try {
            update acc;
            System.assert(false, 'Deveria lançar erro por nome vazio');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Nome é obrigatório'), 'Erro esperado por nome vazio');
        }
        Test.stopTest();
    }

    @isTest
    static void testUpdateInvalidRevenue() {
        Account acc = new Account(Name = 'Empresa Inicial', AnnualRevenue = 500000);
        insert acc;

        acc.AnnualRevenue = -500;

        Test.startTest();
        try {
            update acc;
            System.assert(false, 'Deveria lançar erro por receita negativa');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Receita Anual não pode ser negativa'), 'Erro esperado por receita negativa');
        }
        Test.stopTest();
    }

    @isTest
    static void testBulkInsertValidAccounts() {
        List<Account> accounts = createTestAccounts(200, 'Empresa Valida', 1000000);

        Test.startTest();
        insert accounts;
        Test.stopTest();

        List<Account> inserted = [SELECT Name, AnnualRevenue FROM Account WHERE Name LIKE 'Empresa Valida%'];
        System.assertEquals(200, inserted.size(), 'Deve inserir 200 contas');
        for (Account acc : inserted) {
            System.assertEquals(1000000, acc.AnnualRevenue, 'Receita anual deve ser 1000000');
            System.assert(acc.Name.startsWith('Empresa Valida'), 'Nome deve começar com Empresa Valida');
        }
    }

    @isTest
    static void testBulkInsertMixedAccounts() {
        List<Account> accounts = createTestAccounts(100, 'Empresa Valida', 1000000);
        accounts.add(new Account(Name = null, AnnualRevenue = 500000));
        accounts.add(new Account(Name = 'Empresa Negativa', AnnualRevenue = -100));

        Test.startTest();
        try {
            insert accounts;
            System.assert(false, 'Deveria lançar erro por contas inválidas');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Nome é obrigatório') || 
                         e.getMessage().contains('Receita Anual não pode ser negativa'), 
                         'Erro esperado por nome nulo ou receita negativa');
        }
        Test.stopTest();

        Integer count = [SELECT COUNT() FROM Account];
        System.assertEquals(0, count, 'Nenhuma conta deveria ser inserida devido ao erro');
    }

    @isTest
    static void testBulkUpdateAccounts() {
        List<Account> accounts = createTestAccounts(200, 'Empresa Inicial', 500000);
        insert accounts;

        for (Account acc : accounts) {
            acc.Name = 'Empresa Atualizada ' + acc.Name.split(' ')[2];
            acc.AnnualRevenue = 750000;
        }

        Test.startTest();
        update accounts;
        Test.stopTest();

        List<Account> updated = [SELECT Name, AnnualRevenue FROM Account WHERE Name LIKE 'Empresa Atualizada%'];
        System.assertEquals(200, updated.size(), 'Deve atualizar 200 contas');
        for (Account acc : updated) {
            System.assertEquals(750000, acc.AnnualRevenue, 'Receita anual deve ser 750000');
            System.assert(acc.Name.startsWith('Empresa Atualizada'), 'Nome deve começar com Empresa Atualizada');
        }
    }

    @isTest
    static void testEdgeCaseEmptyNameWithValidRevenue() {
        Account acc = new Account(Name = ' ', AnnualRevenue = 1000000);

        Test.startTest();
        try {
            insert acc;
            System.assert(false, 'Deveria lançar erro por nome vazio');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Nome é obrigatório'), 'Erro esperado por nome vazio');
        }
        Test.stopTest();
    }

    @isTest
    static void testEdgeCaseNullRevenue() {
        Account acc = new Account(Name = 'Empresa Valida', AnnualRevenue = null);

        Test.startTest();
        insert acc;
        Test.stopTest();

        Account inserted = [SELECT Name, AnnualRevenue FROM Account WHERE Id = :acc.Id];
        System.assertEquals('Empresa Valida', inserted.Name, 'Nome deve ser Empresa Valida');
        System.assertEquals(null, inserted.AnnualRevenue, 'Receita anual deve ser nula');
    }

    @isTest
    static void testMultipleErrorsInSingleAccount() {
        Account acc = new Account(Name = null, AnnualRevenue = -100);

        Test.startTest();
        try {
            insert acc;
            System.assert(false, 'Deveria lançar erro por nome nulo e receita negativa');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Nome é obrigatório'), 'Erro esperado por nome nulo');
            System.assert(e.getMessage().contains('Receita Anual não pode ser negativa'), 'Erro esperado por receita negativa');
        }
        Test.stopTest();
    }
}