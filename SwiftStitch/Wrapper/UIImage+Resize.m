//
//  UIImage+Resize.m
//  SwiftStitch
//
//  Created by Mahmut Pinarbasi on 28.03.2020.
//  Copyright © 2020 Mahmut Pinarbasi. All rights reserved.
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)

- (UIImage *)convertToSize:(CGSize)size {
    
    CGFloat scale = MAX(size.width/self.size.width, size.height/self.size.height);
    CGFloat width = self.size.width * scale;
    CGFloat height = self.size.height * scale;
    CGRect imageRect = CGRectMake((size.width - width)/2.0f,
                                  (size.height - height)/2.0f,
                                  width,
                                  height);

    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [self drawInRect:imageRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
