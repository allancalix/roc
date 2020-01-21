interface Float
    exposes [
        Float,
        fromNum,
        round,
        ceiling,
        floor,
        div,
        mod,
        recip,
        sqrt,
        highest,
        lowest,
        highestInt,
        lowestInt,
        sin,
        cos,
        tan,
        asin,
        acos,
        atan
    ]
    imports []

## Types

## A 64-bit floating-point number. All number literals with decimal points are #Float values.
##
## >>> 0.1
##
## >>> 1.0
##
## >>> 0.0
##
## If you like, you can put underscores in your #Float literals.
## They have no effect on the number's value, but can make things easier to read.
##
## >>> 1_000_000.000_000_001
##
## Unlike #Int values, #Float values are imprecise. A classic example of this imprecision:
##
## >>> 0.1 + 0.2
##
## Floating point values work this way because of some (very reasonable) hardware design decisions made in 1985, which are hardwired into all modern CPUs. The performance penalty for having things work any other way than this is severe, so Roc defaults to using the one with hardware support.
##
## It is possible to build fractional systems with different precision characteristics (for example, storing an #Int numerator and #Int denominator), but their basic arithmetic operations will be unavoidably slower than #Float.
##
## See #Float.highest and #Float.lowest for the highest and
## lowest values that can be held in a #Float.
##
## Like #Int, it's possible for #Float operations to overflow.
## if they exceed the bounds of #Float.highest and #Float.lowest. When this happens:
##
## * In a development build, you'll get an assertion failure.
## * In an optimized build, you'll get [`Infinity` or `-Infinity`](https://en.wikipedia.org/wiki/IEEE_754-1985#Positive_and_negative_infinity).
##
## Although some languages treat have first-class representations for
## `-Infinity`, `Infinity`, and the special `NaN` ("not a number")
## floating-point values described in the IEEE-754, Roc does not.
## Instead, Roc treats all of these as errors. If any Float operation
## in a development build encounters one of these values, it will
## result in an assertion failure.
##
## Stll, it's possible that these values may accidentally arise in
## release builds. If this happens, they will behave according to the usual
## IEEE-754 rules: any operation involving `NaN` will output `NaN`,
## any operation involving `Infinity` or `-Infinity` will output either
## `Infinity`, `-Infinity`, or `NaN`, and `NaN` is defined to be not
## equal to itself - meaning `(x == x)` returns `False` if `x` is `NaN`.
##
## These are very error-prone values, so if you see an assertion fail in
## developent because of one of them, take it seriously - and try to fix
## the code so that it can't come up in a release!
#FloatingPoint := FloatingPoint

## Returned in an #Err by #Float.sqrt when given a negative number.
#InvalidSqrt := InvalidSqrt

## Conversions

#fromNum : Num * -> Float

#round : Float -> Int
round = \num ->
    when num is
        0.0 -> 0
        _ -> 1

#ceiling : Float -> Int

#floor : Float -> Int

## Trigonometry

#cos : Float -> Float

#acos : Float -> Float

#sin : Float -> Float

#asin : Float -> Float

#tan : Float -> Float

#atan : Float -> Float

## Other Calculations (arithmetic?)

## Divide two #Float numbers.
##
## `a / b` is shorthand for `Float.div a b`.
##
## Division by zero is undefined in mathematics. As such, you should make
## sure never to pass zero as the denomaintor to this function!
##
## If zero does get passed as the denominator...
##
## * In a development build, you'll get an assertion failure.
## * In a release build, the function will return `Infinity`, `-Infinity`, or `NaN` depending on the arguments.
##
## To divide an #Int and a #Float, first convert the #Int to a #Float using one of the functions in this module.
##
## >>> 5.0 / 7.0
##
## >>> Float.div 5 7
##
## `Float.div` can be convenient in pipelines.
##
## >>> Float.pi
## >>>     |> Float.div 2.0
#div : Float, Float -> Result Float DivByZero
div = \numerator, denominator ->
    when numerator is
        0.0 -> 0.0 # TODO return Result!
        _ -> denominator

## Perform modulo on two #Float numbers.
##
## Modulo is the same as remainder when working with positive numbers,
## but if either number is negative, then modulo works differently.
##
## Return `Err DivByZero` if the second number is zero, because division by zero is undefined in mathematics.
##
## `a % b` is shorthand for `Float.mod a b`.
##
## >>> 5.0 % 7.0
##
## >>> Float.mod 5 7
##
## `Float.mod` can be convenient in pipelines.
##
## >>> Float.pi
## >>>     |> Float.mod 2.0
#mod : Float, Float -> Result Float DivByZero

## Return the reciprocal of the #Float.
#recip : Float -> Result Float [ DivByZero ]*
#recip = \float ->
#    1.0 / float

## Return an approximation of the absolute value of the square root of the #Float.
##
## Return #InvalidSqrt if given a negative number. The square root of a negative number is an irrational number, and #Float only supports rational numbers.
##
## >>> Float.sqrt 4.0
##
## >>> Float.sqrt 1.5
##
## >>> Float.sqrt 0.0
##
## >>> Float.sqrt -4.0
#sqrt : Float -> Result Float InvalidSqrt

## Constants

## An approximation of e, specifically 2.718281828459045.
#e : Float
e = 2.718281828459045

## An approximation of pi, specifically 3.141592653589793.
#pi : Float
pi = 3.141592653589793

## Limits

## The highest supported #Float value you can have, which is approximately 1.8 × 10^308.
##
## If you go higher than this, your running Roc code will crash - so be careful not to!
#highest : Float
highest : Num.Num Float.FloatingPoint
highest = 1.0

## The lowest supported #Float value you can have, which is approximately -1.8 × 10^308.
##
## If you go lower than this, your running Roc code will crash - so be careful not to!
#lowest : Float
lowest = 1.0

## The highest integer that can be represented as a #Float without # losing precision.
## It is equal to 2^53, which is approximately 9 × 10^15.
##
## Some integers higher than this can be represented, but they may lose precision. For example:
##
## >>> Float.highestInt
##
## >>> Float.highestInt + 100 # Increasing may lose precision
##
## >>> Float.highestInt - 100 # Decreasing is fine - but watch out for lowestLosslessInt!
#highestInt : Float
highestInt = 1.0

## The lowest integer that can be represented as a #Float without losing precision.
## It is equal to -2^53, which is approximately -9 × 10^15.
##
## Some integers lower than this can be represented, but they may lose precision. For example:
##
## >>> Float.lowestIntVal
##
## >>> Float.lowestIntVal - 100 # Decreasing may lose precision
##
## >>> Float.lowestIntVal + 100 # Increasing is fine - but watch out for highestInt!
#lowestInt : Float
lowestInt = 1.0
