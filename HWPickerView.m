// HWPickerView.m
// Modify from IQActionSheetPickerView
// IQActionSheetPickerView.m
// Created by Mohd Iftekhar Qurashi on 11/5/13.
// Copyright (c) 2013 Iftekhar. All rights reserved.

#import "HWPickerView.h"
#import <QuartzCore/QuartzCore.h>

@implementation HWPickerView
@synthesize actionSheetPickerStyle = _actionSheetPickerStyle;
@synthesize titlesForComponenets = _titlesForComponenets;
@synthesize widthsForComponents = _widthsForComponents;
@synthesize isRangePickerView = _isRangePickerView;
@synthesize dateStyle = _dateStyle;
@synthesize date = _date;
@synthesize delegate = _delegate;

- (id)init
{
    self = [super init];
    if (self) {
        _actionToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        _actionToolbar.barStyle = UIBarStyleBlackTranslucent;
        [_actionToolbar sizeToFit];
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(pickerCancelClicked:)];
        cancelButton.tintColor = [UIColor orangeColor];
        
        UIBarButtonItem *flexSpace1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem *flexSpace2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDoneClicked:)];
        doneBtn.tintColor = [UIColor orangeColor];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 160, 30)];
        _titleLabel.text = @"";
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:16.f];
        _titleLabel.backgroundColor = [UIColor clearColor];
        UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithCustomView:_titleLabel];
        
        [_actionToolbar setItems:[NSArray arrayWithObjects:cancelButton, flexSpace1, titleItem, flexSpace2, doneBtn, nil] animated:YES];
        [self addSubview:_actionToolbar];

        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_actionToolbar.frame) , 320, 0)];
         [_pickerView sizeToFit];
        [_pickerView setShowsSelectionIndicator:YES];
        [_pickerView setDelegate:self];
        [_pickerView setDataSource:self];
        [self addSubview:_pickerView];
        
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_actionToolbar.frame), 320, 0)];
        [_datePicker sizeToFit];
        [_datePicker setDatePickerMode:UIDatePickerModeDate];
        [self addSubview:_datePicker];
        [self setDateStyle:NSDateFormatterMediumStyle];
        
        UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, CGRectGetMaxY(_datePicker.frame))];
        bg.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.9];
        [self insertSubview:bg atIndex:0];
        [self setActionSheetPickerStyle:HWPickerStyleTextPicker];
    }
    return self;
}

-(id) initWithTitle:(NSString *)title delegate: (__weak id<HWPickerViewDelegate>)delegate
{
    self = [self init];
    if(self)
    {
        [self setTitle:title];
        _delegate = delegate;
    }
    return self;
}

-(void)setActionSheetPickerStyle:(HWPickerStyle)actionSheetPickerStyle
{
    _actionSheetPickerStyle = actionSheetPickerStyle;
    
    switch (actionSheetPickerStyle) {
        case HWPickerStyleTextPicker:
            [_pickerView setHidden:NO];
            [_datePicker setHidden:YES];
            break;
        case HWPickerStyleDatePicker:
            [_pickerView setHidden:YES];
            [_datePicker setHidden:NO];
            break;
     
        default:
            break;
    }
}

-(void)setFrame:(CGRect)frame
{
    //Forcing it to be static frame
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        [super setFrame:CGRectMake(0, 0, 320, 260+12)];
        [_actionToolbar setFrame:CGRectMake(0, 0, 320, 44)];
        [_pickerView setFrame:CGRectMake(0, 44, 320, 216)];
    }
    else
    {
        [super setFrame:frame];
    }
}

-(void)pickerCancelClicked:(UIBarButtonItem*)barButton
{
    //[self dismissWithClickedButtonIndex:0 animated:YES];
    [self removeFromSuperview];
    [[[UIApplication sharedApplication] keyWindow].rootViewController.view setUserInteractionEnabled:YES];
}

-(void)pickerDoneClicked:(UIBarButtonItem*)barButton
{
    if ([_delegate respondsToSelector:@selector(pickerView:didSelectTitles:)])
    {
        NSMutableArray *selectedTitles = [[NSMutableArray alloc] init];

        if (_actionSheetPickerStyle == HWPickerStyleTextPicker)
        {
            for (NSInteger component = 0; component<_pickerView.numberOfComponents; component++)
            {
                NSInteger row = [_pickerView selectedRowInComponent:component];
                
                if (row!= -1)
                {
                    [selectedTitles addObject:[[_titlesForComponenets objectAtIndex:component] objectAtIndex:row]];
                }
                else
                {
                    [selectedTitles addObject:[NSNull null]];
                }
            }
        }
        else if (_actionSheetPickerStyle == HWPickerStyleDatePicker)
        {
            [selectedTitles addObject:[NSDateFormatter localizedStringFromDate:_datePicker.date dateStyle:_dateStyle timeStyle:NSDateFormatterNoStyle]];
            [self setDate:_datePicker.date];
        }

        [_delegate pickerView:self didSelectTitles:selectedTitles];
    }
    //[self dismissWithClickedButtonIndex:0 animated:YES];
    [self removeFromSuperview];
    [[[UIApplication sharedApplication] keyWindow].rootViewController.view setUserInteractionEnabled:YES];
}

-(void) setDate:(NSDate *)date
{
    _date = date;
    if (_date != nil)   _datePicker.date = _date;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    //If having widths
    if (_widthsForComponents)
    {
        //If object isKind of NSNumber class
        if ([[_widthsForComponents objectAtIndex:component] isKindOfClass:[NSNumber class]])
        {
            CGFloat width = [[_widthsForComponents objectAtIndex:component] floatValue];

            //If width is 0, then calculating it's size.
            if (width == 0)
                return ((pickerView.bounds.size.width-20)-2*(_titlesForComponenets.count-1))/_titlesForComponenets.count;
            //Else returning it's width.
            else
                return width;
        }
        //Else calculating it's size.
        else
            return ((pickerView.bounds.size.width-20)-2*(_titlesForComponenets.count-1))/_titlesForComponenets.count;
    }
    //Else calculating it's size.
    else
    {
        return ((pickerView.bounds.size.width-20)-2*(_titlesForComponenets.count-1))/_titlesForComponenets.count;
    }
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return [_titlesForComponenets count];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[_titlesForComponenets objectAtIndex:component] count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[_titlesForComponenets objectAtIndex:component] objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_isRangePickerView && pickerView.numberOfComponents == 3)
    {
        if (component == 0)
        {
            [pickerView selectRow:MAX([pickerView selectedRowInComponent:2], row) inComponent:2 animated:YES];
        }
        else if (component == 2)
        {
            [pickerView selectRow:MIN([pickerView selectedRowInComponent:0], row) inComponent:0 animated:YES];
        }
    }
}


-(void)showOnTop
{
    [_pickerView reloadAllComponents];
    
    UIWindow* mainWindow = [[UIApplication sharedApplication] keyWindow];
    [mainWindow.rootViewController.view setUserInteractionEnabled:NO];
    [mainWindow addSubview: self];
    [self setBounds:mainWindow.bounds];
    [self setFrame:CGRectMake(0,
                              mainWindow.frame.size.height-_actionToolbar.bounds.size.height-_pickerView.bounds.size.height,
                              self.frame.size.width,
                              self.frame.size.height)];
    
}

-(void)setTitle:(NSString*)titleString
{
    _titleLabel.text = titleString;
}

@end