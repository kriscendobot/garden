---
ts: 2026-06-03T22:51:45Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--4144a4
prs:
  - repo: endojs/endo-but-for-bots
    pr: 394
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/394
  - https://github.com/endojs/endo-but-for-bots/pull/394#discussion_r3351927403
  - https://github.com/endojs/endo-but-for-bots/pull/394#discussion_r3352371885
---

# dispatch: fixer — #394 use SHA-256 Git variant per kriskowal (revert spike-application's SHA-1 framing)

Maintainer directive on #394 inline reply
`discussion_r3352371885` (kriskowal, 2026-06-03T22:51:02Z, in
reply to 0xpatrickdev's flag at `r3351927403`):

> @kriscendobot my preference is to avoid using a compromised
> hash in this project.

## Context

The spike-application fixer `8f3bda` (earlier this session)
reversed the prior "use the SHA-256 Git variant" claim in
`designs/gateway-package.md` based on the spike #369's
framing: "endo sha256 stays the content key; git's internal
object DB runs in default SHA-1 format behind a `sha256 →
git-oid` index."

0xpatrickdev flagged this as at-odds with kriskowal's
original verbatim directive. kriskowal has now confirmed:
prefer to AVOID compromised hashes (SHA-1) — use SHA-256
throughout.

## Target

- PR: endojs/endo-but-for-bots#394
- Branch: `design/gateway-package-phase-6`
- Head: `0acea588b` (post cascade rebase).
- Base: `design/gateway-package-phase-5`.

## Required change

In `designs/gateway-package.md` (the section the spike-
application touched — around line 600), refine the text to:

- Use SHA-256 throughout (Git's SHA-256 variant, or another
  SHA-256-based scheme).
- Remove the "stays in SHA-1 with sha256→git-oid index"
  framing.
- Acknowledge that this MAY require additional work in the
  underlying daemon-git-backbone implementation (the spike
  named libgit2 + sha256 Git format; verify whether libgit2
  supports sha256 Git format reliably, OR pick another
  approach).
- The original verbatim quote was: "Let's also make sure we
  use the sha256 Git variant and avoid the sha1 version" —
  re-honor this.

This is essentially REVERTING (or refining) the spike-
application commit's SHA-section content for THIS doc. The
spike itself (#369) is a separate PR with its own choices;
don't touch #369.

## Procedure

1. Read the current `designs/gateway-package.md` Feature 3 /
   daemon-side scope section.
2. Identify the section that says git internal stays SHA-1
   with sha256→git-oid index.
3. Replace with text that:
   - Uses SHA-256 throughout.
   - Acknowledges the implementation may need libgit2's
     sha256 Git format support (or a fallback).
   - References kriskowal's preference (the compromised-hash
     concern).
4. Commit (regular append):
   ```
   docs(gateway): use SHA-256 Git variant per kriskowal preference (revert spike SHA-1 framing)
   ```
5. Push to `design/gateway-package-phase-6`.
6. Reply on inline thread `3352371885` with brief
   acknowledgment + new SHA.

## Per-action authorizations

- Edit `designs/gateway-package.md`. Authorized.
- One regular-append commit + push to
  `endojs/endo-but-for-bots:design/gateway-package-phase-6`.
  Authorized.
- Inline-thread reply on `3352371885`. Authorized.

## Not authorized

- Modifying the spike PR #369.
- Modifying any non-designs file.
- Force-pushing.
- Un-drafting / merging.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/fixer--4144a4/garden/roles/COMMON.md`
2. `/home/kris/dispatches/fixer--4144a4/garden/roles/fixer/AGENT.md`
3. `garden/skills/pr-review-thread-replies/SKILL.md`
4. Other skills referenced just-in-time.

Project worktree at `project/` on
`design/gateway-package-phase-6` (head `0acea588b`).

## Report

A `result` journal entry. Include:

- New head SHA.
- Old → new text summary in `designs/gateway-package.md`.
- Inline-thread reply ID.
- Judgment calls (especially: how you handled the libgit2 +
  sha256 Git format implementation reality).
