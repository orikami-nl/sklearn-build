cd /build
source lambda_build/bin/activate
cd /outputs
rm -rf *~ output output.zip
zip -r -9 -q /build/output.zip *
cp -R /build/*.zip /outputs
