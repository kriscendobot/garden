Inbox empty. Work is landed and verified.

---

## Completion report

**Landed on `main2`** (commit `0c5f49d5e4`, pushed clean).

### The key finding: the operative fix already existed; the job's evidence is a measurement artifact

I verified empirically on the live fleet (this host, `endolin-garden-ece02cb4`) that **`aws` is already reachable from inside a `claude -p` session** — my own agent's `command -v aws` resolves to `~/.local/bin/aws`, and every live `claude -p` subprocess's `/proc/<pid>/environ` carries `$HOME/.local/bin` in PATH.

Why the job measured otherwise: it read `/proc/<MainPID>/environ`. That environ is **frozen at exec time** on the bare `systemd --user` PATH and *never* reflects the agent's PATH. `common.sh` § "declare the fleet's PATH tail" (added 2026-07-28, `e89290ff87`) **appends `$HOME/.local/bin` and exports it**, so the `claude -p` child the handler spawns — and its non-login Bash tool calls — inherit the fixed PATH. The MainPID environ is simply the wrong thing to measure. So the job's premise ("nothing propagates `~/.local/bin`") was already false; the agent path works today.

### What I actually changed (a real, remaining gap in the same family)

While confirming the above I found a genuine latent hole: **a login shell can't find `aws`**. `/etc/profile.d/garden.sh` and the baked image `ENV PATH` (both in the Dockerfile) list `$HOME/bin` + the go dirs but **omit `$HOME/.local/bin`**. `bash -lc 'command -v aws'` fails; only common.sh's runtime append (dropped by any login-shell PATH re-derivation) covered it.

- **`Dockerfile`** — added `$HOME/.local/bin` to both the `/etc/profile.d/garden.sh` login PATH (L253) and the baked `ENV PATH` (L259), mirroring the `$HOME/bin` entry already there. Verified the rendered profile resolves the dir.

### Where the fix belongs, and why not the alternatives

- **common.sh append** is the operative layer — serves *every* worker kind (gardener/cleric/hermit/mystic/fireworker all source it) with no per-handler repetition, and it's the one that actually reaches the agent subprocess. It already does the job.
- **Dockerfile** is the belt-and-suspenders for the login-shell/image surface.
- **Rejected: `Environment=PATH=` in the systemd unit** — an absolute unit pin *narrows* PATH on hosts carrying legitimate extra dirs (nvm, `~/.cargo/bin`, `/snap/bin`) and would break fleet builds (per the existing common.sh rationale). I did not mirror `claude_bin()` either — correct, since `aws` is run *by the agent*, not launched by the spine, so a resolver function is unreachable to it.

### Test (DOD: proves reachability, not just a PATH string)

- **`scripts/jobs/test/worker-local-bin-path-test.sh`** — sources common.sh on the exact bare systemd PATH the job quoted, then proves a stub `aws` in `$HOME/.local/bin` **resolves and executes** through the handler's `( cd "$worktree" && env -u … )` launch idiom. 4 subtests: non-vacuity control (aws unreachable without the append), PATH membership, execution-through-launch-path, and idempotency (no dup on double source). Follows the fleet's fake-binary pattern with the noexec-tempdir exec probe → **SKIPs honestly** where the sandbox forbids exec. Passes 4/4, shellcheck-clean, `bash -n`-clean.

### Verification

- New test: 4/4 PASS. Sibling `claude-bin-resolver-test.sh`: 27/27. `detect-home-coupling-test.sh`: 10/10. `worker-spine-kinds-test.sh`: 147/147. Dockerfile profile render verified.

### Take-effect / follow-ups

- **The agent path needs nothing** — common.sh already delivers it; effective on this and any host deployed since 2026-07-28. A follower host still on pre-07-28 deployed code just needs a normal deploy.
- **The Dockerfile change needs an image rebuild** (not a units reconcile, not a deploy) to take effect; it only hardens login-shell reachability, which the runtime append already covers for the agent.
- **Other `~/.local/bin` tools silently unreachable "for the same reason": none in the tool-by-tool sense** — the whole *directory* is on PATH, so every tool installed there (current and future) is reachable together; there was no per-tool gap. The only surface still worth the rebuild is login shells, now closed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-worker-path-local-bin.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 60 tokens (2541147 cached reads)
- Output: 39703 tokens
- Cost: $3.1793905
- Wall-clock: 628s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
