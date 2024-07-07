/**
 * Created by guan on 7/7/2024.
 */

@IsTest
private class sfp_TestUtilsTest {
    @IsTest
    static void testGenerateId() {
        Test.startTest();
        String testId = sfp_TestUtils.generateId(Account.SObjectType);
        Test.stopTest();
        System.assertEquals(18, testId.length());
    }
}