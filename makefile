all:
	odin build main.odin -collection=cocoa=cocoa -keep-temp-files
	@clang main.ll -o main -framework AppKit -framework Foundation -framework CoreFoundation -Wno-override-module
	@rm main.ll
	@rm main.o
	@rm main.bc
clean:
	@rm main
	