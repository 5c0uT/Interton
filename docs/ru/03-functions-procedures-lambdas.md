# Interton: функции, процедуры, лямбды

Целевая версия: `Interton beta-v_.6.2`

## 1. Зачем в Interton три вида callable

В пользовательском коде Interton удобно разделять логику на три слоя:

1. `pure call` - чистые вычисления без I/O и побочных эффектов,
2. `call` - прикладная логика, может вызывать другие функции и работать с состоянием,
3. `procedure` - оркестрация, вывод, системные действия.

Такой раздел помогает:

1. проще тестировать математику,
2. легче переносить код между проектами,
3. быстрее находить проблемы в runtime.

## 2. `call`: основной рабочий инструмент

`call` используется для функций с возвращаемым значением.

```interton
call add(x: int, y: int) -> int {
    return x + y
}

call main() -> int {
    int result = add(5, 7)
    inscribe("sum:", result)
    return 0
}
```

Ожидаемый вывод:

```text
sum: 12
```

Когда выбирать `call`:

1. когда функция не является строго чистой,
2. когда функция может обращаться к внешним данным,
3. когда нужно выразить бизнес-логику, а не только формулу.

## 3. `pure call`: детерминированная математика

`pure call` применяйте для функций, которые зависят только от входа.

```interton
adding std.io

pure call normalize(x: float, min: float, max: float) -> float {
    return (x - min) / (max - min)
}

call main() -> int {
    float n = normalize(25.0, 0.0, 100.0)
    inscribe("normalized:", n)
    return 0
}
```

Ожидаемый вывод:

```text
normalized: 0.25
```

Практика:

1. выносите в `pure call` расчеты и трансформации,
2. не делайте там `inscribe`, файловый ввод/вывод и FFI,
3. используйте `pure call` как фундамент для unit-style проверок.

## 4. `procedure`: явные побочные эффекты

`procedure` возвращает `void` и хорошо подходит для оркестрации.

```interton
adding std.io

procedure log_line(msg: string) -> void {
    inscribe("[log]", msg)
}

call main() -> int {
    log_line("pipeline started")
    log_line("pipeline finished")
    return 0
}
```

Ожидаемый вывод:

```text
[log] pipeline started
[log] pipeline finished
```

Когда выбирать `procedure`:

1. печать/логирование,
2. запуск последовательности шагов,
3. адаптерный слой между вычислениями и внешней средой.

## 5. Лямбды и функции высшего порядка

Interton поддерживает передачу функции как параметра.

```interton
adding std.io

call apply_twice(x: int, f: (int) -> int) -> int {
    return f(f(x))
}

call main() -> int {
    int plus = apply_twice(3, (n) -> n + 2)
    int square = apply_twice(2, (n) -> n * n)

    inscribe("plus:", plus)
    inscribe("square:", square)
    return 0
}
```

Ожидаемый вывод:

```text
plus: 7
square: 16
```

Паттерны:

1. лямбды удобны для коротких преобразований,
2. если логика длинная, выносите ее в именованную `call`,
3. сигнатуру callback держите максимально простой.

## 6. Практический шаблон композиции

Ниже - типовая схема: чистый расчет + сбор результата + вывод.

```interton
adding std.io

pure call score(cpu: float, quality: float) -> float {
    return cpu * 0.7 + quality * 0.3
}

call build_message(cpu: float, quality: float) -> string {
    float s = score(cpu, quality)
    return f"score={s}"
}

procedure print_message(cpu: float, quality: float) -> void {
    inscribe(build_message(cpu, quality))
}

call main() -> int {
    print_message(0.8, 1.0)
    return 0
}
```

Ожидаемый вывод:

```text
score=0.86
```

## 7. Контракт функции: что фиксировать в docs

Для каждой публичной функции проекта фиксируйте:

1. что ожидается на входе,
2. что возвращается и в каком формате,
3. как функция ведет себя на крайних значениях,
4. какие ошибки и ограничения известны,
5. есть ли зависимость от окружения (например FFI runtime).

## 8. Частые ошибки и как их избегать

1. Смешивать вычисления и I/O в одной функции.
Решение: разделяйте `pure call` и `procedure`.

2. Прятать сложную логику в анонимных лямбдах.
Решение: выносите в именованные `call`.

3. Называть параметры неинформативно (`a`, `b`, `tmp`).
Решение: называйте по смыслу (`raw_score`, `max_limit`).

4. Не документировать формат возврата.
Решение: в README модуля добавляйте короткую секцию "Input/Output".

## 9. Мини-чеклист качества

1. Вычислительная логика покрыта `pure call`.
2. Оркестрация вынесена в `procedure`.
3. Публичные `call` имеют понятные имена и контракты.
4. Примеры запуска содержат ожидаемый вывод.


