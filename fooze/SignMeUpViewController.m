//
//  SignMeUpViewController.m
//  Fooze
//
//  Created by Cris Padilla Tagle on 7/1/15.
//  Copyright (c) 2015 Fooze. All rights reserved.
//

#import "SignMeUpViewController.h"
#import "Helper.h"

@interface SignMeUpViewController ()
@property (strong, nonatomic) IBOutlet UILabel *lblOrder;
@property (strong, nonatomic) IBOutlet UIView *vwSignMeUp;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation SignMeUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.lblOrder.text = [[NSString stringWithFormat:@"%@, %@",_menu.name,_menu.restaurant] capitalizedString];
    
    [self loadMenuText];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_vwSignMeUp setBackgroundColor:[UIColor foozeTurquoise]];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
//    if ([segue.identifier isEqualToString:@"segueToLogin"])
//    {
//        LogInViewController *vc = segue.destinationViewController;
//        vc.delegate = self;
//    }
}

- (IBAction)signMeUp:(id)sender
{
   [self performSegueWithIdentifier:@"segueToCreateAccount" sender:self]; 
}

- (IBAction)loginNow:(id)sender
{
    [self performSegueWithIdentifier:@"segueToLogin" sender:self];
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLayoutSubviews
{
     _vwSignMeUp.layer.cornerRadius = _vwSignMeUp.frame.size.height/10.;
}

- (IBAction)touchDown:(id)sender
{
    [_vwSignMeUp setBackgroundColor:[UIColor foozeYellow]];
}

- (void)loadMenuText
{
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    NSString *body = [[NSString stringWithFormat:@"<div id=\"food\"><p>%@:</br>%@</p>",_menu.restaurant, _menu.name] capitalizedString];
    NSString *message = @"<p></p><p></p><p>Getting Hungry?\n Munchies are always a flat price including tip, tax, delivery. What you see is what you get.</p>";
    
    NSString *css = @"<link href=\"fooze.css\" rel=\"stylesheet\" type=\"text/css\">";
    NSString *line1 = @"<body>";
    NSString *line2 = @"<div id=\"divcontainer\">";
    NSString *line3 = [NSString stringWithFormat:@"<h2><strong>%@</strong></h2>", body];
    NSString *line4 = [NSString stringWithFormat:@"<h3><strong>%@</strong></h3>", message];
    
    NSString *htmlString = [NSString stringWithFormat:@"%@%@%@%@%@", css, line1, line2, line3, line4];
    
    htmlString = [NSString stringWithFormat:@"%@", htmlString];
    
    NSString *line5 = @"</div>";
    NSString *line6 = @"</body>";
    
    htmlString = [NSString stringWithFormat:@"%@%@%@", htmlString, line5, line6];
    
    [self.webView loadHTMLString:htmlString baseURL:baseURL];
 
    
}

//#pragma mark -
//#pragma mark - LoginViewController
//
//- (void)continueToMain:(LogInViewController *)controller
//{
//  //  [self dismissViewControllerAnimated:YES completion:^{
//        [self.navigationController popViewControllerAnimated:YES];
//  //  }];
//}

@end
