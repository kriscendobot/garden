---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Fix merge-governance must-fix findings for finbot PR #6

PR: https://github.com/kriscendobot/finbot/pull/6
Blocked head: b663b4f6d68da777be49182e2633f324ba149eaa

The required Fable orchestrator sign-off is withheld. The recorded panel run 4fb530557978 has 28 formal seat blocks but is internally inconsistent: it marks disposition passed while retaining 15 must-fix findings. Do not merge or un-draft.

Primary must-fix, independently confirmed by the sign-off review: the armed forecast-data-sufficiency gate accepts an internally consistent dataSufficiency descriptor supplied by the caller without binding it to the cited, attested forecast artifact. This reaches both audit_proposal and executor fire-time audit, so a forged descriptor can make a thin forecast appear covered. Bind the descriptor to a canonical forecast artifact/provenance before it can satisfy the gate, fail closed when that attestation is absent or inconsistent, and add an executor integration regression proving no steps complete under a forged descriptor.

Also address the documented audit_proposal config-shape error and the CLI help visibility finding if they remain applicable after the binding design. Keep default behavior byte-identical where the gate is off. Run npm test before pushing. Then leave the PR draft and post a fresh full panel job on the new head; only a passing panel with no unresolved must-fix findings may receive a replacement Fable sign-off.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 4
  worker_kind: fireworker
  tier: 
  provider: fireworks
  model: 
  claimed_at: 2026-07-31T00:34:31Z
