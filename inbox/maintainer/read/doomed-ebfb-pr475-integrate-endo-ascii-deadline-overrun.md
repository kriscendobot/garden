from_host: endolin-garden2-5bcdff64
from: reaper:endolin-garden2-5bcdff64
sent_at: 2026-08-13T21:13:07Z
doom_base: ebfb-pr475-integrate-endo-ascii
doom_signature: deadline-overrun
notice_count: 1
first_seen: 2026-08-13T21:13:07Z
last_seen: 2026-08-13T21:13:07Z
---
DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 early-escalation cycle(s) on endolin-garden2-5bcdff64.
The gardener stamped the deadline-overrun counter, so the reaper surfaced it after 1
cycle(s) rather than the full 5-cycle doom threshold. The effective handler budget in
force for this job is 2400s. That counter is stamped for two DISTINCT shapes; check the
gardener log for the actual elapsed to tell which applies:
  (a) GENUINE wall-clock overrun — elapsed ≈ 2400s (rc=124 at the wall). The job does not
      fit one claim: SPLIT it into claim-sized stages, or raise its handler-timeout.
  (b) FAST repeated failure — elapsed far below 2400s (e.g. a 1–2s usage-cap/API rejection)
      flagged by elapsed-constancy. The budget is NOT the problem; read the handler log
      for the real cause (quota/usage cut, swallowed error) — raising the budget will not help.
The work is preserved at jobs/plan/ebfb-pr475-integrate-endo-ascii; it stays HELD until a human promotes it
(promote-plan.sh ebfb-pr475-integrate-endo-ascii) or removes it.
Original job base: ebfb-pr475-integrate-endo-ascii

--- original job body ---
---
role: fixer
---
<!-- garden-promoted-from-plan: gate=blocked priority=high at=2026-08-13T20:26:14Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: endojs/endo-but-for-bots
Pull request: https://github.com/endojs/endo-but-for-bots/pull/475
Canonical package: https://github.com/endojs/endo-but-for-bots/pull/943

After the canonical encode-only @endo/ascii lands on llm, reconstruct or rebase pull request 475 onto a frozen llm snapshot that contains it. Remove pull request 475 own duplicate packages/ascii package and its package, composite-tsconfig, changeset, and yarn.lock ownership. Preserve the byteArray-narrowing change. In packages/ocapn/src/client/util.js, use canonical encodeAscii for ASCII string-to-bytes conversion before the existing immutable/frozen byte wrapping. Do not add decodeAscii to the canonical package: reconcile pull request 475 decoder-side edits against current llm and the bytes-preserving SturdyRef direction, preserving non-ASCII byte semantics. Update dependencies, changesets, lockfile, and focused tests, including rejection at U+0080. Push the pull request head branch and post the required completion summary.

<!-- garden-deadline-overrun: 1 -->
