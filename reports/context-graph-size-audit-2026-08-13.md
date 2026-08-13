# Context graph size audit (2026-08-13)

This report walks relative inline Markdown links from the documented context roots. The main2 roots are the top-level orientation documents plus every role, juror, skill, design, and `context/` Markdown document. The journal2 roots are `README.md`, `projects/README.md`, and `library/README.md`; links from those roots may reach additional journal trees.

Classification thresholds: small is below 100 lines and 8 KiB; medium starts at 100 lines or 8 KiB; large starts at 300 lines or 24 KiB; very large starts at 600 lines or 48 KiB. A hand-authored document is flagged when it reaches 300 lines or 24 KiB, has at least 160 lines and eight level-two sections, or has at least 150 lines and twice the median line count of three or more same-directory peers. The generated `library/sections/README.md` index is classified but exempt from reorganization flags.

Revisions: main2 `7e6aae2c3424`; journal2 `7a70085a8318`.

## main2 context library

Reachable documents: 271. Reorganization candidates: 66.

### Largest 15 documents

| Path | Lines | Bytes | Class | Level-two sections |
| --- | ---: | ---: | --- | ---: |
| `designs/cleric-worker-bid-auction-reputation.md` | 739 | 40803 | very large | 10 |
| `designs/gardener-bid-accept-market.md` | 681 | 37806 | very large | 10 |
| `context/operations/local-inference-amd.md` | 670 | 39747 | very large | 8 |
| `designs/gardener-reputation-bootstrapping.md` | 591 | 33766 | large | 11 |
| `designs/leader-follower-determinism.md` | 562 | 31248 | large | 9 |
| `skills/local-verify/SKILL.md` | 557 | 34458 | large | 14 |
| `designs/job-board.md` | 543 | 31219 | large | 10 |
| `context/control-surface-gallery.md` | 541 | 32604 | large | 14 |
| `designs/fleet-telemetry-and-anomaly-response.md` | 526 | 33763 | large | 13 |
| `skills/agoric-chain-snapshot/SKILL.md` | 508 | 32581 | large | 8 |
| `designs/streamlined-onboarding.md` | 490 | 32153 | large | 6 |
| `designs/review-retrospective-loop.md` | 466 | 26389 | large | 11 |
| `designs/sysop.md` | 458 | 28386 | large | 11 |
| `designs/token-cost-ledger.md` | 455 | 25990 | large | 12 |
| `designs/evaluation-epochs-panel-calibration.md` | 435 | 25585 | large | 13 |

### Reorganization candidates

- `designs/cleric-worker-bid-auction-reputation.md` (739 lines, 39.8 KiB): at least 300 lines; at least 24 KiB; 2.8x the sibling median (266 lines); 10 level-two sections suggest mixed topics.
- `designs/gardener-bid-accept-market.md` (681 lines, 36.9 KiB): at least 300 lines; at least 24 KiB; 2.6x the sibling median (266 lines); 10 level-two sections suggest mixed topics.
- `context/operations/local-inference-amd.md` (670 lines, 38.8 KiB): at least 300 lines; at least 24 KiB; 6.2x the sibling median (108 lines); 8 level-two sections suggest mixed topics.
- `designs/gardener-reputation-bootstrapping.md` (591 lines, 33.0 KiB): at least 300 lines; at least 24 KiB; 2.2x the sibling median (266 lines); 11 level-two sections suggest mixed topics.
- `designs/leader-follower-determinism.md` (562 lines, 30.5 KiB): at least 300 lines; at least 24 KiB; 2.1x the sibling median (266 lines); 9 level-two sections suggest mixed topics.
- `skills/local-verify/SKILL.md` (557 lines, 33.7 KiB): at least 300 lines; at least 24 KiB; 14 level-two sections suggest mixed topics.
- `designs/job-board.md` (543 lines, 30.5 KiB): at least 300 lines; at least 24 KiB; 2.0x the sibling median (266 lines); 10 level-two sections suggest mixed topics.
- `context/control-surface-gallery.md` (541 lines, 31.8 KiB): at least 300 lines; at least 24 KiB; 14 level-two sections suggest mixed topics.
- `designs/fleet-telemetry-and-anomaly-response.md` (526 lines, 33.0 KiB): at least 300 lines; at least 24 KiB; 13 level-two sections suggest mixed topics.
- `skills/agoric-chain-snapshot/SKILL.md` (508 lines, 31.8 KiB): at least 300 lines; at least 24 KiB; 8 level-two sections suggest mixed topics.
- `designs/streamlined-onboarding.md` (490 lines, 31.4 KiB): at least 300 lines; at least 24 KiB.
- `designs/review-retrospective-loop.md` (466 lines, 25.8 KiB): at least 300 lines; at least 24 KiB; 11 level-two sections suggest mixed topics.
- `designs/sysop.md` (458 lines, 27.7 KiB): at least 300 lines; at least 24 KiB; 11 level-two sections suggest mixed topics.
- `designs/token-cost-ledger.md` (455 lines, 25.4 KiB): at least 300 lines; at least 24 KiB; 12 level-two sections suggest mixed topics.
- `designs/evaluation-epochs-panel-calibration.md` (435 lines, 25.0 KiB): at least 300 lines; at least 24 KiB; 13 level-two sections suggest mixed topics.
- `README.md` (415 lines, 25.9 KiB): at least 300 lines; at least 24 KiB.
- `designs/transcript-journal-capture.md` (409 lines, 24.2 KiB): at least 300 lines; at least 24 KiB; 10 level-two sections suggest mixed topics.
- `skills/native-customizable-form-control-styling/SKILL.md` (400 lines, 19.5 KiB): at least 300 lines; 13 level-two sections suggest mixed topics.
- `skills/css-anchor-positioning-and-flip-fallbacks/SKILL.md` (393 lines, 20.1 KiB): at least 300 lines; 11 level-two sections suggest mixed topics.
- `references/endo-but-for-bots/CLAUDE.md` (388 lines, 18.3 KiB): at least 300 lines; 4.2x the sibling median (92 lines); 11 level-two sections suggest mixed topics.
- `designs/spark-gardeners.md` (383 lines, 22.3 KiB): at least 300 lines; 11 level-two sections suggest mixed topics.
- `designs/budgeted-campaign-dispatch.md` (382 lines, 19.2 KiB): at least 300 lines; 10 level-two sections suggest mixed topics.
- `skills/pr-creation-flow/SKILL.md` (376 lines, 20.9 KiB): at least 300 lines; 16 level-two sections suggest mixed topics.
- `designs/omega-task-rank-and-foreman-retirement.md` (368 lines, 20.8 KiB): at least 300 lines.
- `roles/liaison/AGENT.md` (366 lines, 23.5 KiB): at least 300 lines; 8 level-two sections suggest mixed topics.
- `designs/liveness-progress-reaping.md` (360 lines, 24.6 KiB): at least 300 lines; at least 24 KiB; 10 level-two sections suggest mixed topics.
- `designs/opencode-alternate-harness.md` (355 lines, 22.8 KiB): at least 300 lines; 9 level-two sections suggest mixed topics.
- `designs/tada-token-accounting.md` (352 lines, 20.8 KiB): at least 300 lines; 9 level-two sections suggest mixed topics.
- `designs/staged-gauntlet.md` (347 lines, 18.8 KiB): at least 300 lines; 8 level-two sections suggest mixed topics.
- `designs/recurring-budget-calibration.md` (346 lines, 21.4 KiB): at least 300 lines; 11 level-two sections suggest mixed topics.
- `skills/ci-failure-classification-loop/SKILL.md` (340 lines, 17.1 KiB): at least 300 lines; 11 level-two sections suggest mixed topics.
- `skills/frozen-base-branch/SKILL.md` (339 lines, 15.4 KiB): at least 300 lines; 12 level-two sections suggest mixed topics.
- `designs/gnome-backend-verified-autotune.md` (331 lines, 19.2 KiB): at least 300 lines; 8 level-two sections suggest mixed topics.
- `CLAUDE.md` (321 lines, 40.1 KiB): at least 300 lines; at least 24 KiB; 10 level-two sections suggest mixed topics.
- `designs/kimi-k3-takes-opus-work-with-opus-fallback.md` (315 lines, 15.5 KiB): at least 300 lines; 10 level-two sections suggest mixed topics.
- `designs/deadline-nudge.md` (309 lines, 15.5 KiB): at least 300 lines; 12 level-two sections suggest mixed topics.
- `designs/bot-email-dedicated-domain.md` (304 lines, 21.1 KiB): at least 300 lines; 9 level-two sections suggest mixed topics.
- `references/endo-but-for-bots/roles/chronicler.md` (284 lines, 13.8 KiB): 2.2x the sibling median (128 lines).
- `skills/at-mention-surveillance/SKILL.md` (284 lines, 15.3 KiB): 8 level-two sections suggest mixed topics.
- `designs/sysop-repo-maintenance.md` (283 lines, 16.0 KiB): 9 level-two sections suggest mixed topics.
- `designs/fastmail-masked-email-bot-personas.md` (280 lines, 16.5 KiB): 9 level-two sections suggest mixed topics.
- `skills/pr-handoff/SKILL.md` (279 lines, 22.4 KiB): 13 level-two sections suggest mixed topics.
- `designs/sysop-local-model.md` (275 lines, 15.4 KiB): 9 level-two sections suggest mixed topics.
- `skills/self-healing-wrapper/SKILL.md` (273 lines, 16.3 KiB): 8 level-two sections suggest mixed topics.
- `context/operations/starting.md` (268 lines, 13.7 KiB): 2.5x the sibling median (108 lines).
- `designs/change-review-tool-with-review-metering.md` (267 lines, 12.6 KiB): 8 level-two sections suggest mixed topics.
- `skills/gap-revealing-build/SKILL.md` (263 lines, 11.8 KiB): 10 level-two sections suggest mixed topics.
- `designs/xst-park-on-fail.md` (261 lines, 15.8 KiB): 8 level-two sections suggest mixed topics.
- `designs/planning-vs-review-rounds.md` (260 lines, 15.2 KiB): 10 level-two sections suggest mixed topics.
- `roles/COMMON.md` (260 lines, 36.8 KiB): at least 24 KiB; 15 level-two sections suggest mixed topics.
- `designs/post-verdict-addressee.md` (240 lines, 13.8 KiB): 8 level-two sections suggest mixed topics.
- `references/endo-but-for-bots/skills/surface-module-pattern.md` (235 lines, 8.9 KiB): 2.4x the sibling median (96 lines); 9 level-two sections suggest mixed topics.
- `skills/panel-review/SKILL.md` (229 lines, 22.1 KiB): 11 level-two sections suggest mixed topics.
- `designs/deliberate-deploy.md` (217 lines, 12.3 KiB): 10 level-two sections suggest mixed topics.
- `roles/proxy/AGENT.md` (217 lines, 12.3 KiB): 10 level-two sections suggest mixed topics.
- `references/endo-but-for-bots/skills/pr-cycle-state.md` (200 lines, 7.5 KiB): 2.1x the sibling median (96 lines); 9 level-two sections suggest mixed topics.
- `skills/node-lts-window-watch/SKILL.md` (190 lines, 15.9 KiB): 17 level-two sections suggest mixed topics.
- `skills/css-design-tokens-and-theming/SKILL.md` (187 lines, 8.7 KiB): 11 level-two sections suggest mixed topics.
- `skills/aws-administration/SKILL.md` (186 lines, 9.0 KiB): 8 level-two sections suggest mixed topics.
- `skills/supports-feature-query-progressive-enhancement/SKILL.md` (181 lines, 8.7 KiB): 9 level-two sections suggest mixed topics.
- `roles/botanist/AGENT.md` (179 lines, 44.7 KiB): at least 24 KiB; 8 level-two sections suggest mixed topics.
- `skills/css-intrinsic-and-content-sizing/SKILL.md` (177 lines, 8.4 KiB): 10 level-two sections suggest mixed topics.
- `designs/ai-sdk-garden-integration.md` (168 lines, 11.4 KiB): 9 level-two sections suggest mixed topics.
- `skills/activity-feed-watcher/SKILL.md` (162 lines, 7.7 KiB): 8 level-two sections suggest mixed topics.
- `skills/pre-push-gates/SKILL.md` (161 lines, 23.4 KiB): 9 level-two sections suggest mixed topics.
- `roles/scholar/AGENT.md` (117 lines, 27.2 KiB): at least 24 KiB.

