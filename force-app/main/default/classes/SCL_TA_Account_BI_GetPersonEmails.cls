public class SCL_TA_Account_BI_GetPersonEmails {
    private static SCL_TA_Account_BI_GetPersonEmails instance;
    
    public SCL_TA_Account_BI_GetPersonEmails() {
    }
    
    public static SCL_TA_Account_BI_GetPersonEmails getInstance() {
        if (SCL_TA_Account_BI_GetPersonEmails.instance == null) {
            SCL_TA_Account_BI_GetPersonEmails.instance = new SCL_TA_Account_BI_GetPersonEmails();
        }
        return SCL_TA_Account_BI_GetPersonEmails.instance;
    }
    
    public Set<String> beforePersonEmailSet { get; private set; }
    public Set<String> beforePersonPhoneSet { get; private set; }
    
    public class Service implements TriggerAction.BeforeInsert {
        public void beforeInsert(List<Account> newList) {  
            Set<String> patientEmailSet = new Set<String>();
            Set<String> patientPhoneSet = new Set<String>();
            try {                   
                for (Account acc : newList) {                                         
                    if (acc.IsPersonAccount == null || !acc.IsPersonAccount) continue;                    
                    if (String.isNotBlank(acc.PersonEmail)) patientEmailSet.add(acc.PersonEmail);
                    if (String.isNotBlank(acc.Phone)) acc.Phone = SCL_GatewayUtils.formatPhoneNumber(acc.Phone); 
                    if (String.isNotBlank(acc.PersonHomePhone)) acc.PersonHomePhone = SCL_GatewayUtils.formatPhoneNumber(acc.PersonHomePhone); 
                    if (String.isNotBlank(acc.PersonOtherPhone)) acc.PersonOtherPhone = SCL_GatewayUtils.formatPhoneNumber(acc.PersonOtherPhone); 
                    if (String.isNotBlank(acc.PersonMobilePhone)) acc.PersonMobilePhone = SCL_GatewayUtils.formatPhoneNumber(acc.PersonMobilePhone);  
                    if (String.isNotBlank(acc.Phone)) patientPhoneSet.add(acc.Phone);
                    if (String.isNotBlank(acc.PersonHomePhone)) patientPhoneSet.add(acc.PersonHomePhone);
                    if (String.isNotBlank(acc.PersonMobilePhone)) patientPhoneSet.add(acc.PersonMobilePhone);
                }                
                SCL_TA_Account_BI_GetPersonEmails.getInstance().beforePersonEmailSet = patientEmailSet;
                SCL_TA_Account_BI_GetPersonEmails.getInstance().beforePersonPhoneSet = patientPhoneSet;
                patientEmailSet = null;  
                patientPhoneSet = null;
               system.debug('phone'+patientPhoneSet);

            } catch (Exception e) {
                SCL_GatewayUtils.publishException(newList,'insert',e);
            }
        }              
    }
}