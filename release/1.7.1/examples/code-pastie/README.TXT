This is a simple pastebin called Code Pastie.

BINARIES: pastie.cgi.windows
          pastie.cgi.linux
		  Rename to paste.cgi, pick the one that is server OS 
		  Change permissions to 755 on unix.. or what your host requires.

Works on a typical hosting account with cgi-bin (Cpanel, Plesk, etc)		  


INSTALLATION
-------------
1. Compile the pastie.pas file and you will get a CGI program.
   Compilation not needed if you downloaded binary.

2. The fpc.cfg file creates pastie.cgi. Change your paths in fpc.cfg to appropriate.
   If you don't use fpc.cfg then rename program to pastie.cgi

3. Upload pastie.cgi to your server in a cgi-bin subdirectory.

4. Upload htminc/ subdirectory to where pastie.cgi is located

5. Upload pastes/ subdirectory to where pastie.cgi is located

6. Change permissions on pastie.cgi to 755 or 777 depending on your server

7. Try program in your webbrowser:
   http://site.com/cgi-bin/code-pastie/pastie.cgi?p=main

HOW TO USE 
-----------
See instructions on the main page once you have program running