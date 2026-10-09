I applied the round-2 panel's must-fix items to PR #173 and pushed them; CI is green.

I worked from the latest panel verdict, the round-2 review posted at 07:26. All edits are in `designs/ocap-site-crawler-leak-rotation.md`, as one follow-up commit `065f4b2` ("design: address panel round 2 must-fix items"). It was pushed with `safe-push-pr-head.sh` and moved the head from `d24f347` to `065f4b2`.

**Must-fix items:**
- **Novice 1 (too much up front):** added an "In plain terms" paragraph before § 1 that explains what a clip, a crawler hit and rotation mean, and defines label, signal and rotation. The established-fact bullets now have short headings, and "formula id" and "powers plane" are explained where they first appear. The Certificate Transparency claim now says it comes from the committed Caddy config (`clip-gateway.caddy` does use a DNS-01 wildcard), not from a log search.
- **Novice 2 (§ 2 hard to read):** the observe, alert and rotate tiers and the grace window are now defined before the § 2 table, and the table cells are much shorter.
- **Skeptic 1 (the rotate trigger may never fire):** added gate 5 to § 3.4. It measures how often a verified search crawler hits a clip, counted only after the `noindex` and `robots.txt` changes are live.
  - **Exit rule:** if there are zero hits, or fewer than one per 1,000 live clips, build units 4 and 5 are skipped. The feature then ships as those header changes plus owner alerts.
  - **Sign-off:** the measurement report is a PR that the maintainer approves.
- **Decomplector (justify the signal tiers that can't act):** § 3.4 now says units 1 to 3 are useful on their own and explains what the non-acting tiers are for. It also lets the report remove a signal that can't be told apart from link previews.
- **Skeptic 2 / critic 3 (rotation steps not crash-safe):** § 6.1 now explains what each step protects against and walks through a crash example. It adds failure handling:
  - limited retries with backoff;
  - on a permanent failure, falling back to the § 6.2 degraded rotation;
  - if that is refused too, the old link stays dead (fail-closed), `getStatus()` reports a new `rotation-failed` state, and both the operator and the owner are alerted;
  - any rotation still unfinished after 1 hour alerts the operator.

  The state diagram, the facet's types, the § 8 tests and the § 9 build units were updated to match. The diagram also now has an edge for an owner with no alert channel.
- **Pedant:** replaced `≤` with `<=`, and made all three PR #37 links use the same `[#37](…)` form.

**CI:** the only workflow on the new head, `test (typecheck + vitest)`, finished with **success** ([run 37926671716](https://github.com/kriscendobot/minion.town/actions/runs/37926671716)). `ci-wait-merge.sh` itself exited with rc 4 (still pending). That is because this host's bot token can't read PR check status, so every one of its reads failed, not because CI was pending. I confirmed green through the Actions runs API instead. Its first background attempt hit the 10-minute background limit and was stopped.

**Follow-ups:**
- Some of the panel's should-fix and comment-only items are not addressed. They include critic 1 (requiring two crawler hits before rotating), critic 4 / skeptic 4 (spelling out the startup self-check), decomplector 2–4, ergonomist 1–8 (naming and how errors are returned), and novice 6 (the wide ownership table).
- `prettier --write` also reformatted the existing TypeScript block in § 7.1 (double quotes, one union member per line). The file wasn't prettier-clean before this commit.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr173-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1794207 cached reads)
- Output: 14266 tokens
- Cost: $1.4007614
- Wall-clock: 1709s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
