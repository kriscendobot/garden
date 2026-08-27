Routing complete. Summary of what I did:

## Completion report

**Directive:** "attention" on endojs/endo-but-for-bots PR #1066, comment 5446412651 — kriskowal: *"Not what I'm looking for."*

**Preflight:** `pr-feedback-preflight.sh` returned exit 2 (HINT). I corroborated rather than treating it as a licence to close: the only correlated artifacts were the garden's own ack reply and an earlier addressed-review comment — no peer had done substantive follow-up work. So I proceeded.

**Diagnosis.** PR #1066 is a **design document** (draft, `design/hardened262-all-environment-runs`) proposing to retire the `onlyLockdown` flag in `@endo/hardened262`. kriskowal **closed** it and said "Not what I'm looking for." Tracing the origin: on #1064 (review 5045929318) he asked to *"propose a change that causes these tests to be run in every environment, removing the lockdownOnly flag from the run. This may reveal new failures that need **addressing**."* Two things the design got wrong:
1. It answered with a design essay + open questions instead of the actual change.
2. Its *disposition* banked +14 new accepted `failed.txt` entries — the opposite of the maintainer's own #1064 precedent (`ec37f708d`, "run buffer coverage **without lockdown**"), which stripped lockdown-only assertions so the broadened tests *pass* and keep the ratchet failure-free. The panel's skeptic seat had flagged exactly this contradiction.

**Routing action.** Posted a builder job **`build-hardened262-retire-onlylockdown`** (tier opus) to the board — confirmed present in the lifecycle (idempotent re-post reported "already present"). Its body: remove `onlyLockdown` from the flagged cases so they run in `module` + `lockdownModule` across `xs`/`sesXs`/`sesNode`; **fix** surfaced failures the #1064 way rather than baselining them; only a genuinely-unsupported combination may remain a failure and must be called out explicitly. It opens a normal (non-draft) PR against `llm` and auto-runs the gauntlet.

**Loop closed.** Left a note on #1066 (comment 5446452085) stating the reading and pointing to the new build job; #1066 stays closed.

**Changed:** no garden-library edits (nothing to commit to main2); one board job posted, one PR comment.

**Follow-ups:** the builder job now owns the real deliverable; watch its PR for the surfaced-failure disposition the maintainer cares about.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1066-573f0c19.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (780719 cached reads)
- Output: 13057 tokens
- Cost: $1.2503955
- Wall-clock: 218s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
