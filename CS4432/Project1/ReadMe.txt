Megan Sin 
Student ID: 622101967

Section I:

- First input parameter, number of frames representing the buffer pool size, in program arguments in application configurations
- When prompted, with "The program is ready for the next command (GET, SET, PIN, UNPIN)," input a command in uppercase (i.e. SET) followed by its appropriate integer (i.e. record number following GET command)
- SET command will prompt for the new record:
- Input record in the following format without the quotation marks: "Fi-Recj, Namej, addressj, agej." (ex. F05-Rec450, Jane Do, 10 Hill Rd, age020.)
** Note: for i use two digits like 01, and for j use three digits like 001


Section II:

All commands in the test case were successful

BufferPool with size 3 initialized.
The program is ready for the next command (GET, SET, PIN, UNPIN)
SET 430
New record:
F05-Rec450, Jane Do, 10 Hill Rd, age020.
Brought file 5 from disk.
Placed in Frame 1
Write was successful
The program is ready for the next command (GET, SET, PIN, UNPIN)
GET 430
File 5 is already in memory.
Located in Frame 1
F05-Rec450, Jane Do, 10 Hill Rd, age020.
The program is ready for the next command (GET, SET, PIN, UNPIN)
GET 20
Brought file 1 from disk.
Placed in Frame 2
F01-Rec020, Name020, address020, age020.
The program is ready for the next command (GET, SET, PIN, UNPIN)
SET 430
New record:
F05-Rec450, John Do, 23 Lake Ln, age056.
File 5 is already in memory.
Located in Frame 1
Write was successful
The program is ready for the next command (GET, SET, PIN, UNPIN)
PIN 5
File 5 is already in memory.
Located in Frame 1
File 5 pinned in Frame 1
Not already pinned
The program is ready for the next command (GET, SET, PIN, UNPIN)
UNPIN 3
The corresponding file 3 cannot be unpinned because it is not in memory.
The program is ready for the next command (GET, SET, PIN, UNPIN)
GET 430
File 5 is already in memory.
Located in Frame 1
F05-Rec450, John Do, 23 Lake Ln, age056.
The program is ready for the next command (GET, SET, PIN, UNPIN)
PIN 5
File 5 is already in memory.
Located in Frame 1
File 5 pinned in Frame 1
Already pinned
The program is ready for the next command (GET, SET, PIN, UNPIN)
GET 646
Brought file 7 from disk.
Placed in Frame 3
F07-Rec646, Name646, address646, age646.
The program is ready for the next command (GET, SET, PIN, UNPIN)
PIN 3
Evicted file 1 from frame 2
Brought file 3 from disk.
Placed in Frame 2
File 3 pinned in Frame 2
Not already pinned
The program is ready for the next command (GET, SET, PIN, UNPIN)
SET 10
New record:
F01-Rec010, Tim Boe, 09 Deer Dr, age009.
Evicted file 7 from frame 3
Brought file 1 from disk.
Placed in Frame 3
Write was successful
The program is ready for the next command (GET, SET, PIN, UNPIN)
UNPIN 1
File 1 unpinned in frame 3
File already unpinned
The program is ready for the next command (GET, SET, PIN, UNPIN)
GET 355
Evicted file 1 from frame 3
Brought file 4 from disk.
Placed in Frame 3
F04-Rec355, Name355, address355, age355.
The program is ready for the next command (GET, SET, PIN, UNPIN)
PIN 2
Evicted file 4 from frame 3
Brought file 2 from disk.
Placed in Frame 3
File 2 pinned in Frame 3
Not already pinned
The program is ready for the next command (GET, SET, PIN, UNPIN)
GET 156
File 2 is already in memory.
Located in Frame 3
F02-Rec156, Name156, address156, age156.
The program is ready for the next command (GET, SET, PIN, UNPIN)
SET 10
New record:
F01-Rec010, No Work, 31 Hill St, age100.
Write was unsuccessful because block 1 is not in memory and the memory buffers are full.
The program is ready for the next command (GET, SET, PIN, UNPIN)
PIN 7
The corresponding block7 cannot be pinned because the memory buffers are full
The program is ready for the next command (GET, SET, PIN, UNPIN)
GET 10
The corresponding block 1 cannot be accessed from disk because the memory buffers are full
The program is ready for the next command (GET, SET, PIN, UNPIN)
UNPIN 3
File 3 unpinned in frame 2
File not already unpinned
The program is ready for the next command (GET, SET, PIN, UNPIN)
UNPIN 2
File 2 unpinned in frame 3
File not already unpinned
The program is ready for the next command (GET, SET, PIN, UNPIN)
GET 10
Evicted file 3 from frame 2
Brought file 1 from disk.
Placed in Frame 2
F01-Rec010, Name010, address010, age010.
The program is ready for the next command (GET, SET, PIN, UNPIN)
PIN 6
Evicted file 2 from frame 3
Brought file 6 from disk.
Placed in Frame 3
File 6 pinned in Frame 3
Not already pinned
The program is ready for the next command (GET, SET, PIN, UNPIN)

Section III:

- private int 'fileID' added to Frame class, variable keeps track of the file id the frame is located in 
- private int 'last' added to BufferPool class, variable keeps track of the index where a frame was last evicted
- setRecord() in Frame class assumes new record is different from old record, pinned boolean is updated appropriately
- getBlockID() in BufferPool class returns the frame number where specified file id exists (if it exists), otherwise returns -1
- *added method* setAndRead() in BufferPool class sets block id at frame i (inputted parameter 'i') to i and reads file at file id (inputted parameter 'file id')
- retrieveBlock() in BufferPool class will print out the contents of the retrieved record (if exists) and any actions taken (i.e. block did not already exist in the buffers array and was added to an empty frame); will also use setAndRead()
- getRID() and setRID() in BufferPool class calculates the fileID from the inputted rid (record id)
