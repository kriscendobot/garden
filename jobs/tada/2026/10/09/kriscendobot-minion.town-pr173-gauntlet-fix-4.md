Round 4 fix for kriscendobot/minion.town PR #173 is pushed and CI is green.

I added one follow-up commit, `2d0f2869`, on top of `3b62b08`, and it is the PR's current head. It only changes `designs/ocap-site-crawler-leak-rotation.md`. CI passed all three checks, with no failures (`ci-wait-merge` exit code 0).

What I changed for the panel's must-fix items:
- **critic 1–2, skeptic 1 (unclear scope):** The header now has a table splitting units 1–3 from the deferred rotation follow-up:
  - **Classifier:** the committed part labels `uaClass` and checks the source against one pinned range snapshot, only to label the gate 5 count. Reverse-DNS confirmation, snapshot staleness handling and `uaListVersion` escalation are deferred.
  - **States:** the committed set is `Quiet`, `Observed`, `Alerted` and `Public`. `Rotating`, `Cooling` and `RotationFailed` are deferred.
  - **Facet:** it ships without `rotate()` and the `DISABLED`, `LIMITED` and `DEGRADED_REFUSED` error codes.
  - **Ownership map:** the rotation layer and `FormulaReferenceControl` rows are deferred.

  The § 4.1 state diagram now shows only the committed states, and § 7, § 7.1 and the § 4.2 rotate rows are marked deferred.
- **§ 8 split:** § 8.1 holds the committed tests, plus a check that nothing ever goes past `Alerted` and a test for alert delivery. It also has a new production canary for the header and `robots.txt` floor that never calls `rotate()`. § 8.2 holds the deferred rotation, crash and failure tests and the rotation canary.
- **critic 3 (no alert channel):** I made a decision on open question 1: units 1–3 show alerts only through `getStatus()` and `events()`. Which push channel ships first is still open. Unit 2's text no longer mentions `rotate`.
- **critic 4 (production config unconfirmed):** Unit 1 now has a precondition that an operator checks the production unit and records the result in the unit 1 PR. The check covers `GATEWAY_ENDO_SOCK`, the writable `StateDirectory`, and the shared group with `minion-mcp`.
- **skeptic 2 (gate 5 denominator):** § 3.4 now requires the report to state the live clip count. A rate under 1 per 1,000 counts only if there are at least 1,000 live clips; below that it means "zero hits". It also spells out what a zero result does and does not show, given that the `noindex` and `robots.txt` floor suppresses compliant crawlers.
- **skeptic 3 (unproved leak premise):** The report must include a search of the certificate-transparency logs for `ocap.site` names. It must also list other ways a URL gets found (browser telemetry, Safe Browsing and URL-submission features, passive DNS) and call the counts "crawler fetches", not "leaks".

I only saw the start of skeptic's third finding, because the review output was cut off. Any remaining items, and any findings from jurors after the skeptic, were not addressed; panel-5 will show whether anything is left.

Follow-up: none from this stage. The driver posts panel-5 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr173-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 22 tokens (672986 cached reads)
- Output: 8362 tokens
- Cost: $1.1973143999999998
- Wall-clock: 834s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
