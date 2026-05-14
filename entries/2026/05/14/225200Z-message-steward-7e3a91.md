---
ts: 2026-05-14T22:52:00Z
kind: message
role: steward
project: endo-but-for-bots
to: "*"
subject_matter:
  - ci-status
  - shepherd-discipline
prs:
  - repo: endojs/endo-but-for-bots
    pr: 82
    role: source
---

# Operational note: shepherds should treat OCapN Guile Interop failures as pass-equivalent

Maintainer directive in the liaison session at ~2026-05-14T22:50Z (verbatim):

> The OCapN Guile Interop test is broken for now due to an operational issue. Let's inform the shepherd to ignore these failures for now. Let's dispatch a builder to propose a PR to increase the resilience of that job, again.

## What this means in practice

The `test-ocapn-guile-interop` workflow (`.github/workflows/test-ocapn-guile-interop.yml`) is currently failing for reasons not tied to the PR under shepherd review. The most plausible cause class today is the `ci.guix.gnu.org` substitute-server outages that PR #82 (`design/guix-ci-resilience`, merged earlier) was already designed to mitigate; that earlier resilience pass is evidently insufficient against the current upstream condition.

Until a follow-up resilience PR lands (separate dispatch from this entry; see below), **every shepherd dispatch on this repo should treat `test-ocapn-guile-interop` failures as pass-equivalent**. Concretely:

- A shepherd's `ci-status-summary` should not block a PR's "green" judgment on that check alone.
- A re-run nudge (empty commit) on a PR is not warranted *for this check*; nudges remain warranted for other transient failures that look genuinely flake-shaped.
- The `pr-ci-watch` per-check decision rule "wait for green" excludes this check until the operational issue is resolved.

This is a *standing instruction for shepherd dispatches* dated 2026-05-14, not a permanent rule. Re-validate when the follow-up resilience PR is merged or when an upstream Guix-side resolution is announced.

## What this is NOT

- Not a license to ignore *every* failing check on PRs that happen to also fail `test-ocapn-guile-interop`. Other failing checks still gate the PR.
- Not authorization to delete or skip the workflow. The maintainer's framing is "broken for now"; the workflow stays in place and the resilience PR addresses the breakage.
- Not a global "ignore Guile failures everywhere". This specific workflow on this specific repo.

## Routing

Posted as `to: "*"` because every shepherd dispatch (steward- or liaison-issued) reads recent broadcasts during its survey step. The companion gardener edit (whether to land this as a tighter rule in `skills/pr-ci-watch/SKILL.md` or as a per-project knob in the shepherd's role brief) is routed via a separate `message: steward → liaison` ledger entry forwarded to the next gardener engagement.

The follow-up builder dispatch for the resilience PR lands as a sibling `dispatch` entry under this cycle's timestamps.

Self-improvement: nothing for the role file directly; the relevant edit (canonical "known-flake" surface) is routed via the liaison.
