//
//  ViewController.m
//  ParseJSONDemo
//
//  Created by Apple on 9/9/15.
//  Copyright (c) 2015 广东华讯网络投资有限公司. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "SBJson4.h"
#import "SYMovieModel.h"
#import "SYCell.h"
#import "UIImageView+WebCache.h"
@interface ViewController () <UITableViewDataSource,UITableViewDelegate>
{
     UITableView *_tableView;
     NSMutableArray *_saveDataArray;
}
@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _saveDataArray = [NSMutableArray array];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20) style:UITableViewStylePlain];
    
    _tableView.rowHeight = 120;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    //注册
    [_tableView registerNib:[UINib nibWithNibName:@"SYCell" bundle:nil] forCellReuseIdentifier:@"Cell"];

    
    [self Get];
}

#pragma mark Get Request
-(void)Get{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://api.douban.com/v2/movie/top250" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
     
    NSArray *movieArray = responseObject[@"subjects"];
        
        for (NSDictionary *dict  in movieArray)
        {
            SYMovieModel *model = [[SYMovieModel alloc] init];
            model.movieName = dict[@"title"];
            model.movieYear = dict[@"year"];
            model.movieImage = dict[@"images"][@"large"];
            
            [_saveDataArray addObject:model];
        }
        //刷新表
        [_tableView reloadData];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _saveDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SYCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    SYMovieModel *model = _saveDataArray[indexPath.row];
    
    cell.name.text = model.movieName;
    cell.year.text = model.movieYear;
    [cell.movieImageView sd_setImageWithURL:[NSURL URLWithString:model.movieImage] placeholderImage:[UIImage imageNamed:@"photo"]];

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
