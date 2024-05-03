# Food AI Brief

Have you ever found yourself looking inside your fridge trying to figure out what to eat? Our Food AI project aims to deal with this age-old issue with generative AI packaged in an easy-to-use yet feature-rich mobile application.

## Installation

Feel free to pick an integrated development environment (IDE) of your choosing, as many options widely available for mobile development should in theory work, but we would recommend one of the following, due to extensive support for mobile development and the inclusion of powerful mobile emulators: 

- Android Studio 

- IntelliJ IDEA  

The aforementioned IDEs were the ones used in the development of the Food AI Brief Project and functioned well. This installation guide will focus on IntelliJ IDEA on a Windows operating system. 

#### Installing Flutter + Dart: 

Flutter already has an amazing guide on how to install it, so I will guide the first couple of steps and then you just need to follow the instructions on the website. When downloading flutter, it will also download Dart along with it. 

- Firstly, go to this website:

 [https://docs.flutter.dev/get-started/install](https://docs.flutter.dev/get-started/install)

and select the Windows operating system. 

- Next, select Android and it should bring up a page with the title of “Start building Flutter Android apps on Windows”, simply follow these steps from now on until the installation is completed. There are a couple of different ways to install it, so you can pick which method best suits you. 
 
#### Installing IntelliJ IDEA: 

- Firstly, go to [https://www.jetbrains.com/idea/download/?section=windows](https://www.jetbrains.com/idea/download/?section=windows) and select the Windows platform (you may wish to select a different operating system such as macOS or Linux, but this guide is done using a Windows operating system, so it may change slightly). 

- Next, download the EXE from the website and once finished downloading, run the EXE, and follow the instructions it provides, once you get to this screenshot, please ensure you tick the box “Add bin folder to the PATH” under “Update PATH Variable (restart needed) as this is essential for running the code in a terminal. 

![Image Link](../assets/intellij-pic.png)
 

- You may select any of the other options as well that you feel like you would like, but they are not essential. Once you are happy simply continue with the setup wizard until the installation is finished. 

- Now you should be able to start IntelliJ IDEA for the first time. If you have any trouble setting up the installation, then feel free to also look at this website as it is the official download guide that everyone who used IntelliJ IDEA in our group used under the Standalone installation section 

 [https://www.jetbrains.com/help/idea/installation-guide.html#standalone](https://www.jetbrains.com/help/idea/installation-guide.html#standalone) 

- Once you see a window like in the screenshot below, click on plugins on the left of the application. 

![Image Link](../assets/intellij-home.png)

- Then click on marketplace and search for Flutter and click download once completed, then search for Dart and click download and this should finish off setting up the pre requirements for running the group’s code.

## Usage

Firstly, go to the git repository: 
 [https://projects.cs.nott.ac.uk/comp2002/2023-2024/team31_project](https://projects.cs.nott.ac.uk/comp2002/2023-2024/team31_project)  
and download the source code for or clone our project. 

- Next, open the project in IntelliJ IDEA. 

- Now open the terminal and run the following two commands: 

```
flutter pub get
```
```
flutter pub upgrade
```

- Then, click on “File” at the top left of the screen and select “Settings”, open up “Languages & Frameworks” and select “Dart”, where it says “Dart SDK Path” enter where you installed the dart SDK.  

- It should be located in the flutter folder: “flutter\bin\cache\dart-sdk” 

- After you have set the Dart SDK Path, ensure that “Enable Dart support for the project” is ticked like in the screenshot below.

![Image Link](../assets/sdk.png)  

- After, go to the top right of IntelliJ IDEA and where it says, “No device selected”, click on it and select “Chrome (Web)” and press start by clicking on the green arrow. 

## License

[MIT](https://choosealicense.com/licenses/mit/)