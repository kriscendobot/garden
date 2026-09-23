---
ts: 2026-05-29T14:08:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: designer
dispatch_root: /home/kris/dispatches/designer--9c7d88
prs:
  - repo: endojs/endo-but-for-bots
    pr: 358
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/358
  - entries/2026/05/29/053100Z-dispatch-steward-e8f9a0.md
---

# dispatch: designer — respond to kriskowal CHANGES_REQUESTED on #358

Monitor surfaced PullRequestReviewEvent on PR #358
(`design(daemon): importLocation from EndoMount with npm-registry-proxy
+ Go-like MVS`, kriscendobot-authored) at 14:06:26Z: kriskowal submitted
a CHANGES_REQUESTED review with **5 inline comments** on
`designs/daemon-worker-import-from-mount.md` (2 new today + 3 prior in
the same thread set still requiring response).

## Why the steward, not the contractor

PR #358 is not in any contractor slot (the contractor's current claims
are #324, #337, #343). Per `roles/steward/AGENT.md` § Maintainer-
feedback response (added by gardener 6e19e2), the steward owns Monitor-
surfaced maintainer feedback on every garden-authored PR regardless of
who opened it. Dispatch-by-shape: design-only PRs → designer.

## Inline comments to address (kriskowal on `designs/daemon-worker-import-from-mount.md`)

| Comment ID  | Line | Disposition required |
|-------------|------|---------------------|
| 3324782663  | 133  | Acknowledgment ("Confirmed.") — verify acknowledgment / resolve thread |
| 3324796922  | 409  | Substantive — "The keys will be package names and version numbers, e.g., `ses@1.0.0` or `@endo/patterns@1.2.1`" — design clarification to incorporate |
| 3324802404  | 409  | Substantive — "The readPowers will also need to close over both the registry and the source mount" — design correction to incorporate |
| 3324812556  | 571  | Scope directive — "Let's limit scope to mvs resolution and skip the lockfile, for now" — remove or defer lockfile content |
| 3324843748  | 728  | Substantive direction — "Let's add a new lane to the compartment mapper, analogous to mapNodeModules, but for mapSnapshot (from registry and mount exos, which collectively produce a snapshot of an application that importSnapshot can execute). Because this relies on the daemon, it is a daemon-specific variation on mapNodeMod…" — re-fetch full body and incorporate as new design section |

Re-fetch each in full via
`gh api repos/endojs/endo-but-for-bots/pulls/358/comments` — the table
above shows truncated bodies.

## Task

Same procedure as the 05:31Z designer dispatch on #376 (see refs):

1. Re-fetch each inline comment in full from the API.
2. Edit `designs/daemon-worker-import-from-mount.md` per each comment.
3. Reply on each inline thread (acknowledgments are short, substantive
   ones link to the new design section).
4. Push to `design/daemon-worker-import-from-mount` (bot has direct
   push access).
5. Top-level summary comment on the PR linking each inline thread to
   the addressing edit per
   `garden/skills/pr-review-thread-replies/SKILL.md` and
   `garden/skills/review-feedback-followup-commits/SKILL.md`.
6. Re-request kriskowal review after CI green (use the working
   `gh api ... --input -` JSON shape, NOT the `-f reviewers=[...]`
   form which returns HTTP 422 per the gardener-fixed example in
   `roles/fixer/AGENT.md` line 54).

## Per-action authorizations (forwarded)

- Push the design edit to
  `endojs/endo-but-for-bots:design/daemon-worker-import-from-mount`
  under kriscendobot identity. Authorized.
- Reply on each inline review thread. Authorized.
- Post the top-level summary comment. Authorized.
- Re-request kriskowal review after CI green. Authorized.

## Not authorized

- Re-drafting the PR (already un-drafted; only steward dispatches a
  judge for any draft-state changes).
- Modifying any non-design file (this is a design-only PR; stay in
  `<project>/designs/`).
- Closing the PR.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/designer--9c7d88/garden/roles/COMMON.md`
2. `/home/kris/dispatches/designer--9c7d88/garden/roles/designer/AGENT.md`
3. `garden/skills/pr-review-thread-replies/SKILL.md`
4. `garden/skills/review-feedback-followup-commits/SKILL.md`
5. Other skills the designer names just-in-time.

Project worktree starts at `project/` on
`design/daemon-worker-import-from-mount` (detached HEAD at `9ac8f99c6`).

## Report

A `result` journal entry. Include: new head SHA after push, list of
edited sections in `designs/daemon-worker-import-from-mount.md` with
the inline comment IDs each addresses, the top-level summary comment
ID, the re-request-review API call status, and any inline thread
reply IDs.
