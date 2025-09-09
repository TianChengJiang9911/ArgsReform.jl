# ArgsReform

Since we have syntax like:

```julia
a, b..., c = 1:5 # a=1 ,b=[2,3,4], c=5
```

This pkg is aimed to expand this to 'named' variables / keyword arguments / NamedTuple.

## Import

```julia
import ArgsReform:@reform
```


## Usage examples

Variable assignment BY NAME

```julia
let
    @reform d, e = (e=2, d=1)... # d == 1, e == 2
end
let
    d, e = (e=2, d=1) # d == 2, e == 1
end
```

Packing & unpacking (& splitting)
```julia
let nt_1 = (a=1, b=2, c=3), nt_2 = (a=1, b=2, c=3)
    @reform a, c, nt_1... = nt_1... # a == 1, c == 3, nt_1 == (b=2,)
    @reform nt_2... = nt_2..., (d=4) # nt_2 == (a=1, b=2, c=3, d=4)
end
```

Over writing
```julia
let nt_1 = (a=1, b=2, c=3), nt_2 = (b=4, c=5, d=6)
    @reform b, c, nt_3... = nt_1..., nt_2... # b == 4, c == 5, nt_3 == (a=1, d=6) 
end
```


## 'Side' features

Single symbol (like :b) is converted to :(b=b)
```julia
let b=2
    @reform nt_1... = (a=1), b # nt_1 == (a=1, b=2)
end
```

A :_rest is created if there's no ... left of the @reform =
```julia
let nt_1 = (a=1, b=2, c=3)
    @reform a = nt_1... # a == 1, _rest == (b=2, c=3)
end
```