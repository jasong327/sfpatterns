public abstract class sfp_TriggerHandler{

    @TestVisible
    private static final String ERROR_NOT_TRIGGER_CONTEXT = 'Current context is not trigger context';
    @TestVisible
    private static final String ERROR_INVALID_TRIGGER_HANDLER = 'Invalid Trigger Handler, Custom Trigger Handler must extend TriggerHandler abstract class';

    // These virtual methods are to be extended in individual trigger handler class
    public virtual void onBeforeInsert(List<SObject> newRecords) {
    }
    public virtual void onBeforeUpdate(Map<Id, SObject> newRecordsMap, Map<Id, SObject> oldRecordsMap) {
    }
    public virtual void onBeforeDelete(Map<Id, SObject> oldRecordsMap) {
    }
    public virtual void onAfterInsert(Map<Id, SObject> newRecordsMap) {
    }
    public virtual void onAfterUpdate(Map<Id, SObject> newRecordsMap, Map<Id, SObject> oldRecordsMap) {
    }
    public virtual void onAfterDelete(Map<Id, SObject> oldRecordsMap) {
    }
    public virtual void onAfterUndelete(Map<Id, SObject> newRecordsMap) {
    }

    /**
     * @description  Execute the trigger handler by the class type passed in
     * @param        type: Type of the trigger handler class
     * @example In each object trigger, call TriggerHandler.execute(CustomTriggerHandler.class);
     */
    public static void execute(Type type) {
        Object handler = type.newInstance();
        if ((handler instanceof sfp_TriggerHandler) == false){
            throw new TriggerHandlerException(ERROR_INVALID_TRIGGER_HANDLER);
        }
        if (!Trigger.isExecuting){
            throw new TriggerHandlerException(ERROR_NOT_TRIGGER_CONTEXT);
        }
        ((sfp_TriggerHandler) handler).invoke();
    }

    /**
    * @description  Entry point of the object triggers, it collects the Trigger Context information and call the processing function
    * 				Test coverage: Trigger context cannot be generated in TriggerHandlerTest class. This method will be tested via any object trigger directly.
    */
    public virtual void invoke() {
        List<SObject> newRecords = Trigger.new;
        List<SObject> oldRecords = Trigger.old;
        Map<Id, SObject> newRecordsMap = Trigger.newMap;
        Map<Id, SObject> oldRecordsMap = Trigger.oldMap;
        Boolean isBefore = Trigger.isBefore;
        Boolean isInsert = Trigger.isInsert;
        Boolean isUpdate = Trigger.isUpdate;
        Boolean isDelete = Trigger.isDelete;
        Boolean isUndelete = Trigger.isUndelete;
        if(Trigger.isExecuting) processTriggerHandler(newRecords, oldRecords, newRecordsMap, oldRecordsMap, isBefore, isInsert, isUpdate, isDelete, isUndelete);
    }

    /**
     * @description	Method to process the trigger actions, it analyse the Trigger Context information and execute specific trigger handler method
     * @param		newRecords: records after DML operations
     * @param		oldRecords: records before DML operations
     * @param		newRecordsMap: id to records map referencing new records
     * @param		oldRecordsMap: id to records map referencing old records
     * @param		isBefore: boolean value to indicate the trigger context timing, true for before, false for after
     * @param		isInsert: boolean value to indicate the trigger context operation, true for insert
     * @param		isUpdate: boolean value to indicate the trigger context operation, true for update
     * @param		isDelete: boolean value to indicate the trigger context operation, true for delete
     * @param		isUndelete: boolean value to indicate the trigger context operation, true for undelete
     */
    @TestVisible
    private void processTriggerHandler(List<SObject> newRecords,
            List<SObject> oldRecords,
            Map<Id, SObject> newRecordsMap,
            Map<Id, SObject> oldRecordsMap,
            Boolean isBefore,
            Boolean isInsert,
            Boolean isUpdate,
            Boolean isDelete,
            Boolean isUndelete) {
        if (isBefore && isInsert) {
            onBeforeInsert(newRecords);
        }
        else if (isBefore && isUpdate) {
            onBeforeUpdate(oldRecordsMap, newRecordsMap);
        }
        else if (isBefore && isDelete) {
            onBeforeDelete(oldRecordsMap);
        }
        else if (!isBefore && isInsert) {
            onAfterInsert(newRecordsMap);
        }
        else if (!isBefore && isUpdate) {
            onAfterUpdate(oldRecordsMap, newRecordsMap);
        }
        else if (!isBefore && isDelete) {
            onAfterDelete(oldRecordsMap);
        }
        else if (!isBefore && isUndelete) {
            onAfterUndelete(newRecordsMap);
        }
    }

    public class TriggerHandlerException extends Exception {}
}