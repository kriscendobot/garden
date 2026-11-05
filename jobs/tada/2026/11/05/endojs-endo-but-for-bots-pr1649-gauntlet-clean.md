---
orchestration-failed: true
---
**Clean stage failed for PR #1649: CI is red at head `6a613403d4`.** The only failing check is `test-xs`, and I found nothing to change, so I pushed nothing.

**CI**
- `ci-wait-merge.sh endojs/endo-but-for-bots 1649 --no-merge` returned **rc 3** (36 checks, 1 failed).
- `test-xs` fails with `Result baseline changed`: `sesNode/module` went from passed to failed on `test/intrinsics/ThrowTypeError/intrinsic-metadata.js`.
- This is the known Node 26 flip, not this PR's diff. The job log shows `Attempting to download 26...`, and `.node-version` is still `lts/*` on both this head and `llm`. I did not rerun it, because reruns don't help.
- #1646, which pins `.node-version` to 24, is still an unmerged draft and is itself red on `test (24.x, ubuntu-latest)`.
- Once a pin lands on `llm`, this PR needs a weave to pick it up, because its frozen base (`feature/api-key-agent-factory-a46a836`) keeps `lts/*`. A maintainer decision on the fix is still outstanding.

**Coverage**
An earlier attempt had already pushed the coverage work as `6a613403d4`. I re-ran `c8` and `ava` on `packages/hosted-agent` and compared uncovered lines with the lines this PR adds:

| File | Lines added | Added lines uncovered |
| --- | --- | --- |
| `agent-responder.js` | 496 | 0 (100% of lines) |
| `agent-guest-powers.js` | 2 | 0 |
| `inference-provider-registry.js` | 2 | 0 |
| `agent-factory.js` | 41 | 2 (lines 1129–1130) |

- **`agent-factory.js` 1129–1130:** this is the `setLimits` refusal, code from the phase 4 base that only moved here, so I added no test for it.
- **The `*-module.js` caplets:** these run inside the daemon, so `c8` in this package doesn't measure them. `packages/daemon/test/agent-responder-restart.test.js` references the responder modules, but I did not run that suite.
- **Not re-run:** coverage for `lal` and `fae`.
- **Dead code:** my pass found none beyond the two unreachable guards `6a613403d4` already removed.

**Other changes**
- The warm-cache install reordered a dependency in `packages/hosted-agent/package.json`. I reverted that, and it was never committed.
- I added this rc 3 result to the fleet memory note on the Node 26 flip.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1649-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s)
- Input: 250 tokens (10551997 cached reads)
- Output: 60810 tokens
- Cost: $5.5014474
- Wall-clock: 14821s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
