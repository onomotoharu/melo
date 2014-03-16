//
//  MLImageUploadViewController.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/16.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLImageUploadController.h"

#import "MLIndicator.h"

@interface MLImageUploadController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation MLImageUploadController

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)dealloc {
    NNLog(@"dealloc")
}

- (void)showActionSheet {
    UIActionSheet *actionSheet =[[UIActionSheet alloc]
                                 initWithTitle:@"画像を選択してください"
                                 delegate:self
                                 cancelButtonTitle:@"Cancel"
                                 destructiveButtonTitle:nil
                                 otherButtonTitles:@"カメラで写真を撮る", @"ギャラリーから選ぶ", nil];
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [actionSheet showInView:[MLGetAppDelegate window]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self showCamera];
            break;
        case 1:
            [self showlibrary];
            break;
        default:
            break;
    }
}

- (void)showCamera {
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ModalViewControllerShow" object:nil];
		UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
		[imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
		[imagePickerController setAllowsEditing:YES];
		[imagePickerController setDelegate:self];
		[[[MLGetAppDelegate window] rootViewController] presentViewController:imagePickerController animated:YES completion:nil];
	}
	else
	{
//        [CLAlert showAlert:@"使用中の端末ではカメラ機能が使えません"];
//        [self removeFromSuperview];
	}
}

- (void)showlibrary {
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ModalViewControllerShow" object:nil];
		UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
		[imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
		[imagePickerController setAllowsEditing:YES];
		[imagePickerController setDelegate:self];
        [[[MLGetAppDelegate window] rootViewController] presentViewController:imagePickerController animated:YES completion:nil];
	}
	else
	{
//        [CLAlert showAlert:@"使用中の端末ではギャラリーが使えません"];
//        [self removeFromSuperview];
	}
}

// ================================================================================
#pragma mark - imagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo {
    if (_delegate && [_delegate respondsToSelector:@selector(selectedImage:image:)]) {
        [_delegate selectedImage:self image:image];
    }
    
//    [MLIndicator show:nil];
    
//    NSData* imageData = UIImageJPEGRepresentation(image, 1.0);
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
