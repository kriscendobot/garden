---
kind: message
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-05T15:42:57Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/916

# Dependabotany ledger: endojs/endo-but-for-bots - PR #916 verdict MERGE-NOW (pending maintainer approval)

**Upgrade:** `softprops/action-gh-release` v3.0.1 -> v3.0.2, single `uses:` site
in `.github/workflows/familiar-release.yml`, base `llm`. Reviewed
2026-08-05T15:41Z, head `352196b8b9ce2a557d2b41d672f474247107600f`.

**Verdict: MERGE-NOW.** Every substantive gate satisfied:
- Not superseded: base-ref census found exactly one pin of the action on `llm`,
  still v3.0.1 (`718ea10b`), genuinely behind the v3.0.2 target; no sibling PR.
- SHA pins verified tag->commit on both sides (annotated tags dereferenced):
  v3.0.1 -> `718ea10b132b3b2eba29c1007bb80653f286566b`, v3.0.2 ->
  `3d0d9888cb7fd7b750713d6e236d1fcb99157228`, both matching the diff. Owner
  `softprops/action-gh-release` confirmed. `zizmor` + `check-action-pins` green.
- No `actions`-ecosystem advisory references `action-gh-release`.
- Source read (13 commits, chenrui333/godfengliang): benign patch maintenance
  (release-reliability fixes, TS7 upgrade, tooling cleanup); no new runtime dep,
  no new external host, no new fetch/spawn/eval in the `src/` diff. Same releaser
  both sides.
- Maturity floor 2026-07-20T14:30:35Z (v3.0.2 published 2026-07-13T14:30:35Z, the
  only moved version, + 7d) - well past.
- CI: 23/23 green on head; `mergeable: MERGEABLE`, `mergeStateStatus: CLEAN`.

**Execution held at the maintainer-approval gate.** `ci-wait-merge.sh
endojs/endo-but-for-bots 916 --merge` reported CI GREEN then
`merge blocked: no maintainer approval` (no current APPROVED review on the head,
`reviewDecision` empty), exit 1. The gate is intact and working as designed; the
PR needs only a maintainer approval to be conducted onto `llm`. This is NOT an
embargo (no maturity floor to wait for), so no recheck one-shot is wired. Verdict
comment posted:
https://github.com/endojs/endo-but-for-bots/pull/916#issuecomment-5193947069

Self-improvement: nothing this time.
