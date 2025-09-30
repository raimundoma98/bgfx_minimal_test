Minimal example on how to build a [bgfx]() project together with [GLFW]().

# How to build
This project uses [premake5]() for generating the project files. Executables of premake5 can be found under the ```tools/<plaform>/``` folder.

## Windows
Example on how to generate project files for Visual Studio 2022:
```.\tools\windows\premake5 vs2022```

## GNU Make
Alternatively, you can use the following command to generate the makefiles using gmake:
```.\tools\linux\premake5 gmake```

Then go to the ```build/gmake/``` folder and run ```make``` there to build the project.
