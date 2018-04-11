#!/bin/sh


docker build --tag consul_swift .
docker run --rm consul_swift