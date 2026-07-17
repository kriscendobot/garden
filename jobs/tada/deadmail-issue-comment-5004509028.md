Completed the dead-lettered intent for issue #57 (kriskowal/garden), comment from dckc: *"why a private repository? I'm curious to look at ymax-e2e"*.

**What I found:** `kriscendobot/ymax-e2e` was PRIVATE. Inspected its contents — it's a Playwright recording-harness scaffold (config, guard tests, a `test.fixme` flow-1) with an explicit no-secrets policy. It contains **no ymax source and no secrets** (`.gitignore` excludes `.env*`, artifacts, reports; a scan turned up only policy-doc mentions of secrets, no actual credentials). The original private choice was a conservative over-reading of dckc's earlier "ymax.app code isn't published" note, not something the scaffold actually requires.

**What I did:**
1. **Granted dckc read access** — sent a `pull`-permission collaborator invitation to `dckc` on `kriscendobot/ymax-e2e` (invitation id 326051156), directly satisfying "I'm curious to look at it" via a reversible action rather than an irreversible public flip.
2. **Replied on the issue thread** (https://github.com/kriskowal/garden/issues/57#issuecomment-5004619048): explained the private default was conservative not deliberate, that the repo holds no ymax code/secrets, that dckc is now invited as a read collaborator, and offered to make it fully public on request (deferring that call to the maintainer). Also flagged that `ymax-e2e` is likely to become secondary once the `agoric-labs/ymax-agent-local-mcp` fork unblocks (still 404 for kriscendobot).
3. Did **not** close the issue (submitter closes it).

**Changes:** No garden-repo (main2) changes — this was operational GitHub work, so nothing to commit/push. `dckc` collaborator invite pending their acceptance.

**Follow-ups:**
- If dckc prefers public, flip `kriscendobot/ymax-e2e` visibility to public.
- Still blocked: read access to `agoric-labs/ymax-agent-local-mcp` (404 for kriscendobot) is required before the harness can move to that fork per dckc's earlier steer.
