---
section: one-package-json-keyword-one-install-command-multiple-resource-kinds-with-per-kind-confinement
source: endo-but-for-bots--llm-designs-endopi-extension-package-manifest
topics: [agent-conventions]
status: current
title: The §Install command — three source schemes + project-local
parent: endo-but-for-bots--llm-designs-endopi-extension-package-manifest--one-package-json-keyword-one-install-command-multiple-resource-kinds-with-per-kind-confinement
---

mode

The §Install subsection shows the source-resolution shape:

```sh
endo install npm:@foo/bar
endo install npm:@foo/bar@1.2.3
endo install git:github.com/user/repo
endo install git:github.com/user/repo@v1
endo install --project npm:@foo/bar     # project-local
```

Three source schemes (`npm:`, `git:`, local path) with optional
version pinning. The `--project` flag installs to a project-local
location rather than the user's global store. The §dispatch
mechanism walks the four resource directories:

1. **`guests/`** → daemon's guest-plugin store (existing `endo
   install` path).
2. **`skills/`** → `~/.agents/skills/` global OR `.agents/skills/`
   project-local — cycle 112's
   `endopi-skills-markdown-format` discovery walker picks them up.
3. **`prompts/`** → cycle 129's `endopi-prompt-templates`
   discovery path.
4. **`providers/`** → cycle 128's `endopi-provider-registry-
   and-oauth` registry registration.

The four-step dispatch directly cross-references the four
sibling designs. This design is *the unifier* — the file that
makes the prior endopi-* designs distributable as a coordinated
set.
