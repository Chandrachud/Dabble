//
//  ObjcUtils.h
//  
//
//  Created by Reddy on 7/27/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
//#import "DBLServices.swift"

@interface ObjcUtils : NSObject
{
    
}
+(void)getDataForURL:(NSURL*)url atFile:(NSString*)filePath withInstance:(id)instance;
+(BOOL)isValidEmail:(NSString *)checkString;
+ (BOOL) textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
 replacementString:(NSString *)string;
+(NSString*) formatPhoneNumber:(NSString*) simpleNumber deleteLastChar:(BOOL)deleteLastChar;
+(void)setMaskTo:(UIView*)view byRoundingCorners:(UIRectCorner)corners;
+ (NSData*)getDataForAsset:(ALAsset*)asset;
+ (NSString*)getFormattedDeviceToken:(NSData*)deviceToken;
+ (NSURL*)getFileUrlForURL:(NSString*)urlString;

+(NSDate *) toLocalTime:(NSDate*)date;
+(NSDate *) toGlobalTime:(NSDate*)date;
@end
