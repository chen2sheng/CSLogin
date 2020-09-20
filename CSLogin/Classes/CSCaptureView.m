//
//  CSCaptureView.m
//  QRDeCode
//
//  Created by chens on 16/3/18.
//  Copyright © 2016年 luojing. All rights reserved.
//

#import "CSCaptureView.h"

@implementation CSCaptureView




-(void)prepareParts{
    if (!_session) {
        _session = [[AVCaptureSession alloc] init];
    }
    if (!_device) {
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    NSError *error = nil;
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
    if(_input) {
        // Add the input to the session
        [_session addInput:_input];
    }else{
        NSLog(@"error: %@", error);
        return;
    }
    

    
    _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _previewLayer.bounds = self.bounds;
    _previewLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    [self.layer addSublayer:_previewLayer];
    [self dealWithFuctionType];
    
}

-(void)dealWithFuctionType{
    if (_fuctionType==CSCaptureDecodeQRCodeType) {

        [self QRcodeSuface];
        if (!_output) {
            _output =[[AVCaptureMetadataOutput alloc]init];
            [_session addOutput:_output];
        }
        _session.sessionPreset= AVCaptureSessionPreset1920x1080;
        [(AVCaptureMetadataOutput*)_output setRectOfInterest:[self rectOfInterest]];
        [(AVCaptureMetadataOutput*)_output setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode, nil]];

    }
    [_session startRunning];
}

-(void)startWork{
    [self prepareParts];
}


-(CGRect)rectOfInterest{
    CGSize size = self.bounds.size;
    CGRect cropRect =CGRectMake(self.bounds.size.width*0.2, (self.bounds.size.height-self.bounds.size.width*0.6)/2, self.bounds.size.width*0.6, self.bounds.size.width*0.6);
    CGFloat p1 = size.height/size.width;
    CGFloat p2 = 1920./1080.;  //使用了1080p的图像输出
    if (p1 < p2) {
        CGFloat fixHeight = size.width * 1920. / 1080.;
        CGFloat fixPadding = (fixHeight - size.height)/2;
        return  CGRectMake((cropRect.origin.y + fixPadding)/fixHeight,
                                                  cropRect.origin.x/size.width,
                                                  cropRect.size.height/fixHeight,
                                                  cropRect.size.width/size.width);
    } else {
        CGFloat fixWidth = size.height * 1080. / 1920.;
        CGFloat fixPadding = (fixWidth - size.width)/2;
        return  CGRectMake(cropRect.origin.y/size.height,
                                                  (cropRect.origin.x + fixPadding)/fixWidth,
                                                  cropRect.size.height/size.height,
                                                  cropRect.size.width/fixWidth);
    }
}

-(void)setFuctionType:(CSCaptureFuctionType)fuctionType{
    _fuctionType=fuctionType;
}

-(void)QRcodeSuface{

    UIView *maskView = [[UIView alloc] initWithFrame:self.bounds];
    maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self addSubview:maskView];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:self.bounds];
    [maskPath appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(self.bounds.size.width*0.2, (self.bounds.size.height-self.bounds.size.width*0.6)/2, self.bounds.size.width*0.6, self.bounds.size.width*0.6) cornerRadius:1] bezierPathByReversingPath]];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = maskPath.CGPath;
    maskView.layer.mask = maskLayer;
    
    [self addSubview:maskView];
}


-(void)stopWork{
    [_session stopRunning];
}


@end
