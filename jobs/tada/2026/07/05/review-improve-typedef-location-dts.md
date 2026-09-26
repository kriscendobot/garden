All work is complete and verified. Here is my completion report.

---

## Completion report: `review-improve-typedef-location-dts`

Closed the `typedef-location-dts` review-miss cluster by adding the missing tier-1 deterministic layer plus sharpening the two sensing tiers. Landed as commit `33a6994ef` on `main2`; cluster marked `closed` in `journal2`.

### (a) Prevention — the deterministic pre-push gate (the tier the #58 round omitted)
- **New probe** `scripts/jobs/gardening/pre-push-gates/probes/typedefs-belong-in-dts.sh` (executable, `bash -n` + `shellcheck` clean). It fails the gate non-zero when a changed `**/src/**/*.js` file is a **types-only module** — a character scanner strips `//` and `/* */` (incl. JSDoc) comments while skipping string literals, and the file fires only when it declares `@typedef`/`@callback` yet, once comments and the empty `export {}` marker are removed, has **no runtime code**. Non-auto-fixable: emits one `fail: <path> …` line the pushing step addresses. Subcommands `--check-file` / `--classify-stdin` support the driver and testing.
- **Narrow by design** (honors the "too aggressive" pitfall): any implementation `.js` with runtime code never matches, so the module-private single-use inline-`@typedef` escape hatch is honored automatically.
- **Skill contract updated** — `skills/pre-push-gates/SKILL.md`: new row in the *Garden-specific deterministic probes* table with #58 + #442 provenance, plus a dated field note.
- **Directive sharpened** — `roles/builder/AGENT.md` now names the **whole typedef-only `.js` module** (`types.js` masquerade) shape explicitly, not just inline `@typedef`; the probe added to the builder + fixer gate enumeration. (The fixer carries no standalone typedef house-style line, so only its gate enumeration was touched — per the job's conditional.)

### (b) Sensing — the always-on typist seat
- `roles/jurors/typist/AGENT.md`'s type-definition check now flags **both** shapes: (1) a whole `.js` module of exported `@typedef`s → should be a hand-written `.d.ts`, and (2) the existing inline case. Notes the gate is the deterministic half and the seat the backstop for a PR whose gauntlet did not run (the #442 failure mode).

### Verification — the re-litigation test
- **#442** `packages/platform/src/fs/types.js` (typedef-only module at PR head before fix `660981551`): the probe **fires** — `--classify-stdin` → `types-only`; full `run_probe` over a reconstructed staged diff prints the `fail:` line and exits 1. This is now caught deterministically by the gate (cannot be skipped even when the gauntlet doesn't run) and by the sharpened typist seat + builder directive.
- **#58** `packages/daemon/src/trace-aggregator.js:41` (inline exported `@typedef` in a 45-runtime-line implementation file): the probe **abstains** (`not-types-only`) — correct, because it is a single inline typedef in an impl file, not a whole-file masquerade. Its intended catch is the **sharpened builder directive + typist seat line** (the inline-`@typedef` case), not the gate. Stated explicitly per the job.
- Control cases confirmed narrow: impl file with a private typedef, `@typedef` inside a string, block-comment-plus-runtime-export, and comments-only-no-typedef all correctly do **not** fire; a real named export blocks a fire.

### Cluster closed
`review-miss-record.sh cluster-status typedef-location-dts closed --improved-by "…"` → `status=closed`, verified in `journal2`.

### Follow-ups
- The `pre-push-gates.sh` **driver** and its `probes/` directory did not previously exist under `scripts/` (the skill's executable counterpart is still unimplemented — the double-space README references a `skills/pre-push-gates/probes/…` path that also doesn't exist). I placed the probe at the SKILL-canonical location under `scripts/jobs/gardening/pre-push-gates/probes/` so a future driver picks it up by glob, but **the driver itself remains to be built** — until it exists, these probes (this one and the others the skill's table promises) run only when invoked directly, not automatically at push time. Worth a follow-up job to implement the driver and wire it into the gardening push path.
