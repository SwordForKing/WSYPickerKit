//
//  LKPickerViewController.m
//  cltios
//
//  Created by zjlk32 on 2021/8/4.
//

#define LKSCREENWidth      MIN([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height) //旋转屏幕会出现差别
#define LKScreenHeight     MAX([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)

#import "LKPickerViewController.h"
#import "LKPickerAlertContentView.h"

@interface LKPickerViewController ()<LKWSYPickerDelegate,LKWSYPickerDataSource,UIGestureRecognizerDelegate>

@property(nonatomic,strong)UIView  *backView;

@property(nonatomic,strong)LKPickerBackView  *pickerView;

@property(nonatomic,strong)LKPickerAlertContentView  *alertView;

@property(nonatomic,assign)LKWSYPickerType   type;

@property(nonatomic,assign)LKWSYPickerStyleType   styleType;

@property(nonatomic,copy)NSString   *messgeTitle;

@property(nonatomic,assign)CGFloat   pickHeight;

@property(nonatomic,strong)UIView    *customView;

@end

@implementation LKPickerViewController

-(instancetype)init{
    if (self == [super init]) {
        _pickHeight = 240.0f;
        _type = LKWSYPickerType_picker;
    }
    return self;
}

-(instancetype)initWithTitle:(NSString *)title Message:(NSString *)message PickerStyle:(LKWSYPickerStyleType)pickerType {
    self = [super init];
    if (self) {
        _pickHeight = 240.0f;
        [self setStyleType:pickerType];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer  *tapGester = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dissmissTheCotnentView)];
    tapGester.delegate = self;
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self.view addSubview:self.backView];
    [self.backView addGestureRecognizer:tapGester];
    [self.backView addSubview:self.pickerView];
    [self.backView addSubview:self.alertView];
}
#pragma mark--UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isKindOfClass:[UIView class]]) {
        UIView * backView =  touch.view;
        if (backView.tag == 998) {
            return YES;
        }else{
            return NO;
        }
    }
    return NO;
}

-(void)dissmissTheCotnentView{
    if (_delegate &&[_delegate respondsToSelector:@selector(lkwsyWillDisApperar)]) {
        [_delegate lkwsyWillDisApperar];
    }
    [self pickerDownAnmation];
}

-(void)setMessgeTitle:(NSString *)messgeTitle{
    _messgeTitle = messgeTitle;
}

-(void)setDelegate:(id<LKWSYPickerDelegate>)delegate{
    _delegate = delegate;
    if (_delegate && [_delegate respondsToSelector:@selector(lkwsyPickerType)]) {
        _type = [_delegate lkwsyPickerType];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(lkwsyPickerStyleType)]) {
        _styleType = [_delegate lkwsyPickerStyleType];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(lkwsyPickerViewCustomBackContentView)]) {
        _customView = [_dataSource lkwsyPickerViewCustomBackContentView];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(lkwsyPickerHeight)]) {
        _pickHeight = [_dataSource lkwsyPickerHeight];
    }
}

-(UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LKSCREENWidth, LKScreenHeight)];
        _backView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.6];
        _backView.tag = 998;
    }
    return _backView;
}

-(LKPickerBackView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[LKPickerBackView alloc]initWithFrame:CGRectMake(0, LKScreenHeight,LKSCREENWidth ,_pickHeight)];
    }
    return _pickerView;
}

-(LKPickerAlertContentView *)alertView{
    if (!_alertView) {
        _alertView = [[LKPickerAlertContentView alloc]initWithFrame:CGRectMake(30, LKScreenHeight, LKSCREENWidth - 60,_pickHeight)];
        _alertView.bounds = CGRectMake(0, 0, LKSCREENWidth - 60, _pickHeight);
        _alertView.layer.masksToBounds = true;
        _alertView.layer.cornerRadius = 9.0f;
        _alertView.backgroundColor = [UIColor whiteColor];
    }
    return _alertView;
}
-(void)pickerDownAnmation{
    [self disApperThePickerAnimation];
}

-(void)setType:(LKWSYPickerType)type{
    _type = type;
}

-(void)setPickHeight:(CGFloat)pickHeight{
    _pickHeight = pickHeight;
}

-(void)setStyleType:(LKWSYPickerStyleType)styleType{
    _styleType = styleType;
    switch (_styleType) {
        case LKWSYPickerStyle_AlertCenter:
        {
            [self.pickerView removeFromSuperview];
            self.alertView.hidden = false;
        }
            break;
        case LKWSYPickerStyle_pickerSheet:{
            self.pickerView.hidden = false;
            [self.alertView removeFromSuperview];
        }
            break;
        case LKWSYPickerStyle_pickerCenter:
        {
            
        }
        default:
            break;
    }
}

-(void)addAction:(LKAlertAction *)action{
    if (_styleType == LKWSYPickerStyle_AlertCenter || _styleType == LKWSYPickerStyle_AlertSheet) {
        [self.alertView addActions:action];
    }
}

-(LKWSYPickerType)lkwsyPickerType{
      
    if (_delegate && [_delegate respondsToSelector:@selector(lkwsyPickerType)]) {
        _type = [_delegate lkwsyPickerType];
    }
    return _type;
}

