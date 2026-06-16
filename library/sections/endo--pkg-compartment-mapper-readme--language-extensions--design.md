---
title: Design
source: packages/compartment-mapper/README.md
source_repo: endojs/endo
source_commit: ee87476e0efcf8f6e412eec93eba5f3853ead6f3
source_date: 2024-12-15
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [bundles, compartments, tooling]
status: current
parent: endo--pkg-compartment-mapper-readme--language-extensions
---

Each workflow of the compartment mapper executes a portion of a sequence
of underlying internals.

* search ([search.js](./src/search.js)): Scan the parent directories of a given
  `moduleSpecifier` until successfully finding and reading a `package.json` for
  the containing application.
* map compartments from Node.js packages
  ([node-modules.js](./src/node-modules.js)): Find and gather all the
  `package.json` files for the application's transitive dependencies.
  Use these to construct a compartment map describing how to construct a
  `Compartment` for each application package and how to link the modules each
  exports in the compartments that import them.
* load compartments ([archive.js](./src/archive.js)): Using `compartment.load`,
  or implicitly through `compartment.import`, create a module graph for the
  application's entire working set.
  When creating an archive, this does not execute any of the modules.
  The compartment mapper uses the compartments and a special `importHook` that
  records the text of every module the main module needed.
* import modules ([import.js](./src/import.js),
  [import-archive.js](./src/import-archive.js)): Actually execute the working
  set.

Around this sequence, we can enter late or depart early to store or retrieve an
archive.
The compartment mapper provides workflows that use `read` and `write` hooks
when interacting with a filesystem or work with the archive bytes directly.

This diagram represents the the workflows of each of the public methods like
`importLocation`.
Each column of pipes `|` is a workflow from top to bottom.
Each asterisk `*` denotes a step that is taken by that workflow.
The dotted lines `.'. : '.'` indicate carrying an archive file from the end of
one workflow to the beginning of another, either as bytes or a location.

In the diagram, "powers" refer to globals and built-in modules that may provide
capabilities to a compartment graph.
For `writeArchive` and `makeArchive`, these may be provided but will be ignored
since the application does not execute.

```
                 loadLocation  writeArchive
             importLocation |  | makeArchive
                          | |  | |
                          | |  | |      parseArchive
                          | |  | |      | loadArchive
                          | |  | |      | | importArchive
                          | |  | |      | | |...
               search ->  * *  * *      | |'| . '
     map compartments ->  * *  * *   .'.| | |' : :
         read archive ->  |    | |  '   | * *  : :
       unpack archive ->  |    | |  :   * * *  : :
assemble compartments ->  *    * *  :       *  : : <- powers
    load compartments ->  *    * *  :       *  : :
       import modules ->  *    | |  :       *  : :
         pack archive ->       * *  '          : :
        write archive ->       * '.' <- data   : :
                               '..............'  : <- files
                                '...............'
```

Source: [packages/compartment-mapper/README.md](https://github.com/endojs/endo/blob/ee87476e0efcf8f6e412eec93eba5f3853ead6f3/packages/compartment-mapper/README.md) at commit `ee87476e`.
