Implemented and pushed PR #100 hardening (`6828efc`):

- Type-safe daemon directory narrowing and registration anchoring.
- Falsy primitive `back` rejection and rollback-path coverage.
- Restored ordinary pet-name live acceptance coverage.
- Replaced ad-hoc random tests with `fast-check` properties.
- Replied to #69 discussion `r3939501084`; surfaced the `confirmPublicBuiltIn` rename decision to the maintainer.

Verified locally: build, typecheck, and 372 tests pass. Live-daemon CI remains red on the pre-existing `nameStr` frozen-object failure also present on current `main`; no local `ENDO_CHECKOUT` is available.

Follow-up: maintainer decision needed on whether to rename `confirmPublicBuiltIn` to `confirmPublicSpecialName`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-pr69-followup-hardening.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 2 host(s) (1 unmetered)
- Input: 440 tokens (38713145 cached reads)
- Output: 184041 tokens
- Cost: $28.74526850000001 (1 engagement(s) unpriced)
- Wall-clock: 3479s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
