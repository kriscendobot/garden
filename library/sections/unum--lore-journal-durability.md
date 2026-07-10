---
title: Git-ref journal durability — RMW-CAS, primitive selection, and cutover atomicity
source: LORE/ (journal & durability cluster)
source_repo: jcorbin.tngl.sh/unum
source_commit: 1834abac9b27e517d0ffd2bf20625e33e9a05028
source_date: 2026-06-21
source_authors: [jcorbin]
ingested: 2026-07-10
ingested_by: scholar
topics: [agent-fleet-durability, persistence]
status: current
notes: |
  Consolidates the LORE "Journal, state & durability" cluster:
  journal_ref_concurrent_writers_cas_pattern, journal_primitive_selection_rmw_vs_writeonce,
  journal_cutover_lazy_untrack_atomicity. Directly comparable to the garden's own
  journal2-branch CAS board (`commit_and_push` retry loop, silent-loss guard).
---

## Abstract

unum stores runtime state on a dedicated git ref (`refs/devoker/journal`, an orphan
ref with no shared history) written concurrently by three processes — vigil,
invoker, televoke. Its durability lessons are the mechanics of **safely
concurrent-writing and migrating files on a git ref**, and they map almost one-to-one
onto the garden's own `journal2`-branch job board and its `commit_and_push`
CAS-retry-with-silent-loss-guard. Three lessons compose: pick the write primitive by
the file's *lifecycle*, use read-modify-write CAS (not a blind overlay) for
concurrently-mutated files, and migrate a file off a branch **journal-then-untrack
atomically** so a re-clone never sees neither copy.

## Concurrent writers need RMW-CAS, not a blind overlay

A ref with multiple concurrent writers cannot use a **blind whole-file overlay**: two
writers touching *different sections* of the same ledger file clobber each other, and
the loss is silent — a lost-update bug on the very ledger the merge engine reads to
decide task state. unum's `CommitToRef` did exactly this blind overlay; the
correction, `UpdateFileOnRef`, is a transactional **read-modify-write with CAS retry**:
it **re-reads the file and re-runs the caller's mutate closure on every CAS attempt**,
so a competing writer's edit is already present when the mutate runs and survives
alongside ours. Two invariants make it safe:

- The mutate closure must be **idempotent and re-runnable** — it is invoked fresh
  against the latest ref tip on every retry, never once against a snapshot.
- This gives a git ref the same atomic-RMW safety an on-disk per-path lock gives a
  file — an on-disk-lock equivalent, but over a ref.

(This is the same shape the garden's `land-journal-edit.sh` / `journal-entry.sh`
encode: `sync_clone` to the current `origin/journal2` tip *first*, then commit and
CAS-push with a `_verify_pushed` guard — never land against an in-context-stale
snapshot.)

## Select the primitive by file lifecycle, not by habit

Once RMW-CAS is in hand the reflex is to carry it everywhere — wrong. Choose by the
file's **lifecycle**:

- **Mutated in place by concurrent writers** → RMW-CAS (`UpdateFileOnRef`). Re-reads
  and re-runs so concurrent edits survive.
- **Write-once new file** (session archives, per-run transcripts) → a plain write-once
  primitive (`CommitFilesToRef` / `CommitToRef`). One writer, one archive, no
  concurrent-write race, so **CAS is needless machinery**.

Applying RMW-CAS to a write-once file is wasted overhead; applying a write-once overlay
to a concurrently-mutated file is a lost-update bug. The selection axis is
concurrency/mutation — **not** file size or churn (a large, high-churn but
concurrently-mutated file is still an RMW-CAS case).

## Cutover: journal-then-untrack atomically, never `git rm --cached`

Migrating a file *off* a tracked branch *onto* the journal ref with a one-time
`git rm --cached` cutover commit opens a window where a **re-clone has neither copy** —
gone from the branch, journal copy not yet written. For multi-MB session transcripts
and channel state that window is data loss. The pattern:

> **Journal-then-untrack atomically in the same runtime write operation** — first
> journal the file to the ref, *then* untrack it from the branch index, in that order,
> in one op — so an already-tracked file keeps its branch copy until its journal copy
> exists. There is no moment with neither.

`.gitignore` does the rest passively: it **suppresses future tracking without removing
already-tracked copies**, so adding the glob is safe and the lazy untrack does the
cutover gradually, per-file, on each file's next write — no flag-day, no
`git rm --cached`. Caveat: for **always-new** file classes (sessions), once the glob is
in place a flag-OFF `git add` is *refused* — the byte-identical guarantee that holds
for redirected *existing* files does not hold for new writes; a rollback would need an
explicit `git add -f` path (deliberately not built).

Source: LORE `journal_ref_concurrent_writers_cas_pattern`,
`journal_primitive_selection_rmw_vs_writeonce`, `journal_cutover_lazy_untrack_atomicity`
at [jcorbin.tngl.sh/unum](https://tangled.org/jcorbin.tngl.sh/unum) commit `1834aba`.
