---
role: weaver
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-22T16:25:03Z -->

# Restack PR #702 (SturdyRef bridge cut 4, ocapn identity singleton) onto the restacked #700

Repo: endojs/endo-but-for-bots. PR: https://github.com/endojs/endo-but-for-bots/pull/702
(head `build/sturdyref-bridge-4-ocapn-singleton`, base `build/sturdyref-bridge-3-daemon-mint-export`).

Context: the maintainer-arbitrated restack (kriskowal on #737, 2026-07-22T06:27Z) moved the
sturdyref stack to llm ← #774 ← #737 ← #541 ← #698 ← #700. The #541/#698/#700 restack
completed 2026-07-22 ~14:35Z (#700 head `0a2d989961`). Bridge cuts 3–6 (#701–#704) were NOT
part of that orchestration and still sit on the pre-restack line (compare shows #702
stale: its base branch is being moved by the predecessor child of this orchestration). Re-verify all SHAs live at claim time — states drift.

Task (weaver):
1. Verify the predecessor landed: `build/sturdyref-bridge-3-daemon-mint-export` head descends
   from `build/sturdyref-bridge-1-bytes-wire-read`'s restacked head. Identify #702's OLD
   merge-base (the old bridge-3 tip its own commits sit on) — e.g. via
   `git merge-base` / `git range-diff` — so the rebase carries ONLY #702's own commits.
2. `git rebase --onto origin/build/sturdyref-bridge-3-daemon-mint-export <old-base>
   build/sturdyref-bridge-4-ocapn-singleton` in an ISOLATED project worktree keyed by
   THIS job's base (`scripts/jobs/ensure-project-worktree.sh <base> endojs/endo-but-for-bots
   build/sturdyref-bridge-4-ocapn-singleton`).
3. Resolve conflicts TOWARD the arbitrated shapes now in the base: the standalone
   `@endo/sturdyref` package is the shim/minting home (not `@endo/pass-style`'s removed
   duplicate); accessor is `getSturdyRefLocator` (returns `{location, secret}`, the old
   `getSturdyRefDetails` is gone); camelCase `'sturdyRef'` discriminator; lowercase OCapN
   vocab; marshal rank prefix `l` (locator) between number `f` and remotable `r`; closely-held
   reveal rides the shim (`fromLocation`/`toLocation`).
4. GitHub base unchanged (it already names bridge-3). Push `--force-with-lease`; keep DRAFT;
   comment the new head + test evidence on #702.
5. CONFINEMENT TESTS ARE LOAD-BEARING: keep the sturdyref confinement suites green
   (opaque SturdyRef — no location/secret readable; no toString URI leak; closely-held
   reveal off the surface; unlinkability) plus cut 4's own ocapn-singleton
   tests. Real-execution evidence required (command + observed output). If daemon
   integration tests cannot start here (known env gap: better-sqlite3 native binding;
   /tmp is noexec — run ava via `node <store>/ava.../entrypoints/cli.js` with any shim
   placed under home), report exactly which suites ran and which were blocked and why.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 21
  worker_kind: cleric
  claimed_at: 2026-07-22T16:25:08Z
