# Interton: operators and expressions (detailed)

Target version: `Interton beta-v_.6.2`

This section documents operators with behavior aligned to parser/runtime implementation.

## 1. Operator map

Supported groups:

1. arithmetic: `+`, `-`, `*`, `/`, `%`, `%%`, `//`, `**`,
2. assignment: `=`, `+=`, `-=`, `*=`, `/=`, `%=`, `%%=`, `//=`, `**=`, `^=`,
3. comparisons: `==`, `!=`, `===`, `!==`, `<`, `<=`, `>`, `>=`, `<>`, `><`,
4. logic: `&&`, `||`, `!`,
5. bitwise: `&`, `|`, `^`, `~`, `<<`, `>>`,
6. range and pipeline: `..`, `|>`,
7. extra: `?` (ternary), `->`, `::`, `@measure`, `@entangle`, `@tensor`.

## 2. Critical detail about `<>` and `><`

They are not boolean comparators.

1. `a >< b` returns max(`a`, `b`).
2. `a <> b` returns min(`a`, `b`).

So they are value-select operators.

```interton
adding std.io

call main() -> int {
    int x = 8 >< 3
    int y = 8 <> 3
    float a = 2.5 >< 4.1
    float b = 2.5 <> 4.1

    inscribe("x:", x)
    inscribe("y:", y)
    inscribe("a:", a)
    inscribe("b:", b)
    return 0
}
```

Expected output:

```text
x: 8
y: 3
a: 4.1
b: 2.5
```

Important runtime nuance in `beta-v_.6.2`:

1. in `if (...)` and other logical contexts, `<>`/`><` results are interpreted with truthy/falsy rules,
2. assigning into `bool` currently keeps the numeric result, which is then interpreted logically when used in conditions.

```interton
adding std.io

call main() -> int {
    bool c = 8 >< 3
    bool d = 0 <> 3
    inscribe("c:", c, "d:", d)

    if (c) {
        inscribe("c_true")
    } else {
        inscribe("c_false")
    }

    if (d) {
        inscribe("d_true")
    } else {
        inscribe("d_false")
    }
    return 0
}
```

Expected output:

```text
c: 8 d: 0
c_true
d_false
```

## 3. Arithmetic

```interton
adding std.io

call main() -> int {
    int p = 2 ** 5
    int d = 17 // 3
    int m1 = 17 % 3
    int m2 = 17 %% 3
    float q = 7 / 2

    inscribe("pow:", p)
    inscribe("int_div:", d)
    inscribe("%:", m1)
    inscribe("%%:", m2)
    inscribe("div:", q)
    return 0
}
```

Expected output:

```text
pow: 32
int_div: 5
%: 2
%%: 2
div: 3.5
```

Notes:

1. `//` is integer division.
2. `**` is exponentiation.
3. `%` and `%%` are both accepted; numeric behavior is modulo.

## 4. Equality and strict checks

```interton
adding std.io

call main() -> int {
    inscribe("5 == 5:", 5 == 5)
    inscribe("5 != 7:", 5 != 7)
    inscribe("5 === 5:", 5 === 5)
    inscribe("5 !== 7:", 5 !== 7)
    inscribe("3 < 9:", 3 < 9)
    inscribe("3 >= 9:", 3 >= 9)
    return 0
}
```

Expected output:

```text
5 == 5: true
5 != 7: true
5 === 5: true
5 !== 7: true
3 < 9: true
3 >= 9: false
```

## 5. Logical operators

```interton
adding std.io

call main() -> int {
    bool a = true
    bool b = false
    inscribe("a && b:", a && b)
    inscribe("a || b:", a || b)
    inscribe("!a:", !a)
    return 0
}
```

Expected output:

```text
a && b: false
a || b: true
!a: false
```

## 6. Bitwise operators

```interton
adding std.io

call main() -> int {
    int a = 6
    int b = 3
    inscribe("a & b:", a & b)
    inscribe("a | b:", a | b)
    inscribe("a ^ b:", a ^ b)
    inscribe("a << 1:", a << 1)
    inscribe("a >> 1:", a >> 1)
    return 0
}
```

Expected output:

```text
a & b: 2
a | b: 7
a ^ b: 5
a << 1: 12
a >> 1: 3
```

## 7. Compound assignment

```interton
adding std.io

call main() -> int {
    int v = 10
    v += 2
    v *= 3
    v //= 4
    v **= 2
    v %= 5
    inscribe("v:", v)
    return 0
}
```

Expected output:

```text
v: 4
```

## 8. Ranges and indexing

```interton
adding std.io

call main() -> int {
    int[] arr = [10, 20, 30, 40, 50]
    inscribe("len:", |arr|)
    inscribe("first:", arr[0])
    inscribe("slice:", arr[1..3].to_string())
    return 0
}
```

Expected output:

```text
len: 5
first: 10
slice: [20, 30, 40]
```

## 9. Operator precedence (important)

From low to high priority:

1. assignments and `->`,
2. `||`,
3. `&&`,
4. `==`, `!=`, `===`, `!==`,
5. `<`, `<=`, `>`, `>=`, `<>`, `><`, `..`, `<<`, `>>`,
6. `+`, `-`,
7. `*`, `/`, `%`, `//`, `%%`, `|`,
8. `**`,
9. `|>`.

Practical rule:

1. use parentheses in long expressions even when precedence is known,
2. treat `<>` and `><` as min/max selectors,
3. do not mix arithmetic, bitwise, and logical ops in one line without grouping.

## 10. Typical mistakes

1. Expecting `<>` to return `bool`:
   It returns one operand (the minimum). Logical behavior appears only in condition contexts.
2. Mixing `%` and `%%` style in one codebase:
   Pick one convention.
3. Using `|` as logical OR:
   Logical OR is `||`; `|` is bitwise.

