# Interton: standard library and built-ins reference

Target version: `Interton beta-v_.6.2`

## 1. How to use this file

This is a reference document:

1. what is available out of the box,
2. how to call it,
3. where to apply it,
4. what to validate in runtime.

For first-time learning: `00-quick-start.md` -> `01-language-basics.md`.

## 2. Built-ins: output/input

## 2.1 `inscribe(...)`

Purpose: prints all arguments on one line separated by spaces.

Example:

```interton
adding std.io

call main() -> int {
    inscribe("sum:", 2 + 3)
    return 0
}
```

Output:

```text
sum: 5
```

## 2.2 `enter(...)` and `input(...)`

Current behavior (`beta-v_.6.2`): runtime aliases.

1. both read one line from `stdin`,
2. both accept an optional prompt,
3. both return `string`.

Example:

```interton
adding std.io

call main() -> int {
    string name = enter("Name: ")
    string city = input("City: ")
    inscribe("name:", name)
    inscribe("city:", city)
    return 0
}
```

Session sample:

```text
Name: Alex
City: Kazan
name: Alex
city: Kazan
```

## 3. Built-ins: type conversions

Available core conversions:

1. `int(x)`,
2. `float(x)`,
3. `string(x)`,
4. `bool(x)`,
5. `to_string(x)`.

Example:

```interton
adding std.io

call main() -> int {
    int a = int("42")
    float b = float("3.5")
    string c = to_string(99)
    bool ok = bool(1)
    inscribe(a, b, c, ok)
    return 0
}
```

Output:

```text
42 3.5 99 true
```

## 4. Built-ins: optional and arrays

1. `some(value)` — create optional with value,
2. `new_array(size)` — create fixed-size array.

Example:

```interton
adding std.io

call main() -> int {
    var maybe = some(123)
    var arr = new_array(3)
    arr[0] = 10
    arr[1] = 20
    arr[2] = 30
    inscribe("maybe:", maybe)
    inscribe("arr0:", arr[0])
    return 0
}
```

Output:

```text
maybe: 123
arr0: 10
```

## 5. `std.system.files` (files and JSON)

Core functions:

1. `read_file(path)`,
2. `read_lines(path)`,
3. `write_file(path, data)`,
4. `append_file(path, data)`,
5. `read_json(path)`,
6. `write_json(path, obj)`,
7. `open_file(path, mode?)`.

Stream functions:

1. `read_chunk(stream, size?)`,
2. `eof(stream)`,
3. `close(stream)`.

Guideline:

1. small files -> `read_file/write_file`,
2. large files -> `open_file + read_chunk`,
3. always `close` stream handles.

## 6. `std.system.memory`

Available:

1. `used_bytes()`,
2. `page_size()`,
3. `gc_collect()`.

Use cases:

1. memory diagnostics,
2. load monitoring,
3. service-level reporting.

## 7. `std.system.threads`

Available:

1. `sleep(milliseconds)`,
2. `yield()`,
3. `hardware_concurrency()`.

Example:

```interton
adding std.io
adding std.system.threads

call main() -> int {
    inscribe("threads:", hardware_concurrency())
    return 0
}
```

Output sample:

```text
threads: <platform-dependent>
```

## 8. `std.math` and submodules

## 8.1 Base `std.math`

Common names:

1. `sqrt`, `pow`,
2. `sin`, `cos`,
3. `abs`, `log`,
4. `random`.

## 8.2 `std.math.basic`

Helpers:

1. `sum`, `min`, `max`,
2. `sorted`, `reversed`.

Validation example: `examples/basic/module_alias_using.it`

Observed output:

```text
sum: 14
sorted: [1, 1, 3, 4, 5]
max: 5
```

## 8.3 `std.math.statistics`

Typical names:

1. `mean`, `variance`, `standard_deviation`,
2. `median`, `mode`,
3. `correlation`, `probability`.

## 8.4 `std.math.linear`

Typical names:

1. `dot`, `cross`, `normalize`,
2. `transpose`, `determinant`, `rank`, `inverse`.

## 8.5 `std.math.advanced`

Typical names:

1. `derivative`,
2. `integral`,
3. `limit`.

## 9. Domain stacks quick map

## 9.1 Quantum

Frequent names:

1. `H`, `X`, `Y`, `Z`,
2. `Rx`, `Ry`, `Rz`,
3. `CNOT`, `CX`, `CZ`, `CRz`,
4. `measure`.

## 9.2 Interf

Namespaces:

1. `interf.math.*`,
2. `interf.wave.*`.

Runtime examples:

1. `interf.wave.interfere`,
2. `interf.wave.fourier_transform`,
3. `interf.math.mean`, `interf.math.variance`.

## 9.3 Interference

Namespaces:

1. `interference.light.*`,
2. `interference.sound.*`,
3. `interference.quantum.*`,
4. `interference.advanced.*` (alias-level remap to sub-functions).

## 9.4 Rendering

1. `rendering.ray.*`.

## 10. Mermaid runtime API

Available entry points:

1. `mermaid_config` / `mermaid.config`,
2. `mermaid_status` / `mermaid.status`,
3. `mermaid_config_json`,
4. `mermaid_status_json`.

First things to inspect:

1. `cluster_mode`,
2. `deep_retry_count`, `deep_failover`, `deep_force_no_cache`,
3. `cache_hits/cache_misses/failures/last_error`.

## 11. `get_tunnel_stats`

Aliases:

1. `get_tunnel_stats`,
2. `std.system.get_tunnel_stats`,
3. `tunnel.get_stats`.

Validation example: `examples/all_examples/14_tunnel_cache.it`

Observed output:

```text
mix: 2.28571 2.28571
tunnel stats: 1
```

## 12. Minimal release smoke set

1. `inscribe`,
2. `enter/input`,
3. type conversion calls,
4. `std.system.files` read/write,
5. `hardware_concurrency`,
6. one math example,
7. `mermaid_config_json`,
8. `get_tunnel_stats`,
9. one `interference` or `quantum` scenario.

