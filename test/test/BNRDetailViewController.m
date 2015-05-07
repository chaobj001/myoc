//
//  BNRDetailViewController.m
//  Homepwner_UITableView
//
//  Created by 王超 on 15-1-30.
//  Copyright (c) 2015年 sk80.com. All rights reserved.
//

#import "BNRDetailViewController.h"
#import "BNRItem.h"
#import "BNRChangeDateViewController.h"
#import "BNRImageStore.h"
#import "BNRCrosshairView.h"

@interface BNRDetailViewController () <UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

//声明插座变量
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialNumberField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
//声明一个图片删除按钮变量, 控制按钮显隐
@property (weak, nonatomic) IBOutlet UIBarButtonItem *delImageButton;


@end

@implementation BNRDetailViewController

//在视图展示之前操作
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //将BNRItem对象赋值给相应的UITextField
    BNRItem *item = self.item;
    
    self.nameField.text = item.itemName;
    self.serialNumberField.text = item.serialNumber;
    self.valueField.text = [NSString stringWithFormat:@"%d", item.valueInDollars];
    //创建NSDateFormatter对象，用于将NSDate对象转换成简单的日期字符串
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    //将转换后得到的日期字符串设置为dateLabel的标题
    self.dateLabel.text = [dateFormatter stringFromDate:item.dateCreated];
    
    //加入图片展示处理
    NSString *itemKey = self.item.itemKey;
    //根据itemKey, 从BNRImageStore对象获取照片
    UIImage *imageToDisplay = [[BNRImageStore shareStore] imageForKey:itemKey];
    if (imageToDisplay) {
        self.delImageButton.enabled = YES;
    } else {
        self.delImageButton.enabled = NO;
    }
    
    //将得到的照片赋给UIImageView对象
    self.imageView.image = imageToDisplay;
    
    //NSLog(@"%@", self.toolbar.items);
}

//在视图控制器BNRDetailViewController退出栈时
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //取消第一响应对象, 键盘会消失
    [self.view endEditing:YES];
    //将修改“保存”至BNRItem对象
    BNRItem *item = self.item;
    item.itemName = self.nameField.text;
    item.serialNumber = self.serialNumberField.text;
    item.valueInDollars = [self.valueField.text intValue];
}

- (void)setItem:(BNRItem *)item
{
    _item = item;
    self.navigationItem.title = _item.itemName;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.nameField resignFirstResponder];
    [self.serialNumberField resignFirstResponder];
    [self.valueField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)changeDate:(id)sender
{
    BNRChangeDateViewController *dateChangeViewController = [[BNRChangeDateViewController alloc] init];
    
    dateChangeViewController.item = self.item;
    
    [self.navigationController pushViewController:dateChangeViewController animated:YES];
}
#pragma mark - 拍照
//拍照方法实现
- (IBAction)takePicture:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    //如果设备支持相机，就是用拍照模式
    //否则让用户从照片库中选择照片
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        CGRect layFrame = CGRectMake(self.view.center.x - 25,
                                      self.view.center.y - 25,
                                      50,
                                      50);
        BNRCrosshairView *crosshair=[[BNRCrosshairView alloc]initWithFrame:layFrame];
        imagePicker.cameraOverlayView=crosshair;
        
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    //设置委托对象
    imagePicker.delegate = self;
    
    imagePicker.allowsEditing = YES;
    
    //以模态的形式显示UIImagePickerController对象
    [self presentViewController:imagePicker animated:YES completion:nil];
}
//UIImagePickerController对象选择了一张照片后
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //通过info字典获取选择的照片
    //UIImage *image = info[UIImagePickerControllerOriginalImage];
    UIImage *image = info[UIImagePickerControllerEditedImage];//打开编辑模式之后
    
    //以itemKey为键，将照片存入BNRImageStore对象
    [[BNRImageStore shareStore] setImage:image forKey:self.item.itemKey];
    
    //将照片放入UIImageView对象
    self.imageView.image = image;
    
    //关闭UIImagePickerController对象
    [self dismissViewControllerAnimated:YES completion:nil];
}
//用户取消选择照片
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 删除
//删除图片
- (IBAction)deleteImage:(id)sender
{
    self.imageView.image = nil;
    [[BNRImageStore shareStore] deleteImageForKey:self.item.itemKey];
    self.delImageButton.enabled = NO;
}




@end
