//
//  ViewController.m
//  SimpleLogger
//
//  Created by boob on 2017/6/16.
//  Copyright © 2017年 YY.COM. All rights reserved.
//

#import "ViewController.h"
#import "HBLoggerDefines.h"

#ifdef DEBUG
#define NSLog(...)  logDebug(__VA_ARGS__);
//#define NSLog(...) NSLog(__VA_ARGS__);
#define NSLogMethod NSLog(@"🔴类名与方法名：%s（在第%d行），描述：%@", __PRETTY_FUNCTION__, __LINE__, NSStringFromClass([self class]));
#else
#  define NSLog(...) ;
#  define NSLogMethod ;
#endif

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *txtlog;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    NSLog(@"test nslog~~~");
}

- (IBAction)writelog:(id)sender {

    logDebug(@"logdebug hello world");
    
    logInfo(@"log info hello world");
    
    logWarn(@"log hello world");
}

- (IBAction)readlog:(id)sender {
    
    NSString * filepath = [HBLogger sharedLogger].currentLogFilePath;
    NSString * str = [NSString stringWithContentsOfURL:[NSURL fileURLWithPath:filepath] encoding:NSUTF8StringEncoding error:nil];
    self.txtlog.text = str;

}
- (IBAction)removelog:(id)sender {
    
    [[HBLogger sharedLogger] remove7dayAgoLogfile];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
