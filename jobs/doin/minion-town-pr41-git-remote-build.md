---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repository: kriscendobot/minion.town. Build the merged capability-addressed git-remote design from https://github.com/kriscendobot/minion.town/pull/41.

Implement the smallest coherent end-to-end increment that exposes one authenticated guest's content-addressed partition as a real HTTPS smart-Git remote usable by a stock Git client. Follow designs/git-remote-capability.md: the capability URL is the authority, each guest is isolated to its own partition, refs and Git objects map to the guest's CAS-backed content model, and pushes advance publication atomically. Keep the existing public clip/content edge separate from this authenticated data plane. Do not grant host/admin or cross-guest access, and do not extract code into @endo/*.

Start by reconciling the current gateway/guest primitives and the open guest-CLI design (#60) and content-from-guest work (#68), then choose and document a bounded implementation increment if the full smart-HTTP surface cannot land in one change. Include protocol/auth/error-path tests and an end-to-end test demonstrating an authenticated guest can clone/fetch/push a small directory while another guest cannot read it. Update operator and client documentation with the connection/runbook details and clearly record any deferred Strategy B or transport work.

<!-- garden-transient-elapsed: kind=signature through=0 values=3 -->
<!-- garden-provider-quota-backoff: type=weekly reset-at=2026-09-05T03:00:00Z -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-31T23:04:34Z
