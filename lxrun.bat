@echo off

rem #
rem #Performs administrative operations on the LX subsystem
rem #
rem #Usage:
rem #    /install - Installs the subsystem
rem #        Optional arguments:
rem #            /y - Do not prompt user to accept
rem #    /uninstall - Uninstalls the subsystem
rem #        Optional arguments:
rem #            /full - Perform a full uninstall
rem #            /y - Do not prompt user to accept
rem #    /update - Updates the subsystem
rem #        Optional arguments:
rem #            /critical - Perform critical update. This option will close all running LX processes when the update completes.
rem #

rem C:\> lxrun /install /y
rem C:\> lxrun /uninstall /y
