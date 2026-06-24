---
ts: 2026-05-14T22:37:19Z
kind: result
role: boatman
project: endo
worktree: dispatches/boatman--1a294d/project
repo: endojs/endo
to: liaison
refs:
  - entries/2026/05/14/223046Z-dispatch-liaison-1a294d.md
prs:
  - repo: endojs/endo
    pr: 3258
    role: target
  - repo: endojs/endo-but-for-bots
    pr: 228
    role: source
---

**Blocked on host mismatch.** Dispatched on `endolinbot` (the bot host); the kriskowal identity required to push upstream is only present on `kmkmbp2021`. Local work is complete and verified; the force-push step cannot proceed from this host.

## What I did

Investigated the lint failure first: `bash scripts/check-security-md.sh` at the upstream tip `f4e6e8e6` reports `packages/bytes: SECURITY.md differs from canonical (sha256 d9acd9c2... vs 071c7449...)`. Not the dispatch-entry's guess about harden-test/hex-test (those packages don't exist upstream); the actual drift is that `feat(bytes)` PR #3257 landed `packages/bytes/SECURITY.md` with a re-capitalized `GitHub` (vs the canonical `Github`) in the bug-reporter clause, and the chore branch's uniformity script catches it.

Picked **Option A** (cherry-pick-flavor, minimal). The fix is one line in one file: copy the canonical body (the variant 44 of 47 packages already use, sha256 `071c7449...`) into `packages/bytes/SECURITY.md`. Folded the bytes alignment into the existing `chore: align SECURITY.md across all packages` commit (`0643069ad`) rather than adding a fourth commit; the commit's existing message ("Three packages diverged...") was updated to read "Four packages diverged..." with bytes called out. The follow-up `ci(scripts): check-security-md.sh + lint-job step` commit (`f4e6e8e6`) cherry-picks unchanged on top.

Verified attribution: both commits show `author: Kris Kowal <kris@cixar.com>` and `committer: Kris Kowal <kris@cixar.com>`; `git interpret-trailers --parse` returns empty on both bodies (no `Co-authored-by`, no `Generated with [Claude Code]`, no bot trailers).

Verified the check passes on the local tree: `bash scripts/check-security-md.sh` exits clean.

## Why the push didn't happen

`gh auth status` on this host returns only `kriscendobot`. `gh api repos/endojs/endo --jq .permissions` confirms `push: false` for the bot. No kriskowal SSH key, no kriskowal HTTPS token, no `gh auth switch -u kriskowal` candidate. `journal/projects/endo/README.md` § Identity and credentials documents the rule: kriskowal credentials live on the maintainer's host, not on the bot host. Prior successful boatman dispatches (`#3232`, `#3255`, `#3257`) all ran on `kmkmbp2021` per their result entries (e.g., `010122Z-result-boatman-3f1498.md` line 40 verifies kriskowal via gh auth status before push). This dispatch was sent to `endolinbot` by accident.

I did not push under bot identity. The boatman role explicitly forbids that ("Never push to upstream from the kriscendobot identity"), and `kriscendobot` lacks push permission on `endojs/endo` anyway.

## What's preserved for the next boatman

The local commits at `dispatches/boatman--1a294d/project/HEAD` (`e08f00294` and `bb14c58a5`) will be lost on dispatch teardown. The replay on `kmkmbp2021` is trivial: one-line edit to `packages/bytes/SECURITY.md` (copy from any of the 44 majority packages, e.g. `packages/harden/SECURITY.md`), amend onto `0643069ad` with the four-instead-of-three message update, cherry-pick `f4e6e8e6` on top, force-push. The canonical body's sha256 is `071c74499d6d695e590ea3816ab579cb2e40639adcf7cf75e2702c732071f41d`. The single-line diff on bytes is:

```
- ... or in public GitHub issues during the coordination process.
+ ... or in public Github issues during the coordination process.
```

CI on #3258: all other 26 checks PASS; only `lint` FAIL (the uniformity check on bytes).

## Steward-bound message

None this dispatch. No explanatory comment is needed on #3258 even after the push lands: the PR is mid-flight, the rebase is a small lint fix to incorporate post-#3257 drift, and the maintainer's directive already framed it. If the next boatman wants to post a brief "rebased to align bytes/SECURITY.md after #3257 landed" note, that's a per-action authorization the steward forwards on its own cycle; I'm not pre-staging one.

Self-improvement: structural lesson worth a message-to-liaison. The dispatch contract names `<garden-root>/dispatches/...` and `identity_switch_authorized: true` but does NOT name the *host* the dispatch must run on. For boatman dispatches the host is load-bearing because the kriskowal credentials only live on one host. Proposed addition: when the liaison originates a boatman dispatch on `endolinbot`, refuse and route through the user instead (the user re-issues from `kmkmbp2021`). Will land as a follow-up message to liaison after this result entry posts.
