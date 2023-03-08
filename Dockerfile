FROM swift:5.7-jammy

# Install tools
RUN apt update -y \
    && apt install -y make unzip wget \
    && mkdir -p /tools/bin

# Version args (in order of build time)
ARG SWIFT_FORMAT_VERSION=0.50700.1
ARG PROTOC_GEN_SWIFT_VERSION=1.21.0
ARG VAPOR_TOOLBOX_VERSION=18.6.0
ARG PROTOC_VERSION=22.1

# Download and build swift-format
WORKDIR /swift-format
RUN wget -qO- https://github.com/apple/swift-format/archive/${SWIFT_FORMAT_VERSION}.tar.gz | tar zxf - --strip-components 1 \
    && swift build -c release \
    && mv .build/*/release/swift-format /tools/bin/swift-format

# Download and build protoc-gen-swift
WORKDIR /protoc-gen-swift
RUN wget -qO- https://github.com/apple/swift-protobuf/archive/${PROTOC_GEN_SWIFT_VERSION}.tar.gz | tar zxf - --strip-components 1 \
    && swift build -c release \
    && mv .build/*/release/protoc-gen-swift /tools/bin/protoc-gen-swift

# Download and build vapor toolbox
WORKDIR /vapor-toolbox
RUN wget -qO- https://github.com/vapor/toolbox/archive/${VAPOR_TOOLBOX_VERSION}.tar.gz | tar zxf - --strip-components 1 \
    && swift build -c release \
    && mv .build/*/release/vapor /tools/bin/vapor 

# Download protoc
WORKDIR /protoc
RUN wget -qO protoc.zip https://github.com/google/protobuf/releases/download/v$PROTOC_VERSION/protoc-$PROTOC_VERSION-linux-x86_64.zip \
	&& unzip -d /tools protoc.zip \
    && rm /tools/readme.txt
	
FROM swift:5.7-jammy

# Install tools (libsqlite3-dev=SQLite)
RUN apt update -y && apt install -y \
    libsqlite3-dev
    
# Copy swift-format, protoc, protoc-gen-swift and vapor
COPY --from=0 /tools/. /usr/
