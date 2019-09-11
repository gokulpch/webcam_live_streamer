FROM python:3.6
USER root
RUN apt-get update && \
        apt-get install -y \
        build-essential \
        software-properties-common \
        cmake \
        apt-utils \
        git \
        wget \
        unzip \
        yasm \
        pkg-config

#RUN add-apt-repository -y “deb http://security.ubuntu.com/ubuntu xenial-security main”

RUN apt-get update && \
        apt-get install -y \
        libswscale-dev \
        libtbb2 \
        libtbb-dev \
        libjpeg-dev \
        libpng-dev \
        libtiff-dev \
        libavformat-dev \
        libpq-dev

RUN git clone https://github.com/jasperproject/jasper-client.git jasper && \
 		chmod +x jasper/jasper.py && \
		pip install --upgrade setuptools && \ 
		pip install -r jasper/client/requirements.txt

RUN pip install numpy

WORKDIR /
RUN apt-get install -y --no-install-recommends python python-dev python-pip build-essential cmake git pkg-config libtiff5-dev libgtk2.0-dev libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libatlas-base-dev gfortran libavresample-dev libgphoto2-dev libgstreamer-plugins-base1.0-dev libdc1394-22-dev \ 
&& cd /opt \
&& git clone https://github.com/opencv/opencv_contrib.git \
&& cd opencv_contrib \
&& git checkout 3.4.0 \	
&& cd /opt \
&& git clone https://github.com/opencv/opencv.git \
&& cd opencv \
&& git checkout 3.4.0 \
&& mkdir build \
&& cd build \
&& cmake -D CMAKE_BUILD_TYPE=RELEASE \
	 -D BUILD_NEW_PYTHON_SUPPORT=ON \
	 -D CMAKE_INSTALL_PREFIX=/usr/local \
	 -D INSTALL_C_EXAMPLES=OFF \
	 -D INSTALL_PYTHON_EXAMPLES=OFF \
	 -D OPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib/modules \
	 -D PYTHON_EXECUTABLE=/usr/bin/python2.7 \
	 -D BUILD_EXAMPLES=OFF /opt/opencv \
&& make -j $(nproc) \
&& make install \
&& ldconfig \
&& rm -rf /var/lib/apt/lists/* \
&& rm -rf /opt/opencv* \
&& cd / \
&& git clone https://github.com/gokulpch/webcam_live_streamer \
&& cd webcam_live_streamer \
&& pip install -r requirements.txt \
&& cd .. \
&& sed -i 's/#if NPY_INTERNAL_BUILD/#ifndef NPY_INTERNAL_BUILD\n#define NPY_INTERNAL_BUILD/g' /usr/local/lib/python3.6/site-packages/numpy/core/include/numpy/npy_common.h \
&& cd ../.. \
&& chmod +x webcam_live_streamer/main.py
#Expose port 80
EXPOSE 80
#Default command
CMD ["webcam_live_streamer/main.py"]
