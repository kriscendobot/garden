Viability gate result for kriscendobot/minion.town#122: **proceed**. The PR is open, unmerged and still a draft, at head `ba974952`. Nothing has replaced it, and the hardening it adds is still missing from `main`. I spent no clean, panel, fix or CI budget.

**Deciding question:** Does current `origin/main` (`d750b09`, 199 commits past the PR's frozen base `main-561472a`) still lack both protections the PR adds, so that nothing has replaced it and its security reason still holds? The two protections are an offline check, in the harness CI, of Anthropic's signed release manifest and its detached signature, tied to `release.json`; and a SHA-256 check of the Node 22 arm64 tarball before root extraction in `deploy-app.sh`.

**Evidence:**
- **No signed manifest on `main`:** `tools/claude-harness/` has no `manifest.json` or `manifest.json.sig`. `check.mjs` only checks that the version pins agree (`checkPinConsistency`). The GPG check of the upstream manifest still runs only inside `refresh.mjs`, against a temporary download that is then thrown away, so CI cannot check it later.
- **No Node checksum on `main`:** `deploy/aws/scripts/deploy-app.sh` still finds `NODE_FILE` by grepping `SHASUMS256.txt`, then downloads and `sudo tar`-extracts `/tmp/node.tar.xz` without checking its hash.
- **Nothing newer covers it:** none of the 199 newer commits touching `tools/claude-harness/` or `deploy-app.sh` adds either protection. They are pin bumps to 2.1.268, 2.1.278 and 2.1.283, Claude CLI backend work, artifact and rollback fixes, and a Caddy route.
- **No objection on the PR:** it has no reviews. Its only comment is the halt notice from the previous gauntlet run.

**Follow-ups for the clean stage:**
- The previous run (`kriscendobot-minion.town-pr122-gauntlet`) stopped because its clean stage declared failure, and the next run needs to get past that.
- The base is 199 commits behind and `main` has moved the Claude pin to 2.1.283. Rebasing will mean regenerating the PR's checked-in `manifest.json` and `manifest.json.sig` for 2.1.283, since the files the PR carries are for an older version.

I made no repository changes.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr122-gauntlet-20261008-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (164780 cached reads)
- Output: 2012 tokens
- Cost: $0.429476
- Wall-clock: 30s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
