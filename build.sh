#!/usr/bin/env bash

# set -x
set -eu -o pipefail

source "$stdenv"/setup

buildPhase() {
  cl-wrapper.sh sbcl --no-userinit --disable-debugger --load "$src"/build.lisp --quit
}

installPhase() {
  mkdir -p "$out"/bin
  mv siuta "$out"/bin
  mkdir -p "$out"/lib/sbcl/
  cp "$(dirname "$sbcl")"/../lib/sbcl/sbcl.core "$out"/lib/sbcl/
}

genericBuild
