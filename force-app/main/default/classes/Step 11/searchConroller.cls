public with sharing class searchConroller {
    @AuraEnabled
    public static string searchRecords(string objName, string fieldName, string searchKey ){
        string searchKeyword = searchKey + '*';
        string returningQuery  = objName + '(Id, '+ fieldName +')';

        String query = 'FIND :searchKeyword IN ALL FIELDS RETURNING ' + returningQuery + 'LIMIT 2000';
        List<List<SObject>> records = Search.query(query);
        return JSON.serialize(records);
    }
}
