I closed the `cross-platform-test-coverage` cluster. Both halves of the job (prevention and sensing) landed on main2 in one commit, `622ac410f43`. The new probe test passes 14/14, and the neighbouring probe and coverage tests still pass.

**Prevention**
- `skills/coverage-driven-testing/SKILL.md` has a new § Platform-conditional arms. A change that adds or alters a `browser`/`xs`/`endor` (or other non-`node`/`default`) condition, a platform-named source file, or a `test:<platform>` script must carry a test that runs on that platform. For endo-but-for-bots `browser` that means a `browser-test/` Playwright case bundled through the compartment mapper under the `browser` condition. For `xs`/`endor` it means a real `test:xs`/`test:endor` that CI actually runs. Otherwise the PR body must say why no such test is possible.
- The same section says Node-side spies don't count, and that a test must not assert a shim-only shape without a check for native support.
- `roles/builder/AGENT.md` has a matching norm.
- I did not edit the endo testing page (`journal/library/topics/testing.md`). It is an index built from upstream sources, not a place for garden rules.

**Sensing**
- **New probe, `skills/panel-hints/probes/C-platform-arm.sh`.** It fires `coverage-auditor` on:
  - a platform condition key in a `package.json`;
  - a `*-browser*`/`*-xs*`/`*-endor*` source file;
  - a stub `test:<platform>` script (`exit 0`, `true`, `echo`);
  - a touched package whose existing `test:xs` is a stub.

  It fires `engine-realist` on the xs/endor subset of those, and on test lines that assert shim-only shapes. `C-engine-realist.sh` passes that fire along, and `panel-hints.sh` no longer lists a seat as "suppressed" when another probe fired it or it is always-on.
- **Coverage-auditor gate, `scripts/jobs/gardening/seat-gate-coverage-auditor.sh`.** This is the real gap the cluster exposed. The coverage-auditor always runs, but its gate approved any change whose c8 coverage was clean without spending a model call. c8 runs on Node, so #1290's `browser` arm, covered only by Node-side spies, would have been approved that way. When the probe fires, a clean or report-less change now gets a model call on the platform question. With no `claude` available, it gets a comment-only block naming the arm instead of an approval.
- **Juror check lines** were added to `roles/jurors/coverage-auditor/AGENT.md` and `roles/jurors/engine-realist/AGENT.md`. The `panel-hints` skill's trigger docs and field notes are updated.

**Re-litigation.** The probe fires on each member's historical diff, both live and in `scripts/jobs/test/cross-platform-test-coverage-probe-test.sh`:

| PR | Diff checked | Signal that fires | Check that now catches it |
| --- | --- | --- | --- |
| #836 | `gh pr diff 836` | `"xs": "./src/sha256-xs.js"` condition key | coverage-auditor platform-arm check (no real CI-run `test:xs`/`test:endor`) |
| #1290 | `gh pr diff 1290` | `./async` arm with `"browser": "./src/sha256-browser-async.js"` | gate no longer auto-approves; coverage-auditor asks for a `browser-test/` Playwright case |
| #475 | `git diff 38ca1d1893...28957b81d0` (`gh pr diff` refuses a 316-file diff) | `packages/immutable-arraybuffer` has `test:xs: "exit 0"`; shim assertions in its tests | engine-realist § Native-vs-shim check |

The test file also has four cases that correctly don't fire, plus two gate cases: a clean change with no platform arm is approved, and a clean `browser` arm is surfaced as comment-only instead.

**Cluster closed** with `review-miss-record.sh cluster-status cross-platform-test-coverage closed --improved-by "main2 622ac410f43: …"`; it returned `status=closed`.

**Follow-up:** the probe fires on any added test line mentioning `shim`, so it will sometimes send engine-realist to changes that don't need it. That is deliberate (the job asked to err toward firing) and costs nothing extra, since engine-realist already runs on every code panel.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/review-improve-cross-platform-test-coverage.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 88 tokens (5438835 cached reads)
- Output: 35507 tokens
- Cost: $3.0789790000000004
- Wall-clock: 366s
- Model(s): claude-opus-5-5 ×3

<!-- garden-usage-end -->
