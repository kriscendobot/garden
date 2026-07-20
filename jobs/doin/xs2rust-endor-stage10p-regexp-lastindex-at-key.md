---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-20T09:40:06Z -->

---
model: opus
---
# Stage-10p child 1: AT-key RegExp `lastIndex` WRONG-completion (PR #600, xs2rust-endor)

**Repo:** `endojs/endo-but-for-bots`, branch `xs2rust-endor`, PR #600 (DRAFT — keep DRAFT).
**Worktree:** `scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`;
sync to the REAL remote tip first (the press and stage-10p child 0 advance the branch). Cache seeding,
bundle rules, oracle pin `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`, cargo/TMPDIR notes: identical to
child 0's brief (same-tip siblings on endolin-garden include
`scratch/project-wt-port-xs-to-rust-memory-safe-engine-s46-5cd7f36a`).

## The finding (s45, re-confirmed s46 — a WRONG-completion, priority over mere misses)

`var re=/x/; re['lastIndex']=3; re.lastIndex` → oracle `3`, endor `0`. The computed (AT-key) WRITE path
misses the RegExp side table that the dot-path write hits, then the read silently serves the stale `0`.
The F1 bug-class doctrine binds: ANY write/mutation path onto a guest-reachable target must preserve
slot coherence end to end — an AT-key write that silently no-ops is a doctrine violation, worse than an
honest skip.

## Task — reproduce-first

1. Reproduce at tip via dual-run: the probe above; also the computed READ (`re['lastIndex']` after a
   dot-write — oracle serves the written value), delete/`in` corners (honest-skip acceptable), and a
   fresh `exec`-interaction variant (`var re=/a/g; re['lastIndex']=0; re.exec('aa').index` class —
   verify against the oracle, transliterate semantics from `c/moddable/xs/sources/xsRegExp.c`, never
   guess).
2. Fix: route the AT-key (computed string key) property write on RegExp instances into the same
   side-table path as the dot form, for `lastIndex` and any other side-table-backed RegExp instance
   property the audit surfaces. If a corner cannot be made coherent, make it an HONEST skip
   (`Unsupported`), never a silent stale read.
3. Gate tests (dual-run agreement) for write-then-dot-read, dot-write-then-computed-read,
   computed-write-then-exec.

## Discipline

Push-per-item; full bars on every pushed engine change with measured numbers at the pushed tip
(workspace GROWS from 943/0 at `139b8561f1` + child 0's gates; compile-diff 1909/1909 + SYMB; boot 30/0;
ROOT 111/0; 0 non-oracle warnings; no new `unsafe`; no new side table — extending an EXISTING RegExp
side table is fine, ADDING a new one must be snapshot-ledgered the same day). Accuracy-over-parity.
One 2400s invocation; tada ONLY; keep PR DRAFT.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 6
  worker_kind: gardener
  claimed_at: 2026-07-20T09:40:10Z
