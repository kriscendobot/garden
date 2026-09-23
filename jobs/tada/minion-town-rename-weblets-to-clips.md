PR #54 is open and the work is complete. Final summary below.

---

## Completion report — `minion-town-rename-weblets-to-clips`

**What I did:** Renamed the "weblet" concept to "clip" throughout `kriscendobot/minion.town` as a single focused change (per `rename-discipline`), landed as **draft PR [kriscendobot/minion.town#54](https://github.com/kriscendobot/minion.town/pull/54)** (branch `rename-weblets-to-clips`).

**Scope covered — 844 occurrences across 70 files:**
- Case-preserving token rename: `Weblet→Clip`, `WEBLET→CLIP`, `weblet→clip` across source, tests, identifiers, comments, docs, and design docs.
- **MCP tool names** `weblet_publish`/`weblet_list`/`weblet_unpublish`/`weblet_upgrade` → `clip_*`.
- **Deployment env vars** `WEBLET_*` → `CLIP_*` (values unchanged), all systemd/Caddy/`.env.example`/workflow consumers updated in lockstep.
- `no-such-weblet` reason code → `no-such-clip`; `[weblet-charge]` log tag → `[clip-charge]`.
- **16 files renamed** via `git mv` (source, tests, deploy scripts, design docs — incl. `designs/weblet-ocap-synthesis.md` → `designs/clip-ocap-synthesis.md`).

**Externally-visible judgment calls (all noted in the PR body):**
- **Preserved as frozen literals** (renaming would orphan live/persisted state), each with a clarifying in-code comment:
  - `weblet.minion.town` — legacy DNS domain still serving already-published `<hash>.weblet.minion.town` capability URLs.
  - `endo-weblet-store` — live Unix system group that owns the deployed store tree on the host.
  - `"weblet-v1"` — frozen hash-preimage domain-separation version tag (`sha-256("weblet-v1\n"+…)`) that fixes derived content ids on the wire.
- **Renamed (not aliased):** MCP tool names — MCP clients rediscover tools each session and there's no in-repo persistent client contract, so a straight rename is low-risk. This is the largest external-facing change and is flagged for review.
- **Untouched:** `ocap.site` (current parent domain, never contained "weblet"); already-merged upstream git branch names (immutable history).

**Verification:** `npm run typecheck` clean; `npm test` (vitest) **270 passed, 4 skipped** (the skips are the by-design daemon-integration tests). Matches CI (`test.yml` = typecheck + vitest).

**Single PR vs staged sequence:** **Single PR** is correct here. This is a mechanical, atomic concept rename — the tree only compiles/passes tests when every reference moves together; a staged sequence would leave the source half-renamed and broken between stages, with no independently-reviewable value in the intermediate states. The change is large but uniform, and the three judgment calls are concentrated and clearly documented for focused review.

**Follow-ups:**
- PR #54 is left **draft**, ready for maintainer review of the judgment calls (esp. the MCP tool-name rename). The gauntlet can be run on it (`run the gauntlet #54`) when desired.
- Pre-existing (not a regression): `designs/clip-gateway.md` is referenced ~47× but no such file exists in-repo — it was already dangling as `weblet-gateway.md` before this change.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-rename-weblets-to-clips.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 67 tokens (2567535 cached reads)
- Output: 33993 tokens
- Cost: $2.9265614999999996
- Wall-clock: 505s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
