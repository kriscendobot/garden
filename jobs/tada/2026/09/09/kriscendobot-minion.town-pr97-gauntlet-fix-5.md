Fix stage complete. CI is green.

## Completion report — gauntlet FIX round 5, kriscendobot/minion.town PR #97

**PR:** #97 (draft) — `docs(claude-agents): reconcile design to root-only endowment amendment`, a design-only PR touching `designs/claude-agents-capability.md`.

**Panel round-5 verdict:** two blocking **must-fix** items (posted as COMMENTED, since GitHub blocks a request-changes review on a self-authored PR). Applied both, plus one trivially-correct comment-only slip:

1. **critic must-fix** — the existing-root migration path ("Endowing the root guest") asserted it "adds the same two specials to that guest's persisted formula" with no mechanism, while the doc frames a formula as a persisted, replayable recipe (write-once/content-addressed). Gave the migration a concrete mechanism at the same level as the fresh-creation `provideGuest` snippet: since a formula is content-addressed and immutable, the migration **re-derives** a new formula (reusing the existing guest's directory node *by identifier*, so all pet names/children/connections carry over, and adding the two `introducedSpecialNames` to the special-name record), persists it under its new content-addressed id, and **atomically re-points the root guest name's binding** from the old id to the new one. Named the single serialization point and made it idempotent/crash-safe (a crash before commit leaves the old formula bound; retry re-derives the identical id).

2. **skeptic must-fix** — guest-teardown-during-inference was unspecified. Added a paragraph stating that `dismiss`/`revoke` of a guest holding the single in-flight slot **kills the running spawn** as part of the subtree cascade and **clears its slot lease immediately** on the completion path (not left to expire/sweep), deliberately distinct from the disconnect path's "let the in-flight inference finish" rule (disconnect revokes the credential while guests live; teardown removes the guest itself). Made teardown the third slot-clear path in the enumeration, and added an acceptance-evidence bullet exercising "dismiss/revoke while target holds the slot → concurrent `infer` admitted immediately, not only after sweep/expiry."

3. **pedant comment-only** — fixed two Chicago period-inside-quote slips (`"no live authority".` → `"no live authority."`, same for `"no children"`).

**Hygiene:** verified no em-dashes (project ban) or other banned code points in additions; reverted a stray `package-lock.json` engines-field change from the npm warm-cache reconcile so only the design doc committed.

**Push:** `4601f6b..4003421` to `design/claude-agents-root-endowment` via `safe-push-pr-head.sh` (advance mode).

**CI:** `ci-wait-merge.sh` (bounded, `--no-merge`) → **CI GREEN** (rc 0), 1 check, 0 failed.

I applied the must-fix items once and stopped as instructed; the driver re-posts panel-6.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr97-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 72 tokens (2323392 cached reads)
- Output: 17427 tokens
- Cost: $2.3230210000000002
- Wall-clock: 348s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
