# Report back on PR #595 with the completed unredactError probe findings

**Repo:** endojs/endo-but-for-bots — **PR #595** (design PR, draft, base `llm`, title "design(captp): error identification follow-up to #58").

**Maintainer directive — a RE-PING requiring the report be published.** On the review thread on
`designs/unredacted-stack-sanctioned-ses-api.md` line 63, kriskowal first asked (comment r3522720512) for an
exploratory implementation and "please report back." He has now **re-pinged the same thread**:
https://github.com/endojs/endo-but-for-bots/pull/595#discussion_r3525583203 — "Please report back regarding
above." The report-back is overdue and must be published this time.

**The substantive work is already DONE — this job PUBLISHES it, does NOT re-run the probe.** The probe job
`endojs-endo-but-for-bots-pr595-probe-unredact-error` completed; its full gap-revealing-build report is in
the journal at `jobs/tada/endojs-endo-but-for-bots-pr595-probe-unredact-error.md`
(`git show origin/journal2:jobs/tada/endojs-endo-but-for-bots-pr595-probe-unredact-error.md`). It was never
published because the probe ran on `endolinbot2`, which had no bot GitHub credentials. This leader host
(`endolinbot`) HAS working `kriscendobot` credentials (verified), so publishing is now unblocked.

**Task — report back on the PR (do NOT re-probe):**
1. Read the completed probe report from `jobs/tada/endojs-endo-but-for-bots-pr595-probe-unredact-error.md`.
2. Post a **reply on kriskowal's review thread** (in reply to comment r3522720512 / r3525583203 on
   `designs/unredacted-stack-sanctioned-ses-api.md` line 63) summarizing the exploratory-implementation
   findings: the 5 gaps with **Gap 4 (return shape)** as the keystone that gates the API name (Gap 1), the
   ses-ava migration / shared-symbol retirement (Gap 3), and structured TraceRecord population; **Gap 2**
   (convention-symbol vs permitted-intrinsic exposure) as an independent SES-surface decision the design
   should name; **Gap 5** (destructive one-shot `take` semantics) as an unmentioned correctness hazard; and
   the strongest positive signal — **start-compartment-only exposure already works under real lockdown**
   (verified in code), so the design's open work is entirely in the API's *shape*, not in whether SES can
   host a start-compartment-only export.
3. Also post a **top-level summary comment** on the PR (per the PR-summary norm) linking the thread reply,
   stating this was an exploratory (probe) build that stays as findings — no implementation PR follows — and
   naming the upstream `endojs/endo` SES-export dependency (design §2, lines 65-66) as the gating item.

Bot-repo work only; publish under the bot identity (no maintainer-identity switch). Confirm the two comments
posted, then report the comment URLs in your ## Follow-ups.

---
claim:
  host: endolinbot
  gardener: 16
  claimed_at: 2026-07-05T20:31:42Z
