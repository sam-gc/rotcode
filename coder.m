#import <stdio.h>
#import <stdlib.h>
#import "NSString+Utils.h"
#import "coder.h"
#import "randgen.h"

@implementation Coder

- (id)init
{
    self = [super init];
    if(self)
    {
        wheel = [[NSString alloc] initWithString:@"abcdghijklmnopqr"];
        rot = 'z';
        innerDelim = 'e';
        outerDelim = 'f';
    }

    return self;
}

- (char)randChar:(char)offset
{
    return rand_generate() % 26 + offset;
}

- (NSString *)generateSpecialCharacters
{
    NSMutableString *str = [[NSMutableString alloc] init];
    char offset = 'a';

    rot = [self randChar:offset];
    [str appendFormat:@"%c", rot];

    innerDelim = [self randChar:offset];
    while([str containsChar:innerDelim])
        innerDelim = [self randChar:offset];

    [str appendFormat:@"%c", innerDelim];

    outerDelim = [self randChar:offset];
    while([str containsChar:outerDelim])
        outerDelim = [self randChar:offset];

    [str appendFormat:@"%c", outerDelim];

    return str;
}

- (void)buildWheelWith:(long)rule
{
    rand_seed_generator(rule);

    char offset = 'a';

    NSString *special = [self generateSpecialCharacters];

    NSMutableString *output = [[NSMutableString alloc] init];

    int i;
    for(i = 0; i < 13; i++)
    {
        char c = [self randChar:offset];
        while([output containsChar:c] || [special containsChar:c] || c == 'e' || c == 'f')
            c = [self randChar:offset];
        [output appendFormat:@"%c", c];
    }

    wheel = output;

    [special release];
}

- (char)characterFromWheel:(char)ch
{
    ch -= ch > 'm' ? 'n' : 'a';

    return [wheel characterAtIndex:ch];
}

- (RingPosition)positionOfChar:(char)ch
{
    if(ch > 'm')
        return RING_OUTER;
    return RING_INNER;
}

- (NSArray *)brokenMessage:(NSString *)str
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];

    int i, prev;
    for(i = prev = 0; i < [str length]; i++)
    {
        char c = [str characterAtIndex:i];
        if(c == innerDelim || c == outerDelim)
        {
            NSString *s = [str substringWithRange:NSMakeRange(prev, i - prev)];
            prev = i;
            [arr addObject:s];
        }
    }

    [arr addObject:[str substringFromIndex:prev]];

    return arr;
}

- (NSString *)encode:(NSString *)str
{
    NSMutableString *output = [[NSMutableString alloc] init];

    NSArray *words = [[str lowercaseString] componentsSeparatedByString:@" "];
    int i, j;
    for(i = 0; i < [words count]; i++)
    {
        NSString *word = [words objectAtIndex:i];

        if(![word length])
            continue;

        char c = [word characterAtIndex:0];
        
        RingPosition rp = [self positionOfChar:c];

        if(rp == RING_INNER)
            [output appendFormat:@"%c", innerDelim];
        else
            [output appendFormat:@"%c", outerDelim];

        for(j = 0; j < [word length]; j++)
        {
            char ch = [word characterAtIndex:j];

            if(ch < 'a' || ch > 'z')
            {
                [output appendFormat:@"%c", ch];
                continue;
            }

            char n = [self characterFromWheel:ch];
            RingPosition np = [self positionOfChar:ch];
            if(rp != np)
            {
                [output appendFormat:@"%c", rot];
                rp = np;
            }

            [output appendFormat:@"%c", n];
        }
    }

    return output;
}

- (NSString *)decode:(NSString *)str
{
    NSMutableString *output = [[NSMutableString alloc] init];
    NSArray *words = [self brokenMessage:str];

    int i, j;
    for(i = 0; i < [words count]; i++)
    {
        NSString *word = [words objectAtIndex:i];

        if(![word length])
            continue;

        char ch = [word characterAtIndex:0];

        RingPosition rp = ch == innerDelim ? RING_INNER : RING_OUTER;

        for(j = 1; j < [word length]; j++)
        {
            char ch = [word characterAtIndex:j];

            if(ch < 'a' || ch > 'z')
            {
                [output appendFormat:@"%c", ch];
                continue;
            }

            if(ch == rot)
            {
                rp = rp == RING_INNER ? RING_OUTER : RING_INNER;
                continue;
            }

            char offset = rp == RING_INNER ? 'a' : 'n';
            char loc = (char)[wheel indexOfChar:ch];

            char n = loc + offset;
            [output appendFormat:@"%c", n];
        }

        [output appendString:@" "];
    }

    [words release];

    return output;
}

- (void)dealloc
{
    [wheel release];
    [super dealloc];
}

@end