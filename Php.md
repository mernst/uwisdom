Contents:


use ini\_set ("memory\_limit", "32M") to change the memory
available to php to 32M.  Obviously other values can be
used as well.  There are similar settings for the time limit.
Look at 'php ini' for the full list of settings.

To open a stream (file resource) that corresponds to stdout (output to the
browser) in non-cli php (webserver app) use:
```
   $stdout = fopen ("php://output", "w"); 
```

To get the values of variables use the php superglobal variable $_REQUEST
(superglobals do not need to be declared with the global keyword).
$_REQUEST is an associative array that contains the values of each
input variable from a form or url.  It contains the contents of
$_GET, $_POST, and $