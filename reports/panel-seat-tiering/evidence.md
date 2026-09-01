# Panel seat tiering: evidence

This is an evidence file, not a tiering recommendation.

## Scope and confidence

The coherent measurement snapshot is journal commit
`f4a70cb6e45a7615d3cda801df49540deda70ece` (2026-08-01T08:52:06Z), the exact
commit that promoted this job. At that commit, `panel-runs/` contains 54 records
and `review-misses/` contains 172 files, matching the job's stated population.
Using the moving tip would mix later panel behavior with the earlier miss and
usage windows. **Confidence: high** (tree counts and commit identity are exact).

Post-cutoff drift is material: the producer clone observed 466 panel-run records
on 2026-09-01, including 181 design records. Those later records are not folded
into the tables below. Thus "zero design runs" is true for the defined snapshot,
not for the current journal tip. **Confidence: high** (direct tip count), but this
report makes no claims about post-cutoff seat effectiveness.

Confidence grades mean:

- **High**: direct deterministic count or code inspection.
- **Medium**: direct record text, but attribution or population coverage is
  incomplete.
- **Low**: proxy only; the journal lacks the join needed for a causal claim.

## Method

- A seat "sat" once for every `seat=<verdict>` token on a `seat verdicts (...)`
  line, across all recorded rounds. Verdicts are the record's normalized
  `pass`, `comment`, `must-fix`, or `error` values. Partial fan-outs therefore
  give some seats fewer sittings than others. **Confidence: high.**
- Finding attribution parses only the body under each `must-fix items (N):`
  heading, stopping at the next round heading or end of file. Every bullet
  matching `^- ([a-z0-9-]+):` is attributed to that seat, regardless of whether
  its text begins `**must-fix**`, `[must-fix]`, `should-fix`, `comment-only`, or
  bare prose. This yields exactly 693 bullets, equal to the sum of all heading
  counts: 100 visibly must-fix-marked, 56 should-fix-marked, and 537 bare or
  otherwise marked. It intentionally does not repeat the undercounting rule
  `- <seat>: **must-fix**`. **Confidence: high for attribution; medium for
  semantic severity**, because the recorder's heading contains mixed severities
  and truncates long text.
- A confirmed miss is a file in `review-misses/misses/`. Seat attribution is a
  whole-token occurrence of the seat name in `missed_by:`; one miss may name
  multiple seats. Dismissed `new-direction` records do not count as seat misses.
  **Confidence: medium**, because `missed_by:` is free-form and the retrospective
  process may omit or name a panel rather than a seat.
- Deterministic coverage was checked against current seat briefs, the named
  style/changeset skills, the pre-push probes, `detect-banners.sh`,
  `detect-home-coupling.sh`, and `seat-gate-coverage-auditor.sh`. `full` means a
  shipped cost gate can own the seat result; `partial` means shipped code covers
  only a mechanical subset; `rule-only` means a codified skill exists but no
  matching executable pre-pass was found; `none` means no seat-specific rule or
  gate was found. **Confidence: high for shipped-code existence; medium for
  completeness**, because project-local gates are outside this garden snapshot.

## Per-seat observations

`P/C/M/E` means pass/comment/must-fix/error. `Findings` is the inclusive bullet
parse above. `Misses` is confirmed retrospective misses naming the seat. Cost is
`--` for every seat because no source carries a seat-to-usage join; see the cost
section. Count columns are **high-confidence** except `Misses` (**medium**) and
deterministic feasibility (**high/medium as defined above**).

