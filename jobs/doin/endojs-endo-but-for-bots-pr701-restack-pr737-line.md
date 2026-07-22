---
role: weaver
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-22T16:13:03Z -->

# Restack PR #701 (SturdyRef bridge cut 3, daemon mint/export) onto the restacked #700

Repo: endojs/endo-but-for-bots. PR: https://github.com/endojs/endo-but-for-bots/pull/701
(head `build/sturdyref-bridge-3-daemon-mint-export`, base `build/sturdyref-bridge-2-ocapn-promotions`).

Context: the maintainer-arbitrated restack (kriskowal on #737, 2026-07-22T06:27Z) moved the
sturdyref stack to llm ← #774 ← #737 ← #541 ← #698 ← #700. The #541/#698/#700 restack
completed 2026-07-22 ~14:35Z (#700 head `0a2d989961`). Bridge cuts 3–6 (#701–#704) were NOT
part of that orchestration and still sit on the pre-restack line (compare shows #701
diverged: behind_by 426 vs its base). Re-verify all SHAs live at claim time — states drift.

Task (weaver):
1. Verify the predecessor landed: `build/sturdyref-bridge-2-ocapn-promotions` head descends
   from `build/sturdyref-bridge-1-bytes-wire-read`'s restacked head. Identify #701's OLD
   merge-base (the old bridge-2 tip its own commits sit on) — e.g. via
   `git merge-base` / `git range-diff` — so the rebase carries ONLY #701's own commits.
2. `git rebase --onto origin/build/sturdyref-bridge-2-ocapn-promotions <old-base>
   build/sturdyref-bridge-3-daemon-mint-export` in an ISOLATED project worktree keyed by
   THIS job's base (`scripts/jobs/ensure-project-worktree.sh <base> endojs/endo-but-for-bots
   build/sturdyref-bridge-3-daemon-mint-export`).
3. Resolve conflicts TOWARD the arbitrated shapes now in the base: the standalone
   `@endo/sturdyref` package is the shim/minting home (not `@endo/pass-style`'s removed
   duplicate); accessor is `getSturdyRefLocator` (returns `{location, secret}`, the old
   `getSturdyRefDetails` is gone); camelCase `'sturdyRef'` discriminator; lowercase OCapN
   vocab; marshal rank prefix `l` (locator) between number `f` and remotable `r`; closely-held
   reveal rides the shim (`fromLocation`/`toLocation`).
4. GitHub base unchanged (it already names bridge-2). Push `--force-with-lease`; keep DRAFT;
   comment the new head + test evidence on #701.
5. CONFINEMENT TESTS ARE LOAD-BEARING: keep the sturdyref confinement suites green
   (opaque SturdyRef — no location/secret readable; no toString URI leak; closely-held
   reveal off the surface; unlinkability) plus cut 3's own daemon mint/export/swiss-num
   tests. Real-execution evidence required (command + observed output). If daemon
   integration tests cannot start here (known env gap: better-sqlite3 native binding;
   /tmp is noexec — run ava via `node <store>/ava.../entrypoints/cli.js` with any shim
   placed under home), report exactly which suites ran and which were blocked and why.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 16
  worker_kind: cleric
  claimed_at: 2026-07-22T16:13:08Z
