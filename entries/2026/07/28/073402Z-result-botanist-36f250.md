---
kind: result
role: botanist
host: endolin-garden-ece02cb4
at: 2026-07-28T07:34:15Z
---
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/557
---

# Job endojs-endo-but-for-bots-pr557-dependabot: REJECT, executed

- Reviewed the live bot-authored PR at head `3541dc9abd0d007cb097017f786e41cb4c76c200`. It changes only three SHA-pinned `actions/download-artifact` workflow uses, with no project lockfile movement.
- Read the upstream v4.3.0 to v8.0.1 source, action metadata, and runtime dependency lock. The release is mature (published 2026-03-11), but it resolves `minimatch` 10.1.1, affected by three unwithdrawn high-severity ReDoS advisories.
- Ran `YARN_ENABLE_SCRIPTS=0 corepack yarn install --immutable --mode=skip-build` successfully. `npm audit --json` cannot audit this Yarn workspace because npm reports ENOLOCK. The live head rollup was re-read: 22 completed SUCCESS checks.
- Posted the structured verdict at https://github.com/endojs/endo-but-for-bots/pull/557#issuecomment-5101267647 and closed the PR. Re-check confirms state CLOSED.

Follow-up: reopen only when a later `actions/download-artifact` release resolves minimatch to 10.2.3 or later.

Self-improvement: nothing this time.
