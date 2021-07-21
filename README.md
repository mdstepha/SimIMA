# SimIMA Installation/Setup and Requirements: 

## 1. Operating System: 
SimIMA was tested successfully in the following operating systems: 
- MacOS (Catalina, version:10.15.6) 
- Linux (Ubuntu, version:18.04)
- Windows 10
  - Please, see the section [Running SimIMA in Windows OS](#running-simima-in-windows-os) for further details. 

## 2. MATLAB Version 
This software was tested to work properly with R2019b and R2021a versions of matlab. However, it should work just fine in other versions too. 

## 3. Install TXL 
SimIMA uses Simone clone detector, which in turn, uses TXL. So, download and install TXL. 
Instructions for downloading and installing TXL can be found in its official website: 

        https://www.txl.ca/txl-download.html

To verify that TXL is installed successfully, execute the command 'txl' from terminal (if you are on Windows, use Cygwin terminal). This must output something like this: 

        TXL v10.7 (1.10.18) (c) 1988-2018 Queen's University at Kingston
        Usage:  txl [txloptions] [-o outputfile] inputfile [txlfile] [- progoptions]
        (for more information use txl -help)

## 4. Get Simone Working 
SimIMA uses Simone clone detector. To make sure Simone works as expected, navigate to SimIMA/ and execute the following commands. (If you are in Windows, execute these commands from Cygwin terminal.) 

        unzip Simone-2.0-Complete-Cygwin64-customized-for-SimIMA.zip
        cd Simone-2.0-Complete-Cygwin64-customized-for-SimIMA
        make 
        
## 5. Set MATLAB Path
To use SimIMA, you must add the path of SimIMA project directory to your matlab path permanenetly. Follow the following steps to add SimIMA project directory to your matlab path. 

        Home > Set Path > Add Folder... > Choose SimIMA project directory > Save 

## 6. Customize Simulink UI
SimIMA customizes the default Simulink UI by introducing SimIMA services in the **Tools** Menu and the **Context** menu. To trigger this customization, follow these steps. This needs to be done only once.
1. Open Matlab.
2. Navigate inside the SimIMA project directory. (Make sure the file sl_customization.m is in current directory)
3. run the following command in matlab command window. This will make an option "SimIMA: Suggest Complete Models" available in both the Tools menu and the context menu (mouse right click)

        sl_refresh_customizations 

## 7. MATLAB Toolbox Requirements
Make sure the following toolboxes are included in your MATLAB installation. 
- Mapping Toolbox 


<br><br><br>
# Running SimIMA in Windows OS 
- SimIMA (SimXample, to be precise) uses Simone clone detector. 
- Simone is written using bash scripts which cannot be executed directly under Windows environment. However, Simone can still be run in Windows using *Cygwin*.
- Thus, if you want to run SimIMA on a Windows machine, you must install Cygwin (64 bit version). 
- Cygwin can be downloaded from the following website: 

      https://www.cygwin.com/ 

- The installation must be done in the following path, which is the default installation directory for Cygwin.

      C:\\cygwin64
  
- After you install Cygwin, make sure you have installed the following UNIX programs within it: 
  - make 
  - gcc 
  - unzip 


<br><br><br>
# Invoking SimIMA:
After loading a Simulink model in the Simulink window, SimIMA can be invoked by two ways: 
1. From the "Tools" menu. 
2. From the context menu i.e. mouse right click.

This will present you with 3 options: 
  - SimIMA: Suggest Blocks 
    - Choosing this option invokes SimGestion for Simulink block-level suggestions for the current modeling context.  
  - SimIMA: Suggest Complete Systems
    - Choosing this option invokes SimXample for complete Simulink (sub)system-level examples for the current modeling context.  
  - SimIMA: Configure Block Suggestions 
    - Choosing this option opens SimGestion suggestion configuration wizard.  

<br><br><br><br><br><br><br><br><br>
---
--- 
---
<P align="center"> The following sections serve as the project's documentation, and are intended for developers/maintainers only.  If you are interested only on using SimIMA (and not developing/maintaining it), you can safely skip these sections. </P> 
---
---
---

<br><br><br><br><br><br><br><br><br>

# A Note on Terminology
- The words "simima" and "simvma" occur interchangeably in this documentation and in the source code. The reason behind this is that initially we started the project under the name "simvma", but later decided that "simima" would be a better name. Since much of the code was already written using "simvma" term, we decided not to refactor it to "simima" in the code. However, we have changed the occurrances of the term "SimVMA" to "SimIMA" in UI related parts of the code. 

<br>

# Project Structure 
After you download/clone this project, it must have the following structure:

<pre>
SimIMA
├── .git
├── .gitignore
├── README.md
├── Simone-2.0-Complete-Cygwin64-customized-for-simvma.zip
├── default-repos/
│   ├── automotive/ 
│   ├── avionics/ 
│   ├── electroinics/ 
│   ├── energy/ 
│   ├── miscellaneous/ 
│   └── robotics/ 
├── devt/
├── getSimvmaPath.m
├── images/
├── initialize.m
├── shared-vars/
├── sl_customization.m
├── special-files/
├── src/
│   ├── apps/
│   │   ├── appSimgestion.mlapp
│   │   └── appSimxample.mlapp  
│   ├── classes/  
│   ├── functions/
│   │   └── devt/ 
│   └── special-files/
└── tmp/
    ├── *.mdl
    ├── simxample-slx2mdl-output/
    └── simxample-suggs/
</pre>

- **simvma/README.md** : 
  - This file contains the following information: 
    - SimIMA setup/installation instructions (for end users)
    - SimIMA project documentation (for developers/maintainers)
- **simvma/Simone-2.0-Complete-Cygwin64-customized-for-simvma.zip** : 
  - This file is Simone clone detector project. 
  - This particular zipped file contains Simone which has been customized for SimIMA. 
  - You must unzip this file in the same directory before you can use SimIMA (See instructions in README-for-user.md file). 
- **simvma/default-repos** : 
  - This folder contains Simulink model files categorized in 6 different repositories: automotive, avionics, electronics, energy, miscellaneous, and robotics. 
- **simvma/devt** : 
  - This folder contains some files useful only during deveopment time of this project such as test Simulink models and test scripts. 
  - These contents can be safely ignored/deleted by future developers/maintainers. 
- **simvma/getSimvmaPath.m** : 
  - This MATLAB function returns the absoulte path of this project. 
  - Unlike other functions, which are located in *simima/src/functions*, this function must be located here, that is, immediately inside simima project directory. This is because, when this function is first called (by *simima/initialize.m*), the path to *simima/src/functions* is not yet added to MATLAB path. 
- **simvma/images** : 
  - This folder contains image files. 
  - These image files are used to create SimIMA UI by the apps designed in AppDesigner. The source code of these apps is in *simima/src/apps*. 
- **simvma/initialize.m** : 
  - This MATLAB function takes care of various initialization jobs that must be done before calling SimIMA for suggestions. 
  - Unlike other functions, which are located in *simima/src/functions*, this function must be located here, that is, immediately inside simima project directory. This is because, when this function is first called (by *simima/sl_customization.m*), the path to *simima/src/functions* is not yet added to MATLAB path. 
- **simvma/shared-vars** : 
  - This folder contains various MATLAB variables used in the project, saved as .mat files. 
  - These variables are set and accessed using the functions *setSharedVar* and *getSharedVar* (both located inside *src/functions/*) respectively. 
  - These variables are created to serve one or both of the following purposes: 
    - To enable **data-passing** from one MATLAB function/app to another MATLAB function/app. Although data-passing between two functions is straightforward (can be accomplished using function arguments), passing arguments to and from apps (designed in App Designer) is not that easy. So, we use this workaround. 
    - To **preserve SimIMA's "state"** between multiple sessions. The state information of this application, such as which repositories are chosen by the user, what configurations are set by the user, etc. need to persist across sessions. Such state information is saved in the shared var simvma_appState.mat 
  - The use of each of these shared vars is presented below: 
    - **simvma_addedAnnotationTexts.mat** : 
      - This shared var stores which annotations (texts) are added to the Simulink workspace when populating the SimGestion suggestion panel. 
      - This information must be tracked so that these annotations can be properly deleted from the Simulink model afterwards. 
    - **simvma_appState.mat** : 
      - This shared var stores the configuration/state of SimIMA. 
      - This information must be tracked to persist user's changes to the default SimIMA configuration across sessions, and to communicate this information back-and-forth between functions (located in *src/functions/*) and apps (located in *src/apps/*). 
    - **simvma_armCache.mat** : 
      - This shared var stores the "cache" for training the ARM block-prediction model, to speed up training ARM model on previously "seen" Simulink model files. 
    - **simvma_armModel.mat** : 
      - This shared var stores the ARM block-prediction model, currently being used by SimIMA to generate block suggestions. 
      - This ARM model is formed by "combining" the ARM model trained on user-selected default repositories (stored in *simvma_armModelDef_xxxxxx.mat**) and the ARM model trained on user-added custom repositories (stored in *simvma_armModelCst.mat*). 
    - **simvma_armModelCst.mat**: 
      - This shared var stores the ARM block-prediction model trained on user-added custom repositories. 
    - **simvma_armModelDef_xxxxxx.mat**: 
      - This shared var stores the ARM block-prediction model trained on user-selected default repositories. 
      - The 6 x represent the default repos automotive, avionics, electronics, energy, robotics, and miscellaneous respectively. 
      - They take a value of either 1 or 0. 
      - x=1 means that this ARM model is trained on this particular default repository. 
      - x=0 means that this ARM model is NOT trained on this particular default repository.
    - **simvma_freqCache.mat** : 
      - This shared var stores the "cache" for training the FREQ block-prediction model, to speed up training FREQ model on previously "seen" Simulink model files. 
    - **simvma_freqModel.mat** : 
      - This shared var stores the FREQ block-prediction model, currently being used by SimIMA to generate block suggestions. 
      - This FREQ model is formed by "combining" the FREQ model trained on user-selected default repositories (stored in *simvma_freqModelDef_xxxxxx.mat**) and the FREQ model trained on user-added custom repositories (stored in *simvma_freqModelCst.mat*). 
    - **simvma_freqModelCst.mat**: 
      - This shared var stores the FREQ block-prediction model trained on user-added custom repositories. 
    - **simvma_freqModelDef_xxxxxx.mat**: 
      - This shared var stores the FREQ block-prediction model trained on user-selected default repositories. 
      - The 6 x represent the default repos automotive, avionics, electronics, energy, robotics, and miscellaneous respectively. 
      - They take a value of either 1 or 0. 
      - x=1 means that this FREQ model is trained on this particular default repository. 
      - x=0 means that this FREQ model is NOT trained on this particular default repository.
- **simvma/sl_customization.m** : 
  - This MATLAB function is necessary to customize Simulink UI with SimIMA menus. With this function in the current directory, if the user executes the command "sl_refresh_customizations" from the MATLAB command line, then the Simulink UI will be customized for SimIMA. Such customization needs to be done only once, that is, it persists across sessions. 
  - Unlike other functions, which are located in *simima/src/functions*, this function must be located here, that is, immediately inside simima project directory, so that, during SimIMA setup, the user can customize the UI right from this directory without having to navigate into *simima/src/functions*. 
- **simvma/special-files**:
  - This folder contains the following special files: 
    - **blank_r2012b.mdl**: 
      - This file is used as a "template" to create a custom input file for Simone. 
      - This file is saved in very old MATLAB version (R2012b) so that SimXample can work all versions not older than r2012b. Saving this file in a newer versions would make SimXample non-functional in older MATLAB installations. 
      - Note that, to overcome the nested-clone problem, we don't pass Model Under Development (MUD) as-it-is to Simone. We rather create a custom MUD for Simone such that the System Under Development (SUD) appears as the topmost system in this custom MUD. 
- **simvma/src**: 
  - This folder contains the source code of the project, organized in following folders: 
  - **simvma/src/apps**: 
    - This folder contains the following apps designed in App Designer. 
      - **appSimgestion.mlapp** : 
        - This file is the app for SimGestion configuration wizard UI.   
        - Note that, this file is NOT for SimGestion suggestion panel. This is because, unlike SimXample, the UI for SimGestion suggestion panel is NOT designed using App Designer, but is created using "sub-system" blocks inside the Simulink canvas itself. 
      - **appSimXample.mlapp** : 
        - This file is the app for SimXample UI. 
  - **simvma/src/classes**: 
    - This folder contains various class definitions used in the project. 
  - **simvma/src/functions**: 
    - This folder contains various function definitions used in the project. 
    - Functions inside *simvma/src/functions/devt/* are useful during SimIMA development/maintenance time only, that is, for the developer/maintainer. These functions are not needed for SimIMA to function for the end user. 
  - **simvma/src/special-files**: 
    - This folder contains some special files.
    - See comments inside each files for file-specific information. 
- **simvma/tmp**: 
  - This folder contains files that are created and destroyed often when SimIMA executes. 
  - It contains the following files/folders: 
    - **\*.mdl**: 
      - Temporary mdl files created during SimIMA's execution. 
      - These files are removed during each invocation of SimIMA (both SimXample and SimGestion) by the function initialize.m. 
    - **simvma/tmp/simxample-slx2mdl-output**: 
      - SimIMA user might be working on either MDL or SLX-formatted Simulink models. However, Simone (used by SimIMA) supports only MDL-formatted models. In case the user is working on SLX-formatted models, SimIMA first, as an intermediate step, saves the model as an MDL-formatted model in this directory so that Simone can use this MDL file as its input. 
   - **simvma/tmp/simxample-suggs**: 
     - This folder contains the Simulink model file (.mdl) and corresponding image files (.png) generated by SimXample. 
     - These files correspond to SimXample suggestions. 


<br><br><br>
# Changes made in Simone 
- We have made the following customizations to Simone to make it good for use with SimIMA: 
    - We have commented out the command-line-confirmation (yes/no) for the command 'cleanall' (see file: scripts/CleanAll) so that simone proceeds without any user-intervention.  
    - We have added the following line in 3 files (simonecross, scripts/CleanAll, scripts/NiCadCross). This adds the path of cygwin binaries for different UNIX utilities required by Simone. 

          export PATH=/cygdrive/c/cygwin64/bin:$PATH  # added by Bhisma to make Simone Windows-compatible using Cygwin

    - We have removed all configuration files inside config/, and added a new template configuration file 'config/template.cfg'. This file serves as the template to generate actual Simone configuration files for SimXample. During SimXample runtime, SimXample first checks if the required configuration file (simone10.cfg / simone20.cfg / simone30.cfg) exists or not, and generates it if needed. 