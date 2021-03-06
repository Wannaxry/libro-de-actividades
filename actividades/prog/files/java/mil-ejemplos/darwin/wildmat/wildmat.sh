#!/bin/sh
# This is a shell archive.  Remove anything before this line,
# then unpack it by saving it in a file and typing "sh file".
# If all goes well, you will see the message "No problems found."
# Wrapped by mirror!rs on Wed Nov 26 19:06:08 EST 1986

# Exit status; set to 1 on "wc" errors or if would overwrite.
STATUS=0
# Contents:  wildmat.c
 
echo x - wildmat.c
if test -f wildmat.c ; then
    echo wildmat.c exists, putting output in $$wildmat.c
    OUT=$$wildmat.c
    STATUS=1
else
    OUT=wildmat.c
fi
sed 's/^X//' > $OUT <<'@//E*O*F wildmat.c//'
X/*
X**  Do shell-style pattern matching for ?, \, [], and * characters.
X**  Might not be robust in face of malformed patterns; e.g., "foo[a-"
X**  could cause a segmentation violation.
X**
X**  Written by Rich $alz, mirror!rs, Wed Nov 26 19:03:17 EST 1986.
X*/

X#define TRUE		1
X#define FALSE		0


Xstatic int
XStar(s, p)
X    register char	*s;
X    register char	*p;
X{
X    while (wildmat(s, p) == FALSE)
X	if (*++s == '\0')
X	    return(FALSE);
X    return(TRUE);
X}


Xint
Xwildmat(s, p)
X    register char	*s;
X    register char	*p;
X{
X    register int 	 last;
X    register int 	 matched;
X    register int 	 reverse;

X    for ( ; *p; s++, p++)
X	switch (*p) {
X	    case '\\':
X		/* Literal match with following character; fall through. */
X		p++;
X	    default:
X		if (*s != *p)
X		    return(FALSE);
X		continue;
X	    case '?':
X		/* Match anything. */
X		if (*s == '\0')
X		    return(FALSE);
X		continue;
X	    case '*':
X		/* Trailing star matches everything. */
X		return(*++p ? Star(s, p) : TRUE);
X	    case '[':
X		/* [^....] means inverse character class. */
X		if (reverse = p[1] == '^')
X		    p++;
X		for (last = 0400, matched = FALSE; *++p && *p != ']'; last = *p)
X		    /* This next line requires a good C compiler. */
X		    if (*p == '-' ? *s <= *++p && *s >= last : *s == *p)
X			matched = TRUE;
X		if (matched == reverse)
X		    return(FALSE);
X		continue;
X	}

X    return(*s == '\0');
X}


X#ifdef	TEST
X#include <stdio.h>

Xextern char	*gets();


Xmain()
X{
X    char	 pattern[80];
X    char	 text[80];

X    while (TRUE) {
X	printf("Enter pattern:  ");
X	if (gets(pattern) == NULL)
X	    break;
X	while (TRUE) {
X	    printf("Enter text:  ");
X	    if (gets(text) == NULL)
X		exit(0);
X	    if (text[0] == '\0')
X		/* Blank line; go back and get a new pattern. */
X		break;
X	    printf("      %d\n", wildmat(text, pattern));
X	}
X    }
X    exit(0);
X}
X#endif	/* TEST */
@//E*O*F wildmat.c//
chmod u=rw,g=rw,o=rw $OUT
 
echo Inspecting for damage in transit...
temp=/tmp/sharin$$; dtemp=/tmp/sharout$$
trap "rm -f $temp $dtemp; exit" 0 1 2 3 15
cat > $temp <<\!!!
      95     281    1828 wildmat.c
!!!
wc  wildmat.c | sed 's=[^ ]*/==' | diff -b $temp - >$dtemp
if test -s $dtemp ; then
    echo "Ouch [diff of wc output]:"
    cat $dtemp
    STATUS=1
elif test $STATUS = 0 ; then
    echo "No problems found."
else
    echo "WARNING -- PROBLEMS WERE FOUND..."
fi
exit $STATUS
-- 
--
Rich $alz					"Hi, mom!"
Mirror Systems, Cambridge Massachusetts		rs@mirror.TMC.COM
{mit-eddie, ihnp4, wjh12, cca, cbosgd, seismo}!mirror!rs