| Panel | Seat | Sat | P/C/M/E | Findings | Misses | Deterministic coverage | Seat cost |
|---|---|---:|---:|---:|---:|---|---:|
| code | assessor | 56 | 17/18/18/3 | 56 | 0 | none | -- |
| code | typist | 55 | 11/24/18/2 | 8 | 2 | partial: code-point, typedef-location, inline-import probes | -- |
| code | stylist | 56 | 2/21/31/2 | 35 | 7 | partial: `spell-out-identifiers` probe | -- |
| code | packager | 57 | 18/19/18/2 | 9 | 0 | rule-only: changeset and lockfile discipline | -- |
| code | archivist | 58 | 5/20/30/3 | 71 | 1 | partial: banner detector/handler | -- |
| code | prover | 55 | 5/21/26/3 | 16 | 2 | rule-only: regression-evidence, no cheap pre-pass | -- |
| code | curator | 57 | 11/20/24/2 | 52 | 0 | rule-only: changeset bump rules | -- |
| code | migrator | 57 | 9/20/25/3 | 15 | 0 | rule-only: changeset/consumer-cascade rules | -- |
| code | locksmith | 54 | 9/18/26/1 | 14 | 1 | none | -- |
| code | warden | 53 | 6/17/29/1 | 6 | 1 | none | -- |
| code | saboteur | 52 | 7/16/27/2 | 16 | 2 | rule-only: adversarial-tests, requires judgment | -- |
| code | breaker | 53 | 6/18/28/1 | 51 | 0 | none | -- |
| code | purist | 52 | 6/18/26/2 | 16 | 3 | partial: `prefer-endo-primitives` covers one idiom | -- |
| code | spec-keeper | 53 | 5/17/30/1 | 17 | 5 | none | -- |
| code | wire-watcher | 53 | 11/17/24/1 | 3 | 0 | none | -- |
| code | engine-realist | 52 | 8/17/25/2 | 29 | 0 | none | -- |
| code | integrator | 54 | 8/18/27/1 | 60 | 0 | partial: related-design evidence triage, semantic verdict remains modeled | -- |
| code | benchmarker | 53 | 17/23/12/1 | 22 | 0 | none | -- |
| code | changeset-auditor | 51 | 17/18/15/1 | 29 | 0 | rule-only: `changeset-discipline` | -- |
| code | surfacer | 52 | 19/19/12/2 | 3 | 0 | none shipped; structural triage is mechanically plausible | -- |
| code | scribe | 52 | 13/18/19/2 | 10 | 0 | rule-only: completion-summary/closure rules | -- |
| code | pruner | 52 | 2/21/28/1 | 25 | 0 | none | -- |
| code | gateway | 52 | 14/23/15/0 | 11 | 0 | none shipped; path-based applicability is mechanically plausible | -- |
| code | corner-prober | 51 | 6/22/23/0 | 48 | 0 | none | -- |
| code | fast-checker | 52 | 11/20/20/1 | 30 | 1 | rule-only: property testing, no cheap pre-pass | -- |
| code | releaser | 51 | 15/20/15/1 | 9 | 0 | rule-only: `changeset-discipline` | -- |
| code | transplanter | 51 | 20/16/14/1 | 4 | 0 | partial: literal home-coupling detector | -- |
| code | coverage-auditor | 51 | 9/24/16/2 | 28 | 0 | **full cost gate**: deterministic c8 new-line pre-pass | -- |
| design | critic | 0 | 0/0/0/0 | 0 | 1 | none | -- |
| design | skeptic | 0 | 0/0/0/0 | 0 | 1 | none | -- |
| design | decomplector | 0 | 0/0/0/0 | 0 | 0 | none | -- |
| design | ergonomist | 0 | 0/0/0/0 | 0 | 0 | none | -- |
| design | copyeditor | 0 | 0/0/0/0 | 0 | 0 | partial: typist-friendly code-point probe | -- |
| design | pedant | 0 | 0/0/0/0 | 0 | 0 | partial: code-point probe and banner detector; em-dash is rule-only | -- |
| design | novice | 0 | 0/0/0/0 | 0 | 0 | none | -- |

Across the 59 recorded rounds there are 1,495 seat verdict tokens: 287 pass,
543 comment, 621 must-fix, and 44 error. The six-round finbot run contributes
168 of those tokens and 120 of the 693 finding bullets, so neither the verdict
nor finding observations are independent PR samples. **Confidence: high.**

The design seats have no yield observations at the cutoff. All 54 records say
`panel_kind: code`; the job brief's older "52 of 54" statement is not reproduced
by the exact promoted-job tree. Design-seat miss names (critic and skeptic, one
each) are retrospective attributions and are not observed seat executions.
They cannot establish design-seat quality. **Confidence: high for run counts;
medium for miss attribution.**

## Review-miss signal size

