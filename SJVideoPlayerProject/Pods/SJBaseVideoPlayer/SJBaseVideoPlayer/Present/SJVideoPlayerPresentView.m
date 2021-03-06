//
//  SJVideoPlayerPresentView.m
//  SJVideoPlayerProject
//
//  Created by BlueDancer on 2017/11/29.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJVideoPlayerPresentView.h"
#import <AVFoundation/AVPlayerLayer.h>
#import <Masonry/Masonry.h>

NS_ASSUME_NONNULL_BEGIN

@interface SJVideoPlayerPresentView ()

@property (nonatomic, strong, readonly) UIImageView *placeholderImageView;

@end

NS_ASSUME_NONNULL_END

@implementation SJVideoPlayerPresentView {
    BOOL _isHidden;
}

@synthesize placeholderImageView = _placeholderImageView;

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayerLayer *)avLayer {
    return (AVPlayerLayer *)self.layer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if ( !self ) return nil;
    [self _presentSetupView];
    return self;
}

#pragma mark -

#ifdef SJ_MAC
- (void)dealloc {
    NSLog(@"%d - %s", (int)__LINE__, __func__);
}
#endif

#pragma mark -

- (void)showPlaceholder {
    if ( !_isHidden ) return; _isHidden = NO;
    self.placeholderImageView.alpha = 1;
}

- (void)hiddenPlaceholder {
    if ( _isHidden ) return; _isHidden = YES;
    self.placeholderImageView.alpha = 0.001;
}

- (void)setPlayer:(AVPlayer *)player {
    if ( player == self.avLayer.player ) return;
    self.avLayer.player = player;
    
    CATransition *anima = [CATransition animation];
    anima.type = kCATransitionFade;
    anima.duration = 1.0f;
    [self.layer addAnimation:anima forKey:@"fadeAnimation"];
}

- (AVPlayer *)player {
    return self.avLayer.player;
}

- (void)setPlaceholder:(UIImage *)placeholder {
    if ( placeholder == _placeholder ) return;
    _placeholder = placeholder;
    _placeholderImageView.image = placeholder;
}

- (void)setVideoGravity:(AVLayerVideoGravity)videoGravity {
    if ( videoGravity == self.videoGravity ) return;
    [self avLayer].videoGravity = videoGravity;
}

- (AVLayerVideoGravity)videoGravity {
    return [self avLayer].videoGravity;
}

- (void)_presentSetupView {
    self.backgroundColor = [UIColor blackColor];
    self.placeholderImageView.frame = self.bounds;
    _placeholderImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_placeholderImageView];
    [self hiddenPlaceholder];
}

- (UIImageView *)placeholderImageView {
    if ( _placeholderImageView ) return _placeholderImageView;
    _placeholderImageView = [UIImageView new];
    _placeholderImageView.contentMode = UIViewContentModeScaleAspectFill;
    _placeholderImageView.clipsToBounds = YES;
    return _placeholderImageView;
}

@end
