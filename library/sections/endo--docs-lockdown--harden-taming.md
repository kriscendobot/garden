---
title: __hardenTaming__ Options
source: docs/lockdown.md
source_repo: endojs/endo
source_commit: fe81477bf88b00775bf135ce6cb3a7123a296e3e
source_date: 2025-09-25
source_authors: [Kris Kowal]
ingested: 2026-05-13
ingested_by: scholar
topics: [hardened-javascript]
status: current
---

> Abstract: Makes harden() a no-op for performance in trusted environments where the cost of recursive freezing exceeds the safety value. Default: safe (harden actually freezes). Option: unsafe (harden becomes a no-op; significantly faster, significantly less safe). The double-underscore prefix marks this option as exceptional and dangerous-on-purpose.

## `__hardenTaming__` Options

The `__hardenTaming__` option to `lockdown`, with values `'safe'` (the default)
in which `harden` still works, and `'unsafe'`, in which `harden` is a do-nothing
identity function.

```js
lockdown(); // __hardenTaming__ defaults to 'safe'
// or
lockdown({ __hardenTaming__: 'safe' }); // harden works
// vs
lockdown({ __hardenTaming__: 'unsafe' }); // harden is noop. Other tests pretend
```

If `lockdown` does not receive a `__hardenTaming__` option, it will respect
`process.env.LOCKDOWN_HARDEN_TAMING`.

```console
LOCKDOWN_HARDEN_TAMING=safe
LOCKDOWN_HARDEN_TAMING=unsafe
```

We created this option specifically for
speed of the SwingSet kernel. It could also be used for other highly vetted, style
restricted, security-critical, and speed-critical code. This would be safe to turn
on in the SwingSet kernel or other such specialized code once we're confident that
they are free of the kinds of bugs that a working `harden` would have protected
them from.

There are various tests for whether something is frozen, sealed, non-extensible,
non-configurable, non-writable, that could all be broken by this fake `harden`.
However, in all cases in our non-test, non-demo code that we are aware of so far,
for each such branch, one side of the branch reports an error and only the other
side is the happy path. Once we're confident we have no bugs that `harden` would
have caught, then we need only ensure we go down the happy paths for such tests.

`Object.isFrozen`, `Object.isSealed`, `Object.isExtensible`, and
`Reflect.isExtensible` are patched to claim that everything is frozen, since that is
typically the happy path. But not always. For those rare occasions where not being
frozen is the happy path, we have added a `harden.isFake = true` property. When
this unsafe option is not turned on, there is no `isFake` property, so
`harden.isFake` is falsy. This lets code test `harden.isFake` to ensure it still
goes down the happy path.

We do not patch any of the builtins for reflecting on property
attributes, such as `Object.getOwnPropertyDescriptor`. When this creates a
problem, please use `harden.isFake` to adapt.

The "`__`" in the option name indicates that this option is temporary. XS now
has a fast native `harden`, but SwingSet currently runs on node/v8, which does
not. If node/v8 ever implements a fast native `harden`, we hope to deprecate
and eventually remove this option.

Source: [docs/lockdown.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/docs/lockdown.md) at commit `fe81477b`.
