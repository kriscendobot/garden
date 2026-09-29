The must-fix panel findings on PR #610 are addressed, committed, pushed, and summarized on the PR. Job complete.

## Completion report

**Job:** Fix must-fix panel findings on endojs/endo-but-for-bots PR #610 (`design/gateway-bearer-token-auth-reconcile`).

**What I did** — one commit (`7d690d92f7`) pushed to the PR head, touching three design files:

- **`designs/gateway-bearer-token-auth.md`** (the PR's file):
  - Reverse-proxy/loopback caveat (decomplector, request-changes): new "Interim caveat" section — a same-host proxy fronting local mode defeats loopback admission until `X-Forwarded-*` handling lands in Phase C; remote mode (optionally CIDR-narrowed) is the supported proxied topology for Phases A/B.
  - Env-var precedence (ergonomist / decomplector): note under the modes table that `ENDO_GATEWAY=remote` short-circuits `makeAddressChecker` and the CIDR allowlist is ignored when both are set.
  - Glossed "lineage" on first use; expanded `M5`→Milestone 5, `M6`→Milestone 6 (novice must/should-fix).
  - Sequence diagram: added the rate-limited-rejection branch and a close reason on the 1008 (novice, ergonomist).
  - Style: removed all 22 em-dashes from prose (kept only judgment-based rewrites — colon/comma/period), replaced 3 `§` signs with ASCII "sec.", fixed the verb ellipsis (copyeditor, pedant must-fix).
- **`designs/daemon-web-gateway.md`** (critic #1): Status no longer claims `cidr.js` address filtering ships with "no significant deviation" — now records it present-but-unwired and points to Phase A; Address-filtering section flagged as not-yet-wired.
- **`designs/daemon-docker-selfhost.md`** (skeptic #1): corrected the "gateway rejects non-localhost" premise, the stale `ENDO_GATEWAY_REMOTE` env var (prose + compose + entrypoint), the stale `gateway.js` path, and the non-existent `--addr` flag.
- Related Designs updated to list both siblings as reconciled in this pass.

**Verification:** `prettier --check` clean on all three files; no em-dash or `§` in any added line.

**Follow-ups:** PR stays a DRAFT design PR; the two Open Questions (which lineage serves #608's follow-up; loopback-enforcement deprecation) remain maintainer decisions. Posted a summary comment on the PR mapping each finding to its fix.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-endojs-endo-but-for-bots-pr610.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 94 tokens (5417803 cached reads)
- Output: 34363 tokens
- Cost: $4.952406499999999
- Wall-clock: 575s
- Model(s): claude-opus-5-5 ×1, claude-opus-4-8 ×2

<!-- garden-usage-end -->
