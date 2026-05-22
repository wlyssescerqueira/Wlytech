@IsTest
private class BusScheduleCacheTest {
    @IsTest
    static void storesAndReadsScheduleFromCache() {
        BusScheduleCache.useInMemoryStoreForTests = true;
        BusScheduleCache.testSchedules.clear();
        BusScheduleCache cache = new BusScheduleCache();
        Time[] expectedSchedule = new Time[] {
            Time.newInstance(6, 30, 0, 0),
            Time.newInstance(12, 15, 0, 0)
        };

        cache.putSchedule('Blue Line', expectedSchedule);
        Time[] actualSchedule = cache.getSchedule('Blue Line');

        System.assertEquals(2, actualSchedule.size());
        System.assertEquals(expectedSchedule[0], actualSchedule[0]);
        System.assertEquals(expectedSchedule[1], actualSchedule[1]);
    }

    @IsTest
    static void returnsDefaultScheduleOnCacheMiss() {
        BusScheduleCache.useInMemoryStoreForTests = false;
        BusScheduleCache.testSchedules.clear();
        BusScheduleCache cache = new BusScheduleCache();

        Time[] actualSchedule = cache.getSchedule('Green Line');

        System.assertEquals(2, actualSchedule.size());
        System.assertEquals(Time.newInstance(8, 0, 0, 0), actualSchedule[0]);
        System.assertEquals(Time.newInstance(17, 0, 0, 0), actualSchedule[1]);
    }
}
