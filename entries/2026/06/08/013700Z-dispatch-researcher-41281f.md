---
ts: 2026-06-08T01:37:00Z
kind: dispatch
role: steward
host: endolinbot
project: endo-but-for-bots
to: researcher
dispatch_root: /home/kris/dispatches/researcher--41281f
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/89
  - https://github.com/endojs/endo-but-for-bots/pull/89#pullrequestreview-4342320898
---

# dispatch: researcher — kriskowal review on PR #89 (design-only: genie-integration)

Maintainer-feedback dispatch per the Monitor-surfaced
`PullRequestReviewEvent` at 2026-06-08T01:34:57Z on
`endojs/endo-but-for-bots#89` (`docs(designs): propose
genie-integration`). Review `4342320898` is kriskowal
CHANGES_REQUESTED. The PR is **design-only** (changes only
`designs/README.md` and `designs/genie-integration.md`).

Per the steward role's *Dispatch decision by PR shape*: design-
only PR → designer. Per researcher-precedence rule: researcher
runs first.

## Maintainer's asks (verbatim)

**5 inline comments tied to review `4342320898`** (all on
`designs/genie-integration.md`):

1. **Line 8** (id `3285712716`): *"Prettier."* (format fix)
2. **Line 452** (id `3369680410`): *"Every agent in the daemon
   has a 'pet store' which can read and write files and make
   and remove directories. This should be a sufficient space
   for the agent's memory and references to shared context. It
   should not be necessary for this virtual filesystem to be
   backed by an actual file system. If we s..."* (body
   truncated — designer must fetch full body)
3. **Line 481** (id `3369682114`): *"Please dispatch a designer
   to propose a scheduler design that closes the gap between
   what the daemon currently provides and what the integrated
   agent would need. This should amount to a prerequisite
   refactor. Please include that new design in this PR."*
4. **Line 485** (id `3369682742`): *"Let's simply call it
   'scheduler'."*
5. **Line 560** (id `3370450380`): *"Please remove. This is
   indeed irrelevant."*

**Top-level comment** at 2026-06-08T01:35:25Z (id `4644790211`):
*"Also rebase for the zizmor CI fix."*

## What the downstream designer dispatch will do

Apply kriskowal's CHANGES_REQUESTED review on PR #89. Five
inline asks: Prettier format on line 8; pet-store-as-memory
framing rewrite at line 452; **author a new scheduler design
as a prerequisite refactor and include it in this PR** at
line 481; rename to "scheduler" at line 485; remove irrelevant
section at line 560. Plus rebase against current `llm` (which
just got the master-into-llm sync at `11a76ae6`) to pick up
the zizmor CI fix.

## What you should look for

- **The full body of inline `3369680410`** (the pet-store/agent-
  memory truncated comment). The designer must fetch via
  `gh api repos/.../pulls/comments/3369680410` before acting.
- **Scheduler design precedents**: the daemon's current
  scheduling primitives, any prior scheduler designs in
  `designs/`, the gap between "daemon currently provides" and
  "integrated agent needs". The new design needs to "close the
  gap" — what gap?
- **Pet store context**: what's the pet-store concept in the
  daemon? Is there a library entry on it? The maintainer's
  framing assumes the designer knows what "pet store" means.
- **Genie / familiar / chat integration context**: where does
  the genie-integration design sit in the project's roadmap?
  What's it integrating? `designs/familiar*`, `designs/chat*`,
  `designs/genie*` precedents.
- **Zizmor CI**: which workflow/check is this? Has it been
  added to master recently? The "rebase for the zizmor CI fix"
  framing implies a known fix is on llm; what is it?
- **PR-shape conventions for design-only PRs**: any rules
  beyond the frozen-base-branch rule? The PR's current state
  is non-draft and base `llm`; the rebase should preserve
  that.

## Deliverable

Per `roles/researcher/AGENT.md`: a `result` entry with the
standard `## Library and project references` section. The
steward will inline that section verbatim into the designer's
dispatch brief.

Keep your dispatch under five minutes wall time (slightly
longer than the standard three; the substance is novel).
No project worktree was prepared (journal-and-library work
only).
