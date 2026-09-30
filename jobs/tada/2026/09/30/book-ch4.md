I wrote chapter 4, "Creating your own instance," and landed it on `origin/journal2` at `projects/garden-book/ch4-creating-your-own-instance.md`. I used `land-journal-edit.sh`, which pushed it and checked it arrived. I made no changes to `main2`.

The chapter is about 600 lines of Markdown, based on `main2` 649f5cdd617. Where the sources disagree, it defers to the launcher, `identity.md`, `auth.md`, `starting.md` and the turnkey design and runbook. It covers:

1. **Container model:** the per-user image, the checkout mounted at the same path inside and outside the container, and the unprivileged container (only `SYS_ADMIN` added, no host devices). It also covers pinned DNS, the hardening check, and how the container guard works and why it doesn't compare the current directory with `$HOME`.
2. **Identity:** how `<hostname>-<basename>-<hash8>` is built, that there is no `.garden` file, the "hostnames must be distinct" question, running several instances, renaming, and the expert overrides.
3. **Bot credentials:** the three credentials (Claude login, bot SSH key, bot `gh` token), the two `gh` login paths, why the Claude login is never stored as a secret, and how the bot's git identity is restored (per-host journal override first, then the tracked default).
4. **Bring-up:** the six steps from `starting.md`, the checks that the worker pool is actually running, the liaison's four monitors (as a table), the optional armings, and the first job.
5. **Turnkey AWS host:** the scripts under `scripts/aws/turnkey/`, the AMI bake and scrub, the launch template, the credential-free smoke test, logging in over SSM, the three resolved decisions, the alternatives the design rejected, and cost and teardown.
6. **What you end up with:** the difference between a new host joining an existing garden (fully documented) and an independent garden with its own journal that can evolve separately (the chapter 1 framing). It lists which settings live in journal data and would need to change.

It closes with a known-gaps section and a checklist.

**Gaps and stale spots the chapter reports:**
- **No read-once PAT bootstrap:** the Secrets Manager login path has its IAM permission (`--with-secret`), but no script reads the secret into `gh`.
- **No recipe for an independent garden:** nothing documents forking the repo or creating a fresh orphan `journal2`, and several defaults are hardcoded to `kriscendobot`.
- **`README.md` is stale:** it still tells multi-instance users to `echo <name> > .garden`.
- **The turnkey design is stale:** its alternatives section still describes a `--privileged` container.
- **The ARM64 image carries an unused amd64 ROCm overlay:** the arch guard for the `Dockerfile` hasn't landed.

**Possible follow-ups (none posted):**
- Fix the stale `.garden` line in `README.md` and the privileged-container text in the turnkey design.
- Write the PAT read-once bootstrap.
- Write an independent-garden (fork plus fresh journal) recipe.

The chapter 1 file wasn't written yet, so the link back to it relies on `HISTORY.md`'s stage names rather than chapter 1's actual text.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/book-ch4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (791773 cached reads)
- Output: 19655 tokens
- Cost: $1.2835425999999999
- Wall-clock: 182s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
