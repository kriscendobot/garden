Inbox empty. Work is done.

# Report — `deadmail-issue-comment-5105796865`

Picked up a dead-lettered issue-inbox message: a new comment from `dckc` on kriscendobot/garden#68 whose addressee (`issue-kriscendobot-garden-68`) had already completed. The comment reported that an agent told them "the Dockerfile installs the Claude CLI via NodeSource's npm, whose global prefix is `/usr` — so claude lands in `/usr/bin/claude`", and that they were resuming their *containerize ps23* plan on that basis.

## What I found

That answer is wrong on both halves, verified against `Dockerfile:88-152`: NodeSource's apt repo and setup script both 403 as of 2026-07, so the image unpacks the **nodejs.org tarball into `/usr/local`** — npm's global prefix is `/usr/local` and the CLI lands at **`/usr/local/bin/claude`**. Their gist's verification step would have looked for a path that does not exist.

I also reconstructed the current state of #68 from the journal: orchestration `fix-ps23-claude-path-outage` is complete (children `7173c6dd36` pre-claim health gate, `e89290ff87` `claude_bin` resolver); ps23's 52 stranded claims cleared via the reaper once the leader throttled it to `gardeners: 1` at 06:49Z; zero ps23 claims in `doin/`; ps23 silent since `06:49:29Z`; no job poisoned by the outage. **Open caveat:** the deployed root is `7e525d50c6`, 39 commits behind `main2` — I confirmed `7173c6dd36` is *not* an ancestor of the deployed sha, so the guard is landed but running nowhere. The maintainer was already alerted by the prior job.

## Changed

- **`context/operations/health.md`** — new § *A worker cannot find its agent CLI*: where the CLI actually lives (and why not `/usr/bin`), the `systemd --user` undeclared-PATH trap (`show-environment` vs a login shell), the `agent_bin_probe` resolution order and its `npm install -g` retry window, the pre-claim health gate, and the `GARDEN_CLAUDE_BIN` fail-closed override — with the note that all of it lives in the *deployed* checkout.
- **`context/operations/README.md`** — index line updated to route "claude not on PATH" here.
- Landed on `main2` as `e5792e8de2` (direct push per CLAUDE.md § Conventions). `scripts/checks/run-all.sh`: all 5 pre-dispatch gates clean.

## Replied

https://github.com/kriscendobot/garden/issues/68#issuecomment-5105877759 — the two corrections; that containerizing is right for the credential-isolation reasons in their own gist but is *not* the fastest fix for this outage (a current `main2` deploy resolves the CLI host-side already); three items in their gist that have gone stale (`set-gardeners.sh` must run from the target host; `gardeners: 0` is refused twice over so retirement is drain+disable; the **sysop** daemon now runs on every host and gives the remote kill switch this issue was filed for lack of); and the #68 status above. Issue left open — the submitter closes it.

## Follow-ups (not in scope, carried from the chain)

1. **Deploy is the live blocker** — the pre-claim guard protects no host until the fleet deploys past `7e525d50c6`.
2. If ps23 returns at 8 gardeners on its old deploy, it can re-strand claims; the comment says so explicitly.
3. Pre-existing and unrelated: `run-test.sh` is red by default on `main2` (~30 environmental failures) and hardcodes a shared `TR=/home/kris/.garden-test` that concurrent workers clobber.
