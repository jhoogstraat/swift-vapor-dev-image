FROM swift:5.7-jammy

# Install tools
RUN apt update -y \
    && apt install -y make unzip curl

# Download and build swift-format
ARG SWIFT_FORMAT_VERSION=0.50700.1
WORKDIR /swift-format
RUN wget -qO- https://github.com/apple/swift-format/archive/${SWIFT_FORMAT_VERSION}.tar.gz | tar zxf - --strip-components 1 \
    && swift build -c release \
    && mv .build/*/release/swift-format /swift-format

# Download protoc
ARG PROTOC_VERSION=22.1
WORKDIR /protoc
RUN wget -qO protoc.zip https://github.com/google/protobuf/releases/download/v$PROTOC_VERSION/protoc-$PROTOC_VERSION-linux-x86_64.zip \
	&& unzip protoc.zip \
	&& mv bin/protoc /protoc
	
# Download and build protoc-gen-swift
ARG PROTOC_SWIFT_VERSION=1.21.0
WORKDIR /protoc-gen-swift
RUN wget -qO- https://github.com/apple/swift-protobuf/archive/${SWIFT_FORMAT_VERSION}.tar.gz | tar zxf - --strip-components 1 \
    && swift build -c release \
    && mv .build/*/release/protoc-gen-swift /protoc-gen-swift 


FROM swift:5.7-jammy

# Install tools (libsqlite3-dev=SQLite)
RUN apt update -y && apt install -y \
    libsqlite3-dev
    
# Copy swift-format, protoc and protoc-gen-swift
COPY --from=0 /swift-format /usr/bin
COPY --from=0 /protoc /usr/bin
COPY --from=0 /protoc-gen-swift /usr/bin

# Install Vapor Toolbox, see https://docs.vapor.codes/4.0/install/linux/
RUN git clone --depth 1 https://github.com/vapor/toolbox.git \
    && (cd toolbox && sed -i 's/sudo//g' Makefile && make install) \
    && rm -r /toolbox
