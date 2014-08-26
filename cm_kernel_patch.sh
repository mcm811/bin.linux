#!/bin/bash

linux_patch() {
    if [ ! -f Kbuild ] || [ ! -f Kconfig ] || [ ! -f Makefile ]; then
	return
    fi

    local version=$(($1-1))-$1
    if [ ! -f ~/download/patch/patch-3.0.${version}.bz2 ]; then
	cd ~/download/patch/;wget http://www.kernel.org/pub/linux/kernel/v3.0/incr/patch-3.0.${version}.bz2;cd -
    fi
    if [ -f defconfig ]; then
	bzcat ~/download/patch/patch-3.0.${version}.bz2 | patch -p1 -f
	git commit -a -m "Linux 3.0.${1}" --author="Greg Kroah-Hartman <gregkh@linuxfoundation.org>"
    fi
}
linux_patch 63
linux_patch 64


return
##################################################################################################
cd ~/download/patch/;wget http://www.kernel.org/pub/linux/kernel/v3.0/incr/patch-3.0.15-16.bz2;cd -
cd ~/download/patch/;wget http://www.kernel.org/pub/linux/kernel/v3.0/incr/patch-3.0.16-17.bz2;cd -
cd ~/download/patch/;wget http://www.kernel.org/pub/linux/kernel/v3.0/incr/patch-3.0.17-18.bz2;cd -
cd ~/download/patch/;wget http://www.kernel.org/pub/linux/kernel/v3.0/incr/patch-3.0.18-19.bz2;cd -
cd ~/download/patch/;wget http://www.kernel.org/pub/linux/kernel/v3.0/incr/patch-3.0.19-20.bz2;cd -
cd ~/download/patch/;wget http://www.kernel.org/pub/linux/kernel/v3.0/incr/patch-3.0.20-21.bz2;cd -
cd ~/download/patch/;wget http://www.kernel.org/pub/linux/kernel/v3.0/incr/patch-3.0.21-22.bz2;cd -
cd ~/download/patch/;wget http://www.kernel.org/pub/linux/kernel/v3.0/incr/patch-3.0.22-23.bz2;cd -
cd ~/download/patch/;wget http://www.kernel.org/pub/linux/kernel/v3.0/incr/patch-3.0.23-24.bz2;cd -
cd ~/download/patch/;wget http://www.kernel.org/pub/linux/kernel/v3.0/incr/patch-3.0.24-25.bz2;cd -
cd ~/download/patch/;wget http://www.kernel.org/pub/linux/kernel/v3.0/incr/patch-3.0.25-26.bz2;cd -
cd ~/download/patch/;wget http://www.kernel.org/pub/linux/kernel/v3.0/incr/patch-3.0.26-27.bz2;cd -
cd ~/download/patch/;wget http://www.kernel.org/pub/linux/kernel/v3.0/incr/patch-3.0.27-28.bz2;cd -
cd ~/download/patch/;wget http://www.kernel.org/pub/linux/kernel/v3.0/incr/patch-3.0.28-29.bz2;cd -
cd ~/download/patch/;wget http://www.kernel.org/pub/linux/kernel/v3.0/incr/patch-3.0.29-30.bz2;cd -
cd ~/download/patch/;wget http://www.kernel.org/pub/linux/kernel/v3.0/incr/patch-3.0.30-31.bz2;cd -
cd ~/download/patch/;wget http://www.kernel.org/pub/linux/kernel/v3.0/incr/patch-3.0.31-32.bz2;cd -
cd ~/download/patch/;wget http://www.kernel.org/pub/linux/kernel/v3.0/incr/patch-3.0.32-33.bz2;cd -
cd ~/download/patch/;wget http://www.kernel.org/pub/linux/kernel/v3.0/incr/patch-3.0.33-34.bz2;cd -
cd ~/download/patch/;wget http://www.kernel.org/pub/linux/kernel/v3.0/incr/patch-3.0.34-35.bz2;cd -
cd ~/download/patch/;wget http://www.kernel.org/pub/linux/kernel/v3.0/incr/patch-3.0.35-36.bz2;cd -
cd ~/download/patch/;wget http://www.kernel.org/pub/linux/kernel/v3.0/incr/patch-3.0.36-37.bz2;cd -
cd ~/download/patch/;wget http://www.kernel.org/pub/linux/kernel/v3.0/incr/patch-3.0.37-38.bz2;cd -
cd ~/download/patch/;wget http://www.kernel.org/pub/linux/kernel/v3.0/incr/patch-3.0.38-39.bz2;cd -
cd ~/download/patch/;wget http://www.kernel.org/pub/linux/kernel/v3.0/incr/patch-3.0.39-40.bz2;cd -
cd ~/download/patch/;wget http://www.kernel.org/pub/linux/kernel/v3.0/incr/patch-3.0.40-41.bz2;cd -
cd ~/download/patch/;wget http://www.kernel.org/pub/linux/kernel/v3.0/incr/patch-3.0.41-42.bz2;cd -
cd ~/download/patch/;wget http://www.kernel.org/pub/linux/kernel/v3.0/incr/patch-3.0.42-43.bz2;cd -
cd ~/download/patch/;wget http://www.kernel.org/pub/linux/kernel/v3.0/incr/patch-3.0.43-44.bz2;cd -
cd ~/download/patch/;wget http://www.kernel.org/pub/linux/kernel/v3.0/incr/patch-3.0.44-45.bz2;cd -
cd ~/download/patch/;wget http://www.kernel.org/pub/linux/kernel/v3.0/incr/patch-3.0.45-46.bz2;cd -
cd ~/download/patch/;wget http://www.kernel.org/pub/linux/kernel/v3.0/incr/patch-3.0.46-47.bz2;cd -
cd ~/download/patch/;wget http://www.kernel.org/pub/linux/kernel/v3.0/incr/patch-3.0.47-48.bz2;cd -
cd ~/download/patch/;wget http://www.kernel.org/pub/linux/kernel/v3.0/incr/patch-3.0.48-49.bz2;cd -
cd ~/download/patch/;wget http://www.kernel.org/pub/linux/kernel/v3.0/incr/patch-3.0.49-50.bz2;cd -
cd ~/download/patch/;wget http://www.kernel.org/pub/linux/kernel/v3.0/incr/patch-3.0.50-51.bz2;cd -
cd ~/download/patch/;wget http://www.kernel.org/pub/linux/kernel/v3.0/incr/patch-3.0.51-52.bz2;cd -
cd ~/download/patch/;wget http://www.kernel.org/pub/linux/kernel/v3.0/incr/patch-3.0.52-53.bz2;cd -

