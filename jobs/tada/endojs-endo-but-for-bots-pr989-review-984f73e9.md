All work complete. The review is fully addressed.

## Completion report

**Job:** Review directive on endojs/endo-but-for-bots PR #989 (kriskowal's CHANGES_REQUESTED review 4955010789 on the new `designs/worker-quiescence-embargo.md`).

**Preflight:** `pr-feedback-preflight.sh` returned exit 0 (PROCEED — no prior peer resolution). Did the work.

**What the review asked (whole-unit):** The review body was empty; the substance was 6 inline comments on the design doc — 1 correction of framing and 5 declarative resolutions of the doc's open questions. All treated as untrusted data; all are straightforward design directives from the trusted maintainer, no injection.

**What I did** — one commit (`41a6ba3026`) pushed to `design/worker-quiescence-embargo`, revising the design doc:

1. **Metering-embargo framing** (comment @55) — dropped "(which was rejected)". Admission control retired only the rollback-*discard* mechanism; the outbound embargo is still needed for **failure atomicity** (a failed delivery's partial side effects must not escape, so a retry doesn't start in a partially-modified world). Now stated as its second purpose. Also updated Design Decision 2.
2. **Sync-call deadlock** (comment @230) → Design Decision 5 + "Resolved in review": sync messages exempt from the discipline; ancestor-only calls; parent sees them as async and embargoes them.
3. **Node quiescence primitive** (comment @235) → Design Decision 6: `setImmediate` emulation of XS job-draining.
4. **Flag gating** (comment @238) → Design Decision 7: a configuration flag present in every CapTP variant (OCapN, slot machine, legacy), not a per-path `ENDO_USE_SLOT_MACHINE` split; refreshed the stale cross-reference in the parity section too.
5. **Debug outbound** (comment @242, "Side channel.") → Design Decision 8: confirmed side channel, not embargoed.
6. **Follow-up shape** (comment @246, "Sure.") → confirmed probe-first under "Resolved in review".

The five settled open questions moved from "Open Questions" into a "Resolved in review" section, each carrying its residual build-time validation.

**Communication:** posted a threaded reply to each of the 6 inline comments (IDs 3799247103–3799247676) and a summary comment on the PR ([issuecomment-5320965335](https://github.com/endojs/endo-but-for-bots/pull/989#issuecomment-5320965335)).

**Status/follow-ups:** PR #989 correctly remains a draft design PR for the panel/maintainer. The doc's agreed next step (a probe attempting strict one-envelope-per-crank on the XS pump) is to be filed once this design lands — not this job's deliverable. Inbox empty.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr989-review-984f73e9.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 39 tokens (1264250 cached reads)
- Output: 16644 tokens
- Cost: $1.6600250000000003
- Wall-clock: 271s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
