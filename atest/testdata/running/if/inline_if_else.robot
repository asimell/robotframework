*** Test Cases ***
IF passing
    IF    True    Log    reached this

IF failing
    [Documentation]    FAIL Inside IF
    IF    '1' == '1'   Fail    Inside IF

IF erroring
    [Documentation]    FAIL No keyword with name 'Oooops, I don't exist!' found.
    IF    '1' == '1'   Oooops, I don't exist!

Not executed
    [Documentation]    FAIL After IF
    IF    False    Not    run
    Fail    After IF

Not executed after failure
    [Documentation]    FAIL Before IF
    Fail    Before IF
    IF    True    Not    run    ELSE IF    True    Not run    ELSE    Not run

ELSE IF not executed
    [Documentation]    FAIL Expected failure
    IF    False    Not run    ELSE IF    False    Not    run    ELSE    Executed
    IF    1 > 0    Failure    ELSE IF    True    Not run        ELSE IF    True    Not run

ELSE IF executed
    [Documentation]    FAIL Expected failure
    IF    False    Not run    ELSE IF    True    Executed    ELSE    Not run
    IF                False    Not run
    ...    ELSE IF    False    Not run
    ...    ELSE IF    True     Failure
    ...    ELSE IF    False    Not run
    ...    ELSE                Not run

ELSE not executed
    [Documentation]    FAIL expected
    IF    1 > 0    Executed            ELSE    Not    run
    IF    1 > 0    Fail    expected    ELSE    Not run

ELSE executed
    [Documentation]    FAIL expected
    IF    0 > 1    Not run       ELSE    Log    does go through here
    IF    0 > 1    Not    run    ELSE    Fail    expected

Assign
    ${x} =    IF    1    Convert to integer    1    ELSE IF    2    Convert to integer    2    ELSE    Convert to integer    3
    ${y} =    IF    0    Convert to integer    1    ELSE IF    2    Convert to integer    2    ELSE    Convert to integer    3
    ${z} =    IF    0    Convert to integer    1    ELSE IF    0    Convert to integer    2    ELSE    Convert to integer    3
    Should Be Equal    ${x}    ${1}
    Should Be Equal    ${y}    ${2}
    Should Be Equal    ${z}    ${3}

Multi assign
    ${x}   ${y}    ${z} =    IF    True    Create list    a    b    c    ELSE    Not run
    Should Be Equal    ${x}    a
    Should Be Equal    ${y}    b
    Should Be Equal    ${z}    c

List assign
    @{x} =    IF    True    Create list    a    b    c    ELSE    Not run
    Should Be True    ${x} == ['a', 'b', 'c']
    ${x}    @{y}    ${z} =    IF    False    Not run    ELSE    Create list    a    b    c
    Should Be Equal    ${x}    a
    Should Be True     ${y} == ['b']
    Should Be Equal    ${z}    c

Dict assign
    &{x} =    IF    False    Not run    ELSE    Create dictionary    a=1    b=2
    Should Be True    ${x} == {'a': '1', 'b': '2'}

Inside FOR
    [Documentation]    FAIL The end
    FOR    ${i}    IN    1    2    3
        IF    ${i} == 3    Fail    The end    ELSE    Log    ${i}
    END

Inside normal IF
    IF    ${True}
        Log   Hi
        IF    3==4    Fail    Should not be executed    ELSE    Log    Hello
        Log   Goodbye
    ELSE
        IF    True    Not run    ELSE    Not run
    END

In keyword
    [Documentation]    FAIL Expected failure
    Keyword with inline IFs

Invalid END after inline header
    [Documentation]    FAIL 'End' is a reserved keyword. It must be an upper case 'END' and follow an opening 'FOR' or 'IF' when used as a marker.
    IF    True    Log    reached this
        Log   this is a normal keyword call
    END

*** Keywords ***
Keyword with inline IFs
    ${x} =    IF    True    Convert to integer    42
    IF    ${x} == 0      Not run    ELSE IF    $x == 42    Executed    ELSE    Not    run
    IF                False    Not run
    ...    ELSE IF    False    Not run
    ...    ELSE IF    False    Not run
    ...    ELSE IF    True     Failure
    ...    ELSE IF    False    Not run
    ...    ELSE IF    False    Not run
    ...    ELSE                Not run

Executed
    No operation

Failure
    Fail    Expected failure
