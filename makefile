rotcode: main.m coder.m NSString+Utils.m randgen.c
	# Linux
	# gcc -o rotcode main.m coder.m NSString+Utils.m randgen.c `gnustep-config --objc-flags` `gnustep-config --base-libs`
	# OS X
	clang -o rotcode NSString+Utils.m coder.m main.m randgen.c -framework Foundation -lobjc

randtst: randtst.c randgen.c
	gcc -o randtst randtst.c randgen.c
