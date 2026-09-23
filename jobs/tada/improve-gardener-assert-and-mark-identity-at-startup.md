Pushed cleanly on the first attempt. Work complete.

---

**Completion report**

**Job:** `improve-gardener-assert-and-mark-identity-at-startup` — make `gardener.sh` surface and validate its resolved `GARDEN` at spawn so an inherited-env drift (the endolinbot2 case) becomes detectable before it corrupts per-host journal/index state.

**What I did**

Edited `scripts/jobs/gardener.sh` to add a host-identity assertion block at the top, immediately after sourcing `common.sh` (right after the busy-marker setup, before the `starting` log). It does exactly the three things the spec asked:

1. **Logs the resolved `GARDEN` once** at startup, alongside `hostname -s` for contrast.
2. **Compares `GARDEN` to `hostname -s`** and emits **exactly one `WARN`** when they differ *without a recorded deliberate override*. Per the design (which permits `GARDEN=<unique>` parallel pools) it **warns, never refuses**, and the WARN is loud/greppable and names the fix. A deliberate override recorded in either `GARDEN_IDENTITY_OVERRIDE` (env) or `$GARDEN_STATE/identity-override` (file) — matching the resolved `GARDEN` — silences the WARN and logs a `RECORDED deliberate override` line instead.
3. **Writes a cheap per-instance marker** `$GARDEN_STATE/gardeners/<id>.garden` holding the resolved name, so the scaler's drift check (sibling job) can read it without walking `/proc`.

Added `scripts/jobs/test/gardener-identity-test.sh` — a hermetic boot of the real `gardener.sh` (oneshot, empty throwaway board, no network/systemd/`claude`) with four subtests: matching identity (no WARN + marker), drift-without-override (exactly one WARN + marker records the drifted name), env-override, and file-override. All 9 assertions pass.

**Verification**
- New test: `9 passed, 0 failed`.
- `shellcheck -x` on both files: no new findings from my code (the info/warn items are pre-existing patterns shared with sibling tests — the same `unset` scrub, `cd` subshell, and `A && B || C` idiom used across `scripts/jobs/test/`).
- Committed with explicit pathspecs and pushed to `main2` via rebase-CAS (landed first attempt as `8ba8dcf8d`).

**Follow-ups**
- The **scaler's drift check is a sibling job** (not part of this one). This job provides the machine-readable marker it will consume; someone still needs to add the reader in `gardener-scaler.sh` (compare each `gardeners/<id>.garden` against the scaler's own `GARDEN`, or against `hostname -s`, and surface a fleet-wide drift). The marker path and format (one line, the resolved `GARDEN` name) are the contract.
- The "recorded deliberate override" convention (`GARDEN_IDENTITY_OVERRIDE` env / `$GARDEN_STATE/identity-override` file) is newly introduced here; if the fleet wants deliberate parallel pools to run WARN-free, the bring-up procedure (`install-units.sh` / the `GARDEN=<unique>` pool setup) should write that marker. Not required for correctness — it only quiets the warning.
