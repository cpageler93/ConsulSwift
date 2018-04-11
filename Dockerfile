FROM swift:4.1

MAINTAINER Christoph Pageler

# install packages
RUN apt-get update && apt-get install -y \
    unzip

# install consul
ENV CONSUL_VERSION 1.0.6
RUN curl -o consul_$CONSUL_VERSION.zip "https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip"
RUN unzip consul_$CONSUL_VERSION.zip
RUN mv consul /usr/local/bin

WORKDIR /package

COPY . ./

RUN swift package resolve
RUN swift build
CMD nohup consul agent --dev --datacenter fra1 & swift test