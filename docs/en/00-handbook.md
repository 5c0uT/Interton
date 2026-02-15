# Interton Handbook (EN)

Target version: `Interton beta-v_.6.2`

This file is the main narrative document. It is organized into **topic blocks** so you can read it linearly without bouncing between many pages.

If you need exact per-topic reference pages, use `en/README.md`.

---

## Block 1. Program Model (What A File Looks Like)

**Goal:** understand the minimum structure of an Interton program and what “adding/using/call main” mean.

**Key terms:**
- `adding` imports a namespace/module (or declares a foreign block).
- `using` controls short-name resolution (and for `mermaid.*` also configures runtime mode).
- `call main() -> int` is the user entrypoint.

Minimal program:

```interton
adding std.io

call main() -> int {
    inscribe("Hello, Interton")
    return 0
}
```

Run:

```bash
intertonc --run hello_world.it
```

Examples in repo:
- `examples/all_examples/00_basics_hello.it`
- `examples/basic/hello_world.it`

---

## Block 2. Core Types, Optional, Collections

**Goal:** use the core types and the common containers without surprises.

Core types:
- `int`, `float`, `bool`, `string`, `void`

Optional:
- `optional<T>` with `none` and `some(value)`

Collections:
- arrays: `T[]` (indexing: `arr[i]`, slicing: `arr[a..b]`)
- tuples: `(T1, T2, ...)` (access: `.0`, `.1`, ...)

Examples in repo:
- `examples/all_examples/01_types_optional.it`
- `examples/all_examples/02_arrays_tuples_ranges.it`

---

## Block 3. Control Flow

**Goal:** write loops and conditions in the real syntax used by examples/runtime.

Common forms:
- `if (...) { ... } else { ... }`
- `while cond { ... }`
- `for int i = 0; i < n; i = i + 1 { ... }`
- C-style update variant is also used in examples: `i += 1`

Examples in repo:
- `examples/all_examples/03_control_flow.it`
- `examples/basic/control_flow_showcase.it`

---

## Block 4. Operators (Semantics First)

**Goal:** know what operators *mean* (not just the list).

Important semantic detail:
- `a >< b` returns `max(a, b)` (value-select, not boolean)
- `a <> b` returns `min(a, b)` (value-select, not boolean)

When you see them in conditions (`if`, `&&`, `||`), the produced value is then interpreted via truthy/falsy rules.

Examples in repo:
- `examples/all_examples/08_operators_arithmetic.it`
- `examples/all_examples/09_operators_assignment.it`
- `examples/basic/operators_showcase.it`

Reference page:
- `en/02-operators.md`

---

## Block 5. Functions, Procedures, Lambdas

**Goal:** structure code into callables and understand “pure vs procedure”.

What you will meet in examples:
- functions: `call name(args...) -> Type { ... }`
- lambdas and callable values
- `procedure` blocks and “pipeline-like” composition patterns

Examples in repo:
- `examples/all_examples/04_functions_procedures.it`
- `examples/all_examples/05_lambdas.it`
- `examples/basic/pure_procedure_showcase.it`

Reference page:
- `en/03-functions-procedures-lambdas.md`

---

## Block 6. Classes / OOP

**Goal:** understand the class model used by examples (fields, methods, init/this).

Examples in repo:
- `examples/all_examples/07_classes_oop.it`
- `examples/basic/oop_showcase.it`
- `examples/basic/oop_methods_init_variants.it`

Reference page:
- `en/04-classes-oop.md`

---

## Block 7. Modules, Namespaces, `adding`, `using`

**Goal:** reliably import and control names without collisions.

Key rule:
- `adding` makes things available, `using` changes *how names resolve* in the current file.

Full path usage is valid and often preferred for clarity:
`std.system.files.read_file(...)`

Examples in repo:
- `examples/all_examples/19_modules_aliases.it`
- `examples/basic/module_alias_using.it`
- `examples/basic/module_using_alias_variants2.it`

Reference page:
- `en/05-modules-libraries.md`

---

## Block 8. FFI (Foreign Integration)

**Goal:** understand the “adding <lang> ...” surface and the JSON/file-based exchange that examples use.

Examples in repo:
- `examples/all_examples/24_foreign_integration.it`
- `examples/basic/multilang_integration.it`
- `examples/basic/foreign_pipeline.it`

Reference page:
- `en/06-ffi.md`

---

## Block 9. Metadata, Toning, Tunnel, Refocus

**Goal:** use advanced language/runtime mechanics as shown in examples, not as abstract theory.

Examples in repo:
- `examples/all_examples/12_toning.it`
- `examples/all_examples/13_refocus.it`
- `examples/all_examples/14_tunnel_cache.it`
- `examples/all_examples/15_metadata.it`
- `examples/all_examples/25_metadata_admin_core.it`

Reference page:
- `en/07-metadata-toning-tunnel-refocus.md`

---

## Block 10. Quantum / Interference / Ray

**Goal:** know where domain stacks live, and how to start exploring them.

Stacks:
- `quantum.*`
- `interference.*` and `interf.*` (interface/bridge style)
- `rendering.ray.*`

Examples in repo:
- quantum: `examples/all_examples/17_quantum.it`, `examples/all_examples/30_quantum_gates.it`, `examples/quantum/*`
- interference: `examples/all_examples/16_interference.it`, `examples/interference/*`
- ray: `examples/all_examples/23_ray_tracing_mini.it`, `examples/ray_tracing/*`

Reference page:
- `en/08-quantum-interference-ray.md`

---

## Block 11. CLI Run Modes (Interpreter vs Compiled Pipeline)

**Goal:** run the same program via `--run` and `--run-compiled` and understand when to use which.

Examples in repo:
- `examples/basic/compiled_pipeline_showcase.it`
- `examples/all_examples/all_in_one.it`

Reference page:
- `en/09-cli-run-modes.md`

---

## Block 12. Standard Library And Built-ins (Where To Look)

**Goal:** know where stdlib functions live and how to find the right module quickly.

Reference page:
- `en/11-standard-library-reference.md`

---

## Block 13. Mermaid (Runtime Profiles)

**Goal:** understand what `using mermaid.*` does today and what is planned/not implemented.

Reference page:
- `en/12-mermaid-guide.md`

