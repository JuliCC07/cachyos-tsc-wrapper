#!/bin/bash
set -e

# Variables config
REPO_URL="https://github.com/CachyOS/linux-cachyos.git"
BUILD_DIR="/tmp/linux-cachyos-build"
PATCHES_DIR="$(pwd)/tsc_patches"

echo "=== TSC-patched CachyOS BORE kernel compiler ==="

# 1. Clonning the official version
echo "[1/3] Clonning official repo..."
rm -rf "$BUILD_DIR"
git clone --depth 1 "$REPO_URL" "$BUILD_DIR"

# 2. Injecting patches
echo "[2/3] Copying and injecting TSC patches..."
cd "$BUILD_DIR/linux-cachyos-bore"
cp "$PATCHES_DIR/"*.patch .

# Injecting patch filenames into PKGBUILD, right after "config"
sed -i 's/"config"/"config"\n    "0001-x86-implement-tsc-directsync-for-systems-without-IA3.patch"\n    "0002-x86-touch-clocksource-watchdog-after-syncing-TSCs.patch"\n    "0003-x86-save-restore-TSC-counter-value-during-sleep-wake.patch"\n    "0004-x86-only-restore-TSC-if-we-have-IA32_TSC_ADJUST-or-d.patch"\n    "0005-x86-don-t-check-for-random-warps-if-using-direct-syn.patch"\n    "0006-x86-export-tsc_khz-to-userspace.patch"/g' PKGBUILD

# 3. Compiling
echo "[3/3] Updating checksums and initializing the compliation..."
updpkgsums
makepkg -C -si