cd ~/download/patch/;wget http://www.kernel.org/pub/linux/kernel/v3.0/incr/patch-3.0.53-54.bz2;cd -
cd ~/download/patch/;wget http://www.kernel.org/pub/linux/kernel/v3.0/incr/patch-3.0.54-55.bz2;cd -

cd ~/download/patch/;wget http://www.kernel.org/pub/linux/kernel/v3.0/incr/patch-3.0.55-56.bz2;cd -

cd ~/download/patch/;wget http://www.kernel.org/pub/linux/kernel/v3.0/incr/patch-3.0.56-57.bz2;cd -
cd ~/download/patch/;wget http://www.kernel.org/pub/linux/kernel/v3.0/incr/patch-3.0.57-58.bz2;cd -

http://www.kernel.org/pub/linux/kernel/v3.0/patch-3.0.15.bz2

# -p1: 요건 diff 에 붙어 있는 경로 한단계를 벗겨 내는 옵션
# -R: 패치를 되돌릴때 쓰는 옵션(reverse)

# patch: patch
# -p1 < ../2.6.12-mm1
# reverse patch:
# patch -p1 -R < ../2.6.12-mm1

# reverse patch
bzcat ~/download/patch-3.0.15.bz2 | patch -p1 -R
# patch
bzcat ~/download/patch-3.0.45.bz2 | patch -p1

