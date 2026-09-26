Inbox empty. Job complete.

---

**Completion report — containment drift check for kriscendobot/minion.town gateway records**

Scanned the live vhost store `/var/lib/endo-gateway/store/vhosts/` **recursively** (via SSM Run Command on `i-0380cd68b90020fad`), 49 active records, whitespace-tolerant matching.

**Core property — CLEAN:** All three de-registered records remain ABSENT from the live active store — `f1d754fc…`, `fe0a8e60…`, and `09201a316203e9d99e3c906b12c9466d8f0ae8dc8baf8db484c918d6698f657f` (none present as filename or content). No `@agent`/EndoHost-escape powers record is active. Did **not** assert or re-arm the containment drop-in (powers plane is authorized-open under kriscendobot/minion.town#58, per the retune).

**Store-wide, only 4 records carry a `powers` field:** `powers-fixture` (known-safe), `formula:live-deploy-verification` (unresolvable), and two dckc-owned (`8929a9ae…`) powers weblets — `806fc2ea…` `powers:"counter"` and `c016601e…` `powers:"@none"`. Both resolve to attenuated/powerless caps (not `@agent`), and both return HTTP 404 on the public bootstrap and root (426 on `/.well-known/endo-captp`). dckc owns 20 active records total (18 content-only + those 2).

**Reported to maintainer inbox** (`inbox/maintainer` `20260904T043754Z-6ae1cc`): the three named records confirmed absent, plus an informational flag on the two dckc powers weblets — they share the "powers value + 404 bootstrap" signature of the 08-31 de-registered record, so surfaced per the retune's "report any unexpected active dckc-owned record." Did **not** de-register them: they are new records (not the named ones reappearing), and de-registering authorized #58 experiments under the deliberately-open powers plane could be wrong — left as a maintainer decision.

**Changed:** nothing in the garden repo (verification job). Updated persistent memory `minion-town-deployed-topology.md` with the 2026-09-04 baseline (20 dckc records; the 2 catalogued powers weblets; record schema) so the next daily tick isn't surprised by them.

**Follow-ups:** if the maintainer replies that `counter`/`@none` are not expected, re-run the de-registration (move to revoked store) exactly as the originating job recorded and re-verify the recursive scan comes back clean.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-minion-town-containment-gateway-endo-sock-1-20260903-035007.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 28 tokens (894346 cached reads)
- Output: 18335 tokens
- Cost: $1.3750255000000002
- Wall-clock: 302s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
