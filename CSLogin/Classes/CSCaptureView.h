//
//  CSCaptureView.h
//  QRDeCode
//
//  Created by chens on 16/3/18.
//  Copyright © 2016年 luojing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger,CSCaptureFuctionType){
    CSCaptureTakePhotoType,
    CSCaptureDecodeQRCodeType
};

@interface CSCaptureView : UIView<AVCaptureMetadataOutputObjectsDelegate>

@property(nonatomic,strong)AVCaptureSession* session;

@property(nonatomic,strong)AVCaptureDevice *device;

@property(nonatomic,strong,readonly)AVCaptureDeviceInput *input;

@property(nonatomic,strong,readonly)AVCaptureVideoPreviewLayer*previewLayer;

@property(nonatomic,strong)AVCaptureOutput*output;


@property(nonatomic,assign)CSCaptureFuctionType fuctionType;

-(void)startWork;
-(void)stopWork;

@end
