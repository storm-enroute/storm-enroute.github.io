---
layout: default
title: Styleguide
permalink: /styleguide/index.html
---


This document is a comprehensive Scala coding styleguide for Storm Enroute projects.


## Code structure

This section describes the preferred style for naming files and directories, contents and layout of the files.


### File naming rules

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


### Spacing rules

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


### ScalaDoc comments

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
