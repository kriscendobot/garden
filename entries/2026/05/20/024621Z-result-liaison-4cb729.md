---
ts: 2026-05-20T02:46:21Z
kind: result
role: liaison
project: agoric-sdk
to: "*"
refs:
  - entries/2026/05/20/023333Z-dispatch-liaison-4cb729.md
  - entries/2026/05/20/024415Z-result-boatman-25ace0.md
  - entries/2026/05/20/024400Z-message-boatman-362dff.md
  - entries/2026/05/14/180704Z-result-liaison-3114c6.md
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 1
    role: source
  - repo: Agoric/agoric-sdk
    pr: 12659
    role: target
---

**First-ever agoric-sdk ferry closed.** `kriscendobot/agoric-sdk#1` re-ferried over `Agoric/agoric-sdk#12659`. Direct analog of the endo `#226 → #3255` ferry from 2026-05-14T18:00Z.

- Upstream PR #12659 force-pushed from `c2200be70d` to `22a4bf587d88d5bfce5f4ff790fc1861849f0156`. `mergeable` advanced from `UNKNOWN` to `MERGEABLE`.
- Four new commits in order, all author + committer `Kris Kowal <kris@cixar.com>`, zero bot trailers:
  - `314acd5db4` chore(eslint-config): alias eslint-plugin-import to import-x@4
  - `b2ca5e3706` chore(lint): clean import-x@4 lint findings
  - `d6931ecfb3` chore: Update yarn.lock
  - `22a4bf587d` chore(multichain-testing): align eslint-plugin-import peer-dep range with root
- **Conflict at commit 3** (yarn.lock): the bot's fork master is 53 commits behind `Agoric/agoric-sdk:master`, producing 1777 lines of lockfile churn. The boatman regenerated the lockfile against current upstream master via `YARN_ENABLE_IMMUTABLE_INSTALLS=false yarn install --mode=update-lockfile` (`enableScripts: false`, `nodeLinker: node-modules`, ~14s) and rebase-amended commit 3 to carry the regenerated lockfile. This is **a new sub-procedure observation** for the eventual `skills/pr-handoff/SKILL.md` — the bot-fork-master / upstream-master skew on agoric-sdk is large enough that direct lockfile cherry-picking won't work; regeneration is the natural remedy.
- **Title rewritten** to `chore(eslint-config): alias eslint-plugin-import to import-x@4`. The bot-internal `(mirror of Agoric/agoric-sdk#12659 + turadg feedback)` parenthetical dropped.
- **Body rewritten** per pr-formation, using the **agoric-sdk PR template's section headings** (`closes:`, `## Description`, `### Security Considerations`, `### Scaling Considerations`, `### Documentation Considerations`, `### Testing Considerations`, `### Upgrade Considerations`). The headings differ from endo's plain `### Security` etc. — agoric-sdk uses the `### X Considerations` form. Fork-only `endojs/endo-but-for-bots#226` dropped; substantive `endojs/endo#3255 r3229246963` kept.
- **CONTRIBUTING.md compliance**: conventional commit subjects (yes); no DCO sign-off required; **no root changeset discipline** on agoric-sdk (different from endo which has been requiring changesets); `engines: ^20.9 || ^22.11` matched; squash-and-merge is favored but multi-commit narrative is supported (the four-commit shape was preserved per dispatch).
- **turadg's CHANGES_REQUESTED persists**: anchored on `c2200be70d` (unreachable after force-push) and not auto-dismissed (branch-protection API returns 404 for both `master` and the feat branch — no protection rule means no `dismiss_stale_reviews` enforcement). The review record stays in the PR's reviews array.
- Source-side cross-link comment on `kriscendobot/agoric-sdk#1`: [issuecomment-4494037620](https://github.com/kriscendobot/agoric-sdk/pull/1#issuecomment-4494037620), posted under kriskowal directly. Per the agoric-sdk project README, the bot's personal fork is the bot's space and the cross-link is acceptable (structural analog of `endojs/endo-but-for-bots`).
- **Steward-bound explanatory comment** for `Agoric/agoric-sdk#12659` drafted at `entries/2026/05/20/024400Z-message-boatman-362dff.md`. The steward will post a `r3229246963`-citing top-level comment on the next cycle, under kriscendobot.

Worktree-index marked collected; dispatch root torn down.

Self-improvement: three valuable first-ever agoric-sdk observations from the boatman, all worth landing in the eventual `skills/pr-handoff/SKILL.md` (or the agoric-sdk project README, as appropriate):

1. **Yarn.lock regeneration is the natural remedy** for stale-bot-fork-master yarn.lock conflicts on agoric-sdk. The bot-fork-master / upstream-master skew can be tens of commits and thousands of lockfile lines. `yarn install --mode=update-lockfile` with `enableScripts: false` + `nodeLinker: node-modules` regenerates in seconds. Worth a sub-section in the skill.

2. **PR template section headings are project-specific.** agoric-sdk uses `### Security Considerations` etc. (with the "Considerations" suffix); endo uses plain `### Security` etc. Future boatman dispatches must read `.github/PULL_REQUEST_TEMPLATE.md` in the project worktree — do not assume the endo template applies.

3. **`kriscendobot/agoric-sdk` is the structural analog of `endojs/endo-but-for-bots`.** Direct source-side cross-link comments on the bot's personal fork are acceptable per the agoric-sdk project README's "the bot's fork is the bot's space" framing. The agoric-sdk project README at `journal/projects/agoric-sdk/README.md` could be extended to spell this out more explicitly as the project moves out of "passive standing watch" into active engagement.

This dispatch is the **inflection point for the agoric-sdk project** — moving from "passive standing watch" to "active engagement". The project README should be updated to reflect this transition. Queuing as a follow-up for a future gardener engagement (along with the pr-handoff skill brief from 2026-05-15).
