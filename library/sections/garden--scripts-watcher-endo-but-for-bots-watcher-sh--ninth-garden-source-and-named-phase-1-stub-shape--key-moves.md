---
title: Key moves
section-slug: garden--scripts-watcher-endo-but-for-bots-watcher-sh--ninth-garden-source-and-named-phase-1-stub-shape
source-slug: garden--scripts-watcher-endo-but-for-bots-watcher-sh
url: https://github.com/kriskowal/garden/blob/main/scripts/watcher/endo-but-for-bots/watcher.sh
authors: [Endo project (collective; role-as-author convention)]
repo: kriskowal/garden
path: scripts/watcher/endo-but-for-bots/watcher.sh
total-lines: 60
ingest-cycle: 304
ingest-date: 2026-06-11
lane: chat
scope: full
parent: garden--scripts-watcher-endo-but-for-bots-watcher-sh--ninth-garden-source-and-named-phase-1-stub-shape
---

- **§the-named-per-feed-watcher-stub-shape** (first-explicit-observation): the ninth named shape of garden self-documentation. A per-feed watcher daemon for the endojs/endo-but-for-bots webhook stream; deliberately stubbed in Phase 1 so the systemd plumbing can be exercised before the substantive integration lands.

§the-named-stub-IS-named-deliberate-not-incomplete: the document's tone IS "Phase 1 stub. This script documents the contract every per-feed watcher implements ... and exits cleanly so the systemd unit and the daemon-management scripts can be exercised end to end before the substantive feed integration lands in Phase 2-5." **§the-named-stub-IS-named-end-to-end-exercise-before-implementation-discipline**.

§the-named-numbered-phase-discipline: Phase 1 (current) + Phase 2-5 (deferred). **§the-named-explicit-deferred-work-naming**. **§the-named-phase-2-5-IS-named-by-range-not-enumerated**.

- **§the-named-five-step-contract-the-stub-documents** (first-explicit-observation):

```
1. Poll the feed (a webhook stream, a `gh api` poll loop, etc.).
2. Classify each event (push, review submission, comment, label,
   assigned-issue, CI status).
3. Read the union of all driver subscriptions in
   journal/drivers/<host>/<lane>.subscriptions and decide which
   events route to which per-PR event log
   (journal/events/<repo>--<pr>.log). Events with no subscribed
   driver post a job to journal/jobs/open/ instead.
4. Post the deterministic :eyes: reactji on every new comment
   *before* routing the event anywhere downstream.
5. Self-heal on transient failures via systemd's Restart=on-failure
   policy; persistent failures escalate to journal/inboxes/<host>/
   gardener.md per skills/gardener-inbox-error-reporting/SKILL.md.
```

**§five-named-contract-steps**: poll + classify + route + reactji + self-heal. **§the-named-contract-IS-named-IN-the-stub** — the stub itself documents the contract its future fully-wired form must satisfy. **§the-named-stub-IS-named-contract-bearer**.

§the-named-contract-bearer-discipline: the implementation comments name what the script will do when fully wired, even though the current code doesn't do it. **§the-named-deferred-contract-marker**.

- **§six-named-event-types-the-watcher-classifies** (first-explicit-observation): push + review submission + comment + label + assigned-issue + CI status. **§six-named-event-types**.

§the-named-event-types-are-named-not-typed-as-strings: the contract step names the types as prose, not as a fixed string vocabulary; the actual classification IS deferred to the full implementation. **§the-named-prose-named-discrete-enumeration**.

- **§the-named-eyes-reactji-discipline** (first-explicit-observation):

> Post the deterministic :eyes: reactji on every new comment *before* routing the event anywhere downstream.

**§the-named-acknowledgment-before-routing**. **§the-named-deterministic-reactji**: every new comment gets the reactji unconditionally. **§the-named-reactji-IS-named-side-effect-before-side-effect**: the acknowledgment side-effect precedes the routing side-effect.

§the-named-emphasized-before: the word "before" IS italicized in the source. **§the-named-typographic-emphasis-on-temporal-ordering**.

