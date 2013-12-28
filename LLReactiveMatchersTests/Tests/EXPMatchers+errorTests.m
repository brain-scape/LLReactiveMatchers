#import "EXPMatchers+error.h"

@interface EXPMatchers_errorTests : TEST_SUPERCLASS
@end

@implementation EXPMatchers_errorTests

- (void) test_nonSignalActual {
    NSArray *actual = @[@1, @2, @3];
    
    assertFail(test_expect(actual).to.error(), @"expected: actual to be a signal or recorder");
    assertFail(test_expect(actual).toNot.error(), @"expected: actual to be a signal or recorder");
}

- (void) test_endsInError {
    RACSignal *signal = [[[LLReactiveMatchersFixtures values:@[@1, @2, @3]] concat:[RACSignal error:MI9SpecError]] setNameWithFormat:@"foo"];
    
    assertPass(test_expect(signal).to.error());
    assertFail(test_expect(signal).toNot.error(), @"Signal foo finished in error instead of not erroring");
}

- (void) test_endsInCompletion {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@1, @2, @3]] setNameWithFormat:@"foo"];
    
    assertPass(test_expect(signal).toNot.error());
    assertFail(test_expect(signal).to.error(), @"Signal foo finished in completion instead of error");
}

- (void) test_notYetCompleted {
    RACSignal *signal = [[[LLReactiveMatchersFixtures values:@[@1, @2, @3]] concat:RACSignal.never] setNameWithFormat:@"foo"];
    
    assertPass(test_expect(signal).toNot.error());
    assertFail(test_expect(signal).to.error(), @"Actual foo has not finished");
}

@end
