# Linchi

## Goals

Linchi is a small web server written in pure Swift and designed to run on Linux.
It is designed to be fast and easy to use, without burying what is actually 
happening behind too much abstraction.

Because Swift is not yet available for Linux, Linchi is a Mac app right now. This also gives us access
to a lot of great Xcode features like easy builds, unit testing, and code coverage.

## Contributing

There are still some issues that need to be fixed before Linchi becomes an acceptable web server.
If you see a TODO in the code that you think you can fix, don't hesitate! Everyone is welcome, and 
every contribution is highly appreciated 😊

Here are the main issues right now (this section will be regularly updated):
- The majority of the code is not tested
- HTTPServer doesn't handle connections asynchronously
- URLRouter is not yet implemented, which leaves us with an inefficient solution
- There is no limit to the length of the url or body of a request
- A few methods are not documented

Remember that you cannot use Foundation or any other proprietary framework. If you decide to use 
Foundation anyway, please add a TODO above the lines that depend on it so we remember to replace them later.

## Example

There is a very simple website included in the app that you can use to familiarise yourself with Linchi.

## Inspiration

Linchi started as a clone of Swifter but quickly diverged in significant ways. 
I also took some inspiration from the net/http package of golang.
