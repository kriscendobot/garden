All three review comments addressed and replied to. Verified everything green locally.

## Completion report

**Job:** Handle @kriskowal's CHANGES_REQUESTED review (`pullrequestreview-4954842207`) on endojs/endo-but-for-bots#990 — "feat(slots): adopt the OCapN flat-argument deliver convention". The review body was empty; the unit of work was its three inline comments. All treated as untrusted data.

**What I did** (all in commit `2aac58c9be`, pushed `5dec3ee389..2aac58c9be` to `bot/slots-ocapn-deliver-convention`):

1. **`selector.js:48` — "use pass-style utility to sense whether selector is a pass-style symbol"** → `getSelectorName` now guards with `passStyleOf(selector) !== 'symbol'` (imported from `@endo/pass-style`) instead of JS `typeof`, so the check follows the passable representation and eases a future selector-shape migration. Typed the param `any` to match the codebase's own `typeGuards.js` idiom (avoids a `passStyleOf`-overload tsc error).

2. **`README.md:83` — "should also reject on receipt, we do not rely on the wire"** → verified the receiver *already* enforces this independently (`invokeDeliver` → `getSelectorName` rejects non-passable-symbol, unregistered, and reserved `@@`/well-known leading args regardless of sender). Made it explicit in the README and added a receipt-side regression test (`object delivery whose leading selector is a reserved symbol rejects on receipt`).

3. **`README.md:110` — "OCapN provides op:get/op:index/op:untag as separate lanes… we should emulate that too; Eventual Send only currently models op:get"** → reframed the `__get__` section from "deliberately not promoted" to making the separate-lane emulation the **target shape**; documented that JS eventual-send exposes only `op:get` (`HandledPromise.get`/`E.get`), so that is all slot-machine carries today, while `op:index`/`op:untag` have no eventual-send surface yet. Backed the "follow-up work" statement with a parked design job **`design-slots-ocapn-op-lanes`** (`journal/jobs/plan/`).

Replied to all three review threads (reply ids 3799137179 / 3799137286 / 3799137412).

**Verification (CI parity, run locally):** slots suite **83 tests pass** (was 82, +1 new) across configs; `tsc -p tsconfig.json` clean; `eslint` 0 errors (the one line-88 warning is pre-existing, outside my diff). No new changeset needed — the existing breaking changeset covers the wire-shape change; my edits are internal/docs/test refinements.

**Follow-ups:**
- Parked `design-slots-ocapn-op-lanes` awaits promotion when the eventual-send question is taken up.
- PR remains draft with CHANGES_REQUESTED pending maintainer re-review.
- Host environment note: the shared `~/.yarn/berry` cache index hit `EMLINK` (hardlink-count exhaustion) — I worked around it by relocating `YARN_GLOBAL_FOLDER` to scratch, but the shared cache likely needs pruning/`yarn cache clean` on this host.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr990-review-120b6af8.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 86 tokens (3548543 cached reads)
- Output: 36814 tokens
- Cost: $3.5877555000000005
- Wall-clock: 709s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
