---
role: shepherd
handler-timeout: 7200
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-25T05:19:11Z -->

---
handler-timeout: 7200
---

Shepherd endojs/endo-but-for-bots PR #852 in response to the maintainer directive at https://github.com/endojs/endo-but-for-bots/pull/852#issuecomment-5077090769. Diagnose and drive all CI checks for the current PR head to green, applying permitted in-scope repairs if needed. If an impasse remains, report an explicit `next: <role>` classification. The directive also authorizes the subsequent conduct stage; do not merge in this stage.

<!-- garden-reaped: 2 -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: hermit
  claimed_at: 2026-07-25T06:13:13Z
