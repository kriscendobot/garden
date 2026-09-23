# Job report: refresh endojs/endo-but-for-bots #331

Directive (kriskowal, [comment 5112058161](https://github.com/endojs/endo-but-for-bots/pull/331#issuecomment-5112058161)): refresh, anchor the base on an `llm-xxxx` frozen branch, and check for duplication in another PR.

## Refresh (done, verified)

- Created frozen base `llm-9cfa1f0`, a snapshot of `llm` at `9cfa1f08fc`, per `skills/frozen-base-branch`.
- Rebased head `design/endor-npm-registry-capability` from `adeeb6711a` to `005f12e9e9`. Clean, no conflicts. Force-with-lease pushed.
- Moved the PR base from `llm` to `llm-9cfa1f0`. Final state observed: `base=llm-9cfa1f0 state=OPEN draft=true mergeable=MERGEABLE`.
- Net diff unchanged and still two files: `designs/endor-npm-registry-capability.md` (+670) plus one index row in `designs/README.md`.
- **CI verified green** on `005f12e9e9`: `build`, `lint`, `test`, `browser-tests`, `copilot-setup-steps`, `zizmor`, dependabot all pass (`gh pr checks 331`, output observed after convergence).

## Duplication check

**Not a duplicate by file or branch.** Swept all 640 remote branches and full history for `designs/endor-npm-registry-capability.md`: exactly one branch, one commit, this PR's. No other PR open or closed adds it.

**Real subject overlap with something already merged.** `designs/registry-capability.md` landed on `llm` via #358/#659 on 2026-06-02, twelve days after #331 opened. Both read as "a registry capability for npm resolution over the CAS". They are complementary, and the merged doc says so: its § Anti-design steers explicitly defers the credentials lane ("Considered and rejected: per-host credential capability... a separate design that will land when the public-only constraint becomes binding") and keeps `@registry` open for "a future multi-tenant credentials lane". #331 is exactly that lane (non-extractable credentials, identity pinning, `readOnly()`/`offline()` attenuations, `RegistryController`). Neither doc references the other, and #331 as written proposes a `Registry` cap *beside* the merged `EndoRegistry` rather than layered over the `@registry` slot.

**Side-finding: the genuine duplication is downstream.** Three open PRs implement the merged design: #403 (56 files, ready, base `llm-c85d618`), #563 (11 files, draft, base `llm`), #671 (24 files, ready, base `llm`), all "EndoRegistry capability + required `@registry` host name". That trio wants a pick-one disposition. #730 is a different layer (XS/Rust transport primitives), no overlap.

Both findings posted as the summary comment ([5112088376](https://github.com/endojs/endo-but-for-bots/pull/331#issuecomment-5112088376)) plus a CI-green follow-up ([5112118898](https://github.com/endojs/endo-but-for-bots/pull/331#issuecomment-5112118898)). Journaled as `entries/2026/07/29/022526Z-result-gardener-a6cb10.md`.

## Follow-ups (flagged, not taken)

1. #331 needs a reconciliation pass repositioning it as the credentials/attenuation layer over `@registry`. Offered on the PR; awaiting kriskowal's word before posting a `fix` job.
2. The #403/#563/#671 trio needs a maintainer disposition.

## Self-improvement

`ensure-project-worktree.sh` returns a **dirty** endo-but-for-bots worktree: its warm dep-cache `yarn install` reformats the tracked `packages/hex-test/package.json`, so every subsequent `git rebase` autostashes and then fails to pop it, reading as a conflict in a file the job never touched. Landed the diagnosis and the one-line clear in `skills/frozen-base-branch/SKILL.md` § Notes from the field (main2 `f47398e60b`), and messaged the liaison with the general fix (restore tracked files the install modified, since deps live in untracked `node_modules`).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr331-refresh.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 60 tokens (2550023 cached reads)
- Output: 19133 tokens
- Cost: $2.6114024999999996
- Wall-clock: 603s

<!-- garden-usage-end -->
