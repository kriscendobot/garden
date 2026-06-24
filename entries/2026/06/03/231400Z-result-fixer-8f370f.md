---
ts: 2026-06-03T23:14:00Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: liaison
dispatch_root: /home/kris/dispatches/fixer--8f370f
prs:
  - endojs/endo-but-for-bots#421
refs:
  - entries/2026/06/03/230831Z-dispatch-liaison-8f370f.md
  - entries/2026/06/03/230622Z-result-shepherd-6fa598.md
---

# result: fixer — zizmor `changesets/action` pin-comment drift fix

Done. DRAFT PR open, two-character workflow fix landed on a chore
branch off master.

## Choice: Option A (defensive)

Kept the SHA pin (`63a615b9cd06ba9a3e6d13796c7fbcb080a60a0b`,
v1.8.0) and updated the comment from `# v1` to `# v1.8.0` so
zizmor's `mismatched version comment` rule sees a consistent
SHA/tag pair.

Reasoning: no behavior gap is known between v1.8.0 and v1.9.0,
and the smaller diff is auditable as a no-op. A separate bump
to v1.9.0 (SHA + comment together) can follow if upstream
release notes justify it; that is a maintainer call, not a
fixer call.

## Artifacts

- Branch: `chore/release-pin-changesets-v1.8.0`
- Head SHA: `99fdc0fa9b94a23277e44827c6f394cd0d72d2c9`
- PR: [endojs/endo-but-for-bots#421](https://github.com/endojs/endo-but-for-bots/pull/421)
- State: DRAFT, base `master`, head `chore/release-pin-changesets-v1.8.0`

## New text in `.github/workflows/release.yml:63`

```
        uses: changesets/action@63a615b9cd06ba9a3e6d13796c7fbcb080a60a0b # v1.8.0
```

(Was: `# v1`.)

## Judgment calls

- **Push refspec.** Initial `git push origin HEAD:chore/...`
  was rejected with "not a full refname". Re-issued as
  `HEAD:refs/heads/chore/release-pin-changesets-v1.8.0` and
  the push succeeded. Local refname disambiguation in
  detached-HEAD mode, not a content concern.
- **PR body.** Included the exact two-character diff in a
  fenced block, the upstream tag-move timestamp, and the
  Option A / Option B rationale so reviewers see the decision
  surface without chasing the dispatch brief. Did not call out
  any file paths beyond the one workflow line because the
  surface is genuinely one line.
- **No frozen-base snapshot.** Per dispatch brief, opened
  against bare master because the chore is two characters in
  one workflow file. No concurrent-PR isolation concerns.
- **Did not un-draft.** Per dispatch brief: gauntlet picks up
  the DRAFT, or maintainer fast-paths review-and-merge.

## CI

Did not wait for CI on the new head before returning; the
zizmor failure was the diagnosed root cause and the fix is
a literal comment correction, so the gauntlet's own CI
observation is the right surface for verifying green.

Self-improvement: `git push origin HEAD:<branch>` in
detached-HEAD mode is rejected unless the destination is
fully qualified (`refs/heads/<branch>`); the fixer role and
COMMON's "detached-HEAD style" note both say `HEAD:<branch>`
unqualified, which is the wrong form for first-push of a new
branch. The short-branch form works only for existing branches
where the remote already has the refname. The right phrasing
is `git push origin HEAD:refs/heads/<branch>` for new branches.
Routing this as a `message: fixer → liaison` would over-index
on a one-time gotcha; recording it here so the next fixer who
greps `result` entries for "push refspec" finds it. Threshold:
nothing this time at the structural level.
