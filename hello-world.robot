*** Settings ***
Documentation    Smallest possible suite: one test using only BuiltIn keywords.

*** Test Cases ***
Log Hello World
    [Documentation]    Writes a message to the log and report.
    Log    Hello World
