trigger LeadTrigger on Lead (before insert, before update) {
    // Iterar sobre os Leads no contexto do trigger
    for (Lead lead : Trigger.new) {
        // Verificar se o Lead é novo ou se o FirstName ou LastName foi alterado
        if (Trigger.isInsert || (Trigger.isUpdate && 
            (lead.FirstName != Trigger.oldMap.get(lead.Id).FirstName || 
             lead.LastName != Trigger.oldMap.get(lead.Id).LastName))) {
            
            // Concatenar FirstName e LastName no campo Description
            if (String.isNotBlank(lead.FirstName) && String.isNotBlank(lead.LastName)) {
                lead.Description = 'Lead Name: ' + lead.FirstName + ' ' + lead.LastName;
            } else {
                lead.Description = 'Lead Name: Not fully provided';
            }
        }
    }
}