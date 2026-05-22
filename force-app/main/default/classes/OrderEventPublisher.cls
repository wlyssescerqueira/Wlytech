public class OrderEventPublisher {
    public static void publish(String orderNumber, Boolean hasShipped) {
        Order_Event__e event = new Order_Event__e(
            Order_Number__c = orderNumber,
            Has_Shipped__c = hasShipped
        );

        Database.SaveResult sr = EventBus.publish(event);

        if (sr.isSuccess()) {
            System.debug('Successfully published Order Event.');
        } else {
            for (Database.Error err : sr.getErrors()) {
                System.debug('Error: ' + err.getStatusCode() + ' - ' + err.getMessage());
            }
        }
    }
}
