![Meikadeh-icon](https://raw.githubusercontent.com/Aseman-Land/Meikade/master/configurations/ios/icons/Icon-Small%402x.png)

Meikade
=======

[![GitHub license](https://img.shields.io/github/license/Aseman-Land/Meikade?style=for-the-badge)](https://github.com/Aseman-Land/Meikade/blob/master/LICENSE)


Meikade is a collection of Persian poetry.
It's a cross-platform application which is avaiable on iOS, Android, Windows, macOS and Linux.
Meikade is built using C++ & Qt.

## ⚒️ How to Build

### Prerequisites

#### Build Environment & Dependencies

Before you start the build process, you have to install/resolve Meikade's dependencies like any other application.

In order to start the build process, you have to set up the environment for the respective platforms.

- 📱️ **Android**: install Android NDK and Android SDK.
- 🍎️ **iOS & macOS**: install XCode and XCode command-line tools.
- 🐧️ **Linux (esp. Ubuntu & other Debian-based distros)**: install gcc, g++ and make command.

And for all the above platforms you need to install git on them. So for example if you want to build it for Ubuntu, You need to setup your environment using the below command:

```bash
sudo apt-get install git g++ gcc
```

#### Qt
You can download and install Qt from their website [qt.io](). Also If you want to build Meikade on Ubuntu (or any other Debian-based distro), you could install Qt from the official repositories using the commands below:

```bash
sudo apt-get install qtbase5-dev qt5-default "qml-module-qt*"
```

#### QtAseman

Meikade is dependant on the QtAseman. So you can build it using the commands below:

```bash
git clone https://github.com/Aseman-Land/QtAseman.git
cd QtAseman
mkdir build && cd build
qmake -r ..
make
make install
```

And if you want to use our launchpad repository you can install [QtAseman](https://github.com/Aseman-Land/QtAseman) using the commands below:

```bash
sudo apt-add-repository ppa:aseman/qt-modules
sudo apt-get update
sudo apt-get install qt5aseman qt5aseman-dev
```

### Build Meikade

It's pretty easy to build meikade. Just clone and build it:

```bash
git clone https://github.com/Aseman-Land/Meikade.git
cd Meikade
mkdir build && cd build
qmake -r ..
make
```

and after building it, execute it from the build directory :)
