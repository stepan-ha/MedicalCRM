
@isTest
private class EventTriggerHelperTest {

    @TestSetup
    static void makeData(){
        Account acc = new Account(Name = 'Test');

        insert acc;

        Contact testContact = new Contact(FirstName = 'Test', 
                                            LastName = 'Test', 
                                            AccountId = acc.Id);

        insert testContact;


        Profile p = [SELECT Id FROM Profile WHERE Name='Customer Community Plus Login User']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com',
            ContactId = testContact.id);


        insert u;

        Test.startTest();
        EventTriggerHelperTest.assignPermissionSet(u.id);
        Test.stopTest();

        String doctorId = UserInfo.getUserId();

        System.runAs(u){
            insert new Event(Subject = 'Meeting',
                        WhoId = testContact.Id,
                        OwnerId = doctorId,
                        StartDateTime = DateTime.now(),
                        EndDateTime = DateTime.now().addMinutes(15));
        }

    }

    @future
    static void assignPermissionSet(String userId){

        PermissionSet ps = [SELECT Id 
                    FROM PermissionSet 
                    WHERE Name = 'Medical_CRM_External'];

        insert new PermissionSetAssignment(AssigneeId = userId, PermissionSetId = ps.Id);

    }

    @isTest
    static void validateTest() {

        User u = [SELECT Id 
                FROM User 
                WHERE Email = 'standarduser@testorg.com'];
        
        Account acc = [SELECT Id 
                    FROM Account 
                    LIMIT 1];

        Contact testContact = [SELECT Id 
                                FROM Contact 
                                LIMIT 1];

        String doctorId = UserInfo.getUserId();
        System.runAs(u){

            try {
                
                insert new Event(Subject = 'Meeting',
                            WhoId = testContact.Id,
                            OwnerId = doctorId,
                            StartDateTime = DateTime.now(),
                            EndDateTime = DateTime.now().addMinutes(15));
                
                System.assert(false);
    
            } catch (Exception e) {
                System.assert(true);
            }
        }

    }

    @isTest
    static void shareTest() {

        User u = [SELECT Id 
                FROM User 
                WHERE Email = 'standarduser@testorg.com'];

        Account acc = [SELECT Id 
                    FROM Account 
                    LIMIT 1];

        Contact testContact = [SELECT Id 
                                FROM Contact 
                                LIMIT 1];

        String doctorId = UserInfo.getUserId();

        List<Event> eventList = new List<Event>();

        Event eventItem =  new Event(Subject = 'Meeting',
                                    WhoId = testContact.Id,
                                    OwnerId = doctorId,
                                    StartDateTime = DateTime.now().addHours(2),
                                    EndDateTime = DateTime.now().addHours(2).addMinutes(15));

        Event eventItem2 =  new Event(Subject = 'Meeting',
                                    WhoId = testContact.Id,
                                    OwnerId = doctorId,
                                    StartDateTime = DateTime.now().addHours(4),
                                    EndDateTime = DateTime.now().addHours(4).addMinutes(15));
        
        eventList.add(eventItem);
        eventList.add(eventItem2);

        Test.startTest();

        System.runAs(u){

        insert eventList;
        }

        Test.stopTest();

        System.assertEquals(2,[SELECT Id 
                                FROM Event 
                                WHERE isCoppy__c = TRUE 
                                AND (Copy_From_Entity__c =: eventItem.id
                                OR Copy_From_Entity__c =: eventItem2.id)].size());

    }

    @isTest
    static void updateTest() {
        
        Event eventItem = [SELECT Id, StartDateTime, EndDateTime FROM Event WHERE isCoppy__c = FALSE LIMIT 1];

        eventItem.StartDateTime = Datetime.now().addHours(13);
        eventItem.EndDateTime = Datetime.now().addHours(14);

        update eventItem;

    }
}