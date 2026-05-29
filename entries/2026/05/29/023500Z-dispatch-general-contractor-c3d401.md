---
ts: 2026-05-29T02:35:00Z
kind: dispatch
role: general-contractor
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
worktree: dispatches/fixer--00df9b
refs:
  - jobs/claimed/20260529T022628Z--endolinbot--general-contractor--e7a0--234bf0--summary-fix-343.md
  - contractor-slots/endolinbot/slot-1.md
---

# Dispatch fixer on PR #343 — design summary-fix bundle (job 234bf0)

Cycle 3 of the 2026-05-29 re-adoption. Slot-1 claims job `234bf0`
(`summary-fix-343`, posted 2026-05-23T00:44:57Z by solicitor on
endolinbot) and dispatches a fixer to address the four-item bundle on
design PR #343.

## Subject

PR [endojs/endo-but-for-bots#343](https://github.com/endojs/endo-but-for-bots/pull/343)
`design(gateway): gateway-package.md` — a design PR (no code), branch
`design/gateway-package`, head `ba4c81236`, base
`llm-b1c3f4d` (frozen base per the 2026-05-22 convention).
reviewDecision=CHANGES_REQUESTED from the panel; PR is un-drafted; the
bundle is post-un-draft cleanup on the design markdown.

## Worktree triple

- `DISPATCH_ROOT=/home/kris/dispatches/fixer--00df9b`
- `project/` at `ba4c81236` (origin/design/gateway-package)
- `garden/` detached at main
- `journal/` detached at cycle-3 journal HEAD

## Bundle (four items, design prose; full body in claimed job)

1. **critic** — delete the orphaned `setVirtualHostAllocationPolicy` method + `AllocationPolicy` type from `designs/gateway-package.md:630-631, 862` (OQ3's resolution made them moot). Clean-delete is the lower-risk option.
2. **critic + copyeditor** — fold the OQ5 contradictory paragraphs at `:1115-1130` into one paragraph (or delete the obsolete pre-fix sentence).
3. **ergonomist** — at Feature 2 `bind('chat', ...)` example (lines 243-310), add the alias-vs-identifier clarifying sentence between lines 293-294.
4. **novice** — OQ7 (`:1137-1154`): add one consequence-naming sentence between the lede and the phase-1 mechanics paragraph.

## Authorizations

Per the claimed job: `identity_switch: false`, `comment_repos: []`.
The fixer's push to the design branch is implicit per role norms. No PR
comments or reactjis carried. No title edit. No `gh` mutations beyond
the implicit branch push.

## Expected report

A `result` entry naming the new head SHA on `design/gateway-package`,
per-item commit mapping, prose-style verification (no em-dashes per
em-dash-style; relative paths per relative-paths), and a one-line
Self-improvement.
