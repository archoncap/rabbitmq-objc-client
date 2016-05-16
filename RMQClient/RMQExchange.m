#import "RMQExchange.h"
#import "RMQChannel.h"

@interface RMQExchange ()
@property (nonatomic, readwrite) NSString *name;
@property (nonatomic, readwrite) id<RMQChannel> channel;
@end

@implementation RMQExchange

- (instancetype)initWithName:(NSString *)name channel:(id<RMQChannel>)channel {
    self = [super init];
    if (self) {
        self.name = name;
        self.channel = channel;
    }
    return self;
}

- (void)delete:(RMQExchangeDeleteOptions)options {
    [self.channel exchangeDelete:self.name options:options];
}

- (void)delete {
    [self delete:RMQExchangeDeleteNoOptions];
}

- (void)publish:(NSString *)message routingKey:(NSString *)key persistent:(BOOL)isPersistent {
    [self.channel basicPublish:message
                    routingKey:key
                      exchange:self.name
                    persistent:isPersistent];
}

- (void)publish:(NSString *)message routingKey:(NSString *)key {
    [self publish:message routingKey:key persistent:NO];
}

- (void)publish:(NSString *)message {
    [self publish:message routingKey:@""];
}

@end
