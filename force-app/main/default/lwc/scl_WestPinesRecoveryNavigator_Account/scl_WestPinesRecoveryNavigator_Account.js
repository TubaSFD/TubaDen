import { LightningElement, api } from 'lwc';

//On a Person Account, can only pre-import field tokens for Account fields (custom or standard), and standard Contact fields.
// Custom Contact fields need to be defined inline
import NAME_FLD from '@salesforce/schema/Account.Name';
import PHONE_FLD from '@salesforce/schema/Account.Phone';
import MOBILE_FLD from '@salesforce/schema/Account.PersonMobilePhone';
import EMAIL_FLD from '@salesforce/schema/Account.PersonEmail';
import MRN_FLD from '@salesforce/schema/Account.SCL_MRNPersonAccount__c';
import MOST_RECENT_HD_SCORE_FLD from '@salesforce/schema/Account.SCL_WPRN_MostRecentHDScore__c';
import INITIAL_HD_DATE_FLD from '@salesforce/schema/Account.SCL_WPRN_InitialHDSurvey__c';


export default class Scl_WestPinesRecoveryNavigator_Account extends LightningElement {
  @api recordId;
  fields = [
    NAME_FLD,    
    { fieldApiName: 'SCL_PreferredFirstName__pc', objectApiName: 'Account'},
    MRN_FLD,    
    { fieldApiName: 'SCL_Deceased__pc', objectApiName: 'Account'},
    { fieldApiName: 'SCL_WPRN_ProgramOutreach__pc', objectApiName: 'Account'},
    { fieldApiName: 'SCL_WPRN_ProgramStatus__pc', objectApiName: 'Account'},
    { fieldApiName: 'SCL_WPRN_StartDate__pc', objectApiName: 'Account'},
    { fieldApiName: 'SCL_WPRN_EstimatedEndDate__pc', objectApiName: 'Account'},
    { fieldApiName: 'SCL_WPRN_TelehealthConsent__pc', objectApiName: 'Account'},
    { fieldApiName: 'SCL_WPRN_Navigator__pc', objectApiName: 'Account'},
    EMAIL_FLD,    
    //PHONE_FLD, --- phone not included because it's already in the Compact Layout at the top
    MOBILE_FLD,    
    { fieldApiName: 'SCL_WPRN_PrimaryPhoneContact__pc', objectApiName: 'Account'},
    { fieldApiName: 'SCL_WPRN_ROIAlternateNumber__pc', objectApiName: 'Account'},
    { fieldApiName: 'SCL_WPRN_ROIAlternateName__pc', objectApiName: 'Account'},
    { fieldApiName: 'SCL_WPRN_PreferredContactMethod__pc', objectApiName: 'Account'},
    { fieldApiName: 'SCL_WPRN_PreferredContactAddl__pc', objectApiName: 'Account'},
    { fieldApiName: 'SCL_WPRN_Preferred_Contact_Times__pc', objectApiName: 'Account'},
    { fieldApiName: 'SCL_WPRN_ReferralSource__pc', objectApiName: 'Account'},   
    { fieldApiName: 'SCL_InsuranceProvider__pc', objectApiName: 'Account'},        
    { fieldApiName: 'SCL_DischargeDate__pc', objectApiName: 'Account'}, 
    { fieldApiName: 'SCL_WPRN_DateOfLastContact__pc', objectApiName: 'Account'},    
    { fieldApiName: 'SCL_WPRN_PointOfContact__pc', objectApiName: 'Account'},   
    { fieldApiName: 'SCL_WPRN_CallBack__pc', objectApiName: 'Account'}, 
    { fieldApiName: 'SCL_WPRN_PatientMilestones__pc', objectApiName: 'Account'},    
    INITIAL_HD_DATE_FLD,    
    MOST_RECENT_HD_SCORE_FLD,
    { fieldApiName: 'SCL_WPRN_Notes__pc', objectApiName: 'Account'},
  ]
  
}