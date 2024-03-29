#!/usr/bin/env bash

docker build -t buildrecovery .
docker run \
  -v $(pwd)/common:/common \
  -v $(pwd)/out:/out \
  buildrecovery \
  /bin/bash -c \
  "mkdir -p /usr/src/recovery && \
  cd /usr/src/recovery && \
  repo init --depth=1 -u https://gitlab.com/OrangeFox/Manifest.git -b fox_9.0 && \
  mkdir -p .repo/local_manifests/ && \
  cp -v /common/manifests/local_manifest_winnerx.xml .repo/local_manifests/ && \
  repo sync -c -j$(nproc --all) --no-clone-bundle --no-tags && \
  . build/envsetup.sh && \
  lunch omni_winnerx-eng && \
  mka recoveryimage && \
  cp -fv /usr/src/recovery/out/target/product/winnerx/recovery.img /out/orangefox.img && \
  chmod -v 777 /out/*"
