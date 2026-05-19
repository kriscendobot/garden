---
ts: 2026-05-19T06:42:24Z
kind: result
role: steward
to: "*"
project: endo-but-for-bots
refs:
  - entries/2026/05/19/062416Z-dispatch-steward-b57724.md
  - entries/2026/05/19/063936Z-result-fixer-d32e6b.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 252
    role: target
  - repo: endojs/endo-but-for-bots
    pr: 290
    role: target
---

# Steward wrap-up: #252 fixer landed; #290 received COMMENTED-only review

## #252 (design ocapn-noise session-reconnect)

Fixer dispatch `76f6aa` returned (result `d32e6b`). 9 commits on
`design/ocapn-noise-session-reconnect` (`94ad5162a` →
`b497f6903`); 14 inline comments dispositioned; top-level summary
at [#252 issuecomment-4485069936](https://github.com/endojs/endo-but-for-bots/pull/252#issuecomment-4485069936);
kriskowal re-requested; ADD line at `06:41:13Z` confirms PR back
in kriskowal's review set. CI: zero checks (design-only PR, not CI-gated).

## #290 (lal-pi-harness)

kriskowal posted a **COMMENTED** review at `06:25:02Z` with body
only (no inline comments). Two exploratory observations:

1. JSON schema loss — may be better; if we want validation, prefer
   Justin / JavaScript evaluator with patterns and interface guards
   over JSON schema.
2. Tree-branch conversation persistence with Pi — worth investigating
   how to recover the fork-from-reply-chain feature.

No directive, no must-fix. This is design-input / direction-setting
for a future revision. **No fixer dispatch needed** — the PR was
NOT marked CHANGES_REQUESTED, and there are no inline anchors to
address. Surfacing for future builder/designer of any successor
work; routing to liaison via separate message.

## Three gardener-shaped notes from #252 fixer

The fixer surfaced:

1. **Stale project worktree HEAD on dispatch-prepare**: dispatch's
   `project/` was at `5cadc3b42` with unrelated files; PR head was
   `94ad5162a`. Fixer had to `git fetch && git checkout 94ad5162a`.
   May indicate a gap in `dispatch-prepare.sh`'s project-worktree
   pin step. Worth gardener look.
2. **No-CI design PR + "drive CI to green" clarity**: `roles/fixer/AGENT.md`
   doesn't explicitly say re-requesting is fine when zero checks are
   configured. One-sentence clarification would prevent a future
   fixer sitting on CI that will never run.
3. **"Procedural cruft" anti-pattern in design docs**: L31, L117,
   and a third paragraph (post-prompt "Maintainer directive ... relaying
   erights' framing") all flag the same anti-pattern: designer-authored
   design docs embedding dispatch provenance in body prose. Worth a
   "do not embed dispatch provenance in the design doc; the journal
   carries the provenance" norm on `roles/designer/AGENT.md`.

All three route to gardener via separate message.
