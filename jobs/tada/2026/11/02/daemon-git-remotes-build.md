I didn't build anything or open a PR, because this job would duplicate work that is already open. Every buildable slice of `designs/daemon-git-remotes.md` on `llm` either has shipped or already has its own PR. A third PR would compete with them, so I changed no code. `ensure-pr.sh --find-only` found no earlier PR for this job.

**Where the design stands:**

| Slice | State |
|---|---|
| Phases 1–5: the remote model, HTTPS credentialed fetch, pull, branch-limited push, controllers and revocation | Merged: 365, 368, 538, 705, 734, 929, 1145 |
| Next slice, which the minion.town git-remote arc depends on: adopting git capability URLs (git.minion.town) as `GitRemote`s without leaking the token | Design 1367 is open. Build 1557 (`feat(exo-git): adopt git capability URLs as GitRemotes without leaking the token`) is out of draft, mergeable, and waiting for maintainer review. It is marked as job `build-daemon-git-remotes` |
| Phase 6: interactive provisioning (CLI remote profiles, an inspection surface) | Build 1595 (`feat(cli): provision bounded Git remote profiles`) is a mergeable draft, marked as job `build-daemon-git-remotes-interactive-provisioning` |
| Phase 7: extended transports (SSH, Noise) | The design calls for design work here, not a build, so this job doesn't cover it |

The foreman posted this job (`foreman-decision:51bc3a7a64dc78285a87a2b1`) while 1557 and 1595 already covered the design. That is the same mistake as the stale `daemon-git-clone-bootstrap-build` job closed earlier today.

**Follow-ups:**
1. **1595 is stuck.** Its gauntlet `endojs-endo-but-for-bots-pr1595-gauntlet` halted on 2026-11-01 after using all 6 panel rounds (about $13.79). Panel 6 was parked as a deterministic failure, and the record has no structured must-fix list. Someone needs to decide whether to post a fixer job with a disambiguator suffix or have the maintainer review it.
2. **1557 needs the maintainer.** It is the real blocker for the minion.town arc's endo-binding step, and the next step is the maintainer's review, not more building.
3. **The foreman needs a fix.** It should search PRs by design slug and by the `garden-job: build-<slug>*` marker before posting a build job, so it stops minting duplicates.

I cite PRs as bare numbers so the completion machinery doesn't treat any of them as this job's deliverable and stage a second gauntlet.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/daemon-git-remotes-build.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (809963 cached reads)
- Output: 3913 tokens
- Cost: $0.7815486
- Wall-clock: 84s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
