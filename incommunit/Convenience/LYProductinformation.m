//
//  LYProductinformation.m
//  incommunit
//  商品信息
//  Created by LANGYI on 14/10/29.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "LYProductinformation.h"
#import "CustomToolbarItem.h"
#import "AppDelegate.h"
#import "StoreOnlineNetworkEngine.h"
#import "LYSqllite.h"
#import "UIImageView+AsyncDownload.h"
@interface InfoView : UIView

@end

@implementation InfoView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    
    CGFloat lineWidth = 0.25f;
    // Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, lineWidth);
    
    CGContextMoveToPoint(context, 0.0f, 0); //start at this point
    
    CGContextAddLineToPoint(context, CGRectGetWidth(rect), 0); //draw to this point
    
    // and now draw the Path!
    CGContextStrokePath(context);
}

@end

@interface LYProductinformation ()
@property (weak, nonatomic) IBOutlet UIView *desContainerView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *page;
@property (weak, nonatomic) IBOutlet UIScrollView *imageViewScroll;

@end

@implementation LYProductinformation
@synthesize m_iamgeview,m_GoodsName,m_Introduction,m_Price,m_textField,m_ProductDetails,m_Imagescrillview;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.oreginPrice.hidden = YES;
    
    NSThread *myThread01 = [[NSThread alloc] initWithTarget:self
                                                   selector:@selector(GetProductDetails:)
                                                     object:self];
    [myThread01 start];
    
    
    UIBarButtonItem *homePage = [self createCustomItem:@"首页" imageName:@"首页" selector:@selector(jumpToPage:) tag:100];
    UIBarButtonItem *persionalPage = [self createCustomItem:@"个人主页" imageName:@"2" selector:@selector(jumpToPage:) tag:101];
    UIBarButtonItem *shoppingCartPage = [self createCustomItem:@"购物车" imageName:@"购物车" selector:@selector(jumpToPage:) tag:102];
    UIBarButtonItem *orderPage = [self createCustomItem:@"我的订单" imageName:@"订单" selector:@selector(jumpToPage:) tag:103];
    NSArray *array = [NSArray arrayWithObjects:
                      [self createFixableItem:17]
                      ,homePage
                      ,[self createFixableItem:0]
                      ,persionalPage
                      ,[self createFixableItem:0]
                      ,shoppingCartPage
                      ,[self createFixableItem:0]
                      ,orderPage
                      ,[self createFixableItem:17]
                      ,nil];
    [self setToolbarItems:array animated:YES];
    
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickView)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [self.view addGestureRecognizer:singleRecognizer];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setToolbarHidden:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setToolbarHidden:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (UIBarButtonItem *)createFixableItem:(NSInteger)width {
    UIBarButtonItem *item = nil;
    UIBarButtonSystemItem type = UIBarButtonSystemItemFlexibleSpace;
    if (width > 0) {
        type = UIBarButtonSystemItemFixedSpace;
    }
    item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:type target:nil action:nil];
    item.width = width;
    return item;
}

- (UIBarButtonItem *)createCustomItem:(NSString *)title imageName:(NSString *)imageName selector:(SEL)selector tag:(NSInteger)tag {
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"CustomToolbarItem" owner:self options:nil];
    CustomToolbarItem *customItem = [nibViews objectAtIndex:0];
    customItem.tag = tag;
    customItem.autoresizingMask = UIViewAutoresizingNone;
    [customItem setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [customItem setTitle:title forState:UIControlStateNormal];
    [customItem addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:customItem];
    return item;
}

