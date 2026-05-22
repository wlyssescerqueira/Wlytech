public class BusScheduleCache {
    private Cache.OrgPartition part;
    @TestVisible
    private static Map<String, Time[]> testSchedules = new Map<String, Time[]>();
    @TestVisible
    private static Boolean useInMemoryStoreForTests = false;

    public BusScheduleCache() {
        try {
            part = new Cache.OrgPartition('local.BusSchedule');
        } catch (Exception ex) {
            if (!Test.isRunningTest()) {
                throw ex;
            }
        }
    }

    public void putSchedule(String busLine, Time[] schedule) {
        String cacheKey = toCacheKey(busLine);

        if (Test.isRunningTest() && (useInMemoryStoreForTests || part == null)) {
            testSchedules.put(cacheKey, schedule);
            return;
        }

        part.put(cacheKey, schedule);
    }

    public Time[] getSchedule(String busLine) {
        String cacheKey = toCacheKey(busLine);
        Time[] schedule;

        if (Test.isRunningTest() && (useInMemoryStoreForTests || part == null)) {
            schedule = testSchedules.get(cacheKey);
        } else {
            schedule = (Time[]) part.get(cacheKey);
        }

        if (schedule == null) {
            return new Time[] {
                Time.newInstance(8, 0, 0, 0),
                Time.newInstance(17, 0, 0, 0)
            };
        }

        return schedule;
    }

    private static String toCacheKey(String busLine) {
        if (String.isBlank(busLine)) {
            throw new IllegalArgumentException('busLine must not be blank.');
        }

        return busLine.replaceAll('[^A-Za-z0-9]', '');
    }
}
