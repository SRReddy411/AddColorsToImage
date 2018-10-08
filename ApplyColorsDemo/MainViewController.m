//
//  ViewController.m
//  ApplyColorsDemo
//
//  Created by volive solutions on 08/10/18.
//  Copyright © 2018 volive solutions. All rights reserved.
//

#import "MainViewController.h"
#import "ApplyColorsDemo-Swift.h"

@interface MainViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,AddColorPhotoEditorDelegate>{
    UIImage *profile_pic;
    UIImagePickerController * picker_Profile_Pic;
    ViewController *applyColorsView;
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
-(void)viewWillAppear:(BOOL)animated{
    // UserDefaults.standard.set(imageView?.image, forKey: "applyColorImage")
    
    
    
}

//MARK:- ADD PHOTO ACTION
- (IBAction)addPhotoBtnAction:(id)sender {
    
    UIAlertController * view=   [UIAlertController alertControllerWithTitle:@"Pick The Image" message:@"From" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* PhotoLibrary = [UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        self->picker_Profile_Pic = [[UIImagePickerController alloc] init];
        self->picker_Profile_Pic.delegate = self;
        [self->picker_Profile_Pic setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:self->picker_Profile_Pic animated:YES completion:NULL];
        
        [view dismissViewControllerAnimated:YES completion:nil];    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {  }];
    
    
    UIAlertAction* camera = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        self->picker_Profile_Pic = [[UIImagePickerController alloc] init];
        self->picker_Profile_Pic.delegate = self;
        [self->picker_Profile_Pic setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:self->picker_Profile_Pic animated:YES completion:NULL];
        [view dismissViewControllerAnimated:YES completion:nil];   }];
    
    
    [view addAction:PhotoLibrary];
    [view addAction:camera];
    [view addAction:cancel];
    [self presentViewController:view animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *original = [info objectForKey:UIImagePickerControllerOriginalImage];
    _selectImageView.image = original;
    applyColorsView = [[ViewController alloc]init];
   ViewController *editor = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    editor.selectingImage = original;
    editor.photoEditorDelegate = self;
     [self.navigationController pushViewController:editor animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (void)imageEditedWithImage:(UIImage * _Nonnull)image {
    self.selectImageView.image = image;
}



@end
