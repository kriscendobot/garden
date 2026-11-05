# Gauntlet fix round 5: kriscendobot/minion.town PR #250

I fixed every must-fix and should-fix item from the panel-5 review (5781371233) in one follow-up commit, `8060116d`. CI is green: 3 checks, 0 failed.

**What I did**
- Read panel-5's "Must-fix before merge" review. No deterministic pre-pass block came with the job, so I worked from that review.
- Edited `designs/api-key-agent-directory-authorization.md` in an isolated project checkout.
- Pushed with `safe-push-pr-head.sh`, which moved the PR head from `e3c78e91` to `8060116d`.

**Changes by juror**
- **critic (Gate 1 not tied to the deployed factory):** Gate 1 now has to run against the deployed factory:
  - the endo-but-for-bots daemon at `ENDO_COMMIT` in `deploy/aws/scripts/deploy-endo-daemon.sh`, which must equal `PINNED_ENDO_COMMIT` in `src/endo/root-host-socket.ts`;
  - booted through the `ENDO_CHECKOUT` harness in `test/helpers/endo-daemon.ts`, and called through the minion.town agent endpoint rather than the factory directly.
  
  CI must provision that checkout so the test runs instead of skipping. A test against any other revision doesn't count, and a pin bump has to re-run the test before deploy.
- **skeptic (operations left out of Gate 1):** Gate 1 now lists every operation that takes an `agentId`: `get`, `setWake`, `setLimits`, `reattachOptions`, `reattach`, `dismissMail`, `retryMail` and `delete`. For each, another owner's id must be refused, change nothing, and look the same as an unknown id. `list` must never leak another owner's agents, and any new operation joins the list in the same change that adds it.
- **skeptic (legacy same-site cookie case):** Gate 2 now:
  - routes both `ocap.site` and `weblet.minion.town` hosts;
  - runs every case from both hosts, framed and opened directly;
  - adds a check for the legacy host: server-side instrumentation must show the request arrived with the session cookie and passed the account gate, then that no service method ran and nothing durable changed. The test fails if the cookie never arrived.
- **copyeditor:**
  - fixed the wrong antecedent on line 72;
  - turned the rubric-row sentence fragment and semicolon chain into a list;
  - split the frame/top-page/popup checks into separate cases and named the relaxed control (the `connect-src`/`form-action` floor);
  - changed "false `ownerId`" to "forged, caller-supplied `ownerId`".
- **novice:**
  - added a short plain-language definition of facet, attenuation, root-private, principal and endowments after the capabilities table;
  - noted beside the Decision chain that claims 1–3 are covered by existing tests, while claims 4–5 are still unproven and fall to Gate 1.

**CI**
`ci-wait-merge.sh` returned rc 0 (GREEN). My first wait, with the full 3600 s deadline, was stopped by the tool's 10-minute background limit before it reported a result. I re-ran it in the foreground with a 560 s deadline, and CI went green during that run.

**Follow-ups**
None from this round. The driver re-posts panel-6.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr250-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (1055423 cached reads)
- Output: 7132 tokens
- Cost: $0.8954926
- Wall-clock: 1485s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
