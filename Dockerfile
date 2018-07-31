FROM amazonlinux:2017.03.1.20170812

RUN yum update -y && \
    yum install -y \
    # python 
    python36 \
    python36-devel \
    python36-virtualenv \
    python36-setuptools \
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
    lapack-devel && \
    rm -rf /var/cache/yum

WORKDIR /build

# Create VENV and install pip3.6
RUN python3.6 -m venv --copies lambda_build && \
    chmod +x lambda_build/bin/activate && \
    source lambda_build/bin/activate && \
    pip3.6 install --upgrade pip wheel

COPY ./requirements.txt requirements.txt

# Install everything
RUN source lambda_build/bin/activate && \
    pip3.6 install -r requirements.txt

# Copy shared libraries into lib and zip
RUN source lambda_build/bin/activate && \
    pip uninstall -y wheel pip && \ 
    LIBDIR="$VIRTUAL_ENV/lib/python3.6/site-packages/lib/" && \
    mkdir -p $LIBDIR && \
    cp /usr/lib64/atlas/* $LIBDIR && \
    cp /usr/lib64/libquadmath.so.0 $LIBDIR && \
    cp /usr/lib64/libgfortran.so.3 $LIBDIR && \
    # Strip
    find $VIRTUAL_ENV/lib/python3.6/site-packages/ -name "*.so" | xargs strip && \
    # Zip
    cd $VIRTUAL_ENV/lib/python3.6/site-packages/ && \
    zip -r -9 -q /build/output.zip * && \
    rm -rf /root/.cache /var/cache/yum


# Copy to output folder (when mounted, this will be available on your HD)
COPY ./build.sh build.sh
CMD chmod +x /build/build.sh && /build/build.sh
