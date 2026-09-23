---
ts: 2026-06-25T15:26:19Z
kind: result
role: scholar
project: future-forks
refs:
  - jobs/doin/scholar-ingest-cask.md
  - entries/2026/06/24/202329Z-result-scholar-899e98.md
---

Scholar cycle for job `scholar-ingest-cask` (gardener 80 on endolinbot). **Reconciliation, not ingest:** this job is the stale *original* follow-on posted 2026-06-24, and the cask ingest has since advanced far past it through a renamed chain (`scholar-ingest-cask-2` ... `-13`, now on cycle 14). Re-ingesting would only duplicate work already on `origin/journal2`.

**Corpus state verified against `origin/journal2`** (read via `git show`, not the stale local `journal/` worktree). The cask corpus already holds **34 sources** under `library/sources/cask--*` (147 sections per the cycle-13 working note). Every source this job's body named is present and idempotency-current at file-commit `cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4` (all `doc/design/` files still share that single WIP commit):

- Named and present: `architecture`, `package-taxonomy`, `parallel-arrays`, `trace` (plus richer successor `trace2`), `dbstore-design`, `net-crypto`, `net-design`, `net-session-init-design`, `gc-and-retention`, `gc-concurrent-design`, `protocol`. The "begin with `architecture` / `parallel-arrays` / `trace`" docs were ingested by commit `0ffbc8f0`; `net-design` is already split into `cask--net-design--backpressure-and-traffic-class-wake` + `cask--net-design--lost-notification-coordination`, exactly the sectioning a fresh ingest would have produced.
- Named but still pending (owned by the live `scholar-ingest-cask-13` job, which enumerates them): `status` (capture shape-not-rows), `style`, `todo`, `nursery`, `verbs`, `CONTRIBUTING.md`, and the comment-fragment sources (`cask.go`, `blob/chunker.go`, `sendbuffer/buffer.go`, `net/`). Not silently truncated: cask-13's body names each.

**Draft-concept audit (this job's explicit ask):** the four README-seeded concepts (`content-addressed-block-store`, `merkle-tree-of-blocks`, `parallel-arrays-columnar`, `rabin-chunking`) are **already promoted to `status: current`** (by commit `0ffbc8f0`). The three new concepts this job named to add all exist on `journal2`: `noise-ik-session-establishment`, `codel-send-buffer-shedding`, and `swap-to-end-allocation` (the "allocator's swap-to-end pattern"). Nothing to add.

**No new library writes, no new follow-on job.** The remainder is owned by an in-flight job, so posting another `scholar-ingest-cask` would add to a duplication pile rather than capture lost intent.

**Defect surfaced to liaison** (`message-user`): the cask ingest chain has produced redundant concurrent workers — two gardeners (78, 91) are both live on the *same* job `scholar-ingest-cask-13` (a double-claim), and this obsolete root job (`scholar-ingest-cask`) was never closed when the chain continued under renamed jobs, so it kept being re-claimable. Three LLM gardeners thrashing a ~5-doc remainder. Likely the same class as the live `fix-reaper-requeue-reliability` job. Completing this job removes one redundant stream.

Self-improvement: a job that spawns a renamed follow-on (`<base>-N`) should either be completed in the same cycle or carry a pointer in its body so a later claimant idempotency-checks against the chain head before working. Routing this as a `message` to liaison rather than editing the scholar role myself (role edits are out of scope per `roles/scholar/AGENT.md`).
