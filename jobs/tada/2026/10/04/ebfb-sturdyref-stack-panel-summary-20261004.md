I sent the maintainer one combined merge-decision message covering the SturdyRef stack. None of the four PRs needs a redesign: three can merge as is, and endojs/endo-but-for-bots#1393 can merge once its rework commits are regrouped. I didn't push to any PR or stage another gauntlet.

**What I checked:** each PR's latest panel round, its fix-round reports, what changed after the last panel, and CI. I also checked whether each layer still sits on its predecessor's current head.

**Recommendation per PR, in merge order:**

| Layer | PR | Recommendation | Main open items |
|---|---|---|---|
| 3, pass-style | endojs/endo-but-for-bots#1392 | Merge as is | Optional: one line in the changeset warning TypeScript users that the new `'sturdyRef'` pass style breaks exhaustive switches. Follow-up: no XS test run; a fake SturdyRef global installed before the shim is trusted (bounded by the shape checks). |
| 4, marshal | endojs/endo-but-for-bots#1393 | Merge after regrouping ~26 rework commits (mechanical), done together with moving it onto the landed #1392 | Follow-up: stricter slot-index parsing (predates this PR), XS run, spaces-util tests. |
| 6, captp construct | endojs/endo-but-for-bots#1396 | Merge as is, after layer 5 (endojs/endo-but-for-bots#1394) lands | Optional one-liner: `CTP_DROP` still accepts `'l-0'` (has no effect today). Follow-up: the locator should use the house exo-with-guard idiom. |
| 7, ocapn enliven | endojs/endo-but-for-bots#1397 | Merge as is | The last must-fix was a doc wording error, fixed in the head commit. Follow-up: mint-time byte aliasing and the non-ASCII string-secret split (both predate this PR); XS path unverified. |

**State of the stack:**
- **CI:** green on all four heads.
- **Panel coverage:** none of the four latest heads was re-reviewed after its last fix push. Those later changes are small and low-risk. #1397's is docs only, #1396's is 8 lines of type docs, and #1392's is four small commits. #1393's is the largest, about 70 non-test lines including a type change to `Passable`.
- **Lower layers:** layers 1 and 2 (endojs/endo-but-for-bots#774 and endojs/endo-but-for-bots#1391) are still drafts, so nothing in this stack can land until they do.
- **Base drift:** every layer except #1396 sits on a base that is behind the current head of the PR below it, so each will need a weave as the stack lands.

**Which layers can land first:** #1392 first, as soon as layers 1 and 2 land. Then #1393 after the regrouping. #1396 and #1397 have no code blockers but wait on #1394.

**Follow-ups for the maintainer to decide:** the optional small fixes on #1392 and #1396, the #1393 regrouping and weave, and the follow-up items above if they want them filed as jobs.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `4445fbf937910b0ab04af1cc5c5cc98b19088b99`; this job presented `d427cb91b6d624f4f0be3aa1a2c8533fc638ccea`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer received a deduplicated stale-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-stack-panel-summary-20261004.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (970381 cached reads)
- Output: 10370 tokens
- Cost: $3.138397200000001
- Wall-clock: 177s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
