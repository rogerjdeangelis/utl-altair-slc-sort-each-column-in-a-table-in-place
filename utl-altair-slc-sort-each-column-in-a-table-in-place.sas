%let pgm=utl-altair-slc-sort-each-column-in-a-table-in-place;

%stop_submission;

Altair slc sort each column in a table in place

Too long to post here, see github
https://github.com/rogerjdeangelis/utl-altair-slc-sort-each-column-in-a-table-in-place

PROBLEM SORT COLUMNS

                 COLUMNS SORTED
                   IN PLACE

    INPUT           OUTPUT

   C1 C2 C3        C1 C2 C3

    8  7  2        2  1  2
    6  4  9        2  2  2
    2  1  8        3  3  2
    3  9  7        3  3  6
    2  2  2        6  4  6
    6  7  8        6  4  7
    9  3  6        6  4  8
    6  4  6        8  7  8
    3  3  2        8  7  9
    8  4  9        9  9  9

Not easily done with sql;

 CONTENTS

    1 slc proc r
    2 slc transpose sort

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/
data workx.slots;
    call streaminit(4);
    do spin=1 to 10;
        c1 = 1 + floor(9 * rand("Uniform"));
        c2 = 1 + floor(9 * rand("Uniform"));
        c3 = 1 + floor(9 * rand("Uniform"));
        output;
    end;
    drop spin;
run;

/*       _
/ |  ___| | ___   _ __  _ __ ___   ___   _ __
| | / __| |/ __| | `_ \| `__/ _ \ / __| | `__|
| | \__ \ | (__  | |_) | | | (_) | (__  | |
|_| |___/_|\___| | .__/|_|  \___/ \___| |_|
                 |_|
*/

options set=RHOME "C:\Progra~1\R\R-4.5.2\bin\r";
proc r;
 export data=workx.slots r=slots;
 submit;
  slots
  spun<-apply(slots,2,sort)
  spun
 endsubmit;
 import r=spun data=workx.spun;
run;

proc print data=workx.spun;
run;

/************************************/
/*     INPUT      |    OUTPUT       */
/*                |                 */
/*  Obs C1 C2 C3  |  Obs V1 V2 V3   */
/*                |                 */
/*   1   8  7  2  |    1  2  1  2   */
/*   2   6  4  9  |    2  2  2  2   */
/*   3   2  1  8  |    3  3  3  2   */
/*   4   3  9  7  |    4  3  3  6   */
/*   5   2  2  2  |    5  6  4  6   */
/*   6   6  7  8  |    6  6  4  7   */
/*   7   9  3  6  |    7  6  4  8   */
/*   8   6  4  6  |    8  8  7  8   */
/*   9   3  3  2  |    9  8  7  9   */
/*   10  8  4  9  |   10  9  9  9   */
/************************************/

/*___        _        _                                                            _
|___ \   ___| | ___  | |_ _ __ __ _ _ __  ___ _ __   ___  ___  ___  ___  ___  _ __| |_
  __) | / __| |/ __| | __| `__/ _` | `_ \/ __| `_ \ / _ \/ __|/ _ \/ __|/ _ \| `__| __|
 / __/  \__ \ | (__  | |_| | | (_| | | | \__ \ |_) | (_) \__ \  __/\__ \ (_) | |  | |_
|_____| |___/_|\___|  \__|_|  \__,_|_| |_|___/ .__/ \___/|___/\___||___/\___/|_|   \__|
                                             |_|
*/

proc transpose data=workx.slots out=workx.slotsXpo;
var c1-c3;
run;quit;

/**************************************************************************************************************************/
/*  Altair SLC                                                                                                            */
/*                                                                                                                        */
/* Obs    _NAME_    COL1    COL2    COL3    COL4    COL5    COL6    COL7    COL8    COL9    COL10                         */
/*                                                                                                                        */
/*  1       C1        8       6       2       3       2       6       9       6       3       8                           */
/*  2       C2        7       4       1       9       2       7       3       4       3       4                           */
/*  3       C3        2       9       8       7       2       8       6       6       2       9                           */
/**************************************************************************************************************************/

data slotsSrt;
  set workx.slotsXpo;
  call sortn(of col:);
run;quit;

proc transpose data=slotsSrt out=workx.srtsrt;
var col1-col10;
run;

proc print data=workx.srtsrt;;
run;quit;

/**************************************************************************************************************************/
/* Altair SLC                                                                                                             */
/*                                                                                                                        */
/* Obs    _NAME_    C1    C2    C3                                                                                        */
/*                                                                                                                        */
/*   1    COL1       2     1     2                                                                                        */
/*   2    COL2       2     2     2                                                                                        */
/*   3    COL3       3     3     2                                                                                        */
/*   4    COL4       3     3     6                                                                                        */
/*   5    COL5       6     4     6                                                                                        */
/*   6    COL6       6     4     7                                                                                        */
/*   7    COL7       6     4     8                                                                                        */
/*   8    COL8       8     7     8                                                                                        */
/*   9    COL9       8     7     9                                                                                        */
/*  10    COL10      9     9     9                                                                                        */
/**************************************************************************************************************************/

 /*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
