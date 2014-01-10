//
//  LeveyTabBar.m
//  LeveyTabBarController
//
//  Created by Levey Zhu on 12/15/10.
//  Copyright 2010 VanillaTech. All rights reserved.
//

#import "LeveyTabBar.h"
#import "UIColor+Addition.h"
#define iconImageTag 66
#define lableTag 88

@implementation LeveyTabBar
@synthesize backgroundView = _backgroundView;
@synthesize delegate = _delegate;
@synthesize buttons = _buttons;

- (id)initWithFrame:(CGRect)frame iconArray:(NSArray *)iconArray txtArray:(NSArray *)txtArray
{
    self = [super initWithFrame:frame];
    if (self)
	{
		self.backgroundColor = [UIColor clearColor];
		_backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
		[self addSubview:_backgroundView];
		imageArray = [[NSMutableArray alloc] initWithArray:iconArray];
		self.buttons = [NSMutableArray arrayWithCapacity:[iconArray count]];
		UIButton *btn;
		CGFloat width = 320.0f / [iconArray count];
		for (int i = 0; i < [iconArray count]; i++)
		{
			btn = [UIButton buttonWithType:UIButtonTypeCustom];
			btn.showsTouchWhenHighlighted = YES;
            
			btn.tag = i;
			btn.frame = CGRectMake(width * i, 0, width, frame.size.height);
//			[btn setImage:[[imageArray objectAtIndex:i] objectForKey:@"Default"] forState:UIControlStateNormal];
//			[btn setImage:[[imageArray objectAtIndex:i] objectForKey:@"Highlighted"] forState:UIControlStateHighlighted];
//			[btn setImage:[[imageArray objectAtIndex:i] objectForKey:@"Seleted"] forState:UIControlStateSelected];
            
            [btn setBackgroundImage:[UIImage imageNamed:@"bgd_gray.png"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"bgd_orange.png"] forState:UIControlStateHighlighted];
            [btn setBackgroundImage:[UIImage imageNamed:@"bgd_orange.png"] forState:UIControlStateSelected];
			[btn addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            UIImage *icon = [[iconArray objectAtIndex:i] objectForKey:@"Default"];
            UIImageView *iconImageView= [[UIImageView alloc] initWithFrame:CGRectMake(width/2-12, 5, 24, 24)];
            [iconImageView setImage:icon];
            iconImageView.tag = iconImageTag;
            [btn addSubview:iconImageView];
            [iconImageView release];
            NSString *title = [txtArray objectAtIndex:i];
            UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height-20, width, 20)];
            [lblTitle setBackgroundColor:[UIColor clearColor]];
            lblTitle.text = title;
            lblTitle.textAlignment = UITextAlignmentCenter;
            lblTitle.textColor = [UIColor colorWithHexString:@"#e3632a"];
            lblTitle.font = [UIFont systemFontOfSize:12];
            lblTitle.tag = lableTag;
            [btn addSubview:lblTitle];
            [lblTitle release];
			[self.buttons addObject:btn];
			[self addSubview:btn];
		}
    }
    return self;
}

- (void)setBackgroundImage:(UIImage *)img
{
	[_backgroundView setImage:img];
}

- (void)tabBarButtonClicked:(id)sender
{
	UIButton *btn = sender;
	[self selectTabAtIndex:btn.tag];
}

- (void)selectTabAtIndex:(NSInteger)index
{
	for (int i = 0; i < [self.buttons count]; i++)
	{
		UIButton *b = [self.buttons objectAtIndex:i];
		b.selected = NO;
        UIImageView *iconImageView = (UIImageView *)[b viewWithTag:iconImageTag];
        UIImage *icon = [[imageArray objectAtIndex:i] objectForKey:@"Default"];
        [iconImageView setImage:icon];
        UILabel *lblTitle = (UILabel *)[b viewWithTag:lableTag];
        lblTitle.textColor = [UIColor colorWithHexString:@"#e3632a"];
	}
	UIButton *btn = [self.buttons objectAtIndex:index];
	btn.selected = YES;
    UIImageView *iconImageView = (UIImageView *)[btn viewWithTag:iconImageTag];
    UIImage *icon = [[imageArray objectAtIndex:index] objectForKey:@"Seleted"];
    [iconImageView setImage:icon];
    UILabel *lblTitle = (UILabel *)[btn viewWithTag:lableTag];
    lblTitle.textColor = [UIColor whiteColor];
    if ([_delegate respondsToSelector:@selector(tabBar:didSelectIndex:)])
    {
        [_delegate tabBar:self didSelectIndex:btn.tag];
    }
    NSLog(@"Select index: %d",btn.tag);
}

- (void)removeTabAtIndex:(NSInteger)index
{
    // Remove button
    [(UIButton *)[self.buttons objectAtIndex:index] removeFromSuperview];
    [self.buttons removeObjectAtIndex:index];
   
    // Re-index the buttons
     CGFloat width = 320.0f / [self.buttons count];
    for (UIButton *btn in self.buttons) 
    {
        if (btn.tag > index)
        {
            btn.tag --;
        }
        btn.frame = CGRectMake(width * btn.tag, 0, width, self.frame.size.height);
    }
}
- (void)insertTabWithImageDic:(NSDictionary *)dict atIndex:(NSUInteger)index
{
    // Re-index the buttons
    CGFloat width = 320.0f / ([self.buttons count] + 1);
    for (UIButton *b in self.buttons) 
    {
        if (b.tag >= index)
        {
            b.tag ++;
        }
        b.frame = CGRectMake(width * b.tag, 0, width, self.frame.size.height);
    }
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.showsTouchWhenHighlighted = YES;
    btn.tag = index;
    btn.frame = CGRectMake(width * index, 0, width, self.frame.size.height);
    [btn setImage:[dict objectForKey:@"Default"] forState:UIControlStateNormal];
    [btn setImage:[dict objectForKey:@"Highlighted"] forState:UIControlStateHighlighted];
    [btn setImage:[dict objectForKey:@"Seleted"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttons insertObject:btn atIndex:index];
    [self addSubview:btn];
}

- (void)dealloc
{
    [_backgroundView release];
    [_buttons release];
    [imageArray release];
    [super dealloc];
}

@end
