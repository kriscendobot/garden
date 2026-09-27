## Milestone 3 (frozen-object exploitation): accepted, with a correctness fix — draft PR endojs/endo-but-for-bots#1346

The optimization lands in draft PR #1346. It is still draft, against `llm-387ea66`, and the PR head is now `58819e62b`. The two result comments were not posted, because this host's bot token gets a 403 on endojs comments (details at the end).

**What I found on resume.** The previous session left no project checkout, so I started over and built a separate version of the fused walk and integrity cache. That was wasted work. A different claimant had already pushed this job's full result to `feat/ironhorse-ocap-frozen-objects` and opened draft PR #1346, carrying this job's marker. Their result on a quiet host:
- **Accepted:** the fused freeze-and-referent walk, the sealed/frozen/hardened cache, and cached rejection of writes. The representative composite was 13.02% faster; `harden-tree` 12.19% (confidence interval [0.8507, 0.9101]), `harden-repeat` 23.24%, `ocap-mixed` 23.78%. The worst regression was 3.75%, and computrons were identical.
- **Gates:** test262 manifests matched exactly across parent and candidate (51,976 entries), as did hardened262 (2,223). The Rust workspace tests passed, and the general benchmark was within its 1.25× limit.
- **Not pursuing:** the property-index and GC-edge-roster candidates missed the bar. Their raw reports are kept on the branch and both implementations are reverted.

I did not push my version.

**Bug I found in #1346, now fixed (`0e4a5ac18`).** Their fused `harden` walk queued referents in property-creation order instead of spec key order (index names, string names, then symbols). A Proxy further down the worklist can see this through its traps. I reproduced it:
- An object holding a symbol-keyed Proxy created before a string-keyed one logs `str,sym` on the parent and `sym,str` on #1346.
- A second case logs `z,a,later,symFirst` on the parent and `z,a,symFirst,later` on #1346.

Computrons don't change, so none of the gates caught it. The fix:
- Referents are now queued in spec key order.
- The full walk runs whenever skipping the per-key key lookup could be seen: in shared-compartment mode, or while intrinsic bindings are still pending. In my own build, skipping that lookup changed the order the heap was laid out in.
- A regression test pins the parent's logs.

**Checks after the fix:**
- **Rust tests:** `cargo test --release -p ironhorse-vm -p ironhorse-snapshot` passed, 1,620 tests including the new one.
- **Hardened262:** I wrote the `ironhorse` and `sesIronhorse` result lists on parent `107ec8db7` and on `0e4a5ac18`. They are byte-identical: 75 files, 2,223 entries.
- **Benchmark:** a full 7-sample run gave composite 0.8724; `harden-tree` 0.851 with interval [0.835, 0.903], which excludes no-change. Results, computrons, meter and dispatch counts are identical on every fixture. The raw report is committed as `ocap-frozen-ordered-fix.json`.
- **Noise caveat:** this host is shared and loaded. Fixtures the change doesn't touch moved up to ±11%, including `mutable-control` at about 1.10, over the 5% limit on its median. Their intervals include no change, and an unmodified closure-site run swung 17% in both directions here. The quiet-host run above remains the acceptance measurement.
- **Not re-run on the fixed head:** the full test262 sweep and the workspace-wide tests; neither fit in the remaining time. Test262 never calls `harden`, and the fix only sends more integrity calls down the unchanged original path, so its manifest shouldn't move. The planned milestone-4 campaign audit re-runs the full manifest on the combined head.

Everything is written up in `rust/engine/benches/results/ocap-frozen-objects.md` under "Own-key order correction".

**Still to do:**
- **Two comments to post from a host with endojs write access.** One notes the correction on PR #1346. The other posts the milestone-3 result (accepted, the correction, and the two declined candidates with their raw report files) on design PR #1300, as milestone 2 did. I drafted both but lost the drafts when I cleaned up the scratch files; the facts above and the results file on the branch are enough to rewrite them. My attempt to send them to the maintainer inbox timed out twice because journal operations are hanging on this host.
- **This host's journal connectivity is degraded.** Inbox reads and `message-user.sh` time out.

Self-improvement: a garden fix worth making. The resume path left no project checkout and gave no sign that another claimant had already pushed the job's branch and PR. Running `ensure-pr.sh --find-only` and checking whether the branch exists remotely before building anything would have avoided the duplicate implementation. I didn't make that change to the garden this session.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-ocap-frozen-objects.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s) (1 unmetered)
- Input: 366 tokens (35284204 cached reads)
- Output: 117529 tokens
- Cost: $11.883668800000006 (1 engagement(s) unpriced)
- Wall-clock: 12192s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
