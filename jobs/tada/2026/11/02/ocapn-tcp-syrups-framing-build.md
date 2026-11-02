I didn't open a PR because the build this job asks for is already on `llm`. There was no feature code left to write, so I made no commits.

**What I found**
- **The framer package exists.** `packages/syrup-frame/` (`@endo/syrup-frame` 0.1.1, commit 38fe6787d) is the comma-less `<length>:<payload>` framer from Phase 1. It has the tests ported from netstring plus tests for messages split across TCP chunks. It is named `@endo/syrup-frame`, not the `@endo/syrups` the design proposed, to match `@endo/cbor-frame` (renamed in #738).
- **The chunk-boundary bug is fixed.** `packages/ocapn/src/netlayers/tcp-test-only.js` reassembles whole frames before handing them to OCapN. Syrup framing became the default in bdb9ddc50. Since 33d84fd706 (2026-10-19) the default is `'cbor'`, with `'syrup'` and `'none'` as options; `'none'` is kept only for the Python `ocapn-test-suite`. This replaces the design's Phase 2 (netstring framing) and Phase 3 (a separate `tcp-syrups` identifier).
- **Phase 4** (proposing the change to the OCapN spec) is optional and outside Endo's roadmap.

**Why this job was queued again**
An earlier job for the same design, `endo-but-for-bots-ocapn-tcp-syrups-framing-build`, already reached this conclusion. It opened https://github.com/endojs/endo-but-for-bots/pull/1479, a docs-only PR that marks the design Complete and records what shipped. #1479 is still open, so `designs/ocapn-tcp-syrup-framing.md` on `llm` still says **Status: Not Started**. That stale header is what set off this second build job, and it will set off more until #1479 merges. Opening another PR would duplicate #1479, so I didn't.

**Follow-ups for the maintainer**
1. **Merge #1479** (it is mergeable) to stop the repeat build jobs, after a one-line fix: it says `tcp-testing-only` defaults to `framing: 'syrup'` (README row and package-layout block), but since 33d84fd706 the default is `'cbor'`.
2. **#741** (name reconciliation on the old `designs/ocapn-tcp-syrups-framing.md` path) overlaps #1479 and no longer applies cleanly. It can probably be closed once #1479 lands.
3. Removing the per-chunk loop in OCapN core still waits on #242 (moving the Python suite onto framing) and the open revision of the ocapn-tcp-for-test-extraction design (#1430).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ocapn-tcp-syrups-framing-build.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (610980 cached reads)
- Output: 4474 tokens
- Cost: $0.7311320000000001
- Wall-clock: 76s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
