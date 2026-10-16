# Gauntlet fix round 1: endojs/endo-but-for-bots#1334

I fixed the panel's blocking item and its four should-fix items, pushed one follow-up commit, and CI is green on all 35 checks (`ci-wait-merge` rc 0, failed=0).

**Must-fix (PR body):** I rewrote the PR body under the template's seven headings, in order:
- **Description:** what was broken, why, and what the patch does.
- **Testing Considerations:** how the round-trip test works.
- **Compatibility Considerations:** says the repo now carries a local patch to ava, and that it can be dropped once ava registers its encoders against the live global `Uint8Array` or the view emulation stops replacing it.
- **Upgrade Considerations:** nothing beyond `yarn install`; an ava upgrade must re-create or drop the patch.
- The other three headings get one sentence each.

I removed the invented headings, including the dated "Update" section, and cut the body from 380 to about 266 words. The `garden-job` marker is kept.

**Should-fix items:**
- The title now names the ava patch: "fix(test): patch ava so snapshots stay readable under the immutable-arraybuffer view emulation".
- The fixture snapshot now includes `new Uint8Array([1, 2, 3])`, so the test covers the byte encoding that broke.
- The parent round-trip test has an explicit `t.timeout(5 * 60_000)`, since it runs two child ava processes.
- I trimmed the comments in `ava.config.js` and `fixture.js`. The fixture comment now points to the comment in the patch file instead of repeating it.

**What changed on the PR head:** commit `911c7171c0`, "test(init): pin Uint8Array bytes in the snapshot round-trip", touching 3 files under `packages/init/test/`. It went in as a fast-forward from `29c4591ff7` via `safe-push-pr-head.sh`.

**Checked locally:**
- `snapshot-roundtrip.test.js` passes, both normally and with `CI=true`.
- eslint is clean on the changed files.
- The fixture is outside the `test/**/*.test.*` pattern, so it stays out of the package's main test run. The integrator seat had asked to confirm this.
- I did not re-run the test with the ava patch disabled. The earlier check that it fails without the patch was done before I added the `Uint8Array` value.

**Process note:** the first CI watcher was stopped by the tool's 20-minute limit. I restarted it detached (with a 2400s deadline) and it reached green.

**Follow-ups:** none. The driver re-posts the panel for round 2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1334-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1089880 cached reads)
- Output: 6210 tokens
- Cost: $0.800072
- Wall-clock: 2851s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
