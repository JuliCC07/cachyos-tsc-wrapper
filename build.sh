#!/bin/bash
set -e

# Configuración
REPO_URL="https://github.com/CachyOS/linux-cachyos.git"
BUILD_DIR="/tmp/linux-cachyos-build"
PATCHES_DIR="$(pwd)/tsc_patches"

echo "=== Compilador del Kernel CachyOS BORE con Parches TSC ==="

# 1. Clonar versión oficial
echo "[1/3] Clonando el repositorio oficial de CachyOS..."
rm -rf "$BUILD_DIR"
git clone --depth 1 "$REPO_URL" "$BUILD_DIR"

# 2. Inyectar parches
echo "[2/3] Copiando e inyectando los parches TSC..."
cd "$BUILD_DIR/linux-cachyos-bore"
cp "$PATCHES_DIR/"*.patch .

# Inyectar los nombres de los parches en el PKGBUILD, justo después de "config"
sed -i 's/"config"/"config"\n    "0017-x86-implement-tsc-directsync-for-systems-without-IA3.patch"\n    "0018-x86-touch-clocksource-watchdog-after-syncing-TSCs.patch"\n    "0019-x86-save-restore-TSC-counter-value-during-sleep-wake.patch"\n    "0020-x86-only-restore-TSC-if-we-have-IA32_TSC_ADJUST-or-d.patch"\n    "0021-x86-don-t-check-for-random-warps-if-using-direct-syn.patch"\n    "0022-x86-export-tsc_khz-to-userspace.patch"/g' PKGBUILD

# 3. Compilar
echo "[3/3] Actualizando sumas de control e iniciando compilación..."
updpkgsums
makepkg -C -si

echo "=== Compilación e instalación finalizada ==="
