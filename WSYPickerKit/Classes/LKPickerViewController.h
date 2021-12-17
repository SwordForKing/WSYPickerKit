//
//  LKPickerViewController.h
//  cltios
//
//  Created by zjlk32 on 2021/8/4.
//

#import <UIKit/UIKit.h>
#import "LKPickerProtocol.h"
#import "LKPickerBackView.h"
#import "LKAlertContentView/LKAlertAction.h"
NS_ASSUME_NONNULL_BEGIN

@interface LKPickerViewController : UIViewController

@property(nonatomic,weak)id<LKWSYPickerDelegate>delegate;

@property(nonatomic,weak)id<LKWSYPickerDataSource>dataSource;

-(instancetype)initWithTitle:(NSString *)title Message:(NSString *)message PickerStyle:(LKWSYPickerStyleType)pickerType;

-(void)lkPickerViewWithDataArr:(NSArray *)dataArray SelectWithBlock:(void(^)(NSString  *title, NSInteger index))block;

-(void)dissmissTheCotnentView;

-(void)addAction:(LKAlertAction *)action;

@end

NS_ASSUME_NONNULL_END
