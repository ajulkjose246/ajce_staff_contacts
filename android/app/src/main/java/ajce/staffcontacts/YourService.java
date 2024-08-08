package ajce.staffcontacts;

import android.app.Service;
import android.content.Intent;
import android.os.IBinder;
import android.util.Log;

public class YourService extends Service {
    @Override
    public IBinder onBind(Intent intent) {
        // TODO: Return the communication channel to the service.
        return null;
    }

    @Override
    public void onCreate() {
        super.onCreate();
        Log.d("YourService", "Service created");
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        // Do background work here
        return START_STICKY;
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        Log.d("YourService", "Service destroyed");
    }
}
