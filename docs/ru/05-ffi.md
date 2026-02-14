# Interton: FFI и мультиязычная интеграция

Целевая версия: `Interton beta-v_.6.1`

## 1. Что такое FFI в Interton

FFI (Foreign Function Interface) в Interton позволяет вызывать код других языков из `.it`-программы.

Практический смысл:

1. переиспользовать готовые библиотеки,
2. делегировать задачи в оптимальный runtime (Python/JS/C++/C#/и т.д.),
3. строить polyglot-пайплайн в одном запуске.

## 2. Какие языки обычно применяются

В пользовательских сценариях чаще всего используются:

1. `py`
2. `js`
3. `cpp`
4. `c`
5. `cs`
6. `j`
7. `ts`

Важно: успешный запуск зависит от установленного внешнего runtime/toolchain на машине.

## 3. Базовый шаблон FFI-объявления

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

## 4. Полный пример вызова FFI из `main`

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

Ожидаемый вывод:

```text
foreign: 26
```

## 5. Совместимые типы для старта

Начинайте с простых сигнатур:

1. `int`, `float`, `bool`, `string`,
2. `int[]`, `float[]`, `string[]`.

Рекомендация:

1. сначала убедитесь, что scalar-типы проходят стабильно,
2. потом добавляйте массивы,
3. сложные структуры вводите постепенно и покрывайте smoke-тестами.

## 6. Надежный FFI workflow

1. Делайте внешние функции маленькими и однозначными.
2. Валидируйте вход до FFI-вызова.
3. После каждого FFI-вызова печатайте диагностический маркер.
4. Проверяйте одинаковый результат в `--run` и `--run-compiled`.
5. Для релиза фиксируйте версии Python/Node/компилятора C++.

## 7. Типовые ошибки и как их диагностировать

1. Несовместимость типов между Interton и foreign-языком.
Признак: падение на этапе вызова или неожиданный формат результата.

2. Отсутствует внешний runtime/toolchain.
Признак: ошибка запуска foreign-команды.

3. Разное окружение на разных ОС.
Признак: на Windows работает, на Linux/macOS падает.

4. Нестабильные входные данные.
Признак: sporadic failures и плавающий результат.

Что делать:

1. уменьшите вход до минимального кейса,
2. сравните `--run` vs `--run-compiled`,
3. проверьте `mermaid.status_json()` при включенной Mermaid-конфигурации.

## 8. Пример “минимальный smoke для FFI-модуля”

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

Ожидаемый вывод:

```text
py_inc: 11
```

## 9. Production-рекомендации

1. На каждый FFI-модуль иметь отдельный smoke-файл.
2. В CI проверять минимум один foreign-вызов на платформу.
3. Для критичных цепочек включать Mermaid-политику retry/failover.
4. Фиксировать список внешних зависимостей рядом с модулем.
5. Никогда не считать FFI-слой "прозрачным": логируйте вход и выход.

## 10. Мини-чеклист перед релизом

1. FFI-функции проходят smoke.
2. Типы входа/выхода документированы.
3. Версии внешних runtime зафиксированы.
4. Ошибки воспроизводимы и понятны по логам.
