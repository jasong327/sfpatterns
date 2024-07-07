/**
 * Created by guan on 7/7/2024.
 */

@IsTest
private class sfp_TriggerHandlerTest {
    @IsTest
    static void testTriggerHandlerNegative() {
        // Execute the valid trigger handler class and assert the overriden trigger context methods
        Test.startTest();
        try{
            sfp_TriggerHandler.execute(SampleTriggerHandler.class);
        }
        catch (Exception ex){
            System.assertEquals(sfp_TriggerHandler.ERROR_NOT_TRIGGER_CONTEXT, ex.getMessage());
        }
        try{
            sfp_TriggerHandler.execute(AccountSelector.class);
        }
        catch (Exception ex){
            System.assertEquals(sfp_TriggerHandler.ERROR_INVALID_TRIGGER_HANDLER, ex.getMessage());
        }
        Test.stopTest();
    }

    @IsTest
    static void testTriggerHandlerPositive() {
        SampleTriggerHandler handler = new SampleTriggerHandler();
        Map<Id, Account> newAccountMap = new Map<Id, Account>();
        Map<Id, Account> oldAccountMap = new Map<Id, Account>();
        Test.startTest();
        handler.invoke();
        handler.processTriggerHandler(newAccountMap.values(), oldAccountMap.values(), newAccountMap, oldAccountMap, true, true, false, false, false);
        handler.processTriggerHandler(newAccountMap.values(), oldAccountMap.values(), newAccountMap, oldAccountMap, true, false, true, false, false);
        handler.processTriggerHandler(newAccountMap.values(), oldAccountMap.values(), newAccountMap, oldAccountMap, true, false, false, true, false);
        handler.processTriggerHandler(newAccountMap.values(), oldAccountMap.values(), newAccountMap, oldAccountMap, false, true, false, false, false);
        handler.processTriggerHandler(newAccountMap.values(), oldAccountMap.values(), newAccountMap, oldAccountMap, false, false, true, false, false);
        handler.processTriggerHandler(newAccountMap.values(), oldAccountMap.values(), newAccountMap, oldAccountMap, false, false, false, true, false);
        handler.processTriggerHandler(newAccountMap.values(), oldAccountMap.values(), newAccountMap, oldAccountMap, false, false, false, false, true);
        Test.stopTest();
    }

    private class SampleTriggerHandler extends sfp_TriggerHandler {
    }
}