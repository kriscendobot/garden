---
ts: 2026-05-14T23:58:02Z
kind: dispatch
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/14/180704Z-result-liaison-3114c6.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 255
    role: source
---

First-time ferry: `endojs/endo-but-for-bots#255` ("ci(ocapn-guile-interop): harden against bordeaux.guix.gnu.org outages (iteration II)") to a new draft PR on `endojs/endo`. The bot-side PR is itself a draft, with 24 SUCCESS / 0 FAILURE CI on a single workflow file change. The user explicitly chose **draft on upstream** when offered (normal PR / draft / direct-push to master).

Prior context: PR #82 ("iteration I") was direct-pushed to upstream master as commit `246c6a6c` on 2026-05-02 (`ci(ocapn-guile-interop): make guix dependency resilient to ci.guix.gnu.org outages`). The 2026-05-14 outage exposed the symmetric case: bordeaux was unreachable while ci.guix.gnu.org was healthy, and the daemon's first-listed substitute server (bordeaux per iteration I) paid a connection-timeout per substitute lookup, pushing the Guile host's sturdyref publication past the 120-second polling ceiling.

Iteration II's fix is to reverse the `--substitute-urls` ordering (ci.guix.gnu.org first, bordeaux second). One-line change in `.github/workflows/ocapn-guile-interop.yml`. The user opted for a draft upstream PR rather than another direct-push.

**Source**: `endojs/endo-but-for-bots#255`, branch `ci/ocapn-guile-interop-resilience-ii`, head `ed9ba7296df131a1b5530e6138654e4363ba68d7`. State OPEN (DRAFT), MERGEABLE. Base on `llm` at `ea4d07bb14d88bfb45fef91c0611714f6e89e46e`.

**Upstream**: new branch on `endojs/endo` (boatman picks the name; suggested `kriskowal-ocapn-guile-interop-resilience-ii`). Target base: `master`. Current `master` already has iteration I (`246c6a6c`) and two later ci hygiene commits authored by "Claude" (`bab98d8e`, `93f57b34`); the new commit applies cleanly on top per a local diff check.

**Human**: `Kris Kowal <kris@cixar.com>`. **identity_switch_authorized: true** (user asked for the ferry; this matches the recent re-ferry pattern).

**Dispatch root**: `/Users/kris/garden/dispatches/boatman--ferry-ocapn-guile-resilience-ii-255--20260514-235748--02ccd8/`. Project worktree on `endojs/endo:master` (detached at `052b0487e`); boatman pushes the new branch off this tip.

**Boatman direction**:

- This is a first-time ferry, not a re-ferry: open a new upstream PR rather than force-pushing to an existing branch.
- Apply the source diff `ea4d07bb..ed9ba729` (one file: `.github/workflows/ocapn-guile-interop.yml`) onto current `upstream/master`. Resolve any divergence: the upstream file already has iteration I plus the two "Claude" commits (the `persist-credentials: false` change and the stale-action-pin bump), so the diff context may be off by those edits; the boatman should rebase the diff in terms of the substituer-ordering change rather than as a verbatim patch apply.
- Single commit, author + committer `Kris Kowal <kris@cixar.com>`; verify with `git log upstream/master..HEAD --pretty=fuller` and `git interpret-trailers --parse`.
- Push to a fresh upstream branch.
- Open the upstream PR as a **DRAFT** via `gh pr create --draft -R endojs/endo`. Follow `skills/pr-formation/SKILL.md`: endojs/endo's PR template sections (Description / Security / Scaling / Documentation / Testing / Compatibility / Upgrade), behavior over diff, no checklists, no file callouts. **No garden references** (no "mirror of #255", no bot framing, no fork-only issue numbers). The source body's `Refs: #82` is a fork-only reference; translate to "Follow-up to commit `246c6a6c`" if the boatman judges that adds upstream-visible context, or omit otherwise.
- Source-side cross-link comment on `endojs/endo-but-for-bots#255`: post under the bot identity (standing repo authorization), naming the upstream PR URL and head.
- **Identity discipline**: no direct comments on `endojs/endo#<new>`; if an explanatory comment is warranted, route via `message`-to-steward.

**Expected report** (≤350 words): upstream PR number + URL + head SHA, attribution-verified, source-side cross-link URL, steward-message path if any, one-line `Self-improvement: ...`. If anything blocks (the source diff doesn't apply cleanly because of the "Claude" commits' interactions with the substituer block, or any other surprise), `message`-to-liaison and stop without opening the upstream PR.
