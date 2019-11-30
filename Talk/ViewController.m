//
//  ViewController.m
//  Talk
//
//  Created by 홍수혁 on 2019/11/28.
//  Copyright © 2019 홍수혁. All rights reserved.
//

#import "ViewController.h"
#import "MyBubbleTableViewCell.h"
#import "YourBubbleTableViewCell.h"


@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewBottomMagin;
@property (weak, nonatomic) IBOutlet UIButton *postBtn;
@property (weak, nonatomic) IBOutlet UITextView *chatTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeight;
@property (strong, nonatomic) NSMutableArray *chatData;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.chatTableView.dataSource = self;
    self.chatTableView.delegate = self;
    self.chatTextView.delegate = self;
    
    self.chatData = [[NSMutableArray alloc] init];
    self.chatTextView.textContainer.lineBreakMode = NSLineBreakByCharWrapping;
    
    // Xib Cell Register
    [self.chatTableView registerNib:[UINib nibWithNibName:@"MyBubbleTableViewCell" bundle:nil] forCellReuseIdentifier:@"myBubbleCell"];
    [self.chatTableView registerNib:[UINib nibWithNibName:@"YourBubbleTableViewCell" bundle:nil] forCellReuseIdentifier:@"yourBubbleCell"];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // TableViewCell Dynamic
    self.chatTableView.rowHeight = UITableViewAutomaticDimension;
    
    // 줄 없애기
    self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Navigation Bar Color Change
    [self.view setBackgroundColor:[UIColor colorWithRed:137.0/255.0 green:223.0/255.0 blue:245.0/255.0 alpha:1]];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    [self.view addGestureRecognizer:tapGesture];
    [tapGesture addTarget:self action:@selector(tapGestureHandler:)];
    
}

- (void)tapGestureHandler:(UITapGestureRecognizer *)gesture {
    UIView* view = gesture.view;
    CGPoint loc = [gesture locationInView:view];
    UIView* subview = [view hitTest:loc withEvent:nil];
    
    if ([subview isEqual:self.chatTableView] || [subview isKindOfClass:UITableViewCell.class]) {
        [self.chatTextView resignFirstResponder];
    }
}

// Observer Unlock
- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//
//    if ([text isEqualToString:@"\n"]) {
//        return NO;
//    }
//
//    return YES;
//}

- (IBAction)textInputDone:(id)sender {
    if (self.chatTextView.hasText) {
        [self.chatData addObject:self.chatTextView.text];
        [self.chatTableView reloadData];
        self.chatTextView.text = @"";
        
        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:self.chatData.count -1 inSection:0];
        
        [self.view layoutIfNeeded];
        
        [self.chatTableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        
        [self textViewDidChange:self.chatTextView];
    }
};

- (void)textViewDidChange:(UITextView *)textView {
    
    NSLog(@"textView height %f", textView.contentSize.height); // 텍스트뷰 사이즈 가져오기
    if (textView.contentSize.height <= 98) { // 98보다 작거나 같으면 true
        self.textViewHeight.constant = textView.contentSize.height;
        [textView setContentOffset:CGPointZero animated:NO];
        
    }
    
    
    [self.view layoutIfNeeded];
}


- (void)keyboardWillShow:(NSNotification *)noti {
    NSDictionary *notiInfo = noti.userInfo; // Keyboard Info List
    NSValue *keyFrame = [notiInfo valueForKey:UIKeyboardFrameEndUserInfoKey]; // KeyboardFrame Get
    CGRect keyboardFrame = keyFrame.CGRectValue;
    CGFloat height = keyboardFrame.size.height;
    
    NSTimeInterval animationDuration = [[notiInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]; // Info Get
    [UIView animateWithDuration:animationDuration animations:^{
        self.inputViewBottomMagin.constant = height;
        [self.view layoutIfNeeded];

    }];
};

- (void)keyboardWillHide:(NSNotification *)noti {
    NSDictionary *notiInfo = noti.userInfo; // Keyboard Info List
    NSTimeInterval animationDuration = [[notiInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]; // Info Get
    [UIView animateWithDuration:animationDuration animations:^{
        self.inputViewBottomMagin.constant = 0;
        [self.view layoutIfNeeded];
    }];
};

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chatData.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // TableViewCell Dynamic
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *defualtCell;
    if (indexPath.row % 2 == 1) {
        MyBubbleTableViewCell *cell = (MyBubbleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"myBubbleCell" forIndexPath:indexPath];
        
        cell.textBody.text = self.chatData[indexPath.row];
        
        defualtCell = cell;
    } else {
        YourBubbleTableViewCell *cell = (YourBubbleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"yourBubbleCell" forIndexPath:indexPath];
        cell.textBody.text = self.chatData[indexPath.row];
        defualtCell = cell;
    }
    
    defualtCell.selectionStyle = UITableViewCellSelectionStyleNone; // 선택시 회색 줄 안 보이게
    
    return defualtCell;
}

// Function to change the color of the TableView full screen
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor colorWithRed:137.0/255.0 green:223.0/255.0 blue:245.0/255.0 alpha:1];
    self.chatTableView.backgroundColor = [UIColor colorWithRed:137.0/255.0 green:223.0/255.0 blue:245.0/255.0 alpha:1];
}

@end
