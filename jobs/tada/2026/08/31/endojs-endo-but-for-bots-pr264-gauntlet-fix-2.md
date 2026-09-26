Confirmed the terminal state: PR head is my pushed commit `5f712d14`, the PR touches only `designs/README.md` and `designs/compartment-mapper-import-attributes.md` (100% docs), and it carries **zero** CI checks (verified via both `gh pr checks` and an empty `statusCheckRollup`). endo's workflows are path-filtered to `packages/**`, so a docs-only design PR attaches no checks — CI is vacuously green, nothing pending or red. The fix is pushed and terminal.

## Completion report

**Job:** endojs/endo-but-for-bots PR #264 — gauntlet FIX round 2 (design-doc PR: import-attributes propagation proposal).

**Panel must-fix items applied (both from the skeptic; critic finding 1 is the same defect):**

1. **`link.js` walkthrough invented a static `moduleMap` construction option that does not exist.** Verified against `packages/compartment-mapper/src/link.js`: the sole `new Compartment(...)` call site (line 500) passes only a *dynamic* `moduleMapHook` built by `makeModuleMapHook` from `compartmentDescriptor` + its `modules` descriptor — no static `moduleMap`. Rewrote the "Today" description, the "Under this design" partition, the three-case `moduleMapHook` analysis (case 3), the concrete-touchpoints table, the partition-step prose, the Test-plan entries, and the References recap so "legacy-collapse slot" now names the unchanged `moduleMapHook`/`importHook` path, and only *non-JS* attribute-bearing records are seated through the new `modulesWithAttributes` option.

2. **SES arity-rule restatement dropped the `{ type: 'js' }` exception and declared the misreading load-bearing.** Verified against `designs/ses-import-attributes.md` § `importHook signature` (a length-1 hook is served specifier-only when attributes are empty **or** `{ type: 'js' }`; it throws only for a *non-JS* `type`). Corrected the load-bearing arity-rule paragraph, then propagated the empty-vs-non-JS boundary through every downstream consumer that had inherited the over-strict conflation: the live-path upgrade diagnostic, the archive write-path tag, and the archive read-side fail-fast — so an explicit `with { type: 'js' }` graph now gets the soft landing SES actually gives it. Added explicit `type: 'js'`-boundary tests (live-path companion + archive no-tag) to close the "ships untested" gap the skeptic flagged.

**Should-fix polish also applied** (to reduce panel-3 risk): decomplector ×2 (named `moduleMapHook` as the sole participant outside the uniform carry rule; made the policy-passthrough scope-bound argument explicit); copyeditor idioms ("spell out", split "sibling of/depends on"); pedant (Latin shorthand `i.e.`/`e.g.`/`vs.` in the cited prose spots, `SHA-pinned archive integrity` hyphenation, lowercase `node-modules`). Kept the doc's house style of **zero em-dashes** (rewrote all interim dashes into commas/colons/parens).

**Push & CI:** committed as `5f712d14` and pushed to `endojs/design/compartment-mapper-import-attributes` via `safe-push-pr-head.sh` (advanced `9aa9efa8` → `5f712d14`). CI watch: the PR changes only `designs/*.md`; endo's workflows are path-filtered (lint checks only `.github`/`packages`), so the PR attaches **no** checks (`statusCheckRollup` empty; `gh pr checks` reports none). `ci-wait-merge.sh` cannot distinguish "no checks yet" from "no checks ever" and would spin to its deadline, so I stopped it after confirming — two ways — that the head is my commit and zero checks exist. CI is vacuously green.

**Follow-ups:** none for this stage. Stopped without re-running the panel, per the stage contract (the driver re-posts panel-3). Note: the PR is still `mergeable: CONFLICTING` against base — a rebase/weave is a separate concern outside this fix stage, not a CI/must-fix item.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr264-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 168 tokens (8601260 cached reads)
- Output: 46449 tokens
- Cost: $6.781695000000001
- Wall-clock: 1273s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
