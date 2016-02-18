//
//  HHMacro.h
//  HeyHere
//
//  Created by 虞鸿礼 on 16/1/25.
//  Copyright © 2016年 baidu. All rights reserved.
//

#ifndef HHMacro_h
#define HHMacro_h

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define STATUSBAR_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height
#define NAVIGATIONBAR_HEIGHT 44.f

// Singleton
#define DEFINE_SINGLETON_FOR_HEADER(className) \
\
+(className* )shared##className;

#define DEFINE_SINGLETON_FOR_CLASS(className) \
\
+ (className *)shared##className { \
static className *shared##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
@synchronized(self){ \
shared##className = [[self alloc] init]; \
} \
}); \
return shared##className; \
}

// UIFont
#define SET_FONT(className,fontName,fontSize) [className setFont:[UIFont fontWithName:fontName size:fontSize]]

#endif /* HHMacro_h */
