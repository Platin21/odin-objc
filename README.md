# Odin ObjC #

Complete bindings for the objc runtime library.
Each of these functions should be fully working.

### Notes ###

Procs that begin with objc_ have that addtional prefix removed as the package name itself is already objc. 

### Usage ###

On macOS no addtional library is required as the system.framework already includes the objc runtime library. 

For other systems (linux/bsd) you want to include the runtime library impl in order to make it work.

If that is done one can just include it like that:
```odin
  import "<Collection Name>:objc"
  import "shared:objc"
```

### What's next? ###

- Addition of usage examples (pure objc no external lib)
- Addtion of tests for each of the defined procs
- Addition of more complicated setups with external library's
- Making a generic class/protocol builder for odin
- Making a builder for blocks (unsure wether that is easy todo)
- Seperating the runtime functions in to there own files (not sure if that makes sense)

### Some rando build batches ###

[![volkswagen status](https://auchenberg.github.io/volkswagen/volkswargen_ci.svg?v=1)](https://github.com/auchenberg/volkswagen)

### Licence ### 

MIT 
