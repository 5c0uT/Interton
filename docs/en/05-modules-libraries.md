# Interton: modules, submodules, `adding` and `using` (extended guide)

Target version: `Interton beta-v_.6.2`

## 1. Why module structure matters

Interton modularity solves three core problems:

1. responsibility split,
2. reusability,
3. namespace control to avoid collisions.

Important: Interton has two distinct connection stages: `adding` and `using`.

## 2. `adding` vs `using` (exact behavior)

`adding`:

1. makes a module/namespace available,
2. can assign alias via `as`.

`using`:

1. controls short-name resolution in the current file,
2. for `mermaid.*` also enables Mermaid runtime configuration.

Short form:

1. `adding` = source availability,
2. `using` = name resolution/runtime mode.

## 3. `adding` forms

## 3.1 Standard module import

```interton
adding std.io
adding std.math.basic
```

## 3.2 Import with alias

```interton
adding std.math.basic as mb
```

Then you can access via `mb.*`.

## 3.3 Foreign function block

```interton
adding <cpp> cpp_scale(value: int, factor: int) -> int {
    return value * factor;
}
```

This is not a classic module, but it uses the same `adding` mechanism.

## 4. `using` forms

## 4.1 Alias mode

```interton
adding std.math.basic as mb
using mb;
```

Now `sum(...)`, `max(...)` resolve through `mb`.

## 4.2 Mermaid mode (with config)

```interton
using mermaid.struct;
using mermaid.cluster(1);
using mermaid.deep(retry=2 failover=true cache=true);
```

Or grouped:

```interton
using mermaid {
    struct,
    cluster(1),
    deep(retry=2 failover=true cache=true)
};
```

## 5. Example without `using` (fully-qualified names)

File: `examples/basic/module_using_alias_variants2.it`

```interton
adding std.io
adding std.math.basic

call main() -> int {
    float[] nums = [1, 2, 3, 4]
    inscribe("sum:", std.math.basic.sum(nums))
    inscribe("min:", std.math.basic.min(nums))
    inscribe("max:", std.math.basic.max(nums))
    inscribe("sorted:", std.math.basic.sorted(nums))
    return 0
}
```

Observed output:

```text
sum: 10
min: 1
max: 4
sorted: [1, 2, 3, 4]
```

Use this style when:

1. explicitness is critical,
2. many aliases are active,
3. code must be easy for new contributors.

## 6. Example with `using` (short names)

File: `examples/basic/module_alias_using.it`

```interton
adding std.io
adding std.math.basic as mb

using mb

call main() -> int {
    int[] data = [3, 1, 4, 1, 5]
    std.io.inscribe("sum:", sum(data))
    std.io.inscribe("sorted:", sorted(data))
    std.io.inscribe("max:", max(data))
    return 0
}
```

Observed output:

```text
sum: 14
sorted: [1, 1, 3, 4, 5]
max: 5
```

Best use cases:

1. frequent calls from one stack,
2. less visual noise.

## 7. Core stacks and submodules

## 7.1 `std.io`

1. `inscribe`,
2. `enter`/`input`.

## 7.2 `std.system.files`

1. `read_file`, `read_lines`,
2. `write_file`, `append_file`,
3. `read_json`, `write_json`,
4. `open_file`, `read_chunk`, `eof`, `close`.

## 7.3 `std.system.memory`

1. `used_bytes`,
2. `page_size`,
3. `gc_collect`.

## 7.4 `std.system.threads`

1. `sleep`,
2. `yield`,
3. `hardware_concurrency`.

## 7.5 `std.math.*`

1. `std.math` (base: `sqrt/pow/sin/cos/log/random`),
2. `std.math.basic`,
3. `std.math.statistics`,
4. `std.math.linear`,
5. `std.math.advanced`.

## 7.6 Domain stacks

1. `quantum.*`,
2. `interf.*`,
3. `interference.*`,
4. `rendering.ray.*`.

## 8. Mermaid as a special `using` case

For regular modules, `using` is only name resolution. For Mermaid, it also configures runtime behavior.

Validation example:

File: `examples/basic/mermaid_config_demo.it`

```interton
using mermaid {
    struct,
    cluster(1),
    deep(custom_rules)
};

call main() -> void {
    string cfg = mermaid_config_json();
    inscribe("mermaid_config:", cfg);
}
```

Observed output:

```text
mermaid_config: {"struct": true, "cluster_mode": 1, "cluster": true, "deep": true, "deep_force_no_cache": false, "deep_failover": true, "deep_retry_count": 0, "deep_config": "custom_rules"}
```

## 9. Name-collision control

Risk: same function names in multiple modules.

Practical rules:

1. avoid `using` for highly overlapping APIs,
2. keep full path where ambiguity is likely,
3. keep aliases limited to 1-2 active stacks per file.

## 10. Recommended import order

1. `adding std.*`,
2. `adding domain.*`,
3. `adding project.*`,
4. `using ...`.

Template:

```interton
adding std.io
adding std.math.basic as mb
adding quantum.core
adding modules.analytics as an

using mb
using an
```

## 11. Common beginner mistakes

1. `using` without matching `adding` for regular modules,
2. too many aliases in one file,
3. expecting `using` to auto-import module content,
4. mixing Mermaid profiles (`cluster(0)` and `cluster(1)`) without documenting why.

## 12. Validation checklist

1. every module is imported via `adding`,
2. `using` is used only where readability improves,
3. Mermaid profile is verified via `mermaid_config_json()`,
4. documented outputs match real runs.

