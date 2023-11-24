THSTD(1)                    General Commands Manual                   THSTD(1)

NAME
       thstd 窶 Touhou background script tool

SYNOPSIS
       thstd [-V] [-d | -c -VERSION] [input [output]]

DESCRIPTION
       The  thstd utility performs various actions on background scripts.  The
       following commands are available:

       thstd -c version [input output]
               Compiles a stage script.

       thstd -d version [input [output]]
               Dumps a stage script.

       thstd -V
               Displays the program version.

EXIT STATUS
       The thstd utility exits with 0 on success, 1 on error.

SEE ALSO
       Project homepage: https://github.com/thpatch/thtk

SECURITY CONSIDERATIONS
       Invalid data may not be properly handled.  Do not operate on  untrusted
       files.

thtk                            April 24, 2023                        THSTD(1)