bzcat ~/download/patch/patch-3.0.15-16.bz2 | patch -p1 -f
bzcat ~/download/patch/patch-3.0.16-17.bz2 | patch -p1 -f
bzcat ~/download/patch/patch-3.0.17-18.bz2 | patch -p1 -f
bzcat ~/download/patch/patch-3.0.18-19.bz2 | patch -p1 -f
bzcat ~/download/patch/patch-3.0.19-20.bz2 | patch -p1 -f
bzcat ~/download/patch/patch-3.0.20-21.bz2 | patch -p1 -f
bzcat ~/download/patch/patch-3.0.21-22.bz2 | patch -p1 -f
bzcat ~/download/patch/patch-3.0.22-23.bz2 | patch -p1 -f
bzcat ~/download/patch/patch-3.0.23-24.bz2 | patch -p1 -f
bzcat ~/download/patch/patch-3.0.24-25.bz2 | patch -p1 -f
bzcat ~/download/patch/patch-3.0.25-26.bz2 | patch -p1 -f
bzcat ~/download/patch/patch-3.0.26-27.bz2 | patch -p1 -f
bzcat ~/download/patch/patch-3.0.27-28.bz2 | patch -p1 -f
bzcat ~/download/patch/patch-3.0.28-29.bz2 | patch -p1 -f
bzcat ~/download/patch/patch-3.0.29-30.bz2 | patch -p1 -f
bzcat ~/download/patch/patch-3.0.30-31.bz2 | patch -p1 -f

bzcat ~/download/patch/patch-3.0.31-32.bz2 | patch -p1 -f
bzcat ~/download/patch/patch-3.0.32-33.bz2 | patch -p1 -f
bzcat ~/download/patch/patch-3.0.33-34.bz2 | patch -p1 -f
bzcat ~/download/patch/patch-3.0.34-35.bz2 | patch -p1 -f
bzcat ~/download/patch/patch-3.0.35-36.bz2 | patch -p1 -f
bzcat ~/download/patch/patch-3.0.36-37.bz2 | patch -p1 -f
bzcat ~/download/patch/patch-3.0.37-38.bz2 | patch -p1 -f
bzcat ~/download/patch/patch-3.0.38-39.bz2 | patch -p1 -f
bzcat ~/download/patch/patch-3.0.39-40.bz2 | patch -p1 -f
bzcat ~/download/patch/patch-3.0.40-41.bz2 | patch -p1 -f
bzcat ~/download/patch/patch-3.0.41-42.bz2 | patch -p1 -f
bzcat ~/download/patch/patch-3.0.42-43.bz2 | patch -p1 -f
bzcat ~/download/patch/patch-3.0.43-44.bz2 | patch -p1 -f
bzcat ~/download/patch/patch-3.0.44-45.bz2 | patch -p1 -f
bzcat ~/download/patch/patch-3.0.45-46.bz2 | patch -p1 -f

bzcat ~/download/patch/patch-3.0.46-47.bz2 | patch -p1 -f
bzcat ~/download/patch/patch-3.0.47-48.bz2 | patch -p1 -f
bzcat ~/download/patch/patch-3.0.48-49.bz2 | patch -p1 -f
bzcat ~/download/patch/patch-3.0.49-50.bz2 | patch -p1 -f
bzcat ~/download/patch/patch-3.0.50-51.bz2 | patch -p1 -f

bzcat ~/download/patch/patch-3.0.51-52.bz2 | patch -p1 -f
bzcat ~/download/patch/patch-3.0.52-53.bz2 | patch -p1 -f

bzcat ~/download/patch/patch-3.0.53-54.bz2 | patch -p1 -f
bzcat ~/download/patch/patch-3.0.54-55.bz2 | patch -p1 -f
Linux 3.0.54-55