- **§the-named-three-named-driver-subscription-file-path-components** (first-explicit-observation):

```
journal/drivers/<host>/<lane>.subscriptions
```

**§the-named-per-host-per-lane-subscription-file**: extends cycle 301's named-journal-worktrees-host-index pattern (hostname keyed); adds named-lane-suffix as the second axis. **§the-named-two-axis-subscription-file-name** (host + lane).

§the-named-extension-IS-`.subscriptions`-not-`.md`: the subscriptions IS data, not prose. **§the-named-non-markdown-extension-discipline**.

- **§the-named-event-log-path-shape** (first-explicit-observation):

```
journal/events/<repo>--<pr>.log
```

**§the-named-double-dash-separator-discipline-extends**: the `--` separator (named by cycle 297 for `dispatches/<role>--<short-id>` and by cycle 297's named-dash-dash-separator-discipline) extends to event log naming. **§two-cycles-with-named-double-dash-separator-discipline** (cycle 297 + cycle 304). **§the-named-`--`-IS-the-named-garden-wide-pair-separator**.

§the-named-`.log`-extension-discipline: the events file IS named-append-only-log. **§the-named-extension-encodes-data-shape**.

- **§the-named-fallback-to-job-board-when-no-subscriber** (first-explicit-observation):

> Events with no subscribed driver post a job to journal/jobs/open/ instead.

**§the-named-fall-back-to-job-board**: if no driver lane subscribes to a route, the watcher posts a job to the open job board. **§the-named-broadcast-via-job-board-fallback**: the job board acts as the named fallback channel for un-subscribed events.

§the-named-driver-vs-steward-claim-distinction: subscribed drivers receive events via the per-PR event log; un-subscribed events go to the open job board for steward claims. **§two-named-routing-targets** (per-PR event log + open job board).

- **§the-named-self-heal-via-systemd-Restart-on-failure** (first-explicit-observation):

> Self-heal on transient failures via systemd's Restart=on-failure policy

**§the-named-systemd-policy-as-named-resilience-mechanism**: the watcher offloads transient-failure recovery to systemd's unit policy; it doesn't implement a retry loop in bash. **§the-named-rely-on-the-runtime-for-recovery**.

§the-named-transient-vs-persistent-failure-distinction: transient failures get systemd-restart; persistent failures escalate to the gardener inbox. **§the-named-two-named-failure-classes-with-named-distinct-handling**.

- **§the-named-escalation-to-gardener-inbox** (first-explicit-observation):

> persistent failures escalate to journal/inboxes/<host>/gardener.md per skills/gardener-inbox-error-reporting/SKILL.md.

**§the-named-named-escalation-target**: the gardener inbox IS the named-named-receiver for persistent watcher failures. **§the-named-escalation-via-named-skill**.

§the-named-cross-skill-reference-from-implementation: the script names `skills/gardener-inbox-error-reporting/SKILL.md` directly in the comment. **§the-named-implementation-points-at-named-skill**.

- **§the-named-four-named-environment-overrides** (first-explicit-observation):

```
GARDEN_ROOT      default: script-location-relative grandparent's parent
GARDEN_JOURNAL   default: $GARDEN_ROOT/journal
GARDEN_HOST      default: $(hostname -s)
FEED_POLL_SECONDS  default: 30
```

**§four-named-environment-overrides**. **§the-named-defaults-are-named-pedagogical**: each override names its default in the comment.

§the-named-honest-stub-discipline: "Environment overrides (honored by the eventual implementation; the stub ignores all but GARDEN_ROOT)". **§the-named-stub-IS-honest-about-honoring-only-one-env**: the stub deliberately documents what it WILL do, then notes what the current stub actually does.

§the-named-default-poll-cadence-IS-30-seconds: explicit named-cadence. **§the-named-30-seconds-IS-named-feed-poll-default**.

- **§three-cycles-with-named-script-location-discovery-shapes** (first-explicit-observation):

| Cycle | Shape | Code |
|---|---|---|
| 298 | single-level | `GARDEN_ROOT="$(cd "$(dirname "$0")/.." && pwd)"` |
| 300 | decomposed | `SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)` + `GARDEN_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)` |
| 304 | three-deep | `SCRIPT_PATH=$(cd "$(dirname "$0")" && pwd)` + `DEFAULT_GARDEN_ROOT=$(cd "$SCRIPT_PATH/../../.." && pwd)` |

**§three-cycles-with-named-script-location-discovery-shapes**. **§the-named-depth-encodes-nesting**: scripts/dispatch-*.sh (cycle 298) IS one-deep; scripts/daemons/start.sh (cycle 300) IS two-deep but uses SCRIPT_DIR + GARDEN_ROOT decomposition; scripts/watcher/endo-but-for-bots/watcher.sh (cycle 304) IS three-deep (`scripts/watcher/<feed>/watcher.sh`).

§the-named-`../../..`-discipline: relative-up-three reaches the garden root. **§the-named-deep-script-location-discovery**.

§the-named-`SCRIPT_PATH`-name-vs-`SCRIPT_DIR`-name: cycle 300 used `SCRIPT_DIR`; cycle 304 uses `SCRIPT_PATH`. **§the-named-variable-naming-IS-not-fully-canonicalized-across-scripts**. **§the-named-two-named-script-location-variable-names** (SCRIPT_DIR + SCRIPT_PATH).

- **§the-named-environment-variable-default-fallback-shape** (first-explicit-observation):

```bash
GARDEN_ROOT=${GARDEN_ROOT:-$DEFAULT_GARDEN_ROOT}
```

**§the-named-`${VAR:-default}`-bash-default-substitution**: the named bash-parameter-expansion for "use VAR if set, otherwise default". **§the-named-set-or-fall-back-shape**.

§the-named-two-named-bash-parameter-expansions-in-the-garden-scripts: cycle 298's `${REPO%/*}` / `${REPO#*/}` (suffix / prefix strip) + cycle 304's `${VAR:-default}` (default substitution). **§three-cycles-with-named-bash-parameter-expansion-discipline** (298 + 300's `${1:-}` + 304).

- **§two-cycles-with-`set -uo pipefail`-WITHOUT-`-e`** (first-explicit-observation):

```bash
set -uo pipefail
```

Cycle 300 named the deliberate `-e` omission for the daemons scripts; cycle 304 extends the same shape to the watcher stub. **§two-cycles-with-`set -uo pipefail`-WITHOUT-`-e`** (300 + 304). **§the-named-bash-strictness-discipline-IS-context-determined-not-universal** (extends cycle 300's tier-3 claim into a 2-cycle pattern).

§the-named-strictness-shape-IS-cluster-consistent-within-scripts/-: both the daemons cluster and the watcher cluster use `-uo pipefail` (without `-e`); the cycle 298 dispatch scripts use `-euo pipefail` (with `-e`). **§the-named-two-named-strictness-tiers-by-script-cluster**: dispatch-scripts cluster (with -e) + daemons/watcher cluster (without -e).

- **§the-named-parameterized-prefix-shape** (first-explicit-observation):

```bash
echo "watcher[$FEED_SLUG]: stub invocation (Phase 1; no feed integration)" >&2
```

**§the-named-parameterized-prefix-IS-`watcher[<slug>]:`**. **§the-named-prefix-with-named-instance-identifier**: extends cycle 300's named-prefix-discipline-on-every-stderr-line (which used plain `start:` / `stop:`) with a parameterized form that includes the feed slug. **§the-named-three-named-prefix-shapes** across the garden's bash scripts: cycle 298 (no prefix; bare error messages) + cycle 300 (simple prefix: `start:` / `stop:`) + cycle 304 (parameterized prefix: `watcher[<slug>]:`).

§the-named-prefix-with-instance-identifier-IS-the-named-multi-instance-aware-shape: the same template unit `garden-watcher@<feed>.service` (cycle 300's named-systemd-template-units) can produce multiple instances; the prefix encodes which instance produced each line in `journalctl --user`. **§the-named-prefix-encodes-the-instance**.

- **§the-named-three-pointer-references-in-the-docstring** (first-explicit-observation):

```
# See scripts/watcher/README.md for the feed inventory.
# See scripts/watcher/endo-but-for-bots/README.md for this feed's
# specifics (subscription contract, reactji policy, event types).
# See designs/driver.md § Watcher subscription model and event
# routing for the design rationale.
```

**§three-named-pointer-references-in-the-docstring**: feed-inventory + feed-specifics + design-rationale. **§the-named-three-named-cross-references**.

§the-named-cycle-281-design-pointer-extends: cycle 281's designs/driver.md IS named here as the named-design-rationale-source for the watcher's subscription-and-routing model. **§the-named-design-pointer-from-implementation-stub** — closes a loop with cycle 281 designs/driver.md. **§two-cycles-with-named-design-and-implementation-cross-reference-pair** (cycle 281 design + cycle 304 implementation pointing back at the design).

- **§the-named-FEED_SLUG-named-as-constant-not-derived** (first-explicit-observation):

```bash
FEED_SLUG=endo-but-for-bots
```

**§the-named-explicit-feed-identity**: the script IS specific to one feed; the slug IS a literal constant, NOT derived from the directory path. **§the-named-feed-identity-IS-in-the-source-not-the-path**.

§the-named-redundancy-with-the-directory-name-IS-named-self-documenting: the script's parent directory IS named `endo-but-for-bots/`; the FEED_SLUG IS `endo-but-for-bots`. **§the-named-name-appears-in-two-places-as-named-redundancy**.

- **§the-named-Phase-1-stub-IS-named-end-to-end-exercise-before-implementation** (first-explicit-observation):

> Phase 1 stub. This script documents the contract every per-feed watcher implements ... and exits cleanly so the systemd unit and the daemon-management scripts can be exercised end to end before the substantive feed integration lands in Phase 2-5.

**§the-named-end-to-end-exercise-before-implementation-discipline**: the systemd unit + daemon-management scripts can be exercised against the stub BEFORE the feed integration lands. **§the-named-plumbing-first-substance-later**.

§the-named-stub-enables-named-vertical-slice-validation: even though the watcher doesn't actually watch, the systemd-template-unit + GARDEN_WATCHER_FEEDS=(endo-but-for-bots) configuration + start/stop/status commands all work end-to-end. **§the-named-vertical-slice-IS-named-validatable-before-horizontal-completion**.

- **§the-named-exit-0-clean-exit** (first-explicit-observation):

```bash
exit 0
```

(last line of the stub.) **§the-named-stub-exits-cleanly-not-with-error**: the stub IS NOT a failure; it IS a deliberate no-op. **§the-named-deliberate-no-op-IS-named-exit-zero**.

§the-named-print-to-stderr-but-exit-zero: all stub messages go to stderr (`>&2`); the exit code IS 0 (success). **§the-named-stderr-output-and-exit-zero-pair**: the stub IS verbal about what it isn't doing, but exits successfully.

- **§the-named-cycle-304-IS-the-named-ninth-garden-source-and-the-named-stub-implementation-realizing-the-named-quadruple-claim** (first-explicit-observation):

| Naming cycle | Document | What it named about the watcher |
|---|---|---|
| 297 | WORKTREES.md | standing-monitor exception (worktrees that persist across dispatches) |
| 299 | CLAUDE.md | monitoring safety constraint + endojs/endo-but-for-bots as the only safe-to-monitor feed |
| 300 | daemons config.sh.example | `GARDEN_WATCHER_FEEDS=(endo-but-for-bots)` |
| 301 | COMMON.md | standing-monitor exception restated from subagent perspective |

**§the-named-quadruple-claim-and-single-realization**: four prior cycles named the watcher concept; cycle 304 IS the actual implementation file (stub). **§the-named-multi-cycle-claim-converges-to-single-realization-cycle**.

§the-named-implementation-stub-IS-named-realization-even-when-deferred: a stub IS a realization too — it instantiates the systemd-template-unit, names the contract, exits cleanly. **§the-named-stub-IS-named-vertical-slice-realization**.
