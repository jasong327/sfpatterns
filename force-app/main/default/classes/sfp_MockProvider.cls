/**
 * Created by guan on 1/7/2024.
 */

public class sfp_MockProvider implements StubProvider{

    @TestVisible
    private static final String ERROR_MISCONFIGURED = 'Configuration should be done with pairs of when() and thenReturn() or thenVoid() or thenException()';
    @TestVisible
    private static final String ERROR_NO_MOCK = 'No mocking found for the method call: ';
    private static Map<String, IMockable> mockableClassMap;
    private Boolean mockingCompleted = false;
    private Map<String, Object> stubReturnMap;
    @TestVisible
    private String currentSubKey;

    static{
        mockableClassMap = new Map<String, IMockable>();
    }

    public interface IMockable{}

    public sfp_MockProvider(){
        stubReturnMap = new Map<String, Object>();
    }

    public static IMockable getInstance(Type classType){
        String className = classType.getName();
        // When the class is in the mockableClassMap, return the mockable instance for unit test
        if(mockableClassMap.containsKey(className)){
            return mockableClassMap.get(className);
        }
        // Or return the real instance of the class
        return (IMockable) Type.forName(className).newInstance();
    }

    public Object handleMethodCall(Object stubbedObject, String stubbedMethodName, Type returnType, List<Type> listOfParamTypes, List<String> listOfParamNames, List<Object> listOfArgs){
        String key = getStubInvocationKey(stubbedObject, stubbedMethodName, returnType, listOfParamTypes, listOfParamNames, listOfArgs);
        System.debug('@@@@ key: ' + key);
        System.debug('@@@@ isInMocking(false): ' + isInMocking(false));
        if(isInMocking(false)){
            currentSubKey = key;
            return null;
        }
        else if(!stubReturnMap.containsKey(key)){
            throw new MockProviderException(ERROR_NO_MOCK + key);
        }
        Object returnValue = stubReturnMap.get(key);
        System.debug('@@@@ returnValue: ' + returnValue);
        if(returnValue instanceOf Exception){
            throw (Exception) returnValue;
        }
        return returnValue;
    }

    public IMockable createMock(Type classType){
        IMockable mockable = (IMockable) Test.createStub(classType, this);
        mockableClassMap.put(classType.getName(), mockable);
        return mockable;
    }

    public sfp_MockProvider completeMocking(){
        mockingCompleted = true;
        return this;
    }

    public sfp_MockProvider when(Object methodInvocation){
        return this;
    }

    public sfp_MockProvider thenReturn(Object returnValue){
        if(isInMocking(true)){
            stubReturnMap.put(currentSubKey, returnValue);
            currentSubKey = null;
        }
        return this;
    }

    public sfp_MockProvider thenException(Exception ex){
        if(isInMocking(true)){
            stubReturnMap.put(currentSubKey, ex);
            currentSubKey = null;
        }
        return this;
    }

    private Boolean isInMocking(Boolean expectCurrentStubKeyExist){
        if(mockingCompleted){
            return false;
        }
        if(expectCurrentStubKeyExist && currentSubKey == null){
            throw new MockProviderException(ERROR_MISCONFIGURED);
        }
        if(!expectCurrentStubKeyExist && currentSubKey != null){
            throw new MockProviderException(ERROR_MISCONFIGURED);
        }
        return true;
    }

    private String getStubInvocationKey(Object stubbedObject, String stubbedMethodName, Type returnType, List<Type> listOfParamTypes, List<String> listOfParamNames, List<Object> listOfArgs){
        String stubbedObjectString = String.valueOf(stubbedObject);
        String stubbedObjectValue = stubbedObjectString != null ? stubbedObjectString.split(':')[0] : '';
        List<String> values = new List<String>{
                stubbedObjectValue,
                String.valueOf(stubbedMethodName),
                String.valueOf(returnType),
                String.valueOf(listOfParamTypes),
                String.valueOf(listOfParamNames),
                String.valueOf(listOfArgs)
        };
        return String.join(values, '-');
    }

    @TestVisible
    private class MockProviderException extends Exception{}
}