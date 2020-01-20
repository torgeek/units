/// Physical values in programming languages
/// Author & copyright 2019: Dmitrii Kuznetsov
/// Licenses Apache/MIT
Class Speed.Base Extends %RegisteredObject
{

Property literal As %String;

Property value As %Double;

Property unit As array Of %Integer;

ClassMethod Run() As %Status
{
    set literal = "50 km/h"
    set s1 = ..Parse(literal)
    w s1
}

ClassMethod Parse(literal As %String) As Speed.Base
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

    #; w a = b, !
    #; Write *27,*91,1,*59,1,*72
    #; Set $X = 0
    #; Set $Y = 0
    #; w "###", !
    #; Set $X = 0
    #; Set $Y = 0
    #; w "#1#", !
    #; set unit = $case(unit,
    #;     "J": "kg*m^2/s^2",
    #;     "Pa": "kg/m*s^2",
    #;     "W": "kg*m^2/s^3",
    #;     : " "
    #; )

    #; if unit = "J" { set unitSI = [2, 1, -2, 0, 0, 0, 0] } // kg*m^2/s^2
    #; elseif unit = "Pa" { set unitSI = [-1, 1, -2, 0, 0, 0, 0] } // kg/m*s^2
    #; elseif unit = "W":  { set unitSI = [2, 1, -3, 0, 0, 0, 0] } // kg*m^2/s^3

    return literal
}

ClassMethod setValue() As %Status
{
}

ClassMethod UnknownType() As %Status
{
}

ClassMethod Equals(unit1, unit2) As %Status
{
}

}
