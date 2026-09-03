/opt/homebrew/Library/Homebrew/cmd/shellenv.sh: line 18: /bin/ps: Operation not permitted
/Users/yangmizhao/.rvm/scripts/rvm:29: operation not permitted: ps
#import <Foundation/Foundation.h>

static NSString *NullableString(id value) {
    if (value == nil || value == [NSNull null]) {
        return nil;
    }
    return [value isKindOfClass:[NSString class]] ? value : nil;
}

static NSNumber *NullableNumber(id value) {
    if (value == nil || value == [NSNull null]) {
        return nil;
    }
    return [value isKindOfClass:[NSNumber class]] ? value : nil;
}

static NSDictionary *DictionaryValue(id value) {
    return [value isKindOfClass:[NSDictionary class]] ? value : @{};
}

static NSDictionary *BuildOrderSummary(NSDictionary *payload) {
    NSDictionary *customer = DictionaryValue(payload[@"customer"]);
    NSString *name = NullableString(customer[@"name"]);
    NSString *email = NullableString(customer[@"email"]);
    NSNumber *total = NullableNumber(payload[@"total"]);

    return @{
        @"customerName": name.length > 0 ? name : @"Guest customer",
        @"email": email.length > 0 ? email : @"Not provided",
        @"total": total ?: @0,
    };
}

static BOOL AssertEqual(id actual, id expected, NSString *label) {
    BOOL passed = [actual isEqual:expected];
    NSLog(@"%@ %@ (actual: %@)", passed ? @"PASS" : @"FAIL", label, actual);
    return passed;
}

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        NSDictionary *validPayload = @{
            @"customer": @{ @"name": @"Alicia", @"email": @"alicia@example.com" },
            @"total": @129.90,
        };

        NSDictionary *nullPayload = @{
            @"customer": @{ @"name": @"Bo", @"email": [NSNull null] },
            @"total": @42,
        };

        NSDictionary *malformedPayload = @{
            @"customer": @"unexpected-string",
            @"total": @"not-a-number",
        };

        NSDictionary *first = BuildOrderSummary(validPayload);
        NSDictionary *second = BuildOrderSummary(nullPayload);
        NSDictionary *third = BuildOrderSummary(malformedPayload);

        NSString *missingObject = nil;
        NSUInteger safeLength = missingObject.length;
        NSLog(@"A message to nil returned length %lu", (unsigned long)safeLength);

        BOOL ok = YES;
        ok &= AssertEqual(first[@"email"], @"alicia@example.com", @"valid email is preserved");
        ok &= AssertEqual(second[@"email"], @"Not provided", @"JSON null becomes a fallback");
        ok &= AssertEqual(third[@"customerName"], @"Guest customer", @"wrong container type is rejected");
        ok &= AssertEqual(third[@"total"], @0, @"wrong number type is rejected");
        ok &= AssertEqual(@(safeLength), @0, @"object-returning nil chain is harmless here");

        NSLog(@"%@", ok ? @"All checks passed." : @"One or more checks failed.");
        return ok ? 0 : 1;
    }
}