## journal2 entries/

Reachable documents: 13. Reorganization candidates: 0.

### Largest 13 documents

| Path | Lines | Bytes | Class | Level-two sections |
| --- | ---: | ---: | --- | ---: |
| `entries/2026/05/29/015400Z-message-steward-b8c2d3.md` | 100 | 4266 | medium | 5 |
| `entries/2026/05/19/213800Z-dispatch-liaison-c0a194.md` | 92 | 8291 | medium | 5 |
| `entries/2026/05/13/001202Z-message-liaison-28a603.md` | 76 | 3230 | small | 0 |
| `entries/2026/05/13/023600Z-message-monitor-926d77.md` | 48 | 3658 | small | 4 |
| `entries/2026/05/18/051155Z-message-cleaner-e31b72.md` | 48 | 2106 | small | 0 |
| `entries/2026/05/12/193714Z-message-liaison-d45bb5.md` | 37 | 1616 | small | 0 |
| `entries/2026/05/12/194807Z-worktree-liaison-619681.md` | 33 | 1373 | small | 0 |
| `entries/2026/05/13/045631Z-dispatch-liaison-266ec2.md` | 29 | 3643 | small | 0 |
| `entries/2026/05/13/023818Z-result-gardener-b86896.md` | 26 | 1856 | small | 2 |
| `entries/2026/05/13/023047Z-tick-monitor-08f970.md` | 25 | 2262 | small | 0 |
| `entries/2026/05/12/193651Z-message-liaison-aad0d0.md` | 25 | 931 | small | 0 |
| `entries/2026/05/13/023400Z-result-gardener-bb97fb.md` | 21 | 2154 | small | 0 |
| `entries/2026/05/12/193700Z-message-liaison-5f675d.md` | 19 | 592 | small | 0 |

### Reorganization candidates

None.

## journal2 library/

Reachable documents: 7968. Reorganization candidates: 266.

### Largest 15 documents

| Path | Lines | Bytes | Class | Level-two sections |
| --- | ---: | ---: | --- | ---: |
| `library/sections/README.md` (generated index, exempt) | 11561 | 3055358 | very large | 3 |
| `library/sources/README.md` | 1085 | 1567422 | very large | 15 |
| `library/conventions.md` | 583 | 46027 | large | 18 |
| `library/sections/endo--packages-ses-src-error-console-js--logging-console-causal-console-and-error-info-rendering--body.md` | 416 | 18623 | large | 0 |
| `library/sections/endo--pkg-ses-readme--usage-modules.md` | 412 | 16703 | large | 0 |
| `library/sections/endo--packages-exo-src-exo-tools-js--method-defense-with-raw-guards-and-async-await-handling--body.md` | 403 | 17882 | large | 0 |
| `library/sections/garden--roles-COMMON-md--sixth-garden-source-and-standing-subagent-instructions-and-explicit-load-vs-auto-load--key-moves.md` | 383 | 26732 | large | 0 |
| `library/sections/endo--packages-ses-src-error-assert-js--logArgs-makeError-sanitizeError-tagError-and-loggedErrorHandler--body.md` | 371 | 23951 | large | 0 |
| `library/sections/endo--packages-exo-src-exo-makers-js--defineExoClass-defineExoClassKit-and-makeExo-factory-trio--body.md` | 360 | 18424 | large | 0 |
| `library/sections/endo--packages-patterns-src-keys-compareKeys-js--passstyle-dispatched-key-comparison-with-pareto-partial-order--body.md` | 358 | 18688 | large | 0 |
| `library/sections/endo-but-for-bots--llm-designs-daemon-agent-tools--dir-shell-git-capabilities-and-dynamic-tool-registration--body.md` | 356 | 19925 | large | 0 |
| `library/sections/endo--packages-marshal-src-encodepassable-js--dual-array-encodings-and-double-decode-verify--body.md` | 341 | 12791 | large | 0 |
| `library/topics/capability-security.md` | 335 | 130946 | very large | 3 |
| `library/sections/endo--packages-ses-src-error-tame-console-js--integration-wiring-and-platform-error-traps--body.md` | 332 | 16604 | large | 0 |
| `library/sections/garden--journal-library-conventions-md--tenth-garden-source-and-library-conventions-shape-and-third-design-instance-pair--key-moves.md` | 328 | 27352 | large | 2 |

### Reorganization candidates

