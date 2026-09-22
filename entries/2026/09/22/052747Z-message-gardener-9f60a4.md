---
kind: message
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-09-22T05:27:52Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/1317

# Dependabotany ledger: endojs/endo-but-for-bots — 2026-09-22 recheck sweep

Recovered the cumulative case-insensitive ledger and re-fetched live GitHub state (base `llm`).

## Active due embargo rows

**None.** Every explicit embargo row is terminal on live GitHub:

- https://github.com/endojs/endo-but-for-bots/pull/197 (`EMBARGO-2026-05-31`) — MERGED.
- https://github.com/endojs/endo-but-for-bots/pull/362 (`EMBARGO-2026-06-30`) — CLOSED (superseded by later all-minor-patch group).
- https://github.com/endojs/endo-but-for-bots/pull/868 (`EMBARGO-2026-07-31`) — MERGED.
- https://github.com/endojs/endo-but-for-bots/pull/923 (`EMBARGO-2026-08-10`) — CLOSED (superseded).
- https://github.com/endojs/endo-but-for-bots/pull/1005 (`EMBARGO-2026-08-21`) — CLOSED (superseded).
- https://github.com/endojs/endo-but-for-bots/pull/1093 — MERGED.
- https://github.com/endojs/endo-but-for-bots/pull/1168 (`EMBARGO-2026-09-06`) — MERGED.

## PR #1317 — MERGE-NOW conducted (executed)

The sole open Dependabot PR at sweep time was #1317 (`all-minor-patch` group, 19 updates), base `llm`. It carried **no** embargo ledger row: a full botanist MERGE-NOW verdict was rendered 2026-09-20, the maintainer said "Please conduct," but the follow-up ran as a **plain conductor `merge` job** and stalled on the maintainer-approval gate (it did not pass the botanist `--dependabot-auto-merge` opt-in); its dedicated review job was doomed (requeue-exhausted) and its merge orchestration halted. #1317 was thus orphaned and stuck open.

Re-verified the standing MERGE-NOW verdict against **live** state, then executed it:
- **Maturity floor past.** Freshest moved version `js-yaml@5.4.2` published `2026-09-13T00:15:39Z` (re-confirmed vs npm registry; nothing newer in the 19-update set). Floor `2026-09-20T00:15:39Z` — passed. No 24h-fresh version.
- **Advisories clean both sides.** OSV (npm) re-queried for every incoming version incl. `happy-dom@20.14.5` (clear of the historical `<20.0.0` VM-escape CRITICAL): zero advisories.
- **CI green** on head `3dac3709e82e38ad41f3406691a85227543960b2`: 27 SUCCESS / 8 SKIPPED / 0 failed (`check-runs total_count=35`); prior `test (24.x, ubuntu)` flake now green. `MERGEABLE`/`CLEAN`.
- **Head 1 ahead / 0 behind live `llm`** — no rebase; accepted the already-green CI directly.

**Executed via `ci-wait-merge.sh --dependabot-auto-merge`** (author `dependabot[bot]` + bot-owned-repo scope → approval-bypass). Merged into `llm` at `2026-09-22T05:26:17Z` as `2d0f7fb7f06dc09b6277aae1e9e9bdaab26dacb8`. Verdict/confirmation comment: https://github.com/endojs/endo-but-for-bots/pull/1317#issuecomment-5771638498

## Schedule and disposition

Daily backstop `dependabotany-recheck-endo-but-for-bots` remains installed. No embargo row remains, so no per-PR one-shot exists or is needed. After the merge there are **zero** open Dependabot PRs on the repo.

Follow-up: the doomed parked job `jobs/plan/endojs-endo-but-for-bots-pr1317-dependabot.md` (gate `go-ahead`, `doomed: true`) is now moot (#1317 merged); it is inert (doomed jobs are never promoted) and left in place.

Self-improvement: the stuck-#1317 pattern — a botanist MERGE-NOW that got handed to a **conductor** `merge` job (which cannot use `--dependabot-auto-merge`) instead of being conducted by the **botanist** — is worth guarding against; a dependabot MERGE-NOW should be conducted by a botanist-role job, not routed to a generic merge.
