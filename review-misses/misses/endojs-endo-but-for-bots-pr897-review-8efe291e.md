---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr897-review-8efe291e
verdict: miss
category: process
pr: 897
repo: endojs/endo-but-for-bots
surface: pr-review-body
author: kriskowal
review_at: 2026-09-02T03:59:37Z
comment_url: https://github.com/endojs/endo-but-for-bots/pull/897#pullrequestreview-5085400547
identity: endojs/endo-but-for-bots#897:review:5085400547
producing_role: builder
producing_job: endojs/endo-but-for-bots#897 (fix/mount-glorp-713-followup #713 must-fix bundle; no build job in jobs/tada)
missed_by: code-panel scope (no existing-surface / layer-ownership equivalence check for pet-name path handling)
severity: moderate
cluster: existing-cli-surface-equivalence
---

# Miss: pet-name path translation placed in the daemon Exo layer on #897

The maintainer review at `comment_url` (CHANGES_REQUESTED) objects that the PR's
mount interface implicitly split a pet-name string on slash to form a path, and
that its `help.md` described translating between Endo pet-name paths and other
path disciplines inside the core daemon Exo interface. The maintainer's
correction: in every place taking a pet name or an array of pet names, a bare
string is equivalent to a one-element array — never implicitly slash-split — and
translation between path disciplines belongs in a named adapter (like
`fileURLToPath`), not the Exo interface, which must not privilege one discipline.
The primary job resolved it in-place (commit `7eac1629d` "keep string paths as
single names", commit `a0020fbaf` "keep Git path translation in its adapter") and
replied to each thread; the resolution deliverable genuinely exists.

## Grounds (miss)

Grounded in the repo, not the comment: the layering the maintainer enforces is an
existing convention already embodied in the codebase. Slash-delimited-string →
array parsing lives in the CLI adapter (`packages/cli/src/pet-name.js`,
`parsePetNamePath`), and the daemon-facing interface types pet-name paths as
arrays (`NamePathShape` / `petNamePath: string[]`, e.g. `packages/lal/tools/meta.js`).
PR #897 added slash-splitting path translation into `packages/daemon/src/mount.js`
— the daemon/Exo layer — duplicating and misplacing a responsibility the CLI
adapter already owns. This is foreseeable by tracing the existing pet-name-path
route/layer before adding a new path-handling branch, the same mechanism recorded
for #658 (mount-path reader branches duplicating the CLI's slash-path traversal).
It is a review-lens/scope gap, not new direction: the maintainer is applying an
existing layering, not stating a fresh requirement. No standing garden seat brief,
skill, or gate requires an existing-surface / layer-ownership trace for pet-name
path handling, so it is a prevention-and-sensing gap to accumulate.

## Threshold call

Joins `existing-cli-surface-equivalence` (was count=1 / prs={658}). Second member,
second distinct PR → count=2 / prs={658, 897}. Below the default floor (K ≥ 3
misses across ≥ 2 PRs): the two-PR requirement is now met but the three-miss
count is not. Severity is moderate and no standing rule bound, so the single-major
bypass does not apply. Hold — no `review-improve-*` dispatch this cycle. A third
matching miss (a panelled path-handling branch that ignores the existing
route/layer) should join and trip a fresh threshold call.