bzcat ~/download/patch/patch-3.0.55-56.bz2 | patch -p1 -f
Linux 3.0.56

bzcat ~/download/patch/patch-3.0.56-57.bz2 | patch -p1 -f
Linux 3.0.57

bzcat ~/download/patch/patch-3.0.57-58.bz2 | patch -p1 -f
git commit -a -m "Linux 3.0.58" --author="Greg Kroah-Hartman <gregkh@linuxfoundation.org>"





https://github.com/CyanogenMod/android_kernel_htc_msm8960/blob/jellybean/

em mm/vmscan.c
shrink_inactive_list(unsigned long nr_to_scan, struct zone *zone,
			struct scan_control *sc, int priority, int file)
{
	LIST_HEAD(page_list);
	unsigned long nr_scanned;
	unsigned long nr_reclaimed = 0;
	unsigned long nr_taken;
	unsigned long nr_anon;
	unsigned long nr_file;
	isolate_mode_t reclaim_mode = ISOLATE_INACTIVE;

#///////////////////////////////////////////////////////////////////
	set_reclaim_mode(priority, sc, false);

	if (sc->reclaim_mode & RECLAIM_MODE_LUMPYRECLAIM)
		reclaim_mode |= ISOLATE_ACTIVE;

	lru_add_drain();

	if (!sc->may_unmap)
		reclaim_mode |= ISOLATE_UNMAPPED;
	if (!sc->may_writepage)
		reclaim_mode |= ISOLATE_CLEAN;

	spin_lock_irq(&zone->lru_lock);

	if (scanning_global_lru(sc)) {
		nr_taken = isolate_pages_global(nr_to_scan, &page_list,
			&nr_scanned, sc->order, reclaim_mode, zone, 0, file);
		zone->pages_scanned += nr_scanned;
		if (current_is_kswapd())
			__count_zone_vm_events(PGSCAN_KSWAPD, zone,
					       nr_scanned);
		else
			__count_zone_vm_events(PGSCAN_DIRECT, zone,
					       nr_scanned);
	} else {
		nr_taken = mem_cgroup_isolate_pages(nr_to_scan, &page_list,
			&nr_scanned, sc->order, reclaim_mode, zone,
			sc->mem_cgroup, 0, file);
		/*
		 * mem_cgroup_isolate_pages() keeps track of
		 * scanned pages on its own.
		 */
	}

em mm/page_alloc.c
__alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
	bool deferred_compaction = false;

em fs/proc/base.c
-struct mm_struct *mm_for_maps(struct task_struct *task)
-{
	return mm_access(task, PTRACE_MODE_READ);
-}

# 3.0.46
# 334 +	disable_nonboot_cpus();
1 out of 1 hunk FAILED -- saving rejects to file kernel/sys.c.rej

git format-patch -1 master


./include/linux/migrate.h.rej
./include/linux/usb/usbnet.h.rej
./mm/vmscan.c.rej

./mm/memory_hotplug.c.rej
./mm/vmalloc.c.rej
./mm/memory-failure.c.rej
./mm/vmstat.c.rej
./mm/mempolicy.c.rej
./mm/page_alloc.c.rej
./arch/arm/include/asm/cacheflush.h.rej
./arch/arm/Kconfig.rej
./arch/arm/kernel/smp.c.rej
./arch/arm/kernel/traps.c.rej
./arch/arm/plat-samsung/adc.c.rej
./kernel/time/timekeeping.c.rej
./kernel/sys.c.rej
./drivers/net/usb/usbnet.c.rej
./drivers/gpu/drm/i915/i915_reg.h.rej
./drivers/gpu/drm/i915/intel_display.c.rej
./drivers/mmc/core/sd.c.rej
./drivers/usb/host/xhci.h.rej
./drivers/usb/core/hub.c.rej
./drivers/usb/serial/qcserial.c.rej
./drivers/regulator/max8997.c.rej

em scripts/Kbuild.include