- `library/sources/README.md` (1085 lines, 1530.7 KiB): at least 300 lines; at least 24 KiB; 29.3x the sibling median (37 lines); 15 level-two sections suggest mixed topics.
- `library/conventions.md` (583 lines, 44.9 KiB): at least 300 lines; at least 24 KiB; 9.1x the sibling median (64 lines); 18 level-two sections suggest mixed topics.
- `library/sections/endo--packages-ses-src-error-console-js--logging-console-causal-console-and-error-info-rendering--body.md` (416 lines, 18.2 KiB): at least 300 lines; 12.2x the sibling median (34 lines).
- `library/sections/endo--pkg-ses-readme--usage-modules.md` (412 lines, 16.3 KiB): at least 300 lines; 12.1x the sibling median (34 lines).
- `library/sections/endo--packages-exo-src-exo-tools-js--method-defense-with-raw-guards-and-async-await-handling--body.md` (403 lines, 17.5 KiB): at least 300 lines; 11.9x the sibling median (34 lines).
- `library/sections/garden--roles-COMMON-md--sixth-garden-source-and-standing-subagent-instructions-and-explicit-load-vs-auto-load--key-moves.md` (383 lines, 26.1 KiB): at least 300 lines; at least 24 KiB; 11.3x the sibling median (34 lines).
- `library/sections/endo--packages-ses-src-error-assert-js--logArgs-makeError-sanitizeError-tagError-and-loggedErrorHandler--body.md` (371 lines, 23.4 KiB): at least 300 lines; 10.9x the sibling median (34 lines).
- `library/sections/endo--packages-exo-src-exo-makers-js--defineExoClass-defineExoClassKit-and-makeExo-factory-trio--body.md` (360 lines, 18.0 KiB): at least 300 lines; 10.6x the sibling median (34 lines).
- `library/sections/endo--packages-patterns-src-keys-compareKeys-js--passstyle-dispatched-key-comparison-with-pareto-partial-order--body.md` (358 lines, 18.2 KiB): at least 300 lines; 10.5x the sibling median (34 lines).
- `library/sections/endo-but-for-bots--llm-designs-daemon-agent-tools--dir-shell-git-capabilities-and-dynamic-tool-registration--body.md` (356 lines, 19.5 KiB): at least 300 lines; 10.5x the sibling median (34 lines).
- `library/sections/endo--packages-marshal-src-encodepassable-js--dual-array-encodings-and-double-decode-verify--body.md` (341 lines, 12.5 KiB): at least 300 lines; 10.0x the sibling median (34 lines).
- `library/topics/capability-security.md` (335 lines, 127.9 KiB): at least 300 lines; at least 24 KiB; 6.8x the sibling median (49 lines).
- `library/sections/endo--packages-ses-src-error-tame-console-js--integration-wiring-and-platform-error-traps--body.md` (332 lines, 16.2 KiB): at least 300 lines; 9.8x the sibling median (34 lines).
- `library/sections/garden--journal-library-conventions-md--tenth-garden-source-and-library-conventions-shape-and-third-design-instance-pair--key-moves.md` (328 lines, 26.7 KiB): at least 300 lines; at least 24 KiB; 9.6x the sibling median (34 lines).
- `library/sections/endo--packages-exo-src-exo-tools-js--defendPrototype-and-defendPrototypeKit-with-interface-guard-validation--body.md` (325 lines, 14.9 KiB): at least 300 lines; 9.6x the sibling median (34 lines).
- `library/sections/endo--packages-marshal-src-rankorder-js--inner-comparator-per-pass-style-rules--body.md` (324 lines, 12.0 KiB): at least 300 lines; 9.5x the sibling median (34 lines).
- `library/sections/endo--packages-ses-src-error-tame-v8-error-constructor-js--tame-v8-error-constructor-and-system-vs-user-preparefns--body.md` (310 lines, 13.7 KiB): at least 300 lines; 9.1x the sibling median (34 lines).
- `library/sections/endo--packages-ses-src-error-assert-js--makeAssert-and-the-assert-function-family--body.md` (305 lines, 14.6 KiB): at least 300 lines; 9.0x the sibling median (34 lines).
- `library/sections/endo-but-for-bots--llm-designs-chat-reply-chain-visualization--css-gutter-rendering-and-deprecation-rationale--body.md` (300 lines, 17.4 KiB): at least 300 lines; 8.8x the sibling median (34 lines).
- `library/sections/endo-but-for-bots--llm-designs-daemon-value-message--value-message-type-and-reply-only-design--body.md` (285 lines, 15.6 KiB): 8.4x the sibling median (34 lines).
- `library/sections/endo-but-for-bots--llm-designs-familiar-electron-shell--electron-shell-with-daemon-outlives-app-and-localhttp-protocol--body.md` (285 lines, 18.3 KiB): 8.4x the sibling median (34 lines).
- `library/sections/endo--packages-marshal-src-encodepassable-js--error-special-case-and-passstyle-prefix-table--body.md` (275 lines, 11.1 KiB): 8.1x the sibling median (34 lines).
- `library/sections/endo--docs-message-passing--defensive-receive-protected-objects.md` (273 lines, 7.0 KiB): 8.0x the sibling median (34 lines).
- `library/sections/endo--packages-zip-src-format-reader-js--symmetric-reverse-pipeline-and-Zip64-rejection-with-security-rationale-and-findLast-deliberately-not-used-and-named-strike-a-compromise--key-moves.md` (272 lines, 15.5 KiB): 8.0x the sibling median (34 lines).
- `library/sections/endo--packages-patterns-src-keys-checkKey-js--copyset-copybag-copymap-extensions-and-special-case-algorithms--body.md` (271 lines, 14.8 KiB): 8.0x the sibling median (34 lines).
- `library/sections/endo-but-for-bots--llm-designs-daemon-commands-as-messages--commands-as-self-addressed-messages-design--body.md` (270 lines, 16.9 KiB): 7.9x the sibling median (34 lines).
- `library/sections/endo--packages-ses-src-error-console-js--no-special-privilege-prelude-and-console-method-permit-lists--body.md` (265 lines, 17.4 KiB): 7.8x the sibling median (34 lines).
- `library/sections/papers--taly-automated-analysis-of-security-critical-javascript-apis-2011--static-analysis-procedure-and-soundness-theorem--body.md` (260 lines, 14.0 KiB): 7.6x the sibling median (34 lines).
- `library/sections/endo--docs-lockdown--stack-filtering.md` (256 lines, 14.5 KiB): 7.5x the sibling median (34 lines).
- `library/sections/endo--docs-reference--lockdown-options-summary.md` (254 lines, 11.2 KiB): 7.5x the sibling median (34 lines).
- `library/concepts/README.md` (252 lines, 92.4 KiB): at least 24 KiB; 7.9x the sibling median (32 lines).
- `library/sections/garden--roles-liaison-AGENT-md--eighth-garden-source-and-role-specific-orchestrator-instructions--key-moves.md` (250 lines, 23.0 KiB): 7.4x the sibling median (34 lines).
- `library/sections/endo-but-for-bots--llm-designs-familiar-daemon-bundling--single-file-bundle-with-worker-entry-and-platform-node--body.md` (248 lines, 13.8 KiB): 7.3x the sibling median (34 lines).
- `library/sources/endo--packages-promise-kit-src-memo-race-js.md` (248 lines, 11.9 KiB): 6.7x the sibling median (37 lines).
- `library/sections/endo--packages-ses-src-error-assert-js--declassifiers-quote-bare-and-redacted-vs-unredacted-details--body.md` (244 lines, 12.9 KiB): 7.2x the sibling median (34 lines).
- `library/sections/endo-but-for-bots--llm-designs-familiar-unified-weblet-server--single-port-virtual-host-routing-with-key-revision--body.md` (244 lines, 14.6 KiB): 7.2x the sibling median (34 lines).
- `library/sections/erights--elang-quick-ref--idioms-quick-reference.md` (244 lines, 7.6 KiB): 7.2x the sibling median (34 lines); 10 level-two sections suggest mixed topics.
- `library/sections/endo--pkg-ses-docs-secure-coding-guide--more-patterns--don-t-use-reachable-objects-as-mutable-records.md` (243 lines, 7.4 KiB): 7.1x the sibling median (34 lines).
- `library/sections/endo-but-for-bots--llm-designs-daemon-form-request--form-message-type-and-implementation--body.md` (243 lines, 11.7 KiB): 7.1x the sibling median (34 lines).
- `library/sections/endo-but-for-bots--llm-designs-endopi-skills-markdown-format--agentskills-io-on-disk-skill-shape-with-progressive-disclosure--body.md` (242 lines, 13.9 KiB): 7.1x the sibling median (34 lines).
- `library/sections/endo--packages-marshal-src-rankorder-js--full-order-comparator-kit-observable-mutable-state--body.md` (239 lines, 9.9 KiB): 7.0x the sibling median (34 lines).
- `library/sections/endo--packages-patterns-src-keys-checkKey-js--keys-foundation-confirm-is-assert-trio-and-recursion--body.md` (239 lines, 12.3 KiB): 7.0x the sibling median (34 lines).
- `library/sections/endo-but-for-bots--llm-designs-daemon-capability-bank--family-of-designs-and-six-design-principles--body.md` (239 lines, 18.2 KiB): 7.0x the sibling median (34 lines).
- `library/sections/garden--scripts-daemons-start-and-stop-pair--five-cycles-with-garden-source-ingest-and-set-uo-pipefail-and-systemd-template-units--key-moves.md` (238 lines, 19.1 KiB): 7.0x the sibling median (34 lines).
- `library/sections/erights--elang-kernel--meta-interpreter-semantics.md` (235 lines, 11.1 KiB): 6.9x the sibling median (34 lines).
- `library/sections/endo--packages-ses-src-error-unhandled-rejection-js--browser-limitations-and-finalization-registry-rejection-tracking--body.md` (229 lines, 13.3 KiB): 6.7x the sibling median (34 lines).
- `library/sections/endo--pkg-ses-docs-secure-coding-guide--basic-ses-example.md` (229 lines, 7.3 KiB): 6.7x the sibling median (34 lines).
- `library/sections/garden--scripts-dispatch-prepare-and-teardown-pair--implementation-of-cycle-297-named-prepare-and-teardown-pair-shape-and-set-euo-pipefail-discipline-and-stdout-as-return-value--key-moves.md` (228 lines, 13.0 KiB): 6.7x the sibling median (34 lines).
- `library/sections/endo--packages-marshal-src-encodepassable-js--compact-format-string-escapes--body.md` (226 lines, 9.0 KiB): 6.6x the sibling median (34 lines).
- `library/sections/endo--pkg-ses-readme--usage-core.md` (226 lines, 8.1 KiB): 6.6x the sibling median (34 lines).
- `library/sections/endo--packages-pass-style-src-error-js--error-validation-security-vs-diagnostic-tension--body.md` (225 lines, 13.3 KiB): 6.6x the sibling median (34 lines).
- `library/sources/endo-but-for-bots--packages-fae-COMPARISON-FAE-LAL-md.md` (225 lines, 12.8 KiB): 6.1x the sibling median (37 lines).
- `library/sections/papers--taly-automated-analysis-of-security-critical-javascript-apis-2011--applications-adsafe-vulnerability-sealer-unsealer-and-mint--body.md` (223 lines, 15.7 KiB): 6.6x the sibling median (34 lines).
- `library/sources/endo--packages-where-index-js.md` (220 lines, 10.1 KiB): 5.9x the sibling median (37 lines).
- `library/sections/endo--packages-marshal-src-rankorder-js--sort-by-rank-undefined-quirk-and-passstyleprefixes-invariant--body.md` (217 lines, 8.9 KiB): 6.4x the sibling median (34 lines).
- `library/sections/endo--packages-zip-src-format-writer-js--three-stage-pipeline-encode-compress-make-record-and-DOS-date-bit-packing-and-LocalFileLocator-with-three-offsets-and-FileRecord-extends-ArchiveHeaders--key-moves.md` (217 lines, 14.0 KiB): 6.4x the sibling median (34 lines).
- `library/sources/endo-but-for-bots--packages-lal-setup-js.md` (217 lines, 12.0 KiB): 5.9x the sibling median (37 lines).
- `library/sources/endo-but-for-bots--packages-lal-primer-howto-code-md.md` (215 lines, 12.2 KiB): 5.8x the sibling median (37 lines).
- `library/sections/endo--docs-message-passing--digital-purse-example.md` (214 lines, 6.9 KiB): 6.3x the sibling median (34 lines).
- `library/sections/endo--packages-marshal-src-marshal-js--error-diagnostic-priority--body.md` (214 lines, 9.8 KiB): 6.3x the sibling median (34 lines).
- `library/sections/garden--scripts-watcher-endo-but-for-bots-watcher-sh--ninth-garden-source-and-named-phase-1-stub-shape--key-moves.md` (213 lines, 15.1 KiB): 6.3x the sibling median (34 lines).
- `library/sources/endo-but-for-bots--packages-exo-README-md.md` (213 lines, 12.3 KiB): 5.8x the sibling median (37 lines).
- `library/sections/endo--packages-marshal-src-encodepassable-js--bigint-encoding-elias-delta-with-sign-aware-alphabets--body.md` (212 lines, 8.4 KiB): 6.2x the sibling median (34 lines).
- `library/sources/endo-but-for-bots--packages-marshal-README-md.md` (211 lines, 11.7 KiB): 5.7x the sibling median (37 lines).
- `library/sections/endo--packages-marshal-src-encodepassable-js--number-encoding-binary64-bit-complement--body.md` (210 lines, 9.1 KiB): 6.2x the sibling median (34 lines).
- `library/sections/endo--packages-marshal-src-rankorder-js--same-value-zero-and-numeric-rank-semantics--body.md` (210 lines, 9.0 KiB): 6.2x the sibling median (34 lines).
- `library/sources/endo--packages-shim-and-prepare-endo-cluster.md` (210 lines, 8.5 KiB): 5.7x the sibling median (37 lines).
- `library/sections/endo--packages-nat-src-index-js--Nat-predicate-and-coercion-pair-and-named-BigInt-constants--key-moves.md` (209 lines, 13.5 KiB): 6.1x the sibling median (34 lines).
- `library/sections/garden--skills-library-lookup-SKILL-md--seventh-garden-source-and-skill-procedural-playbook-and-second-design-instance-pair--key-moves.md` (207 lines, 17.2 KiB): 6.1x the sibling median (34 lines).
- `library/sources/endo-but-for-bots--packages-patterns-README-md.md` (207 lines, 11.5 KiB): 5.6x the sibling median (37 lines).
- `library/sections/endo--packages-marshal-src-marshal-js--dual-format-body-discriminator--body.md` (206 lines, 8.9 KiB): 6.1x the sibling median (34 lines).
- `library/sections/papers--swasey-garg-dreyer-ocpl-2017--three-ocps-verified-dynamic-sealing-caretaker-membrane--body.md` (205 lines, 14.8 KiB): 6.0x the sibling median (34 lines).
- `library/sections/endo--packages-patterns-src-keys-copybag-js--bag-entry-validation-with-per-entry-shape-and-positive-count--body.md` (204 lines, 9.9 KiB): 6.0x the sibling median (34 lines).
- `library/sources/endo-but-for-bots--packages-fae-README-md.md` (204 lines, 11.5 KiB): 5.5x the sibling median (37 lines).
- `library/sources/endo-but-for-bots--packages-lal-primer-tools-md.md` (204 lines, 11.0 KiB): 5.5x the sibling median (37 lines).
- `library/sections/garden--journal-jobs-README-md--eleventh-garden-source-and-job-board-contract-and-fourth-design-instance-pair--key-moves.md` (203 lines, 18.5 KiB): 6.0x the sibling median (34 lines).
- `library/sources/endo-but-for-bots--packages-captp-README-md.md` (203 lines, 11.2 KiB): 5.5x the sibling median (37 lines).
- `library/sources/endo-but-for-bots--packages-captp-src-loopback-js.md` (203 lines, 11.2 KiB): 5.5x the sibling median (37 lines).
- `library/sources/endo-but-for-bots--packages-eventual-send-README-md.md` (203 lines, 11.2 KiB): 5.5x the sibling median (37 lines).
- `library/sources/endo-but-for-bots--packages-conversation-tree-src-endopetstore-backend-js.md` (202 lines, 11.5 KiB): 5.5x the sibling median (37 lines).
- `library/sources/endo-but-for-bots--packages-lal-primer-capabilities-md.md` (202 lines, 12.0 KiB): 5.5x the sibling median (37 lines).
- `library/sources/metamask-ocap-kernel--docs-ken-protocol-assessment-md.md` (202 lines, 8.5 KiB): 5.5x the sibling median (37 lines).
- `library/sections/endo--packages-marshal-src-rankorder-js--pass-style-rank-derivation-and-rank-covers--body.md` (201 lines, 9.1 KiB): 5.9x the sibling median (34 lines).
- `library/sections/papers--drossopoulou-reasoning-about-risk-and-trust-2015--hoare-four-tuples-and-code-agnostic-rules--body.md` (201 lines, 15.8 KiB): 5.9x the sibling median (34 lines).
- `library/sources/endo-but-for-bots--llm-designs-daemon-capability-filesystem.md` (201 lines, 8.0 KiB): 5.4x the sibling median (37 lines).
- `library/sources/endo-but-for-bots--packages-familiar-src-protocol-handler-js.md` (201 lines, 11.9 KiB): 5.4x the sibling median (37 lines).
- `library/sources/endo-but-for-bots--packages-lal-primer-howto-capabilities-md.md` (201 lines, 10.8 KiB): 5.4x the sibling median (37 lines).
- `library/sections/endo--packages-zip-src-buffer-reader-js--WeakMap-private-fields-with-bound-get-helper-and-can-assertCan-do-it-triad-and-IE10-historical-ghost-comment-and-findLast-reverse-search--key-moves.md` (200 lines, 12.3 KiB): 5.9x the sibling median (34 lines).
- `library/sources/endo-but-for-bots--packages-fae-COMPARISON-FAE-NANOBOT-md.md` (200 lines, 11.3 KiB): 5.4x the sibling median (37 lines).
- `library/sections/endo--docs-message-passing--eventual-send-async-messaging.md` (199 lines, 5.6 KiB): 5.9x the sibling median (34 lines).
- `library/sections/endo--packages-evasive-transform--SES-censorship-evasion-with-six-strategies-and-comment-defanging-and-decrement-greater-edge-case-and-sync-async-API-pair-and-zero-width-end-adopt-start-from--six-evasion-strategies.md` (199 lines, 9.9 KiB): 5.9x the sibling median (34 lines).
- `library/sections/endo--packages-marshal-src-encodetosmallcaps-js--canonical-encoding-invariants--body.md` (199 lines, 8.4 KiB): 5.9x the sibling median (34 lines).
- `library/sections/endo--docs-lockdown--error-taming.md` (198 lines, 8.3 KiB): 5.8x the sibling median (34 lines).
- `library/sections/endo--docs-message-passing--validation-describing-what-you-accept.md` (198 lines, 5.9 KiB): 5.8x the sibling median (34 lines).
- `library/sections/endo--pkg-compartment-mapper-readme--language-extensions--compartment-maps.md` (198 lines, 7.3 KiB): 5.8x the sibling median (34 lines).
- `library/sources/endo--packages-patterns-src-patterns-getGuardPayloads-js.md` (197 lines, 9.5 KiB): 5.3x the sibling median (37 lines).
- `library/sources/endo--packages-ses-README-md.md` (197 lines, 9.5 KiB): 5.3x the sibling median (37 lines).
- `library/sections/garden--roles-steward-AGENT-md--twelfth-garden-source-and-orchestrator-pair-completes--key-moves.md` (196 lines, 19.1 KiB): 5.8x the sibling median (34 lines).
- `library/sources/endo-but-for-bots--packages-lal-LAL-ARCHITECTURE-md.md` (196 lines, 10.9 KiB): 5.3x the sibling median (37 lines).
- `library/sources/endo-but-for-bots--packages-pass-style-src-byteArray-js.md` (196 lines, 11.4 KiB): 5.3x the sibling median (37 lines).
- `library/sources/endo-but-for-bots--packages-pass-style-src-copyRecord-js.md` (196 lines, 10.8 KiB): 5.3x the sibling median (37 lines).
- `library/sections/garden--WORKTREES-md--second-garden-design-and-three-named-worktree-kinds-and-the-named-dash-dash-separator-discipline-and-detached-HEAD-as-discipline-and-named-standing-exceptions--key-moves.md` (195 lines, 12.9 KiB): 5.7x the sibling median (34 lines).
- `library/sources/endo-but-for-bots--packages-errors-index-js.md` (194 lines, 10.6 KiB): 5.2x the sibling median (37 lines).
- `library/sources/endo-but-for-bots--packages-lal-providers-anthropic-js.md` (194 lines, 11.4 KiB): 5.2x the sibling median (37 lines).
- `library/sections/danfinlay-quickjs--native-ses--xs-transferable-strategies.md` (193 lines, 11.3 KiB): 5.7x the sibling median (34 lines).
- `library/sections/endo--packages-ses-src-error-console-js--causal-console-from-logger-and-filter-console--body.md` (193 lines, 9.4 KiB): 5.7x the sibling median (34 lines).
- `library/sections/endo-but-for-bots--llm-designs-chat-reply-chain-visualization--message-of-interest-spotlight-algorithm-and-layout-computation--body.md` (193 lines, 11.2 KiB): 5.7x the sibling median (34 lines).
- `library/sources/endo-but-for-bots--llm-designs-filesystem-watchers.md` (193 lines, 8.2 KiB): 5.2x the sibling median (37 lines).
- `library/sources/endo-but-for-bots--packages-familiar-src-exfiltration-defense-js.md` (193 lines, 10.6 KiB): 5.2x the sibling median (37 lines).
- `library/sources/endo-but-for-bots--packages-familiar-src-navigation-guard-js.md` (193 lines, 10.1 KiB): 5.2x the sibling median (37 lines).
- `library/sources/endo-but-for-bots--packages-lal-primer-messaging-md.md` (193 lines, 10.6 KiB): 5.2x the sibling median (37 lines).
- `library/sources/endo--packages-harden-make-hardener-js.md` (192 lines, 10.3 KiB): 5.2x the sibling median (37 lines).
- `library/sources/endo-but-for-bots--llm-designs-daemon-engo-supervisor.md` (192 lines, 7.3 KiB): 5.2x the sibling median (37 lines).
- `library/sources/endo-but-for-bots--llm-designs-unhandled-rejection-display.md` (192 lines, 8.5 KiB): 5.2x the sibling median (37 lines).
- `library/sources/metamask-ocap-kernel--docs-glossary-md.md` (191 lines, 8.0 KiB): 5.2x the sibling median (37 lines).
- `library/sources/endo--packages-captp-src-atomics-js.md` (190 lines, 8.0 KiB): 5.1x the sibling median (37 lines).
- `library/sources/endo--packages-stream-index-js.md` (190 lines, 7.4 KiB): 5.1x the sibling median (37 lines).
- `library/sections/endo--packages-patterns-src-keys-copyset-js--element-validation-and-canonical-internal-form--body.md` (189 lines, 9.9 KiB): 5.6x the sibling median (34 lines).
- `library/sections/endo-but-for-bots--llm-designs-endopi-jsonl-transcript-format--pi-compatible-jsonl-with-custom-entries-for-endo-extensions--body.md` (189 lines, 12.6 KiB): 5.6x the sibling median (34 lines).
- `library/sources/endo-but-for-bots--llm-designs-endo-posix-sandbox.md` (189 lines, 7.2 KiB): 5.1x the sibling median (37 lines).
- `library/sources/endo-but-for-bots--llm-designs-endopi.md` (189 lines, 9.6 KiB): 5.1x the sibling median (37 lines).
- `library/sources/endo-but-for-bots--packages-lal-test-simulator-mock-powers-js.md` (189 lines, 10.6 KiB): 5.1x the sibling median (37 lines).
- `library/sections/endo--packages-ses-src-error-tame-v8-error-constructor-js--call-site-permit-list-and-filename-censors--body.md` (188 lines, 10.5 KiB): 5.5x the sibling median (34 lines).
- `library/sources/endo-but-for-bots--llm-designs-ci-no-npm-lifecycle.md` (188 lines, 8.1 KiB): 5.1x the sibling median (37 lines).
- `library/sources/endo-but-for-bots--llm-designs-daemon-endo-rust-sqlite.md` (188 lines, 7.0 KiB): 5.1x the sibling median (37 lines).
- `library/sources/endo-but-for-bots--packages-conversation-tree-index-js.md` (188 lines, 11.0 KiB): 5.1x the sibling median (37 lines).
- `library/sources/endo-but-for-bots--packages-patterns-src-keys-copySet-js.md` (188 lines, 10.8 KiB): 5.1x the sibling median (37 lines).
- `library/sources/endo--packages-compartment-mapper-README-md.md` (187 lines, 10.1 KiB): 5.1x the sibling median (37 lines).
- `library/sources/endo-but-for-bots--packages-conversation-tree-types-js.md` (187 lines, 10.7 KiB): 5.1x the sibling median (37 lines).
- `library/sources/endo-but-for-bots--packages-lal-primer-README-md.md` (186 lines, 10.2 KiB): 5.0x the sibling median (37 lines).
- `library/sources/endo-but-for-bots--packages-lal-providers-index-js.md` (185 lines, 10.5 KiB): 5.0x the sibling median (37 lines).
- `library/sources/endo-but-for-bots--packages-lal-providers-ollama-js.md` (185 lines, 10.8 KiB): 5.0x the sibling median (37 lines).
- `library/sections/garden--skills-self-improvement-SKILL-md--thirteenth-garden-source-and-second-shape-extension-and-triple-claim--key-moves.md` (184 lines, 15.4 KiB): 5.4x the sibling median (34 lines).
- `library/sources/endo-but-for-bots--llm-designs-daemon-rename-to-manager.md` (184 lines, 7.9 KiB): 5.0x the sibling median (37 lines).
- `library/sources/endo-but-for-bots--llm-designs-gateway-package.md` (184 lines, 7.1 KiB): 5.0x the sibling median (37 lines).
- `library/sections/endo--pkg-ses-readme--security-claims-and-caveats.md` (183 lines, 7.7 KiB): 5.4x the sibling median (34 lines).
- `library/sections/papers--taly-automated-analysis-of-security-critical-javascript-apis-2011--api-confinement-problem-and-ses-light-language-design--body.md` (182 lines, 11.9 KiB): 5.4x the sibling median (34 lines).
- `library/sources/endo-but-for-bots--llm-designs-exo-zip-package.md` (182 lines, 7.8 KiB): 4.9x the sibling median (37 lines).
- `library/sources/endo--packages-captp-src-finalize-js.md` (181 lines, 8.0 KiB): 4.9x the sibling median (37 lines).
- `library/sections/endo--docs-message-passing--design-patterns-and-best-practices.md` (180 lines, 4.4 KiB): 5.3x the sibling median (34 lines).
- `library/sections/endo-but-for-bots--llm-designs-chat-voice-command-parser--interaction-patterns-and-asynchrony--body.md` (179 lines, 12.1 KiB): 5.3x the sibling median (34 lines).
- `library/sections/endo-but-for-bots--llm-designs-chat-voice-command-parser--problem-scope-mode-inventory-and-parser-shape--body.md` (179 lines, 10.5 KiB): 5.3x the sibling median (34 lines).
- `library/sections/endo-but-for-bots--llm-designs-daemon-form-request--gaps-and-design-decisions--body.md` (179 lines, 12.4 KiB): 5.3x the sibling median (34 lines).
- `library/sources/endo--packages-pass-style-src-remotable-js.md` (179 lines, 8.5 KiB): 4.8x the sibling median (37 lines).
- `library/sources/endo-but-for-bots--packages-fae-setup-js.md` (179 lines, 10.1 KiB): 4.8x the sibling median (37 lines).
- `library/sections/metamask-ocap-kernel--packages-streams-src-BaseDuplexStream-ts--syn-ack-synchronization-handshake-and-four-state-machine.md` (178 lines, 12.5 KiB): 5.2x the sibling median (34 lines).
- `library/sources/endo--packages-eventual-send-src-local-js.md` (178 lines, 8.5 KiB): 4.8x the sibling median (37 lines).
- `library/sources/endo--packages-promise-kit-src-promise-executor-kit-js.md` (178 lines, 7.0 KiB): 4.8x the sibling median (37 lines).
- `library/sources/endo-but-for-bots--llm-designs-workers-panel.md` (178 lines, 7.6 KiB): 4.8x the sibling median (37 lines).
- `library/sections/cask--cell-capabilities--command-vocabulary-and-examples.md` (177 lines, 8.1 KiB): 5.2x the sibling median (34 lines); 8 level-two sections suggest mixed topics.
- `library/sources/endo-but-for-bots--packages-init-README-md.md` (177 lines, 9.9 KiB): 4.8x the sibling median (37 lines).
- `library/sections/endo--packages-marshal-src-marshal-js--slot-typing-security-hazard--body.md` (176 lines, 8.0 KiB): 5.2x the sibling median (34 lines).
- `library/sections/erights--elib-concurrency-refmech--reference-kinds-near-eventual-broken-promise-far-sturdyref.md` (176 lines, 10.9 KiB): 5.2x the sibling median (34 lines); 8 level-two sections suggest mixed topics.
- `library/sources/endo-but-for-bots--llm-designs-daemon-mount.md` (176 lines, 7.0 KiB): 4.8x the sibling median (37 lines).
- `library/sources/endo--packages-marshal-src-marshal-justin-and-marshal-stringify-js.md` (175 lines, 6.5 KiB): 4.7x the sibling median (37 lines).
- `library/sources/endo-but-for-bots--llm-designs-app-sharing-milestone.md` (175 lines, 7.5 KiB): 4.7x the sibling median (37 lines).
- `library/sections/cask--cell-capabilities--content-model-changes.md` (174 lines, 7.0 KiB): 5.1x the sibling median (34 lines).
- `library/sections/endo--pkg-ses-docs-guide--HardenedJS-renamed-from-SES-and-three-parts-and-Lockdown-two-phases-with-vetted-shims-between-and-Promise-queue-vs-IO-queue--key-moves.md` (174 lines, 11.3 KiB): 5.1x the sibling median (34 lines).
- `library/sections/erights--elib-concurrency-event-loop--plan-interference-and-deadlock-freedom.md` (174 lines, 10.3 KiB): 5.1x the sibling median (34 lines); 9 level-two sections suggest mixed topics.
- `library/sources/endo-but-for-bots--llm-designs-daemon-xs-worker-debugger.md` (174 lines, 7.1 KiB): 4.7x the sibling median (37 lines).
- `library/sources/endo--packages-init-README-md.md` (173 lines, 8.9 KiB): 4.7x the sibling median (37 lines).
- `library/sources/endo-but-for-bots--llm-designs-daemon-xs-worker-metering.md` (173 lines, 6.9 KiB): 4.7x the sibling median (37 lines).
- `library/sources/endo--packages-pass-style-src-make-far-js.md` (172 lines, 7.7 KiB): 4.6x the sibling median (37 lines).
- `library/sources/endo-but-for-bots--llm-designs-daemon-debug-worker-restart.md` (172 lines, 7.0 KiB): 4.6x the sibling median (37 lines).
- `library/sources/endo-but-for-bots--llm-designs-daemon-endor-architecture.md` (172 lines, 6.5 KiB): 4.6x the sibling median (37 lines).
- `library/sources/endo-but-for-bots--llm-designs-endopi-provider-registry-and-oauth.md` (172 lines, 8.2 KiB): 4.6x the sibling median (37 lines).
- `library/sources/endo--packages-lockdown-pre-js.md` (171 lines, 8.6 KiB): 4.6x the sibling median (37 lines).
- `library/sources/endo-but-for-bots--packages-lal-agent-types-d-ts.md` (171 lines, 9.6 KiB): 4.6x the sibling median (37 lines).
- `library/sections/endo--packages-marshal-src-encodetosmallcaps-js--error-encoding-root-special-case--body.md` (170 lines, 7.4 KiB): 5.0x the sibling median (34 lines).
- `library/sections/erights--elib-concurrency-msg-passing--six-primitives-call-send-outcome.md` (170 lines, 9.7 KiB): 5.0x the sibling median (34 lines).
- `library/sources/endo--packages-harden-README-md.md` (170 lines, 8.6 KiB): 4.6x the sibling median (37 lines).
- `library/sources/endo--packages-init-and-lockdown.md` (170 lines, 7.0 KiB): 4.6x the sibling median (37 lines).
- `library/sources/endo--packages-marshal-src-marshal-stringify-js.md` (170 lines, 7.2 KiB): 4.6x the sibling median (37 lines).
- `library/sources/endo-but-for-bots--llm-designs-daemon-xs-worker-snapshot.md` (170 lines, 6.3 KiB): 4.6x the sibling median (37 lines).
- `library/sources/metamask-ocap-kernel--overview.md` (170 lines, 7.4 KiB): 4.6x the sibling median (37 lines).
- `library/sections/papers--miller-morningstar-frantz-capability-based-financial-instruments-2000--pluribus-rights-taxonomy-and-covered-call-option--body.md` (169 lines, 17.1 KiB): 5.0x the sibling median (34 lines).
- `library/topics/hardened-javascript.md` (169 lines, 74.4 KiB): at least 24 KiB; 3.4x the sibling median (49 lines).
- `library/sections/endo-but-for-bots--llm-designs-familiar-gateway-migration--gateway-moved-from-chat-vite-plugin-into-daemon--body.md` (168 lines, 11.6 KiB): 4.9x the sibling median (34 lines).
- `library/sections/ocapn--implementation-guide--stage-6-handoffs.md` (168 lines, 10.9 KiB): 4.9x the sibling median (34 lines).
- `library/sections/papers--miller-tribble-shapiro-concurrency-among-strangers-2005--partial-failure-and-when-catch--body.md` (168 lines, 16.2 KiB): 4.9x the sibling median (34 lines).
- `library/sources/endo-but-for-bots--llm-designs-daemon-checkin-checkout.md` (168 lines, 6.9 KiB): 4.5x the sibling median (37 lines).
- `library/sections/endo--packages-zip-src-buffer-writer-js--WeakMap-private-fields-with-getPrivateFields-helper-and-doubling-capacity-strategy-and-three-named-assertion-functions-and-binary-write-API--key-moves.md` (167 lines, 9.7 KiB): 4.9x the sibling median (34 lines).
- `library/sources/endo--packages-import-bundle-src-compartment-wrapper-js.md` (167 lines, 6.7 KiB): 4.5x the sibling median (37 lines).
- `library/sources/endo-but-for-bots--llm-designs-endo-bytes.md` (167 lines, 6.2 KiB): 4.5x the sibling median (37 lines).
- `library/sources/endo-but-for-bots--llm-designs-endopi-extension-package-manifest.md` (167 lines, 7.9 KiB): 4.5x the sibling median (37 lines).
- `library/sources/endo-but-for-bots--packages-fae-src-tools-js.md` (167 lines, 9.5 KiB): 4.5x the sibling median (37 lines).
- `library/sections/endo--packages-eventual-send-src-track-turns-js--closure-hoisting-and-bidirectional-error-annotation--body.md` (166 lines, 8.5 KiB): 4.9x the sibling median (34 lines).
- `library/sections/endo--packages-marshal-src-encodetosmallcaps-js--special-character-prefix-scheme--body.md` (166 lines, 6.7 KiB): 4.9x the sibling median (34 lines).
- `library/sections/metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatSupervisor-ts--initvat-endowment-filtering-and-caveated-fetch.md` (166 lines, 11.0 KiB): 4.9x the sibling median (34 lines).
- `library/sources/endo-but-for-bots--llm-designs-daemon-cas-management.md` (166 lines, 7.5 KiB): 4.5x the sibling median (37 lines).
- `library/sources/endo-but-for-bots--llm-designs-endoclaw.md` (166 lines, 6.4 KiB): 4.5x the sibling median (37 lines).
- `library/sections/endo--packages-lp32-README-md--length-prefixed-message-streams-and-WebExtension-Native-Messaging-target--key-moves.md` (165 lines, 10.4 KiB): 4.9x the sibling median (34 lines).
- `library/sections/endo--docs-message-passing--foundation-what-can-be-passed.md` (164 lines, 5.8 KiB): 4.8x the sibling median (34 lines).
- `library/sections/metamask-ocap-kernel--packages-ocap-kernel-src-KernelRouter-ts--deliver-send-refcount-and-endpoint-vanished-splat.md` (164 lines, 12.4 KiB): 4.8x the sibling median (34 lines).
- `library/sources/endo-but-for-bots--llm-designs-daemon-rust-xs-performance.md` (164 lines, 6.1 KiB): 4.4x the sibling median (37 lines).
- `library/sections/endo--packages-ses-src-error-tame-v8-error-constructor-js--callsite-path-shortening-patterns--body.md` (163 lines, 8.4 KiB): 4.8x the sibling median (34 lines).
- `library/sections/erights--elang-guarding-async--reference-state-guards-for-asynchrony.md` (163 lines, 10.3 KiB): 4.8x the sibling median (34 lines).
- `library/sources/endo--packages-ses-docs-secure-coding-guide-md.md` (163 lines, 8.8 KiB): 4.4x the sibling median (37 lines).
- `library/sections/erights--elib-concurrency-eio-goals--design-goals-requirements-and-preferences.md` (162 lines, 10.2 KiB): 4.8x the sibling median (34 lines).
- `library/sources/endo--packages-netstring-reader-js.md` (162 lines, 5.9 KiB): 4.4x the sibling median (37 lines).
- `library/sources/endo--packages-pass-style-src-passStyle-helpers-js.md` (162 lines, 7.4 KiB): 4.4x the sibling median (37 lines).
- `library/sources/endo--packages-captp-src-loopback-js.md` (161 lines, 6.7 KiB): 4.4x the sibling median (37 lines).
- `library/sources/endo--packages-harden-make-selector-js.md` (161 lines, 6.2 KiB): 4.4x the sibling median (37 lines).
- `library/sources/endo-but-for-bots--packages-familiar-README-md.md` (161 lines, 8.8 KiB): 4.4x the sibling median (37 lines).
- `library/sources/endo--packages-cli-src-utility-cluster.md` (160 lines, 6.2 KiB): 4.3x the sibling median (37 lines).
- `library/sources/endo--packages-eventual-send-src-message-breakpoints-js.md` (160 lines, 7.6 KiB): 4.3x the sibling median (37 lines).
- `library/sources/metamask-ocap-kernel--docs-platform-specific-md.md` (160 lines, 6.2 KiB): 4.3x the sibling median (37 lines).
- `library/sections/endo--packages-nat-README-md--companion-README-to-cycle-310-source-and-validators-and-coercers-section--key-moves.md` (159 lines, 12.8 KiB): 4.7x the sibling median (34 lines).
- `library/sections/papers--drossopoulou-reasoning-about-risk-and-trust-2015--escrow-failure-and-four-case-valid-escrow-spec--body.md` (159 lines, 15.1 KiB): 4.7x the sibling median (34 lines).
- `library/sources/endo--packages-marshal-src-dot-membrane-js.md` (159 lines, 7.2 KiB): 4.3x the sibling median (37 lines).
- `library/sources/endo-but-for-bots--llm-designs-daemon-guest-eval-simplification.md` (159 lines, 7.5 KiB): 4.3x the sibling median (37 lines).
- `library/sources/endo--packages-base64-src-encode-decode-js.md` (158 lines, 6.1 KiB): 4.3x the sibling median (37 lines).
- `library/sections/erights--elang-concurrency-race--racing-joining-and-timeouts.md` (157 lines, 7.6 KiB): 4.6x the sibling median (34 lines).
- `library/sections/erights--elib-concurrency-semi-transparent--semi-transparent-networking.md` (157 lines, 9.4 KiB): 4.6x the sibling median (34 lines).
- `library/sections/frb--readme--reference-programmatic-api.md` (157 lines, 8.0 KiB): 4.6x the sibling median (34 lines).
- `library/sources/endo--packages-eventual-send-src-E-js.md` (157 lines, 6.9 KiB): 4.2x the sibling median (37 lines).
- `library/sections/endo--packages-memoize-src-memoize-js--memoization-primitive-with-named-encapsulatedPumpkin-recursion-sentinel--key-moves.md` (156 lines, 9.5 KiB): 4.6x the sibling median (34 lines).
- `library/sources/endo-but-for-bots--llm-designs-endopi-iterative-compaction.md` (156 lines, 7.7 KiB): 4.2x the sibling median (37 lines).
- `library/sources/metamask-ocap-kernel--docs-identity-backup-recovery-md.md` (156 lines, 6.4 KiB): 4.2x the sibling median (37 lines).
- `library/topics/content-addressed-storage.md` (156 lines, 41.2 KiB): at least 24 KiB; 3.2x the sibling median (49 lines).
- `library/sections/endo--packages-hex-src-encode-js--polyfill-and-native-dispatch-pair-and-pre-lockdown-capture--key-moves.md` (155 lines, 9.6 KiB): 4.6x the sibling median (34 lines).
- `library/sections/papers--miller-vancutsem-tulloh-distributed-electronic-rights-2013--escrow-exchange-and-contract-host--body.md` (155 lines, 10.1 KiB): 4.6x the sibling median (34 lines).
- `library/sources/endo--packages-pass-style-src-symbol-js.md` (155 lines, 6.6 KiB): 4.2x the sibling median (37 lines).
- `library/sources/endo-but-for-bots--llm-designs-daemon-docker-selfhost.md` (155 lines, 6.7 KiB): 4.2x the sibling median (37 lines).
- `library/sections/endo--packages-pass-style-src-error-js--v8-stack-accessor-undeniable-channel-and-repair--body.md` (154 lines, 9.5 KiB): 4.5x the sibling median (34 lines).
- `library/sections/papers--swasey-garg-dreyer-ocpl-2017--hla-language-program-logic-and-robust-safety--body.md` (154 lines, 15.0 KiB): 4.5x the sibling median (34 lines).
- `library/sources/endo--packages-init-source-cluster.md` (154 lines, 7.7 KiB): 4.2x the sibling median (37 lines).
- `library/sources/endo--packages-pass-style-src-safe-promise-js.md` (154 lines, 6.7 KiB): 4.2x the sibling median (37 lines).
- `library/sources/endo--packages-zip-src-cluster.md` (154 lines, 5.9 KiB): 4.2x the sibling median (37 lines).
- `library/sources/endo-but-for-bots--llm-designs-break-dev-dependency-cycles.md` (154 lines, 5.8 KiB): 4.2x the sibling median (37 lines).
- `library/sources/endo-but-for-bots--packages-chat-README-md.md` (154 lines, 8.1 KiB): 4.2x the sibling median (37 lines).
- `library/sources/endo-but-for-bots--packages-genie-DESIGN-md.md` (154 lines, 8.6 KiB): 4.2x the sibling median (37 lines).
- `library/sections/endo--docs-get-started--distributed-programming.md` (153 lines, 5.7 KiB): 4.5x the sibling median (34 lines).
- `library/sections/papers--miller-shapiro-paradigm-regained-2003--object-capability-model-and-redells-caretaker--body.md` (153 lines, 12.2 KiB): 4.5x the sibling median (34 lines).
- `library/sections/web--mdn-customizable-select--styling-the-parts.md` (153 lines, 5.7 KiB): 4.5x the sibling median (34 lines).
- `library/sources/endo-but-for-bots--llm-designs-familiar-app-ui-hosting.md` (153 lines, 6.8 KiB): 4.1x the sibling median (37 lines).
- `library/sources/endo-but-for-bots--packages-daemon-src-networks-setup-ws-relay-js.md` (153 lines, 8.2 KiB): 4.1x the sibling median (37 lines).
- `library/sources/endo-but-for-bots--llm-designs-daemon-message-streaming.md` (152 lines, 6.9 KiB): 4.1x the sibling median (37 lines).
- `library/concepts/passable-equality.md` (151 lines, 11.7 KiB): 4.7x the sibling median (32 lines).
- `library/sections/metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatSupervisor-ts--in-vat-endpoint-and-mirrored-dual-rpc-wiring.md` (151 lines, 10.9 KiB): 4.4x the sibling median (34 lines).
- `library/sources/endo--packages-pass-style-src-deeplyFulfilled-js.md` (151 lines, 6.7 KiB): 4.1x the sibling median (37 lines).
- `library/sources/endo-but-for-bots--llm-designs-daemon-locator-reference.md` (151 lines, 7.0 KiB): 4.1x the sibling median (37 lines).
- `library/concepts/space.md` (150 lines, 13.5 KiB): 4.7x the sibling median (32 lines).
- `library/sources/endo--packages-patterns-src-keys-merge-bag-operators-js.md` (150 lines, 7.4 KiB): 4.1x the sibling median (37 lines).
- `library/sources/endo-but-for-bots--llm-designs-endopi-stdio-rpc-bridge.md` (150 lines, 6.8 KiB): 4.1x the sibling median (37 lines).
- `library/topics/daemon.md` (128 lines, 94.3 KiB): at least 24 KiB.
- `library/topics/datalog-query.md` (128 lines, 41.1 KiB): at least 24 KiB.
- `library/topics/eventual-send.md` (125 lines, 49.3 KiB): at least 24 KiB.
- `library/concepts/module-harmony-intersection-surface.md` (109 lines, 28.4 KiB): at least 24 KiB.
- `library/topics/networking.md` (106 lines, 27.4 KiB): at least 24 KiB.
- `library/topics/forecast-evaluation.md` (101 lines, 32.5 KiB): at least 24 KiB.
- `library/topics/capability-theory.md` (98 lines, 37.5 KiB): at least 24 KiB.
- `library/topics/marshal.md` (98 lines, 38.0 KiB): at least 24 KiB.
- `library/concepts/ocap-kernel.md` (94 lines, 26.6 KiB): at least 24 KiB.
- `library/topics/ocapn.md` (94 lines, 24.2 KiB): at least 24 KiB.
- `library/topics/README.md` (93 lines, 31.6 KiB): at least 24 KiB.
- `library/topics/financial-forecasting.md` (91 lines, 29.6 KiB): at least 24 KiB.
- `library/topics/tooling.md` (91 lines, 34.1 KiB): at least 24 KiB.
- `library/topics/patterns.md` (87 lines, 47.0 KiB): at least 24 KiB.
- `library/topics/chat-ui.md` (85 lines, 48.8 KiB): at least 24 KiB.
- `library/topics/agent-conventions.md` (84 lines, 46.1 KiB): at least 24 KiB.
- `library/topics/pass-style.md` (83 lines, 34.9 KiB): at least 24 KiB.
- `library/topics/persistence.md` (83 lines, 29.9 KiB): at least 24 KiB.
- `library/topics/captp.md` (77 lines, 32.0 KiB): at least 24 KiB.
- `library/topics/repository-governance.md` (74 lines, 24.4 KiB): at least 24 KiB.
- `library/topics/errors.md` (63 lines, 29.4 KiB): at least 24 KiB.

