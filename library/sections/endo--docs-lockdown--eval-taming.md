---
title: evalTaming Options
source: docs/lockdown.md
source_repo: endojs/endo
source_commit: fe81477bf88b00775bf135ce6cb3a7123a296e3e
source_date: 2025-09-25
source_authors: [Kris Kowal]
ingested: 2026-05-13
ingested_by: scholar
topics: [hardened-javascript, compartments]
status: current
---

> Abstract: Controls eval() and the Function constructor in the start compartment after lockdown. Default: safe-eval (SES's safe evaluator). Options: unsafe-eval (preserve original; allows code injection); no-eval (disable both eval and Function entirely).

## `evalTaming` Options

This option only affects the start compartment!

To disallow `eval` in specific compartments, replace `eval` and the function
constructors in the compartment.

```js
const c = new Compartment()
c.globalThis.eval = c.globalThis.Function = function() {
  throw new TypeError();
};
```

**Background**: Every realm has an implicit initial compartment we call the "start compartment". Explicit compartments are made with the `Compartment` constructor.
For every compartment including the start compartment, there are evaluators `eval` and `Function`.
The default lockdown behavior isolates all of these evaluators.

Replacing the realm's initial evaluators is not necessary to ensure the
isolation of guest code because guest code must not run in the start compartment.
Although the code run in the start compartment is normally referred to as "trusted", we mean only that we assume it was not written maliciously. It may still be buggy, and it may be buggy in a way that is exploitable by malicious guest code. To limit the harm that such vulnerabilities can cause, the default (`'safe-eval'`) setting replaces the evaluators of the start compartment with their safe alternatives.

However, in the shim, only the exact `eval` function from the start compartment can be used to
perform direct eval, which runs in the lexical scope in which the direct eval syntax appears (the direct eval syntax is a special form rather than a function call).
The SES shim itself uses direct eval internally to construct an isolated
evaluator, so replacing the initial `eval` prevents any subsequent program
from using the same mechanism to isolate a guest program.

The `'unsafe-eval'` option for `evalTaming` leaves the original `eval` in place
for other isolation mechanisms like isolation code generators that work in
tandem with SES.
This option may be useful for web pages with an environment that allows `'unsafe-eval'`,
like a development-mode bundling systems that use `eval`
(for example, [`'eval-source-map'` in webpack](https://webpack.js.org/configuration/devtool/#devtool)).

In these cases, SES cannot be responsible for maintaining the isolation of
guest code. If you're going to use `eval`, [Trusted
Types](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy/trusted-types) may help maintain security.

The `'no-eval'` option emulates a Content Security Policy that disallows
`'unsafe-eval'` by replacing all evaluators with functions that throw an
exception.

```js
lockdown(); // evalTaming defaults to 'safe-eval'
// or
lockdown({ evalTaming: 'no-eval' }); // disallowing calling eval like there is a CSP limitation.
// vs

// Please use this option with caution.
// You may want to use Trusted Types or Content Security Policy with this option.
lockdown({ evalTaming: 'unsafe-eval' });
```

Also `'unsafe-eval'` and `no-eval` allow us to initialize SES when no direct eval is available.

**Background**: Hermes is a JavaScript engine that does not yet support direct `eval()` nor the `with` statement. Default option `'safe-eval'` evaluates the source using direct eval and multiple nested `with` statements to create a restricted scope chain that constructs the isolated evaluator. This leaves us with options `'unsafe-eval'` or `'no-eval'`.

Note: In the future when the Compartment global class is supported on Hermes after `lockdown`, attempting to evaluate a compartment will emit on Hermes `Uncaught SyntaxError: 2:5:invalid statement encountered` (referring to make-evaluate.js > evaluateFactory) if the `with` statement is still unsupported.

Once Hermes engine supports direct eval, the `SES_DIRECT_EVAL` error will not longer prevent SES initializing with `'safe-eval'`.
Currently there is an open feature request and open pull request targeting Static Hermes.

* <https://github.com/facebook/hermes/issues/957>
  * <https://github.com/facebook/hermes/pull/1515>

You can also test and verify `lockdown` completing on this change by [building and running](https://github.com/facebook/hermes/blob/static_h/doc/BuildingAndRunning.md) Static Hermes on the following fork for example:
<https://github.com/leotm/hermes/tree/ses-lockdown-test-static-hermes-compiler-vm>

Once Hermes engine supports direct eval and the `with` statement, `'safe-eval'` will work.
Currently there is an open feature request and open pull request targeting Static Hermes.

* <https://github.com/facebook/hermes/issues/1056>
  * <https://github.com/facebook/hermes/pull/1571>

There is also an open alternate idea to sandbox `Compartment` *without* the `with` statement.

* <https://github.com/endojs/endo/discussions/1944>

If `lockdown` does not receive an `evalTaming` option, it will respect
`process.env.LOCKDOWN_EVAL_TAMING`.

```console
LOCKDOWN_EVAL_TAMING=safe-eval
LOCKDOWN_EVAL_TAMING=no-eval
LOCKDOWN_EVAL_TAMING=unsafe-eval
```


Source: [docs/lockdown.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/docs/lockdown.md) at commit `fe81477b`.
