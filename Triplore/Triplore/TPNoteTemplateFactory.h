//
//  TPNoteTemplateFactory.h
//  Triplore
//
//  Created by 宋 奎熹 on 2017/6/15.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPNoteTemplate.h"

@interface TPNoteTemplateFactory : NSObject

+ (TPNoteTemplate *)getTemplateOfNum:(TPNoteTemplateNumber)number;

@end
