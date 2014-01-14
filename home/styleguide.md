---
layout: default
title: Styleguide
permalink: /styleguide/index.html
---


This document is a comprehensive Scala coding styleguide for Storm Enroute projects.


## File naming guidelines

Every source file can contain symbols of a single package `x.y.z`, and must be placed into a source code subdirectory `x/y/z`.

If the file is named with a upper case initial letter, then it may only contain a class and its companion object with the same name.

If the file is named with a lower case initial letter, then it may contain any number of related classes.

If the file is named `package.scala`, then it may only contain the package object for the related package `x.y.z`:

    package x.y
    
    package object z {
    }

A package object file may additionally declare a package statement for declarations that must be outside an object, for compiler-specific reasons.

    package z {
      class Z
      extends MustBeOutsideSingletonObject
    }

In specific occasions, a file may declare a different subpackage within its body, but this is to be avoided.


## Spacing and indentation guidelines

Every source file should have the following structure:

- start with an optional preamble with a license or the project banner and 1 empty line after it
- package name, unless in root package
- 3 empty lines
- imports
- 3 empty lines
- a sequence of top level object separated with 2 empty lines

This is a typical file containing a class declaration:

    /* Optional preamble
     */
    
    package org.styleguide
    
    
    
    import guidelines._
    
    
    
    class Example {
    }
    
    
    object Example {
      def apply() = new Example
    }


### Class declarations

A class declaration keyword and class name should go in one line.
They should be followed by the type parameters, early initialization list, list of arguments, list of superclasses and the class body.
If the superclasses cannot fit in the same line, they are placed in the next line:

    class MyMapper[T, S](f: T => S)
    extends LongNamedSuperClass
    with VeryLongNamedMixingTrait

If the argument list cannot fit on the same line, it should be placed in the next line and indented:

    class MyMapper[T, S]
      (f: T => S, logger: Logger, errorHandler: Exception => S)
    extends MapperBase


### Miscellaneous

Type ascriptions consist of a colon `:` followed by a space and the type:

    def id[T]: T => T = x => x

Operators in expressions should be delimited with a space.
This is bad: `1+1`,
but the following is good: `1 + 1`.
Keywords that are followed by a condition enclosed in parenthesis like `if` and `while` should be delimited with a space.
By contrast, method calls should not.
Avoid putting blocks of code or method bodies into a new line.
One liner methods are allowed

Here are some examples:

    var x: Int = 1
    val y = x + 1
    def loop() = while (x != y) {
      println(times2(x))
      x += 1
    }
    def times2(x: Int) = {
      x * 2
    }


## ScalaDoc comments

They begin with `/**` and end with `*/`.
In the case they are multiline, each line should start with a `*`.
First line of text should start with the first line of comment, to save vertical space.
The following descriptive lines should be separate by one blank line.
Parameter, type parameter and return annotations go in separate lines,
and their descriptions are aligned horizontally.
Multiline parameter descriptions are also aligned.
Descriptions start with an uppercase letter and end with a dot `.`.
Inline code and code segments have to be in standard markdown syntax.
Here is an example.

    /** This method is very important.
     *
     *  The long description in this line will not be
     *  shown in the ScalaDoc unless the user clicks on it.
     *
     *  Example:
     *
     *      mapForMe[Int, Int](x => x + 1)(11)
     *
     *  @tparam T           A type parameter that we need.
     *  @tparam S           Another type parameter that is hard
     *                      to understand and needs a long explanation.
     *  @param f            A function parameter.
     *  @param elem         This one is hard to explain. The element
     *                      will be used and applied in `f`.
     *  @return             Whatever the function returns.
     */
    def mapForMe[T, S](f: T => S)(elem: T): S = f(elem)



