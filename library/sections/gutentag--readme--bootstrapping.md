---
title: Bootstrapping a Guten Tag application
source: README.md
source_repo: gutentags/gutentag
source_commit: 38cdebb355f9c09ffbc9b0dcc8bb13a9421dfc88
source_date: 2017-03-07
source_authors: [Kris Kowal]
ingested: 2026-07-06
ingested_by: scholar
topics: [html-modules, getting-started]
status: current
---

Abstract: Every Guten Tag application starts with an npm package plus local copies of the System module loader, Koerper (the virtual document), and Guten Tag. Tags require a loader that can translate HTML modules; System supports to-JavaScript translator modules and, in development, loads npm-installed modules without a build step (provided packages have no implicit `index.js` directories and are not deduped). A `package.json` `extensions` annotation maps `html`/`xml` to `gutentag/extension`. A boilerplate `index.html` boots via System's `boot.js`, and `index.js` creates a Koerper document, a root `Scope`, and the root component. For production, System's Bundle tool (Browserify-like) translates all HTML modules to JavaScript and emits a bundle via `npm run build`.

Every Guten Tag application starts with an npm package. You will need a
`package.json`. Use `npm init` to create one.

You will also need copies of the module system and Guten Tag installed locally.
Tags require a module system that can load these HTML modules. The System loader
supports to-JavaScript translator modules. During development, System supports
loading modules installed by npm without a build step, provided that the
packages are compatible (no support for directories with an implicit
`index.js`) and that the modules have not been deduped (with `npm dedupe`).

```
$ npm init
$ npm install --save system
$ npm install --save koerper
$ npm install --save gutentag
```

To enable the loader to load Guten Tag HTML or XML files, add an "extensions"
annotation to `package.json`.

```json
{
  "extensions": {
    "html": "gutentag/extension",
    "xml": "gutentag/extension"
  }
}
```

A Guten Tag application starts with a boilerplate `index.html`, suitable for
debugging locally with your favorite web server. Refreshing the page reloads all
modules without incurring a build step. You have the option of using this page
as a loading screen if your application takes a significant amount of time to
load; it also hosts your metadata and assets like icons and CSS themes.

```html
<!doctype html>
<html>
    <head>
    </head>
    <body>
        <script src="node_modules/system/boot.js" data-import="./index"></script>
    </body>
</html>
```

The HTML calls into the bootstrapping script which in turn loads the entry
module, `index.js`. This boilerplate module just creates a virtual document, a
root scope, and the root component.

```js
var Document = require("koerper");
var Scope = require("gutentag/scope");
var App = require("app.html");

var scope = new Scope();
var document = new Document(window.document.body);
var app = new App(document.documentElement, scope);
```

To bundle up your modules for production, System also provides a tool called
Bundle, that operates like Browserify and generates a bundle. Bundle translates
all of the HTML modules into JavaScript and bundles a very minimal module
system. You can add a build step to your package.json and run it with `npm run
build`.

```
{
  "scripts": {
    "build": "bundle index.js | uglifyjs > bundle.js"
  }
}
```

Source: [README.md](https://github.com/gutentags/gutentag/blob/38cdebb355f9c09ffbc9b0dcc8bb13a9421dfc88/README.md) at commit `38cdebb`.
