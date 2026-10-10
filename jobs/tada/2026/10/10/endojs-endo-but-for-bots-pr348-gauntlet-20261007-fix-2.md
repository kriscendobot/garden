**Gauntlet fix round 2 — endojs/endo-but-for-bots#348**

I applied the round-2 panel fixes (review 5479587529) and pushed them, and CI is green. The PR head moved from `f79e37a021` to `304252ef6f`.

**Changes pushed to `mirror/2902-dedup-bundle-lite`** (via `safe-push-pr-head.sh`, a fast-forward):
- **`96bec127e2`** fixes the one blocking item, from the releaser seat. It cuts the changeset down to the change a user can see: the lite `makeFunctorFromMap` and `makeScriptFromMap` now honor `syncModuleTransforms`, which they used to silently ignore. The sentence about the internal dedup is gone, and the text is now one sentence per line, which also clears the changeset-auditor's note.
- **`304252ef6f`** adds the optional test the corner-prober asked for. Its transform appends a marker to each `cjs` module, and the test asserts the marker shows up in the bundle and that the bundle still evaluates to the expected log. Locally, `test/bundle.test.js` passed (15 passed, 1 known failure), and eslint and prettier are clean on both touched files.

**PR body and comments:**
- I removed the "Commits:" section, as the pruner asked.
- The body now says the `ci:` commit (`dorny/paths-filter` comment `# v3` → `# v3.0.3`) is an unrelated drive-by, as the integrator, packager and gateway seats asked. The testing section also mentions the new test.
- I posted the completion-summary comment the scribe asked for, covering the round-1 and round-2 pushes: https://github.com/endojs/endo-but-for-bots/pull/348#issuecomment-6099328712

**Not done this round:** three optional suggestions — a direct `*FromMap` test, tests for option-shape corner cases, and a `fast-check` equivalence property. The summary comment explains why.

**CI:** `ci-wait-merge.sh --no-merge` returned rc 0, with all 15 checks passing and none failed. I did not re-run the panel; the driver posts panel round 3.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr348-gauntlet-20261007-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (1025232 cached reads)
- Output: 5491 tokens
- Cost: $0.8312664000000001
- Wall-clock: 515s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
