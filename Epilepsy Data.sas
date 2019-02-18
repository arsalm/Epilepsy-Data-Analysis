/* Arsal Munawar
   Project 2
   STAT 432      */

/* below is the epliepsy data. The first column is patient ID, the second column is 
   the treatment type, 0 for placebo and 1 for the drug, third column is age, fourth
   column is the baseline eight-week seizure count, the fifth through eigth columns
   are the seizure counts every two weeks for eight weeks total after medication. 
   "Onetwo" means the first two-week period.*/
data epdata;
	INPUT ID Treatment Age eightwk onetwo twotwo threetwo fourtwo;
datalines;
           1     0      31      11      5     3     3     3
           2     0      30      11      3     5     3     3
           3     0      25       6      2     4     0     5
           4     0      36       8      4     4     1     4
           5     0      22      66      7    18     9    21
           6     0      29      27      5     2     8     7
           7     0      31      12      6     4     0     2
           8     0      36      52     40    20    23    12
           9     0      37      23      5     6     6     5
          10     0      28      10     14    13     6     0
          11     0      36      52     26    12     6    22
          12     0      24      33     12     6     8     5
          13     0      28      18      4     4     6     2
          14     0      36      42      7     9    12    14
          15     0      26      87     16    24    10     9
          16     0      26      50     11     0     0     5
          17     0      28      18      0     0     3     3
          18     0      31     111     37    29    28    29
          19     0      32      18      3     5     2     5
          20     0      21      20      3     0     6     7
          21     0      29      12      3     4     3     4
          22     0      21       9      3     4     3     4
          23     0      32      17      2     3     3     5
          24     0      25      28      8    12     2     8
          25     0      30      55     18    24    76    25
          26     0      40       9      2     1     2     1
          27     0      19      10      3     1     4     2
          28     0      22      47     13    15    13    12
          29     1      18      76     11    14     9     8
          30     1      32      38      8     7     9     4
          31     1      20      19      0     4     3     0
          32     1      20      10      3     6     1     3
          33     1      18      19      2     6     7     4
          34     1      24      24      4     3     1     3
          35     1      30      31     22    17    19    16
          36     1      35      14      5     4     7     4
          37     1      57      11      2     4     0     4
          38     1      20      67      3     7     7     7
          39     1      22      41      4    18     2     5
          40     1      28       7      2     1     1     0
          41     1      23      22      0     2     4     0
          42     1      40      13      5     4     0     3
          43     1      43      46     11    14    25    15
          44     1      21      36     10     5     3     8
          45     1      35      38     19     7     6     7
          46     1      25       7      1     1     2     4
          47     1      26      36      6    10     8     8
          48     1      25      11      2     1     0     0
          49     1      22     151    102    65    72    63
          50     1      32      22      4     3     2     4
          51     1      25      42      8     6     5     7
          52     1      35      32      1     3     1     5
          53     1      21      56     18    11    28    13
          54     1      41      24      6     3     4     0
          55     1      32      16      3     5     4     3
          56     1      26      22      1    23    19     8
          57     1      21      25      2     3     0     1
          58     1      36      13      0     0     0     0
          59     1      37      12      1     4     3     2
/*proc import datafile = "C:\Users\arsalm1\Desktop\epilepsy.txt" dbms=csv out=epdata replace;
getnames=yes;
datarow=2;
run;*/

/*  ID   Treatment   Age    Period       Seizure-count
*   1       0        31     8-Wk           11
*   1       0        31     1st-2wk         5
*   1       0        31     2nd-2wk         3
*   1       0        31     3rd-2wk         3
*   1       0        31     4th-2wk         3
*   2       0        30     8-Wk           11
*   2       0        30     1st-2wk         3
*   2       0        30     2nd-2wk         5
*   2       0        30     3rd-2wk         3
*   2       0        30     4th-2wk         3    */

/* now the data is converted from short to long format */
data longepdata;
set epdata;

period = 1;             /* 8 week pre-preiod is '1' */
scount = eightwk;       /* scount = seizure count */
SPerWeek = scount/8;    /* SPerWeek is the seizure count per week */
OUTPUT;

period = 2;             /* 1st two week period is '2' */
scount = onetwo;
SPerWeek = scount/2;
OUTPUT;

period = 3;             /* 2nd two week period is '3' */
scount = twotwo;
SPerWeek = scount/2;
OUTPUT;

period = 4;             /* 3rd two week period is '4' */
scount = threetwo;
SPerWeek = scount/2;
OUTPUT;

period = 5;             /* 4th two week period is '5' */
scount = fourtwo;
SPerWeek = scount/2;
OUTPUT;

KEEP ID Treatment Age period scount SPerWeek;

proc reg data = longepdata;
	model SPerWeek = Treatment period / P;
	output out=Part15
		p = SPerWeekhat     /* display the predicted value of SPerWeek */
		r = SPerWeekresid;  /* display the residuals */
run;
quit;

data OrigPred;
set Part15;
OrigSPerWeek = SPerWeek;          /* this code simply creates a new table with relevant info */
PredSPerWeek = SPerWeekhat;
Residual = SPerWeekresid;
OUTPUT;
KEEP ID OrigSPerWeek PredSPerWeek Residual;
run;
quit;

data RSS;
set OrigPred;
RSquared =(Residual)**2;     */ calculates the (O-E)^2 for each value */
OUTPUT;
KEEP ID OrigSPerWeek PredSPerWeek Residual RSquared;
run;

proc print data = RSS;
	sum RSquared;  /* calculates the RSS and displays at bottom of table */
run;