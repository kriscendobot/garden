---
title: "Single-level-store checkpointing tradeoffs"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/1999-June/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/1999-June.txt.gz
source_content_sha256: 751f38ec0ce03d66083cf9bc3fae6ca07f1c2b32b1b0e94a817feb2f5dbca6ab
source_authors: [Jonathan S. Shapiro, Alan Cox, Norman Hardy, Rik van Riel, Ben Laurie]
source_date: 1999-06-20
thread_subject: "Some very thought-provoking ideas about OS architecture / Questions about EROS"
ingested: 2026-09-16
ingested_by: scholar
topics: [persistence, capability-security]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: A Linux-kernel cross-list discussion stress-tests EROS's combination of object capabilities and transparent system-wide persistence. Shapiro argues that single-level storage eliminates kernel file-system naming and per-application serialization while checkpoints turn recovery into resuming a prior reference graph. Critics correctly identify non-atomic application state, corruption recovery, large randomly-mutated working sets, device state, and checkpoint latency as separate problems. EROS answers with copy-on-write snapshots, append-only logs, extent-aware allocation, migration, explicit invalidation of nonpersistent device capabilities, and the admission that workloads tuned to fill and randomly rewrite memory are a poor fit.

## Persistence is not transactionality

A checkpoint provides a recoverable system image, not an application transaction boundary. Programs that require mutually-consistent updates still need a transaction protocol. Likewise, preserving the heap does not preserve external hardware or network sessions; after restart those resources are reinitialized and clients discover invalid capabilities and reauthenticate or recover.

## The locality strategy

Objects allocated and freed inside one checkpoint window never reach disk. Reallocated objects can avoid both log and home-location writes; zero pages have a compact representation. The append-only checkpoint log converts writes to large sequential transfers, while a later migrator sorts and places objects into their predetermined home locations. Layout is planned at allocation time rather than reconstructed at each write.

## The honest workload boundary

Checkpoint overhead becomes visible for a computation that nearly fills physical memory and randomly mutates the whole working set. Shapiro's responses include changing the checkpoint interval, adding memory, variable-rate checkpointing, and restructuring access patterns, but he explicitly says EROS was not designed to optimize that border case. This is useful provenance for Endo durability work: persistence claims must name both the recovery guarantee and the workload assumptions.

Source: [cap-talk 1999-June archive](http://www.eros-os.org/pipermail/cap-talk/1999-June/) (Internet Archive original-bytes snapshot, sha256 `751f38ec`), cross-list discussion among Jonathan S. Shapiro, Alan Cox, Norman Hardy, Rik van Riel, Ben Laurie, and others, 1999-06-20 to 1999-06-28.
