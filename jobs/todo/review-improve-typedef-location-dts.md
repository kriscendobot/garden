# review-improve: typedef-only `.js` modules must be `.d.ts` — add the deterministic layer

role: builder

Origin: the review-retrospective (prosecutor) second loop. Cluster
`typedef-location-dts` tripped the threshold via the **severity bypass** — a single
`severity: major` miss whose grounds cite a standing rule that already existed and did
not bind. The pattern spans two distinct PRs.

## The pattern (why this job exists)

The maintainer wants exported/shared type definitions in a hand-written `.d.ts`, not a
typedef-only `.js` module (or an inline `@typedef` block in an implementation `.js`).
He gave this directive **twice**:

- `endojs/endo-but-for-bots#58` review `4612637233` (2026-07-02, `trace-aggregator.js:41`):
  "Typedefs in .d.ts, please. **Adjust the garden to avoid this in the future with builder
  directives and a reviewer.**"
- `endojs/endo-but-for-bots#442` review `4629047816`
  (https://github.com/endojs/endo-but-for-bots/pull/442#discussion_r3522728825,
  `packages/platform/src/fs/types.js`): the same ask, on a whole typedef-only `types.js`.

After #58 the garden added a **builder directive** (`roles/builder/AGENT.md`, the
".d.ts / .ts types module" line) and a **typist seat-brief line**
(`roles/jurors/typist/AGENT.md`, the inline-`@typedef` check). Those are the two
*weakest* tiers in the review-retrospective preference order — prose an agent must
remember, plus a panel seat that only fires if the gauntlet actually runs. Neither
bound on #442, and the maintainer had to repeat himself. The recorded miss:
`review-misses/misses/endojs-endo-but-for-bots-pr442-review-61c65980.md`; the cluster:
`review-misses/clusters/typedef-location-dts.md`.

## Deliverable — BOTH halves are mandatory (a one-half completion is incomplete)

### (a) Prevention — the deterministic pre-push gate the #58 round omitted

Add a new pre-push-gate probe (the tier-1 durable check;
`skills/pre-push-gates/SKILL.md` § "Adding a probe") — a small shell/awk script under
the gate's `probes/` directory (`scripts/.../pre-push-gates/probes/<rule>.sh`), e.g.
`typedefs-belong-in-dts.sh`, that reads the staged diff and **fails non-zero** when a
changed `**/src/**/*.js` file is a **types-only module** — its meaningful exports are
`@typedef`/`@callback`/`@import` blocks with no runtime exports (the `types.js`
masquerade), i.e. a file that should be a hand-written `.d.ts`. This is NOT auto-fixable
(moving to `.d.ts` + repointing the `types` export condition needs judgment), so it is a
non-auto-fixable finding that fails the gate with a one-line summary the pushing step
addresses.

Keep the probe **narrow and deterministic** (per the gate's "too aggressive blocks a
legitimate diff" pitfall): match the clear whole-file-of-typedefs shape, honor the
existing escape hatch for a genuinely module-private single-use `@typedef` referenced
only within one `.js` file (do not fire on an implementation file that merely carries one
private typedef). Add the row to the skill's *Garden-specific deterministic probes* table
with this provenance (#58 + #442). Also **sharpen the builder/fixer directive**
(`roles/builder/AGENT.md`, and the fixer if it carries a sibling line) to name the
whole-`types.js`-module shape explicitly, not just inline typedefs — the #442 file was a
whole module, a slightly different shape than the seat brief's "inline `@typedef` in an
implementation `.js`".

### (b) Sensing — sharpen the always-on reviewer so the panel catches the module shape

`typist` is already always-on (`skills/panel-hints/SKILL.md`), so no probe is needed to
*fire* it. The gap is precision: amend `roles/jurors/typist/AGENT.md`'s type-definition
check to explicitly flag a **whole `.js` module whose entire purpose is exported
`@typedef`s** (a `types.js` / `*-types.js` file) as "should be a hand-written `.d.ts`",
in addition to the existing inline-`@typedef` case. The gate from (a) is the deterministic
half of the sensing (it cannot be skipped even when the gauntlet does not run — the #442
failure mode); the seat amendment is the judgment half for shapes the gate holds too
loosely.

## Verification — the re-litigation test (required in your completion report)

For each member of the cluster, name the exact check that now catches it and demonstrate
the gate probe fires on the historical diff:

- **#442** `packages/platform/src/fs/types.js` — the typedef-only module at the PR head
  before the fix (converted to `types.d.ts` in fix commit `660981551`). Show the new probe
  **fails** on that file's pre-fix content.
- **#58** `packages/daemon/src/trace-aggregator.js:41` — the inline exported `@typedef` the
  original directive flagged. Confirm it is covered by the sharpened builder directive +
  typist seat line (and, if it meets the probe's whole-file shape, the probe; if it is a
  single inline typedef, the seat/directive is the intended catch — state which).

Then close the cluster:

```
scripts/jobs/review-miss-record.sh cluster-status typedef-location-dts closed \
  --improved-by "<commits/files changed>"
```

## Norms

- Garden-infra job: build in an **isolated worktree off `origin/main2`**, commit explicit
  pathspecs, push `HEAD:main2` with a rebase CAS loop (the shared main2 tree is
  concurrently mutated). The probe + skill table row + role edits land together.
- The gate's executable lives under v2 `scripts/` (per the pre-push-gates skill); the
  `SKILL.md` is the contract, the script is the implementation — update both.
