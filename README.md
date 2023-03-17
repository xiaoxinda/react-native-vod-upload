# react-native-vod-upload
##### langzixiaoxin@foxmail.com
## Getting started

# 支持安卓端，ios端
`$ npm install react-native-vod-upload --save`

## Usage
```javascript
import VodUploadExport from 'react-native-vod-upload';

/**
 * 上传视频
 */
//1.设置回调
VodUploadExport.setVideoCallback((msg)=>{
    console.log(msg);
},(msg)=>{
    console.log(msg);
})
//上传，此处用了ImagePicker组件，仅供参考，请注意then中的上传实现
ImagePicker.openPicker({
    multiple: false,
    mediaType: 'video',
}).then(async res => {
    let filePath = res.path.replace("file://", "");
    //测试视频上传
    VodUploadExport.startPublishVideo({
        signature: 'vuLmVSFK5v12343BdY+DCgaJytoSBzZWNyZXRJZD1BS0lEWHQ1NG91212312321123123GZhSWwmY3VycmVudFRpbWVTdGFtcD0xNjc4MzQ2MDE2JmV4cGlyZVRpbWU9MTY3ODU2MjAxNiZyYW5kb209Mg==',
        videoPath: filePath,
        //     coverPath: "",//如果有封面可以一起传
        fileName: "测试视频" + Math.round(Math.random() * 1000),
    }).then((msg) => {
        console.log(msg);
    });
});
//********************************************
    /**
     * 上传图片
     */
//1.设置回调
    VodUploadExport.setMediaCallback((msg)=>{
        console.log(msg);
    },(msg)=>{
        console.log(msg);
    })

//上传，此处用了ImagePicker组件，仅供参考，请注意then中的上传实现
    ImagePicker.openPicker({
        multiple: false,
        mediaType: 'photo',
    }).then(async res => {
        let filePath = res.path.replace("file://", "");
        //测试图片上传
        VodUploadExport.startPublishMedia({
            signature: 'vuLmVSFK5vz2QBdY+DCgaJytoSBzZWNyZXRJZD1123123HQ1NG9KYmlhYk94TFZSQ2w1QjNoN2Fwb2NDWGZhSWwmY3VycmVudFRpbWVTdGFtcD0xNjc4MzQ2MDE212321312ZVRpbWU9MTY3ODU2MjAxNiZyYW5kb209Mg==',
            mediaPath: filePath,
            fileName: "测试图片" + Math.round(Math.random() * 1000),
        }).then((msg) => {
            console.log(msg);
        });
    });


```
# 如果你感觉这个包不错，可以请作者喝杯咖啡☕️️️☕️️️☕️️️☕️️️~~~~~，作者口渴呀
![img.png](img.png)
