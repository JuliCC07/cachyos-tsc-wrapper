# CachyOS Kernel with TSC Patches Wrapper

This repository contains an automated wrapper to compile the official `linux-cachyos-bore` kernel while dynamically injecting custom patches to force direct synchronization of the Time Stamp Counter (TSC) on systems lacking the `IA32_TSC_ADJUST` MSR.

## How It Works

Instead of maintaining a heavy fork of the entire CachyOS kernel repository (which is updated very frequently), this wrapper:
1. Clones the official upstream CachyOS repository on-the-fly into a temporary build directory.
2. Copies the custom TSC patches (stored in `tsc_patches/`) into the build area.
3. Modifies the `PKGBUILD` source array dynamically using `sed` to register the patches.
4. Updates the integrity checksums of the sources (`updpkgsums`).
5. Initiates a clean compile and installs the kernel (`makepkg -C -si`).

---

## Usage

To compile and install the kernel:

```bash
chmod +x build.sh
./build.sh
```

---

## Guide for the Future: How to Adapt Patches to Newer Kernels

Since the Linux kernel code evolves, a future update might change the surrounding lines of code that a patch targets. When this happens, `makepkg` will fail during `prepare()` with a message like:
> `Hunk #2 FAILED at 344.`

Here is the step-by-step process to adapt and resolve these conflicts manually:

### Step 1: Identify the Failure
1. Run `./build.sh`.
2. Look at the output of the failed step. It will specify which patch failed and on which file.
3. Navigate to the temporary directory where `makepkg` is compiling (usually `/tmp/linux-cachyos-build/linux-cachyos-bore/src/linux-<version>/`).
4. Look for the `.rej` (rejected) file generated next to the target source file (e.g., `arch/x86/kernel/tsc.c.rej`). This file shows exactly what context the patch was looking for and couldn't find.

### Step 2: Manually Locate the Target Code
1. Open the original source file (e.g., `arch/x86/kernel/tsc.c`) in the temporary build directory.
2. Search for the function or variable names mentioned in the patch (e.g., `tsc_setup` or `tsc_watchdog`).
3. Note how the code has changed (e.g., variable names refactored, surrounding code blocks updated, braces removed or added).

### Step 3: Modify the Patch File
1. Open the corresponding patch file in `tsc_patches/` (e.g., `tsc_patches/0001-x86-implement-tsc-directsync-for-systems-without-IA3.patch`).
2. Locate the "hunk" (the block starting with `@@ -line,num +line,num @@`) that failed.
3. Edit the context lines (the lines without `+` or `-` at the start of the hunk) to match the new code layout exactly.
4. Ensure variables match the new names used in the newer kernel source code.

*Alternatively (Easier way using Git):*
1. In a copy of the kernel source, make the code modification manually.
2. Generate a clean patch of your changes using:
   ```bash
   git diff path/to/file.c > new_patch.patch
   ```
3. Replace the old patch in `tsc_patches/` with this newly generated one.

### Step 4: Commit and Push
Once the patch applies successfully and `./build.sh` finishes without errors:
1. Commit the changes to your wrapper repository:
   ```bash
   git add tsc_patches/
   git commit -m "Update patch X to support kernel version Y.Z"
   git push
   ```
