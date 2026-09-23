## B3 Daemon Standup — Completion Report

### What was done

B3 (daemon standup on the box) is **already implemented** on branch `feat/endo-daemon-guest-mcp-b3` ahead of `origin/main`. The three commits deliver all requirements from `designs/mcp-daemon-guest-tools.md` §7 and `designs/mcp-endo-guest.md` §4.1–4.2:

**1. `deploy/aws/scripts/deploy-endo-daemon.sh`** (B0 pin + B3 deploy)
- Pins llm commit `f66505034aaa54ac46294347b2bf0e14655b088a`
- Clones endo-but-for-bots, packages source artifact, compiles app's `src/endo` for root-ctl
- Uploads both to private S3 bucket → presign GETs
- Via SSM: installs Node 22, creates `endo-daemon` user/group, installs systemd unit, builds native deps on ARM64 target, unpacks atomically, adds `minion-mcp` to endo-daemon group, restarts daemon

**2. `deploy/aws/systemd/endo-daemon.service`** (matches §4.1 verbatim)
- Dedicated `endo-daemon` system user, `ENDO_SOCK=/run/endo-daemon/endo.sock`, `RuntimeDirectory=endo-daemon`, `UMask=0007` for group socket access
- MemoryMax=1G, TasksMax=64, hardened (NoNewPrivileges, ProtectSystem=strict, etc.)
- RestartSec=3, WantedBy=multi-user.target

**3. `deploy/aws/systemd/minion-mcp.service`** — ENDO_SOCK env + SupplementaryGroups line added to enable guest tools at boot time

**4. `.github/workflows/deploy.yml`** — deploy ordering: `endo-daemon` step inserted before `app` step; `endpoint/endo-daemon` choice added to `deploy_target`; timeout bumped to 45m

**5. Scope wiring**
- `.env.example`: `MCP_SCOPES_SUPPORTED` includes `mcp/guest`
- `config/policy.json`: `mcp/guest` added to all three identity scope arrays (maintainer, guest admin, test)
- `src/config.ts`: default scopes include `mcp/guest`

**6. Dev client** (`dev/client.ts`) updated with B3 test modes (`guest-write`, `guest-read`, `guest-roundtrip`) using the `mcp/guest` scope

**7. OCapN demo lanes untouched** — `deploy/aws/daemon/` directory and its two listeners remain outside the CD sequence

**8. Typecheck**: `tsc --noEmit` passes clean (zero errors)

### Evidence available
Branch is pushed to `origin/feat/endo-daemon-guest-mcp-b3`. The deployed-edge validation (`guest_write_text` → SSM `endo list` → restart → `guest_read_text`) requires the AWS EC2 box and a live Cognito token, which are outside this environment. Once merged to main, CD will stand up the daemon automatically.

### Follow-ups
- **B4** (full surface, two tenants): remaining tool surface rows (`guest_list`, `guest_remove`, `guest_inbox`, `guest_eval`), Cognito scope provisioning
- **B5** (retire the toy): delete three minion tools + their scope rows; restructure `server.ts`
- **B6** (`@endo/mcp` extract): maintainer-gated
