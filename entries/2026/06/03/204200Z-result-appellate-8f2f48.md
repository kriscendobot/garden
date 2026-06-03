---
ts: 2026-06-03T20:42:00Z
kind: result
role: appellate
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
prs:
  - endojs/endo-but-for-bots#417
refs:
  - entries/2026/06/03/203807Z-dispatch-liaison-8f2f48.md
  - entries/2026/06/03/203900Z-result-justice-53be75.md
  - entries/2026/06/03/201004Z-result-barrister-c117d2.md
  - https://github.com/endojs/endo-but-for-bots/pull/417
---

# result: appellate on #417 (no promotions; un-draft can proceed)

Gamut stage 5 on the mirror of erights's `endojs/endo#3164`. Appellate
audit of the justice's terminating verdict (`approve`, round 2). Three
`follow-up` and three `acknowledge` dispositions carried from the
barrister's round-1 verdict; the appellate audits each against the
small-and-in-context + loss-track rubric per `roles/appellate/AGENT.md`.

## Overall verdict: no promotions

All 6 carried dispositions are either future-conditional (out-of-context
for the current PR's diff) or are observations rather than actions.
Nothing crosses the promotion bar. The judge's deferrals stand.

## Per-disposition verdict

### Follow-up items (3, parked in ledger)

1. **Rebase-artifact carry** (packager via cleaner). *Recommended
   action*: when upstream `endojs/endo#3164` merges, confirm 4
   upstream-master commits reconcile cleanly.
   - **small?** yes (conditional confirmation).
   - **in-context?** no. Work depends on the upstream PR merging; the
     bot-side mirror branch cannot pre-resolve. The bot-side mirror's
     `master` is already current with `endo-upstream/master`
     (`ba26f4cdb`), so the reconciliation is upstream-PR-side.
   - **loss-track risk?** low. Ledger entry with `status: parked`,
     `upstream_mirror_pr: 3164` is the canonical home; steward's
     per-cycle survey revisits on merge.
   - **Verdict: keep as follow-up.**

2. **Post-shim-wiring second-round re-panel** (integrator,
   fast-checker, spec-keeper). *Recommended action*: when shim wiring
   lands upstream, open a follow-up bot-side PR and run a fresh
   code-panel pass.
   - **small?** no. A full code-panel round on a future PR is the
     opposite of a small in-PR addition.
   - **in-context?** no. The shim wiring (the `makePseudoTypedArrayConstructor`
     call site in `immutable-arraybuffer-shim.js`) is explicitly NOT in
     this PR; the current PR adds the static plumbing only.
   - **loss-track risk?** low (ledger-parked).
   - **Verdict: keep as follow-up.**

3. **Changeset on merge** (releaser). *Recommended action*: when
   upstream merges, confirm changeset names both
   `@endo/immutable-arraybuffer` and `@endo/ses` at the right semver
   level.
   - **small?** yes (a `.changeset/*.md` file is small).
   - **in-context?** marginal. The releaser explicitly noted "the
     natural home for the changeset is the upstream PR"; landing a
     bot-side `.changeset/*` that the upstream `endojs/endo#3164` will
     not carry creates divergence between the mirror and its upstream.
     The bot-side mirror inherits whatever changeset the upstream PR
     lands with.
   - **loss-track risk?** low. The upstream changeset is the canonical
     write; the bot-side mirror is read-only from the changeset
     perspective.
   - **Verdict: keep as follow-up.**

### Acknowledge items (3, in justice round-2 body only)

4. **`pony.js` reduction to 7-line re-export** (packager). The
   reduction is intentional; the moved bodies live in
   `immutable-arraybuffer-pony-internal.js`.
   - This is an *observation* that the diff's hygiene choice is correct,
     not an action item. There is no work to promote.
   - **Verdict: keep as acknowledge.**

5. **`globalThis` directive** (warden). The
   `// eslint-disable-next-line no-restricted-globals` on the
   `globalThis` destructure is the sibling-file standard pattern.
   - Observation, not action.
   - **Verdict: keep as acknowledge.**

6. **`@ts-expect-error` narrowing** (typist). The `@ts-expect-error
   testing purposeful type violation` swaps in `pony-slice` /
   `shim-slice` tests are an improvement over the prior
   `@ts-nocheck` blanket suppression.
   - Observation of a positive choice already in the diff; not an
     action.
   - **Verdict: keep as acknowledge.**

## Proposed summary-fix bundle

None. The terminating round's `summary-fix` count stays at 0; the
appellate adds nothing to it.

## Top-level PR comment

Not posted. Per `roles/appellate/AGENT.md` § External-repo etiquette,
the appellate's output is the proposal list in the journal; the
orchestrator's amendments to the summary-fix job carry the work to the
PR via the fixer. The dispatch's per-action authorization to post a
top-level PR comment naming proposed promotions is unused this engagement
(no promotions to surface).

## Un-draft readiness

**Un-draft can proceed immediately.** No promotion-fixer needed. The
liaison's next step on the gamut is `gh pr ready 417`.

## Audit-trail count

- `follow-up` items considered: 3 (all parked in the ledger at
  `journal/projects/endo-but-for-bots/followups/endo-but-for-bots--417.md`).
- `acknowledge` items considered: 3 (in the justice round-2 review body
  at `pullrequestreview-4422559798`).
- Items proposed for promotion: 0.
- Items audited and silenced: 6.

The appellate ran and chose to silence on every disposition; the
deferral set is well-shaped for the PR's mirror posture.

## Authorizations respected

- Read the followup ledger and justice's findings. Used.
- Post a top-level PR comment naming any proposed promotions +
  rationale. Authorized but unused (no promotions to surface).
- Update the followup ledger if a promotion-side edit landed. Authorized
  but unused.
- Did not modify source files, did not force-push, did not un-draft,
  did not touch upstream `endojs/endo`. Respected.

Self-improvement: nothing this time. The PR's mirror posture made the
appellate audit straightforward: all three follow-up items are
future-conditional on upstream events (PR merge, shim wiring landing,
changeset on merge), and all three acknowledge items are observations
about the diff's positive choices rather than action items. None
crossed the small-and-in-context bar. The conservative-bias norm in the
role file matched the outcome: when in doubt, the judge's deferral
stands, and here there is no doubt.
