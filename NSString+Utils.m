#import "NSString+Utils.h"

@implementation NSString (Utils)

- (BOOL)containsChar:(char)ch
{
    return [self rangeOfString:[NSString stringWithFormat:@"%c", ch]].location != NSNotFound;
}

- (int)indexOfChar:(char)ch
{
    int i;
    for(i = 0; i < [self length]; i++)
    {
        if([self characterAtIndex:i] == ch)
            return i;
    }

    return -1;
}

@end