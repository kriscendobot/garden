---
kind: message
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-19T02:17:07Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots

# Dependabotany ledger: endojs/endo-but-for-bots — 2026-08-18 daily backstop sweep

Daily backstop job `dependabotany-recheck-endo-but-for-bots-20260818-170501`
(dispatched 2026-08-18T17:05Z; carried across several reaper requeues, so this
sweep was executed against live state 2026-08-19T00:00–02:20Z). Recovered the
cumulative ledger with the required case-insensitive heading match
(`grep -rl '^project: endo-but-for-bots$' entries/ | xargs grep -il '^# *dependabotany'`)
and reconciled every open Dependabot PR + due ledger row against live GitHub,
base-ref, advisory, source-maturity, schedule, and CI state. **This was NOT a
quiet day**: a fresh batch of Dependabot PRs (endojs/endo-but-for-bots#1005–#1009,
#1037) landed on 2026-08-16 evening; #1006's dedicated botanist job had been
**doomed** on 2026-08-16 without a verdict, so this backstop recovered it.

## Terminal / confirmed rows

- **endojs/endo-but-for-bots#923** (`all-minor-patch`, 36 updates) — REJECT (stale
  group), CLOSED 2026-08-10T21:25:33Z. Re-verified terminal (`state=CLOSED`,
  `mergedAt=null`). No residue.
- **endojs/endo-but-for-bots#1005** (`all-minor-patch`, 44 updates; prior
  EMBARGO-2026-08-21) — **now terminal: CLOSED 2026-08-19T00:07:24Z**, superseded
  by Dependabot's regenerated group endojs/endo-but-for-bots#1037 (opened
  00:08:26Z). Its embargo is moot. **Residue:** the precise one-shot
  `schedules/dependabotany-recheck-endo-but-for-bots-pr1005.md` (fire
  2026-08-21T11:15:00Z) is now stale — it will fire against a CLOSED PR, render a
  terminal no-op, and self-delete. Left in place (no manual journal mutation),
  consistent with prior residue-handling; harmless.
- **endojs/endo-but-for-bots#1037** (`all-minor-patch`, 43 updates; the #1005
  successor) — **MERGED into `llm` 2026-08-19T01:07:34Z** by its own dedicated
  botanist job (`endojs-endo-but-for-bots-pr1037-dependabot`). Not a row this
  backstop owns; noted because it is the #1005 supersessor and its merge is why
  #1006's original head conflicted.

## Active embargo (not due — one-shots verified placed)

- **endojs/endo-but-for-bots#1007** `@octokit/core` 3.6.0 → 7.0.7 —
  **EMBARGO-2026-08-21** (floor 2026-08-21T01:20:34Z from newly-introduced
  transitive `json-with-bigint@3.5.11`). OPEN; precise one-shot
  `dependabotany-recheck-endo-but-for-bots-pr1007` correctly placed at
  2026-08-21T02:15:00Z (floor ceil-to-hour + 15m). Not due; no action. `@octokit/core`
  is a dev-only devDependency imported nowhere, so the outgoing low-ReDoS advisories
  it clears do not qualify for the CVE-now exception (per the 2026-08-16 review).

## MERGE-NOW rendered; execution blocked on the fleet node24-runner CI flake

Both are one green CI run from merge; both are blocked by the **recurring
fleet-wide node24-runner infra flake** (`.../externals/node24/bin/node: No such
file or directory`) plus a severe CI-queue backlog. Escalated to the maintainer
(inbox `20260819T021547Z-7f9907`): merge both directly (`llm` has no branch
protection, so the flake is a non-required check) or fix the runner.

- **endojs/endo-but-for-bots#1006** `eslint-plugin-unicorn` 72.0.0 → 73.0.0
  (dev-only lint plugin). **Verdict MERGE-NOW** — full diligence: only unicorn moved
  in the lockfile (no transitive movement, deps ranges identical), 73.0.0 published
  2026-08-04 (mature, 14d, floor 2026-08-11), OSV-clean both sides, publisher
  `sindresorhus` unchanged, no install script (`hasInstallScript` null, no `bin`),
  major-bump ruleset change breaks no repo lint (lint check green). Verdict comment
  https://github.com/endojs/endo-but-for-bots/pull/1006#issuecomment-5331568230.
  I **rebased it clean** onto live `llm` (the #1037 merge had introduced a
  package.json conflict; the resolution was mechanical — re-apply `^73.0.0` +
  regenerate `yarn.lock` lockfile-only): head `86b6b4f9913`. A full run was 24/25
  green, sole red the node24 flake on `test (24.18.0, macos-15)` (green on base;
  unicorn runs only at lint time → not a regression). Conduct attempted repeatedly
  via `ci-wait-merge.sh --dependabot-auto-merge`; blocked (see above). Update comment
  https://github.com/endojs/endo-but-for-bots/pull/1006#issuecomment-5336697105.
- **endojs/endo-but-for-bots#1009** `npm-packlist` 10.0.4 → 11.3.0 (root
  devDependency). **Verdict MERGE-NOW on merits** (established 2026-08-16; mature,
  advisory-clean, consumer test 18/18). Sole red is the identical node24 flake on
  `test (24.x, ubuntu-latest)`. Head is ~65 behind and needs a rebase (fresh full
  CI → re-rolls the flake). Same standing escalation as 2026-08-16.

## Schedule state

- Daily backstop `dependabotany-recheck-endo-but-for-bots` present and retained —
  the standing net that will re-sweep #1006, #1007, and #1009 until terminal.
- Precise one-shots present: `-pr1007` (2026-08-21T02:15Z, live embargo) and
  `-pr1005` (2026-08-21T11:15Z, now stale — see #1005 above).
- Paused residue `dependabotany-recheck-endo-but-for-bots-pr868` remains inert in
  `paused-schedules/` (cannot fire); left for a future journal-maintenance pass.

## Fleet-defect note

The node24-runner flake now blocks a **third** and **fourth** dependabot PR
(#1006, #1009) beyond the arc first escalated 2026-08-16. It is the single highest-
leverage CI-infra fix for this repo's dependabot throughput; the maintainer
escalation asks for a direct-merge or a runner fix. No self-improvement change to
the botanist library this pass — the role already prescribes escalate + backstop
for a fleet-wide operational blocker, which is exactly what was done.
