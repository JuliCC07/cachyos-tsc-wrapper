su julicc -c "
  sed -i 's/\"config\"/\"config\"\n    \"0001-x86-implement-tsc-directsync-for-systems-without-IA3.patch\"\n    \"0002-x86-touch-clocksource-watchdog-after-syncing-TSCs.patch\"\n    \"0003-x86-save-restore-TSC-counter-value-during-sleep-wake.patch\"\n    \"0004-x86-only-restore-TSC-if-we-have-IA32_TSC_ADJUST-or-d.patch\"\n    \"0005-x86-don-t-check-for-random-warps-if-using-direct-syn.patch\"\n    \"0006-x86-export-tsc_khz-to-userspace.patch\"/g' PKGBUILD
"
