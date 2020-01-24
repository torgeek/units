/// Physical values in programming languages
/// Author & copyright 2019: Dmitrii Kuznetsov
/// Licenses Apache/MIT
Class Speed.Base Extends %RegisteredObject
{

Property literal As %String;

Property value As %Double;

Property unitType As array Of %Integer;

Property unitBaseString As %String;

ClassMethod Run() As %Status
{
    set literal = "50 km/h"
    #; set s1 = ..ParseAll(literal)
    #; w s1

    set valueWithUnit = ##class(Speed.Base).%New()
    set valueWithUnit.literal = "10 km/h"

    w valueWithUnit.literal, !
    w valueWithUnit.Value() _" "_ valueWithUnit.unitBaseString, !
}

ClassMethod ParseAll(literal As %String) As Speed.Base
{
    w "Parse "_ literal, !
    set parsedList = $lfs(literal, " ")
    w "Speed: "_ $DOUBLE(literal), !
    w "Unit: "_ $PIECE(literal, " ", 2), !

    set literalValue = $PIECE(literal, " ", 1)
    set value = $DOUBLE(literalValue)
    w value, !

    set literalUnit = $PIECE(literal, " ", 2)
    set literalUnitNumerator = $PIECE(literalUnit, "/", 1)
    set literalUnitDenominator = $PIECE(literalUnit, "/", 2)
    w literalUnit, !
    w literalUnitNumerator, !
    w literalUnitDenominator, !
    set scale = $CASE($EXTRACT(literalUnitNumerator),
        "k": 3,
        "M": 6,
        "G": 9,
        "m": -3,
        "µ": -6,
        "n": -9,
        : 0
    )
    w 10 ** scale, !
    set value = value * (10 ** scale)
    w "in m: "_ value, !
    
    if (scale '= 0) set literalUnitNumerator = $EXTRACT(literalUnitNumerator, 2, *)
    w literalUnitNumerator, !
    
    
    set unit = { "m" : 0, "kg" : 0, "S" : 0, "A" : 0, "K" : 0, "mol": 0, "cd" : 0 }
    w unit.%ToJSON(), !
    set unitExp = $DOUBLE($PIECE(literalUnit, "^", 2))
    if (unitExp = 0) set unitExp = 1 
    #; set unitPoz = $CASE(literalUnitNumerator,
    #;     "m": "1",
    #;     "h": "2",
    #;     : -1
    #; )
    set unit(literalUnitNumerator) = unitExp
    w unitExp, !
    #; w unitPoz, !
    w unit.%ToJSON(), !

    set a = [1, -1, 0, 2, 0, 0, 0]
    set b = [1, -1, 0, 2, 0, 0, 0]
    #; zw a, b

    set unit = "J"
    set unitNorm = $case(unit,
        "J": "kg*m^2/s^2",
        "Pa": "kg/m*s^2",
        "W": "kg*m^2/s^3",
        : ""
    )
    w unitNorm, !

    set unitSI = $CASE(unit,
        "J": [2, 1, -2, 0, 0, 0, 0], // kg*m^2/s^2
        "Pa": [-1, 1, -2, 0, 0, 0, 0], // kg/m*s^2
        "W":  [2, 1, -3, 0, 0, 0, 0], // kg*m^2/s^3
        : []
    )
    w unitSI, !
    zw unitSI

    return literal
}

Method Value() As %Double
{
    if (..value = "") do ..Parse()
    return ..value
}

Method Unit() As %String
{
    if (..unitBaseString = "") do ..Parse()
    return ..unitBaseString
}

Method Parse() As %Status
{
    set literalValue = $PIECE(..literal, " ", 1)
    set value = $DOUBLE(literalValue)

    set literalUnit = $PIECE(..literal, " ", 2)
    set literalUnitNumerator = $PIECE(literalUnit, "/", 1)
    set literalUnitDenominator = $PIECE(literalUnit, "/", 2)

    set scale = ..Scale(literalUnitNumerator)
    set value = value * scale
    if (scale '= 1) set literalUnitNumerator = $EXTRACT(literalUnitNumerator, 2, *)

    set isExtraLiteral = ..ExtraSIConvert(literalUnitDenominator)
    if (isExtraLiteral '= literalUnitDenominator) {
        set literalScale = $PIECE(isExtraLiteral, " ", 1)
        set scale = $DOUBLE(literalScale)
        set value = value / scale

        set literalUnit = $PIECE(isExtraLiteral, " ", 2)
        set literalUnitDenominator = literalUnit
    }

    set ..unitBaseString = literalUnitNumerator _ "/" _ literalUnitDenominator
    set ..value = value
}

Method Scale(literalUnit) As %Integer
{
    set scale = $CASE($EXTRACT(literalUnit),
        "k": 3,
        "M": 6,
        "G": 9,
        "m": -3,
        "µ": -6,
        "n": -9,
        : 0
    )

    Return 10 ** scale
}

Method ExtraSIConvert(unit As %String) As %String
{
    set extraSIUnit = $case(unit,
        "h": "3660 s",
        "min": "60 s",
        : unit
    )
    Return extraSIUnit
}

ClassMethod Equals(unit1, unit2) As %Status
{
}

}
