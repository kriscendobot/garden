## Gauntlet undraft stage: kriscendobot/minion.town PR #201

**Result:** PR #201 is now ready for review. Its head is still the panel-passed commit `73866dc2142863141a1635688290b75799d07ae2`.

**Gate check:**
- **Before un-drafting:** state OPEN, isDraft true, head equal to the panel-passed commit.
- **Action:** ran `gh pr ready`.
- **After:** isDraft false, head unchanged.

**Advisory appellate pass (does not block):** a short `claude -p` review (Sonnet) of the diff, with `package-lock.json` left out. It stopped at 150 KB, partway through `test/new-clip.test.ts`, so the rest of that file was not reviewed. It found these possible gaps for the maintainer to check:
1. **Write access:** anyone with a clip id has the full clip power: `makeDirectory`, `writeText`, `makeApp` and `remove`.
   - Strangers can fill a clip to its quota (4096 names, 1 MiB of text).
   - The owner has no way to shut a clip down other than unpublishing it.
   - The diff doesn't show the CapTP WebSocket upgrade checking `Origin`.
   - The design doc accepts this exposure; the maintainer should confirm it is intended for the beta.
2. **Minting cost:** `POST /account/clips/new` spends credits on every call. Nothing limits the rate per owner or blocks parallel requests. A client timeout after 60 s doesn't cancel the mint on the server.
3. **CSRF:** the `Sec-Fetch-Site` check passes when the header is missing. If that happens, protection depends on the session cookie being `SameSite=Lax` or stricter, which the diff doesn't show. Requiring an `Origin` match or a custom header would close this.
4. **Build and deploy:**
   - Confirm `@endo/init`, `@endo/captp` and `@endo/far` are declared dependencies.
   - Confirm `npm ci` in the Docker build stage installs `esbuild`.
   - Confirm the runtime stage copies `dist/src/clips/`. If it doesn't, the route quietly disables itself at boot.
5. **CI runner:** the new step runs `docker run --network host` on the self-hosted runner. It mounts the workspace read-write, runs code from the PR, and installs Playwright from the network at test time.

The reviewer found nothing else wrong in the code it saw: the clip power stays inside its space, and path rules are enforced in one place. No follow-up jobs were posted.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr201-gauntlet-20261019-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (150856 cached reads)
- Output: 2109 tokens
- Cost: $0.3620152
- Wall-clock: 79s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
