## Completion report: `design-jev-triage-foreman-integration`

**Result:** The design is written and on `main2` at `18f32b7efa`, in `designs/jev-triage-foreman-integration.md`. Its review PR is **kriscendobot/garden#122**: https://github.com/kriscendobot/garden/pull/122. The PR is a draft, its only diff is the design file, and its frozen base is `main2-360df84`. The PR body carries `<!-- garden-design-open-questions -->`, so no design panel is staged for it. I sent the PR link to the maintainer inbox (message `msg-design-jev-triage-foreman-integration-f2d6be89a71d`). The message says to read § 4 (data egress) and open questions 1–3 first.

**What the design settles:**
1. **Decision points, ranked:**
   - D1: routing comments that match no verb (the `attention` jobs).
   - D4: triaging maintainer-inbox notices as they arrive.
   - D3: setting a role on jobs posted without one.
   - D2: deciding how to respond to maintainer feedback the watcher treats as non-actionable.
   - D5: breaking ties in foreman promotion order with a doom-risk score.

   The verb table stays authoritative. Jev can never choose merge, ferry, retcon, or any change to a PR's state, and any failure falls back to today's behavior.
2. **Template loop:** a scheduled mentor run proposes templates. Each one is versioned by content hash in `jev/templates/<decision>/`. A new template must pass an offline replay and a 7-day shadow run against the current one, and only then replaces it. New runs are triggered by falling accuracy, with a monthly floor.
   - **Break-even:** the proposer run and the LLM step a template saves are both priced by wall-clock time on the same rate card. So the break-even count is a ratio of seconds and does not depend on which price basis is used. It works out to about 15 decisions for D1, 180 for D4 and 30 for D3. Monthly volumes clear that: 63 attention jobs, about 2,512 inbox messages and about 1,200 jobs without a role.
3. **Ground truth** comes from data the journal already keeps: the usage ledger, job bodies recovered from a full journal clone, tada reports, inbox fields, and `jobs/withdrawn`. The only new record is a Jev ledger that stores hashes, not text.
4. **Egress:** a table per decision point shows what text leaves the host and from which senders. Only the maintainer-inbox class is already covered, through the standing Muster practice.
5. **Failure and cost:** every failure falls back to today's path, there is a $0.25 per-day cap, a per-decision authorization switch, and a table of what each kind of wrong label can do.
6. **Options:** four were considered. The recommendation is the full template loop, introduced in stages (shadow, then advisory, then gating). A Jev template only ships if it beats the best deterministic rule built from the same data.
7. **Trial plan:** step-by-step offline replay with numeric pass criteria:
   - at least 0.85 or 0.80 agreement (by decision point)
   - at least 0.40 coverage
   - false-act rate at most 0.02 or 0.03
   - at least +0.05 over the deterministic baseline
   - at most $0.0005 per decision
   - volume at least twice the break-even count
   - at least 0.70 of inputs labeled

   It calls Jev live only for D4. D1 and D3 stop after labeling and template proposal until egress is authorized.

The design has two mermaid flowcharts, both checked with the parser, and an `## Ownership map`. The thesaurus and orthographer grep checks came back clean.

**Measured, 2026-09-08 to 2026-10-07:** 3,619 jobs ran, and 34% of usage rows had no role. There were 63 attention jobs, averaging 384 s each, and 2,512 maintainer-inbox messages.

**Open questions for the maintainer:**
1. May D4 run on its own as messages arrive, without a muster session?
2. May the comment watcher send text from trusted senders to TypeSafe, and for which senders? This is the same as open question 2 on #115, which is still unanswered.
3. May garden-authored job and plan bodies be sent, with third-party excerpts removed?
4. Which role should the template proposer run as?

## Follow-ups
- The orchestration's next child runs the trial plan in § 7. It needs no maintainer answer, because it calls Jev only on maintainer-inbox data. No build is named here: building waits on the trial result and the egress answers.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-jev-triage-foreman-integration.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 92 tokens (4526258 cached reads)
- Output: 37032 tokens
- Cost: $3.4650860000000008
- Wall-clock: 449s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
