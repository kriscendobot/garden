---
title: "Driver trust, DMA, and least authority"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/1999-August/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/1999-August.txt.gz
source_content_sha256: 7800fc19e7a8155ce7ca63144a72b3319d767cc0c276f406dddd73d5323d4c3d
source_authors: [Eyal Lotem, Norman Hardy, R. J. Shaw, Jonathan S. Shapiro]
source_date: 1999-08-08
thread_subject: "Is a VM really required?"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Critics ask why a least-authority operating system keeps hardware drivers in its trusted kernel. Shapiro's answer distinguishes code placement from effective authority: a device with unrestricted DMA can alter all physical memory, so its driver already has machine-wide authority even when placed in a user process. Moving it out of the kernel may improve engineering and dynamic loading, but without cooperative hardware it does not shrink the trusted computing base and can add transitions, translation calls, copying, and buffer-accounting hazards.

## Split drivers and capability-shaped hardware interfaces

EROS splits drivers into a trusted lower half for registers, interrupts, DMA, and physical translation, plus an upper half for queueing and policy. KeyKOS had hardware that supported a narrower channel-program interface, letting a driver run programs only on a device capability it held. Shapiro considers downloadable checked driver code and read-only mapping access, but each still needs a trusted mechanism for pinning pages and constraining DMA.

## Open architectural edge

The thread does not reject user-level drivers. It says their security benefit depends on a real hardware boundary such as an IOMMU or a constrained channel processor. Otherwise process separation changes fault containment and certification shape, not authority. This is a durable POLA lesson: count the effects a component can cause, not the ring or process where its code resides.

Source: [cap-talk 1999-August archive](http://www.eros-os.org/pipermail/cap-talk/1999-August/) (Internet Archive original-bytes snapshot, sha256 `7800fc19`), messages by Eyal Lotem, Norman Hardy, R. J. Shaw, and Jonathan S. Shapiro, 1999-08-08 to 1999-08-15.
