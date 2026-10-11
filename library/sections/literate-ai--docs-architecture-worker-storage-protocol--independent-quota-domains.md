---
title: "Worker storage observation protocol: independent quota domains"
source: docs/architecture/worker-storage-protocol.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, process-monitoring]
status: current
---

> Abstract: Each storage sample carries one to eight opaque quota domains whose bytes and inodes are checked independently; admission sums demand per domain, an empty list never means unlimited, and the Linux adapter reads quotas read-only through `quotactl_fd` while declaring other filesystems unsupported.

## Independent quota domains

Each storage sample carries one to eight sorted, unique `quotas` entries. Each entry
has an opaque `domain`, `available_bytes` and `available_inodes`. An empty list cannot
stand for unlimited capacity. This revises an unreleased observation contract;
earlier private development observations must be collected again.

Admission sums concurrent demand once per bound quota domain, keeps one maximum
reserve per domain, and checks byte and inode limits independently. A shared user
limit can overlap separate group limits; free capacity in one cannot satisfy another.
Failed measurements remain explicit and cannot remove that role's demand from a
shared domain. Conflicting measured and not-applicable results require rechecking.

The Linux adapter admits 64-bit x86-64/AArch64 ext filesystems and uses the existing
open directory descriptor for read-only `quotactl_fd` queries. It queries class
applicability before filesystem user/group identities; `ESRCH` from a per-identity
query is unavailable, not proof of disabled quotas. It conservatively includes both
the process filesystem GID and directory GID when they differ. Soft limits are
conservative ceilings without assuming their grace periods survive the job. Byte
limits use the kernel's 1,024-byte units; inode limits remain independent. These
interfaces are defined by the [Linux quota UAPI](https://raw.githubusercontent.com/torvalds/linux/master/include/uapi/linux/quota.h)
and [quotactl_fd reference](https://www.man7.org/linux/man-pages/man2/quotactl_fd.2.html).

No enable, set, sync or mount operation is issued. Active project quotas, XFS,
macOS/APFS, unknown ABIs and unavailable syscalls remain explicitly unsupported or
unavailable. Existing-worker Linux qualification demonstrates disabled-class
applicability; real active-quota exhaustion and additional filesystem/platform
coverage remain required. Fixtures cover user/group byte and inode exhaustion,
partial kernel records, denied queries and overlapping admission domains. Windows
continues to use caller-available capacity with explicit inapplicable inode quotas.

Source: [docs/architecture/worker-storage-protocol.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/worker-storage-protocol.md) at commit `fcc40bc` (source lines 91–121).
