.. highlight:: perl


****
NAME
****


timeclock.pl - a timeclock reporting utility


*****
USAGE
*****


timeclock.pl [options] [file]

Some examples:


.. code-block:: perl

     # Console output
     $ timeclock.pl timelog.bak
 
     # HTML output
     $ timeclock.pl --html > report.html
 
     # CSV output
     $ timeclock.pl --csv > report.csv



*******
OPTIONS
*******


Accepts excactly \ *one*\  of the folowing options:


\ **--help**\ 
 
 Print short usages information and exits.
 


\ **--man**\ 
 
 Displays the manual and exits.
 


\ **--version**\ 
 
 Displays the version number and copyright information and exits.
 


\ **--html**\ 
 
 Switches to HTML formatted output.
 


\ **--csv**\ 
 
 Switches to CSV formatted output.
 



***********
DESCRIPTION
***********


This is a simple reporting utility for timeclock, which is a time
tracking package for GNU Emacs.

You will use timeclock from GNU Emacs to \ *check in*\  and \ *check out*\ 
of projects during your workday.

Then at the end of the week you can run timeclock.pl to get a daily
report of your work time.


*************
CONFIGURATION
*************


If you haven't changed your Emacs/TimeClock setup, no configuration is
needed. The script will read your timelog file from the default
location which is ~/.timelog

If you have changed the location of the timelog file (I've placed mine
in a Dropbox folder), you can create the file ~/.timeclockrc and
define the location of the timelog file there. Example:


.. code-block:: perl

  $timelog = "$ENV{HOME}/Dropbox/timelog";


Emacs Integration
=================


You could add the following to you .emacs file to integrate
timeclock.pl into Emacs:


.. code-block:: perl

  (defun timeclock-show-daily-report()
    "Creates and displays a daily report of timeclock entries."
    (interactive)
    (let ((process-connection-type nil)   ; Use a pipe.
          (command-name "timeclock")
          (buffer-name "*timeclock daily report*")
          (script-name "timeclock.pl"))
      (when (get-buffer buffer-name)
        (progn
          (set-buffer buffer-name)
          (set-buffer-modified-p nil)
          (erase-buffer)))
      (set-buffer (get-buffer-create buffer-name))
      (start-process command-name buffer-name "perl" "-S" script-name)
      (switch-to-buffer buffer-name)))


And the use \ ``M-x timeclock-show-daily-report RET``\  to display the
report.



************
DEPENDENCIES
************



******
AUTHOR
******


Søren Lund, \ ``<soren at lund.org>``\ 


********
SEE ALSO
********


`App::TimeClock::ConsolePrinter <http://search.cpan.org/search?query=App%3a%3aTimeClock%3a%3aConsolePrinter&mode=module>`_,
`App::TimeClock::HtmlPrinter <http://search.cpan.org/search?query=App%3a%3aTimeClock%3a%3aHtmlPrinter&mode=module>`_,
`App::TimeClock::CsvPrinter <http://search.cpan.org/search?query=App%3a%3aTimeClock%3a%3aCsvPrinter&mode=module>`_,
`App::TimeClock::PrinterInterface <http://search.cpan.org/search?query=App%3a%3aTimeClock%3a%3aPrinterInterface&mode=module>`_

`http://www.gnu.org/software/emacs/ <http://www.gnu.org/software/emacs/>`_,
`http://www.emacswiki.org/emacs/TimeClock <http://www.emacswiki.org/emacs/TimeClock>`_


****
BUGS
****


Please report any bugs at
`https://github.com/soren/App-TimeClock/issues <https://github.com/soren/App-TimeClock/issues>`_.  I will be notified,
and then you'll automatically be notified of progress on your bug as I
make changes.


*********
COPYRIGHT
*********


Copyright (C) 2012-2018 Søren Lund

This file is part of App::TimeClock.

App::TimeClock is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

App::TimeClock is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with App::TimeClock.  If not, see <http://www.gnu.org/licenses/>.

