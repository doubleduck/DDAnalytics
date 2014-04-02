package co.doubleduck.extensions;

import android.os.Bundle;
import com.gameanalytics.android.GameAnalytics;
import com.gameanalytics.android.Severity;
import com.gameanalytics.*;
import com.flurry.android.FlurryAgent;
import java.lang.Float;
import java.util.Map;
import java.util.HashMap;
import org.haxe.extension.Extension;
import android.util.Log;


public class GameAnalyticsExt extends Extension 
{
        private static String flurryAppID = "";

        private static int initedGA = 0;
        private static int initedFlurry = 0;

        
        @Override public void onCreate (Bundle savedInstanceState)
        {
			   
        }
        

        @Override
        public void onResume() {
            super.onResume();
            if (initedGA == 1) {
              GameAnalytics.startSession(Extension.mainActivity);  
            }
            
        }

        @Override
        public void onPause() {
            super.onPause();
            if (initedGA == 1) {
                GameAnalytics.stopSession();
            }
        }

        @Override
        public void onStart() {
            super.onStart();
            if (initedFlurry == 1) {
                FlurryAgent.onStartSession(mainActivity, flurryAppID);
            }
        }

        @Override
        public void onStop() {
            super.onStop();
            if (initedFlurry == 1) {
                FlurryAgent.onEndSession(mainActivity);
            }
        }

        public static void initFlurry(String appID) {
            initedFlurry = 1;
            flurryAppID = appID;
            FlurryAgent.onStartSession(mainActivity, flurryAppID);
        }

        public static void initGA(String appID, String appSecret, String build) {
                GameAnalytics.setDebugLogLevel(GameAnalytics.RELEASE);
                GameAnalytics.initialise(Extension.mainActivity, appSecret, appID, build);
                GameAnalytics.startSession(Extension.mainActivity);
                initedGA = 1;
        }

        public static void designEvent(String eventId, float value, String area){
            if (initedGA == 1) {
                GameAnalytics.newDesignEvent(eventId, value, area, 0f, 0f , 0f);
            }

            if (initedFlurry == 1) {
                Map<String, String> params = new HashMap<String, String>();
                params.put("value", "" + value);
                params.put("area", area);
                FlurryAgent.logEvent(eventId, params);
            }
        }

        public static void businessEvent(String eventId, String currency, int amount, String area){
            if (initedGA == 1) {
                GameAnalytics.newBusinessEvent(eventId, currency, amount, area, 0f, 0f , 0f);
            }
            if (initedFlurry == 1) {
                Map<String, String> params = new HashMap<String, String>();
                params.put("currency", currency);
                params.put("amount", "" + amount);
                params.put("area", area);
                FlurryAgent.logEvent(eventId, params);
            }
        }
		
		public static void errorEvent(String message, String severity, String area){
            if (initedGA == 1) {
                Severity sev = null;
                if (severity.equals("debug")) {
                    sev = GameAnalytics.DEBUG_SEVERITY;
                }
                else if (severity.equals("critical")) {
                    sev = GameAnalytics.CRITICAL_SEVERITY;
                }
                else if (severity.equals("info")) {
                    sev = GameAnalytics.INFO_SEVERITY;
                }
                else if (severity.equals("warning")) {
                    sev = GameAnalytics.WARNING_SEVERITY;
                }
                else if (severity.equals("error")) {
                    sev = GameAnalytics.ERROR_SEVERITY;
                }
                GameAnalytics.newErrorEvent(message, sev, area, 0f, 0f , 0f);
            }
            if (initedFlurry == 1) {
                Map<String, String> params = new HashMap<String, String>();
                params.put("severity", severity);
                params.put("area", area);
                FlurryAgent.logEvent(message, params);
            }
        }
        
        
        

        
        
        
        
        
}
