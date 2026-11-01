**Un-draft stage done: PR #1613 is now ready for review.**

https://github.com/endojs/endo-but-for-bots/pull/1613 ("fix(ci): run the XS oracle lanes on Ubuntu 24.04") was un-drafted at the head the panel passed.

- **Check before the change:** the PR was OPEN and still a draft, and its head was exactly `4066142fc5a45516b34fe9c91c6784999eddb876`, the commit the panel passed.
- **Change:** ran `gh pr ready`.
- **Check after:** `isDraft` is false and the head is still `4066142fc5…`.

**Advisory review (does not block):** the change is 3 files, +11/−2. It moves the `test-ironhorse-oracle` and `ironhorse-oracle-sanitizers` jobs from `ubuntu-latest` to `ubuntu-24.04`, and documents why in `rust/engine/DETERMINISM-METERING.md`. On Ubuntu 26.04, glibc rounds `asinh` and `acosh` correctly, so the stored expected values for stage3-math tests `054.js` and `055.js` are off by one ULP. The change is consistent, with matching comments in both workflows and the doc. The panel didn't flag one weakness: pinning to `ubuntu-24.04` is a stopgap, because that GitHub runner image will eventually be retired.

**Possible follow-up:** stop tying the oracle's expected values to the host's math library. Options are to keep separate expected values per host or to build the oracle against a pinned libm. That would remove the need to pin the runner OS. I haven't posted a job for this.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1613-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (177906 cached reads)
- Output: 1321 tokens
- Cost: $0.41760120000000006
- Wall-clock: 20s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
