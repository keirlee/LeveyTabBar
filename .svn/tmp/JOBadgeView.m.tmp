//
//  JOBadgeView.m
//  JOKit
//
//  Created by Jeffrey Oloresisimo on 11-07-27.
//  Copyright 2011 radelcom. All rights reserved.
//

#import "JOBadgeView.h"


#define	PADDING     14

@interface JOBadgeView (PRIVATE)

- (void)initialize;
- (void)autoPositionFromSuperView;

@end

@implementation JOBadgeView

@synthesize badgeValue = _badgeValue;
@synthesize fillColor = _fillColor;
@synthesize borderColor = _borderColor;
@synthesize showBorder = _showBorder;
@synthesize showGloss = _showGloss;
@synthesize showShadow = _showShadow;
@synthesize autoPositioning = _autoPositioning;

- (id)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)setFont:(UIFont*)font {
	[super setFont:font];
	[self setBadgeValue:_badgeValue];
}

- (void)setText:(NSString*)text {
	[super setText:text];
    
	CGSize size = [self.text sizeWithFont:self.font];    
    CGFloat radius = ceil((size.height)/2.0);
    CGFloat adjustment = ceil(size.width-radius) > 0 ? ceil(size.width-radius) : 0;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, (2*radius)+adjustment+PADDING, size.height+PADDING);
	self.hidden = self.text == nil;
    
	[self setNeedsDisplay];
}

- (void)setBadgeValue:(NSString *)badgeValue {
    [_badgeValue release];
    _badgeValue = [badgeValue retain];
    
    [self setText:_badgeValue];
}

- (void)setFillColor:(UIColor *)fillColor {
    [_fillColor release];
    _fillColor = [fillColor retain];
    
    [self setNeedsDisplay];
}

- (void)setBorderColor:(UIColor *)borderColor {
    [_borderColor release];
    _borderColor = [borderColor retain];
    
    [self setNeedsDisplay];
}

#pragma mark - PRIVATE
- (void)initialize {
    self.adjustsFontSizeToFitWidth = YES;
    self.font = [UIFont boldSystemFontOfSize:14];
    self.textColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor clearColor];
    self.textAlignment = UITextAlignmentCenter;
    self.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    self.fillColor = [UIColor redColor];
    self.borderColor = [UIColor whiteColor];
    self.showBorder = YES;
    self.showGloss = YES;
    self.showShadow = NO;
    self.autoPositioning = YES;
}

- (void)autoPositionFromSuperView {
	CGSize size = [self superview].bounds.size;
	self.frame = CGRectMake(size.width-self.bounds.size.width +5, self.bounds.origin.y - 5, self.bounds.size.width -3, self.bounds.size.height -3);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat radius = ceilf((self.bounds.size.height/2.0)-6);
	CGFloat minx = ceilf(CGRectGetMinX(self.bounds)+6), midx = ceilf(CGRectGetMidX(self.bounds)), maxx = ceilf(CGRectGetMaxX(self.bounds)-6);
	CGFloat miny = ceilf(CGRectGetMinY(self.bounds)+6), midy = ceilf(CGRectGetMidY(self.bounds)), maxy = ceilf(CGRectGetMaxY(self.bounds)-6);
    
	CGContextMoveToPoint(context, minx, midy);
	CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
    
    CGContextSaveGState(context);
    
    // fill
    if (_fillColor) {
        CGContextSetFillColorWithColor(context, _fillColor.CGColor);
    }
    
    // border
    if (_showBorder) {
        CGContextSetLineWidth(context, 2.0);
        CGContextSetStrokeColorWithColor(context, _borderColor.CGColor);
    } else { // set border color the same as fill color
        CGContextSetLineWidth(context, 2.0);
        CGContextSetStrokeColorWithColor(context, _fillColor.CGColor);
    }
    
    // shadow
    if (_showShadow && _showBorder) {
        UIColor* blurColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        CGContextSetShadowWithColor(context, CGSizeMake(0.0,2.0), 4, blurColor.CGColor);
    }
    
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextRestoreGState(context);
    
    // gloss
    if (_showGloss) {
        CGContextSaveGState(context);

        CGFloat locations[2] = { 0.0, 1.0 };
        CGFloat components[8] = {
            1.0, 1.0, 1.0, 0.8,
            1.0, 1.0, 1.0, 0.0,
        };
        
        CGColorSpaceRef cspace;
        CGGradientRef gradient;
        cspace = CGColorSpaceCreateDeviceRGB();
        gradient = CGGradientCreateWithColorComponents(cspace, components, locations, 2);

        CGFloat halfRadius = ceilf(midy/2.0);
		CGContextMoveToPoint(context, minx, midy/2);
        CGContextAddArcToPoint(context, minx, miny, midx, miny, halfRadius);
        CGContextAddArcToPoint(context, maxx, miny, maxx, midy/2, halfRadius);
        CGContextAddArcToPoint(context, maxx, midy, midx, midy, halfRadius);
        CGContextAddArcToPoint(context, minx, midy, minx, midy/2, halfRadius);
        CGContextClip(context);
        CGContextDrawLinearGradient (context, gradient, CGPointMake(radius, 0), CGPointMake(radius, maxy), kCGGradientDrawsBeforeStartLocation);
    	
        CGColorSpaceRelease(cspace);
        CGGradientRelease(gradient);
        CGContextRestoreGState(context);
    }
    
    if (_autoPositioning) {
        [self autoPositionFromSuperView];
    }
	
	[super drawRect:rect];
}

- (void)dealloc {
    [_badgeValue release];
    [_fillColor release];
    [_borderColor release];
    [super dealloc];
}

@end
