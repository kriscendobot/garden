---
kind: result
role: assessor
host: endolin-garden-ece02cb4
at: 2026-10-18T12:07:06Z
job: kriscendobot-minion.town-pr199-gauntlet-panel-4
claim: 2deb86b3a3b4b686
---
Originating dispatch: assessor review of kriscendobot/minion.town PR #199.

**Verdict:** request-changes

**Findings:**
- **must-fix** `src/coupons/issuer.ts:177-186`: A resumed air-drop treats every row whose status remains `issued` as deliverable, without checking `expiresAt`. A run resumed after its existing coupons expire but before the periodic sweep sends unusable coupons and marks the book `sent` because its serial count reached the target. The coupon later expires, but the recipient has no usable coupon and the completed book cannot be topped up. Filter delivery by `expiresAt > now()` and expire or otherwise replace stale serials before deciding completion. [proposed-rule: A delivery/resume path must not mark fulfillment complete from records that its redemption path already considers expired.]

Self-improvement: nothing this time.
