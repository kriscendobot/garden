I checked the upstream PR, its review history, and the fork's `llm` branch. Nothing has replaced this work, so the gauntlet can start.

**Deciding question:** Is the change in endojs/endo#3137 (`.ts` runtime modules via erasable type syntax: `E.ts` and `patternMatchers.ts` migrations, the `no-nonrelative-ts-import` lint rule, amaro loading for `@endo/cli` and `@endo/daemon`, `docs/typescript.md`) still unlanded and not replaced, upstream and on the fork, with the upstream proposal still live?
Answer: **yes**.

**Evidence:**
- **The fork PR is live.** endojs/endo-but-for-bots#546 is OPEN, not merged and not a draft. Base is `master-5be15cb`, head is `2f2c0a3b` (a verbatim mirror of upstream #3137). It has no reviews or comments on the fork, and was last updated 2026-09-01.
- **Upstream #3137 is still OPEN and active.** Its head is the same `2f2c0a3b`. mhofman requested changes and boneskull raised concerns about the added complexity. turadg reworked the PR in response on 2026-05-27: `.ts` entrypoints were dropped, and the lint rule mhofman asked for was added. Nobody has rejected or closed it.
- **The groundwork landed; the feature did not.** Upstream merged #3261 (amaro type stripping, 2026-05-14) and #3260 (packing via ts-node-pack, 2026-05-23). #3137 builds on both. It is not replaced by them.
- **The fork's default branch has none of it.** On `llm` (5324 commits ahead of the PR base, 0 behind), `packages/eventual-send/src/E.js` still exists. `E.ts`, `patterns/src/patterns/patternMatchers.ts`, `eslint-plugin/lib/rules/no-nonrelative-ts-import.js` and `docs/typescript.md` are all absent.
- **No competing PR.** Searches on both repos found no other PR doing the same thing. Fork PRs #909 (TypeScript in confined CLI commands), #514, #594 and #438 (lint and type-checking tooling) are about different things.
- **The motivation still holds.** The repo minimum is still Node 22, which strips types natively. Upstream review is still asking for exactly this direction, refined.

**Caveat:** the PR base is 5324 commits behind `llm`. Expect rebase and conflict work later in the gauntlet. That affects cost, not whether the PR is still needed.

I spent nothing on cleaning, panel review, fixes, CI waits or un-drafting, and I made no repo changes.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr546-gauntlet-20261007-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (262058 cached reads)
- Output: 2502 tokens
- Cost: $0.44378759999999995
- Wall-clock: 46s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
