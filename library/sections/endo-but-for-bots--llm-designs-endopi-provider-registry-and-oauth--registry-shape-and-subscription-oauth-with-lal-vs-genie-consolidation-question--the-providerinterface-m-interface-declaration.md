---
section: registry-shape-and-subscription-oauth-with-lal-vs-genie-consolidation-question
source: endo-but-for-bots--llm-designs-endopi-provider-registry-and-oauth
topics: [agent-conventions]
status: current
title: The §ProviderInterface — M.interface declaration
parent: endo-but-for-bots--llm-designs-endopi-provider-registry-and-oauth--registry-shape-and-subscription-oauth-with-lal-vs-genie-consolidation-question
---

The §Provider registry §Design subsection shows the registry as an
`M.interface` declaration:

```js
const ProviderInterface = M.interface('Provider', {
  // Static metadata
  name: M.call().returns(M.string()),
  apiStyle: M.call().returns(M.string()), // 'openai' | 'anthropic' | 'google' | 'bedrock' | 'custom'
  authShape: M.call().returns(M.string()), // 'apiKey' | 'oauth' | 'vertex' | 'none'

  // Model discovery
  listModels: M.callWhen().returns(M.arrayOf(M.record())),

  // Completion
  complete: M.callWhen(M.record()).returns(M.record()),
  stream: M.callWhen(M.record()).returns(M.remotable('AsyncIterable')),
});
```

The §registry-as-interface-guard discipline uses Endo's native
@endo/patterns + @endo/exo machinery (cycles 118 + 127 et al.) to
declare the provider contract. Each provider registers as an exo
implementing the `ProviderInterface`. The §apiStyle + authShape
discriminators are *string sums* matching Pi's `pi-ai` taxonomy
(`'openai'|'anthropic'|'google'|'bedrock'|'custom'` for API style;
`'apiKey'|'oauth'|'vertex'|'none'` for auth shape).

Providers *register themselves at daemon start; new providers ship
as guest plugins per
[endopi-extension-package-manifest](endopi-extension-package-manifest.md)*.
The §extension-package-manifest sibling (still unindexed) is the
distribution surface; the §registry is the runtime surface they
register into.
