# Interton: FFI and multilang integration

Target version: `Interton beta-v_.6.2`

## 1. What FFI means in Interton

FFI (Foreign Function Interface) lets your `.it` program call code from other languages.

Practical value:

1. reuse existing ecosystem libraries,
2. route tasks to best runtime/toolchain,
3. build polyglot pipelines behind one Interton entrypoint.

## 2. Commonly used languages

In user workflows, typical language bridges are:

1. `py`
2. `js`
3. `cpp`
4. `c`
5. `cs`
6. `j`
7. `ts`

Important: successful execution depends on external runtime/toolchain availability.

## 3. Basic FFI declaration pattern

```interton
adding <py> py_tokens(text: string) -> int[] {
    return [len(t) for t in text.split()]
}

adding <js> js_sum(values: int[]) -> int {
    return values.reduce((a, b) => a + b, 0);
}

adding <cpp> cpp_scale(value: int) -> int {
    return value * 2;
}
```

## 4. Full FFI call example

```interton
adding std.io

adding <py> py_tokens(text: string) -> int[] {
    return [len(t) for t in text.split()]
}

adding <js> js_sum(values: int[]) -> int {
    return values.reduce((a, b) => a + b, 0);
}

adding <cpp> cpp_scale(value: int) -> int {
    return value * 2;
}

call main() -> int {
    int[] tokens = py_tokens("foreign bridge")
    int total = js_sum(tokens)
    int out = cpp_scale(total)
    inscribe("foreign:", out)
    return 0
}
```

Expected output:

```text
foreign: 26
```

## 5. Recommended type scope for initial adoption

Start with:

1. `int`, `float`, `bool`, `string`,
2. `int[]`, `float[]`, `string[]`.

Rollout strategy:

1. validate scalar roundtrips first,
2. then add array payloads,
3. only then introduce more complex structures.

## 6. Reliable FFI workflow

1. Keep each foreign function small and focused.
2. Validate input before crossing language boundary.
3. Log key values after each foreign call.
4. Compare behavior in `--run` and `--run-compiled`.
5. Pin external runtime/compiler versions in project docs.

## 7. Typical failure causes

1. Type mismatch between Interton and foreign runtime.
2. Missing foreign runtime/toolchain.
3. Environment drift across OSes.
4. Non-deterministic/invalid upstream input.

Debug routine:

1. reduce to minimal reproducible case,
2. compare run modes,
3. inspect Mermaid status if retry/failover/cache policy is active.

## 8. Minimal FFI smoke example

```interton
adding std.io
adding <py> py_inc(x: int) -> int {
    return x + 1
}

call main() -> int {
    int v = py_inc(10)
    inscribe("py_inc:", v)
    return 0
}
```

Expected output:

```text
py_inc: 11
```

## 9. Production recommendations

1. Keep one smoke case per FFI module.
2. Validate at least one foreign path per platform in CI.
3. Use Mermaid retry/failover for unstable dependencies.
4. Keep dependency inventory next to integration module.
5. Never treat FFI as transparent: log input/output contracts.

## 10. Release mini-checklist

1. FFI smoke tests pass.
2. Input/output contracts are documented.
3. Runtime/toolchain versions are pinned.
4. Failures are diagnosable from logs.

