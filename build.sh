#!/usr/bin/env bash

docker build -t buildrecovery .
docker run \
  -v $(pwd)/common:/common \
  -v $(pwd)/out:/out \
  buildrecovery \
  /bin/bash -c \
  "mkdir -p /usr/src/recovery
  cd /usr/src/recovery
  repo init --depth=1 -u git://github.com/minimal-manifest-twrp/platform_manifest_twrp_omni.git -b twrp-9.0 && \
  mkdir -p .repo/local_manifests/ && \
  cp -v /common/manifests/local_manifest_winner.xml .repo/local_manifests/ && \
  repo sync -c -j$(nproc --all) --no-clone-bundle --no-tags && \
  export ALLOW_MISSING_DEPENDENCIES=true && \
  . build/envsetup.sh && \
  lunch omni_winner-eng && \
  mka recoveryimage && \
  cp -fv /usr/src/recovery/out/target/product/winner/recovery.img /out/recovery.img && \
  chmod -v 777 /out/*"