## journal2 projects/

Reachable documents: 47. Reorganization candidates: 22.

### Largest 15 documents

| Path | Lines | Bytes | Class | Level-two sections |
| --- | ---: | ---: | --- | ---: |
| `projects/endo/drafts/resequencing-2026-06.md` | 767 | 47835 | very large | 8 |
| `projects/endo/drafts/frb-reactive-exo-collections.md` | 584 | 34151 | large | 12 |
| `projects/endo/drafts/endopen.md` | 528 | 36945 | large | 9 |
| `projects/endo/drafts/bear-brief-2026-06.md` | 462 | 26921 | large | 5 |
| `projects/endo/drafts/endopi.md` | 455 | 33139 | large | 8 |
| `projects/endo/drafts/construction-time-notifiers.md` | 446 | 20428 | large | 10 |
| `projects/endo/drafts/road-to-maturity-2026-06.md` | 443 | 27128 | large | 5 |
| `projects/endo/drafts/ses-import-attributes.md` | 411 | 18611 | large | 10 |
| `projects/endo/drafts/ses-top-level-await.md` | 391 | 20463 | large | 6 |
| `projects/endo-but-for-bots/xs-from-rust-investigation.md` | 385 | 20868 | large | 7 |
| `projects/endo/ai-sdk-research.md` | 350 | 20504 | large | 12 |
| `projects/endo/drafts/hosts-pitch-2026-06.md` | 323 | 17362 | large | 8 |
| `projects/endo/drafts/exo-import.md` | 317 | 15045 | large | 8 |
| `projects/endo/drafts/endopen-acp-server.md` | 251 | 13104 | medium | 8 |
| `projects/endo/drafts/exo-npm-registry.md` | 247 | 11073 | medium | 7 |

