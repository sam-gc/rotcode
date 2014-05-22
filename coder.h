#import <Foundation/Foundation.h>

typedef enum {
    RING_INNER,
    RING_OUTER
} RingPosition;

@interface Coder : NSObject
{
    NSString *wheel;
    char key;
    char rot;
    char innerDelim;
    char outerDelim;
}

- (char)randChar:(char)offset;
- (NSString *)generateSpecialCharacters;
- (void)buildWheelWith:(long)rule;
- (char)characterFromWheel:(char)ch;
- (RingPosition)positionOfChar:(char)ch;
- (NSString *)encode:(NSString *)str;
- (NSString *)decode:(NSString *)str;

@end