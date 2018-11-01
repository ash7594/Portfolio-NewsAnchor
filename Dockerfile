FROM python:3.7
COPY . .
MAINTAINER Ash Agarwal <ashutosh.nath.agarwal@gmail.com>

RUN apt-get update && \
        apt-get install -y \
        build-essential \
        cmake \
        git \
        wget \
        unzip \
        yasm \
        pkg-config \
        libswscale-dev \
        libtbb2 \
        libtbb-dev \
        libjpeg-dev \
        libpng-dev \
        libtiff-dev \
        libavformat-dev \
        libpq-dev

RUN pip install numpy

WORKDIR /
ENV OPENCV_VERSION="3.4.2"
RUN wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip \
&& unzip ${OPENCV_VERSION}.zip \
&& mkdir /opencv-${OPENCV_VERSION}/cmake_binary \
&& cd /opencv-${OPENCV_VERSION}/cmake_binary \
&& cmake -DBUILD_TIFF=ON \
  -DBUILD_opencv_java=OFF \
  -DWITH_CUDA=OFF \
  -DWITH_OPENGL=ON \
  -DWITH_OPENCL=ON \
  -DWITH_IPP=ON \
  -DWITH_TBB=ON \
  -DWITH_EIGEN=ON \
  -DWITH_V4L=ON \
  -DBUILD_TESTS=OFF \
  -DBUILD_PERF_TESTS=OFF \
  -DCMAKE_BUILD_TYPE=RELEASE \
  -DCMAKE_INSTALL_PREFIX=$(python3.7 -c "import sys; print(sys.prefix)") \
  -DPYTHON_EXECUTABLE=$(which python3.7) \
  -DPYTHON_INCLUDE_DIR=$(python3.7 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
  -DPYTHON_PACKAGES_PATH=$(python3.7 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") \
  .. \
&& make install \
&& rm /${OPENCV_VERSION}.zip \
&& rm -r /opencv-${OPENCV_VERSION}

RUN pip install flask && \
  pip install python-dotenv
RUN apt-get install -y ffmpeg libavcodec-extra
RUN pip install gevent
RUN pip install flask-socketio
RUN pip install requests
RUN pip install pytesseract
RUN pip install imutils
RUN pip install Pillow
RUN pip install streamlink
RUN apt-get install -y tesseract-ocr

EXPOSE 8080
CMD ["python", "run.py"]
