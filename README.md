# CachyOS Kernel con Parches TSC

Este repositorio contiene un wrapper automatizado para compilar la versión oficial del kernel `linux-cachyos-bore` aplicando unos parches personalizados para forzar la sincronización directa del Time Stamp Counter (TSC) en sistemas que carecen del MSR `IA32_TSC_ADJUST`.

## ¿Cómo funciona?

En lugar de hacer un *fork* de todo el código de CachyOS (lo cual sería difícil de mantener debido a las constantes actualizaciones), este proyecto funciona clonando temporalmente el repositorio original de CachyOS justo antes de compilar, inyectando los parches locales de manera dinámica en el `PKGBUILD` y compilando el kernel.

## Uso

Para compilar e instalar el kernel:

```bash
chmod +x build.sh
./build.sh
```

El script se encargará de:
1. Descargar el `PKGBUILD` oficial más reciente en `/tmp/linux-cachyos-build`.
2. Copiar los parches contenidos en el directorio `tsc_patches/` a la zona de compilación.
3. Modificar el `PKGBUILD` para añadir los parches al array `source`.
4. Calcular las nuevas sumas de control (`updpkgsums`).
5. Ejecutar `makepkg -C -si` para descargar las fuentes, parchear, compilar e instalar el kernel de forma limpia.
