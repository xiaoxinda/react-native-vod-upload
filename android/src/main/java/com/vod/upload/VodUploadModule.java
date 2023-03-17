// VodUploadModule.java

package com.vod.upload;
import com.facebook.react.module.annotations.ReactModule;
import com.facebook.react.bridge.*;
import com.facebook.react.bridge.Callback;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import java.util.HashMap;
import androidx.annotation.NonNull;
import com.vod.upload.impl.UploadResumeDefaultController;

public class VodUploadModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;
    private TXUGCPublish mVideoPublish = null;
    private Promise mPromise;

    public VodUploadModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    @NonNull
    public String getName() {
        return "VodUpload";
    }

    @ReactMethod
    public void init(){
        mVideoPublish = new TXUGCPublish(reactContext);
    }

    //视频上传回调
    @ReactMethod
    public void setVideoCallback(){
        mVideoPublish.setListener(new TXUGCPublishTypeDef.ITXVideoPublishListener() {
            public void onPublishProgress(long uploadBytes, long totalBytes) {
                WritableMap params = Arguments.createMap();
                params.putDouble("uploadBytes", uploadBytes);
                params.putDouble("totalBytes",totalBytes);
                reactContext
                        .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                        .emit("onPublishProgress", params);
            }

            public void onPublishComplete(TXUGCPublishTypeDef.TXPublishResult result) {
                WritableMap params = Arguments.createMap();
                params.putInt("retCode", result.retCode);
                params.putString("descMsg", result.descMsg);
                params.putString("videoId", result.videoId);
                params.putString("videoURL", result.videoURL);
                params.putString("coverURL", result.coverURL);
                reactContext
                        .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                        .emit("onPublishComplete", params);
            }
        });
    }

    //图片上传回调
    @ReactMethod
    public void setMediaCallback(){
        mVideoPublish.setListener(new TXUGCPublishTypeDef.ITXMediaPublishListener() {
            public void onMediaPublishProgress(long uploadBytes, long totalBytes) {
                WritableMap params = Arguments.createMap();
                params.putDouble("uploadBytes", uploadBytes);
                params.putDouble("totalBytes",totalBytes);
                reactContext
                        .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                        .emit("onMediaPublishProgress", params);
            }

            public void onMediaPublishComplete(TXUGCPublishTypeDef.TXMediaPublishResult result) {
                WritableMap params = Arguments.createMap();
                params.putInt("retCode", result.retCode);
                params.putString("descMsg", result.descMsg);
                params.putString("mediaId", result.mediaId);
                params.putString("mediaURL", result.mediaURL);
                reactContext
                        .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                        .emit("onMediaPublishComplete", params);
            }
        });
    }

    /**
     * 开始发布视频
     * @param videoPath 视频路径
     * @param coverPath 封面路径
     * @param signature 签名
     * @param videoName 视频名称
     * @return 0：成功；-1：失败
     */
    @ReactMethod
    public void startPublishVideo(final ReadableMap params, Promise promise) {
        try {
            TXUGCPublishTypeDef.TXPublishParam param = new TXUGCPublishTypeDef.TXPublishParam();

            mPromise = promise;
            if (!params.hasKey("signature") || params.getString("signature").isEmpty()){
                throw new Exception("签名信息signature不能为空");
            }
            if (!params.hasKey("videoPath") || params.getString("videoPath").isEmpty()){
                throw new Exception("视频地址videoPath不能为空");
            }
            if (!params.hasKey("fileName") || params.getString("fileName").isEmpty()){
                throw new Exception("视频名称fileName不能为空");
            }
            param.signature =params.getString("signature");
            param.videoPath = params.getString("videoPath");//视频地址，支持uri
            param.fileName = params.getString("fileName");//视频名称
            if (params.hasKey("coverPath") && !params.getString("coverPath").isEmpty()){
                param.coverPath = params.getString("coverPath");//封面
            }
            if (params.hasKey("enableResume")){
                param.enableResume = params.getBoolean("enableResume");//是否启动断点续传，默认开启
            }
            param.enableHttps = true;//上传是否使用https。
            if (params.hasKey("enableHttps")){
                param.enableHttps = params.getBoolean("enableHttps");//上传是否使用https。默认关闭，走http
            }
            if (params.hasKey("enablePreparePublish")){
                param.enablePreparePublish = params.getBoolean("enablePreparePublish");//是否开启预上传机制，默认开启，备注：预上传机制可以大幅提升文件的上传质量
            }
            if (params.hasKey("concurrentCount")){
                param.concurrentCount = params.getInt("concurrentCount");// 分片上传并发数量，<=0 则表示SDK内部默认为2个
            }

            int publishCode = mVideoPublish.publishVideo(param);
            if (publishCode != 0) {
                mPromise.reject("error", "上传失败" + Integer.toString(publishCode));
                return;
            }
            mPromise.resolve("开始上传");

        }catch (Exception e){
            mPromise.reject("error", e.getMessage());
        }
    }

    //上传图片
    @ReactMethod
    public void startPublishMedia(final ReadableMap params, Promise promise) {
        try {
            TXUGCPublishTypeDef.TXMediaPublishParam param = new TXUGCPublishTypeDef.TXMediaPublishParam();

            mPromise = promise;
            if (!params.hasKey("signature") || params.getString("signature").isEmpty()){
                throw new Exception("签名信息signature不能为空");
            }
            if (!params.hasKey("mediaPath") || params.getString("mediaPath").isEmpty()){
                throw new Exception("图片地址mediaPath不能为空");
            }
            param.signature =params.getString("signature");
            param.mediaPath = params.getString("mediaPath");//图片地址，支持uri
            if (params.hasKey("enableResume")){
                param.enableResume = params.getBoolean("enableResume");//是否启动断点续传，默认开启
            }
            if (params.hasKey("enableHttps")){
                param.enableHttps = params.getBoolean("enableHttps");//上传是否使用https。默认关闭，走http
            }
            param.enableHttps = true;
            if (params.hasKey("fileName") && !params.getString("fileName").isEmpty()){
                param.fileName = params.getString("fileName");//图片名称
            }
            if (params.hasKey("enablePreparePublish")){
                param.enablePreparePublish = params.getBoolean("enablePreparePublish");//是否开启预上传机制，默认开启，备注：预上传机制可以大幅提升文件的上传质量
            }
            if (params.hasKey("concurrentCount")){
                param.concurrentCount = params.getInt("concurrentCount");// 分片上传并发数量，<=0 则表示SDK内部默认为2个
            }

            int publishCode = mVideoPublish.publishMedia(param);
            if (publishCode != 0) {
                mPromise.reject("error", "上传失败" + Integer.toString(publishCode));
                return;
            }
            mPromise.resolve("开始上传");

        }catch (Exception e){
            mPromise.reject("error", e.getMessage());
        }
    }
}
