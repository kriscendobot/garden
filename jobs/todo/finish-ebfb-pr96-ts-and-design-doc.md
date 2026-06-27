# endo-but-for-bots #96 — address the two remaining 17:55Z review asks

Repo: `endojs/endo-but-for-bots`, PR **#96**
(`design/compartment-mapper-auxiliary-package-json`).

Wear the **builder** role (`roles/builder/AGENT.md`; escalate to fixer detail as
needed). Bot-fork PR — bot identity, **no** identity switch. Commit + push to #96's
branch and post a top-level PR summary comment plus inline thread replies on the
two source comments.

## Context

PR #96 implements the compartment-mapper auxiliary-`package.json` design. The
06-24 "finish the implementation as designed" directive and the 06-25 general
transitive-dependency reconciliation are **already landed** (commits `729e07f` →
`16ce3b08`, CI green). This job is ONLY the two still-open asks from kriskowal's
CHANGES_REQUESTED review **id 4573560420** (2026-06-25T17:55Z). The review's third
inline ask (consolidate descriptor types into the `.d.ts` tree) was already
resolved in `63266ca` — do NOT redo it.

## Task — two asks, both unaddressed

1. **TypeScript-extension parity** — comment on
   `packages/compartment-mapper/src/language-for-extension-by-prefix.js`
   (2026-06-25T17:53Z):
   > "We should also account for ts, mts, cts, including test fixtures with parity
   > confirmation with Node.js."

   Extend the per-prefix language-for-extension mechanism so an auxiliary
   `package.json` `type` override also governs `.ts`, `.mts`, and `.cts` the way
   it already governs `.js`/`.mjs`/`.cjs`. Add test fixtures (follow the existing
   `fixtures-auxiliary-*` topology, including a flip-back subtree for regression
   evidence) and confirm parity with Node.js's own resolution of those extensions
   under the same `type` rules. Honor `skills/node-parity-test/SKILL.md`.

2. **Design-doc relocation/rewrite** — comment on
   `designs/compartment-mapper-auxiliary-package-json.md` (2026-06-25T17:52Z):
   > "Since this is targeting master, we can now move this into a
   > compartment-mapper/designs/ document that simply states what was implemented
   > and omits any incidental information of the process for arriving at the
   > implemented design."

   Move the design into `packages/compartment-mapper/designs/` as a clean
   as-implemented document — describe the final mechanism only, drop the
   phase-by-phase process narrative and superseded-decision history. Remove the
   old top-level `designs/` copy.

## Definition of done

Both asks implemented, tests added and green (coverage-driven; regression evidence
that neutralizing/flipping an aux `package.json` fails the relevant test), `tsc`
and `eslint` clean over `@endo/compartment-mapper`, pushed to #96's branch under
the bot identity. Reply inline on both source comments and post a top-level PR
summary comment (SHA + what changed + verification). Post `shepherd-ebfb-pr96` to
drive CI to green if the change is non-trivial. Report the head SHA and what was
done; if Node.js parity for `ts/mts/cts` is ambiguous (e.g. Node's own handling of
bare `.ts`), surface the ambiguity rather than guessing.

---
Posted by gardener picking up dead-lettered job
`deadmail-20260625T170305Z-ce5467` (intended recipient
`endojs-endo-but-for-bots-pr96-rebase` had already completed; its reconcile diff
landed, so this carries the workstream's still-open maintainer asks forward).
