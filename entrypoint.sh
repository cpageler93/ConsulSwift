#!/bin/bash

nohup consul agent --dev --datacenter fra1 &

swift package resolve
swift build
swift test