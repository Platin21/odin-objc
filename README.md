# Odin ObjC #

Complete bindings for the objc runtime library.
Each of these functions should be fully working.

### Notes ###

Procs that begin with objc_ have that addtional prefix removed as the package name itself is already objc. 

### Usage ###

On macOS no addtional library is required as the system.framework already includes the objc runtime library. 

For other systems (linux/bsd) you want to include the runtime library impl in order to make it work.

### What's next? ###

- Addition of usage examples (pure objc no external lib)
- Addtion of tests for each of the defined procs
- Addition of more complicated setups with external library's
- Making a generic class/protocol builder for odin
- Making a builder for blocks (unsure wether that is easy todo)

### Licence ### 

MIT 