The 172-path review-miss tree is not 172 usable seat failures. It contains 24
confirmed misses, 134 dismissed records (all `category: new-direction`), 13
cluster files, and one README. Of the 24 confirmed misses, 15 are minor, 2
moderate, and 7 major. Thus the usable confirmed signal is **24 records**, or
**9 non-minor records** for a stricter severity slice. **Confidence: high** for
the file/category/severity counts.

Confirmed named-seat attribution is sparse: only 12 of the 35 seats are named
at all, and one record may name multiple seats. The counts in the table reproduce
the proposed keep-high evidence for stylist 7, spec-keeper 5, purist 3, saboteur
2, prover 2, and warden 1. Breaker and corner-prober have zero attributed misses,
despite 28/23 must-fix verdicts and 51/48 attributed findings respectively.
**Confidence: medium**, because zero can mean no miss, missing retrospective
coverage, or attribution to the panel rather than a seat.

## Standing-hypothesis check

The claim that all eight proposed lowering candidates are "mechanical, no miss
ever attributed" does **not** hold as stated. **Confidence: medium.**

- The zero-confirmed-miss part holds for benchmarker, surfacer, transplanter,
  gateway, releaser, changeset-auditor, and scribe. It fails for typist, which is
  named in 2 confirmed misses. **Confidence: medium** (free-form attribution).
- "Mechanical" is only partly evidenced. Typist and transplanter have shipped
  probes for subsets of their lenses. Changeset-auditor and releaser have a
  codified skill but no matching executable pre-pass found. Benchmarker,
  surfacer, gateway, and scribe still require semantic or cross-source judgment
  after any deterministic applicability scan. **Confidence: high/medium** from
  code inspection.
- These seats are not uniformly low-yield in the records. Changeset-auditor has
  29 attributed bullets, benchmarker 22, gateway 11, scribe 10, releaser 9,
  typist 8, transplanter 4, and surfacer 3. **Confidence: high for counts.**
- The keep-high observations are internally consistent with this snapshot:
  stylist has the most must-fix verdicts (31) and the most named misses (7);
  spec-keeper has 30 and 5; purist 26 and 3; saboteur 27 and 2; prover 26 and 2;
  warden 29 and 1. Breaker and corner-prober have high finding yield but no named
  misses. **Confidence: high for yield, medium for misses.**

This tests the hypothesis only; it does not imply a tier disposition.

## Cost evidence

No journal source attributes model usage to an individual seat. Panel-run files
carry repo, PR, round, seat verdicts, and findings, but no model, token, cost,
job base, invocation ID, or timestamp. Usage JSONL is keyed by gardener job base
and aggregates a whole handler engagement. Reputation events and arms are keyed
by job kind/model/work class, not juror seat. Therefore per-seat dollars and
cost-per-finding are **not identifiable** and are left unallocated rather than
divided by 28. **Confidence: high.**

A conservative ledger slice selects usage filenames whose base contains a
hyphen-delimited `panel` token and excludes the garden-development job
`improve-panel-parallel-seat-fanout`. It finds 19 panel-named usage files, 11
with no priced result row and 8 with priced rows. The priced lower bound is
**$35.584** across 22 result engagements and 399 recorded turns. This is not
total panel spend: gauntlet jobs without `panel` in the base are missed, and
unpriced/zero-row files contribute no dollars. **Confidence: high for the slice;
low as an estimate of total panel cost.**

Within that slice, `$10.065` (28.3%) is attached to `outcome: fail`, `$20.704`
(58.2%) to `outcome: requeue`, and `$4.815` (13.5%) to `outcome: tada`. Thus
**86.5% of measured panel-named spend is attached to a non-tada engagement**.
This is the closest available spend proxy for work that did not complete in its
engagement, not an exact "no verdict" share: a requeue can follow an actionable
must-fix round, and one handler can emit multiple panel-run records. **Confidence:
high for ledger arithmetic, low for interpreting it as verdictless spend.**

## Error confound

Of 54 runs, 31 (57.4%) terminated without a terminal panel verdict: 16
`seat-error`, 13 generic `error`, and 2 `decider-error`. Only 5 runs (9.3%)
passed; 18 terminated `must-fix`. **Confidence: high.** A failed run can still
contain findings: the failed dispositions contain 286 of the 693 retained
finding bullets, so treating every failed run as zero-yield would also be wrong.
**Confidence: high.**

