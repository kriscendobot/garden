The review process should have caught this, so I recorded it as a miss. I dispatched nothing new, because both the prevention and the review check for this pattern are already in place.

**What the comment asked.** On #1125 (now closed), kriskowal asked for a short review run to check whether the panel would have flagged the bare `Far('ReadableNameHub', …)` in `readOnlyDirectorySource` (`packages/daemon/src/directory.js`) and recommended `makeExo` with an interface guard.

**Why it is a miss, not new direction.** I checked the PR, the board and main2 myself rather than trusting the primary job's report:
- **The rule already existed and did not work.** The locksmith brief already said to flag an exported capability that has no interface guards. That line came from this cluster's earlier improvement (main2 `37b04ec909`, 2026-08-04). The primary job ran four review seats over the real diff without telling them what to look for, and none of the four caught it. The warden even called the `Far` "properly hardened".
- **No panel reviewed the offending commit.** The `Far` came in with commit `42bad92360` on 2026-09-17. The last #1125 panels ran on 2026-09-12/13, so the maintainer was the first reviewer to see that commit.

**The primary job's claims check out:**
- main2 `c7aa363e09` updates the locksmith and warden briefs to name the `Far` → `makeExo(tag, InterfaceGuard, methods)` shape, including a `Far` inside an eval/worker source string.
- The reply on the review thread (r4040314005) exists.
- The PR code was fixed at `9fad002ba8` by job `endojs-endo-but-for-bots-pr1125-fix-readonly-hub-makeexo-guard`, and the fix was confirmed on the thread (r4040987283).
- A pre-push check added on 2026-09-24 fails any newly added bare `Far(` (`prefer-endo-primitives`, via `skills/build-vs-buy/idioms.tsv`). It is covered by `scripts/jobs/test/review-convention-probes-test.sh`, and the `C-locksmith` panel hint probe exists.

**What I recorded.** `review-misses/misses/endojs-endo-but-for-bots-pr1125-23cf90c0.md`, written and pushed to the journal by the store script. Category is security-hardening, severity minor, missed by the locksmith and warden seats, with my own paraphrase of the comment. It joins the existing cluster `capability-hardening-attenuation`, which now holds 6 misses across PRs 874, 881 and 1125.

**Why no new improvement job.** The cluster's status is already "improvement dispatched", which blocks a second dispatch, and this shape is already handled at pre-push and at the two seats. It did not count as a recurrence (the cluster was not closed), so no maintainer alert was sent.

**Changes.** No main2 commit; the only write is the journal record.

**Follow-up for whoever next evaluates this cluster.** The cluster is still "improvement dispatched" even though its improvements have landed. It should be moved to closed, crediting `37b04ec909`, `c7aa363e09` and the 2026-09-24 pre-push change, so that a future `Far` miss counts as a recurrence and alerts the maintainer. The #1125 case also shows that the seat fixes only work if a panel runs after late commits.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1125-23cf90c0-retro.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 26 tokens (1102639 cached reads)
- Output: 6284 tokens
- Cost: $1.0493598
- Wall-clock: 75s
- Model(s): claude-opus-5-5 ×3

<!-- garden-usage-end -->
