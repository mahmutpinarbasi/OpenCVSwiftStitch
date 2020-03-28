//
//  UIImage+Resize.h
//  SwiftStitch
//
//  Created by Mahmut Pinarbasi on 28.03.2020.
//  Copyright © 2020 Mahmut Pinarbasi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Resize)

- (UIImage *)convertToSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
