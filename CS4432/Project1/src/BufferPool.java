import java.io.FileNotFoundException;
import java.io.IOException;

public class BufferPool{
    private Frame[] buffers;
    private int last = 0;

    public Frame[] getBuffers() {
        return buffers;
    }

    /**
     * sets buffer at index 'num' to frame 'frame'
     * @param num index in the buffer array desired to be set to a inputted frame
     * @param frame frame object desired to put into buffers array
     */
    public void setBuffers(int num, Frame frame) {
        this.buffers[num] = frame;
    }

    /**
     * retrieves the frame located at the index 'num' in thee buffers array
     * @param num index for desired frame
     * @return frame located at the specified index
     */
    public Frame getFrame(int num){
        return this.buffers[num];
    }

    /**
     * creates a new buffer object with an empty array of clean, unpinned frames of size "size"
     * @param size the size of the new empty array of frames
     */
    public void initialize(int size){
        this.buffers = new Frame[size];
        for(int i = 0; i<size; i++){
            Frame aFrame = new Frame();
            this.buffers[i] = aFrame;
        }
    }

    /**
     * retrieves the block id for a given file id
     * @param fileID desire file id
     * @return frame number where specified file id exists (if it exists), otherwise -1
     */
    public int getBlockID(int fileID){
        for (int i = 0; i<buffers.length; i++){
            if (buffers[i].getFileID()==fileID){
                return i;
            }
        }
        return -1;
    }

    /**
     * sets block id at frame i to i and reads file at inputted file id
     * @param i index of frame where block id is getting set
     * @param fileID file id being read
     * @throws FileNotFoundException
     */
    private void setAndRead(int i, int fileID) throws FileNotFoundException {
        buffers[i].setBlockID(i);
        buffers[i].readFile(fileID);
        System.out.println("Brought file " + fileID + " from disk.");
        System.out.println("Placed in Frame " + (i+1));
    }


    /**
     * returns the contents in the block for the specified file id
     * @param fileID file tying to retrieve contents for
     * @return prints out the contents of the retrieved record (if exists) and any actions taken (i.e. block did not already exist
     * in the buffers array and was added to an empty frame)
     * @throws IOException
     *  4 cases:
     *      * 1. block exists in the buffers --> record is retrieved
     *      * 2. block does not exist in the buffers but an empty frame exists, block is added to empty frame --> record is retrieved
     *      * 3. block does not exist in the buffers, empty frame also does not exist, however an unpinned block exists --> block replaces unpinned block and record is retrieved
     *      * 4. block does not exist in the buffers, empty frame does not exist, unpinned block also does not exist --> unable to get retrieve block
     */
    public int retrieveBlock(int fileID) throws IOException {
        int blockID = getBlockID(fileID);
        if (blockID == -1){
            for (int i = 0; i < buffers.length; i++){
                if (buffers[i].getBlockID() == -1){
                    //case 2
                    setAndRead(i, fileID);
                    return i;
                }
            }
            for (int i = last; i < buffers.length; i++){
                if (!buffers[i].isPinned()){
                    //case 3
                    if(buffers[i].isDirty()){
                        buffers[i].writeFile();
                    }
                    System.out.println("Evicted file " + buffers[i].getFileID() + " from frame " + (i+1));
                    setAndRead(i, fileID);
                    last = i+1;
                    return i;
                }


            }
            for (int i = 0; i < buffers.length; i++){
                if (!buffers[i].isPinned()){
                    //case 3
                    if(buffers[i].isDirty()){
                        buffers[i].writeFile();
                    }
                    System.out.println("Evicted file " + buffers[i].getFileID() + " from frame " + (i+1));
                    setAndRead(i, fileID);
                    last = i+1;
                    return i;
                }

            }

            //case 4
            return -1;
        }
        else {
            //case 1
            System.out.println("File "+ fileID + " is already in memory.");
            System.out.println("Located in Frame " + (blockID+1));
            return blockID;
        }
    }

    /**
     * retrieve/get the block for the given record id
     * @param rid record id trying to retrieve
     * @throws IOException
     */
    public void getRID (int rid) throws IOException {
        int fileID = rid / 100 + 1;
        int blockID = retrieveBlock(fileID);
        if (blockID != -1) {
            System.out.println(buffers[blockID].getRecord(rid));
        }
        else{
            System.out.println("The corresponding block " + fileID + " cannot be accessed from disk because the memory buffers are full");
        }
    }

    /**
     * set the record at the given record id 'rid' to the inputted record 'record'
     * @param rid record id for the record desired to change the contents of
     * @param record new record/content
     * @throws IOException
     */
    public void setRID(int rid, char[] record) throws IOException {
        int fileID = rid / 100 + 1;
        int blockID = retrieveBlock(fileID);
        if (blockID != -1){
            buffers[blockID].setRecord(rid, record);
            buffers[blockID].setDirty(true);
            System.out.println("Write was successful");
        }
        else{
            System.out.println("Write was unsuccessful because block " + fileID +" is not in memory and the memory buffers are full.");
        }
    }

    /**
     * pins the file at specified file id 'fileID'
     * @param fileID file id you want to pin
     * @throws IOException
     */
    public void pinFID(int fileID) throws IOException {
        int blockID = retrieveBlock(fileID);
        if(blockID != -1){
            //check if file was successfully added to buffer pool
            if(buffers[blockID].isPinned()){
                //check if file was already pinned
                System.out.println("File " + fileID + " pinned in Frame "+ (blockID+1));
                System.out.println("Already pinned");
            }
            else{
                buffers[blockID].setPinned(true);
                System.out.println("File " + fileID + " pinned in Frame "+ (blockID+1));
                System.out.println("Not already pinned");
            }
        }
        else{
            System.out.println("The corresponding block" + fileID + " cannot be pinned because the memory buffers are full");
        }
    }

    /**
     * unpins the file at specified file id 'fileID'
     * @param fileID file id you want to unpin
     */
    public void unpinFID(int fileID){
        int blockID = getBlockID(fileID);
        if(blockID != -1){
            if(buffers[blockID].isPinned()){
                buffers[blockID].setPinned(false);
                System.out.println("File " + fileID + " unpinned in frame "+ (blockID+1));
                System.out.println("File not already unpinned");
            }
            else{
                System.out.println("File " + fileID + " unpinned in frame "+ (blockID+1));
                System.out.println("File already unpinned");
            }
        }
        else{
            System.out.println("The corresponding file " + fileID + " cannot be unpinned because it is not in memory.");
        }
    }


}