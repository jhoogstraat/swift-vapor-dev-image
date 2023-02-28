FROM swift:5.7-jammy

# Install tools (libsqlite3-dev=SQLite)
RUN apt update -y \
    && apt install -y make unzip curl libsqlite3-dev

# Install swift-format
ARG SWIFT_FORMAT_VERSION=0.50700.1
RUN curl -L -o swift_format.zip https://github.com/apple/swift-format/archive/refs/tags/$SWIFT_FORMAT_VERSION.zip \
    && unzip swift_format.zip -d ./swift-format \
    && cd swift-format/swift-format-$SWIFT_FORMAT_VERSION \
    && swift build -c release \
    && mv ./.build/release/swift-format /usr/local/bin/swift-format \
    && rm -r /swift-format

# Install Vapor Toolbox, see https://docs.vapor.codes/4.0/install/linux/
RUN git clone --depth 1 https://github.com/vapor/toolbox.git \
    && (cd toolbox && sed -i 's/sudo//g' Makefile && make install) \
    && rm -r /toolbox

# Install Protobuf (+ swift plugin)
ARG PROTOC_SWIFT_VERSION=1.21.0
ARG PROTOC_VERSION=22.0
RUN curl -L -o plugin.zip https://github.com/apple/swift-protobuf/archive/refs/tags/$PROTOC_SWIFT_VERSION.zip \
	&& unzip plugin.zip -d ./plugin \
	&& (cd plugin/swift-protobuf-$PROTOC_SWIFT_VERSION && swift build -c release) \
	&& cp ./plugin/swift-protobuf-$PROTOC_SWIFT_VERSION/.build/release/protoc-gen-swift /usr/local/bin/protoc-gen-swift \
	&& rm -rf plugin.zip /plugin \
    && curl -L -o protoc.zip https://github.com/google/protobuf/releases/download/v$PROTOC_VERSION/protoc-$PROTOC_VERSION-linux-x86_64.zip \
	&& unzip protoc.zip -d /usr/local/ \
	&& rm -rf protoc.zip