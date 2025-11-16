FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN sed -i 's|http://archive.ubuntu.com/ubuntu/|http://mirror.kakao.com/ubuntu/|g' /etc/apt/sources.list

RUN apt update && apt install -y \
    build-essential \
    git \
    wget \
    libcurl4-openssl-dev

WORKDIR /

RUN git clone https://github.com/pjreddie/darknet.git

WORKDIR /darknet

RUN sed -i 's/OPENCV=1/OPENCV=0/' Makefile
RUN make

RUN wget https://pjreddie.com/media/files/yolov3.weights -O yolov3.weights

# URL 입력 받아서 다운로드 → darknet 실행하는 스크립트 추가
RUN echo '#!/bin/bash\n\
URL="$1"\n\
wget "$URL" -O input.jpg\n\
./darknet detect cfg/yolov3.cfg yolov3.weights input.jpg\n' > /darknet/run.sh

RUN chmod +x /darknet/run.sh

ENTRYPOINT ["/darknet/run.sh"]
