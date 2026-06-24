---
title: Composition with HttpController + endo http CLI surface + dependencies
source: designs/trust-on-first-bind.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 337329bdd0cee6c9f30b6dc593684e8823455e09
source_date: 2026-05-10
source_authors: [Kriscendo Bot]
ingested: 2026-05-14
ingested_by: scholar
topics: [capability-security, tooling]
status: current
notes: The `endo http mk` + `endo http policy {list,add,revoke,unpin,mode,log}` CLI surface is canonical for any cap that adopts TOFB. The dependencies table names six designs in flight; TOFB is most directly an addendum to endoclaw-network-fetch + the PR #144 HttpController revision.
---

> Abstract: **Composition with HttpController**: PR #144's review asks for an HttpController/HttpClient split (an `http` subcommand with `mk` producing both, sibling subcommands adjusting policy through the named controller). TOFB plugs into that split as a `policyMode` constructor parameter on HttpController. **CLI surface** (the `endo http` subcommand verbs TOFB contributes): `endo http mk my-http --origins ... --policy-mode tofu-prompt`; `endo http policy list my-http` (listBindings); `endo http policy add my-http <origin>` (explicit Pinned-Allow); `endo http policy revoke my-http <origin>` (Pinned-Deny via revokeBinding); `endo http policy unpin my-http <origin>` (back to Unknown); `endo http policy mode my-http strict` (setPolicyMode); `endo http policy log my-http --since 1h`. The `endo http` surface itself is PR #144's responsibility; this design only specifies the verbs TOFB contributes. **Dependencies**: endoclaw-network-fetch (originating motivation), PR #144 HttpController revision (the split that provides the policy facet), endoclaw-browser (same allowlist shape, expected adopter), daemon-agent-tools (Shell command + Git repo gates, candidate adopter), daemon-mount (path policy, future application), daemon-form-request (prompt UI for tofu-prompt / tofu-attenuator in Chat).

### Composition with HttpController

The PR #144 review asks for an `HttpController`/`HttpClient` split (an `http` subcommand with `mk` producing both, then sibling subcommands that adjust policy through the named controller). Trust-on-first-bind plugs into that split as a `policyMode` constructor parameter on `HttpController`:

```bash
endo http mk my-http \
  --origins https://api.github.com \
  --policy-mode tofu-prompt
```

After the cap is minted, the holder can:

```bash
endo http policy list my-http             # listBindings
endo http policy add my-http <origin>     # explicit Pinned-Allow
endo http policy revoke my-http <origin>  # Pinned-Deny via revokeBinding
endo http policy unpin my-http <origin>   # back to Unknown
endo http policy mode my-http strict      # setPolicyMode
endo http policy log my-http --since 1h
```

The `endo http` subcommand surface is the revised PR #144 design's responsibility; this design only specifies the verbs trust-on-first-bind contributes.

### Dependencies

| Design | Relationship |
|---|---|
| `endoclaw-network-fetch` | The originating motivation; HttpClient is the first surface that adopts trust-on-first-bind. |
| PR #144 HttpController revision | The split between `HttpClient` and `HttpController` provides the policy facet that this design extends. |
| `endoclaw-browser` | Same allowlist shape, same prompt-and-pin questions; should adopt this pattern. |
| `daemon-agent-tools` | `Shell` command allowlists and `Git` repo gates are candidates; the same audit-and-revoke surface applies. |
| `daemon-mount` | Mount deny-patterns and allow-patterns are a policy surface; trust-on-first-bind for path opens is a future application. |
| `daemon-form-request` | The prompt UI for `'tofu-prompt'` and `'tofu-attenuator'` in Chat reuses this. |

Source: [designs/trust-on-first-bind.md](https://github.com/endojs/endo-but-for-bots/blob/337329bdd0cee6c9f30b6dc593684e8823455e09/designs/trust-on-first-bind.md) at commit `337329bd` on branch `llm`.
