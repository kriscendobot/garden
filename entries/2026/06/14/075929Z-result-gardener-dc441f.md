---
ts: 2026-06-14T07:59:29Z
kind: result
role: gardener
host: endolinbot
to: liaison
short_id: 9ae791
refs:
  - entries/2026/06/14/075600Z-dispatch-gardener-9ae791.md
  - https://github.com/endojs/endo-but-for-bots/pull/440
---

# Result: infer-PR-base-from-package-availability convention landed

## Routing

Dispatch `9ae791` per maintainer directive on `endojs/endo-but-for-bots#440` (2026-06-14T07:55Z):

> Make a note for the gardener and builder that we can infer that the base of a PR should be `llm` if it addresses packages that only exist in `llm`.

## What landed

### On `origin/main` (commit `bf57d99b`, 1 file +2/-1)

- **`roles/builder/AGENT.md`** § Operating norms gains one bullet: *"Infer the base branch from package availability."* Names the rule and points at the per-project journal-side README for the full statement (including the mixed-touch impasse case).
- Frontmatter `updated:` bumped to 2026-06-14.

### On `origin/journal` (commit `103496d6`)

- **`journal/projects/endo-but-for-bots/README.md`** § Rules of engagement gains a new third bullet *"Base-branch inference from package availability"* with three case sub-bullets plus the inspection procedure:
  - **llm-only-package touch → base = llm.** Use a frozen `llm-<sha>` snapshot per `skills/frozen-base-branch/SKILL.md`; the conductor unfreezes to live `llm` at merge time per `roles/conductor/AGENT.md` § Loop step 2 (the 2026-06-06 unfreeze-before-merge norm).
  - **Both-branches-package touch → base = master.** Standard implementation trunk; frozen `master-<sha>` per the same convention.
  - **Mixed touch (llm-only + master-only) → impasse.** The PR cannot have a single base; resolution is either splitting the implementation into two PRs with different bases, or forward-merging the master-only package to llm before implementing.
  - Inspection procedure: one `git ls-tree origin/<branch> -- packages/<name>` per touched package against both branches, performed before opening the PR.
- Precipitating evidence cited: PR `#440` cut 3 (chat) impasse — the merged design's `packages/chat/*` exists only on `llm`; the builder attempting a `master`-base PR could not proceed because `packages/chat/` was absent on `master` (`packages/goblin-chat/` is the `master`-only sibling).

## Cross-references

Hub-and-spoke: the project README is the canonical statement; the builder role file links to it. No other files needed changes — the conductor role file's existing § Loop step 2 unfreeze procedure (landed 2026-06-06) already handles the `llm-<sha>` snapshot at merge time, and the frozen-base-branch skill's procedures apply uniformly to either base.

## Out of scope

- **Other projects' rules.** The `llm`/`master` split is specific to `endojs/endo-but-for-bots`; other projects with a similar two-branch shape would land their own rule on their own project README. None today; the rule is single-project.
- **Builder pre-flight automation.** The inspection procedure is described as a manual check; a future pre-push-gate probe could automate it (detect touched packages, ls-tree against both branches, classify the base). Out of scope for this engagement.

## Summary back

The convention is encoded on both branches. Future builder dispatches against `endo-but-for-bots` will pick up the rule via the project README (read at dispatch time per the standing convention) and the builder role-file cross-reference (read by the dispatched subagent).

Self-improvement: `roles/builder/AGENT.md` and `journal/projects/endo-but-for-bots/README.md`; the base-branch inference rule is now standing convention with a clear impasse case. Tenth gardener-actioned encoding this session.
