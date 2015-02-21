package com.telerik.leanplum;


import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;
import android.content.pm.ApplicationInfo;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import com.leanplum.Leanplum;
import com.leanplum.LeanplumPushService;

public class LeanplumPlugin extends CordovaPlugin {

  static final String START = "start";
  static final String TRACK = "track";
  static final String REGISTER = "registerPush";
  static final String UNREGISTER = "unregisterPush";

  private static String gECB;
  private static String gSenderID;

  protected void pluginInitialize() {
    int resId = cordova.getActivity().getResources().getIdentifier("app_id", "string", cordova.getActivity().getPackageName());
    String appId = cordova.getActivity().getString(resId);

    ApplicationInfo appInfo = this.cordova.getActivity().getApplicationInfo();

    boolean DEBUGGABLE = (appInfo.flags & ApplicationInfo.FLAG_DEBUGGABLE) != 0;

    if (DEBUGGABLE){

      resId = cordova.getActivity().getResources().getIdentifier("development_key", "string", cordova.getActivity().getPackageName());

      String developmentKey = cordova.getActivity().getString(resId);

      Leanplum.setAppIdForDevelopmentMode(appId, developmentKey);
    }
    else{
      resId = cordova.getActivity().getResources().getIdentifier("production_key", "string", cordova.getActivity().getPackageName());

      String prodKey = cordova.getActivity().getString(resId);

      Leanplum.setAppIdForProductionMode(appId, prodKey);
    }
  }

  @Override
  public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
    try {
      if (START.equals(action)) {
        start(callbackContext, args);
      }
      else if (TRACK.equals(action)) {
        track(callbackContext, args);
      }
      else if (REGISTER.equals(action)){
        register(callbackContext, args);
      }
      else if (UNREGISTER.equals(action)){
        unregister(callbackContext, args);
      }
    } catch (Exception e) {
      callbackContext.error(e.getMessage());
      return false;
    }
    return true;
  }

  public void start(CallbackContext callbackContext, JSONArray args) throws JSONException {

    LeanplumPushService.setGcmSenderId(LeanplumPushService.LEANPLUM_SENDER_ID);

    if (args.length() > 1) {
      Leanplum.start(webView.getContext(), args.getString(1));
    } else {
      Leanplum.start(webView.getContext());
    }

    String message = String.format("Leanplum started %b", true);

    callbackContext.success(message);
  }

  public void register(CallbackContext callbackContext, JSONArray args) throws JSONException{

    JSONObject jsonObject = args.getJSONObject(0);

    gECB = jsonObject.getString("callback");

    if (jsonObject.has("senderID")){
      LeanplumPushService.setGcmSenderId(jsonObject.getString("senderID"));
    }
    else{
      LeanplumPushService.setGcmSenderId(LeanplumPushService.LEANPLUM_SENDER_ID);
    }

    Leanplum.start(webView.getContext());

    callbackContext.success();
  }

  public void unregister(CallbackContext callbackContext, JSONArray args) throws JSONException{
    // Bug: Leanplum throws exception.
    //LeanplumPushService.unregister();
    callbackContext.success();
  }

  public void track(CallbackContext callbackContext, JSONArray args) throws JSONException{

    if (args.length() == 1){
      Leanplum.track(args.getString(0));
    }
    else if (args.length() > 1){
      Leanplum.track(args.getString(0), jsonToMap(args.getJSONObject(1)));
    }

    callbackContext.success();
  }

  public Map<String, Object> jsonToMap(JSONObject json) throws JSONException {
    Map<String, Object> retMap = new HashMap<String, Object>();

    if(json != JSONObject.NULL) {
      retMap = toMap(json);
    }
    return retMap;
  }

  public Map<String, Object> toMap(JSONObject object) throws JSONException {
    Map<String, Object> map = new HashMap<String, Object>();

    @SuppressWarnings("unchecked")
    Iterator<String> keysItr = object.keys();
    while(keysItr.hasNext()) {
      String key = keysItr.next();
      Object value = object.get(key);
      if(value instanceof JSONObject) {
        value = toMap((JSONObject) value);
      }
      map.put(key, value);
    }
    return map;
  }
}
