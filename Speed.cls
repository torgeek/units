/// Physical values in programming languages
/// Author & copyright 2019: Dmitrii Kuznetsov

Class Speed.Base Extends %RegisteredObject
{

Property value As %Numeric [ Required ];

ClassMethod Run() As %Status
{
    set literal = "50 km/h"
    set s1 = ..Parse(literal)
    #; w s1
}

ClassMethod Parse(literal As %String) As Speed.Base
{
    w "Parse "_ literal, !
    set parsedList = $lfs(literal, " ")
    w $DOUBLE(literal), !
    w parsedList, !
    set value = $DOUBLE(literal)
    w value, !
    set unit = $extract(literal, " ", 2)
    w unit, !
    set a = [1, -1, 0, 2, 0, 0, 0]
    set b = [1, -1, 0, 2, 0, 0, 0]
    zw a, b

    w a = b, !
    Write *27,*91,1,*59,1,*72
    Set $X = 0
    Set $Y = 0
    w "###", !
    Set $X = 0
    Set $Y = 0
    w "#1#", !
    #; set unit = $case(unit,
    #;     "J": "kg*m^2/s^2",
    #;     "Pa": "kg/m*s^2",
    #;     "W": "kg*m^2/s^3",
    #;     : " "
    #; )

    #; if unit = "J" { set unitSI = [2, 1, -2, 0, 0, 0, 0] } // kg*m^2/s^2
    #; elseif unit = "Pa" { set unitSI = [-1, 1, -2, 0, 0, 0, 0] } // kg/m*s^2
    #; elseif unit = "W":  { set unitSI = [2, 1, -3, 0, 0, 0, 0] } // kg*m^2/s^3


    do $case(unit,
        "m/s": ..setValue(),
        "km/s": ..setValue(),
        "mph": ..setValue(),
        "cm*s-1": ..setValue(),
        : ..UnknownType()
    )
    return speed
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