-(LKWSYPickerStyleType)lkwsyPickerStyleType{
    if (_delegate && [_delegate respondsToSelector:@selector(lkwsyPickerStyleType)]) {
        return  [_delegate lkwsyPickerStyleType];
    }
    return LKWSYPickerStyle_pickerSheet;
}

-(UIView *)lkwsyPickerViewCustomBackContentView{
    _customView = [_dataSource lkwsyPickerViewCustomBackContentView];
    float sizeWith = _customView.frame.size.width;
    float sizeHeight = _customView.frame.size.height;
    self.pickerView.bounds = CGRectMake(0, 0, sizeWith, sizeHeight + 20);
    return _customView;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self ApperThePickerAnimation];
}

-(void)lkPickerViewWithDataArr:(NSArray *)dataArray SelectWithBlock:(void (^)(NSString * _Nonnull, NSInteger))block{
    [self.pickerView lkpickerViewWithData:[NSMutableArray arrayWithArray:dataArray] AndTheSelectedWithBlock:block];
}

//出现的动画
-(void)ApperThePickerAnimation{
    
    if (_delegate && [_delegate respondsToSelector:@selector(lkwsyPickerStyleType)]) {
        _styleType = [_delegate lkwsyPickerStyleType];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(lkwsyWillAppear)]) {
        [_delegate lkwsyWillAppear];
    }
    switch (_styleType) {
        case LKWSYPickerStyle_pickerSheet:
        {
            [UIView animateWithDuration:0.1 animations:^{
                self->_pickerView.frame = CGRectMake(0, LKScreenHeight - self->_pickHeight, LKSCREENWidth, self->_pickHeight);
            } completion:^(BOOL finished) {
                [self.pickerView.tableV reloadData];
                if (self->_delegate && [self->_delegate respondsToSelector:@selector(lkwsyDidAppear)]) {
                    [self->_delegate lkwsyDidAppear];
                }
            }];
        }
            break;
        case LKWSYPickerStyle_pickerCenter:
        {
            [UIView animateWithDuration:0.1 animations:^{
                self.pickerView.center = self.view.center;
            } completion:^(BOOL finished) {
                if (self->_delegate && [self->_delegate respondsToSelector:@selector(lkwsyDidAppear)]) {
                    [self->_delegate lkwsyDidAppear];
                }
            }];
        }
            break;
        case LKWSYPickerStyle_AlertCenter:
        {
            [UIView animateWithDuration:0.1 animations:^{
                self.alertView.center = self.view.center;
            } completion:^(BOOL finished) {
                if (self->_delegate && [self->_delegate respondsToSelector:@selector(lkwsyDidAppear)]) {
                    [self->_delegate lkwsyDidAppear];
                }
            }];
        }
            break;
      
        default:
            break;
    }
}


//消失动画
-(void)disApperThePickerAnimation{
    if (_delegate && [_delegate respondsToSelector:@selector(lkwsyPickerStyleType)]) {
        _styleType = [_delegate lkwsyPickerStyleType];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(lkwsyWillDisApperar)]) {
        [_delegate lkwsyWillDisApperar];
    }
    switch (_styleType) {
        case LKWSYPickerStyle_pickerSheet:
        {
            if (self.pickerView.frame.origin.y <= LKScreenHeight) {
                [UIView animateWithDuration:0.3 animations:^{
                    self.pickerView.frame = CGRectMake(0, LKScreenHeight,LKSCREENWidth ,self->_pickHeight);
                } completion:^(BOOL finished) {
                    if (self->_delegate && [self->_delegate respondsToSelector:@selector(lkwsyDidDisAppear)]) {
                        [self->_delegate lkwsyDidDisAppear];
                    }
                    [self dismissViewControllerAnimated:false completion:nil];
                }];
            }
        }
            break;
        case LKWSYPickerStyle_pickerCenter:
        {
            [UIView animateWithDuration:0.1 animations:^{
                float pickt = self.pickerView.frame.size.height;
                self.pickerView.center = CGPointMake(LKSCREENWidth/2, LKScreenHeight + pickt);
            } completion:^(BOOL finished) {
                if (self->_delegate && [self->_delegate respondsToSelector:@selector(lkwsyDidDisAppear)]) {
                    [self->_delegate lkwsyDidDisAppear];
                }
                [self dismissViewControllerAnimated:false completion:nil];
            }];
        }
            break;
        case LKWSYPickerStyle_AlertCenter:
        {
            [UIView animateWithDuration:0.1 animations:^{
                float pickt = self.alertView.frame.size.height;
                self.alertView.center = CGPointMake(LKSCREENWidth/2, LKScreenHeight + pickt);
            } completion:^(BOOL finished) {
                if (self->_delegate && [self->_delegate respondsToSelector:@selector(lkwsyDidDisAppear)]) {
                    [self->_delegate lkwsyDidDisAppear];
                }
                [self dismissViewControllerAnimated:false completion:nil];
            }];
        }
            break;
        default:
            break;
    }
}

@end
