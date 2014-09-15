// HWPickerView.h
// Modify from IQActionSheetPickerView
// IQActionSheetPickerView.h
// Created by Mohd Iftekhar Qurashi on 11/5/13.
// Copyright (c) 2013 Iftekhar. All rights reserved.

#import <Foundation/Foundation.h>

typedef enum HWPickerStyle
{
    HWPickerStyleTextPicker,
    HWPickerStyleDatePicker
}HWPickerStyle;

@class HWPickerView;

@protocol HWPickerView <NSObject>

- (void)pickerView:(HWPickerView *)pickerView didSelectTitles:(NSArray*)titles;

@end

@interface HWPickerView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
{
@private
    UIPickerView    *_pickerView;
    UIDatePicker    *_datePicker;
    UIToolbar       *_actionToolbar;
    UILabel         *_titleLabel;
}

-(id) initWithTitle:(NSString *)title delegate:(__weak id<HWPickerView>) delegate;

-(void)showOnTop;
-(void)setTitle:(NSString*)titleString;

@property(nonatomic, weak) id<HWPickerView> delegate; // weak reference
@property(nonatomic, assign) HWPickerStyle actionSheetPickerStyle;   //Default is HWPickerStyleTextPicker;
@property (nonatomic, strong, readonly) UIControl *overlayView;

/*for HWPickerStyleTextPicker*/
@property(nonatomic,assign) BOOL isRangePickerView;
@property(nonatomic, strong) NSArray *titlesForComponenets;
@property(nonatomic, strong) NSArray *widthsForComponents;

/*for HWPickerStyleDatePicker*/
@property(nonatomic, assign) NSDateFormatterStyle dateStyle;    //returning date string style.
@property(nonatomic, assign) NSDate *date; //get/set date.

@end