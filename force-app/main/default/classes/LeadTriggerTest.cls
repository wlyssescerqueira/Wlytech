@isTest
public class LeadTriggerTest {
    
    // Método de teste para verificar a inserção de um Lead
    @isTest
    static void testLeadInsert() {
        // Criar um Lead para teste
        Lead testLead = new Lead(
            FirstName = 'João',
            LastName = 'Silva',
            Company = 'Teste Empresa',
            Email = 'joao.silva@teste.com',
            Status = 'Open - Not Contacted'
        );
        
        // Inserir o Lead
        Test.startTest();
        insert testLead;
        Test.stopTest();
        
        // Recuperar o Lead após a inserção
        Lead insertedLead = [SELECT Description FROM Lead WHERE Id = :testLead.Id LIMIT 1];
        
        // Verificar se o campo Description foi preenchido corretamente
        System.assertEquals('Lead Name: João Silva', insertedLead.Description, 
            'O campo Description não foi preenchido corretamente na inserção.');
    }
    
    // Método de teste para verificar a atualização de um Lead
    @isTest
    static void testLeadUpdate() {
        // Criar e inserir um Lead
        Lead testLead = new Lead(
            FirstName = 'Maria',
            LastName = 'Santos',
            Company = 'Teste Empresa',
            Email = 'maria.santos@teste.com',
            Status = 'Open - Not Contacted'
        );
        insert testLead;
        
        // Atualizar o FirstName e LastName do Lead
        testLead.FirstName = 'Ana';
        testLead.LastName = 'Oliveira';
        
        // Atualizar o Lead
        Test.startTest();
        update testLead;
        Test.stopTest();
        
        // Recuperar o Lead após a atualização
        Lead updatedLead = [SELECT Description FROM Lead WHERE Id = :testLead.Id LIMIT 1];
        
        // Verificar se o campo Description foi atualizado corretamente
        System.assertEquals('Lead Name: Ana Oliveira', updatedLead.Description, 
            'O campo Description não foi atualizado corretamente.');
    }
    
    // Método de teste para verificar Lead com campos em branco
    @isTest
    static void testLeadWithBlankFields() {
        // Criar um Lead com FirstName em branco
        Lead testLead = new Lead(
            LastName = 'Costa',
            Company = 'Teste Empresa',
            Email = 'costa@teste.com',
            Status = 'Open - Not Contacted'
        );
        
        // Inserir o Lead
        Test.startTest();
        insert testLead;
        Test.stopTest();
        
        // Recuperar o Lead após a inserção
        Lead insertedLead = [SELECT Description FROM Lead WHERE Id = :testLead.Id LIMIT 1];
        
        // Verificar se o campo Description foi preenchido corretamente
        System.assertEquals('Lead Name: Not fully provided', insertedLead.Description, 
            'O campo Description não foi preenchido corretamente para campos em branco.');
    }
}