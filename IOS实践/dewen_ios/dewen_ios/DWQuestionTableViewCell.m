//
//  SKQuestionTableViewCell.m
//  dewen_ios
//
//  Created by 王超 on 15/4/20.
//  Copyright (c) 2015年 com.sk80. All rights reserved.
//

#import "DWQuestionTableViewCell.h"
#import "DWQuestion.h"
#import "DWTagView.h"
#import "DWUser.h"

//#define KCColor(r,g,b) [UIColor colorWithHue:r/255.0 saturation:g/255.0 brightness:b/255.0 alpha:1]//颜色宏定义
#define KCColor(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define kQuestionTableViewCellControllSpacing 10 //控件间距
#define kQuestionTableViewCellBackgroundColor KCColor(251,251,251)
#define kQuestionGrayColor KCColor(0, 58, 96)
#define kQuestionLightGrayColor KCColor(146, 146, 146)

#define kQuestionTableViewCellTitleFontSize 16
#define kQuestionTableViewCellVotesFontSize 11
#define kQuestionTableViewCellAnswersFontSize 11
#define kQuestionTableViewCellCreatedFontSize 11

@interface DWQuestionTableViewCell ()
{
    UILabel *_title;
    UILabel *_votes;
    UILabel *_answers;
    UILabel *_created;
    UILabel *_content;
    SKTagList *_topics;
    UILabel *_creator;
}

@end


@implementation DWQuestionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        //self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        [self initSubView];
    }
    return self;
}


- (void)awakeFromNib {
    // Initialization code
    
}

#pragma mark 初始化视图
- (void)initSubView
{
    //标题
    _title = [[UILabel alloc] init];
    _title.textColor = [UIColor blackColor];
    _title.font = [UIFont systemFontOfSize:kQuestionTableViewCellTitleFontSize];
    _title.numberOfLines = 2; //动态显示UILabel的行数
    //_title.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:_title];
    
    //投票
    _votes = [[UILabel alloc] init];
    _votes.textColor = kQuestionLightGrayColor;
    _votes.font = [UIFont systemFontOfSize:kQuestionTableViewCellVotesFontSize];
    [self addSubview:_votes];
    
    //答案
    _answers = [[UILabel alloc] init];
    _answers.textColor = kQuestionLightGrayColor;
    _answers.font = [UIFont systemFontOfSize:kQuestionTableViewCellAnswersFontSize];
    [self addSubview:_answers];
    
    //时间
    _created = [[UILabel alloc] init];
    _created.textColor = kQuestionLightGrayColor;
    _created.font = [UIFont systemFontOfSize:kQuestionTableViewCellCreatedFontSize];
    [self addSubview:_created];
    
    //creator
    _creator = [[UILabel alloc] init];
    _creator.textColor = kQuestionLightGrayColor;
    _creator.font = [UIFont systemFontOfSize:kQuestionTableViewCellCreatedFontSize];
    [self addSubview:_creator];
    
    //话题
    _topics = [[SKTagList alloc] init];
    [self addSubview:_topics];
    
    
    
}

#pragma mark 设置问题
- (void)setQuestion:(DWQuestion *)question
{
    CGRect screen = [[UIScreen mainScreen] bounds];
    
    //设置标题大小和位置
    CGFloat titleX = 10;
    CGFloat titleY = 13;
    CGFloat titleWidth = screen.size.width - kQuestionTableViewCellControllSpacing * 2;
    CGSize titleSize = [question.title boundingRectWithSize:CGSizeMake(titleWidth, MAXFLOAT)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kQuestionTableViewCellTitleFontSize]}
                                                    context:nil].size;
    UIFont *titleFont = [UIFont systemFontOfSize:kQuestionTableViewCellTitleFontSize];
    CGFloat titleHeight = titleSize.height > titleFont.lineHeight * 2 ? titleFont.lineHeight * 2 : titleSize.height;
    CGRect titleRect = CGRectMake(titleX, titleY, titleSize.width, titleHeight);
    _title.text = question.title;
    _title.frame = titleRect;

    //话题
    [_topics setTags:question.topics];
    _topics.frame = CGRectMake(titleX, CGRectGetMaxY(_title.frame)+5, screen.size.width - kQuestionTableViewCellControllSpacing * 2, _topics.frame.size.height);

    //设置票数大小和位置
    NSString *votesLabel = [NSString stringWithFormat:@"%ld票", (long)question.votes];
    CGSize votesLabelSize = [votesLabel sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:kQuestionTableViewCellVotesFontSize]}];
    CGFloat votesLabelX = titleX;
    CGFloat votesLabelY = CGRectGetMaxY(_topics.frame) + 5;
    CGRect votesLabelRect = CGRectMake(votesLabelX, votesLabelY, votesLabelSize.width, votesLabelSize.height);
    _votes.text = votesLabel;
    _votes.frame = votesLabelRect;
    
    //设置答案数大小和位置
    NSString *answersLabel = [NSString stringWithFormat:@" · %ld答案", (long)question.answers];
    CGSize answersLabelSize = [answersLabel sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:kQuestionTableViewCellAnswersFontSize]}];
    CGFloat answersLabelX = CGRectGetMaxX(_votes.frame);
    CGFloat answersLabelY = votesLabelY;
    CGRect answersLabelRect = CGRectMake(answersLabelX, answersLabelY, answersLabelSize.width, answersLabelSize.height);
    _answers.text = answersLabel;
    _answers.frame = answersLabelRect;
    
    //设置日期大小和位置
    NSString *createdLabel = [NSString stringWithFormat:@" · %@", question.createdStr];
    CGSize createdLabelSize = [createdLabel sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:kQuestionTableViewCellCreatedFontSize]}];
    CGFloat createdLabelX = CGRectGetMaxX(_answers.frame);
    CGFloat createdLabelY = votesLabelY;
    CGRect createdLabelRect = CGRectMake(createdLabelX, createdLabelY, createdLabelSize.width, createdLabelSize.height);
    _created.text = createdLabel;
    _created.frame = createdLabelRect;
    
    //设置creator大小和位置
    DWUser *creator = question.creator;
    //NSLog(@"USER:%ld", (long)creator.pub_uid);
    NSString *creatorLabel = [NSString stringWithFormat:@" · %@", creator.name];
    CGSize creatorLabelSize = [creatorLabel sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:kQuestionTableViewCellCreatedFontSize]}];
    CGFloat creatorLabelX = CGRectGetMaxX(_created.frame);
    CGFloat creatorLabelY = votesLabelY;
    CGRect creatorLabelRect = CGRectMake(creatorLabelX, creatorLabelY, creatorLabelSize.width, creatorLabelSize.height);
    _creator.text = creatorLabel;
    _creator.frame = creatorLabelRect;
    
    self.height = CGRectGetMaxY(_votes.frame) + 13;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
