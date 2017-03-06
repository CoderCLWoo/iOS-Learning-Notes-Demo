//
//  ViewController.m
//  网络编程
//
//  Created by WuChunlong on 16/10/21.
//  Copyright © 2016年 WuChunlong. All rights reserved.
//
//  NSURLConnection 的使用

#import "ViewController.h"

@interface ViewController () <NSURLConnectionDataDelegate>

/** 用来存放服务器返回的数据 */
@property (strong, nonatomic) NSMutableData *responseData;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

#pragma mark - NSURLConnection 的使用(发送GET请求给服务器)
/**
 *  发送同步请求：阻塞式的方法（在当前线程中执行），会一直的等待服务器返回数据
 */
- (void)sync {
    
    // 0.设置请求路径
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/login?username=520it&pwd=520it&type=JSON"];
    
    // 1.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    // 2.发送请求
    // 参数：请求对象， 响应头， 错误信息
    // 返回值：响应体
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // 3.解析服务器返回的数据
    NSLog(@"%zd", data.length);
    // 先解析成字符串
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", str);
    
    
}

/**
 *  发送异步请求：开辟一条子线程发送请求，请求完在指定队列执行回调block
 */
- (void)async {
    
    // 0.设置请求路径
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/login?username=520it&pwd=520it&type=XML"];
    
    // 1.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    // 2.发送请求
    // 参数：请求对象， 回调block执行时所在队列， 请求完毕回调block
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        // 请求完毕会来到这个block
        // 3.解析服务器返回的数据
        NSLog(@"%zd", data.length);
        // 先解析成字符串
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", str);
    }];
    
    
}

/**
 *  用代理的方法发送请求（默认就是异步请求）：可用于大文件下载
 */
- (void)delegateAsync {
    // 0.设置请求路径
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/login?username=520it&pwd=520it&type=JSON"];
    
    // 1.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 2.创建连接对象,默认创建完就自动发送请求
    //    [NSURLConnection connectionWithRequest:request delegate:self];
    
    // 不自动发送请求
    NSURLConnection *connection =  [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    // 开始发送请求
    [connection start];
}


#pragma mark  <NSURLConnectionDataDelegate>
/**
 *  接收到服务器的响应
 */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
    NSLog(@"didReceiveResponse:%@", res.allHeaderFields);
    
    // 创建data对象
    self.responseData = [NSMutableData data];
}


/**
 *  接收到服务器的数据（如果数据量比较大，这个方法会被调用多次）
 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // 不断拼接服务器返回的数据
    [self.responseData appendData:data]; // 对于大文件不能使用这种方法，应该一点一点写入磁盘进行存放
    NSLog(@"didReceiveData: %zd -- %@", data.length, data);
}


/**
 *  服务器的数据成功接收完毕
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"didFinishLoading，%@", [NSThread currentThread]);
    
    // 解析服务器返回的数据
    NSLog(@"%zd", self.responseData.length);
    // 先解析成字符串
    NSString *str = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", str);
    
    // 清空内存中data 数据
    self.responseData = nil;
    
}

/**
 *  请求失败（比如请求超时）
 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError: -- %@", error);
}



#pragma mark - NSURLConnection 的使用(发送POST请求给服务器)
- (void)postRequest {
    // 0.设置请求路径
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/login"];
    
    // 1.创建可变请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // 1.1 更改请求方法（默认为GET）
    request.HTTPMethod = @"POST";
    
    // 1.2 设置请求体
    request.HTTPBody = [@"username=520it&pwd=520it&type=JSON" dataUsingEncoding:NSUTF8StringEncoding];
    
    // 1.3 设置超时
    request.timeoutInterval = 5; // 5s后如果服务器没有响应，就会报错error
    
    // 1.4 设置请求头(可选设置)
    [request setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.143 Safari/537.36 OPR/40.0.2308.90" forHTTPHeaderField:@"User-Agent"];
    
    // 2.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        // 请求完毕会来到这个block
        
        if (connectionError) {
            NSLog(@"请求失败");
        } else {
            
            // 3.解析服务器返回的数据
            NSLog(@"%zd", data.length);
            // 先解析成字符串
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@", str);
        }
    }];
}

#pragma mark - 中文URL处理（转码）
- (void)get {
    NSString *urlStr = @"http://120.25.226.186:32812/login2?username=小码哥&pwd=520it";
    // 0.设置请求路径
    NSURL *url = [NSURL URLWithString:urlStr];
    NSLog(@"%@", url); // 此时结果为：(null)
    
    // 将包含中文的url进行转码
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; // 过期的方法
    //    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:urlStr]]; // 新方法
    
    
    url = [NSURL URLWithString:urlStr];
    
    // 1.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    // 2.发送请求
    // 参数：请求对象， 回调block执行时所在队列， 请求完毕回调block
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        // 请求完毕会来到这个block
        // 3.解析服务器返回的数据
        NSLog(@"%zd", data.length);
        // 先解析成字符串
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", str);
    }];
}

- (void) post {
    NSString *urlStr = @"http://120.25.226.186:32812/login2"; // 如果此时urlStr中含中文字符，仍然要转码
    // 0.设置请求路径
    NSURL *url = [NSURL URLWithString:urlStr];
    NSLog(@"%@", url);
    
    // 1.创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 1.1 设置请求方式
    request.HTTPMethod = @"POST";
    // 1.2 设置请求体
    NSString *requestBody = @"username=小码哥&pwd=520it";
    // 将包含中文的请求体进行转码
    request.HTTPBody = [requestBody dataUsingEncoding:NSUTF8StringEncoding];
    // 1.3 设置超时
    request.timeoutInterval = 5;
    
    // 2.发送请求
    // 参数：请求对象， 回调block执行时所在队列， 请求完毕回调block
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        // 请求完毕会来到这个block
        // 3.解析服务器返回的数据
        NSLog(@"%zd", data.length);
        // 先解析成字符串
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", str);
    }];
}

@end

