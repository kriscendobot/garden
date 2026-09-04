CI is green (rc 0). All must-fix items applied and pushed.

## Completion report

Applied the round-6 design-panel must-fix items to `designs/chat-http-controller-ui.md` on PR #735 (`endojs/endo-but-for-bots`, head branch `design/chat-http-controller-ui`), pushed as a review-feedback follow-up commit (`4ad320f07`), and watched CI to green.

**Must-fix items fixed:**
- **Design Decision 2 rewritten** to record all three navigable shapes (client, service, standalone `HttpClientControl`) instead of asserting the control facet is never navigated standalone (the dominant must-fix, raised by six seats).
- **§ Detection count** corrected from "two HTTP shapes" to "three".
- **Third tier badge** added ("HTTP Control (policy only, no client)") in § Layout 1 and the layout diagram, so a control-only viewer is no longer mislabeled with the service badge that promises an absent composer (ergonomist must-fix).
- **Boundary 5 confirm logic** reworked: gate the widening confirm on *absence of a binding* (a `Revoked`/`Pinned-Deny` origin fails closed before `decide()` in every mode — skeptic), re-read the mode *immediately before the send* so a co-writer's `strict`→`tofu-auto` flip can't skip the confirm (critic), and **hedge the read-only viewer's copy** ("may durably pin…") since it can't read the mode (ergonomist). Mirrored in the Request composer and Design Decision 3.
- **§ Keeping the view live** now lists "immediately before an off-allowlist send" as a refresh point.
- **Test Plan** covers `isHttpClientControlLike` detection plus a new integration case asserting the control-only surface omits the composer.
- **Phase 1 self-contradiction** resolved by naming an ordered "Phase 0 provisioning prerequisite" and scoping the value claim to UI value (novice must-fix).

**Coupled cheap correctness fixes folded in:** the "eight mutators" cardinality (now "the eight `assertNotRevoked`-guarded mutators, every mutator except `revoke()`"; novice/copyeditor), and Open Questions 1 accuracy (the plugin pins nothing; the integrator passes `resultName`; critic). Verified no em/en dashes or other typist-hostile glyphs were introduced.

**CI:** all 5 checks pass (build, lint, test, browser-tests, zizmor) — `rollup-terminal … total=5 failed=0 → CI GREEN`, rc 0.

Did NOT re-run the panel (the driver re-posts panel-7). Skipped the panel's should-fix/style items (pedant punctuation/wrap, decomplector's data-model remodel, the eager-vs-lazy `listBindings` contradiction) per the "apply must-fix once" mandate.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr735-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 92 tokens (4379769 cached reads)
- Output: 29170 tokens
- Cost: $4.0408764999999995
- Wall-clock: 1060s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
