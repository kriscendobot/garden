I fixed the routing on main2 (commit `9feb6590987`). The first time a host's token is refused when posting a panel review for a repo owner, that host now stops claiming that owner's panel and un-draft stages, so a host whose token can post takes them. The new test passes and the related panel, claim and gauntlet tests still pass.

**Why this option:** I chose the host-local learned exclusion over a pre-spend write check. I couldn't find a way to test review-write access without actually writing. A pending review created and then deleted would work, but if the delete failed, the leftover pending review could block the real review post.

**How it works:**
- **The marker:** when `panel.sh` posts its review and GitHub refuses with `Resource not accessible by personal access token` (or `... by integration`), it records a marker file for that repo owner under `$GARDEN_STATE/review-write-deny/`. Owner names are case-insensitive. It expires after 7 days (`GARDEN_REVIEW_WRITE_DENY_TTL`) and each new refusal re-arms it. A plain 403, such as GitHub's secondary rate limit, does not set it. The gh error is still printed and the stage still fails without reporting success.
- **Claim-time skip:** while the marker is live, `claim-job.sh` skips that host's gauntlet stages whose `gauntlet_stage` is `panel` or `undraft` and whose `pr:` URL belongs to that owner. It logs `skipping (review-write)`. Clean, fix and viability stages stay claimable because they don't post to the PR.
- **Pre-spend refusal:** if such a stage gets claimed anyway, `panel.sh` stops before running any jurors.
- **Nothing public:** the marker lives on the host, not in the journal, so no credential details are published.

**Changes:**
- New `scripts/jobs/review-write-deny.sh` holds the shared helpers; `common.sh` and `panel.sh` both load it.
- `claim-job.sh` and `panel.sh` carry the two checks.
- New test `scripts/jobs/test/review-write-deny-test.sh` (12/12 pass). It covers the marker lifetime, the rate-limit case, the first refusal setting the marker with no juror run afterwards, and a denied host skipping the stage while another host claims it. The existing test stub for gh can now produce both kinds of 403.
- I added a note next to the `--stage-requires` stopgap in `context/operations/systemd-units.md`.

**Tests:** `panel-repo-slug-test` fails on one case, an `http://` remote URL. It fails the same way on the commit before mine, so it isn't caused by this change.

**Limits:**
- Each host still wastes one juror fan-out (about $0.4–0.9) per owner every time the marker expires, because the first refusal is what teaches it.
- Only the panel's own review post sets the marker. An un-draft stage's `gh pr ready` is skipped while the marker is live but can't set it.
- If every host's token were refused, the stage would wait unclaimed in todo.

**Maintainer:** I sent the liaison inbox a message (`msg-fix-oros-endojs-review-403-panel-routing-20261027-…`). The lasting fix is to grant the oros-studio bot token Pull requests read and write on the endojs org. Then delete `$GARDEN_STATE/review-write-deny/endojs` on oros-studio, or let it expire.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-oros-endojs-review-403-panel-routing-20261027.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (2198359 cached reads)
- Output: 21118 tokens
- Cost: $1.6384318000000004
- Wall-clock: 302s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