### Reorganization candidates

- `projects/endo/drafts/resequencing-2026-06.md` (767 lines, 46.7 KiB): at least 300 lines; at least 24 KiB; 3.2x the sibling median (241 lines); 8 level-two sections suggest mixed topics.
- `projects/endo/drafts/frb-reactive-exo-collections.md` (584 lines, 33.4 KiB): at least 300 lines; at least 24 KiB; 2.4x the sibling median (241 lines); 12 level-two sections suggest mixed topics.
- `projects/endo/drafts/endopen.md` (528 lines, 36.1 KiB): at least 300 lines; at least 24 KiB; 2.2x the sibling median (241 lines); 9 level-two sections suggest mixed topics.
- `projects/endo/drafts/bear-brief-2026-06.md` (462 lines, 26.3 KiB): at least 300 lines; at least 24 KiB.
- `projects/endo/drafts/endopi.md` (455 lines, 32.4 KiB): at least 300 lines; at least 24 KiB; 8 level-two sections suggest mixed topics.
- `projects/endo/drafts/construction-time-notifiers.md` (446 lines, 19.9 KiB): at least 300 lines; 10 level-two sections suggest mixed topics.
- `projects/endo/drafts/road-to-maturity-2026-06.md` (443 lines, 26.5 KiB): at least 300 lines; at least 24 KiB.
- `projects/endo/drafts/ses-import-attributes.md` (411 lines, 18.2 KiB): at least 300 lines; 10 level-two sections suggest mixed topics.
- `projects/endo/drafts/ses-top-level-await.md` (391 lines, 20.0 KiB): at least 300 lines.
- `projects/endo-but-for-bots/xs-from-rust-investigation.md` (385 lines, 20.4 KiB): at least 300 lines; 3.6x the sibling median (108 lines).
- `projects/endo/ai-sdk-research.md` (350 lines, 20.0 KiB): at least 300 lines; 12 level-two sections suggest mixed topics.
- `projects/endo/drafts/hosts-pitch-2026-06.md` (323 lines, 17.0 KiB): at least 300 lines; 8 level-two sections suggest mixed topics.
- `projects/endo/drafts/exo-import.md` (317 lines, 14.7 KiB): at least 300 lines; 8 level-two sections suggest mixed topics.
- `projects/endo/drafts/endopen-acp-server.md` (251 lines, 12.8 KiB): 8 level-two sections suggest mixed topics.
- `projects/endo/drafts/endopen-concurrent-subagents.md` (241 lines, 11.9 KiB): 8 level-two sections suggest mixed topics.
- `projects/endo/drafts/endopen-tui-shell.md` (236 lines, 13.3 KiB): 8 level-two sections suggest mixed topics.
- `projects/endo/drafts/endopen-openrouter.md` (219 lines, 9.7 KiB): 8 level-two sections suggest mixed topics.
- `projects/endo/drafts/operators-pitch-2026-06.md` (219 lines, 11.9 KiB): 8 level-two sections suggest mixed topics.
- `projects/proposal-compartments/README.md` (216 lines, 13.4 KiB): 11 level-two sections suggest mixed topics.
- `projects/endo/drafts/endopi-skills-markdown-format.md` (172 lines, 6.1 KiB): 8 level-two sections suggest mixed topics.
- `projects/finbot/financial-forecasting-literature-review.md` (152 lines, 25.6 KiB): at least 24 KiB.
- `projects/package-json/property-consumer-matrix.md` (107 lines, 28.7 KiB): at least 24 KiB.

