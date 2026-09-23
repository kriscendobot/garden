---
title: "Building a persistent capability system: EROS versus L4"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2002-October/
source_snapshot: http://web.archive.org/web/20160730002215id_/http://www.eros-os.org/pipermail/cap-talk/2002-October.txt.gz
source_content_sha256: 16b523320f83b00b825f5b1ea06be193ea37d524a5a9b90f3fd6699f2d50013e
source_authors: [Travis Bemann, Jonathan S. Shapiro, Gernot Heiser, Sandro Magi, David Mercer]
source_date: 2002-10-05 to 2002-10-31
thread_subject: "EROS versus L4-based persistent capability system / Caps and Confinement in Mungi"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, capability-theory]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Travis Bemann asks whether to build a persistent capability system directly on EROS or to layer one over the faster L4 microkernel, worrying that EROS-as-microkernel would be Mach-sized and slow. The thread answers on two fronts. Sandro Magi and Jonathan Shapiro correct the premise: EROS is a second-generation microkernel, not a Mach-like first-generation one; its IPC latency and throughput are on par with L4 (within 40 cycles of the fastest reported L4 assembly implementation), its production kernel is actually *smaller* than L4 Hazelnut, and — the decisive difference — EROS capability invocation is fully protected by the kernel, whereas L4's protection at the time was not. Gernot Heiser answers the layering question directly: L4 supplies the mechanism (clans-and-chiefs IPC control) to confine the capability "world" from the raw thread-and-message world beneath it, and the Mungi single-address-space persistent OS already does exactly this — a capability-based discretionary access control model, plus a mandatory access control system, built on L4.

## The performance premise is wrong

Bemann reasons from first principles that a capability microkernel must be big and slow like Mach. Shapiro's rebuttal is empirical: read the papers first. EROS is smaller and tighter than Mach; the measured IPC sits within tens of cycles of hand-tuned L4; the production (NDEBUG) kernel is smaller than L4 Hazelnut and still shrinking. The critical-path sizes of the two kernels are comparable, which is why the performance is comparable.

## Protection, not speed, is the real axis

The distinction Shapiro stresses is not cycles but protection: EROS's capability invocation is mediated and protected by the kernel, while L4 (at the time) left protection to be built above. A capability system layered over a non-capability microkernel therefore lives or dies by whether the layer beneath can be prevented from being addressed directly.

## Confining a capability layer over a raw microkernel

Heiser answers Bemann's containment worry: L4's clans-and-chiefs mechanism (or its successor in the next API) controls IPC across protection boundaries, which is exactly what is required to keep processes inside the userspace capability world from talking to the thread-and-message world that would circumvent it. Mungi (a single-address-space persistent OS on L4) is the existence proof — capability-based DAC layered on L4, alongside a MAC system. The trade the thread surfaces: building on L4 buys a fast, well-understood base but forces you to reconstruct protected invocation on top; building on EROS gets protected capability invocation for free.

Source: [cap-talk 2002-October archive](http://www.eros-os.org/pipermail/cap-talk/2002-October/) (Internet Archive original-bytes snapshot `web/20160730002215id_/.../2002-October.txt.gz`, sha256 `16b52332`), messages dated 2002-10-05 to 2002-10-31.
