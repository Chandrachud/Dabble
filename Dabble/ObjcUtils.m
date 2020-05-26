//
//  ObjcUtils.m
//  
//
//  Created by Reddy on 7/27/15.
//
//

#import "ObjcUtils.h"
#import "Dabble-Swift.h"

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation ObjcUtils

+(BOOL)isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}


+ (BOOL) textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string {
    
    // All digits entered
    if (range.location == 19)
    {
        return NO;
    }
    
    // Reject appending non-digit characters
    if (range.length == 0 &&
        ![[NSCharacterSet decimalDigitCharacterSet] characterIsMember:[string characterAtIndex:0]]) {
        return NO;
    }
    
    // Auto-add hyphen before appending 4rd or 7th digit
    if (range.length == 0 &&
        (range.location == 4 || range.location == 9 || range.location == 14||range.location == 19 )) {
        textField.text = [NSString stringWithFormat:@"%@ %@", textField.text, string];
        return NO;
    }
    
    // Delete hyphen when deleting its trailing digit
    if (range.length == 1 &&
        (range.location == 4 || range.location == 8))  {
        range.location--;
        range.length = 2;
        textField.text = [textField.text stringByReplacingCharactersInRange:range withString:@""];
        return NO;
    }
    return YES;
}

+(void)getDataForURL:(NSURL*)url atFile:(NSString*)filePath withInstance:(id)instance
{
    ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
   __block NSData *data = nil;

    [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset)
     {
         ALAssetRepresentation *rep = [asset defaultRepresentation];
         Byte *buffer = (Byte*)malloc(rep.size);
         NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:rep.size error:nil];
        data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
         [instance successForDataCalled:data];
         //this is NSData may be what you want
         [data writeToFile:filePath atomically:YES];
     }
                 failureBlock:^(NSError *err) {
                     NSLog(@"Error: %@",[err localizedDescription]);
                 }];
}

+ (NSString*)getFormattedDeviceToken:(NSData*)newDeviceToken
{
    return [[[[newDeviceToken description]
            stringByReplacingOccurrencesOfString: @"<" withString: @""]
           stringByReplacingOccurrencesOfString: @">" withString: @""]
          stringByReplacingOccurrencesOfString: @" " withString: @""];
}


+ (NSData*)getDataForAsset:(ALAsset*)asset
{
    ALAssetRepresentation *rep = [asset defaultRepresentation];
    Byte *buffer = (Byte*)malloc((NSUInteger)rep.size);
    NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:(NSUInteger)rep.size error:nil];
    NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
    return data;
}

+(NSString*) formatPhoneNumber:(NSString*) simpleNumber deleteLastChar:(BOOL)deleteLastChar {
    if(simpleNumber.length==0) return @"";
    // use regex to remove non-digits(including spaces) so we are left with just the numbers
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[\\s-\\(\\)]" options:NSRegularExpressionCaseInsensitive error:&error];
    simpleNumber = [regex stringByReplacingMatchesInString:simpleNumber options:0 range:NSMakeRange(0, [simpleNumber length]) withTemplate:@""];
    
    // check if the number is to long
    if(simpleNumber.length>10) {
        // remove last extra chars.
        simpleNumber = [simpleNumber substringToIndex:10];
    }
    
    if(deleteLastChar) {
        // should we delete the last digit?
        simpleNumber = [simpleNumber substringToIndex:[simpleNumber length] - 1];
    }
    
    // 123 456 7890
    // format the number.. if it's less then 7 digits.. then use this regex.
    if(simpleNumber.length<7)
        simpleNumber = [simpleNumber stringByReplacingOccurrencesOfString:@"(\\d{3})(\\d+)"
                                                               withString:@"($1) $2"
                                                                  options:NSRegularExpressionSearch
                                                                    range:NSMakeRange(0, [simpleNumber length])];
    
    else   // else do this one..
        simpleNumber = [simpleNumber stringByReplacingOccurrencesOfString:@"(\\d{3})(\\d{3})(\\d+)"
                                                               withString:@"($1) $2-$3"
                                                                  options:NSRegularExpressionSearch
                                                                    range:NSMakeRange(0, [simpleNumber length])];
    return simpleNumber;
}


+(void)setMaskTo:(UIView*)view byRoundingCorners:(UIRectCorner)corners
{
//    UIBezierPath *rounded = [UIBezierPath bezierPathWithRoundedRect:view.bounds
//                                                  byRoundingCorners:corners
//                                                        cornerRadii:CGSizeMake(3.0,3.0)];
//    CAShapeLayer *shape = [[CAShapeLayer alloc] init];
//    [shape setPath:rounded.CGPath];
//    view.layer.mask = shape;
//    view.layer.borderColor = [UIColor colorWithRed:0.3/255.0 green:97.0/255.0 blue:203.0/255.0 alpha:1.0].CGColor;

    view.layer.cornerRadius = 3.0;
    view.layer.borderColor = [UIColor colorWithRed:0.3/255.0 green:97.0/255.0 blue:203.0/255.0 alpha:1.0].CGColor;
    view.layer.borderWidth = 1.0;
}

+ (NSURL*)getFileUrlForURL:(NSString*)urlString
{
    NSURL *uploadURL = [NSURL fileURLWithPath:[[NSTemporaryDirectory() stringByAppendingPathComponent:@"test"] stringByAppendingString:@".mp4"]];
    
    AVAsset *asset      = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:urlString] options:nil];
    AVAssetExportSession *session =
    [AVAssetExportSession exportSessionWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
    
    session.outputFileType  = AVFileTypeQuickTimeMovie;
    session.outputURL       = uploadURL;
    
    [session exportAsynchronouslyWithCompletionHandler:^{
        
        if (session.status == AVAssetExportSessionStatusCompleted)
        {
            DLog(@"output Video URL %@",uploadURL);
            DLog(@"1-----------");
//            return uploadURL;            
        }
        else
        {
//            return uploadURL;
            DLog(@"2-----------");
            DLog(@"output Video URL %@",uploadURL);
        }
    }];
    DLog(@"3-----------");
    return uploadURL;
}


+(NSDate *) toLocalTime:(NSDate*)date
{
    NSTimeZone *tz = [NSTimeZone localTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate:date];
    return [NSDate dateWithTimeInterval: seconds sinceDate: date];
}

+(NSDate *) toGlobalTime:(NSDate*)date
{
    return date;
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = -[tz secondsFromGMTForDate: date];
    return [NSDate dateWithTimeInterval: seconds sinceDate: date];
}

@end
