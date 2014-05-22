rotcode: main.m coder.m NSString+Utils.m randgen.c
	gcc -o rotcode main.m coder.m NSString+Utils.m randgen.c `gnustep-config --objc-flags` `gnustep-config --base-libs`

randtst: randtst.c randgen.c
	gcc -o randtst randtst.c randgen.c