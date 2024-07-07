/**
 * Created by guan on 7/7/2024.
 */

public class sfp_Mockable implements sfp_MockProvider.IMockable{

    public static sfp_Mockable instance(){
        return (sfp_Mockable) sfp_MockProvider.getInstance(sfp_Mockable.class);
    }

    public Integer add(Integer a, Integer b){
        return a+b;
    }

    public Integer sub(Integer a, Integer b){
        return a-b;
    }
}