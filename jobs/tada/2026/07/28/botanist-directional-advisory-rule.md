Pushed as `9cee27d744`.

## Report

**Job:** `botanist-directional-advisory-rule` — make the step-5 advisory rule directional and add the one-open-PR pitfall to `roles/botanist/AGENT.md`.

**Verified before editing** (as the job required): items 1, 2, and 4 of the source proposal are already landed and were left untouched — the `github-actions` ecosystem leg (step 1 pre-flight + the steps-2-through-4 substitute), the tag-to-commit SHA verification with its annotated-tag deref and fork-network trap, and the base-ref pin census with its three outcomes and `REJECT-superseded` verdict.

**Item 3 — directional advisory rule.** The absolute sentence *"A single advisory on any moved transitive version is enough to block MERGE-NOW."* is gone, replaced by a new paragraph in step 5, verbatim:

> **The rule is directional: run the check on both sides of the bump.** An open advisory on an incoming version blocks MERGE-NOW **unless** the outgoing set carries equal-or-worse exposure **and** the residual advisories are argued unreachable on the code path the project actually consumes. That argument must appear **in the rendered verdict itself**, naming each residual advisory and why the consumed path cannot reach it; a bare assertion that it is unreachable does not qualify, and when the argument cannot be made the advisory blocks, exactly as an absolute rule would. Keep the comparison concrete: cite both sides' advisory sets by identifier and severity, not as counts. An absolute rule reads well but blocks upgrades that *reduce* net exposure, leaving the repo strictly worse off for having reviewed the PR. Precipitating evidence: 2026-07-28 on `endojs/endo-but-for-bots` PR 556 (`actions/cache` 4.3.0 to 5.0.5), where the incoming set carries two open advisories (`undici` 6.24.1, CVSS 3.7 low; `fast-xml-parser` 5.5.6, CVSS 6.1 medium) and the outgoing v4 set carries four (three `minimatch` ReDoS plus a `form-data` CRLF injection) — a strict improvement the old sentence would have blocked.

**Item 5 — one-open-PR suppression**, added as an anti-pattern tied to terminal-verdict discipline: Dependabot keeps at most one open PR per dependency, so a stale open bump suppresses the proposal of a newer one; that is a security cost, not housekeeping, and it is why step 8 must reach a terminal verdict. Cites `actions/cache` v6.1.0 bundling `undici` 6.27.0 / `fast-xml-parser` 5.9.2, which would clear both 5.0.5 residuals but cannot be proposed while the 5.0.5 PR sits open.

**Two coherence changes beyond the literal two items**, both encoding the maintainer's caution rather than adding scope:
- The *Autonomous disposition* gate restated the absolute rule (`no advisory on any moved version`) and would have contradicted the new step 5; it now reads `…or the step-5 directional test passed with its unreachability argument written into the verdict`.
- An anti-pattern guarding the soft spot directly: don't wave a residual through on "fewer advisories than before" — the escape hatch is an argument, not a count.

Not in scope and not touched: the CI shellcheck `-S warning` → `-S info` tightening (maintainer declined).

**Follow-ups:** none blocking. If `endojs/endo-but-for-bots#556` is still open, the new rule plus the suppression pitfall together argue for a terminal verdict on it soon, so a v6 PR can be proposed — that would be a separate botanist job.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/botanist-directional-advisory-rule.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (328451 cached reads)
- Output: 5310 tokens
- Cost: $0.7121415
- Wall-clock: 76s

<!-- garden-usage-end -->
