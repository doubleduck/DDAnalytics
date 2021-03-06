package co.doubleduck;

import flash.Lib;
#if (android && !amazon)
import openfl.utils.JNI;
#elseif ios

#else
import gameanalytics.EventCategory;
import gameanalytics.GameAnalytics;
#end


@:allow(co.doubleduck.DDGameAnalytics) class DDGameAnalytics 
{

	#if ios
	#elseif (android && !amazon) 
	#else
	static public var defaultUserId:String = "desktopUser";
	#end
	static public var enabled:Bool = true;

	public static function designEvent(eventId:String, eventValue:Float, area:String = ""):Void{
		if (!enabled) {
			return;
		}
		#if (android && !amazon)
			if (jni_design_event== null) {

				jni_design_event = JNI.createStaticMethod ("co/doubleduck/extensions/GameAnalyticsExt", "designEvent", "(Ljava/lang/String;FLjava/lang/String;)V");

			}
			jni_design_event(eventId, eventValue, area);
		#elseif ios
			ga_design_event(eventId, eventValue, area);
		#else

			GameAnalytics.newEvent(EventCategory.DESIGN, {event_id: eventId, value: eventValue, area: area});

		#end


	}

	public static function businessEvent(eventId:String, currency:String, amount:Int, area:String = ""):Void{
		if (!enabled) {
			return;
		}
		#if (android && !amazon)
			if (jni_business_event== null) {

				jni_business_event = JNI.createStaticMethod ("co/doubleduck/extensions/GameAnalyticsExt", "businessEvent", "(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;)V");

			}
			jni_business_event(eventId, currency, amount, area);
		#elseif ios
			ga_business_event(eventId, currency, amount, area);
		#else

			GameAnalytics.newEvent(EventCategory.BUSINESS, {event_id: eventId, currency: currency, amount: amount, area: area});

		#end

	}
	
	public static function errorEvent(message:String, severity:String, area:String = ""):Void {
		if (!enabled) {
			return;
		}
		#if (android && !amazon)
			if (jni_error_event == null) {
				jni_error_event = JNI.createStaticMethod ("co/doubleduck/extensions/GameAnalyticsExt", "errorEvent", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V");
			}
			jni_error_event(message, severity, area);
			
		#elseif ios
			ga_error_event(message, severity, area);
		#else
			GameAnalytics.newEvent(EventCategory.ERROR, { severity: severity, message:message, area:area } );
		#end
	}

	
	public static function init(appID:String, appSecret:String, version:String = "1.0", platform:String = "desktop") {
		if (!enabled) {
			return;
		}
		#if ios
		ga_init(appID, appSecret, version);
		#elseif (android && !amazon)
			if (jni_init_event == null) {
				jni_init_event = JNI.createStaticMethod ("co/doubleduck/extensions/GameAnalyticsExt", "initGA", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V");
			}
			jni_init_event(appID, appSecret, version);
		#else
			#if amazon
				platform = "amazon";
			#end
			GameAnalytics.DEBUG_MODE = true;
			GameAnalytics.init(appID, appSecret, version, defaultUserId);
			GameAnalytics.newEvent(EventCategory.USER, {platform: platform});
		#end
	}

	public static function initFlurry(appID:String) {
		if (!enabled) {
			return;
		}
		#if ios
		//ga_init(appID, appSecret, version);
		#elseif (android && !amazon)
			if (jni_flurry_init_event == null) {
				jni_flurry_init_event = JNI.createStaticMethod ("co/doubleduck/extensions/GameAnalyticsExt", "initFlurry", "(Ljava/lang/String;)V");
			}
			jni_flurry_init_event(appID);
		#end
	}

	// Android JNI Handlers
	#if (android && !amazon)
	static var jni_init_event:Dynamic;
	static var jni_flurry_init_event:Dynamic;
	static var jni_design_event:Dynamic;
	static var jni_business_event:Dynamic;
	static var jni_error_event:Dynamic;
	#end

	
	#if ios
	static var ga_init            = Lib.load("ddgameanalytics","ga_init",3);
	static var ga_design_event    = Lib.load("ddgameanalytics", "ga_design_event", 3);
	static var ga_error_event     = Lib.load("ddgameanalytics", "ga_error_event", 3);
	static var ga_business_event  = Lib.load("ddgameanalytics","ga_business_event", 4);
	#end
	
	
}
