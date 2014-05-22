#import <stdio.h>
#import <string.h>
#import "NSString+Utils.h"
#import "coder.h"

BOOL strequ(char *a, char *b)
{
    return strcmp(a, b) == 0;
}

int main(int argc, char *argv[])
{
    if(argc == 1)
    {
        printf("Need some arguments yo!\n");
        return 0;
    }

    BOOL file = NO;
    char *str;

    int i = 1;
    if(strequ(argv[i], "-f"))
    {
        file = YES;
        str = argv[++i];
    }
    else
    {
        str = argv[i];
    }

    char *key = NULL;
    BOOL encode = YES;

    for(; i < argc; i++)
    {
        char *s = argv[i];
        if(strequ(s, "-d"))
            encode = NO;

        if(strequ(s, "-k"))
            key = argv[i + 1];
    }

    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    Coder *coder = [[Coder alloc] init];

    if(key)
    {
        long val = 0;
        int len = strlen(key);

        for(i = 0; i < len; i++)
            val += key[i];

        [coder buildWheelWith:val];
    }

    NSString *text;
    if(file)
        text = [NSString stringWithContentsOfFile:[NSString stringWithUTF8String:str] encoding:NSUTF8StringEncoding error:NULL];
    else
        text = [NSString stringWithUTF8String:str];

    NSString *output = encode ? [coder encode:text] : [coder decode:text];

    printf("%s\n", [output UTF8String]);

    [output release];

    [pool drain];
    [pool release];
    return 0;
}