## Completion report — `endojs-endo-but-for-bots-pr1349-textcodec-encapsulation-mentat`

**PR #1349 (https://github.com/endojs/endo-but-for-bots/pull/1349) now holds the consolidated change with fully green CI**, head `500550badc`, still on frozen base `master-6ee3fda`, ferry-shaped (changeset included, no fork-only artifacts), not merged.

**What I did:**

1. **The shim** (`packages/ses/src/tame-text-codecs.js`, wired into `repairIntrinsics` before intrinsics sampling): `lockdown()` replaces the host `TextEncoder`/`TextDecoder` with SES-owned strict constructors that throw without `new`, delegate via `Reflect.construct(Native, args, new.target)` (preserving subclassing), and reuse the host prototypes (where all behavior lives — `encodeInto`, streaming `decode`, labels, `encoding`/`fatal`/`ignoreBOM` getters, `instanceof`). `prototype.constructor` is repointed, so the host constructor objects — undeletable `caller`/`arguments` and all — never enter the permitted intrinsics graph on any engine. The taming is idempotent because SES-for-XS samples global intrinsics at module load (`src-xs/compartment.js` now tames there too) — a real integration gap the XS smoke test caught on the first CI push, fixed and folded into the fix commit.

2. **Demonstrated the bug, then the fix, in the SES browser test suite** (`browser-test/`, Playwright): new `tests/text-codecs.spec.js` with the synthetic repro from the issue (a no-op on genuinely affected Chromium, which already carries the exact descriptor) plus encapsulation assertions, and a matching Node test. Red run is public: test-only head `7ece21a220` failed browser-tests (in-page `failed to delete intrinsics.TextEncoder.caller`) and the Node suites — links in the PR body. Green on the final head across browser-tests (chromium/chrome-dev/firefox/webkit), Node 22/24 × ubuntu/macos, test-xs, hermes, lint, cover. The browser-test workflow trigger was master-PRs-only and would never have run on this PR; widened to all PRs, matching ci.yml.

3. **Established the real version matrix** (the issue's "before roughly 127" was wrong): probing Chrome-for-Testing builds and running real `lockdown()` with the built bundle shows Chromium **120–137 all affected, 138+ clean** — the failure band extends to June 2025, confirming the maintainer's "recent Chrome" impression. Real-engine red/green proven on Chrome 126 and 137. Full matrix and method recorded in the PR's Verification section.

4. **Why encapsulation over endojs/endo#3371** is argued in the PR body and commit: the `{value:null}` descriptor is indistinguishable from a live sloppy-function slot (the reporter withdrew the tolerance for exactly this), permits inherit the same flaw plus admit configurable variants, and mhofman's "replace the class altogether" is what this implements. No pushes or comments to endojs/endo.

5. **Design doc + changeset**: `ses` patch changeset on the branch; the design-doc revision (matrix, rejected alternatives, adopted remedy, test-plan item 7) is staged as draft companion PR **#1431** against `llm-fda1ff5`, since the doc is a fork-only artifact that must stay off the upstream-destined branch.

**Follow-ups for the liaison:** request review on #1349 and stage the boatman ferry; #1431 (docs-only, draft) can ride the same review. The liaison's drain notice was answered with an ETA; no new same-host work was posted.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `4d3354123e209709df55da0c1374a30f7d7a5a86`; this job presented `500550badcceb8a3436321e9ac456471bdf8fad2`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer received a deduplicated stale-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1349-textcodec-encapsulation-mentat.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 180 tokens (13487784 cached reads)
- Output: 92968 tokens
- Cost: $22.330244
- Wall-clock: 2980s
- Model(s): claude-fable-5 ×1

<!-- garden-usage-end -->