## journal2 root

Reachable documents: 1. Reorganization candidates: 1.

### Largest 1 documents

| Path | Lines | Bytes | Class | Level-two sections |
| --- | ---: | ---: | --- | ---: |
| `README.md` | 6911 | 667751 | very large | 8 |

### Reorganization candidates

- `README.md` (6911 lines, 652.1 KiB): at least 300 lines; at least 24 KiB; 8 level-two sections suggest mixed topics.

## Orphan signal

Unreachable tracked Markdown documents: 36 on main2 and 83 under journal2 `projects/` and `library/`.

### main2 orphans (showing 36 of 36)

- `docs/bulletin/DESIGN.md`
- `scripts/checks/README.md`
- `scripts/checks/bench-engines-rename/README.md`
- `scripts/checks/bench-engines-rename/prompt.md`
- `scripts/checks/claude-md-inventory-drift/README.md`
- `scripts/checks/claude-md-inventory-drift/prompt.md`
- `scripts/checks/double-space-sentence-separator/README.md`
- `scripts/checks/double-space-sentence-separator/prompt.md`
- `scripts/checks/maintainer-inbox-information-hiding/README.md`
- `scripts/checks/maintainer-inbox-information-hiding/prompt.md`
- `scripts/checks/verified-claim-requires-evidence/README.md`
- `scripts/checks/verified-claim-requires-evidence/prompt.md`
- `scripts/daemons/README.md`
- `scripts/jobs/plan/README.md`
- `scripts/jobs/rate-card-defaults.md`
- `scripts/jobs/test/fixtures/cnf/A/jobs/plan/a-build-one.md`
- `scripts/jobs/test/fixtures/cnf/A/jobs/plan/a-build-two.md`
- `scripts/jobs/test/fixtures/cnf/A/jobs/plan/a-design-foo.md`
- `scripts/jobs/test/fixtures/cnf/A/jobs/plan/a-orchestrate-things.md`
- `scripts/jobs/test/fixtures/cnf/B/jobs/plan/b-build-one.md`
- `scripts/jobs/test/fixtures/cnf/B/jobs/plan/b-build-two.md`
- `scripts/jobs/test/fixtures/cnf/B/jobs/plan/b-child-alpha.md`
- `scripts/jobs/test/fixtures/cnf/B/jobs/plan/b-child-beta.md`
- `scripts/jobs/test/fixtures/cnf/B/jobs/plan/b-child-gamma.md`
- `scripts/jobs/test/fixtures/cnf/B/jobs/plan/b-orchestrate-things.md`
- `scripts/jobs/test/fixtures/cnf/C/jobs/orch/c-parent-planning.md`
- `scripts/jobs/test/fixtures/cnf/C/jobs/plan/c-parent-planning.md`
- `scripts/jobs/test/fixtures/cnf/C/jobs/tada/c-kid.md`
- `scripts/systemd/README.md`
- `scripts/watcher/README.md`
- `scripts/watcher/endo-but-for-bots/README.md`
- `skills/agoric-chain-snapshot/repro/README.md`
- `skills/agoric-chain-snapshot/repro/engine-flatmap-ab/README.md`
- `skills/agoric-chain-snapshot/repro/xst-flat-release-ab/README.md`
- `skills/agoric-chain-snapshot/repro/xst-release-ab/README.md`
- `skills/agoric-chain-snapshot/repro/xst-variant-ab/README.md`

