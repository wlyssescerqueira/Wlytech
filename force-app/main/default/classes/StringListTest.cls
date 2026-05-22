@IsTest
public class StringListTest {
    @IsTest
    static void testGenerateStringList() {
        List<String> result = StringList.generateStringList(3);
        System.assertEquals(3, result.size());
        System.assertEquals('Test 0 (Teste 0)', result[0]);
        System.assertEquals('Test 1 (Teste 1)', result[1]);
        System.assertEquals('Test 2 (Teste 2)', result[2]);
    }

    @IsTest
    static void testGenerateStringListEmpty() {
        List<String> result = StringList.generateStringList(0);
        System.assertEquals(0, result.size());
    }
}
