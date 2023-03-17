// main index.js

import _reactNative, {NativeModules, Platform} from 'react-native';

const VodUpload = NativeModules.VodUpload;
export type publishVideoParams = {
    signature: string; //必传：signature @see https://cloud.tencent.com/document/product/266/9221
    videoPath: string; //必传：视频地址，支持uri
    fileName: string; //必传：视频名称
    coverPath?: string; //封面
    enableResume?: boolean; //是否启动断点续传，默认开启
    enableHttps?: boolean; //上传是否使用https。默认关闭，走http
    enablePreparePublish?: boolean; //是否开启预上传机制，默认开启，备注：预上传机制可以大幅提升文件的上传质量
    concurrentCount?: bigint; // 分片上传并发数量，<=0 则表示SDK内部默认为2个，默认-1
};
export type publishMediaParams = {
    signature: string; //必传：signature @see https://cloud.tencent.com/document/product/266/9221
    mediaPath: string; //必传：图片地址，支持uri
    fileName: string; //必传：图片名称
    enableResume?: boolean; //是否启动断点续传，默认开启
    enableHttps?: boolean; //上传是否使用https。默认关闭，走http
    enablePreparePublish?: boolean; //是否开启预上传机制，默认开启，备注：预上传机制可以大幅提升文件的上传质量
    concurrentCount?: bigint; // 分片上传并发数量，<=0 则表示SDK内部默认为2个，默认-1
};


class VodUploadExport {
    emitter;
    listenerObj:object;
    constructor() {
        Platform.OS=='ios' ? VodUpload._init() : VodUpload.init();
        emitter =new _reactNative.NativeEventEmitter(VodUpload) ;
        this.listenerObj={
            onMediaPublishProgress:'',
            onMediaPublishComplete:'',
            onMediaPublishEvent:'',
            onPublishProgress:'',
            onPublishComplete:'',
            onPublishEvent:'',
        };
    }
    init(){

        if(Platform.OS=='ios') {
            VodUpload._init()
        }else{
            VodUpload.init();
        }
    }

    /**
     *
     * @param onPublishProgress:(msg:object) 上传状态回调
     * @param onPublishComplete:(msg:object) 上传完成回调
     * @param onPublishEvent:(msg:object) 上传事件回调
     */
    setVideoCallback(onPublishProgress,onPublishComplete,onPublishEvent){
        VodUpload.setVideoCallback();
        // emitter = new _reactNative.NativeEventEmitter(VodUpload);
        this.listenerObj.onPublishProgress= emitter.addListener('onPublishProgress', event => {
            onPublishProgress(event);
        });
        this.listenerObj.onPublishComplete=  emitter.addListener('onPublishComplete', event => {
            onPublishComplete(event);
        });
        onPublishEvent && (this.listenerObj.onPublishEvent= emitter.addListener('onPublishEvent', event => {
            onPublishEvent(event);
        }))
    }

    /**
     *
     * @param onMediaPublishProgress:(msg:object)=>{} 上传状态回调
     * @param onMediaPublishComplete:(msg:object)=>{} 上传完成回调
     * @param onMediaPublishEvent:(msg:object)=>{} 上传事件回调
     */
    setMediaCallback(onMediaPublishProgress,onMediaPublishComplete,onMediaPublishEvent){
        VodUpload.setMediaCallback();
        // emitter = new _reactNative.NativeEventEmitter(VodUpload);
        this.listenerObj.onMediaPublishProgress=  emitter.addListener('onMediaPublishProgress', event => {
            onMediaPublishProgress(event);
        });
        this.listenerObj.onMediaPublishComplete=emitter.addListener('onMediaPublishComplete', event => {
            onMediaPublishComplete(event);
        });
        onMediaPublishEvent && (this.listenerObj.onMediaPublishEvent=  emitter.addListener('onMediaPublishEvent', event => {
            onMediaPublishEvent(event);
        }))
    }

    removeAllListered(type){
        if(type == 1){
            this.listenerObj.onMediaPublishProgress.remove && this.listenerObj.onMediaPublishProgress.remove()
            this.listenerObj.onMediaPublishComplete.remove && this.listenerObj.onMediaPublishComplete.remove()
            this.listenerObj.onMediaPublishEvent.remove && this.listenerObj.onMediaPublishEvent.remove()
        }
        if(type==2){
            this.listenerObj.onPublishEvent.remove && this.listenerObj.onPublishEvent?.remove()
            this.listenerObj.onPublishComplete.remove &&  this.listenerObj.onPublishComplete?.remove()
            this.listenerObj.onPublishProgress.remove &&  this.listenerObj.onPublishProgress?.remove()
        }

    }

    startPublishVideo(params) {
        return VodUpload.startPublishVideo(params);

    }

    startPublishMedia(params) {
        return VodUpload.startPublishMedia(params);
    }
}

export default new VodUploadExport();
