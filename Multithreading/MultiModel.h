//
//  MultiModel.h
//  Multithreading
//
//  Created by 田微微 on 16/6/16.
//  Copyright © 2016年 田微微. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MultiModel : NSObject

@property (nonatomic,strong) NSString *imagUrl;
@property (nonatomic,strong) NSData *imageData;
@property (nonatomic,assign) NSInteger index;

@end