### journal2 context orphans (showing 50 of 83)

- `library/sections/endo--packages-harden-make-selector-js--race-to-install-harden-at-Object-at-harden-with-three-tier-lookup-and-pin-on-first-install--the-well-known-slot-object-symbol-for-harden.md`
- `library/sections/endo--packages-marshal-src-marshal-justin--Justin-as-JavaScript-subset-and-dual-indenter-strategies-and-badPairPattern-and-two-pass-recursion-and-Hilbert-Hotel-and-qp-eager-vs-q-lazy--proto-bracket-notation-to-preserve-json-meaning.md`
- `library/sections/endo--packages-zip-src-buffer-reader-js--WeakMap-private-fields-with-bound-get-helper-and-can-assertCan-do-it-triad-and-IE10-historical-ghost-comment-and-findLast-reverse-search--the-eslint-no-bitwise-off-reaffirmed-cycle-290-cycle-292.md`
- `library/sections/endo--packages-zip-src-signature-js--six-named-binary-signature-constants-and-the-PK-historic-magic-prefix-and-the-u-helper-with-charCodeAt-and-byte-masking-and-the-binary-signature-constants-file-shape--the-eslint-no-bitwise-off-dire.md`
- `library/sections/endo--packages-zip-src-signature-js--six-named-binary-signature-constants-and-the-PK-historic-magic-prefix-and-the-u-helper-with-charCodeAt-and-byte-masking-and-the-binary-signature-constants-file-shape--the-eslint-off-shape-vs-eslint.md`
- `library/sections/endo-but-for-bots--llm-designs-endor-tui--canonical-template-instantiation-and-two-co-equal-halves-chat-plus-debugger-and-adopt-XS-protocol-not-invent-and-daemon-mediates-debugger-traffic-and-brea-8d51a061--the-known-gaps-section-uses-ch.md`
- `library/sections/endo-but-for-bots--llm-designs-lal-reply-chain-transcripts--linked-chain-of-transcript-nodes-with-shared-prefix-stored-once-and-two-phase-node-lifecycle-and-honest-design-evolution-visible-in-document--depth-as-text-prefix-depth-n-n.md`
- `library/sources/erights-org--elang-intro.md`
- `projects/endo-but-for-bots/followups/endo-but-for-bots--101.md`
- `projects/endo-but-for-bots/followups/endo-but-for-bots--131.md`
- `projects/endo-but-for-bots/followups/endo-but-for-bots--132.md`
- `projects/endo-but-for-bots/followups/endo-but-for-bots--133.md`
- `projects/endo-but-for-bots/followups/endo-but-for-bots--242.md`
- `projects/endo-but-for-bots/followups/endo-but-for-bots--284.md`
- `projects/endo-but-for-bots/followups/endo-but-for-bots--290.md`
- `projects/endo-but-for-bots/followups/endo-but-for-bots--301.md`
- `projects/endo-but-for-bots/followups/endo-but-for-bots--303.md`
- `projects/endo-but-for-bots/followups/endo-but-for-bots--305.md`
- `projects/endo-but-for-bots/followups/endo-but-for-bots--306.md`
- `projects/endo-but-for-bots/followups/endo-but-for-bots--311.md`
- `projects/endo-but-for-bots/followups/endo-but-for-bots--313.md`
- `projects/endo-but-for-bots/followups/endo-but-for-bots--317.md`
- `projects/endo-but-for-bots/followups/endo-but-for-bots--318.md`
- `projects/endo-but-for-bots/followups/endo-but-for-bots--319.md`
- `projects/endo-but-for-bots/followups/endo-but-for-bots--320.md`
- `projects/endo-but-for-bots/followups/endo-but-for-bots--321.md`
- `projects/endo-but-for-bots/followups/endo-but-for-bots--322.md`
- `projects/endo-but-for-bots/followups/endo-but-for-bots--323.md`
- `projects/endo-but-for-bots/followups/endo-but-for-bots--324.md`
- `projects/endo-but-for-bots/followups/endo-but-for-bots--332.md`
- `projects/endo-but-for-bots/followups/endo-but-for-bots--334.md`
- `projects/endo-but-for-bots/followups/endo-but-for-bots--335.md`
- `projects/endo-but-for-bots/followups/endo-but-for-bots--336.md`
- `projects/endo-but-for-bots/followups/endo-but-for-bots--344.md`
- `projects/endo-but-for-bots/followups/endo-but-for-bots--345.md`
- `projects/endo-but-for-bots/followups/endo-but-for-bots--346.md`
- `projects/endo-but-for-bots/followups/endo-but-for-bots--347.md`
- `projects/endo-but-for-bots/followups/endo-but-for-bots--348.md`
- `projects/endo-but-for-bots/followups/endo-but-for-bots--351.md`
- `projects/endo-but-for-bots/followups/endo-but-for-bots--353.md`
- `projects/endo-but-for-bots/followups/endo-but-for-bots--355.md`
- `projects/endo-but-for-bots/followups/endo-but-for-bots--356.md`
- `projects/endo-but-for-bots/followups/endo-but-for-bots--358.md`
- `projects/endo-but-for-bots/followups/endo-but-for-bots--359.md`
- `projects/endo-but-for-bots/followups/endo-but-for-bots--360.md`
- `projects/endo-but-for-bots/followups/endo-but-for-bots--361.md`
- `projects/endo-but-for-bots/followups/endo-but-for-bots--403.md`
- `projects/endo-but-for-bots/followups/endo-but-for-bots--417.md`
- `projects/endo-but-for-bots/followups/endo-but-for-bots--435.md`
- `projects/endo-but-for-bots/followups/endo-but-for-bots--438.md`

## Summary

Walked 8300 reachable documents and flagged 355 reorganization candidates.

Consider running this report periodically through the garden scheduling mechanism if trend data would be useful.
