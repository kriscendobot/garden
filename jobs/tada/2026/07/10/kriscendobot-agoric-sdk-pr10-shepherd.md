I've completed the diagnosis and surfaced it. No push to PR #10 was warranted — the fix belongs elsewhere. Here is my report.

---

## Shepherd report — kriscendobot/agoric-sdk PR #10

**Live CI state (head `13a7799e`):** Exactly one red check, `test-codegen`; all other ~60 checks pass. `mergeable_state: unstable` (i.e. only the failing check), not conflicting.

**Root cause — not this PR's:** `test-codegen` runs a codegen-idempotence check. Running `yarn codegen` in `packages/orchestration` regenerates `src/fetched-chain-info.js` with a diff, so the checked-in generated file is stale. PR #10 changes **only** `designs/beans-v2-deflation.md` (docs-only design PR) and never touches that generated file. PR #10 is `behind: 0` from master, so **master itself carries the stale file** — this is a global codegen drift on the fork, not introduced by PR #10.

**Already owned elsewhere:** PR #8 (`regen-fetched-chain-info`, OPEN, non-draft, MERGEABLE) exists specifically to fix this, changes only `packages/orchestration/src/fetched-chain-info.js`, and its `test-codegen` is SUCCESS.

**Why I did not push to PR #10:** Regenerating the file inside a docs PR would duplicate PR #8 and produce a redundant/conflicting generated-file diff that collides when either lands — the wrong place for the fix. This is a "fix belongs elsewhere" impasse, not a scope-cap dodge. No commit to PR #10's head; correct scope preserved.

**Recommended resolution:** (1) merge PR #8 to master (regenerates the file on master); (2) refresh/weave PR #10 onto the new master so its CI re-runs and goes green. Step 1 is a conductor/human decision.

**Surfaced:** Delivered the above to the maintainer inbox via the liaison (`20260710T063539Z-33f87e`).

**Escalation classification:** `next: liaison` — the canonical fix is merging PR #8 (human/conductor decision), after which PR #10 needs a weave/refresh; neither is a shepherd action on a draft docs PR.

**Follow-ups:** Merge PR #8 → refresh PR #10. The same drift will red every other in-flight fork PR until PR #8 lands, so landing it clears the fork-wide `test-codegen` failure at once.

No garden-repo (main2) changes were needed for this job.
