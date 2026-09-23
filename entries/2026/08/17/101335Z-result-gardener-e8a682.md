---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-17T10:13:37Z
---
---
kind: result
role: purist
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
---

Panel seat `purist` on endojs/endo-but-for-bots PR #1014 (`endo http mk`, Phase 1 of the CLI HTTP client). Diff base `origin/llm`.

### purist

**Verdict:** comment-only

**Findings:**

- `packages/cli/src/http-mk-policy.js:101` duplicates the daemon's mode vocabulary (`HTTP_CLIENT_POLICY_MODES`, `packages/daemon/src/host.js:162`) and respells its union `'strict' | 'tofu-auto'` seven times (lines 108, 116, 132, 139, 164, 169) although `packages/daemon/src/types.d.ts:417` already names it `HttpClientPolicyMode`. The daemon's own docstring says `tofu-prompt` / `tofu-attenuator` are excluded only until a live `policyAuthority` is wired, so the copy is drift-prone: once the daemon widens, this coercer still rejects the new mode locally with "must be strict or tofu-auto" before the authority ever sees it. Fix: add `HttpClientPolicyMode` to the re-export block at `packages/daemon/types.d.ts:35` and annotate with `import('@endo/daemon').HttpClientPolicyMode`. should-fix. [rule: roles/jurors/purist/AGENT.md § Family-consistency across related symbols]

- `packages/cli/src/http-mk-policy.js:178` requires at least one `--origin` unconditionally, while the authority it defers to (`normalizeHttpClientPolicy`, `packages/daemon/src/host.js:227`) treats `allowedOrigins` as optional. Under `--policy-mode tofu-auto` the allowlist is a pre-seed and not a bound (the exo auto-allows any first-seen origin), so the verb demands an entry that confines nothing, and the mint reads as origin-confined when it is not. That is the same false-confinement hazard the module's own docstring at lines 12-25 refuses for path-bearing origins, applied to the mode axis instead of the origin axis. Make the requirement mode-aware: require in `strict`, and under `tofu-auto` either accept its absence or say on stderr that the allowlist does not bound outbound reach. should-fix. [rule: roles/jurors/purist/AGENT.md § Edge-case enumeration on values]

- `packages/cli/src/http-mk-policy.js:11` and `:101` are unhardened module-level arrays; the daemon's counterparts at `packages/daemon/src/host.js:162-163` are `harden(...)`. Not a boundary defect (single realm, and the CLI siblings do not harden either), so consistency with the family it mirrors is the only argument. comment-only. [rule: roles/jurors/purist/AGENT.md § Property hygiene on frozen prototypes]

- `packages/cli/src/http-mk-policy.js:20` claims the local refusal "keeps the allowlist entry meaning exactly what the user typed", but the same function lowercases the host and strips an explicit default port. The claim holds for paths only; narrow the sentence to the path/query/fragment/userinfo case it is actually defending. comment-only. [rule: skills/gricean-maxims/SKILL.md]

**Notes (out of scope but worth flagging):**

- Passability checked and clean: the policy record built at `packages/cli/src/http-mk-policy.js:184` and sent at `packages/cli/src/commands/http-mk.js:48` is a fresh unfrozen record, but CapTP hardens arguments at send (`packages/captp/src/captp.js:532`), and this matches the established CLI shape at `packages/cli/src/commands/mount.js:32`. No finding; recorded so a later seat does not re-raise it.
- `JSON.stringify` for quoting user tokens in errors (six sites) is the majority CLI convention (`packages/cli/src/commands/define.js:19`, `form.js:19`, `endow.js:20`, `inspect.js:24`); only `packages/cli/src/pet-name.js` uses `q` from `@endo/errors`. The new module matches the local family, so the `@endo/*`-reuse rule does not bite here.

Self-improvement: the reuse-an-`@endo/*`-primitive axis in `roles/jurors/purist/AGENT.md` reads as unconditional, but `q`-versus-`JSON.stringify` in `packages/cli/src` shows the local family can already have settled the other way; the axis should say to establish which spelling the surrounding package uses before flagging, so the seat does not report a false positive against a package-wide convention.
