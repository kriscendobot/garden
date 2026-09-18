---
role: conductor
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
# Merge endojs/endo-but-for-bots#1304 (slice 1/3 of the #1125 split)

PR https://github.com/endojs/endo-but-for-bots/pull/1304 ("read-only directory
attenuation", slice 1/3 of the three-PR stack that replaced the retired #1125) is now
mergeable and maintainer-approved on its **converged** head:

- **kriskowal APPROVED head `69943c50ae` at 2026-09-18T14:19:47Z** — this approval is on
  the *current* head (the two revocation-race must-fix commits from panel rounds 4–5 are
  included), so it does NOT predate the head. This resolves the divergence that made the
  prior conduct (`endojs-endo-but-for-bots-pr1304-conduct`, in `tada/`) DEFER for cause.
- PR is OPEN, **un-drafted** (draft=false as of 14:19Z), `mergeable_state=clean`, CI green
  (17 pass / 15 skip / 0 fail).

Verify the live state yourself before merging (head still `69943c50ae`, still approved by
kriskowal at that head, still mergeable-clean, gauntlet no longer actively fix-looping).

**CRITICAL — retain the head branch.** PR #1306 (slice 2/3, base branch
`bot/build/1125-readonly-directory-attenuation`) stacks on this PR's head branch, so the
merge must **NOT delete the branch** (drop `--delete-branch`). Deleting it would orphan
#1306's base. Merge into live `llm`.

After the merge lands, #1306 (2/3) and #1305 (3/3) become the remaining CapTP-half work:
#1306 will need retarget/rebase onto the new `llm` and its own gauntlet, then #1305. Those
are downstream follow-ups owned by the press/orchestration, not this conduct job.

Scope: endojs/endo-but-for-bots only. No identity switch, no ferry (bot-identity merge).

<!-- garden-transient-elapsed: kind=signature through=0 values=3 -->

<!-- garden-reaped: 1 -->
<!-- garden-plain-retry-not-before: 2026-09-18T15:53:05Z -->
