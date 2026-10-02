# Shepherd report: kriscendobot/minion.town PR #85

CI on PR #85 is green again: all three checks pass (`test` and both Claude harness checks) at head `cfc1a9c`, in run https://github.com/kriscendobot/minion.town/actions/runs/37036157415.

**What failed.** In the `test` check, the "live-daemon B1 acceptance" step failed on head `5e0dbbc`. That commit added in-place upgrades of a clip's back (powers). It was a real bug in the PR, not the known B1 flake. The daemon rejected the new path's `storeIdentifier` call with `Invalid formula identifier`. The error only showed up as a vitest `Cannot add property nameStr, object is not extensible`, because the daemon's error object is frozen. The upgrade stub from `directoryFor` passes the bare clip formula number, but the daemon needs the full `number:node` id. The fs record stores only the bare id too. This is the same kind of bug as minion.town#53.

**Fix.** One commit, `fix(clip): node-qualify the directory id before a back re-designation`, changing `src/endo/gateway/daemon-site-registry.ts`. Inside the guest, `guestRedesignateBackSource` now adds the node part of the guest's own `@self` id when the id has none. That works because the guest created the directory on this same daemon. Before pushing, typecheck and the 151 gateway unit tests passed locally. The live-daemon test needs the pinned Endo daemon, so it was checked only in CI. I pushed with `--force-with-lease` against `5e0dbbc`.

I posted a summary comment on the PR with the green run's link: https://github.com/kriscendobot/minion.town/pull/85#issuecomment-5957059936

**Follow-ups:** None. The PR is still a draft; its next step is review (`next: none`).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr85-shepherd.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1486068 cached reads)
- Output: 9323 tokens
- Cost: $1.0277616000000003
- Wall-clock: 370s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
