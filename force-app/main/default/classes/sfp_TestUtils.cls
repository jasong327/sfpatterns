/**
 * Created by guan on 7/7/2024.
 */

public class sfp_TestUtils {
    private static Integer s_num = 1;
    public static Id generateId(SObjectType sObjType){
        String counter = String.valueOf(s_num++);
        return sObjType.getDescribe().getKeyPrefix() + '0'.repeat(12-counter.length()) + counter;
    }
}