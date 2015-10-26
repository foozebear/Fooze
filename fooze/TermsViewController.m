//
//  TermsViewController.m
//  Fooze
//
//  Created by Alex Russell on 5/29/15.
//  Copyright (c) 2015 alexrussell. All rights reserved.
//

#import "TermsViewController.h"
#import "Flurry.h"

@interface TermsViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation TermsViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"terms" ofType:@"html"];
    NSData *htmlData = [NSData dataWithContentsOfFile:htmlFile];
    [self.webView loadData:htmlData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]] ];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: @"Terms", @"Page", nil];
    [Flurry logEvent:@"Settings" withParameters:params];
}

- (void)viewDidLayoutSubviews
{

}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//-(void)makeTextViewFAQ
//{
//    CGRect frame = CGRectMake(self.view.frame.origin.x + .1 *self.view.frame.size.width, self.view.frame.origin.y + .2 * self.view.frame.size.height, self.view.frame.size.width *.8, self.view.frame.size.height *.7);
//    UITextView *textView = [[UITextView alloc]initWithFrame:frame];
//    [textView setFont:[UIFont fontWithName:@"Gotham-Medium" size:20]];
//    textView.backgroundColor = [UIColor colorWithRed:0.988 green:0.851 blue:0.129 alpha:1];
//    textView.tintColor = [UIColor whiteColor];
//    textView.textColor = [UIColor colorWithRed:0.106 green:0.078 blue:0.392 alpha:1];
//    textView.editable = NO;
//
//    [textView insertText:@"How does Fooze work?\n\n"];
//    [textView insertText:@"Every night, we will offer three munchies from great restaurants. Just tap the button to order, and your food is on its way. Our menu changes daily so you can sample the best late night food at an affordable price.\n\n"];
//    [textView insertText:@"How are you different from Seamless?\n\n"];
//    [textView insertText:@"With Fooze, you can get late night food delivered with just one tap, instead of sorting through numerous options. Our menu is restricted to quality and affordable restaurants, and rotates nightly to feature the best munchies in New York City. We offer faster delivery times and allow customers to order delivery later than most restaurants can provide now.\n\n"];
//    [textView insertText:@"What are your hours?\n\n"];
//    [textView insertText:@"We currently deliver between 10pm-2am every night. We plan on expanding our hours over the summer.\n\n"];
//    [textView insertText:@"Is it always a flat $15?\n\n"];
//    [textView insertText:@"Pricing is always a flat $15, which includes tip, tax, delivery fee, and your delicious munchie.\n\n"];
//    [textView insertText:@"How does tipping work?\n\n"];
//    [textView insertText:@"Tipping and tax is included in the price of food for this promotion. (Courier may accept cash tips if you have received excellent service.)\n\n"];
//    [textView insertText:@"Where do you deliver to?\n\n"];
//    [textView insertText:@"Right now we currently service Manhattan only, zip codes 10014, 10012, 10011, 10010, 10003, and 10009. This is approximately the zone between Houston St and 28th St from East to West. We plan on expanding our delivery zone throughout the summer.\n\n"];
//    [textView insertText:@"What’s the expected delivery window?\n\n"];
//    [textView insertText:@"Most customers can expect to receive your munchies in as little as 20 minutes. Our couriers will update you at each stage of the delivery route.\n\n"];
//    [textView insertText:@"Does Fooze only deliver to my primary address?\n\n"];
//    [textView insertText:@"When you initially onboard, you will set your default delivery address, but you can always change your delivery address via the settings tab by clicking on the gear icon on our home screen.\n\n"];
//    [textView insertText:@"How do you choose the restaurants?\n\n"];
//    [textView insertText:@"We focus on restaurants that provide high quality and affordable food late at night. We will be integrating customer demands for restaurant and menu choices as we expand operations.\n\n"];
//    [textView insertText:@"What if I don’t like tonight’s munchies?\n\n"];
//    [textView insertText:@"Our late night munchies change nightly. Leave a comment in the comment box if you have specific munchies you would like to see in Fooze.\n\n"];
//    [textView insertText:@"Can I order menu items besides the three listed tonight?\n\n"];
//    [textView insertText:@"We only offer three items nightly, but choices change every 24 hours. Check our menu selection every night to see what’s cooking.\n\n"];
//    [textView insertText:@"Can I edit an order after it has been submitted?\n\n"];
//    [textView insertText:@"Unfortunately, we don’t currently permit modifications or substitutions after orders have been placed. Our meals are carefully curated to offer the maximum amount of value and deliciousness.\n\n"];
//    [textView insertText:@"How do I update my delivery address, contact, or payment info?\n\n"];
//    [textView insertText:@"You can edit your delivery address, contact info, and payment info in our settings tab by clicking on the gear icon on our home screen.\n\n"];
//    [textView insertText:@"It's past my estimated delivery time, what do I do?\n\n"];
//    [textView insertText:@"We track each delivery to ensure the fastest service possible. If your order is delayed for more than 10 minutes without explanation, please contact customer service at 646-883-6693.\n\n"];
//    [textView insertText:@"What if I’m vegetarian?\n\n"];
//    [textView insertText:@"We do our best to accommodate a wide variety of tastes and dietary needs on our rotating menu. Vegetarian options are marked with our vegetable symbol. Check back every day to see the night’s options.\n\n"];
//    [textView insertText:@"What devices does Fooze support?\n\n"];
//    [textView insertText:@"You can use Fooze if you have an iOS device. We are coming to Android later this summer.\n\n"];
//    
//    /*
//    [textView insertText:@"Can I order for a friend?\n\n"];
//    [textView insertText:@"Currently, Fooze is an individual ordering platform. Your friend will have to download Fooze on his/her mobile phone. You can send them your unique referral URL, and receive a $15 credit when your friend orders.\n\n"];
//    [textView insertText:@"What is the Referral Program?\n\n"];
//    [textView insertText:@"When one of your friends orders through Fooze with your unique referral URL, you receive one free munchie!\n\n"];
//
//    [textView insertText:@"How do I refer people?\n\n"];
//    [textView insertText:@"You can easily share your unique referral URL via email, text, or on any social media platform right from our app.\n\n"];
//    
//    [textView insertText:@"How much can I earn?\n\n"];
//    [textView insertText:@"You will earn one free munchie the first time your unique ordering URL is used. For this promotion, subsequent uses do not accumulate additional credits.\n\n\n"];
//    
//    [textView insertText:@"Does the credit expire? Are there any other terms and conditions?\n\n"];
//    [textView insertText:@"Your free munchie expires after 30 days, so be sure to order before then!\n\n"];
//    
//    [textView insertText:@"Does my friend need to order a certain amount of food for me to get the referral credit?\n\n"];
//    [textView insertText:@"Nope! Your friend just needs to order their first munchie, which is always priced at $15.\n\n"];
//     */
//    
//
//
//
//    
//    [self.view addSubview:textView];
//
//}
//
//-(void)makeTextViewTerms
//{
//    
//    [self makeTermsLabel];
//    
//    CGRect frame = CGRectMake(self.view.frame.origin.x + .1 *self.view.frame.size.width, self.view.frame.origin.y + .2 * self.view.frame.size.height, self.view.frame.size.width *.8, self.view.frame.size.height *.7);
//    UITextView *textView = [[UITextView alloc]initWithFrame:frame];
//    textView.backgroundColor = [UIColor colorWithRed:0.988 green:0.851 blue:0.129 alpha:1];
//    textView.tintColor = [UIColor whiteColor];
//    textView.textColor = [UIColor colorWithRed:0.106 green:0.078 blue:0.392 alpha:1];
//    textView.font = [UIFont systemFontOfSize:17];
//    textView.editable = NO;
//    [textView setFont:[UIFont fontWithName:@"Gotham-Medium" size:20]];
//
//    [textView insertText:@"Policies and Terms of Service\n\n"];
//    [textView insertText:@"Missed Orders\n\n"];
//    [textView insertText:@"Our couriers will try to contact you upon arrival, either in-person, by phone, text, and/or email. If we cannot get in touch with you after 5 minutes, your order will be forfeited. No refunds may be issued once our courier is reassigned to their next order.\n\n"];
//    [textView insertText:@"Incorrect Delivery or Order\n\n"];
//    [textView insertText:@"If there was a mistake with your order or delivery, send us an email at info@foozeapp.com detailing the issue so we can quickly find a resolution. We'll adjust the order for billing purposes, if needed, and will follow up with the restaurant and courier. We can only make adjustments within one week of your order date. After one week, the order is final. \n\n"];
//    [textView insertText:@"Please note, it is not Fooze’s policy to issue credits from Fooze for grievances regarding recipes, portions and/or pricing, as these are all factors that are determined by the restaurant’s chef and management staff. However, we can present your request to their staff and follow up with you with the restaurant's proposed solution, be it monetary or otherwise.\n\n"];
//    [textView insertText:@"Cancellations and Refund Eligibility\n\n"];
//    [textView insertText:@"Orders are received by the restaurant and prepared as soon as you tap the confirm button. Cancellations are subject to approval of the restaurant staff and dependent on whether or not the order has been started. If your meal is already in production, no refunds may be issued.\n\n"];
//    
//    
//    
//    
//    
//    
//    [self.view addSubview:textView];
//    
//}
//
//-(void)makeTermsLabel
//{
//    CGRect labelFrame = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height/5);
//    UILabel *label = [[UILabel alloc]initWithFrame:labelFrame];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.text = @"Terms";
//    
//    label.textColor = [UIColor colorWithRed:0.941 green:0.341 blue:0.169 alpha:1.0];
//    [label setFont:[UIFont fontWithName:@"Luckiest Guy" size:42]];
//   
//    [self.view addSubview:label];
//}
//- (void)makeBackButton{
//    
//    
//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [backButton addTarget:self
//                   action:@selector(back:)
//         forControlEvents:UIControlEventTouchUpInside];
//    backButton.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + self.view.frame.size.width/10, self.view.frame.size.width/10, self.view.frame.size.width/10);
//    [backButton setTintColor:[UIColor colorWithRed:0 green:0.655 blue:0.655 alpha:1.0]];
//    [backButton setTitle:@"<" forState:UIControlStateNormal];
//    
//    [self.view addSubview:backButton];
//    
//    
//    
//    
//}


@end
