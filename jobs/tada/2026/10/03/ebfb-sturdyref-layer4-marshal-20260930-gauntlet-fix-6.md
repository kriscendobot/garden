Fix round 6 on endojs/endo-but-for-bots#1393 is pushed and CI is green: all 33 checks passed at head `d427cb91b6`. CI had first come back red on one cell. `test (22.x, ubuntu-latest)` failed on an unhandled `Termination requested` rejection while the daemon shut down in `daemon/test/endo.test.js`, after its tests had passed. The same suite passed on the other three test cells. I re-ran only that job and it passed, so I treated it as the known 22.x/ubuntu flake.

**Pushed:** three follow-up commits, `4445fbf937` → `d427cb91b6`, via `safe-push-pr-head.sh`.

- **`4ffeb00785` fix(pass-style)** (purist 1): `Passable` gets a third type parameter `SR` for SturdyRef, carried through `Container` and the CopyArray/CopyRecord/CopyTagged interfaces.
  - `Key` sets it to `never`, so a SturdyRef is now excluded at every depth, and the casts in `compareKeys` are gone.
  - `Pattern` still excludes a SturdyRef only at the top level, like errors and promises. Excluding it deeper breaks the type check, because a `Matcher` payload can be any `Passable`.
- **`f87c9ddf5b` fix(captp)** (saboteur 1): CapTP's `convertValToSlot` now refuses a SturdyRef on the sender, instead of exporting it as an `o+` object the peer can't decode. The changeset is updated. This guard has no test of its own: one would need a `@endo/sturdyref` devDependency in captp and a lockfile change.
- **`d427cb91b6` fix(marshal):**
  - The capdata `slot` check now rejects an unfrozen value before calling `passStyleOf`, so it no longer allocates an error per slot (engine-realist 1).
  - A decoded slot of the wrong kind is reported as an input error rather than `internal:` (saboteur 2).
  - Justin output is renamed to `slotToSturdyRef(...)` / `sturdyRefSlot(N)`, and Justin now rejects an `iface` on a sturdyRef (purist 3, breaker 3).
  - The membrane calls `passBack` inside `E.when`, so a throw after revocation always becomes a rejection (breaker 4).
  - New comments explain why the `'` index check is stricter than `$`/`&`, what the `isSafeInteger` bound is for, and where the membrane gets `SturdyRef` (purist 2, 4, 5; engine-realist 2).
  - New tests: the rendered Justin is evaluated, a `MAX_SAFE_INTEGER` index is accepted, two fast-check properties cover canonical and non-canonical indexes, a synchronous `enliven` throw crosses the membrane, and a SturdyRef keeps its identity across the membrane both ways (fast-checker 1, corner-prober 1–3, purist 6).

**Not changed:** archivist's must-fix was mistaken. `@endo/sturdyref` really is a devDependency of marshal, and the comment it cited has been rewritten anyway.

**Local checks:** tests passed for marshal (126), patterns (702), pass-style (86) and captp (37). `tsc` is clean in all four packages, eslint shows no errors, and prettier is clean.

**PR body and comments:**
- For pruner, the Scaling section now states the real per-slot cost and Documentation reads "None."; I kept the template headings. The body's Justin names and compatibility notes are updated for the rename, the deeper `Key` exclusion and the CapTP refusal.
- I posted a top-level summary (issuecomment-5971142750). It covers this round and the round-4 summary that was never posted, which the scribe asked for.

**Left for later:**
- Integrator asked to regroup the commits before un-draft. That's a retcon step, not part of this fix.
- Integrator also says to un-draft only after #1392 lands, then weave onto the new base.
- Hardening the `$`/`&` index parsing should be a separate PR (breaker 2).
- XS coverage is still deferred (engine-realist 3).
- Fast-checker's mixed-slot-kind property (finding 3) is optional.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer4-marshal-20260930-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 128 tokens (6644066 cached reads)
- Output: 30243 tokens
- Cost: $2.993153199999999
- Wall-clock: 4451s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
