Most of this design was already on `master`, so I built the one missing piece, test-plan item 6 (the XS smoke test). It's up as draft PR endojs/endo-but-for-bots#1349. Nothing from the earlier attempt survived: there was no branch, no PR and no journal record.

**Already on master (landed upstream via endojs/endo#3322, merged 2026-07-22):**
- **Phase 1:** `TextEncoder` and `TextDecoder` are on `universalPropertyNames`, and their prototype permits are in `packages/ses/src/permits.js`.
- **Phase 2:** test-plan items 1–5 are covered by `packages/ses/test/text-encoder-decoder.test.js` and `packages/ses/test/text-encoder-decoder-missing.test.js`. The changeset is `.changeset/tender-lions-tickle.md`.
- **Phase 3 audit:** there are no `Buffer.from(` or `.toString('utf…` call sites in any `packages/*/src`, so there's nothing to migrate.

**The PR:**
- It adds a check to `packages/ses/test/_xs.js`. Before `lockdown()`, it records whether the host has the codecs. Afterwards it asserts that a new compartment sees the same presence or absence, and that each codec is frozen when present.
- It's test-only, so there's no changeset.
- Head is `build/hardened-text-codecs-shim`. The base is pinned to `master-6ee3fda`, which is identical to the current `master`, because `ensure-pr.sh` refused a floating base.
- **Checks run:** `yarn test:xs` passes, the 17 existing codec tests pass under ava, and eslint and prettier are clean.

**Follow-ups:**
- The design assumes XS has no `TextEncoder`/`TextDecoder`, but the current `xst` defines both. The new check works either way, but on today's toolchain it only exercises the "present and frozen" path, not the "missing" path.
- `designs/hardened-text-codecs-shim.md` on `llm` still says "Not Started" and needs updating to "landed".
- The PR stays draft until someone says "run the gauntlet #1349".
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-hardened-text-codecs-shim.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 40 tokens (1143454 cached reads)
- Output: 8675 tokens
- Cost: $0.8630468000000001
- Wall-clock: 164s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