The durable records classify the failure stage better than the root cause:

- **Seat-output stage:** all 16 `seat-error` records mean a seat exhausted its
  attempts with timeout/empty/unreported verdict under the panel contract. One
  PR #857 report durably confirms the underlying cause as Anthropic weekly quota:
  every modeled seat returned the quota message and empty stdout; only the
  deterministic coverage gate produced a block. Other `seat-error` records do
  not retain stderr, so they cannot be partitioned between provider/quota,
  timeout, and malformed output. **Confidence: high for stage; low for root-cause
  counts.**
- **Decision-output stage:** the 2 `decider-error` records reached the decider but
  did not produce a recognized terminal token. The records do not say whether
  that was provider failure or malformed model output. **Confidence: high for
  stage; low for root cause.**
- **Budget/controller stage:** the contemporaneous weekly effectiveness review
  records finbot panel jobs requeueing 5-7 times because 28-seat jobs exceeded
  the claim budget, and the maintainer notice describes the 14/20 in-window
  error/seat-error population as a quota/budget job-shape problem. This confirms
  budget as a cause family, but there is no run ID-to-usage join to assign a
  count among these 31. **Confidence: medium for family, low for count.**
- **Generic/unknown:** the 13 `error` records are the EXIT-trap default and do
  not preserve a cause. Some have partial seat fan-out, some contain full
  findings, and some contain seat `error` tokens. Any exact allocation of these
  13 to quota/provider, seat-output, or budget would be invented. **Confidence:
  high.**

This failure population confounds every cost-per-finding comparison: repeated
rounds, partial fan-outs, quota-empty calls, and findings retained from runs that
never decided are all mixed together. **Confidence: high.**

## Deterministic-gate feasibility summary

Only coverage-auditor already has a full deterministic cost gate: clean or
unmeasurable pre-pass branches return a seat block without `claude -p`, and the
model runs only for uncovered new lines needing judgment. **Confidence: high.**

Seven further seats have shipped partial deterministic coverage in this checkout:
typist, stylist, archivist, purist, transplanter, copyeditor, and pedant;
copyeditor and pedant share the same prose probe. The named
`em-dash-style`, `no-latin-shorthand`, and much of `changeset-discipline` remain
skills without an equivalent general executable pre-pass; `no-comment-banners`
has a detector/handler, and `typist-friendly-code-points` has a pre-push probe.
**Confidence: high.**

The existence of a mechanical subset does not measure what fraction of a seat's
historical findings that subset would have caught: the retained bullets are
truncated prose and do not carry normalized rule IDs. **Confidence: high that
the fraction is unavailable.**

## Questions this data cannot answer

1. What model, tier, token count, latency, or dollar cost belongs to any specific
   seat invocation? There is no seat-level usage key.
2. What exact share of dollars bought no verdict? The usage-to-panel-run join is
   absent; 28.3% fail-only and 86.5% fail-plus-requeue are bounds/proxies, not the
   requested causal share.
3. How many of the 31 failed runs were quota/provider, malformed seat output,
   or claim budget? Stderr and a normalized failure-cause field are not durable.
4. Are repeated rounds independent evidence? No: one six-round run contributes
   120 findings, and many records review the same PR/head lineage.
5. Were attributed findings correct, unique, accepted by the foreperson, fixed,
   or later upheld by a maintainer? The record stores bullets, not adjudication
   or fix identity.
6. Does zero `missed_by` mean a seat is effective? No: only 24 confirmed miss
   records exist, attribution is free-form, and 23 seats are never named.
7. What is design-seat yield or quality at the cutoff? There were zero design
   executions. Later design runs require a separate, coherently cut analysis.
8. What fraction of each seat is replaceable by a deterministic gate? Existing
   code proves some subsets are feasible, but finding bullets lack rule IDs and
   replay data.
9. Would a cheaper model preserve seat quality? Every seat used the ambient CLI
   default, and neither panel records nor misses carry model identity; there is
   no within-seat model comparison.
10. What happened in project-local checks not represented in this garden tree?
    The feasibility inventory cannot see them.
