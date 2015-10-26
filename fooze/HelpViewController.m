//
//  HelpViewController.m
//  Fooze
//
//  Created by Cris Padilla Tagle on 7/18/15.
//  Copyright (c) 2015 Fooze. All rights reserved.
//

#import "HelpViewController.h"
#import "Flurry.h"

@interface HelpViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"faq" ofType:@"html"];
    NSData *htmlData = [NSData dataWithContentsOfFile:htmlFile];
    [self.webView loadData:htmlData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]] ];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: @"FAQ", @"Page", nil];
    [Flurry logEvent:@"Settings" withParameters:params];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
