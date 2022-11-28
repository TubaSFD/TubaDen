public class IMH_TA_Contact_BU_GetContactInfo {
    private static IMH_TA_Contact_BU_GetContactInfo instance;
    
    public IMH_TA_Contact_BU_GetContactInfo() {
    }
    
    public static IMH_TA_Contact_BU_GetContactInfo getInstance() {
        if (IMH_TA_Contact_BU_GetContactInfo.instance == null) {
            IMH_TA_Contact_BU_GetContactInfo.instance = new IMH_TA_Contact_BU_GetContactInfo();
        }
        return IMH_TA_Contact_BU_GetContactInfo.instance;
    }
    
    public Set<String> beforeContactPhoneSet { get; private set; }
    
    public class Service implements TriggerAction.BeforeUpdate {
        public void beforeUpdate(List<Contact> newList, List<Contact> oldList) { 
            Set<String> contactPhoneSet = new Set<String>();
            try {                   
                for (Contact con : newList) {                                         
                    if (String.isNotBlank(con.Phone)) con.Phone = SCL_GatewayUtils.formatPhoneNumber(con.Phone);
                    if (String.isNotBlank(con.Fax)) con.Fax = SCL_GatewayUtils.formatPhoneNumber(con.Fax);
                    if (String.isNotBlank(con.MobilePhone)) con.MobilePhone = SCL_GatewayUtils.formatPhoneNumber(con.MobilePhone);
                    if (String.isNotBlank(con.Phone)) contactPhoneSet.add(con.Phone);
                    if (String.isNotBlank(con.Fax)) contactPhoneSet.add(con.Fax);
                    if (String.isNotBlank(con.MobilePhone)) contactPhoneSet.add(con.MobilePhone);
                    if (String.isNotBlank(con.OtherPhone)) contactPhoneSet.add(con.OtherPhone);
                }  
                IMH_TA_Contact_BU_GetContactInfo.getInstance().beforeContactPhoneSet = contactPhoneSet;
                contactPhoneSet = null;
            } catch (Exception e) {
                SCL_GatewayUtils.publishException(newList,'update',e);
            }
        }              
    }
}