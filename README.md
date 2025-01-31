# The lattice surgery tool
the goal of this repo is to provide a tool for research with 3d lattice surgery.
more specificlly, goals are :

develop an environment which makes it easy to develop heuristics to convert PyZX to lattice surgery automatically and do some kind of volume optimization

develop an environment for researchers trying to make 3d lattice surgery without relying on proprietary technology like SketchUp

see tqec tool repo for more context https://github.com/tqec/tqec


## Planning/general features :

CI/CD and general devops stuff

Focus is on enabling researchers to easily build 3D lattice surgery models.

It should be possible to place, rotate and connect blocks together.

It should validate the structure based on some rules (e.g., no overlaps, valid connections).

It should be able to export to a blockgraph file for integration with TQEC.

It should be easy to develop some heuristic code and load it into the tool so that a lots of people can quickly try their ideas.

### Todo
- create a simple Block Placement System
  - Add the five block presets (as predefined 3D meshes or instanced scenes)
  - Drag and snap on a grid by using GridMap (or maybe use custom coords)
- export to BlockGraph file 
  - define a fileformat for blockgraph files
- Add importer to visualize TQEC files in the tool
- Rule validation (e.g., constraints for 3D lattice surgery, could maybe be done with the tqec tool directly ? ie send request to a local server running the tqec tool, run code to see if it validate, return output to godot)

## Current ideas to try to do the PyXZ to lattice surgery conversion
I think this problem is not necesseraly NP-hard, as in, it should be possible to generate 3d shape from PyZX graphs, but the quality of those graphs (ie, it might need 10x more qubits than a human optimized structure) will be the hard part
- Wave function collapse : it's primarly used to procedurally generate 2d or 3d maps in video games and it might be useful here as there is ways to parallelize this algorithm. I don't expect the result from this to be good, but it should be a good exercise
- Use a constraint optimization solver tool like Google OR-Tools
- Custom heuristics <- this is what i think "will win" because the problem will need to be scalable
- algorithms involved adjacency lists could maybe be a good one
## Current ideas for volume optimization
it is unclear how likely it is to fall into a local minima/maxima, this might be an NP-hard problem that might be solved easier with a quantum computer
- heuristics on the 3d models -> create a sets of rules that hold true in all cases and slowly develop that ruleset
- using machine learning by using data generated from the use of this tool
- heuristics on the BlockGraph model directly
- some kind of quantum algorithm heuristics ran on a quantum computer ? it's supposed to be decent at solving graph coloring problems, maybe there's a way to make it work on a quantum computer.
