FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    wget \
    pkg-config \
    libopencv-dev \
    && rm -rf /var/lib/apt/lists/*

COPY darknet /darknet
WORKDIR /darknet

RUN sed -i 's/OPENCV=0/OPENCV=1/' Makefile
RUN make

RUN wget https://pjreddie.com/media/files/yolov3.weights

# URL을 환경변수(URL)로 받아 처리
ENTRYPOINT ["bash", "-c"]
CMD ["wget -O input.jpg \"$URL\" && ./darknet detector test cfg/coco.data cfg/yolov3.cfg yolov3.weights input.jpg -dont_show && echo 'Done'"]
