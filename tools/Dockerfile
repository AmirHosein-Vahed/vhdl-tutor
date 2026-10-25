# A zero-install playground for the course.
#
#   docker build -t vhdl-tutor .
#   docker run --rm -it -v "$PWD":/course vhdl-tutor
#   root@container:/course# make test
#
# The container has GHDL and GTKWave. GTKWave needs a display; either forward
# X11 (docker run -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix) or just copy the
# .ghw/.vcd file out and open it on the host.

FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ghdl gtkwave make python3 git ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /course
COPY . .

# The skeleton must be green out of the box.
RUN make check-lessons && make test-all

CMD ["bash"]
