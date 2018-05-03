FROM amazonlinux:latest

RUN yum update -y && \
    yum install -y \
    # python 
    python36 \
    python36-devel \
    python36-virtualenv \
    python34-setuptools \
    # compilers
    gcc \
    gcc-c++ \
    # utils
    findutils \
    zip \
    # additional libraris for optimized linear algebra
    atlas-devel \
    atlas-sse3-devel \
    blas-devel \
    lapack-devel

WORKDIR /build

# Create VENV and use pip3.6 to install everything
RUN python3.6 -m venv --copies lambda_build && \
    chmod +x lambda_build/bin/activate && \
    source lambda_build/bin/activate

RUN source lambda_build/bin/activate && \
    pip3.6 install --upgrade pip wheel && \
    pip3.6 install --no-binary numpy numpy && \
    pip3.6 install --no-binary scipy scipy
    # TODO: Add pandas

# Copy shared libraries into lib
RUN LIBDIR="$VIRTUAL_ENV/lib/python3.6/site-packages/lib/" && \
    mkdir -p $LIBDIR && \
    cp /usr/lib64/atlas/* $LIBDIR && \
    cp /usr/lib64/libquadmath.so.0 $LIBDIR && \
    cp /usr/lib64/libgfortran.so.3 $LIBDIR

# Strip
RUN find $VIRTUAL_ENV/lib/python3.6/site-packages/ -name "*.so" | xargs strip

# Zip
RUN cd $VIRTUAL_ENV/lib/python3.6/site-packages/ && \
    zip -r -9 -q /build/output.zip *

# Copy to output folder (when mounted, this will be available on your HD)
COPY ./build.sh /build/build.sh
CMD chmod +x /build/build.sh && /build/build.sh