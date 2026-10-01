**Fix round 4: endojs/endo-but-for-bots#1390, gauntlet `ebfb-petname-path-only-sweep-3-gauntlet`**

I pushed no new commits. All five must-fix items from the round-4 panel review (03:21Z, head `784decdc7a`) were already on the PR head when I claimed the job. A parallel gauntlet on the same PR (`endojs-endo-but-for-bots-pr1390-gauntlet-20261001`) pushed them, and CI is green at the current head `4427342873`: 33 checks, 0 failed (`ci-wait-merge.sh` returned 0).

I checked each item against the current head:
1. **typist:** fixed by `45efa290a7`. `container-mounts.js:307` now passes `[journalName(sequence)]`. The floot test fakes in `container-mounts.test.js`, `-hosted.test.js` and `-sandbox.test.js` now go through a `petKey` helper that throws on anything but a string array, as the daemon does.
2. **locksmith:** fixed by `01ed8e0d64`. The PR no longer adds any `.split('/')` in `command-executor.js` or `chat.js`. About 25 `.split('/')` calls are still in `command-executor.js`, but they are also on the base branch `llm-8e53cc0`, so they are older code and outside this PR.
3. **surfacer:** fixed by `eba24922a2`. `types.d.ts` now uses `resultNamePath`, `archiveNamePath` and `correspondentNamePath`.
4. **stylist:** fixed by `049164fe22` and `eba24922a2`. `petNames` is renamed to `petNamePaths` in lal's `mail.js`, `tool-dispatch.js` and `mock-powers.js`, and the `help.md` / `help-text-data.js` headers use `*NamePath`.
5. **integrator:** the PR body already has the #1343 overlap with its landing order and rebase plan, and says this PR is not a phase of `designs/fs-interface-consolidation.md`.

Of the two should-fixes, the purist one is done: `interfaces.js` has a comment at the spread explaining why `lookup`/`maybeLookup` keep the wider shape. The integrator one is not: `@endo/agent-tools` `evaluate-tool.js` still calls its argument `resultName`. Renaming it changes the schema the LLM sees, so it needs its own changeset.

**Follow-ups**
- The PR body says the #1343 overlap and the design note twice, once in "Relationship to other work" and again in two paragraphs below it. I drafted a merged version, but `gh pr edit` failed with "Resource not accessible by personal access token": this host's bot token can't update endojs PRs. It's cosmetic, and a run on `endolin-garden-ece02cb4` could apply it.
- The other gauntlet's terminal comment at 07:02Z says "halted, CI red" at `4427342873`. CI at that same head is now green, so that halt is out of date.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-petname-path-only-sweep-3-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1041197 cached reads)
- Output: 7506 tokens
- Cost: $0.8587113999999998
- Wall-clock: 1117s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
