The scan is decisive and complete. My analysis:

**Core check — the three de-registered records are ABSENT from the active store and present in revoked:**
- `f1d754fc…`, `fe0a8e60…`, `09201a3162…` — none appear in `vhosts/` (recursive scan, filename + content, whitespace-tolerant). All three sit in `vhosts-revoked-20260812/`. The revoked `09201a3162…` had `"powers": "@agent"` (the full EndoHost escape), which is why it was pulled 08-31 (its containing dir's mtime is Aug 31 14:31).

**No unexpected active dckc-owned record:**
- 20 active records are dckc-owned (`8929a9ae-…`), but the escape-scan for `@agent`/`@host` powers came back empty — **no dangerous powers weblet is active**.
- 18 are content-only (no powers field), all created 08-28/08-29 — dckc's published content weblets.
- Two carry powers, both pre-dating and surviving the 08-31 de-registration: `c016601e…` = `"powers": "@none"` (explicitly no powers, 08-12) and `806fc2ea…` = `"powers": "counter"` (bounded counter capability, 08-13). Neither is the `@agent` escape shape; both are authorized under the 08-27 powers-plane opening. The three share one `contentRoot` — the same page bound to `@agent`/`@none`/`counter`; only the dangerous `@agent` binding was revoked.

**Containment-open state is the authorized one (not verified against):** `GATEWAY_ENDO_SOCK=/run/endo-daemon/endo.sock` is present and the drop-in is renamed `zz-containment-20260812.conf.disabled-issue58`. No alarm, no re-arm — per the retuned "What NOT to verify."

Clean no-change pass. Per the reporting rule ("report no-change quietly"), I am not posting to the maintainer inbox. No git changes are warranted for a verification check.

---

Ran the containment drift check for kriscendobot/minion.town gateway records against the live host (`i-0380cd68b90020fad`) via SSM Run Command, read-only.

**What I did:** Recursively scanned the live active vhost store `/var/lib/endo-gateway/store/vhosts/` (the subdirectory — not a root-only glob), matching both filenames and record content whitespace/format-tolerantly, and cross-checked the revoked store and the daemon powers-plane state.

**Findings (clean, no change):**
- All three de-registered records (`f1d754fc…`, `fe0a8e60…`, `09201a316203e9d99e3c906b12c9466d8f0ae8dc8baf8db484c918d6698f657f`) remain **ABSENT** from the active store and are present in `vhosts-revoked-20260812/`.
- **No unexpected active dckc-owned record:** no `@agent`/`@host` escape weblet is active. Of 20 active dckc-owned records, 18 are content-only weblets; the two powers-bearing ones (`@none`, `counter`) pre-date and survived the 08-31 de-registration and are authorized under the 08-27 powers-plane opening.
- Containment-open is the authorized state (`GATEWAY_ENDO_SOCK` set; drop-in renamed `…disabled-issue58`) — correctly not verified against, not alarmed on, not re-armed.

**Changes:** none (verification-only; quiet no-change pass).

**Follow-ups:** none. If a `@agent`-powers dckc record reappears in the active store, the recorded remediation is to `mv` it into `vhosts-revoked-20260812/`, re-run the recursive scan to prove clean, and notify the maintainer inbox.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-minion-town-containment-gateway-endo-sock-1-20260902-035004.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 15 tokens (448220 cached reads)
- Output: 12366 tokens
- Cost: $1.1928729999999999
- Wall-clock: 246s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
