#!/bin/sh
unzip local/artifacts/consul.zip consul -d local/artifacts
exec local/artifacts/consul agent -dev