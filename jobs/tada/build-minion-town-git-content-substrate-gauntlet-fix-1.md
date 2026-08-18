Fix stage complete. Inbox empty.

## Completion report — FIX round 1, kriscendobot/minion.town PR #48

**What I did.** Read the panel-1 request-changes verdict (20 must-fix items across 28 seats, terminal disposition `must-fix`) and applied the consolidated must-fix set in one review-feedback follow-up commit (`c0109c8`) to the PR head `feat/git-content-substrate-serving`, then watched CI to green.

**Fixes applied (source):**
- **Cross-origin content serving (top security finding — warden/saboteur/breaker/locksmith/migrator).** The immutable `/.content/<root>/` tier now binds the URL root to the record: it serves only the record's current root or a retained previous root, so a foreign weblet's root is refused (`404`) instead of executing under another origin. Added `previousRoots` (bounded, written on advance) + a `mutable` flag to `VhostRecord`.
- **Record-blind no-op short-circuit (assessor/archivist/prover/spec-keeper/saboteur/migrator).** Removed; the CAS always reads the durable record (reports `conflict` when a peer advanced past `expected`) and always re-interns (restores GC'd blobs). `changed` threaded through.
- **Unreadable-record-as-absent (locksmith/saboteur/purist).** `readVhostFile` now distinguishes ENOENT from a read/parse fault; an unreadable record fails the swap closed rather than clobbering `owner`/`powers`.
- **weblet_publish cache regression (packager/migrator).** Cache tier is selected by record kind — content-derived (seeded/`weblet_publish`) origins keep the hard-immutable tier; only `mutable` git-substrate records serve `no-cache`.
- **Prototype pollution (assessor/typist/warden/prover/purist/breaker).** `Object.create(null)` + `Object.hasOwn` for all path→entry maps (projector, content-store, publish); reject `__proto__` segments; Map-based sub-resource-attr lookup (no crash on `<constructor>`).
- **srcset / `<link rel>` / raw-text / non-UTF-8 (assessor/prover/spec-keeper/purist).** Grammar-aware srcset (data: URLs preserved); navigational `rel`s left root-free; `<script>`/`<style>`/comment regions skipped; non-UTF-8 documents interned raw.
- **Projection limits on post-rewrite bytes (saboteur/breaker); shared `RESERVED_FIRST_SEGMENTS` (curator/purist); decode-once + serve-time HTML size cap + stream-destroy-on-error (assessor/warden/saboteur/breaker); type/doc drift on the weblet id, identifier spell-out, `opts`→`options` (typist/stylist/archivist).** DEPLOYMENT.md reconciled.

**Tests.** +15 cases (121 gateway tests pass; 266 full-suite pass, 3 integration-skipped): foreign-root 404, immutable-HTML root substitution, prototype-safe paths, srcset/rel/raw-text/non-UTF-8 edges, post-rewrite limit, unreadable-record conflict, `previousRoots` retention, record-verifying no-op, and `expect(ok)` before the previously-vacuous CAS-test narrowings.

**Verification.** `npm run typecheck` clean; full `npm test` green locally. CI `test` check ran on the new head `c0109c8` and passed (`ci-wait-merge.sh` rc 0).

**Notes / deferred.** Owner-gating of the advance (locksmith/breaker) is explicitly documented as deferred to the publish capability (Increment 4), matching the design and `weblet_publish`'s own deferral — one of the two options those seats offered. A few should-fix test-local abbreviations (`ct`/`pub`/`rec`) were left to avoid churn. Per the stage contract I did not re-run the panel; the driver re-posts panel-2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-git-content-substrate-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 197 tokens (17736320 cached reads)
- Output: 103217 tokens
- Cost: $13.666397999999996
- Wall-clock: 1441s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
