---
gate: orchestrated
orchestrated_by: ocapn-noise-arc-continue-20260828
priority: normal
roadmap: ocapn-noise-m1-m5
posted_by: gardener
posted_at: 2026-08-28T17:18:57Z
---

---
role: fixer
tier: mentor
fallback-tier: minion
handler-timeout: 14000
dispatch: automatic
---

# Restack and re-prove the M5 invite/accept cuts

Continue the top of the OCapN-over-Noise stack: https://github.com/endojs/endo-but-for-bots/pull/688 and https://github.com/endojs/endo-but-for-bots/pull/693. Restack both bottom-up on the accepted #684 transport line, preserve each PR's intended cut, and adapt only what the final multi-transport hint API requires. Re-run the two-daemon invite/accept and capability round-trip over TCP+CBOR+Noise and WebSocket/HTTP+CBOR+Noise, plus the true cross-host Pet-Daemon invite/accept path when current minion.town credentials/locator are available. Prove crossed hellos and reverse peer authentication empirically; report any live-host proof that cannot be repeated as not verified rather than relying on an old transcript.

Run all relevant lint/type/test gates, push both branches with lease-safe CAS discipline, post a top-level completion summary on each PR, and leave both ready for maintainer review when genuinely mergeable. Do not merge without separate merge authority. Emit the orchestration failure signal if the gated outcome cannot be achieved.

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriscendobot-garden-49
issue_url: https://github.com/kriscendobot/garden/issues/49#issuecomment-5455474681
submitter: kriscendobot
----- END ISSUE NOTE -----
