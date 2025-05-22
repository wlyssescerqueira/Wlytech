trigger AccountTrigger on Account (before insert, before update) {
    for (Account acc : Trigger.new) {
        if (acc.Name == null || acc.Name.trim() == '') {
            acc.addError('O campo Nome é obrigatório.');
        }


    }
}
