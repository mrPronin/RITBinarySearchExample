//
//  ViewController.m
//  RITBinarySearchExample
//
//  Created by Aleksandr Pronin on 8/4/15.
//  Copyright (c) 2015 Aleksandr Pronin. All rights reserved.
//

#import "ViewController.h"
#import "MroBinarySearch.h"

#define kRecordsCount   500000
#define kFirstName      @"Peter"
#define kLastName       @"Pronin"
#define kEmail          @"pronin.peter@gmail.com"

static NSString* firstNames[] = {
    @"Tran", @"Lenore", @"Bud", @"Fredda", @"Katrice",
    @"Clyde", @"Hildegard", @"Vernell", @"Nellie", @"Rupert",
    @"Billie", @"Tamica", @"Crystle", @"Kandi", @"Caridad",
    @"Vanetta", @"Taylor", @"Pinkie", @"Ben", @"Rosanna",
    @"Eufemia", @"Britteny", @"Ramon", @"Jacque", @"Telma",
    @"Colton", @"Monte", @"Pam", @"Tracy", @"Tresa",
    @"Willard", @"Mireille", @"Roma", @"Elise", @"Trang",
    @"Ty", @"Pierre", @"Floyd", @"Savanna", @"Arvilla",
    @"Whitney", @"Denver", @"Norbert", @"Meghan", @"Tandra",
    @"Jenise", @"Brent", @"Elenor", @"Sha", @"Jessie"
};

static NSString* lastNames[] = {
    
    @"Farrah", @"Laviolette", @"Heal", @"Sechrest", @"Roots",
    @"Homan", @"Starns", @"Oldham", @"Yocum", @"Mancia",
    @"Prill", @"Lush", @"Piedra", @"Castenada", @"Warnock",
    @"Vanderlinden", @"Simms", @"Gilroy", @"Brann", @"Bodden",
    @"Lenz", @"Gildersleeve", @"Wimbish", @"Bello", @"Beachy",
    @"Jurado", @"William", @"Beaupre", @"Dyal", @"Doiron",
    @"Plourde", @"Bator", @"Krause", @"Odriscoll", @"Corby",
    @"Waltman", @"Michaud", @"Kobayashi", @"Sherrick", @"Woolfolk",
    @"Holladay", @"Hornback", @"Moler", @"Bowles", @"Libbey",
    @"Spano", @"Folson", @"Arguelles", @"Burke", @"Rook"
};

@interface ViewController ()

@property (strong, nonatomic) NSMutableArray *records;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _records = [NSMutableArray array];
    for (int i = 0; i < kRecordsCount; i++) {
        NSString *firstName = firstNames[arc4random_uniform(50)];
        NSString *lastName = lastNames[arc4random_uniform(50)];
        NSString *email = [self randomEmailWithFirstName:firstName andLastName:lastName];
        NSString *displayString = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        NSDictionary *data = @{
                               @"email"             : email,
                               @"first_name"        : firstName,
                               @"last_name"         : lastName,
                               @"display_string"    : displayString
                               };
        [_records addObject:data];
    }
    NSDictionary *data = @{
                           @"email"             : kEmail,
                           @"first_name"        : kFirstName,
                           @"last_name"         : kLastName,
                           @"display_string"    : [NSString stringWithFormat:@"%@ %@", kFirstName, kLastName]
                           };
    [_records addObject:data];
    NSString *attributeName = @"email";
    [_records sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1[attributeName] compare:obj2[attributeName]];
    }];
//    NSLog(@"records: %@", _records);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ordinarySearchAction:(UIButton *)sender {
    NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
    NSDate *startDate = [NSDate date];
    NSDictionary *record = nil;
//    NSString *email = kEmail;
    NSString *email = @"test";
    for (NSDictionary *data in _records) {
        if ([data[@"email"] isEqualToString:email]) {
            record = data;
            break;
        }
    }
    NSUInteger index = NSNotFound;
    if (record) {
        index = [_records indexOfObject:record];
    }
    NSLog(@"Time spent: %f", [[NSDate date] timeIntervalSinceDate:startDate]);
    if (index != NSNotFound) {
        NSLog(@"Found at index [%lu]: %@", (unsigned long)index, record);
    } else {
        NSLog(@"Not found!");
    }
}

- (IBAction)binarySearchAction:(UIButton *)sender {
    NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
    NSDate *startDate = [NSDate date];
    NSString *attributeName = @"email";
    NSDictionary *data = @{
//                           @"email"             : kEmail,
                           @"email"             : @"test",
                           @"first_name"        : kFirstName,
                           @"last_name"         : kLastName,
                           @"display_string"    : [NSString stringWithFormat:@"%@ %@", kFirstName, kLastName]
                           };
    NSUInteger index = [_records indexOfObject:data inSortedRange:NSMakeRange(0, _records.count) options:NSBinarySearchingFirstEqual usingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1[attributeName] compare:obj2[attributeName]];
    }];
    NSLog(@"Time spent: %f", [[NSDate date] timeIntervalSinceDate:startDate]);
    if (index != NSNotFound) {
        NSDictionary *record = [_records objectAtIndex:index];
        NSLog(@"Found at index [%lu]: %@", (unsigned long)index, record);
    } else {
        NSLog(@"Not found!");
    }
}

#pragma mark - Private

- (NSString *)randomStringWithLength:(int)length
{
    NSString *alphabet  = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";
    NSMutableString *s = [NSMutableString stringWithCapacity:length];
    for (NSUInteger i = 0U; i < length; i++) {
        u_int32_t r = arc4random() % [alphabet length];
        unichar c = [alphabet characterAtIndex:r];
        [s appendFormat:@"%C", c];
    }
    return s;
}

- (NSString *)randomEmailWithFirstName:(NSString *)firstName andLastName:(NSString *)lastName
{
    NSString *email = [NSString stringWithFormat:@"%@.%@@%@.com", [firstName lowercaseString], [lastName lowercaseString], [self randomStringWithLength:5]];
//    NSString *email = [NSString stringWithFormat:@"%@.%@@%@.com", firstName, lastName, @"rit"];
    return email;
}

@end
