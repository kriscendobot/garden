---
tier: mentor
fallback-tier: minion
dispatch: automatic
requires: host=endolin-garden-ece02cb4
---
# Open the draft design PR for daemon-mount-visible-roots

Repo: endojs/endo-but-for-bots. Role: designer (PR-open handoff only).

Predecessor job `design-mount-root-attenuation-controller` (on host oros-studio-garden-ce242c49, whose bot PAT gets a 403 on endojs `createPullRequest`) already wrote the design and pushed:
- head branch `design/daemon-mount-visible-roots` (one commit adding `designs/daemon-mount-visible-roots.md`)
- frozen base `llm-825c598bc` (a snapshot of `llm` at 825c598bc)

Your ONLY task: open the draft PR. Do not edit the design. In an isolated checkout (`ensure-project-worktree.sh open-pr-design-mount-root-attenuation-controller endojs/endo-but-for-bots design/daemon-mount-visible-roots`), write the PR body below to a file and run, keeping the PREDECESSOR's job base so the durable marker matches:

    /Users/dom/garden/scripts/jobs/gardening/ensure-pr.sh design-mount-root-attenuation-controller endojs/endo-but-for-bots design/daemon-mount-visible-roots llm-825c598bc --title "design(daemon): mount views with visible roots and a root controller" --body-file <file>

Leave the PR DRAFT and name it (URL and number) in your completion report so the completion machinery stages its design-panel gauntlet.

PR body (verbatim, between the BODY markers):
BODY-BEGIN
<!-- garden-job: design-mount-root-attenuation-controller -->
Design for a filesystem mount attenuation that keeps the full POSIX namespace but makes all but chosen roots invisible, so symlinks from one visible root into another resolve, plus a root-controller facet (`EndoMountRootsControl`) that adds and removes visible roots.

Requested by @kriskowal in review of #1340: https://github.com/endojs/endo-but-for-bots/pull/1340#discussion_r4149165593

- Generalizes `assertConfined` from one root to a root set; a plain `EndoMount` is the one-root case.
- Roots are added as `EndoMount` capabilities, never path strings, so the controller cannot amplify authority. A root keeps its source's read-only bit, denied segments, and liveness.
- The controller follows the `makeRevocableMount` / `EndoMountControl` caretaker pattern. The root set persists in a daemon-owned pet store behind `mount-view` / `mount-view-control` formulas, created through `EndoHost.provideMountView`.
- `resolve()` gives #1340's tree `ReadPowers` a `canonical` that does not leak host paths. This removes the hoisted-layout requirement for pnpm symlinked stores and workspaces whose targets fall under a visible root.

Three open questions are listed at the end of the design.

🤖 Generated with [Claude Code](https://claude.com/claude-code)
BODY-END

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-30T23:27:02Z
