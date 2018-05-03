cd /build
source lambda_build/bin/activate
cd /outputs
zip -r -9 -q /build/output.zip *
cp -R /build/*.zip /outputs