-(void)ClickView
{
    [m_textField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/*
 #pragma mark - Navigation
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark - 获取网络数据
-(void)GetProductDetails:(LYProductinformation *)obj
{
    NSDictionary *dic = @{@"id" : m_GoodsID };
    [[StoreOnlineNetworkEngine shareInstance] startNetWorkWithPath:@"services/shop/commodity_detail"
                                                            params:dic
                                                            repeat:YES
                                                             isGet:YES
                                                       resultBlock:^(BOOL bValidJSON, NSString *errorMsg, id result) {
                                                           if(!bValidJSON)
                                                           {
                                                           }else
                                                           {
                                                               m_goodsinfo = result;
                                                               [m_goodlis addObject:result];
                                                               [self Updata:result];
                                                           }}];
}

- (IBAction)addShopingCart:(id)sender
{
    NSDictionary *userInfo = [LYSqllite Ruser];
    if (!userInfo || [[userInfo objectForKey:@"auth_status"] isEqualToString:@"-2"]) {
        UIAlertView *alview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你当前是游客，不能使用该功能？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alview show];
        
        return;
    }
    [LYSqllite addShoppingcart:m_goodsinfo number: m_textField.text StoresID:m_Storesid Storesname:[m_storeinfo objectForKey:@"name"] selectState:@"0"];
    UIAlertView *m_addshopcatalert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"成功将商品加入了购物车" delegate:self cancelButtonTitle:@"继续购物" otherButtonTitles:@"去购物车结算", nil];
    [m_addshopcatalert show];
}

-(IBAction)SetChan
{
    if ([[[NSString alloc]initWithFormat:@"%@",[m_ProductDetails objectForKey:@"isLike"]]isEqual:@"1"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你已经赞过该商品" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消赞", nil];
        [alert show];
    }else
    {
        NSDictionary *dic = @{@"id" : m_GoodsID };
        [[StoreOnlineNetworkEngine shareInstance] startNetWorkWithPath:@"services/shop/commodity_like"
                                                                params:dic
                                                                repeat:YES
                                                                 isGet:YES
                                                           resultBlock:^(BOOL bValidJSON, NSString *errorMsg, id result) {
                                                               if(!bValidJSON)
                                                               {
                                                                   UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                                                    message:errorMsg
                                                                                                                   delegate:self
                                                                                                          cancelButtonTitle:@"确定"
                                                                                                          otherButtonTitles:nil, nil];
                                                                    [alert show];
                                                               }else
                                                               {
//                                                                   int test =result;
                                                                   
                                                               }}];
        
    }
}

//刷新数据
-(void)Updata:(NSDictionary *)dic
{
    if(dic!=nil)
    {
        // 商品名
        m_GoodsName.text = [dic objectForKey:@"name"];
        
        // 商品价格
        NSNumber *priceNumber = [dic objectForKey:@"price"];
        if (!priceNumber) {
            priceNumber = [NSNumber numberWithFloat:0];
        }
        NSString *priceString = [NSString stringWithFormat:@"￥%.2f", [priceNumber floatValue]];
        NSMutableAttributedString *priceAttiString = [[NSMutableAttributedString alloc] initWithString:priceString];
        [priceAttiString addAttribute:NSForegroundColorAttributeName value:SPECIAL_RED range:NSMakeRange(0, priceAttiString.length)];
        [priceAttiString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 1)];
        [priceAttiString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:27] range:NSMakeRange(1, priceAttiString.length - 1)];
        [m_Price setAttributedText:priceAttiString];
        
        NSString *oreginPriceString = priceString;
        self.oreginPrice.hidden = !oreginPriceString;
        [self.oreginPrice setText:oreginPriceString];
        
        CGFloat width = [self labelWidth:self.oreginPrice];
        CGRect rect = self.oreginPrice.bounds;
        rect.size.width = width;
        self.oreginPrice.bounds = rect;
        
        [self repos];
        
        // 商品描述
        NSString *desString = [dic objectForKey:@"description"];
        desString = desString ? desString : @"";
        NSMutableAttributedString *desAttrString = [[NSMutableAttributedString alloc] initWithString:desString];
        if ([desString length]) {
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
            style.alignment = NSTextAlignmentLeft;
            style.firstLineHeadIndent = 26;
            [desAttrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, desAttrString.length)];
            [desAttrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, desAttrString.length)];
            [desAttrString addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, desAttrString.length)];
        }
        [m_Introduction setAttributedText:desAttrString];
        
        // 变更控件size
        CGFloat height =[self heightOfLabel:@[desString] size:CGSizeMake(CGRectGetWidth(m_Introduction.frame), CGFLOAT_MAX) font:[UIFont systemFontOfSize:13]];
        
        rect = m_Introduction.frame;
        rect.size.height = height;
        m_Introduction.frame = rect;
        
        rect = self.desContainerView.frame;
        rect.size.height = CGRectGetMaxY(m_Introduction.frame) + 50;
        self.desContainerView.frame = rect;
        
        CGSize contentSize = CGSizeMake(0, CGRectGetMaxY(self.desContainerView.frame));
        [self.scrollView setContentSize:contentSize];
        
        NSMutableArray * temp = [m_goodsinfo objectForKey:@"images"];
        self.page.numberOfPages =temp.count;
        self.page.currentPage = 0;
        
        
        
        m_Imagescrillview.contentSize = CGSizeMake(temp.count * self.m_Imagescrillview.frame.size.width,0);
        m_Imagescrillview.pagingEnabled = YES;
        m_Imagescrillview.showsHorizontalScrollIndicator = NO;
        for (int i = 0; i < temp.count; i++)
        {
            UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(i * self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
            NSString *imageUrl = [[temp objectAtIndex:i] objectForKey:@"path"];
            if (imageUrl!=nil && ![imageUrl isEqualToString:@""])
            {
                NSURL *url = [NSURL URLWithString:imageUrl];
                [image setImageWithURL:url placeholderImage:nil];
            }
            [m_Imagescrillview addSubview:image];
        }
    }
}

-(IBAction)add:(id)sender
{
    m_textField.text = [[NSString alloc]initWithFormat:@"%d",[m_textField.text intValue]+1];
}

-(IBAction)Less:(id)sender
{
    if([m_textField.text intValue]>0)
    {
        m_textField.text = [[NSString alloc]initWithFormat:@"%d",[m_textField.text intValue]-1];
    }
}

#pragma mark -
#pragma mark TextMethod

- (CGFloat)heightOfLabel:(NSArray *)textList size:(CGSize)size font:(UIFont *)font {
    int length = 0;
    CGFloat height = 0;
    for (NSString *text in textList) {
        length += (int)[self widthOfString:text withFont:font];
    }
    if (length > 0) {
        int count = (int)(length / size.width);
        height = (count + 1) * font.lineHeight;
    }
    return height;
}

//根据字号计算字符串的宽度
- (CGFloat)widthOfString:(NSString *)string withFont:(UIFont *)font {
    if (string.length == 0) {
        return 0;
    }
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width + 26;
}

- (void)repos {
    if (!self.oreginPrice.hidden) {
        CGFloat width = MIN([self widthOfString:self.m_Price.text withFont:self.m_Price.font], CGRectGetWidth(self.m_Price.frame));
        CGFloat x = CGRectGetMinX(self.m_Price.frame) + width + 10;
        CGRect rect = self.oreginPrice.frame;
        rect.origin.x = x;
        self.oreginPrice.frame = rect;
    }
}

- (CGFloat)labelWidth:(UILabel *)label {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:label.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGRect textBounds = [label.text boundingRectWithSize:label.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    return CGRectGetWidth(textBounds);
}

#pragma mark - 键盘处理
#pragma mark 键盘即将显示

- (void)keyBoardWillShow:(NSNotification *)note{
    
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (rect.origin.y >= self.view.frame.origin.y) {
        CGFloat ty = -rect.size.height;
        [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                         animations:^{
                             UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, -ty, 0);
                             [self.scrollView setContentInset:inset];
                             [self.scrollView setContentOffset:CGPointMake(0, CGRectGetMinY(m_textField.frame) - 50)];
                         }];
    }
}

#pragma mark 键盘即将退出

- (void)keyBoardWillHide:(NSNotification *)note{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                     animations:^{
                         [self.scrollView setContentInset:UIEdgeInsetsZero];
                     }];
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.imageViewScroll) {
        NSInteger index = lroundf(self.imageViewScroll.contentOffset.x / self.imageViewScroll.frame.size.width);
        self.page.currentPage = index;
    }
}

#pragma mark -
#pragma mark UItabBar 协议函数
- (void)jumpToPage:(CustomToolbarItem *)sender
{
    switch (sender.tag) {
        case 100:
            [self.navigationController popToRootViewControllerAnimated:YES];
            [self performSegueWithIdentifier:@"GoFunction" sender:self];
            break;
        case 101:
            [self performSegueWithIdentifier:@"GoPersonal" sender:self];
            break;
        case 102:
            [self performSegueWithIdentifier:@"Goshopcat" sender:self];
            break;
        case 103:
            [self performSegueWithIdentifier:@"GoMyOrder" sender:self];
            break;
        default:
            break;
    }
}

@end
