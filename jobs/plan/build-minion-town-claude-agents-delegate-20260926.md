---
gate: blocked
blocked_on: https://github.com/kriscendobot/minion.town/pull/97
priority: normal
role: builder
posted_by: gardener
posted_at: 2026-09-26T05:14:45Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Build: close the implementation gaps between minion.town's Claude-agents wiring and the root-endowment design

Repo: kriscendobot/minion.town (branch off `main`). Mandate: kriskowal's APPROVAL
review https://github.com/kriscendobot/minion.town/pull/97#pullrequestreview-5324695340
— "Conduct and dispatch a builder to close implementation gaps." This job is
blocked on PR #97 merging, so `designs/claude-agents-capability.md` on `main` is the
reconciled root-endowment design when you start.

Task: diff the design (as landed by #97) against the shipped wiring
(#87 / #79 / #98 merged, all behind the Claude-enabled flag, fail-closed pending
endojs/endo-but-for-bots#1015) and implement the gaps. The PR #97 body names the
principal one:

- **`delegate()`**: a root-only surface that mints an *attenuated* sub-factory —
  own sub-namespace, shared credential/quota with optional `maxChildren` cap,
  status-only account facet, no re-delegation, `cancelled`-revocable — and route
  the root→guest hand-off (mail-attach + `adopt`) through it, replacing the current
  unattenuated full-factory hand-off (a privilege escalation: a peer could
  `dismiss` the root's children or `disconnect` the shared subscription).
  `delegate()` joins the same tagged-result never-reject family.
- **Root identity** via deploy config (`ENDO_CLAUDE_ROOT_SUBJECTS` →
  `config.rootSubjects`), fail-closed empty — verify it matches the design; fix if not.
- Any other design/build divergence you find (e.g. the design's § Reconciliation
  with the open build, § Meeting arc item 2 inbox-watching driver if in scope,
  acceptance evidence for root-only and delegation-attenuation checks as tests).

Stay flag-gated and fail-closed; do not enable the live path, and do not attempt
the Endo-substrate (#1015) or canary/deploy steps. Record in the PR body which
design sections each change closes and any gap deliberately left open (with
reason). Deliver as a DRAFT PR on the fork; stop at draft (manual-gauntlet regime).
