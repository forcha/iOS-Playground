//
//  ViewController.m
//  Ribbon
//
//  Created by Ariel Cardieri on 4/02/14.
//  Copyright (c) 2014 Forcha. All rights reserved.
//

#import "ViewController.h"

typedef NS_ENUM(NSUInteger, AHCRibbonType) {
    AHCRibbonTypeTopRight = 0,
    AHCRibbonTypeTopLeft,
    AHCRibbonTypeBottonRight,
    AHCRibbonTypeBottonLeft
};

@interface AHCRibbonView : UIView

- (instancetype)initWithText:(NSString *)text andType:(AHCRibbonType)ribbonType;

@property (nonatomic, copy) NSString * text;
@property (nonatomic, assign) AHCRibbonType ribbonType;

@end

@implementation AHCRibbonView


static const CGFloat kAHCRibbonTextMinSize = 100;
static const CGFloat kAHCRibbonTextMaxSize = 300;
static const CGFloat kAHCRibbonTextHeight = 40;
static const CGFloat kAHCRibbonBorderHeight = 12;
static const CGFloat kAHCRibbonHeight = kAHCRibbonTextHeight + 2 * kAHCRibbonBorderHeight;

static NSAttributedString * AttributeStringForText(NSString * text) {
    NSShadow * shadow = [NSShadow new];
    shadow.shadowOffset = CGSizeMake(2.0, 2.0);
    shadow.shadowBlurRadius = 1.0f;
    NSMutableParagraphStyle * paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = NSTextAlignmentCenter;

    NSDictionary * attributes = @{
            NSFontAttributeName:[UIFont fontWithName:@"Arial-BoldMT" size:kAHCRibbonTextHeight],
            NSForegroundColorAttributeName:[UIColor whiteColor],
            NSShadowAttributeName:shadow,
            NSParagraphStyleAttributeName:paragraphStyle
    };

    NSAttributedString * attributedString = [[NSAttributedString alloc] initWithString:text
                                                                            attributes:attributes];
    return attributedString;
}

static CGFloat RibbonWidthForText(NSAttributedString * text) {
    CGRect textRect = [text boundingRectWithSize:CGSizeMake(kAHCRibbonTextMaxSize, kAHCRibbonTextHeight) options:0 context:nil];
    CGFloat textWidth = ceil(textRect.size.width);
    if (textWidth < kAHCRibbonTextMinSize) {
        textWidth = kAHCRibbonTextMinSize;
    } else if (textWidth > kAHCRibbonTextMaxSize) {
        textWidth = kAHCRibbonTextMaxSize;
    }

    return textWidth + (2 * kAHCRibbonHeight);
}

static CGRect AHCRibbonViewCalculateContainerRectForText(CGFloat outerContainerHypotenuse) {
    CGFloat outerContainerWidthHeight = ceil(outerContainerHypotenuse / sqrt(2));
    return CGRectMake(0, 0, outerContainerWidthHeight, outerContainerWidthHeight);
}

- (instancetype)initWithText:(NSString *)text andType:(AHCRibbonType)ribbonType {
    NSAttributedString * attributedString = AttributeStringForText(text);
    CGFloat outerContainerHypotenuse = RibbonWidthForText(attributedString);
    CGRect frame = AHCRibbonViewCalculateContainerRectForText(outerContainerHypotenuse);
    self = [super initWithFrame:frame];
    if (self) {
        self.text = text;
        _ribbonType = ribbonType;
        [self p_initAHCRibbonViewWithSize:CGSizeMake(outerContainerHypotenuse, kAHCRibbonTextHeight + (2 * kAHCRibbonBorderHeight))];
    }

    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView * view = [super hitTest:point withEvent:event];
    if (view == self) {
        return nil;
    }

    return view;
}

