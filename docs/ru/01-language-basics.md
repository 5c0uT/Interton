# Interton: базовый синтаксис языка

Целевая версия: `Interton beta-v_.6.2`

## 1. Базовая структура файла

Типичный пользовательский файл состоит из:

1. импортов `adding`,
2. опциональных `using`,
3. объявлений функций/классов,
4. входной точки `call main() -> int`.

```interton
adding std.io

call main() -> int {
    inscribe("start")
    return 0
}
```

Ожидаемый вывод:

```text
start
```

## 2. Импорт модулей

### 2.1 Обычный импорт

```interton
adding std.io
adding std.math.basic
```

### 2.2 Импорт с alias

```interton
adding std.math.basic as mb
using mb
```

Что делает `using` базово:

1. активирует ранее объявленный alias/режим использования в файле,
2. применяется после `adding`,
3. для специальных пространств (например `mermaid.*`) включает runtime-поведение, а не только сокращение имен.

### 2.3 Групповой импорт

```interton
adding std { io, system.files, system.memory, system.threads }
```

## 3. Типы данных

Основные типы пользовательского уровня:

- `int`
- `float`
- `bool`
- `string`
- `void`

Пример:

```interton
adding std.io

call main() -> int {
    int count = 3
    float ratio = 1.25
    bool ok = true
    string name = "interton"
    inscribe("hello:", name, "count:", count, "ratio:", ratio, "ok:", ok)
    return 0
}
```

Ожидаемый вывод:

```text
hello: interton count: 3 ratio: 1.25 ok: true
```

## 4. Массивы, срезы, кортежи

```interton
adding std.io

call main() -> int {
    int[] values = [10, 20, 30, 40, 50]
    inscribe("len:", |values|)
    inscribe("first:", values[0])
    inscribe("slice:", values[1..3].to_string())

    (int, string, bool) item = (7, "seven", true)
    inscribe(item.0, item.1, item.2)
    return 0
}
```

Ожидаемый вывод:

```text
len: 5
first: 10
slice: [20, 30, 40]
7 seven true
```

## 5. Optional-значения

```interton
adding std.io

call main() -> int {
    optional<int> maybe = none
    maybe = some(12)
    inscribe("value:", maybe.value)
    return 0
}
```

Ожидаемый вывод:

```text
value: 12
```

## 6. Строки и форматирование

Interton поддерживает обычные строки, raw-строки, f-строки и многострочные f-строки.

```interton
adding std.io

call main() -> int {
    string name = "Interton"
    int count = 3
    string msg = f"Hello {name}, count={count}"
    string raw = r"D:\\data\\file.txt"
    string multi = f"""Block:
{name}
{count + 1}
"""

    inscribe(msg)
    inscribe(raw)
    inscribe(multi)
    return 0
}
```

Ожидаемый вывод (пример):

```text
Hello Interton, count=3
D:\data\file.txt
Block:
Interton
4
```

## 7. Управляющие конструкции

```interton
adding std.io

call main() -> int {
    int total = 0
    for int i = 0; i < 5; i = i + 1 {
        total += i
    }

    int j = 0
    while j < 3 {
        inscribe("while:", j)
        j += 1
    }

    if total > 5 {
        inscribe("total is", total)
    } else {
        inscribe("small total")
    }

    return 0
}
```

Ожидаемый вывод:

```text
while: 0
while: 1
while: 2
total is 10
```

## 8. Алиасы типов

```interton
type Result = success(value) | error(message);
type MaybeString = ok(value) | none();
```

Практика: используйте type alias для публичных контрактов между модулями.

## 9. Минимальные правила качества кода

1. Один файл - одна зона ответственности.
2. Один сложный шаг вычисления - одна функция.
3. Импорты всегда в начале.
4. Стабильные имена переменных и функций.
5. Сначала понятность, потом уплотнение кода.


