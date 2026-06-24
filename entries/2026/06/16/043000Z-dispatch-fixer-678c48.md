---
ts: 2026-06-16T04:30:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--678c48
prs:
  - repo: endojs/endo-but-for-bots
    pr: 435
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/435
  - https://github.com/endojs/endo-but-for-bots/pull/435#discussion_r3418021461
---

# dispatch: fixer — reply to erights' JSC/SpiderMonkey version question on PR #435

erights left ONE follow-up inline comment on PR #435 after his original 29-comment CHANGES_REQUESTED review (which fixer 32650e fully addressed). The follow-up is at `packages/immutable-arraybuffer/src/lib.js:83` (review id 4503137227, 2026-06-16T04:00:26Z):

> @kriscendobot , what versions of JSC and SpiderMonkey have neither `structuredClone` nor `ArrayBuffer.prototype.transfer`?

The question is about the rationale for the polyfill fallback chain at lib.js:83 — specifically whether there are still-shipping JSC (Safari/iOS) or SpiderMonkey (Firefox) versions that lack BOTH `structuredClone` and `ArrayBuffer.prototype.transfer`. If neither exists in any supported browser version, the fallback may be dead code.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#435`, head `9926e4187` (post fixer 32650e).

## Task

In your `project/` worktree at `9926e4187`:

1. Read `packages/immutable-arraybuffer/src/lib.js` around line 83 to understand the context of the fallback being asked about.
2. Research the exact ship dates:
   - `structuredClone` — first JSC/Safari version, first SpiderMonkey/Firefox version.
   - `ArrayBuffer.prototype.transfer` — first JSC/Safari version, first SpiderMonkey/Firefox version.
   - Compare to the project's stated baseline (probably "current evergreen browsers" or a specific Safari/Firefox min version).
3. Determine: is the fallback dead code (every supported browser has at least one)? Or is there a still-shipping browser that needs it?
4. Reply to the inline thread (using the PR review thread API per `garden/skills/pr-review-thread-replies/SKILL.md`) on discussion r3418021461 with the answer:
   - Either: "Both are in baseline X+; fallback is defensive against future-X or pre-baseline outliers." (and propose dropping it if dead).
   - Or: "Safari N (released DATE) lacks transfer; fallback covers users until Safari N+1." (with concrete version data).
5. If the answer is "fallback is dead code", optionally remove the fallback in a small commit.
6. Push if any commit (append only).
7. Post the inline reply.

## Authorizations

- Append-push.
- Inline reply on review thread r3418021461.
- Do NOT touch upstream endojs/endo.

## Out of scope

- Do NOT re-open the prior 29 asks (all addressed).
- Do NOT touch unrelated files.

## Deliverable

A `result` entry under `journal/entries/2026/06/16/` naming:

- The version-research findings.
- Whether the fallback is dead code or defensively useful.
- The inline reply URL.
- Any commit SHA (if dead-code removal applied).
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: liaison` (erights re-reviews).

End your turn with a concise summary back to the orchestrator. This is a 5-10 min job.