- (void)p_initAHCRibbonViewWithSize:(CGSize)size {
    UIImage * ribbonImage = [UIImage imageNamed:@"Ribbon"];
    UIImage * ribbonTiled = [ribbonImage resizableImageWithCapInsets:UIEdgeInsetsMake(kAHCRibbonBorderHeight, 0, kAHCRibbonBorderHeight, 0) resizingMode:UIImageResizingModeTile];

    UIImageView * ribbon = [[UIImageView alloc] initWithImage:ribbonTiled];
    ribbon.frame = CGRectMake(0, 0, size.width, size.height);

    ribbon.contentMode = UIViewContentModeScaleToFill;
    ribbon.layer.mask = [self p_ribbonMaskOfSize:size];

    UIView *container = [UIView new];
    container.center = self.center;
    container.bounds = CGRectMake(0, 0, size.width, size.height);
    container.layer.shadowOpacity = 1.0f;
    container.layer.shadowOffset = CGSizeMake(0, 0);
    [container.layer addSublayer:ribbon.layer];

    UILabel * price = [[UILabel alloc] initWithFrame:CGRectInset(container.bounds, size.height - kAHCRibbonBorderHeight, kAHCRibbonBorderHeight)];
    price.attributedText = AttributeStringForText(self.text);
    price.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [container addSubview:price];

    //FIXME: change rotation transformation based on ribbonType. also change price uilabel
//    CGAffineTransform rotation =
//
//    switch (self.ribbonType) {
//        case AHCRibbonTypeTopRight:
//    }


    container.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(0, - size.height / 2),
            CGAffineTransformConcat(CGAffineTransformMakeRotation(45 * M_PI/180.0), container.transform));

    [self addSubview:container];
}

- (CALayer*) p_ribbonMaskOfSize:(CGSize)sz {
    CGRect r = (CGRect){CGPointZero, sz};
    UIGraphicsBeginImageContextWithOptions(r.size, NO, 0);
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(con,[UIColor colorWithWhite:0 alpha:0].CGColor);
    CGContextFillRect(con, r);
    CGContextSetFillColorWithColor(con,[UIColor colorWithWhite:0 alpha:1].CGColor);
    UIBezierPath* p = [UIBezierPath bezierPath];
    [p moveToPoint:CGPointMake(0, sz.height)];
    [p addLineToPoint:CGPointMake(sz.height, 0)];
    [p addLineToPoint:CGPointMake(sz.width - sz.height, 0)];
    [p addLineToPoint:CGPointMake(sz.width, sz.height)];
    [p closePath];
    [p fill];
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CALayer* mask = [CALayer layer];
    mask.frame = r;
    mask.contents = (id)im.CGImage;
    return mask;
}

@end

@interface ViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIView *container;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _textField.text = @"$100.990";
    _container.layer.borderColor = [UIColor blackColor].CGColor;
    _container.layer.borderWidth = 1;
    [self ribbonWithText:_textField.text atPosition:self.view.center];
}

- (void)ribbonWithText:(NSString *)text atPosition:(CGPoint)center {
    AHCRibbonView * ribbonView = [[AHCRibbonView alloc] initWithText:text andType:AHCRibbonTypeTopRight];
    ribbonView.center = center;
    ribbonView.tag = 999;
    ribbonView.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(.5, .5), ribbonView.transform);
    [_container addSubview:ribbonView];

    UIPanGestureRecognizer * panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRibbon:)];
    [ribbonView addGestureRecognizer:panGR];
}

- (void)panRibbon:(UIPanGestureRecognizer *)gr {
    UIView* vv = gr.view;
    if (gr.state == UIGestureRecognizerStateBegan ||
            gr.state == UIGestureRecognizerStateChanged) {
        CGPoint delta = [gr translationInView: vv.superview];
        CGPoint old = vv.center;
        CGPoint c = vv.center;
        c.x += delta.x; c.y += delta.y;
        vv.center = c;
        if (!CGRectContainsRect(vv.superview.bounds, vv.frame)) {
            vv.center = old;
        }

        [gr setTranslation: CGPointZero inView: vv.superview];
    }
}

- (void)updateRibbon {
    UIView * oldRibbon = [_container viewWithTag:999];
    CGPoint oldCenter = oldRibbon.center;
    [oldRibbon removeFromSuperview];
    [self ribbonWithText:_textField.text atPosition:oldCenter];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _textField) {
        [textField resignFirstResponder];
        return YES;
    }
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _textField) {
        [self updateRibbon];
    }
}


@end
