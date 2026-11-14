# PR #1594 fix pass: all tests pass, only the base-wide `zizmor` check is red

The PR head is now `fbded5f805`. Every test leg passes; the only red check is `zizmor`, which currently fails on every PR in the repo, not just this one.

**The red Node 24 test wasn't caused by this PR.** It was `bwrap › bwrap timeout and repeated cancellation reap process groups` in `@endo/sandbox`, which this PR doesn't touch. The test is intermittent on the ubuntu-26.04 runners: on the same code it failed and passed across runs. The fix for it is open PR #1566, which hasn't merged yet. On the final head, all four `test` legs (Node 22/24 on ubuntu and macOS) and `sandbox-drivers` pass, though the Node 22 leg needed one rerun after hitting that same flake.

**Review findings:** most earlier panel must-fixes were already fixed at `9b0619a17b`. One was left: the changeset described a `@deprecated` re-export of `WorkerFacetForManagerInterface` that pointed at a module consumers couldn't import. Commit `fbded5f805`:
- adds `./src/worker-facet-interface.js` to `packages/daemon/package.json` exports;
- rewords the changeset so that module is the canonical import path, the `interfaces.js` re-export is called deprecated, and it no longer claims "no deprecated aliases".

The pre-push probes passed. I couldn't run the package's tests locally because the checkout has no `node_modules`, so CI is the only test evidence.

**The `zizmor` failure:** two workflows pin `peter-evans/create-pull-request@5f6978f # v8`. The floating `v8` tag has moved to v8.1.3, and the pinned sha is v8.1.1, so `zizmor` flags the comment. I tried the comment fix on this branch and it turned `zizmor` green. But touching workflow files made CI select more sandbox legs that hit the same bwrap flake, so I took it back out by rewriting the branch history. The final head has the same files as `fbded5f805`'s parent plus the changeset fix, with no workflow changes.

**Other actions:**
- I posted job `fix-endo-zizmor-create-pull-request-v8-comment` to change both comments to `# v8.1.1` on `llm`.
- I posted and then updated a summary comment on the PR: https://github.com/endojs/endo-but-for-bots/pull/1594#issuecomment-6874359436

**Follow-ups:**
- This PR is on the frozen base `llm-9a14ddf`, so the `zizmor` fix only reaches it after that job lands on `llm` and the PR is woven onto the new base. A fresh gauntlet should run after the weave, or now if a `zizmor`-only red is acceptable.
- PR #1566 still needs to land to stop the bwrap flake.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `50b82489fd3afd3ff14960c4242b8a6d360a9dce`; this job presented `fbded5f8052c48717b60cabae6f974172da2bfc4`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket accepted a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-endojs-endo-but-for-bots-pr1594.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 8 tokens (595388 cached reads)
- Output: 2313 tokens
- Cost: $0.20492960000000002 (1 engagement(s) unpriced)
- Wall-clock: 11053s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
