---
created: 2026-05-13
updated: 2026-06-24
author: gardener
---

# Skill: saboteur-adversarial-review

Adopted from `references/endo-but-for-bots/skills/saboteur-adversarial-review.md`.

Reusable attack-class patterns for the saboteur's review variant. When reviewing PRs as the adversarial perspective in a jury panel, focus on attack classes the regular reviewers cover poorly: a type-correctness reviewer sees "the function takes a string and returns a string"; the saboteur asks "what if the string is `..` or `\n` or `:` or a symlink or from a different namespace than expected?".

This catalog is **consumed by the `saboteur` jury seat** (`roles/jurors/saboteur/AGENT.md`), which the scripted code panel (`scripts/jobs/gardening/panel.sh`, skill `../panel/SKILL.md`) fans out as one `claude -p` seat over the diff. The seat consults this catalog before walking `[adversarial-tests]`, so recurring attack classes get checked first and the brainstorming list fills in the rest. Cite `[self-improvement]` as the meta-pattern for capturing new review classes here.

## When to use

- Every code-panel pass on the gauntlet. The `saboteur` seat reads this catalog first, then brainstorms the rest per `[adversarial-tests]`.
- Out-of-band review requests where a maintainer asks "what would an attacker do here?" against a specific module (posted as a job a gardener claims, or routed via an inbox per `../message-bus/SKILL.md`).

## Reusable patterns

### Rootfs-derived environment derivation

Whenever a sandbox or container driver derives an environment variable (`$PATH`, `$LD_LIBRARY_PATH`, `$XDG_*`, `$NODE_PATH`, etc.) from the host filesystem layout (by probing for canonical bin dirs, mining the ambient env, or inspecting an OCI image's `Config.Env`) there is a class of attacks that string-shape unit tests do not catch:

1. **`realpath` blind spots.** A textual prefix check (`startsWith('/tmp/')`) does not see through symlinks. Operator-installed `/opt/eve -> /tmp/attacker` survives the filter and becomes a writable entry on the slice's derived `$PATH`. Mitigation: resolve survivors with `fs.realpathSync` and re-apply the prefix check to the resolved value.

2. **Delimiter injection through cap-supplied strings.** Joining derived entries with `:` (or `;`, or `\0`) without validating the entries for the delimiter silently lets a caller inject extra `$PATH` entries by embedding a `:` in their `innerPath` or `hostPath`. Newlines corrupt the wire format of the spawn argv. Add a guard: `if (entry.includes(':') || /[\x00-\x1f]/.test(entry)) drop;`.

3. **Relative-path probing.** A non-absolute `hostPath` (`srv/foo`, `..`) makes `existsSync(\`${hostPath}/usr/bin\`)` probe against the daemon's CWD. Even when the downstream bind-mount fails safely, the synthesised `$PATH` ends up reflecting daemon-CWD-shaped probes that have nothing to do with the slice. Fail closed early: `if (!hostPath.startsWith('/')) return [];`.

4. **Empty-probe fallback to host-shaped defaults.** When the rootfs probe finds no canonical bin dirs, falling back to a hard-coded `/usr/local/bin:/usr/bin:/bin:...` pointed at non-existent paths is user-hostile (commands fail with `ENOENT` for non-obvious reasons) and inconsistent with the rationale comment. Either fall back to empty (force the caller to set `$PATH`) or document the guarantee.

5. **TOCTOU between make-time derivation and spawn.** Confirm whether the derived value is snapshotted at `make()` (rootfs mutations between make and spawn are not reflected) or re-derived per spawn. Either is defensible; flag undocumented choice.

6. **Caller-PATH precedence.** Whether the derived value lands before or after caller-supplied entries determines whether a hostile mount can shadow `/usr/bin`. The defensible choice is "rootfs-defaults first, caller-mounts last". Flag if undocumented or inverted.

### Application

Run these six checks on any PR that touches a `drivers/path.js`-shaped file, or that adds any `process.env`-mining, image-inspection, or mount-probing code path that ends up in a `spawn` argv. The unit-test surface for these helpers will not exercise symlink resolution, control-character injection, or cwd-relative probing because all three require an `existsSync` probe with realistic side effects. They need adversarial test cases, not just shape tests.

## How findings ride in the panel verdict

Each pattern's six checks are independent findings; each gets its own line in the saboteur seat's per-juror block with a verdict (real concern / mitigated / out of scope) and the `file:line` the check targets. The panel script (`../panel/SKILL.md`) files each seat's block under its run dir and the `decide_disposition` step folds the saboteur's must-fix lines into the round's `must-fix` / `pass` aggregate; the panel's fixer loop then drives the must-fix items to resolution before un-draft.

## Output shape

The saboteur seat emits one per-juror block: one line per independent check, each carrying `file:line` + verdict (real concern / mitigated / out of scope) + a one-line rationale. The block is what the panel's disposition step consumes; no other artifact is produced.

## Notes from the field

- _2026-05-13_: adopted from the reference. The reference catalog has one pattern (rootfs-derived env derivation) developed by hand; this skill is structured to accept more as they recur in panel passes.
- _2026-06-24_: migrated into v2. The substance is unchanged; the consumer changed from a dispatched judge's saboteur juror to the scripted code panel's `saboteur` seat. New attack classes are still captured here as they recur; the seat brief at `roles/jurors/saboteur/AGENT.md` points back at this catalog.
