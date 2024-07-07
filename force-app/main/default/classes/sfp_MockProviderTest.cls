/**
 * Created by guan on 7/7/2024.
 */

@IsTest
private class sfp_MockProviderTest {
    @IsTest
    static void testMockProvider() {
        sfp_MockProvider mockProvider = new sfp_MockProvider();
        Assert.areEqual(3, sfp_Mockable.instance().add(1, 2));
        Assert.areEqual(1, sfp_Mockable.instance().sub(2, 1));
        sfp_Mockable mockable = (sfp_Mockable) mockProvider.createMock(sfp_Mockable.class);
        Test.startTest();
        mockProvider.when(mockable.add(1, 2))
                .thenReturn(5)
                .when(mockable.add(3, 3))
                .thenException(new sfp_MockProvider.MockProviderException('Test Exception'))
                .completeMocking();
        Test.stopTest();
        Assert.areEqual(5, sfp_Mockable.instance().add(1,2));
        try{
            sfp_Mockable.instance().add(3,3);
        }
        catch (Exception ex){
            Assert.areEqual('Test Exception', ex.getMessage());
        }
    }

    @IsTest
    static void testMockProviderNegative(){
        sfp_MockProvider mockProvider = new sfp_MockProvider();
        sfp_Mockable mockable = (sfp_Mockable) mockProvider.createMock(sfp_Mockable.class);
        Test.startTest();
        try{
            mockProvider.when(mockable.add(1, 2))
                    .when(mockable.add(2, 3));
        }
        catch (Exception ex){
            Assert.areEqual(sfp_MockProvider.ERROR_MISCONFIGURED, ex.getMessage());
        }
        mockProvider.currentSubKey = null;
        try{
            mockProvider.when(mockable.add(3, 4))
                    .thenReturn(5)
                    .thenReturn(6);
        }
        catch (Exception ex){
            Assert.areEqual(sfp_MockProvider.ERROR_MISCONFIGURED, ex.getMessage());
        }
        mockProvider.currentSubKey = null;
        try{
            mockProvider.when(mockable.add(4, 5))
                    .thenReturn(5)
                    .completeMocking();
            sfp_Mockable.instance().sub(5,6);
        }
        catch (Exception ex){
            Assert.isTrue(ex.getMessage().contains(sfp_MockProvider.ERROR_NO_MOCK));
        }
        Test.stopTest();
    }
}