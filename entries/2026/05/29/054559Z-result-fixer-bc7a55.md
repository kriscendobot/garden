---
ts: 2026-05-29T05:45:59Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
refs:
  - entries/2026/05/29/053900Z-result-steward-a0b1c2.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 377
    role: opened
  - repo: endojs/endo
    pr: 3291
    role: mirror-source
---

# result: fixer opened #377 mirroring endojs/endo#3291

Bot-side mirror PR for upstream's esvu retry fix.

## Outcome

Opened **endojs/endo-but-for-bots#377** as DRAFT against `master-c49fb04`.

- URL: https://github.com/endojs/endo-but-for-bots/pull/377
- Head branch: `fix-benchmark-install-engines-retry`
- Head SHA: `f43996e071fd413c2dce697cdee18e9cec542fb8`
- Upstream commit cherry-picked (hand-applied via `git apply`): `44b80546d6b714d559e92436821e0ab33e353093` from endojs/endo#3291
- Patch applied cleanly. Bot's `packages/benchmark/install-engines.sh` matched upstream's pre-patch shape modulo the two whitespace fixes the upstream commit also picked up (trailing space on `set -e` and on the `INSTALL_STATUS_XS` test line); no manual fixups needed.

## Commits

1. `f43996e07` — `fix(benchmark): retry esvu installs in install-engines.sh`
   - One atomic commit; body mirrors upstream commit message verbatim, prefixed with a "Mirror of endojs/endo#3291" line.
   - `Co-Authored-By: Kris Kowal <kriskowal@kriskowal.com>` for attribution to the upstream author.
   - Touches `packages/benchmark/install-engines.sh` (the patch) and `.changeset/retry-esvu-installs.md` (single-line `@endo/benchmark: patch` bump per `.changeset/` convention).

## Gates

`pre-push-gates --probes-only --summary` passed all 7 deterministic probes before the push.

## PR body shape

Followed `skills/pr-formation/SKILL.md` and the upstream PULL_REQUEST_TEMPLATE.md section-for-section. Body cites endojs/endo#3289 as the upstream issue under `Refs:`, cites endojs/endo#3291 as the source PR being mirrored, notes the two fork-side CI failures (#79 test-xs V8, #375 test-xs XS) the retry addresses, and notes in passing the meta-irony that #3291's own CI test-xs job is failing on the same signature (the fix cannot yet bootstrap itself). No checklist, no file callouts beyond the API-shape mentions necessary for the diagnostic-preservation point, no methodology leak.

## Authorization adherence

- Pushed `fix-benchmark-install-engines-retry` to `endojs/endo-but-for-bots`. (Per-action authorized.)
- `gh pr create` on `endojs/endo-but-for-bots` as DRAFT. (Per-action authorized.)
- No comment on upstream #3291 (correctly out of scope; that routes through the boatman).
- No un-draft (correctly out of scope; cleaner / barrister / justice chain follows).

## Next stage

The DRAFT PR is ready for the gauntlet's cleaner / barrister / justice chain. Per the builder-opened-DRAFT-auto-runs-gauntlet maintainer feedback (`feedback_builder_pr_auto_run_gauntlet.md`), the steward's per-cycle survey should pick #377 up as an orphan DRAFT and dispatch the chain; no need to thread it manually.

Self-improvement: nothing this time. The fixer's mirror-an-upstream-PR shape was straightforward; the only mild surprise was that the upstream PR included two whitespace-only fixes (trailing-space cleanups) that the bot's copy of `install-engines.sh` also had, so the patch applied with no hunks rejected. Worth confirming next mirror that the bot copy is similarly close to upstream before assuming a clean apply.
