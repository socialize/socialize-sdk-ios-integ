default: clean pods test

clean:
	rm -rfd Pods
	xcodebuild -workspace SocializeInteg.xcworkspace -scheme "SocializeInteg" -configuration Debug -sdk iphonesimulator clean

pods:
	pod install

test:
	xcodebuild -workspace SocializeInteg.xcworkspace -scheme "SocializeInteg" -configuration Debug -sdk iphonesimulator -destination OS="latest",name="iPhone Retina (4-inch)" test
