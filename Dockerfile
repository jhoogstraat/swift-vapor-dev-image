FROM swift:5.7-jammy

# Install tools
RUN apt update -y \
    && apt install -y make unzip wget
    && mkdir /tools

# Download and build swift-format
ARG SWIFT_FORMAT_VERSION=0.50700.1
WORKDIR /swift-format
RUN wget -qO- https://github.com/apple/swift-format/archive/${SWIFT_FORMAT_VERSION}.tar.gz | tar zxf - --strip-components 1 \
    && swift build -c release \
    && mv .build/*/release/swift-format /tools/swift-format

# Download protoc
ARG PROTOC_VERSION=22.1
WORKDIR /protoc
RUN wget -qO protoc.zip https://github.com/google/protobuf/releases/download/v$PROTOC_VERSION/protoc-$PROTOC_VERSION-linux-x86_64.zip \
	&& unzip protoc.zip \
	&& mv bin/protoc /tools/protoc
	
# Download and build protoc-gen-swift
ARG PROTOC_GEN_SWIFT_VERSION=1.21.0
WORKDIR /protoc-gen-swift
RUN wget -qO- https://github.com/apple/swift-protobuf/archive/${PROTOC_GEN_SWIFT_VERSION}.tar.gz | tar zxf - --strip-components 1 \
    && swift build -c release \
    && mv .build/*/release/protoc-gen-swift /tools/protoc-gen-swift 

# Download and build vapor toolbox
ARG VAPOR_TOOLBOX_VERSION=18.6.0
WORKDIR /vapor-toolbox
RUN wget -qO- https://github.com/vapor/toolbox/archive/${VAPOR_TOOLBOX_VERSION}.tar.gz | tar zxf - --strip-components 1 \
    && swift build --static-swift-stdlib -c release \
    && mv .build/*/release/vapor /tools/vapor 


FROM swift:5.7-jammy

# Install tools (libsqlite3-dev=SQLite)
RUN apt update -y && apt install -y \
    libsqlite3-dev
    
# Copy swift-format, protoc and protoc-gen-swift
COPY --from=0 /tools/* /usr/bin
