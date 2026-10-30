I un-drafted PR #1425: endojs/endo-but-for-bots#1425, "fix(ses): build the XS lockdown Compartment from lockdown intrinsics". It is now ready for review.

**Gate check.** Right before the un-draft, the PR was OPEN and still a draft, and its head was exactly `2db6a8171422b8d4b23a05599ceb267530a36a2a`, the commit the panel passed. I ran `gh pr ready` and checked again afterwards: `isDraft=false`, and the head is unchanged.

**Advisory appellate pass (does not block the un-draft).** I gave a `claude -p` review only the first 6 KB of the diff. That cut off inside `repairIntrinsics`, before the code that calls the callback, so it saw only part of the change. It raised these points for a reviewer to check:
- `LockdownShimStartCompartment` is only set if `repairIntrinsics` calls the callback. If any path skips the call, the adapter silently gets `undefined`. It suggested a guard that throws instead.
- `tsc` may flag the `let` that has no initial value and is assigned inside a closure (TS2454).
- The new Compartment constructor may not share its prototype with the import-time one. If so, `evaluate` and `import` could be missing on compartments created after lockdown, and `instanceof` checks could fail.
- Check that the `lockdown` and `repairIntrinsics` wrappers can't pass a caller's callback through. That would hand the caller the constructor.
- No XS-specific tests appeared in the part it saw. Examples: a new compartment gets the tamed `Date`, and `Compartment()` without `new` still throws. XS tests may also not run in default CI.
- The workflow's `apt-get install` is unpinned and needs an `apt-get update` on every run, which adds time and a possible flake. The `graphviz-tools` fallback hasn't been tried on 24.04 runners.
- The changeset is marked `patch`. XS users who relied on untamed globals in new compartments could break, so the changeset text could say so.

**Follow-ups:** none required. The maintainer's review can weigh the advisory points.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1425-gauntlet-20261030-run-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (177405 cached reads)
- Output: 1594 tokens
- Cost: $0.42260100000000006
- Wall-clock: 48s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
