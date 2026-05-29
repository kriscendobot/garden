---
ts: 2026-05-29T22:00:00Z
kind: result
role: liaison
host: endolin
project: garden
refs:
  - inboxes/endolin/scholar.md
  - library/sources/endo-but-for-bots--llm-designs-chat-rename-dismiss-to-clear.md
---

# liaison cycle 95 result — chat-rename-dismiss-to-clear ingest (single-section)

Chat-lane ingest (cycle 95, **twentieth chat-cluster source**, per the three-lane rotation after cycle 94's papers-lane OCPL ingest).

Ingested `endojs/endo-but-for-bots: designs/chat-rename-dismiss-to-clear.md` at file-specific commit `8e5058304b08a4ec590a8bdcc799f78b321d5726` (last touched 2026-05-20 by endolinbot, on `origin/llm`). Status: **Complete** (PR #93, merged 2026-05-06).

**Single-section ingest**: `rename-decision-record` — captures the entire 75-line document as a unified PR-merge decision record + post-implementation retrospective. The document's four subsections (Status with bullet points; Roadmap calibration; Motivation; Changes) collapse to one coherent argument cluster — *rename dismiss-all to clear with deprecation-period CLI alias*.

Three structurally interesting features beyond the rename itself:

1. **Deprecation-period CLI alias** — `.command('clear').alias('dismiss-all')` in `packages/cli/src/endo.js`; `clear-command.test.js` regression-tests the alias. The pattern: rename a user-facing name, keep the old name as a hidden alias during deprecation.

2. **Chat-vs-CLI alias asymmetry** — the chat side does *not* retain an alias because the command had not shipped on the chat side pre-rename. **Minimal-deprecation-surface discipline**: add alias only where there are existing users to migrate. The CLI gets the alias; chat doesn't.

3. **Roadmap calibration via git-blame** — the §Roadmap subsection performs *post-merge introspection* via git-blame on `llm`, finding a 65-calendar-day active-development window with *three brief implementation bursts separated by long unattended gaps* (Burst 1 chat-side 2026-03-17; Burst 2 CLI-side 2026-03-20; Burst 3 alias+merge 2026-05-06). The calibration discipline makes *cycle-time* visible for future planning.

A fourth structural observation: **internal-vs-external naming separation** — the underlying daemon power remains `dismissAll()`. The user-facing command name changes; the internal API method name does not. Two layers with separate evolution constraints.

## Pick rationale

Per cycle 94 notes-for-next-cycle, chat-lane candidates were:
- `chat-rename-dismiss-to-clear` (75 lines, Complete; *single-section candidate as PR-merge decision record*).
- `chat-reply-chain-visualization` (502 lines, Deprecated — superseded by chat-focus-message; design-rationale-history candidate).

**chat-rename-dismiss-to-clear was the cohesion-honest pick** for a single-section ingest. The 75-line document is conceptually unified (one rename + its deprecation surface + its retrospective) and best captured as a single section. The cycle-94 notes anticipated this — *single-section candidate as PR-merge decision record*.

`chat-reply-chain-visualization` (502 lines, Deprecated) is the obvious next chat-lane candidate when the rotation returns; the Deprecated-status warrants a separate cycle.

## Three drafting-lessons confirmed

1. **Source-slug duplicate-check (cycle 89's standing discipline)** — `ls library/sources/ | grep "rename-dismiss\|dismiss-to-clear"` confirmed no prior ingest.
2. **Cohesion-honest section count** — 75 lines, four subsections, one unified subject → one section. Cycle 95 is the **second single-section ingest in the chat cluster**; cohesion-over-density discipline supports 1, 2, or 3 sections depending on source.
3. **Bare-clone verification with branch-family awareness** (cycle 92 discipline) — `chat-rename-dismiss-to-clear` was on `origin/llm/designs/`, not `origin/design/chat-*`. Confirmed via cycle-92's chat-branch-discovery.

## Library state after cycle 95

- Sources: 141 (was 140) — adds chat-rename-dismiss-to-clear.
- Sections: 591 (was 590) — adds 1 section.
- Topics: 27 (unchanged) — threading into chat-ui (55 → 56) and repository-governance (48 → 49).
- Concepts: 44 (unchanged).
- Keywords: ~2225 (was ~2200) — added ~25 aliases tied to this document's vocabulary.

## Cross-source linkage

The chat-rename-dismiss-to-clear ingest complements cycle 92's chat-test-coverage:
- **chat-test-coverage** (cycle 92) — broader test-suite inventory; mentions `clear-command.test.js` indirectly via the test-organization layout.
- **chat-rename-dismiss-to-clear** (this cycle) — the specific PR that *added* `clear-command.test.js` as part of the alias-preservation regression.

The deprecation-period-alias pattern complements cycle 88's *ACLs Don't* (Tyler Close) §2.7 *capability-applications-can-recreate-ACL-vulnerabilities* warning — both papers emphasize *intentional-deprecation-surface discipline*: maintain compatibility deliberately and explicitly, not by accident.

## Notes for next cycle (96)

Three-lane rotation pointer advances to **comments-lane**.

Future comments-lane candidates per cycle 93 notes:
- `packages/ses/src/error/console.js` (541 lines / 212 comments / 39% — strong candidate; the causal-console core).
- `packages/ses/src/error/assert.js` (604 lines / 199 comments / 32%; the assert + Fail + X primitives).
- `packages/ses/src/error/unhandled-rejection.js` (122 lines / 50 comments / 40%; small + high density).
- `packages/ses/src/error/tame-console.js` (197 lines / 49 comments / 24%; moderate density).
- `packages/exo/src/exo-makers.js` / `packages/patterns/src/keys/checkKey.js` / `packages/marshal/src/marshal-justin.js` (verified present; lower density).

Future paper-lane candidates after cycle 97 (which would be papers-lane):
- *Incentive Engineering for Computational Resource Management* (Miller/Drexler; 608 KB).
- *Comparative Ecology: A Computational Perspective* (Huberman/Hogg; 455 KB).
- *How Emily tamed the Caml* (Stiegler-Miller 2006; HPL-2006-116; needs URL probe).
- *Robust Composition* (Miller PhD 2006) — multi-cycle plan still pending.

Future chat-lane candidates:
- `chat-reply-chain-visualization` (502 lines, Deprecated — superseded by chat-focus-message; design-rationale-history candidate).
- Watch `origin/design/chat-*` and `origin/llm/designs/chat-*` for new merges.
