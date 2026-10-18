## Gauntlet fix round 3: kriscendobot/minion.town PR #203

The panel-3 fixes are pushed and CI is green.

**Source of the fixes:** no pre-pass block came with the job, so I worked from the latest panel verdict, review 5564652641. Two seats asked for changes (decomplector and novice). The other five comment-only seats left should-fix items, and I folded those in too.

**What changed:** one follow-up commit, `0e41474e`, on `design/git-remote-s7-bearer-identity-test`. It rewrites the control-plane part of § 7 in `designs/git-remote-capability.md`.

Must-fix items:
- **The `/hello` proof can't be computed for `open` (decomplector 1).** Every proof is now an HMAC keyed by SHA-256 of the secret. The store keeps that hash and the caplet can compute it, so the proof works for every route. The allocator credential no longer has to be stored in the clear.
- **Delegated facets have no replay route and no secret row (decomplector 2).** I added a **facet opener** secret, the `/open-facet` route, and the `E(git).openFacet(<facetId>, <facetOpener>)` formula, with a matching table row. A facet id alone now opens nothing, and a read-only holder never holds the partition key.
- **Too many new terms before the walkthrough (novice 1).** A term list now comes first, and the walkthrough is split into four numbered steps.
- **The root-secret exemption (novice 2, also raised by critic and skeptic).** The scope of the test is now stated first. The exemption is gone: every secret is random and stored only as a hash, and a third requirement on #180 says no secret may be derived from a root secret. That requirement also covers what rotating a secret affects.

Should-fix items applied:
- Renamed "retention key" to **partition key**, and stated that it is the partition's owner capability.
- Removed the owner from the caplet's endowment.
- Stated the threat model for `/hello`: a local process that squats on the port but can't read the formulas.
- Stated what happens after an orphan is reclaimed: partition ids are never reused, so a stale key matches nothing, and the caplet reports "unknown partition" separately from a bad secret. I gave the reclaim interval a lower bound of at least one minute; that number is my choice, so review may want a different value.
- Stated two known gaps: confirmed partitions the daemon drops leak (the leak is accepted and capped by the allocator's quota), and a store restored from an old snapshot loses that partition's content.
- Added a one-line explanation of each ownership-map column, made route names use slash paths throughout, and set the state names (*pending*, *confirmed*) in italics everywhere.
- Copy fixes: glossed `iss+sub`, fixed the unclear pronouns, linked #180 with its full URL, and rewrapped the paragraphs.
- No em dashes or non-ASCII typography were added.

**Push:** `safe-push-pr-head.sh` advanced the branch from 6961e2f5 to 0e41474e as a fast-forward.

**CI:** all three checks passed: `test`, `Claude harness (amd64)`, and `Claude harness (arm64)` (the arm64 run took about 17 minutes). The first `ci-wait-merge.sh` run hit the tool's background time limit and was stopped. I waited for the checks in a foreground loop instead, then re-ran `ci-wait-merge.sh --no-merge`, which reported `failed=0 → CI GREEN` with rc 0.

**Follow-ups:** none from this stage. The driver re-posts panel-4, and the PR stays a draft.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr203-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (1085688 cached reads)
- Output: 11964 tokens
- Cost: $1.0241616000000002
- Wall-clock: 1826s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
