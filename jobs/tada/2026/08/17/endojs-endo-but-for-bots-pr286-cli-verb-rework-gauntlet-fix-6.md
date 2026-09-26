All work is complete. Here is my report.

---

## Fixer stage report — PR #1014 (gauntlet FIX round 6)

Applied the panel's round-6 **must-fix** items to `endojs/endo-but-for-bots` PR #1014, pushed, and drove CI to green.

**Head:** `6ac755506a` on `feat/cli-http-mk-on-policy-client` (pushed via `safe-push-pr-head.sh --mode rewrite`).

### Must-fix items applied
1. **False #286 deferral rationale (engine-realist).** Rewrote the `designs/cli-http-client.md` "Deferred, not carried" note as a **Known Limitation**: under lockdown, `http-confine`'s `freeze({ response, … })` deep-hardens the live undici `Response` (independent of CapTP), and `exo-http-client`'s `headersToRecord` then throws iterating the frozen `Headers` — so the Phase-1 client mints/registers but can't complete a live request until #286's snapshot lands. Took the design-correction path and stated the limitation in the changeset.
2. **Unhardened module constants (integrator/warden/purist).** `import harden from '@endo/harden'`; `harden(HTTP_ORIGIN_SCHEMES)`, `harden(HTTP_POLICY_MODES)`, deleted the false comments, and `makeHttpClientPolicy` now `return harden({…})`. Verified the import loads and freezes under plain Node.
3. **Known-red intermediate commit (packager).** Squashed the round-5 red-then-reverted pair (`219c440573`+`afb9c2fd95`) into one clean commit carrying the surviving substance plus item 2's real harden fix (history rewrite).
4. **Unpinned security seams (prover/corner-prober/fast-checker/locksmith).** Added the daemon-oracle `new URL(o).origin === o` on the normalize property test; a non-canonical-input stderr-echo assertion pinning canonicalization; a tofu-auto warning-path daemon mint; and a host-only `mkguest` + `--as <guest>` rejection test. All pass in CI.
5. **Primer unbounded-mint recipe (locksmith).** `cli-reference.md` now names `strict` only, frames `tofu-auto` as needing human judgment, and defers the `--acknowledge-unbounded` spelling to `--help`.
6. **Design synopsis + spec anchor (surfacer/packager/spec-keeper).** Synopsis now shows `[--policy-mode strict|tofu-auto [--acknowledge-unbounded]]`; origin-serializer anchor corrected to `URL.prototype.origin` / ASCII-serialisation-of-an-origin.

Posted the round-5/6 completion summary comment the Process item requested.

### CI
Green on `6ac755506a`. One leg (`test 24.18.0 macos-15`) first failed on a **pre-existing chat-`component` DOM flake** (`inline-define › typing @ … spawns a slot row`, "Rejected promise returned by test") entirely unrelated to this diff; retried the failed leg and it passed → rollup GREEN (26/26).

### Follow-ups (not blocking)
- **Item 4a** — pin the flags-to-stored-formula seam via `endo inspect <name> --json` `t.deepEqual`. Deferred: this worker's install was wedged (shared yarn hardlink-cache `EMLINK`), so the daemon `FormulaRecord` serialization couldn't be confirmed to author that assertion without risking a red leg. Wants a follow-up with a live daemon.
- Should-fix items (`.requiredOption` for `--origin`, origin dedup, `Number.isSafeInteger` byte ceiling, type re-exports, naming) were not taken this round.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr286-cli-verb-rework-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 123 tokens (7253228 cached reads)
- Output: 50817 tokens
- Cost: $6.325245999999998
- Wall-clock: 1653s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
