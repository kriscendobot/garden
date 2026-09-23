The work is complete. Here is my report.

---

## Completion report: Mirror hardened262 into endo-but-for-bots

**Deliverable: draft PR endojs/endo-but-for-bots#1040** (`feat(hardened262): Mirror the Hardened JavaScript test262 harness`), head `kriskowal-hardened262`, base `llm`.

### What I did
Mirrored `@endo/hardened262` from `endojs/endo`'s `kriskowal-xs-native` branch onto `llm`: a test262-format harness that expands each Hardened-JavaScript case (lockdown, harden, freeze, Compartment, ModuleSource) into a **cross product of agent (bare `xs`, `sesXs`, `sesNode`) × mode × lockdown × compartment**, to catch shim-vs-native divergences.

**The design-fork the job flagged did NOT require a handoff.** I read both `designs/ironhorse-test262-convergence.md` and `packages/test262-runner` before writing code and determined the reconciliation is not a genuine architectural judgment call: hardened262's axis (shim-delivery parity) is **orthogonal** to test262-runner's (engine-conformance across xst/node/ironhorse over the tc39 corpus) and to the planned Rust `ironhorse-xst`; the corpora are **disjoint**. So it lands as a complementary third instrument, not a colliding duplicate. I documented this explicitly in the new package README and PR body, and named the two consumers (Ironhorse shim-obviation via the `xs` agent; byte-array `Uint8Array` validation for `@endo/bytes`/`base64`/`hex`/`immutable-arraybuffer`). The one genuinely design-shaped question — whether to eventually *unify* the three instruments into one runner — is called out as a deliberately-deferred follow-up rather than forced.

**Crucially, the underlying XS-native SES infra chain already exists on `llm`** (ses `src-xs` shims via the `xs` conditional export, `@endo/module-source/shim.js`, `@endo/compartment-mapper` tag-conditioned bundling). I verified the harness end-to-end: `yarn build` produces the XS prelude, and **all three agents run** (xst 17.9.1 + Node 22). `test/freeze/monadic.js` passes on `sesNode` but fails on `xs`/`sesXs` — the exact genuine-vs-emulated signal the harness exists to surface. So the "SES on XS" agent has real infra, not nothing to run against.

### What changed
- New package `packages/hardened262/` (scripts, harness includes, ~89 test cases, tsconfigs).
- Adaptations for this repo: added `@endo/compartment-mapper` as a dependency (imported but omitted upstream); pinned `typescript` to `catalog:dev` and dropped unused `ava`/`c8`/`tsd`/`ses-ava`/`lockdown` devDeps + the broken `test:c8` script; fixed `@endo/internal` eslint findings in the authored scripts; excluded the borrowed test262 trees from eslint (`eslint.config.js`) and prettier (`.prettierignore`); regenerated composite tsconfigs; wrote the README; made `SECURITY.md` byte-identical to skel.
- **Green locally (package scope):** `lint` (types + eslint + prettier, 0 errors), `build:types:check`, `test:package-uniformity`, and the harness itself.

### Follow-ups / notes
- PR is **draft** (correct — the load-bearing gauntlet flag). The panel/un-draft review is the supervised continuation; CI runs automatically on the PR.
- The whole-repo `pre-push-gates.sh` reports a failing lint stage, but every finding is **pre-existing debt in packages I never touched** (`module-source` project-service parse errors, ~31 warnings in 9p-server/agent-tools/capn-web/x402/zip). Zero findings are in `packages/hardened262/`; my only lint-config change is +10 ignore lines. Not attributable to this PR — noted so a later gauntlet run doesn't mistake it for a regression.
- Recorded a project memory (`hardened262-mirror`) capturing the infra-already-present finding and the deferred unification design question.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/mirror-hardened262-endo-but-for-bots.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 172 tokens (11391814 cached reads)
- Output: 87067 tokens
- Cost: $9.722089
- Wall-clock: 1655s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
