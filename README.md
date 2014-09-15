HWPickerView
============
Modify from [IQActionSheetPickerView](https://github.com/hackiftekhar/IQActionSheetPickerView)

## Reason
iOS 8 not support class extends from UIActionSheet

##How to use:

### delegate  

@interface ClassName : ExtendsClassName <HWPickerViewDelegate>

- (void)pickerView:(HWPickerView *)pickerView didSelectTitles:(NSArray*)titles

### Create PickView

    NSArray *list = [[NSArray alloc]initWithObjects:@"a", @"b", @"c", @"d", nil ];
    HWPickerView *picker = [[HWPickerView alloc] initWithTitle:@"title"  delegate:self];
    [picker setTag:TAG_PICKER];
    [picker setTitlesForComponenets:[NSArray arrayWithObjects:
                                     list,
                                     nil]];
    [picker showOnTop];

### preview
![參考圖](https://dl.dropboxusercontent.com/u/10581994/github/HWPickerView.png)
  
