---
title: Extensions — per-package translators, analyzers, and dependency introduction
source: README.md
source_repo: gutentags/system
source_commit: 91508059e8241a53bb029592a7f0700e37bba513
source_date: 2017-06-27
source_authors: [Kris Kowal]
ingested: 2026-07-06
ingested_by: scholar
topics: [module-loader, html-modules]
status: current
---

Abstract: System's extension mechanism is what translates non-JavaScript modules (like Guten Tag's HTML) to JavaScript, on the fly in the browser or in the `sysjs` build step, with the same plugins working in both. Extensions are configured with annotations in `package.json` (`"extensions": { "html": "gutentag/extension" }`) and **apply only within the scope of the packages that explicitly configure them**. An extension implements any combination of `analyze(module)` (populates `module.dependencies` with run-time references and may leave annotations for translate) and `translate(module)` (converts `module.text` from the language implied by `module.extension`, rewriting it to JavaScript and reassigning `module.extension` to `"js"`). Alterations to the `module` object are not preserved in `sysjs` build products, so they exist only to communicate with the module system. An analyzer may also `introduce` a package to one of its own dependencies — useful when generated code needs a library the host package does not directly depend on — because System enforces dependency relationships: a package not mentioned in `package.json` or expressly introduced cannot be loaded.

System supports plugins for translating modules to JavaScript, on the fly in the browser or in the `sysjs` build step. The same module loader plugins can work for both development and production, leaving little trace of the module system in the generated bundles.

Configure plugins with annotations in `package.json`. **Extensions only apply within the scope of the packages that explicitly configure them.** The following package uses the Guten Tag HTML to JavaScript extension.

```json
{
  "dependencies": {
    "gutentag": "^2.2.0"
  },
  "extensions": {
    "html": "gutentag/extension"
  },
  "redirects": {
    "./main.html": "./play.html"
  },
  "scripts": {
    "build": "sysjs index.js > bundle.js"
  }
}
```

Extensions are modules that implement any combination of `analyze` and `translate`.

The `analyze(module)` function takes the CommonJS module object and is responsible for populating `module.dependencies` with module references if the module depends on other modules at run-time. The analyzer may also leave annotations to the `module` object that the `translate` function will be able to use.

The `translate(module)` function takes the same CommonJS module object and is responsible for converting `module.text` from the language implied by its `module.extension`, rewrite that `module.text` to JavaScript, and reassign the `module.extension` to `"js"`.

The following extension converts a JSON document containing key-value pairs into a module that exports other modules.

```js
exports.analyze = function analyze(module) {
    module.model = JSON.parse(module.text);
    module.dependencies = Object.keys(module.model);
};

exports.translate = function translate(module) {
    module.text = module.dependencies.map(function (id) {
        return (
            "exports[" + JSON.stringify(module.model[id]) + "] = " +
            "require(" + JSON.stringify(id) + ");\n"
        );
    }).join("");
};
```

Alterations made by the translator and analyzer to the `module` object are not preserved in `sysjs` build products, so they should be used only to communicate with the module system.

Analyzers can also introduce a package to one of their own dependencies. This is useful if generated code needs to use a library that the host package does not directly depend upon. The System module loader enforces dependency relationships between packages. A package that is not mentioned in `package.json` or expressly introduced through the extension system cannot be loaded.

```js
var host = module.system;

exports.analyze = function (module) {
    host.introduce(module.system, "utility");
    module.dependencies.push("utility");
};

exports.translate = function (module) {
    module.text = "require(\"utility\")";
};
```

Source: [README.md](https://github.com/gutentags/system/blob/91508059e8241a53bb029592a7f0700e37bba513/README.md) at commit `9150805`.
